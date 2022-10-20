Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E8B606039
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJTMcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJTMcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 08:32:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0FD4B4AF
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 05:31:58 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KBUxmW025215
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=tl0oFLTFOjnYx6bNLeE09Fl3x7Crxve7fZ43T+bRP4c=;
 b=hVDpEpnYF9aPk6OPsQWFrKJJQQ9FdMvLSSqEZTvkM4g5VYtzXEMKw2lFVgwDxbJX4XPs
 fjDBFgJzde/8ESlYClfciNrQB0uR2ZfurjZEWsF2TJrl0OmiIdx+HEMMW+h4BZNGlQHQ
 ZKVchzs3T+yW3BuXqlx93O1yM+7nf6L/BEnL2xJUEXWoml2LAufmBkZOTc7fHTb1XiF+
 tWWth2DIzDZ9LGaD7S90NnX5KcKWhbq+ukiRtxHzc9fN61gLXiFgIDtVGCBbRzj8nD+0
 Kqo2QwAreCO5gI9I2w2TIU+BSvi9h5s3QNs52gEgqH93PloCkbJlMZ+FGaJOZPrRKUHz Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb5hbj4f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:58 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29KBfxUE022204
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 12:31:57 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb5hbj4dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:31:57 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KCLx69003544;
        Thu, 20 Oct 2022 12:31:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3k7mg8xp3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 12:31:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KCVpjG45351390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 12:31:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BADA542041;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6536342045;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 12:31:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/2] lib: s390x: terminate if PGM interrupt in interrupt handler
Date:   Thu, 20 Oct 2022 14:31:42 +0200
Message-Id: <20221020123143.213778-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020123143.213778-1-imbrenda@linux.ibm.com>
References: <20221020123143.213778-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bC6YC38P8zKQ4yFGxd8F4t1yLOVi3MmR
X-Proofpoint-ORIG-GUID: UGuDauqeaOCeUWKtQFR7_IFdbUNlakFV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_04,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxlogscore=478 impostorscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200074
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
---
 lib/s390x/asm/arch_def.h | 11 +++++++++++
 lib/s390x/interrupt.c    | 20 ++++++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index b92291e8..124449a8 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -51,6 +51,7 @@ struct cpu {
 	bool active;
 	bool pgm_int_expected;
 	bool ext_int_expected;
+	bool in_interrupt_handler;
 };
 
 #define AS_PRIM				0
@@ -330,6 +331,16 @@ static inline void load_psw_mask(uint64_t mask)
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

