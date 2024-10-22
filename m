Return-Path: <kvm+bounces-29388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42FBE9AA1BB
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55D661C21435
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E7719D8B7;
	Tue, 22 Oct 2024 12:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XehVmtU0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCA719D083;
	Tue, 22 Oct 2024 12:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729598773; cv=none; b=as4TCGuTdW0g6xeG5Q12fwL6HI6cZwtARzaEq/N5rkXxaavX/8dO4sTZQx3Jh83QMomMXRGBGOo/l8amPjKrtExyWytfa9HKi18QP9foO/Gqz0RS9z3rwpHvRD93WP0lmAeE0L26mqzsD6zBezGDeTcNe4ykE8yiRUGcFbul0HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729598773; c=relaxed/simple;
	bh=xlPopFefVfTzh69o9E/BNWbjtqQJxBiEWh3waQB4SlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hC4oZKiKM/A1kK9Bw4luRMDpi3+kKhAeH+jj3mdlXhzW50Giz/lNTxo2BLLBVe616KTG/F07k/yUR+drXugfKyI1ecfwjY8DlbJg3IxnAQ+55FQKkdxgLn3UaYCzY8Myi1pkZU3pvZ+oh29t/kek68Sr1uRwIW0NNe202RxzrlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XehVmtU0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HBEe009278;
	Tue, 22 Oct 2024 12:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=SKoxVlqtMbPWGZVFn
	uh11pMFTdjYbTM30VhHZOK5WO0=; b=XehVmtU0s1G7Tad1CTuRmthmwRtEcRBZB
	ajOhC9Enf0cphYFc9ep4ZJnXzBDbGczDpQ1yWq3ioN/4EJotUeL+6LFEryyYxTf8
	QAahqx1MOiHDGUpWEwiOvCiUbiW/CooIuK3hOqelWgTR6/4kNbEWEVLRnLcVWeep
	S2XZBI/9FL6Bkisiz2+YJMZkfNVDCZDm2Z00aGpd6qh7KbzIB2FEdC8c6UwntAC4
	Gj+qIgJjqaQ3RNYFkSjHP17j/7sEw5PZG/bBq3h67jO/pxkKhoVC7vc3yEVGVA7A
	X0qtZ3hFqz5XyGVSaJrpnOcShPwM0wT/+DwJJrRrfatFCwT4dycDw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5hmeevf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MAOb6k018605;
	Tue, 22 Oct 2024 12:06:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42csajauas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:06:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MC63BR34210474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:06:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83D5F20043;
	Tue, 22 Oct 2024 12:06:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7CC720040;
	Tue, 22 Oct 2024 12:06:02 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.37.93])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Oct 2024 12:06:02 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: borntraeger@de.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, seiden@linux.ibm.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: [PATCH v4 01/11] s390/entry: Remove __GMAP_ASCE and use _PIF_GUEST_FAULT again
Date: Tue, 22 Oct 2024 14:05:51 +0200
Message-ID: <20241022120601.167009-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241022120601.167009-1-imbrenda@linux.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JUzmOZ2eRGMp-EAH6zKDMD-4Qc-QaUIE
X-Proofpoint-GUID: JUzmOZ2eRGMp-EAH6zKDMD-4Qc-QaUIE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=573 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220074

Now that the guest ASCE is passed as a parameter to __sie64a(),
_PIF_GUEST_FAULT can be used again to determine whether the fault was a
guest or host fault.

Since the guest ASCE will not be taken from the gmap pointer in lowcore
anymore, __GMAP_ASCE can be removed. For the same reason the guest
ASCE needs now to be saved into the cr1 save area unconditionally.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/ptrace.h |  2 ++
 arch/s390/kernel/asm-offsets.c |  2 --
 arch/s390/kernel/entry.S       | 26 ++++++++++++++------------
 arch/s390/mm/fault.c           |  6 ++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index 2ad9324f6338..788bc4467445 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -14,11 +14,13 @@
 #define PIF_SYSCALL			0	/* inside a system call */
 #define PIF_EXECVE_PGSTE_RESTART	1	/* restart execve for PGSTE binaries */
 #define PIF_SYSCALL_RET_SET		2	/* return value was set via ptrace */
+#define PIF_GUEST_FAULT			3	/* indicates program check in sie64a */
 #define PIF_FTRACE_FULL_REGS		4	/* all register contents valid (ftrace) */
 
 #define _PIF_SYSCALL			BIT(PIF_SYSCALL)
 #define _PIF_EXECVE_PGSTE_RESTART	BIT(PIF_EXECVE_PGSTE_RESTART)
 #define _PIF_SYSCALL_RET_SET		BIT(PIF_SYSCALL_RET_SET)
+#define _PIF_GUEST_FAULT		BIT(PIF_GUEST_FAULT)
 #define _PIF_FTRACE_FULL_REGS		BIT(PIF_FTRACE_FULL_REGS)
 
 #define PSW32_MASK_PER		_AC(0x40000000, UL)
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 5529248d84fb..3a6ee5043761 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -13,7 +13,6 @@
 #include <linux/purgatory.h>
 #include <linux/pgtable.h>
 #include <linux/ftrace.h>
-#include <asm/gmap.h>
 #include <asm/stacktrace.h>
 
 int main(void)
@@ -161,7 +160,6 @@ int main(void)
 	OFFSET(__LC_PGM_TDB, lowcore, pgm_tdb);
 	BLANK();
 	/* gmap/sie offsets */
-	OFFSET(__GMAP_ASCE, gmap, asce);
 	OFFSET(__SIE_PROG0C, kvm_s390_sie_block, prog0c);
 	OFFSET(__SIE_PROG20, kvm_s390_sie_block, prog20);
 	/* kexec_sha_region */
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index d6d5317f768e..454841229ef4 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -327,13 +327,23 @@ SYM_CODE_START(pgm_check_handler)
 	GET_LC	%r13
 	stpt	__LC_SYS_ENTER_TIMER(%r13)
 	BPOFF
-	lgr	%r10,%r15
 	lmg	%r8,%r9,__LC_PGM_OLD_PSW(%r13)
+	xgr	%r10,%r10
+	xgr	%r12,%r12
 	tmhh	%r8,0x0001		# coming from user space?
 	jno	.Lpgm_skip_asce
 	lctlg	%c1,%c1,__LC_KERNEL_ASCE(%r13)
 	j	3f			# -> fault in user space
 .Lpgm_skip_asce:
+#if IS_ENABLED(CONFIG_KVM)
+	lg	%r11,__LC_CURRENT(%r13)
+	tm      __TI_sie(%r11),0xff
+	jz	1f
+	BPENTER	__SF_SIE_FLAGS(%r15),_TIF_ISOLATE_BP_GUEST
+	SIEEXIT __SF_SIE_CONTROL(%r15),%r13
+	lg	%r12,__SF_SIE_GUEST_ASCE(%r15)
+	lghi	%r10,_PIF_GUEST_FAULT
+#endif
 1:	tmhh	%r8,0x4000		# PER bit set in old PSW ?
 	jnz	2f			# -> enabled, can't be a double fault
 	tm	__LC_PGM_ILC+3(%r13),0x80	# check for per exception
@@ -344,21 +354,13 @@ SYM_CODE_START(pgm_check_handler)
 	CHECK_VMAP_STACK __LC_SAVE_AREA,%r13,4f
 3:	lg	%r15,__LC_KERNEL_STACK(%r13)
 4:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
-	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
+	stg	%r10,__PT_FLAGS(%r11)
+	stg	%r12,__PT_CR1(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	mvc	__PT_R8(64,%r11),__LC_SAVE_AREA(%r13)
 	mvc	__PT_LAST_BREAK(8,%r11),__LC_PGM_LAST_BREAK(%r13)
-	stctg	%c1,%c1,__PT_CR1(%r11)
-#if IS_ENABLED(CONFIG_KVM)
-	ltg	%r12,__LC_GMAP(%r13)
-	jz	5f
-	clc	__GMAP_ASCE(8,%r12), __PT_CR1(%r11)
-	jne	5f
-	BPENTER	__SF_SIE_FLAGS(%r10),_TIF_ISOLATE_BP_GUEST
-	SIEEXIT __SF_SIE_CONTROL(%r10),%r13
-#endif
-5:	stmg	%r8,%r9,__PT_PSW(%r11)
+	stmg	%r8,%r9,__PT_PSW(%r11)
 	# clear user controlled registers to prevent speculative use
 	xgr	%r0,%r0
 	xgr	%r1,%r1
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index ad8b0d6b77ea..a6cf33b0f339 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -68,15 +68,13 @@ early_initcall(fault_init);
 static enum fault_type get_fault_type(struct pt_regs *regs)
 {
 	union teid teid = { .val = regs->int_parm_long };
-	struct gmap *gmap;
 
 	if (likely(teid.as == PSW_BITS_AS_PRIMARY)) {
 		if (user_mode(regs))
 			return USER_FAULT;
 		if (!IS_ENABLED(CONFIG_PGSTE))
 			return KERNEL_FAULT;
-		gmap = (struct gmap *)get_lowcore()->gmap;
-		if (gmap && gmap->asce == regs->cr1)
+		if (test_pt_regs_flag(regs, PIF_GUEST_FAULT))
 			return GMAP_FAULT;
 		return KERNEL_FAULT;
 	}
@@ -187,7 +185,7 @@ static void dump_fault_info(struct pt_regs *regs)
 		pr_cont("user ");
 		break;
 	case GMAP_FAULT:
-		asce = ((struct gmap *)get_lowcore()->gmap)->asce;
+		asce = regs->cr1;
 		pr_cont("gmap ");
 		break;
 	case KERNEL_FAULT:
-- 
2.47.0


