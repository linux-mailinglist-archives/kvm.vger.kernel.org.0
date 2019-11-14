Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9DAFAF9A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfKMLYN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:24:13 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65020 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbfKMLYN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 06:24:13 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADBO5oA066414
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 06:24:11 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8gmhgt32-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 06:24:11 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 13 Nov 2019 11:24:09 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 11:24:07 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADBO6PJ35979346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 11:24:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DC765204E;
        Wed, 13 Nov 2019 11:24:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BE45F5204F;
        Wed, 13 Nov 2019 11:24:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4] s390x: Load reset psw on diag308 reset
Date:   Wed, 13 Nov 2019 06:24:03 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <e54ce8f8-7ed5-3eee-6715-8b5051cb49fb@redhat.com>
References: <e54ce8f8-7ed5-3eee-6715-8b5051cb49fb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111311-0008-0000-0000-0000032EA507
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111311-0009-0000-0000-00004A4DAE2B
Message-Id: <20191113112403.7664-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
without DAT. Also we need to set the short psw indication to be
compliant with the architecture.

Let's therefore define a reset PSW mask with 64 bit addressing and
short PSW indication that is compliant with architecture and use it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm-offsets.c  |  1 +
 lib/s390x/asm/arch_def.h |  4 +++-
 s390x/cstart64.S         | 24 +++++++++++++++++-------
 3 files changed, 21 insertions(+), 8 deletions(-)

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
index 07d4e5e..cf6e1ca 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -79,7 +79,8 @@ struct lowcore {
 	uint32_t	sw_int_fpc;			/* 0x0300 */
 	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
 	uint64_t	sw_int_crs[16];			/* 0x0308 */
-	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
+	struct psw	sw_int_psw;			/* 0x0388 */
+	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
 	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
 	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
 	uint64_t	fprs_sa[16];			/* 0x1200 */
@@ -98,6 +99,7 @@ struct lowcore {
 	uint8_t		pad_0x1400[0x1800 - 0x1400];	/* 0x1400 */
 	uint8_t		pgm_int_tdb[0x1900 - 0x1800];	/* 0x1800 */
 } __attribute__ ((__packed__));
+_Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
 
 #define PGM_INT_CODE_OPERATION			0x01
 #define PGM_INT_CODE_PRIVILEGED_OPERATION	0x02
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 4be20fc..86dd4c4 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -126,13 +126,18 @@ memsetxc:
 .globl diag308_load_reset
 diag308_load_reset:
 	SAVE_REGS
-	/* Save the first PSW word to the IPL PSW */
+	/* Backup current PSW mask, as we have to restore it on success */
 	epsw	%r0, %r1
-	st	%r0, 0
-	/* Store the address and the bit for 31 bit addressing */
-	larl    %r0, 0f
-	oilh    %r0, 0x8000
-	st      %r0, 0x4
+	st	%r0, GEN_LC_SW_INT_PSW
+	st	%r1, GEN_LC_SW_INT_PSW + 4
+	/* Load reset psw mask (short psw, 64 bit) */
+	lg	%r0, reset_psw
+	/* Load the success label address */
+	larl    %r1, 0f
+	/* Or it to the mask */
+	ogr	%r0, %r1
+	/* Store it at the reset PSW location (real 0x0) */
+	stg	%r0, 0
 	/* Do the reset */
 	diag    %r0,%r2,0x308
 	/* Failure path */
@@ -144,7 +149,10 @@ diag308_load_reset:
 	lctlg	%c0, %c0, 0(%r1)
 	RESTORE_REGS
 	lhi	%r2, 1
-	br	%r14
+	larl	%r0, 1f
+	stg	%r0, GEN_LC_SW_INT_PSW + 8
+	lpswe	GEN_LC_SW_INT_PSW
+1:	br	%r14
 
 .globl smp_cpu_setup_state
 smp_cpu_setup_state:
@@ -184,6 +192,8 @@ svc_int:
 	lpswe	GEN_LC_SVC_OLD_PSW
 
 	.align	8
+reset_psw:
+	.quad	0x0008000180000000
 initial_psw:
 	.quad	0x0000000180000000, clear_bss_start
 pgm_int_psw:
-- 
2.20.1

