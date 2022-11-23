Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7E163531E
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 09:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiKWIr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 03:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiKWIrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 03:47:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCEC32BA3;
        Wed, 23 Nov 2022 00:47:21 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN8LNUa014558;
        Wed, 23 Nov 2022 08:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=N6KQpyCIRLGVNI2BKxfLkWTQQxU4f9VG2jydRh65aag=;
 b=Ec4cIW/rVyN60oIpCtr70ksemEydK1oYK93q4TEaGL9uNBeASwLkinbJ5cjmRjSfHO7o
 94veJ9rmooajGqrj7g8+haw8ku+kIqW+sBJfuNS9D0XXkuqdWjxBiGA5F4FW5Te9adpG
 aGbjMOojweGELjoymdr808Z4PsDGbQbVA8cx/cabR1QVIM/GitSxH4bF9gHjfcFdyHhw
 lB+q5OTcGXdP5vooMxQHDWFLaSIOrPff+cf3ChFUwZRskxokljNsj+qMRiLZTnK8/us4
 NkR1oCGbGxcmAUXMuomfaTgttl/cjt5XIBx+Yd1+rN3GiEfSnWC3MUTmodL0zqe86Dj0 IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10pfxka8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:20 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AN8astc018667;
        Wed, 23 Nov 2022 08:47:20 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m10pfxk9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:20 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AN8ZeUR022807;
        Wed, 23 Nov 2022 08:47:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhwcvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 08:47:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AN8lEIG6423090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 08:47:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D81D11C04C;
        Wed, 23 Nov 2022 08:47:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B66311C04A;
        Wed, 23 Nov 2022 08:47:13 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 08:47:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/5] lib: s390x: Handle debug prints for SIE exceptions correctly
Date:   Wed, 23 Nov 2022 08:46:56 +0000
Message-Id: <20221123084656.19864-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123084656.19864-1-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: saKs2rWI3ENc4AIXd2OnRJddwu64qPxg
X-Proofpoint-GUID: PGSzQMdilxOOJ1VzxdGb1J-w1OE4zZ9E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 spamscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxlogscore=919 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211230064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we leave SIE due to an exception, we'll still have guest values
in registers 0 - 13 and that's not clearly portraied in our debug
prints. So let's fix that.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 46 ++++++++++++++++++++++++++++++++++++++-----
 lib/s390x/sie.h       |  2 ++
 s390x/cpu.S           |  6 ++++--
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index dadb7415..ff47c2c2 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -9,6 +9,7 @@
  */
 #include <libcflat.h>
 #include <asm/barrier.h>
+#include <asm/asm-offsets.h>
 #include <sclp.h>
 #include <interrupt.h>
 #include <sie.h>
@@ -188,9 +189,12 @@ static void print_storage_exception_information(void)
 	}
 }
 
-static void print_int_regs(struct stack_frame_int *stack)
+static void print_int_regs(struct stack_frame_int *stack, bool sie)
 {
+	struct kvm_s390_sie_block *sblk;
+
 	printf("\n");
+	printf("%s\n", sie ? "Guest registers:" : "Host registers:");
 	printf("GPRS:\n");
 	printf("%016lx %016lx %016lx %016lx\n",
 	       stack->grs1[0], stack->grs1[1], stack->grs0[0], stack->grs0[1]);
@@ -198,24 +202,56 @@ static void print_int_regs(struct stack_frame_int *stack)
 	       stack->grs0[2], stack->grs0[3], stack->grs0[4], stack->grs0[5]);
 	printf("%016lx %016lx %016lx %016lx\n",
 	       stack->grs0[6], stack->grs0[7], stack->grs0[8], stack->grs0[9]);
-	printf("%016lx %016lx %016lx %016lx\n",
-	       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
+
+	if (sie) {
+		sblk = (struct kvm_s390_sie_block *)stack->grs0[12];
+		printf("%016lx %016lx %016lx %016lx\n",
+		       stack->grs0[10], stack->grs0[11], sblk->gg14, sblk->gg15);
+	} else {
+		printf("%016lx %016lx %016lx %016lx\n",
+		       stack->grs0[10], stack->grs0[11], stack->grs0[12], stack->grs0[13]);
+	}
+
 	printf("\n");
 }
 
 static void print_pgm_info(struct stack_frame_int *stack)
 
 {
-	bool in_sie;
+	bool in_sie, in_sie_gregs;
+	struct vm_save_area *vregs;
 
 	in_sie = (lowcore.pgm_old_psw.addr >= (uintptr_t)sie_entry &&
 		  lowcore.pgm_old_psw.addr <= (uintptr_t)sie_exit);
+	in_sie_gregs = (lowcore.pgm_old_psw.addr >= (uintptr_t)sie_entry_gregs &&
+			lowcore.pgm_old_psw.addr <= (uintptr_t)sie_exit_gregs);
 
 	printf("\n");
 	printf("Unexpected program interrupt %s: %#x on cpu %d at %#lx, ilen %d\n",
 	       in_sie ? "in SIE" : "",
 	       lowcore.pgm_int_code, stap(), lowcore.pgm_old_psw.addr, lowcore.pgm_int_id);
-	print_int_regs(stack);
+
+	/*
+	 * If we fall out of SIE before loading the host registers,
+	 * then we need to do it here so we print the host registers
+	 * and not the guest registers.
+	 *
+	 * Back tracing is actually not a problem since SIE restores gr15.
+	 */
+	if (in_sie_gregs) {
+		print_int_regs(stack, true);
+		vregs = *((struct vm_save_area **)(stack->grs0[13] + __SF_SIE_SAVEAREA));
+
+		/*
+		 * The grs are not linear on the interrupt stack frame.
+		 * We copy 0 and 1 here and 2 - 15 with the memcopy below.
+		 */
+		stack->grs1[0] = vregs->host.grs[0];
+		stack->grs1[1] = vregs->host.grs[1];
+		/*  2 - 15 */
+		memcpy(stack->grs0, &vregs->host.grs[2], sizeof(stack->grs0) - 8);
+	}
+	print_int_regs(stack, false);
 	dump_stack();
 
 	/* Dump stack doesn't end with a \n so we add it here instead */
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index a27a8401..147cb0f2 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -273,6 +273,8 @@ struct vm {
 
 extern void sie_entry(void);
 extern void sie_exit(void);
+extern void sie_entry_gregs(void);
+extern void sie_exit_gregs(void);
 extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
 void sie(struct vm *vm);
 void sie_expect_validity(struct vm *vm);
diff --git a/s390x/cpu.S b/s390x/cpu.S
index 45bd551a..9155b044 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -82,7 +82,8 @@ sie64a:
 	# Store scb and save_area pointer into stack frame
 	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
 	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
-
+.globl sie_entry_gregs
+sie_entry_gregs:
 	# Load guest's gprs, fprs and fpc
 	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
@@ -121,7 +122,8 @@ sie_exit:
 	.endr
 	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
 	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
-
+.globl sie_exit_gregs
+sie_exit_gregs:
 	br	%r14
 
 	.align	8
-- 
2.34.1

