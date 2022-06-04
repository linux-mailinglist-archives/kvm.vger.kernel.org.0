Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AB53D486
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350269AbiFDBX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350271AbiFDBXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:23:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201C02CC8B
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:12 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id b9-20020a656689000000b003f672946300so4552573pgw.16
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zRnQwmzMhJYRFOk2BpYJxE9o1Wk/uaPq5tbGkr4yB8o=;
        b=CB6KKHeU8XXyGZXIbX7xPsH4SKxTfArunR9G5W48eK0S5G9Kg40lHnU7yb7pxqJYlA
         OuHJlnVVDlDIbxx7rqiFpoohqofryjXt/oX0/vEdzy5F8BFuVcVjmSSRKw054yfDX8MB
         WJ3lob8fGw8MrHsrVOb+LUoMh/ywcbWblskaBDIArLnvZ5Ka/LSv9jYKMOeM3+YQcwfP
         CHIyr7Qoj7OWO3N8w3GIRgtLWmSGTTCrOZHRSI0efsRYUFQQRmFoQOLL01FJJ9SbBQnU
         3JXNhCgOfm1TV0JYqipaVZG4EMz22Vw7gNsEbyW1+FwZi7k4KAV6atHrzFpvEaLkBXWm
         HjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zRnQwmzMhJYRFOk2BpYJxE9o1Wk/uaPq5tbGkr4yB8o=;
        b=R+WG2ghEw48rEvcLiopustJznFhYaRuXu4rTQldW8XGy8/b4DMorBBxDllrFs9lv9r
         KPxSgFoEUoD6eVGFJ0OQ8ysq8s7XzvZqt+zlCsooqH1MbcRgFItNlRucil6grIZIPYNo
         BI5/giWo5ZBedKc75b0UuRSc4yQFDab98HIEjHT/WAiAmVh56j+IurkMqtVR/cIjExkW
         tz592VKvqhLgBupRfNK0c4fmCSwDcoVP1hnKAeWKUixuaXTRi/5+vfezMbwYQkzZi7c2
         3kYMiCDKOA/TNNWUIZ5anhKyPxWDkWBk/ArGjhKdXUrvcfQ74TVpdhE0DQUh3w33EjRs
         R/Ww==
X-Gm-Message-State: AOAM531GWcysAQ0DnnQLgyneD51xQsS7238+r6j4PKVWQyx9UgCFoIPQ
        nqP62iJtt0445/sBt2TIpaXqKs4KsMM=
X-Google-Smtp-Source: ABdhPJyc75pztoF7EwnBRfDnBKRcklxM/YhAubdHefgT1Peoo3ESR9hq5FR8mpqA13agZKWGI2zELjJYCxY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:ba11:b0:1df:2d09:1308 with SMTP id
 s17-20020a17090aba1100b001df2d091308mr13482968pjr.184.1654305722431; Fri, 03
 Jun 2022 18:22:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:51 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-36-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 35/42] KVM: selftests: Drop unnecessary use of kvm_get_supported_cpuid_index()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_get_supported_cpuid_entry() instead of
kvm_get_supported_cpuid_index() when passing in '0' for the index, which
just so happens to be the case in all remaining users of
kvm_get_supported_cpuid_index() except kvm_get_supported_cpuid_entry().

Keep the helper as there may be users in the future, and it's not doing
any harm.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c              | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 4 ++--
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index a886c9e81b87..411a33cd4296 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -318,7 +318,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA));
 
 	/* Get xsave/restore max size */
-	xsave_restore_size = kvm_get_supported_cpuid_index(0xd, 0)->ecx;
+	xsave_restore_size = kvm_get_supported_cpuid_entry(0xd)->ecx;
 
 	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 5321bfe8b4e9..af018af2d54d 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -376,7 +376,7 @@ static bool use_intel_pmu(void)
 {
 	const struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_get_supported_cpuid_index(0xa, 0);
+	entry = kvm_get_supported_cpuid_entry(0xa);
 	return is_intel_cpu() && check_intel_pmu_leaf(entry);
 }
 
@@ -408,7 +408,7 @@ static bool use_amd_pmu(void)
 {
 	const struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_get_supported_cpuid_index(1, 0);
+	entry = kvm_get_supported_cpuid_entry(1);
 	return is_amd_cpu() &&
 		(is_zen1(entry->eax) ||
 		 is_zen2(entry->eax) ||
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 689517f2aae6..6ec901dab61e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -69,7 +69,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
-	entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
+	entry_a_0 = kvm_get_supported_cpuid_entry(0xa);
 
 	eax.full = entry_a_0->eax;
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
-- 
2.36.1.255.ge46751e96f-goog

