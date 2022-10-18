Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB055602E00
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiJROKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiJROKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:10:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7CC63FF7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:10:10 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IDc3AN008908
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/rbhH8oaulPncdwaRhS/+n8baOIV9VqqRVH+QGzc6N4=;
 b=hRn3qeS8OMQlCSL8kP6QkHGPvza1xbhHIkE+y+VGvVZ7/qDoauZp25sDLed08Ib8xqrc
 JfybN0fnmMyDw+4JtZzrucHfXf2SjdIDXjfgGu9bawNBXZSpYPf8bYipEZnKLo9f6a/U
 NcdQUXdZWKHU81BIzY7dS7IFwVyWVnsJ80g3O56uiBSjNaatAi7hxRssc9EhNi6VLUxH
 nSG4VWnwZuosMdhlA0ylVoAbxcjdJatQeXNdzV0QjJg1uP5lMLP9HNd7EY91zlnB4830
 GBAfAlo3HXh7s4gAKMgwaeYIBHNYihBhcjECBYi8dRUsWNgGe25pOoewQ7G5y5akwQ7W 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9vrra9vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:06 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29IE6qGm011915
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:10:05 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k9vrra9tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 14:10:05 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29IE5ahv027315;
        Tue, 18 Oct 2022 14:10:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3k7m4jc4es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 14:10:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29IEA00c46465310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 14:10:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE3A42047;
        Tue, 18 Oct 2022 14:10:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28F6D42042;
        Tue, 18 Oct 2022 14:10:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Oct 2022 14:10:00 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] lib: s390x: terminate if PGM interrupt in interrupt handler
Date:   Tue, 18 Oct 2022 16:09:50 +0200
Message-Id: <20221018140951.127093-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018140951.127093-1-imbrenda@linux.ibm.com>
References: <20221018140951.127093-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V-7Sb5aKlGCPdmTCqrOMiQchs9I2psuZ
X-Proofpoint-ORIG-GUID: HVedsUTU3Xh3u6gHR5SCnNJJMZzcsVuO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_04,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=478 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210180080
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
 lib/s390x/interrupt.c    | 18 ++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

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
index 7cc2c5fb..22bf443b 100644
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
@@ -242,6 +248,7 @@ void handle_pgm_int(struct stack_frame_int *stack)
 
 void handle_ext_int(struct stack_frame_int *stack)
 {
+	THIS_CPU->in_interrupt_handler = true;
 	if (!THIS_CPU->ext_int_expected && lowcore.ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
 			     lowcore.ext_int_code, stap(), lowcore.ext_old_psw.addr);
@@ -260,6 +267,7 @@ void handle_ext_int(struct stack_frame_int *stack)
 
 	if (THIS_CPU->ext_cleanup_func)
 		THIS_CPU->ext_cleanup_func(stack);
+	THIS_CPU->in_interrupt_handler = false;
 }
 
 void handle_mcck_int(void)
@@ -272,11 +280,13 @@ static void (*io_int_func)(void);
 
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

