Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BF460CB28
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiJYLoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiJYLn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:57 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2741C175366
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:56 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8A3O028254
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fW03cszluypob1Kl7I4yUcvR8fEHIFec+VMud8zwcHU=;
 b=aLFsGsU57BPoTmQoAU0yCkZymu0u8R96egjxRhOdntpy9s7Dh5V6NzXvn+lm/aG4Wlwk
 hxd8Fqv020Y5pe+WF+nQiDgvlwXiPFvQNZ9sTAIc8AhPvZgh6aZ+K/ERIhNEAGJD7YRG
 28du8LCt8CR/89aEZ7nUMEYYgoQmc+PCucbtUuweUpiatzDWzym0+UVaB5hMOChyM7QP
 BRrhqOmjSt6vv1j83JvJscuKJWkJolV7JpkqVcdyYBlZAp/vae5u4cqIkecJZqORBxxg
 2z7cRONl3HSFYpHbf6WgYn6kX/oa38NH7e40gowBIwUnsBqeVp+JHoORucXyClj28mID DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBPDk2017640
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:55 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBd9Nc024274;
        Tue, 25 Oct 2022 11:43:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugat57b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhnnK21496144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A369DAE04D;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70193AE051;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:49 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 15/22] lib: s390x: terminate if PGM interrupt in interrupt handler
Date:   Tue, 25 Oct 2022 13:43:38 +0200
Message-Id: <20221025114345.28003-16-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2YXAzw22ZJ-gkCK2Gp55HtY9BPvVFZLS
X-Proofpoint-GUID: vTsIaSK5zPprdJ8U00jo-Bpjto9s_rmy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=367
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a program interrupt is received while in an interrupt handler,
terminate immediately, stopping all CPUs and leaving the last CPU in
disabled wait with a specific PSW code.

This will aid debugging by not cluttering the output, avoiding further
interrupts (that would be needed to write to the output), and providing
an indication of the cause of the termination.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221020123143.213778-2-imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 11 +++++++++++
 lib/s390x/interrupt.c    | 20 ++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 41c9bd8c..783a7eaa 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -56,6 +56,7 @@ struct cpu {
 	bool active;
 	bool pgm_int_expected;
 	bool ext_int_expected;
+	bool in_interrupt_handler;
 };
 
 #define AS_PRIM				0
@@ -336,6 +337,16 @@ static inline void load_psw_mask(uint64_t mask)
 		: "+r" (tmp) :  "a" (&psw) : "memory", "cc" );
 }
 
+static inline void disabled_wait(uint64_t message)
+{
+	struct psw psw = {
+		.mask = PSW_MASK_WAIT,  /* Disabled wait */
+		.addr = message,
+	};
+
+	asm volatile("  lpswe 0(%0)\n" : : "a" (&psw) : "memory", "cc");
+}
+
 /**
  * psw_mask_clear_bits - clears bits from the current PSW mask
  * @clear: bitmask of bits that will be cleared
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 7cc2c5fb..dadb7415 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -14,6 +14,7 @@
 #include <sie.h>
 #include <fault.h>
 #include <asm/page.h>
+#include "smp.h"
 
 /**
  * expect_pgm_int - Expect a program interrupt on the current CPU.
@@ -226,6 +227,11 @@ static void print_pgm_info(struct stack_frame_int *stack)
 
 void handle_pgm_int(struct stack_frame_int *stack)
 {
+	if (THIS_CPU->in_interrupt_handler) {
+		/* Something went very wrong, stop everything now without printing anything */
+		smp_teardown();
+		disabled_wait(0xfa12edbad21);
+	}
 	if (!THIS_CPU->pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
@@ -233,15 +239,18 @@ void handle_pgm_int(struct stack_frame_int *stack)
 	}
 
 	THIS_CPU->pgm_int_expected = false;
+	THIS_CPU->in_interrupt_handler = true;
 
 	if (THIS_CPU->pgm_cleanup_func)
 		THIS_CPU->pgm_cleanup_func(stack);
 	else
 		fixup_pgm_int(stack);
+	THIS_CPU->in_interrupt_handler = false;
 }
 
 void handle_ext_int(struct stack_frame_int *stack)
 {
+	THIS_CPU->in_interrupt_handler = true;
 	if (!THIS_CPU->ext_int_expected && lowcore.ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
 			     lowcore.ext_int_code, stap(), lowcore.ext_old_psw.addr);
@@ -260,6 +269,7 @@ void handle_ext_int(struct stack_frame_int *stack)
 
 	if (THIS_CPU->ext_cleanup_func)
 		THIS_CPU->ext_cleanup_func(stack);
+	THIS_CPU->in_interrupt_handler = false;
 }
 
 void handle_mcck_int(void)
@@ -272,11 +282,13 @@ static void (*io_int_func)(void);
 
 void handle_io_int(void)
 {
+	THIS_CPU->in_interrupt_handler = true;
 	if (io_int_func)
-		return io_int_func();
-
-	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
-		     stap(), lowcore.io_old_psw.addr);
+		io_int_func();
+	else
+		report_abort("Unexpected io interrupt: on cpu %d at %#lx",
+			     stap(), lowcore.io_old_psw.addr);
+	THIS_CPU->in_interrupt_handler = false;
 }
 
 int register_io_int_func(void (*f)(void))
-- 
2.37.3

