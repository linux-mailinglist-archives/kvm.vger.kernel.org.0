Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A160EF02B5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 17:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390163AbfKEQ3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 11:29:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8358 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390123AbfKEQ3q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 11:29:46 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA5GQ7xO068138
        for <kvm@vger.kernel.org>; Tue, 5 Nov 2019 11:29:45 -0500
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w14m4kd63-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:29:43 -0500
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 5 Nov 2019 16:29:03 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 5 Nov 2019 16:29:00 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA5GSxlh32374886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Nov 2019 16:28:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12E4542042;
        Tue,  5 Nov 2019 16:28:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59EAE42049;
        Tue,  5 Nov 2019 16:28:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Nov 2019 16:28:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH 1/2] s390x: Add CR save area
Date:   Tue,  5 Nov 2019 11:28:27 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105162828.2490-1-frankja@linux.ibm.com>
References: <20191105162828.2490-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110516-0012-0000-0000-00000360F329
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110516-0013-0000-0000-0000219C4D2A
Message-Id: <20191105162828.2490-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-05_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911050135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we run with DAT enabled and do a reset, we need to save the CRs to
backup our ASCEs on a diag308 for example.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm-offsets.c  | 2 +-
 lib/s390x/asm/arch_def.h | 4 ++--
 lib/s390x/interrupt.c    | 4 ++--
 lib/s390x/smp.c          | 2 +-
 s390x/cstart64.S         | 9 ++++++---
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 6e2d259..4b213f8 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -57,7 +57,7 @@ int main(void)
 	OFFSET(GEN_LC_SW_INT_GRS, lowcore, sw_int_grs);
 	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
 	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
-	OFFSET(GEN_LC_SW_INT_CR0, lowcore, sw_int_cr0);
+	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
 	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
 	OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
 	OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 96cca2e..07d4e5e 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -78,8 +78,8 @@ struct lowcore {
 	uint64_t	sw_int_fprs[16];		/* 0x0280 */
 	uint32_t	sw_int_fpc;			/* 0x0300 */
 	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
-	uint64_t	sw_int_cr0;			/* 0x0308 */
-	uint8_t		pad_0x0310[0x11b0 - 0x0310];	/* 0x0310 */
+	uint64_t	sw_int_crs[16];			/* 0x0308 */
+	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
 	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
 	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
 	uint64_t	fprs_sa[16];			/* 0x1200 */
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 5cade23..c9e2dc6 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -124,13 +124,13 @@ void handle_ext_int(void)
 	}
 
 	if (lc->ext_int_code == EXT_IRQ_SERVICE_SIG) {
-		lc->sw_int_cr0 &= ~(1UL << 9);
+		lc->sw_int_crs[0] &= ~(1UL << 9);
 		sclp_handle_ext();
 	} else {
 		ext_int_expected = false;
 	}
 
-	if (!(lc->sw_int_cr0 & CR0_EXTM_MASK))
+	if (!(lc->sw_int_crs[0] & CR0_EXTM_MASK))
 		lc->ext_old_psw.mask &= ~PSW_MASK_EXT;
 }
 
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index 7602886..f57f420 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -189,7 +189,7 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
 	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4);
 	lc->restart_new_psw.mask = 0x0000000180000000UL;
 	lc->restart_new_psw.addr = (uint64_t)smp_cpu_setup_state;
-	lc->sw_int_cr0 = 0x0000000000040000UL;
+	lc->sw_int_crs[0] = 0x0000000000040000UL;
 
 	/* Start processing */
 	rc = sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 8e2b21e..0455591 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -93,7 +93,7 @@ memsetxc:
 	/* save grs 0-15 */
 	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
 	/* save cr0 */
-	stctg	%c0, %c0, GEN_LC_SW_INT_CR0
+	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
 	/* load initial cr0 again */
 	larl	%r1, initial_cr0
 	lctlg	%c0, %c0, 0(%r1)
@@ -107,13 +107,16 @@ memsetxc:
 
 	.macro RESTORE_REGS
 	/* restore fprs 0-15 + fpc */
+	/* load initial cr0 again */
+	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
 	la	%r1, GEN_LC_SW_INT_FPRS
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	ld	\i, \i * 8(%r1)
 	.endr
 	lfpc	GEN_LC_SW_INT_FPC
 	/* restore cr0 */
-	lctlg	%c0, %c0, GEN_LC_SW_INT_CR0
+	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
 	/* restore grs 0-15 */
 	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
 	.endm
@@ -150,7 +153,7 @@ diag308_load_reset:
 smp_cpu_setup_state:
 	xgr	%r1, %r1
 	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
-	lctlg   %c0, %c0, GEN_LC_SW_INT_CR0
+	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
 	br	%r14
 
 pgm_int:
-- 
2.20.1

