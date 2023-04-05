Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E66D7CB9
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 14:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbjDEMfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 08:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbjDEMfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 08:35:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B011BD0;
        Wed,  5 Apr 2023 05:35:17 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335AwRGE011355;
        Wed, 5 Apr 2023 12:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NpidT9U3QfRUXL0IvUatJaeWukJJg8CKx/psZwauPGs=;
 b=BLWf1puQeJq4rErb1tU5YH82ylhv5CvA+6yACoufSuovbLlhgxJueAG5YZFtX05IsIeN
 FIgfo/Oa1mwcbnKKIiOKCH5uBirw81p8OpAZpPT+kGIsDlzfMkj1FfzJRarsgxHx7aI6
 5nM0C/9Kv0MQrP/3I6ZUFYw5GEeo0GVFyHkcuGOkOcIJNn5LpMojHrAGQqnOnYsz22BM
 AICnd3kpu16hxoTjkJB6VHUvcOScLne9+XTLuhJ1oI7OXzynaNytoQ3CXQs5eAE9mX/g
 sOHXck4gBXvHximjy7uPl04MRWaOejTknYGUNGrR1Yw+lfEtbRgNwbpvK2EFJHLL8sIb Zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps7pt2cft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 12:35:16 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 335BfpTh005013;
        Wed, 5 Apr 2023 12:35:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps7pt2cea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 12:35:16 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3350esU6009693;
        Wed, 5 Apr 2023 12:35:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3ppc86tgyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 12:35:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 335CZAUD17695426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 12:35:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECCFB20043;
        Wed,  5 Apr 2023 12:35:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C8FA20040;
        Wed,  5 Apr 2023 12:35:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 12:35:09 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1] s390x: Improve stack traces that contain an interrupt frame
Date:   Wed,  5 Apr 2023 14:35:08 +0200
Message-Id: <20230405123508.854034-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FfYLv27Y2zutJJfnGZhyVEFRn3ViKU06
X-Proofpoint-ORIG-GUID: sVbOpcwKRGNChpmPoPPOuEwu3KT7Bfoi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_07,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=576 impostorscore=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050113
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we encounter an unexpected interrupt we print a stack trace.
While we can identify the interrupting instruction via the old psw,
we don't really have a way to identify callers further up the stack,
since we rely on the s390x elf abi calling convention to perform the
backtrace. An interrupt is not a call, so there are no guarantees about
the contents of the stack and return address registers.
If we get lucky their content is as we need it or valid for a previous
callee in which case we print one wrong caller and then proceed with the
correct ones.

Warn about the stack trace above the interrupting instruction possibly
not being correct by inserting a new stack frame with a warning symbol.
Also identify the interrupted instruction.

For example:

0x00000000000150f1: print_pgm_info at lib/s390x/interrupt.c:255
 (inlined by) handle_pgm_int at lib/s390x/interrupt.c:274
0x0000000000011099: pgm_int at s390x/cstart64.S:97
0x0000000000014523: sclp_service_call at lib/s390x/sclp.c:185
0x0000000000000000: lowcore at lib/s390x/asm/arch_def.h:172
0x0000000000014b8b: console_refill_read_buffer at lib/s390x/sclp-console.c:259
 (inlined by) __getchar at lib/s390x/sclp-console.c:290
0x00000000000188ef: getchar at lib/getchar.c:8

becomes:

0x00000000000151f9: print_pgm_info at lib/s390x/interrupt.c:255
 (inlined by) handle_pgm_int at lib/s390x/interrupt.c:274
0x00000000000110c1: pgm_int at s390x/cstart64.S:98
0x000000000001462f: servc at lib/s390x/asm/arch_def.h:459
 (inlined by) sclp_service_call at lib/s390x/sclp.c:186
0x0000000000019150: WARNING_THE_FOLLOWING_CALLERS_MIGHT_BE_CORRECT_BY_ACCIDENT_ONLY at s390x/cstart64.S:?
0x0000000000000000: lowcore at lib/s390x/asm/arch_def.h:172
0x0000000000014c93: console_refill_read_buffer at lib/s390x/sclp-console.c:259
 (inlined by) __getchar at lib/s390x/sclp-console.c:290

Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
---
 s390x/cstart64.S |  1 +
 s390x/macros.S   | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 468ace3e..3cd0e3f3 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
 
+.file __FILE__
 #include "macros.S"
 .section .init
 
diff --git a/s390x/macros.S b/s390x/macros.S
index e2a56a36..ebbb5fac 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -17,6 +17,20 @@
  * we re-load the registers and load the old PSW.
  */
 	.macro CALL_INT_HANDLER c_func, old_psw
+	/* Allocate new stack frame for warning symbol that shows up in the stack trace */
+	stg	%r15, -STACK_FRAME_SIZE + STACK_FRAME_INT_BACKCHAIN(%r15)
+	lay	%r15, -STACK_FRAME_SIZE(%r15)
+	/*
+	 * The handler must return with the original registers -> save r14
+	 * so it can be used to point to the interrupting instruction
+	 */
+	stg	%r14, STACK_FRAME_INT_GRS0(%r15)
+	larl	%r14, WARNING_THE_FOLLOWING_CALLERS_MIGHT_BE_CORRECT_BY_ACCIDENT_ONLY
+	/* Pretend we are returning to an instruction after the warning symbol */
+	la	%r14,1(%r14)
+	stg	%r14, 12 * 8 + STACK_FRAME_INT_GRS0(%r15)
+	/* Pretend we made a call with the old psw address as return address */
+	lg	%r14, 8 + \old_psw
 	SAVE_REGS_STACK
 	/* Save the stack address in GR2 which is the first function argument */
 	lgr     %r2, %r15
@@ -30,7 +44,14 @@
 	brasl	%r14, \c_func
 	algfi   %r15, STACK_FRAME_SIZE
 	RESTORE_REGS_STACK
+	lg	%r14, STACK_FRAME_INT_GRS0(%r15)
+	lg	%r15, STACK_FRAME_INT_BACKCHAIN(%r15)
 	lpswe	\old_psw
+	.ifndef WARNING_THE_FOLLOWING_CALLERS_MIGHT_BE_CORRECT_BY_ACCIDENT_ONLY
+	.pushsection .rodata
+	.set	WARNING_THE_FOLLOWING_CALLERS_MIGHT_BE_CORRECT_BY_ACCIDENT_ONLY, .
+	.popsection
+	.endif
 	.endm
 
 /* Save registers on the stack (r15), so we can have stacked interrupts. */

base-commit: 5b5d27da2973b20ec29b18df4d749fb2190458af
prerequisite-patch-id: 619d9dfe41a0509d1f123849d696af3109e534ce
prerequisite-patch-id: b5b4345ef04be0c4c4c70903e343783a9ebec0ce
prerequisite-patch-id: 8b1ee5a4dd43bd7f70a69e0ffe1dfea0cfe2be91
prerequisite-patch-id: dc72bb12a0ee455bc607b69f9b644075338a15d0
prerequisite-patch-id: e394d9d3d4c0df3c9788c06e7e940a5abf645318
prerequisite-patch-id: efb98123d132fa4b0bf198dd2718966beea4fbd8
-- 
2.37.2

