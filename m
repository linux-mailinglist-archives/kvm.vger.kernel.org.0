Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61657CCD8
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiGUOHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiGUOHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E2422FB
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:16 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LE66iW021396
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=STKtbH3l3MMfgl13sUdZ3AwlAO1ujHRwLuSMCCmYUqI=;
 b=EfU2wnPbnyS6nAWEcP+ImErDojYEPLBcvCUg56m+/mGmlEnDw6yaJY0YFTf5WaC6e8bp
 vxww8OigO6UuxLD6QebKq2ymFpxJpo6hXO13PpNHi9rlVbB/2pPq6uq9C3YPENfH36/W
 vq07EBUGLqCpWKJBOIecCoIaXYUuHyegekGDiKpjIFWeKZCiziJNhrCyBnOCs2kUy3DH
 6S/erf8V3vP/bhozp9Qqq1P2Tu4SPNq0cz6l534ZkwLPDDyQetvCfI8p6dTC2eQ3tWSv
 PN+DaWA9quiR67cieIZq8Id0wWpiOShDvNN+SOWYipTPll7uN3RwIS2xxyA+fgmzjvgY Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf82vrddv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LE6Qao023540
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:15 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf82vrd28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:15 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE6nbr001099;
        Thu, 21 Jul 2022 14:07:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy8y123-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:07 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE752E22806792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:05 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9436B4C046;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F3104C040;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 10/12] lib: s390x: better smp interrupt checks
Date:   Thu, 21 Jul 2022 16:06:59 +0200
Message-Id: <20220721140701.146135-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721140701.146135-1-imbrenda@linux.ibm.com>
References: <20220721140701.146135-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z-QmT-wRcLIsB501G0XdJHuLjbw9UdXN
X-Proofpoint-ORIG-GUID: vnebyKrZS7U9bwr2N3FnOw_Clm1zGjje
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=799 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use per-CPU flags and callbacks for Program and Extern interrupts,
instead of global variables.

This allows for more accurate error handling; a CPU waiting for an
interrupt will not have it "stolen" by a different CPU that was not
supposed to wait for one, and now two CPUs can wait for interrupts at
the same time.

This will significantly improve error reporting and debugging when
things go wrong.

Both program interrupts and external interrupts are now CPU-bound, even
though some external interrupts are floating (notably, the SCLP
interrupt). In those cases, the testcases should mask interrupts and/or
expect them appropriately according to need.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h  | 17 ++++++++-
 lib/s390x/asm/interrupt.h |  3 +-
 lib/s390x/smp.h           |  8 +---
 lib/s390x/interrupt.c     | 77 +++++++++++++++++++++++++++++++--------
 lib/s390x/smp.c           | 11 ++++++
 s390x/skrf.c              |  2 +-
 6 files changed, 92 insertions(+), 26 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 358ef82e..e7ae454b 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -41,6 +41,18 @@ struct psw {
 	uint64_t	addr;
 };
 
+struct cpu {
+	struct lowcore *lowcore;
+	uint64_t *stack;
+	void (*pgm_cleanup_func)(struct stack_frame_int *);
+	void (*ext_cleanup_func)(struct stack_frame_int *);
+	uint16_t addr;
+	uint16_t idx;
+	bool active;
+	bool pgm_int_expected;
+	bool ext_int_expected;
+};
+
 #define AS_PRIM				0
 #define AS_ACCR				1
 #define AS_SECN				2
@@ -125,7 +137,8 @@ struct lowcore {
 	uint8_t		pad_0x0280[0x0308 - 0x0280];	/* 0x0280 */
 	uint64_t	sw_int_crs[16];			/* 0x0308 */
 	struct psw	sw_int_psw;			/* 0x0388 */
-	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
+	struct cpu	*this_cpu;			/* 0x0398 */
+	uint8_t		pad_0x03a0[0x11b0 - 0x03a0];	/* 0x03a0 */
 	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
 	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
 	uint64_t	fprs_sa[16];			/* 0x1200 */
@@ -148,6 +161,8 @@ _Static_assert(sizeof(struct lowcore) == 0x1900, "Lowcore size");
 
 extern struct lowcore lowcore;
 
+#define THIS_CPU (lowcore.this_cpu)
+
 #define PGM_INT_CODE_OPERATION			0x01
 #define PGM_INT_CODE_PRIVILEGED_OPERATION	0x02
 #define PGM_INT_CODE_EXECUTE			0x03
diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index fc66a925..35c1145f 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -71,7 +71,8 @@ static inline enum prot_code teid_esop2_prot_code(union teid teid)
 	return (enum prot_code)code;
 }
 
-void register_pgm_cleanup_func(void (*f)(void));
+void register_pgm_cleanup_func(void (*f)(struct stack_frame_int *));
+void register_ext_cleanup_func(void (*f)(struct stack_frame_int *));
 void handle_pgm_int(struct stack_frame_int *stack);
 void handle_ext_int(struct stack_frame_int *stack);
 void handle_mcck_int(void);
diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
index df184cb8..f4ae973d 100644
--- a/lib/s390x/smp.h
+++ b/lib/s390x/smp.h
@@ -12,13 +12,6 @@
 
 #include <asm/arch_def.h>
 
-struct cpu {
-	struct lowcore *lowcore;
-	uint64_t *stack;
-	uint16_t addr;
-	bool active;
-};
-
 struct cpu_status {
     uint64_t    fprs[16];                       /* 0x0000 */
     uint64_t    grs[16];                        /* 0x0080 */
@@ -52,5 +45,6 @@ int smp_cpu_setup(uint16_t idx, struct psw psw);
 void smp_teardown(void);
 void smp_setup(void);
 int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status);
+struct lowcore *smp_get_lowcore(uint16_t idx);
 
 #endif
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index ac3d1ecd..7cc2c5fb 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -15,25 +15,36 @@
 #include <fault.h>
 #include <asm/page.h>
 
-static bool pgm_int_expected;
-static bool ext_int_expected;
-static void (*pgm_cleanup_func)(void);
-
+/**
+ * expect_pgm_int - Expect a program interrupt on the current CPU.
+ */
 void expect_pgm_int(void)
 {
-	pgm_int_expected = true;
+	THIS_CPU->pgm_int_expected = true;
 	lowcore.pgm_int_code = 0;
 	lowcore.trans_exc_id = 0;
 	mb();
 }
 
+/**
+ * expect_ext_int - Expect an external interrupt on the current CPU.
+ */
 void expect_ext_int(void)
 {
-	ext_int_expected = true;
+	THIS_CPU->ext_int_expected = true;
 	lowcore.ext_int_code = 0;
 	mb();
 }
 
+/**
+ * clear_pgm_int - Clear program interrupt information
+ *
+ * Clear program interrupt information, including the expected program
+ * interrupt flag.
+ * No program interrupts are expected after calling this function.
+ *
+ * Return: the program interrupt code before clearing
+ */
 uint16_t clear_pgm_int(void)
 {
 	uint16_t code;
@@ -42,10 +53,17 @@ uint16_t clear_pgm_int(void)
 	code = lowcore.pgm_int_code;
 	lowcore.pgm_int_code = 0;
 	lowcore.trans_exc_id = 0;
-	pgm_int_expected = false;
+	THIS_CPU->pgm_int_expected = false;
 	return code;
 }
 
+/**
+ * check_pgm_int_code - Check the program interrupt code on the current CPU.
+ * @code the expected program interrupt code on the current CPU
+ *
+ * Check and report if the program interrupt on the current CPU matches the
+ * expected one.
+ */
 void check_pgm_int_code(uint16_t code)
 {
 	mb();
@@ -54,9 +72,34 @@ void check_pgm_int_code(uint16_t code)
 	       lowcore.pgm_int_code);
 }
 
-void register_pgm_cleanup_func(void (*f)(void))
+/**
+ * register_pgm_cleanup_func - Register a cleanup function for progam
+ * interrupts for the current CPU.
+ * @f the cleanup function to be registered on the current CPU
+ *
+ * Register a cleanup function to be called at the end of the normal
+ * interrupt handling for program interrupts for this CPU.
+ *
+ * Pass NULL to unregister a previously registered cleanup function.
+ */
+void register_pgm_cleanup_func(void (*f)(struct stack_frame_int *))
+{
+	THIS_CPU->pgm_cleanup_func = f;
+}
+
+/**
+ * register_ext_cleanup_func - Register a cleanup function for external
+ * interrupts for the current CPU.
+ * @f the cleanup function to be registered on the current CPU
+ *
+ * Register a cleanup function to be called at the end of the normal
+ * interrupt handling for external interrupts for this CPU.
+ *
+ * Pass NULL to unregister a previously registered cleanup function.
+ */
+void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
 {
-	pgm_cleanup_func = f;
+	THIS_CPU->ext_cleanup_func = f;
 }
 
 static void fixup_pgm_int(struct stack_frame_int *stack)
@@ -183,24 +226,23 @@ static void print_pgm_info(struct stack_frame_int *stack)
 
 void handle_pgm_int(struct stack_frame_int *stack)
 {
-	if (!pgm_int_expected) {
+	if (!THIS_CPU->pgm_int_expected) {
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
 		print_pgm_info(stack);
 	}
 
-	pgm_int_expected = false;
+	THIS_CPU->pgm_int_expected = false;
 
-	if (pgm_cleanup_func)
-		(*pgm_cleanup_func)();
+	if (THIS_CPU->pgm_cleanup_func)
+		THIS_CPU->pgm_cleanup_func(stack);
 	else
 		fixup_pgm_int(stack);
 }
 
 void handle_ext_int(struct stack_frame_int *stack)
 {
-	if (!ext_int_expected &&
-	    lowcore.ext_int_code != EXT_IRQ_SERVICE_SIG) {
+	if (!THIS_CPU->ext_int_expected && lowcore.ext_int_code != EXT_IRQ_SERVICE_SIG) {
 		report_abort("Unexpected external call interrupt (code %#x): on cpu %d at %#lx",
 			     lowcore.ext_int_code, stap(), lowcore.ext_old_psw.addr);
 		return;
@@ -210,11 +252,14 @@ void handle_ext_int(struct stack_frame_int *stack)
 		stack->crs[0] &= ~(1UL << 9);
 		sclp_handle_ext();
 	} else {
-		ext_int_expected = false;
+		THIS_CPU->ext_int_expected = false;
 	}
 
 	if (!(stack->crs[0] & CR0_EXTM_MASK))
 		lowcore.ext_old_psw.mask &= ~PSW_MASK_EXT;
+
+	if (THIS_CPU->ext_cleanup_func)
+		THIS_CPU->ext_cleanup_func(stack);
 }
 
 void handle_mcck_int(void)
diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
index a0495cd9..0d98c17d 100644
--- a/lib/s390x/smp.c
+++ b/lib/s390x/smp.c
@@ -39,6 +39,15 @@ int smp_query_num_cpus(void)
 	return sclp_get_cpu_num();
 }
 
+struct lowcore *smp_get_lowcore(uint16_t idx)
+{
+	if (THIS_CPU->idx == idx)
+		return &lowcore;
+
+	check_idx(idx);
+	return cpus[idx].lowcore;
+}
+
 int smp_sigp(uint16_t idx, uint8_t order, unsigned long parm, uint32_t *status)
 {
 	check_idx(idx);
@@ -253,6 +262,7 @@ static int smp_cpu_setup_nolock(uint16_t idx, struct psw psw)
 
 	/* Copy all exception psws. */
 	memcpy(lc, cpus[0].lowcore, 512);
+	lc->this_cpu = &cpus[idx];
 
 	/* Setup stack */
 	cpus[idx].stack = (uint64_t *)alloc_pages(2);
@@ -325,6 +335,7 @@ void smp_setup(void)
 	for (i = 0; i < num; i++) {
 		cpus[i].addr = entry[i].address;
 		cpus[i].active = false;
+		cpus[i].idx = i;
 		/*
 		 * Fill in the boot CPU. If the boot CPU is not at index 0,
 		 * swap it with the one at index 0. This guarantees that the
diff --git a/s390x/skrf.c b/s390x/skrf.c
index 26f70b4e..4cb563c3 100644
--- a/s390x/skrf.c
+++ b/s390x/skrf.c
@@ -119,7 +119,7 @@ static void set_flag(int val)
 	mb();
 }
 
-static void ecall_cleanup(void)
+static void ecall_cleanup(struct stack_frame_int *stack)
 {
 	lowcore.ext_new_psw.mask = PSW_MASK_64;
 	lowcore.sw_int_crs[0] = BIT_ULL(CTL0_AFP);
-- 
2.36.1

