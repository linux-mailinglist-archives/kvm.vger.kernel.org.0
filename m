Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9535F1802
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiJABOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiJABNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:51 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148DBF027
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 88-20020a17090a09e100b00208c35d9452so3074693pjo.6
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=JvKsep8llHvor/s05gir9lti0qYYQp8Nq7Cl7Mhl79s=;
        b=rbQ5SZxRfYxezW8FiOKdJsbc3bMbILJtwl9jJOm4Q0HgJWxKf0QYDjNVzbVgrhM537
         V7nz9C+BET4No/aWCc00+dQXCRE+3ufb4yUf2Ludanfs6a1LCgqkJeow8/xbegg/EBI2
         zTp/W5OFsRp0jIJdwff9wpuo+42LylJ2kYhOGgzV8Q8dZCmoF4oBKFEX2BxFjUB1i1Xe
         GqbVJJ/PbFYxhLVgSE1tSlHR9p1ylrwCaCgtUrBUZ83iF3PVOkbb54ydOS5EiPwPCi+4
         XiltyDjfrCUQLe3qnx1BlUNQgQ4r2HZRtsTioT1BIvVz5B+hcd+/ecCcBedgECkGUkD5
         JZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=JvKsep8llHvor/s05gir9lti0qYYQp8Nq7Cl7Mhl79s=;
        b=B6MhVe2R+SeLVarcFcqQl0+5HeSrOB1UsvzICHV88M16kLMl/jiPg8tdKze36cqhw+
         VQmncEB1EhjHhkMFeHBIgR/9C586yuC63SikLWMPB5TARrBOJ7deCEboxOav6X8zaEWc
         /5r+MLVujZs2YEfjPikNff+0VqheN8KR4/eehv3drKR8z1oWY7ICMSQl3J2+GPmdSWbS
         bihWNDDgWAiKZFZvAFAY7Bsl6kPM46XkQ7SIzhEYJC9skbCGvSIQcE45V+VfhWkSOrh8
         NEpw4Vi8Ec0v86r5/Rj6PDkHGI4AFZpcIMLuajVnTcIxvwUCtoxXB/7KvblcM3pADcue
         f6/g==
X-Gm-Message-State: ACrzQf3swdM2tVtXMorOtO77o01SpH2F2kiYBO13FtGXkU/N4VZ2O+Pg
        z/+0I5hw5PVJC1cV4Q4+uR3N0s2jbyE=
X-Google-Smtp-Source: AMsMyM4b/pssSTpheYe/VuOK0WhPFRguD4ywGeny45lk4yfevMSEEL8/QNIvuwbiulYzgXj1O7x3UiNTMSw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c1:b0:176:c2b3:6a4c with SMTP id
 u1-20020a170902e5c100b00176c2b36a4cmr11648279plf.87.1664586791617; Fri, 30
 Sep 2022 18:13:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:57 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/9] x86/apic: Restore APIC to original state
 after every sub-test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Restore the APIC to its original state after every APIC sub-test.  Many
of the tests already do (parts of) this manually, while others do not.
Always restore to dedup code and to avoid cross-test dependencies.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 92 +++++++++++++++++++++++++-----------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index 6c555ce..e466a57 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -94,13 +94,12 @@ static bool test_write_apicbase_exception(u64 data)
 
 static void test_enable_x2apic(void)
 {
-	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
-	u64 apicbase;
+	u64 apicbase = rdmsr(MSR_IA32_APICBASE);
 
 	if (enable_x2apic()) {
 		printf("x2apic enabled\n");
 
-		apicbase = orig_apicbase & ~(APIC_EN | APIC_EXTD);
+		apicbase &= ~(APIC_EN | APIC_EXTD);
 		report(test_write_apicbase_exception(apicbase | APIC_EXTD),
 			"x2apic enabled to invalid state");
 		report(test_write_apicbase_exception(apicbase | APIC_EN),
@@ -117,17 +116,6 @@ static void test_enable_x2apic(void)
 			"apic disabled to apic enabled");
 		report(test_write_apicbase_exception(apicbase | APIC_EXTD),
 			"apic enabled to invalid state");
-
-		if (orig_apicbase & APIC_EXTD)
-			enable_x2apic();
-		else
-			reset_apic();
-
-		/*
-		 * Disabling the APIC resets various APIC registers, restore
-		 * them to their desired values.
-		 */
-		apic_write(APIC_SPIV, 0x1ff);
 	} else {
 		printf("x2apic not detected\n");
 
@@ -155,12 +143,10 @@ static void test_apic_disable(void)
 {
 	volatile u32 *lvr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_LVR);
 	volatile u32 *tpr = (volatile u32 *)(APIC_DEFAULT_PHYS_BASE + APIC_TASKPRI);
-	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
 	u32 apic_version = apic_read(APIC_LVR);
 	u32 cr8 = read_cr8();
 
 	report_prefix_push("apic_disable");
-	assert_msg(orig_apicbase & APIC_EN, "APIC not enabled.");
 
 	disable_apic();
 	report(!is_apic_hw_enabled(), "Local apic disabled");
@@ -178,13 +164,10 @@ static void test_apic_disable(void)
 	write_cr8(cr8);
 
 	if (enable_x2apic()) {
-		apic_write(APIC_SPIV, 0x1ff);
 		report(is_x2apic_enabled(), "Local apic enabled in x2APIC mode");
 		report(this_cpu_has(X86_FEATURE_APIC),
 		       "CPUID.1H:EDX.APIC[bit 9] is set");
 		verify_disabled_apic_mmio();
-		if (!(orig_apicbase & APIC_EXTD))
-			reset_apic();
 	}
 	report_prefix_pop();
 }
@@ -213,8 +196,8 @@ static void test_apicbase(void)
 	report(test_for_exception(GP_VECTOR, do_write_apicbase, &value),
 	       "reserved low bits");
 
+	/* Restore the APIC address, the "reset" helpers leave it as is. */
 	wrmsr(MSR_IA32_APICBASE, orig_apicbase);
-	apic_write(APIC_SPIV, 0x1ff);
 
 	report_prefix_pop();
 }
@@ -300,8 +283,6 @@ static void __test_self_ipi(void)
 
 static void test_self_ipi_xapic(void)
 {
-	u64 was_x2apic = is_x2apic_enabled();
-
 	report_prefix_push("self_ipi_xapic");
 
 	/* Reset to xAPIC mode. */
@@ -312,17 +293,11 @@ static void test_self_ipi_xapic(void)
 	__test_self_ipi();
 	report(ipi_count == 1, "self ipi");
 
-	/* Enable x2APIC mode if it was already enabled. */
-	if (was_x2apic)
-		enable_x2apic();
-
 	report_prefix_pop();
 }
 
 static void test_self_ipi_x2apic(void)
 {
-	u64 was_xapic = is_xapic_enabled();
-
 	report_prefix_push("self_ipi_x2apic");
 
 	if (enable_x2apic()) {
@@ -331,10 +306,6 @@ static void test_self_ipi_x2apic(void)
 		ipi_count = 0;
 		__test_self_ipi();
 		report(ipi_count == 1, "self ipi");
-
-		/* Reset to xAPIC mode unless x2APIC was already enabled. */
-		if (was_xapic)
-			reset_apic();
 	} else {
 		report_skip("x2apic not detected");
 	}
@@ -690,38 +661,61 @@ static void test_pv_ipi(void)
 	int ret;
 	unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
 
+	if (!test_device_enabled())
+		return;
+
 	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	report(!ret, "PV IPIs testing");
 }
 
+typedef void (*apic_test_fn)(void);
+
 int main(void)
 {
+	bool is_x2apic = is_x2apic_enabled();
+	u32 spiv = apic_read(APIC_SPIV);
+	int i;
+
+	const apic_test_fn tests[] = {
+		test_lapic_existence,
+
+		test_apic_id,
+		test_apic_disable,
+		test_enable_x2apic,
+		test_apicbase,
+
+		test_self_ipi_xapic,
+		test_self_ipi_x2apic,
+		test_physical_broadcast,
+
+		test_pv_ipi,
+
+		test_sti_nmi,
+		test_multiple_nmi,
+		test_pending_nmi,
+
+		test_apic_timer_one_shot,
+		test_apic_change_mode,
+		test_tsc_deadline_timer,
+	};
+
 	assert_msg(is_apic_hw_enabled() && is_apic_sw_enabled(),
 		   "APIC should be fully enabled by startup code.");
 
 	setup_vm();
 
-	test_lapic_existence();
-
 	mask_pic_interrupts();
-	test_apic_id();
-	test_apic_disable();
-	test_enable_x2apic();
-	test_apicbase();
 
-	test_self_ipi_xapic();
-	test_self_ipi_x2apic();
-	test_physical_broadcast();
-	if (test_device_enabled())
-		test_pv_ipi();
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		tests[i]();
 
-	test_sti_nmi();
-	test_multiple_nmi();
-	test_pending_nmi();
+		if (is_x2apic)
+			enable_x2apic();
+		else
+			reset_apic();
 
-	test_apic_timer_one_shot();
-	test_apic_change_mode();
-	test_tsc_deadline_timer();
+		apic_write(APIC_SPIV, spiv);
+	}
 
 	return report_summary();
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

