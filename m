Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB9E5F5D55
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 01:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiJEXw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 19:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJEXwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 19:52:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5436B82616
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 16:52:20 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so3391857b3.10
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 16:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Xw31e+TGRP2/+OxpnSpZnYUCdGsM9rcAKkyhAayOrSA=;
        b=P8zPkRQqiRIojV0GYvPmtlWYWoqmhVXvVbeZZWDNPYKhEwC1jxhbKGzAXCgWE6TAk/
         bQoD9ZeSpRV349F7T4/+Zd2hLvWBwqZrXbkPGenma4AA71zitGW4tq+GcU/7lWQp64Jl
         hcXLQOnzdWeUMKDSjlXhsY0L8RQzdFNiIfLVzTh6N1Qh8z34lM77fttMRz7dDZnV/Ymm
         yAef2Qkm0zlx25gd89CeAYOPm30VuNMw6gX+7cOf+G5cKziegcXACLumJNynO5pPMae1
         gMmaMX1Qy409Imem+L9/JN4x0Xzf/6geVirDa0Z0j0tG9Iwr6mb5Vzb3kC5PeRZBRgE5
         hj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xw31e+TGRP2/+OxpnSpZnYUCdGsM9rcAKkyhAayOrSA=;
        b=tlCjPfbe5ruxEJLUreeVtOGoiPujlqVVI0DrAR0B3KyZKOO0cxox4/UEFqkOjU4art
         teS5hYmZujpyKtm2da4iGcKJuNMSgxkCb/8bDyaWWMfzeG3gLIBN4d2QnAyEY/N61cz+
         sOVPOJeNtbn5hyDwrLLwxVN9EnMfuWO2LDHw5JuiKBuNRIRIZ+iwwDVG0+gGt0Nq8JPr
         jnYzQaUFIPSx6esIdy1O+jCaEJknshsSe9Un2HsBMQhnTUoknjXuT5ypMW2S8h5Z9qcA
         MTTdJPiHviJvDd/UAE6fQu6CTGvLE90tNijlGpbKBhg1st5kkKMFhjzxbNeDdAs37w1t
         +xjQ==
X-Gm-Message-State: ACrzQf2zbUhg3P3Q67cKVFlFM97sS9yoS3x4Yd1XRhY8kKJYdgTXYCbv
        GjbHLbf24MxLWUWmPijsMs4LNAfOOuw=
X-Google-Smtp-Source: AMsMyM4kIx/ATDClr2BzaA5yNHWOpSMAzcEsoGq0iz81/GqnzMDcqNimzZ4ksUe7c35Clkdw4Q2kwtq57NI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:40ce:0:b0:6be:79b3:51ac with SMTP id
 n197-20020a2540ce000000b006be79b351acmr2319075yba.635.1665013939583; Wed, 05
 Oct 2022 16:52:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Oct 2022 23:52:06 +0000
In-Reply-To: <20221005235212.57836-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221005235212.57836-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005235212.57836-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v3 3/9] nVMX: Move #OF test to generic
 exceptions test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Manali Shukla <manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the INTO=>#OF test, along with its more precise checking of the
exit interrupt info, to the generic nVMX exceptions test.

Move the  helper that generates #OF to processor.h so that it can be
reused by nSVM for an identical test.

Note, this effectively adds new checks for all other vectors, i.e.
affects more vectors than just #OF.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 35 +++++++++++++++++++++++
 x86/vmx_tests.c     | 67 +++++++++------------------------------------
 2 files changed, 48 insertions(+), 54 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index c3d112f..5865933 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -834,6 +834,41 @@ static inline uint64_t generate_usermode_ac(void)
 	return 0;
 }
 
+/*
+ * Switch from 64-bit to 32-bit mode and generate #OF via INTO.  Note, if RIP
+ * or RSP holds a 64-bit value, this helper will NOT generate #OF.
+ */
+static inline void generate_of(void)
+{
+	struct far_pointer32 fp = {
+		.offset = (uintptr_t)&&into,
+		.selector = KERNEL_CS32,
+	};
+	uintptr_t rsp;
+
+	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
+
+	if (fp.offset != (uintptr_t)&&into) {
+		printf("Code address too high.\n");
+		return;
+	}
+	if ((u32)rsp != rsp) {
+		printf("Stack address too high.\n");
+		return;
+	}
+
+	asm goto ("lcall *%0" : : "m" (fp) : "rax" : into);
+	return;
+into:
+	asm volatile (".code32;"
+		      "movl $0x7fffffff, %eax;"
+		      "addl %eax, %eax;"
+		      "into;"
+		      "lret;"
+		      ".code64");
+	__builtin_unreachable();
+}
+
 static inline u8 pmu_version(void)
 {
 	return cpuid(10).a & 0xff;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2ed20ec..edb8062 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2161,57 +2161,6 @@ static int int3_exit_handler(union exit_reason exit_reason)
 	return VMX_TEST_VMEXIT;
 }
 
-static int into_init(struct vmcs *vmcs)
-{
-	vmcs_write(EXC_BITMAP, ~0u);
-	return VMX_TEST_START;
-}
-
-static void into_guest_main(void)
-{
-	struct far_pointer32 fp = {
-		.offset = (uintptr_t)&&into,
-		.selector = KERNEL_CS32,
-	};
-	uintptr_t rsp;
-
-	asm volatile ("mov %%rsp, %0" : "=r"(rsp));
-
-	if (fp.offset != (uintptr_t)&&into) {
-		printf("Code address too high.\n");
-		return;
-	}
-	if ((u32)rsp != rsp) {
-		printf("Stack address too high.\n");
-		return;
-	}
-
-	asm goto ("lcall *%0" : : "m" (fp) : "rax" : into);
-	return;
-into:
-	asm volatile (".code32;"
-		      "movl $0x7fffffff, %eax;"
-		      "addl %eax, %eax;"
-		      "into;"
-		      "lret;"
-		      ".code64");
-	__builtin_unreachable();
-}
-
-static int into_exit_handler(union exit_reason exit_reason)
-{
-	u32 intr_info = vmcs_read(EXI_INTR_INFO);
-
-	report(exit_reason.basic == VMX_EXC_NMI &&
-	       (intr_info & INTR_INFO_VALID_MASK) &&
-	       (intr_info & INTR_INFO_VECTOR_MASK) == OF_VECTOR &&
-	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >>
-	        INTR_INFO_INTR_TYPE_SHIFT) == VMX_INTR_TYPE_SOFT_EXCEPTION,
-	       "L1 intercepts #OF");
-
-	return VMX_TEST_VMEXIT;
-}
-
 static void exit_monitor_from_l2_main(void)
 {
 	printf("Calling exit(0) from l2...\n");
@@ -10741,6 +10690,7 @@ struct vmx_exception_test vmx_exception_tests[] = {
 	{ DB_VECTOR, generate_single_step_db },
 	{ BP_VECTOR, generate_bp },
 	{ AC_VECTOR, vmx_l2_ac_test },
+	{ OF_VECTOR, generate_of },
 };
 
 static u8 vmx_exception_test_vector;
@@ -10769,14 +10719,24 @@ static void handle_exception_in_l2(u8 vector)
 static void handle_exception_in_l1(u32 vector)
 {
 	u32 old_eb = vmcs_read(EXC_BITMAP);
+	u32 intr_type;
+	u32 intr_info;
 
 	vmcs_write(EXC_BITMAP, old_eb | (1u << vector));
 
 	enter_guest();
 
+	if (vector == BP_VECTOR || vector == OF_VECTOR)
+		intr_type = VMX_INTR_TYPE_SOFT_EXCEPTION;
+	else
+		intr_type = VMX_INTR_TYPE_HARD_EXCEPTION;
+
+	intr_info = vmcs_read(EXI_INTR_INFO);
 	report((vmcs_read(EXI_REASON) == VMX_EXC_NMI) &&
-	       ((vmcs_read(EXI_INTR_INFO) & 0xff) == vector),
-	       "%s handled by L1", exception_mnemonic(vector));
+	       (intr_info & INTR_INFO_VALID_MASK) &&
+	       (intr_info & INTR_INFO_VECTOR_MASK) == vector &&
+	       ((intr_info & INTR_INFO_INTR_TYPE_MASK) >> INTR_INFO_INTR_TYPE_SHIFT) == intr_type,
+	       "%s correctly routed to L1", exception_mnemonic(vector));
 
 	vmcs_write(EXC_BITMAP, old_eb);
 }
@@ -10836,7 +10796,6 @@ struct vmx_test vmx_tests[] = {
 	{ "disable RDTSCP", disable_rdtscp_init, disable_rdtscp_main,
 		disable_rdtscp_exit_handler, NULL, {0} },
 	{ "int3", int3_init, int3_guest_main, int3_exit_handler, NULL, {0} },
-	{ "into", into_init, into_guest_main, into_exit_handler, NULL, {0} },
 	{ "exit_monitor_from_l2_test", NULL, exit_monitor_from_l2_main,
 		exit_monitor_from_l2_handler, NULL, {0} },
 	{ "invalid_msr", invalid_msr_init, invalid_msr_main,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

