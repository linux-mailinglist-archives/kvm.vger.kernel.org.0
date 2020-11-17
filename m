Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA42B68EF
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgKQPnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:43:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgKQPnD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:43:03 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFYEAX051202;
        Tue, 17 Nov 2020 10:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TjpqIpFT92oiZXjBwSIu2a2tuu65TkmNzn2630bO6eI=;
 b=Rj6hVulm7GSIZ38Sj+gCGw7GvZDT3mhVRUDDntHzAiATw/2qzHSehGnwBIqT6SI3HG2B
 13ixy7Gf0Npj4LgaOsNm8s/oNq43qa69qXr6evYOSmAZ46gRUdJpYzmONGQhpCdnNDNJ
 d3UEQWNBxNAhYZCpHrpVfZWLWLalnfnc8vnAtL3r0MXtBc3MloY6POT/YMm2o14IXsnT
 nls3FP1zNJS8W0fBAuOu/iBmKVVJnRzOLBpaPp/fBldw4bsdYZWIrBxRGXXqWTjdqjH5
 lE+OBhznmhmp1dchD2bY5TpZg5J9edGsLftYzqoW3Sr8nTBUljxEulrAoAn9ukO/KVwd rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vb0vnwxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:01 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHFYMtD051721;
        Tue, 17 Nov 2020 10:43:01 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vb0vnwx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:43:01 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFgPU8005805;
        Tue, 17 Nov 2020 15:42:58 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 34t6gh398p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:42:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFguAq60359156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:42:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 068DE4C046;
        Tue, 17 Nov 2020 15:42:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 533E64C044;
        Tue, 17 Nov 2020 15:42:55 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:42:55 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/5] s390x: sie: Add SIE to lib
Date:   Tue, 17 Nov 2020 10:42:14 -0500
Message-Id: <20201117154215.45855-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117154215.45855-1-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=1 clxscore=1015
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=836
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit adds the definition of the SIE control block struct and
the assembly to execute SIE and save/restore guest registers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm-offsets.c  |  13 +++
 lib/s390x/asm/arch_def.h |   7 ++
 lib/s390x/interrupt.c    |   7 ++
 lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
 s390x/cstart64.S         |  56 +++++++++++
 5 files changed, 280 insertions(+)
 create mode 100644 lib/s390x/sie.h

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 61d2658..1ebfc8f 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -10,6 +10,7 @@
 #include <libcflat.h>
 #include <kbuild.h>
 #include <asm/arch_def.h>
+#include <sie.h>
 
 int main(void)
 {
@@ -71,6 +72,18 @@ int main(void)
 	OFFSET(GEN_LC_ARS_SA, lowcore, ars_sa);
 	OFFSET(GEN_LC_CRS_SA, lowcore, crs_sa);
 	OFFSET(GEN_LC_PGM_INT_TDB, lowcore, pgm_int_tdb);
+	OFFSET(__SF_GPRS, stack_frame, gprs);
+	OFFSET(__SF_SIE_CONTROL, stack_frame, empty1[0]);
+	OFFSET(__SF_SIE_SAVEAREA, stack_frame, empty1[1]);
+	OFFSET(__SF_SIE_REASON, stack_frame, empty1[2]);
+	OFFSET(__SF_SIE_FLAGS, stack_frame, empty1[3]);
+	OFFSET(SIE_SAVEAREA_HOST_GRS, vm_save_area, host.grs[0]);
+	OFFSET(SIE_SAVEAREA_HOST_FPRS, vm_save_area, host.fprs[0]);
+	OFFSET(SIE_SAVEAREA_HOST_FPC, vm_save_area, host.fpc);
+	OFFSET(SIE_SAVEAREA_GUEST_GRS, vm_save_area, guest.grs[0]);
+	OFFSET(SIE_SAVEAREA_GUEST_FPRS, vm_save_area, guest.fprs[0]);
+	OFFSET(SIE_SAVEAREA_GUEST_FPC, vm_save_area, guest.fpc);
+
 
 	return 0;
 }
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index edc06ef..2cd3fc7 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -10,6 +10,13 @@
 #ifndef _ASM_S390X_ARCH_DEF_H_
 #define _ASM_S390X_ARCH_DEF_H_
 
+struct stack_frame {
+	unsigned long back_chain;
+	unsigned long empty1[5];
+	unsigned long gprs[10];
+	unsigned int  empty2[8];
+};
+
 struct psw {
 	uint64_t	mask;
 	uint64_t	addr;
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index a074505..4b9a640 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -13,6 +13,7 @@
 #include <asm/barrier.h>
 #include <sclp.h>
 #include <interrupt.h>
+#include <sie.h>
 
 static bool pgm_int_expected;
 static bool ext_int_expected;
@@ -59,6 +60,12 @@ void register_pgm_cleanup_func(void (*f)(void))
 
 static void fixup_pgm_int(void)
 {
+	/* If we have an error on SIE we directly move to sie_exit */
+	if (lc->pgm_old_psw.addr >= (uint64_t)&sie_entry &&
+	    lc->pgm_old_psw.addr <= (uint64_t)&sie_entry + 10) {
+		lc->pgm_old_psw.addr = (uint64_t)&sie_exit;
+	}
+
 	switch (lc->pgm_int_code) {
 	case PGM_INT_CODE_PRIVILEGED_OPERATION:
 		/* Normal operation is in supervisor state, so this exception
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
new file mode 100644
index 0000000..b00bdf4
--- /dev/null
+++ b/lib/s390x/sie.h
@@ -0,0 +1,197 @@
+#ifndef SIE_H
+#define SIE_H
+
+#define CPUSTAT_STOPPED    0x80000000
+#define CPUSTAT_WAIT       0x10000000
+#define CPUSTAT_ECALL_PEND 0x08000000
+#define CPUSTAT_STOP_INT   0x04000000
+#define CPUSTAT_IO_INT     0x02000000
+#define CPUSTAT_EXT_INT    0x01000000
+#define CPUSTAT_RUNNING    0x00800000
+#define CPUSTAT_RETAINED   0x00400000
+#define CPUSTAT_TIMING_SUB 0x00020000
+#define CPUSTAT_SIE_SUB    0x00010000
+#define CPUSTAT_RRF        0x00008000
+#define CPUSTAT_SLSV       0x00004000
+#define CPUSTAT_SLSR       0x00002000
+#define CPUSTAT_ZARCH      0x00000800
+#define CPUSTAT_MCDS       0x00000100
+#define CPUSTAT_KSS        0x00000200
+#define CPUSTAT_SM         0x00000080
+#define CPUSTAT_IBS        0x00000040
+#define CPUSTAT_GED2       0x00000010
+#define CPUSTAT_G          0x00000008
+#define CPUSTAT_GED        0x00000004
+#define CPUSTAT_J          0x00000002
+#define CPUSTAT_P          0x00000001
+
+struct kvm_s390_sie_block {
+	uint32_t 	cpuflags;		/* 0x0000 */
+	uint32_t : 1;			/* 0x0004 */
+	uint32_t 	prefix : 18;
+	uint32_t : 1;
+	uint32_t 	ibc : 12;
+	uint8_t		reserved08[4];		/* 0x0008 */
+#define PROG_IN_SIE (1<<0)
+	uint32_t	prog0c;			/* 0x000c */
+	uint8_t		reserved10[16];		/* 0x0010 */
+#define PROG_BLOCK_SIE	(1<<0)
+#define PROG_REQUEST	(1<<1)
+	uint32_t 	prog20;		/* 0x0020 */
+	uint8_t		reserved24[4];		/* 0x0024 */
+	uint64_t	cputm;			/* 0x0028 */
+	uint64_t	ckc;			/* 0x0030 */
+	uint64_t	epoch;			/* 0x0038 */
+	uint32_t	svcc;			/* 0x0040 */
+#define LCTL_CR0	0x8000
+#define LCTL_CR6	0x0200
+#define LCTL_CR9	0x0040
+#define LCTL_CR10	0x0020
+#define LCTL_CR11	0x0010
+#define LCTL_CR14	0x0002
+	uint16_t   	lctl;			/* 0x0044 */
+	int16_t		icpua;			/* 0x0046 */
+#define ICTL_OPEREXC	0x80000000
+#define ICTL_PINT	0x20000000
+#define ICTL_LPSW	0x00400000
+#define ICTL_STCTL	0x00040000
+#define ICTL_ISKE	0x00004000
+#define ICTL_SSKE	0x00002000
+#define ICTL_RRBE	0x00001000
+#define ICTL_TPROT	0x00000200
+	uint32_t	ictl;			/* 0x0048 */
+#define ECA_CEI		0x80000000
+#define ECA_IB		0x40000000
+#define ECA_SIGPI	0x10000000
+#define ECA_MVPGI	0x01000000
+#define ECA_AIV		0x00200000
+#define ECA_VX		0x00020000
+#define ECA_PROTEXCI	0x00002000
+#define ECA_APIE	0x00000008
+#define ECA_SII		0x00000001
+	uint32_t	eca;			/* 0x004c */
+#define ICPT_INST	0x04
+#define ICPT_PROGI	0x08
+#define ICPT_INSTPROGI	0x0C
+#define ICPT_EXTREQ	0x10
+#define ICPT_EXTINT	0x14
+#define ICPT_IOREQ	0x18
+#define ICPT_WAIT	0x1c
+#define ICPT_VALIDITY	0x20
+#define ICPT_STOP	0x28
+#define ICPT_OPEREXC	0x2C
+#define ICPT_PARTEXEC	0x38
+#define ICPT_IOINST	0x40
+#define ICPT_KSS	0x5c
+	uint8_t		icptcode;		/* 0x0050 */
+	uint8_t		icptstatus;		/* 0x0051 */
+	uint16_t	ihcpu;			/* 0x0052 */
+	uint8_t		reserved54[2];		/* 0x0054 */
+	uint16_t	ipa;			/* 0x0056 */
+	uint32_t	ipb;			/* 0x0058 */
+	uint32_t	scaoh;			/* 0x005c */
+#define FPF_BPBC 	0x20
+	uint8_t		fpf;			/* 0x0060 */
+#define ECB_GS		0x40
+#define ECB_TE		0x10
+#define ECB_SRSI	0x04
+#define ECB_HOSTPROTINT	0x02
+	uint8_t		ecb;			/* 0x0061 */
+#define ECB2_CMMA	0x80
+#define ECB2_IEP	0x20
+#define ECB2_PFMFI	0x08
+#define ECB2_ESCA	0x04
+	uint8_t    	ecb2;                   /* 0x0062 */
+#define ECB3_DEA 0x08
+#define ECB3_AES 0x04
+#define ECB3_RI  0x01
+	uint8_t    	ecb3;			/* 0x0063 */
+	uint32_t	scaol;			/* 0x0064 */
+	uint8_t		reserved68;		/* 0x0068 */
+	uint8_t    	epdx;			/* 0x0069 */
+	uint8_t    	reserved6a[2];		/* 0x006a */
+	uint32_t	todpr;			/* 0x006c */
+#define GISA_FORMAT1 0x00000001
+	uint32_t	gd;			/* 0x0070 */
+	uint8_t		reserved74[12];		/* 0x0074 */
+	uint64_t	mso;			/* 0x0080 */
+	uint64_t	msl;			/* 0x0088 */
+	struct psw	gpsw;			/* 0x0090 */
+	uint64_t	gg14;			/* 0x00a0 */
+	uint64_t	gg15;			/* 0x00a8 */
+	uint8_t		reservedb0[8];		/* 0x00b0 */
+#define HPID_KVM	0x4
+#define HPID_VSIE	0x5
+	uint8_t		hpid;			/* 0x00b8 */
+	uint8_t		reservedb9[11];		/* 0x00b9 */
+	uint16_t	extcpuaddr;		/* 0x00c4 */
+	uint16_t	eic;			/* 0x00c6 */
+	uint32_t	reservedc8;		/* 0x00c8 */
+	uint16_t	pgmilc;			/* 0x00cc */
+	uint16_t	iprcc;			/* 0x00ce */
+	uint32_t	dxc;			/* 0x00d0 */
+	uint16_t	mcn;			/* 0x00d4 */
+	uint8_t		perc;			/* 0x00d6 */
+	uint8_t		peratmid;		/* 0x00d7 */
+	uint64_t	peraddr;		/* 0x00d8 */
+	uint8_t		eai;			/* 0x00e0 */
+	uint8_t		peraid;			/* 0x00e1 */
+	uint8_t		oai;			/* 0x00e2 */
+	uint8_t		armid;			/* 0x00e3 */
+	uint8_t		reservede4[4];		/* 0x00e4 */
+	uint64_t	tecmc;			/* 0x00e8 */
+	uint8_t		reservedf0[12];		/* 0x00f0 */
+#define CRYCB_FORMAT_MASK 0x00000003
+#define CRYCB_FORMAT0 0x00000000
+#define CRYCB_FORMAT1 0x00000001
+#define CRYCB_FORMAT2 0x00000003
+	uint32_t	crycbd;			/* 0x00fc */
+	uint64_t	gcr[16];		/* 0x0100 */
+	uint64_t	gbea;			/* 0x0180 */
+	uint8_t		reserved188[8];		/* 0x0188 */
+	uint64_t   	sdnxo;			/* 0x0190 */
+	uint8_t    	reserved198[8];		/* 0x0198 */
+	uint32_t	fac;			/* 0x01a0 */
+	uint8_t		reserved1a4[20];	/* 0x01a4 */
+	uint64_t	cbrlo;			/* 0x01b8 */
+	uint8_t		reserved1c0[8];		/* 0x01c0 */
+#define ECD_HOSTREGMGMT	0x20000000
+#define ECD_MEF		0x08000000
+#define ECD_ETOKENF	0x02000000
+#define ECD_ECC		0x00200000
+	uint32_t	ecd;			/* 0x01c8 */
+	uint8_t		reserved1cc[18];	/* 0x01cc */
+	uint64_t	pp;			/* 0x01de */
+	uint8_t		reserved1e6[2];		/* 0x01e6 */
+	uint64_t	itdba;			/* 0x01e8 */
+	uint64_t   	riccbd;			/* 0x01f0 */
+	uint64_t	gvrd;			/* 0x01f8 */
+} __attribute__((packed));
+
+struct vm_save_regs {
+	u64 grs[16];
+	u64 fprs[16];
+	u32 fpc;
+};
+
+/* We might be able to nestle all of this into the stack frame. But
+ * having a dedicated save area that saves more than the s390 ELF ABI
+ * defines leaves us more freedom in the implementation.
+*/
+struct vm_save_area {
+	struct vm_save_regs guest;
+	struct vm_save_regs host;
+};
+
+struct vm {
+	struct kvm_s390_sie_block *sblk;
+	struct vm_save_area save_area;
+	/* Ptr to first guest page */
+	u8 *guest_mem;
+};
+
+extern u64 sie_entry;
+extern u64 sie_exit;
+extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
+
+#endif /* SIE_H */
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 4e51150..2711018 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -203,6 +203,62 @@ smp_cpu_setup_state:
 	/* If the function returns, just loop here */
 0:	j	0
 
+/*
+ * sie64a calling convention:
+ * %r2 pointer to sie control block
+ * %r3 guest register save area
+ */
+.globl sie64a
+sie64a:
+	# Save host grs, fprs, fpc
+	stmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r3)	# save kernel registers
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8  + SIE_SAVEAREA_HOST_FPRS(%r3)
+	.endr
+	stfpc	SIE_SAVEAREA_HOST_FPC(%r3)
+
+	# Store scb and save_area pointer into stack frame
+	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
+	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
+
+	# Load guest's gprs, fprs and fpc
+	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
+	.endr
+	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
+
+	# Move scb ptr into r14 for the sie instruction
+	lg	%r14,__SF_SIE_CONTROL(%r15)
+
+.globl sie_entry
+sie_entry:
+	sie	0(%r14)
+	nopr	7
+	nopr	7
+	nopr	7
+
+.globl sie_exit
+sie_exit:
+	# Load guest register save area
+	lg	%r14,__SF_SIE_SAVEAREA(%r15)
+
+	# Store guest's gprs, fprs and fpc
+	stmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r14)	# save guest gprs 0-13
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8  + SIE_SAVEAREA_GUEST_FPRS(%r14)
+	.endr
+	stfpc	SIE_SAVEAREA_GUEST_FPC(%r14)
+
+	# Restore host's gprs, fprs and fpc
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8 + SIE_SAVEAREA_HOST_FPRS(%r14)
+	.endr
+	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
+	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
+
+	br	%r14
+
 pgm_int:
 	SAVE_REGS
 	brasl	%r14, handle_pgm_int
-- 
2.25.1

