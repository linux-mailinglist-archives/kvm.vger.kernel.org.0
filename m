Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88AECF02B3
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 17:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390225AbfKEQ3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 11:29:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390156AbfKEQ3H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Nov 2019 11:29:07 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA5GPiTu010617
        for <kvm@vger.kernel.org>; Tue, 5 Nov 2019 11:29:06 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3cbj0v4e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 11:29:05 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 5 Nov 2019 16:29:03 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 5 Nov 2019 16:29:01 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA5GT0LX38142154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Nov 2019 16:29:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B35042045;
        Tue,  5 Nov 2019 16:29:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5770442042;
        Tue,  5 Nov 2019 16:28:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Nov 2019 16:28:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH 2/2] s390x: Remove DAT and add short indication psw bits on diag308 reset
Date:   Tue,  5 Nov 2019 11:28:28 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105162828.2490-1-frankja@linux.ibm.com>
References: <20191105162828.2490-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19110516-0020-0000-0000-00000382CD9F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110516-0021-0000-0000-000021D8F856
Message-Id: <20191105162828.2490-3-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-05_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=974 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911050135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a diag308 subcode 0 CRs will be reset, so we need to mask of PSW
DAT indication until we restore our CRs.

Also we need to set the short psw indication to be compliant with the
architecture.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm-offsets.c  |  1 +
 lib/s390x/asm/arch_def.h |  3 ++-
 s390x/cstart64.S         | 20 ++++++++++++++------
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 4b213f8..61d2658 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -58,6 +58,7 @@ int main(void)
 	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
 	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
 	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
+	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
 	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
 	OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
 	OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 07d4e5e..7d25e4f 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -79,7 +79,8 @@ struct lowcore {
 	uint32_t	sw_int_fpc;			/* 0x0300 */
 	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
 	uint64_t	sw_int_crs[16];			/* 0x0308 */
-	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
+	struct psw	sw_int_psw;			/* 0x0388 */
+	uint8_t		pad_0x0310[0x11b0 - 0x0390];	/* 0x0390 */
 	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
 	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
 	uint64_t	fprs_sa[16];			/* 0x1200 */
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 0455591..2e0dcf5 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -129,8 +129,15 @@ memsetxc:
 .globl diag308_load_reset
 diag308_load_reset:
 	SAVE_REGS
-	/* Save the first PSW word to the IPL PSW */
+	/* Backup current PSW */
 	epsw	%r0, %r1
+	st	%r0, GEN_LC_SW_INT_PSW
+	st	%r1, GEN_LC_SW_INT_PSW + 4
+	/* Disable DAT as the CRs will be reset too */
+	nilh	%r0, 0xfbff
+	/* Add psw bit 12 to indicate short psw */
+	oilh	%r0, 0x0008
+	/* Save the first PSW word to the IPL PSW */
 	st	%r0, 0
 	/* Store the address and the bit for 31 bit addressing */
 	larl    %r0, 0f
@@ -142,12 +149,13 @@ diag308_load_reset:
 	xgr	%r2, %r2
 	br	%r14
 	/* Success path */
-	/* We lost cr0 due to the reset */
-0:	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	RESTORE_REGS
+	/* Switch to z/Architecture mode and 64-bit */
+0:	RESTORE_REGS
 	lhi	%r2, 1
-	br	%r14
+	larl	%r0, 1f
+	stg	%r0, GEN_LC_SW_INT_PSW + 8
+	lpswe	GEN_LC_SW_INT_PSW
+1:	br	%r14
 
 .globl smp_cpu_setup_state
 smp_cpu_setup_state:
-- 
2.20.1

