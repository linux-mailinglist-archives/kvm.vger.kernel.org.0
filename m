Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728845F1800
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiJABOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiJABNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD65052D
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-356a9048111so25477457b3.6
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=O5rbGvlbIIPD3OFir3IbfMTdhXoDT3U4VQf8r61cfVk=;
        b=FyG/AvlZGBby/ZTFwvRhhiTm1zGCP4RAbyl4Cgvb5aYklb/m+kcCxkA1GLnH24otfg
         EoW3wx7cP/SMFN+VBeinThPEDFKf21GNKNA5NjxF4jPikI1fS2GJCddlyQlZl+Cr0PUb
         tU7xMSUiOshoTdi02YKhke4Rml1a2tkjPnVbG5XLEKCPrD1/OX96h17zOLCy/d7Yc/vs
         P3e1C0nkpUFM9U356bTnnHgyDl4UoJCgCE+zCM5eMDnp8udfQgTMX5rSfL7HA3aTZEkO
         rBkCWAABegmsOcGMC/L1UQMYsmdSyxYJr/eH0Nz26jXULeD/VsMZJqC93BrhijCk+yCo
         TH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=O5rbGvlbIIPD3OFir3IbfMTdhXoDT3U4VQf8r61cfVk=;
        b=lGhzrd8AaHhAukbGH8+mqdc7fwV3p1SHaOCPSYi9hpR7ZLSFjpZR1iPZTjXf6DhMAG
         FCxswBthp6ywRjt/7Rgz4VyNuA5886gpm9ZEiGHIIuyMpSuogAusg7yfqbHAV0Fj6Tai
         YfXBJz+UvOroKd47llZijhbWV/Xnd/rLW5WyS+SkFSf1etHLElV4UhaNmbIPQLoutBKX
         CHf4UbhS/KcvSHkAJAxU5Eu8vDwtPVYMvFuOSuYYI5Jx0Eh6y5LI948yVFIO4Bf0wL/m
         0oJaPXz11Rs9bmhBv804M0O5eMlazJUER6P6yx509tCKPNNy6viOoklPyII2JlUx2hKj
         t6Ew==
X-Gm-Message-State: ACrzQf3u9YhxP7mGVqvl4cZukGkRfqvFxUAEVOerpfwu6zXD3VAG+0Ob
        7xDbvbEu7S+WWAQD2IVbyBAZnUZ4KDI=
X-Google-Smtp-Source: AMsMyM4JVQwcK7XHH4cG9hL5nHudngILEOKoLDjbCYhpyHekZEbBJR4/AAuCepmC3Yc84/paTUPEFqShSzY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8c89:0:b0:6b4:75f3:8e6c with SMTP id
 m9-20020a258c89000000b006b475f38e6cmr11041216ybl.156.1664586788250; Fri, 30
 Sep 2022 18:13:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:55 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/9] x86/apic: Add helpers to query current
 APIC state, e.g. xAPIC vs. x2APIC
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

Add helpers to query APIC state and use them to replace a bunch of open
coded instances.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index f038198..650c1d0 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -10,6 +10,21 @@
 
 #define MAX_TPR			0xf
 
+static bool is_apic_hw_enabled(void)
+{
+	return rdmsr(MSR_IA32_APICBASE) & APIC_EN;
+}
+
+static bool is_x2apic_enabled(void)
+{
+	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD);
+}
+
+static bool is_xapic_enabled(void)
+{
+	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN;
+}
+
 static void test_lapic_existence(void)
 {
 	u8 version;
@@ -143,14 +158,13 @@ static void test_apic_disable(void)
 	assert_msg(orig_apicbase & APIC_EN, "APIC not enabled.");
 
 	disable_apic();
-	report(!(rdmsr(MSR_IA32_APICBASE) & APIC_EN), "Local apic disabled");
+	report(!is_apic_hw_enabled(), "Local apic disabled");
 	report(!this_cpu_has(X86_FEATURE_APIC),
 	       "CPUID.1H:EDX.APIC[bit 9] is clear");
 	verify_disabled_apic_mmio();
 
 	reset_apic();
-	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
-	       "Local apic enabled in xAPIC mode");
+	report(is_xapic_enabled(), "Local apic enabled in xAPIC mode");
 	report(this_cpu_has(X86_FEATURE_APIC), "CPUID.1H:EDX.APIC[bit 9] is set");
 	report(*lvr == apic_version, "*0xfee00030: %x", *lvr);
 	report(*tpr == cr8, "*0xfee00080: %x", *tpr);
@@ -160,8 +174,7 @@ static void test_apic_disable(void)
 
 	if (enable_x2apic()) {
 		apic_write(APIC_SPIV, 0x1ff);
-		report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
-		       "Local apic enabled in x2APIC mode");
+		report(is_x2apic_enabled(), "Local apic enabled in x2APIC mode");
 		report(this_cpu_has(X86_FEATURE_APIC),
 		       "CPUID.1H:EDX.APIC[bit 9] is set");
 		verify_disabled_apic_mmio();
@@ -211,7 +224,7 @@ static void __test_apic_id(void * unused)
 	u32 id, newid;
 	u8  initial_xapic_id = cpuid(1).b >> 24;
 	u32 initial_x2apic_id = cpuid(0xb).d;
-	bool x2apic_mode = rdmsr(MSR_IA32_APICBASE) & APIC_EXTD;
+	bool x2apic_mode = is_x2apic_enabled();
 
 	if (x2apic_mode)
 		reset_apic();
@@ -282,21 +295,20 @@ static void __test_self_ipi(void)
 
 static void test_self_ipi_xapic(void)
 {
-	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 was_x2apic = is_x2apic_enabled();
 
 	report_prefix_push("self_ipi_xapic");
 
 	/* Reset to xAPIC mode. */
 	reset_apic();
-	report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN,
-	       "Local apic enabled in xAPIC mode");
+	report(is_xapic_enabled(), "Local apic enabled in xAPIC mode");
 
 	ipi_count = 0;
 	__test_self_ipi();
 	report(ipi_count == 1, "self ipi");
 
 	/* Enable x2APIC mode if it was already enabled. */
-	if (orig_apicbase & APIC_EXTD)
+	if (was_x2apic)
 		enable_x2apic();
 
 	report_prefix_pop();
@@ -304,20 +316,19 @@ static void test_self_ipi_xapic(void)
 
 static void test_self_ipi_x2apic(void)
 {
-	u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
+	u64 was_xapic = is_xapic_enabled();
 
 	report_prefix_push("self_ipi_x2apic");
 
 	if (enable_x2apic()) {
-		report((rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD),
-			"Local apic enabled in x2APIC mode");
+		report(is_x2apic_enabled(), "Local apic enabled in x2APIC mode");
 
 		ipi_count = 0;
 		__test_self_ipi();
 		report(ipi_count == 1, "self ipi");
 
 		/* Reset to xAPIC mode unless x2APIC was already enabled. */
-		if (!(orig_apicbase & APIC_EXTD))
+		if (was_xapic)
 			reset_apic();
 	} else {
 		report_skip("x2apic not detected");
-- 
2.38.0.rc1.362.ged0d419d3c-goog

