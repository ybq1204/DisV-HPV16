#!/usr/bin/sh
#################################################
#

##get the unmap sequence of human
hisat2 -p 16 -x humangenome -1 $1 -2 $2 -S mapped.sam --un-conc unmap.fastq
##alignment to HPV16wholegenome

hisat2 -p 16 -x HPV16wholegenome unmap.fastq -S detectHPV16.sam
##Sort
samtools view -bS detectHPV16.sam > dectectHPV16.bam
samtools sort dectectHPV16.bam -o dectectHPV16_sorted.bam
##make sure if the sample is HPV16 positive
stringtie dectectHPV16_sorted.bam -o dectectHPV16.gtf -p 16 -G HPV16wholegenome.gtf -A HPV16.tab -B -e
##if positive alignment to HPV16genome
[ -s dectectHPV16.gtf ] && echo 'The sample is HPV16-positive' && hisat2 -p 16 -x HPV16genome unmap.fastq -S detectHPV16gene.sam

##Sort
samtools view -bS detectHPV16gene.sam > dectectHPV16gene.bam
samtools sort dectectHPV16gene.bam -o dectectHPV16gene_sorted.bam
##detect HPV16 oncogenes
stringtie dectectHPV16gene_sorted.bam -o dectectHPV16gene.gtf -p 16 -G HPV16genome.gtf -A HPV16gene.tab -B -e
echo 'The result is in the HPV16genome.gtf'