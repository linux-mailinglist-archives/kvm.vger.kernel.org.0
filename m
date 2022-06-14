Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47EF54BB85
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350914AbiFNUHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351433AbiFNUHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CF86164
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:26 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h7-20020a63e147000000b00408948ba461so2669704pgk.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/Py9Wl5goNG9EkafS3McJwH0IeUf3VIZaz2X9X8WLpo=;
        b=UDJlKpJOmkqypxjrLa7Npl/zLUFzASy7rj0pC/Jb0WCdVMh8xrKERa5N7sAKFQ5l01
         a95GCVmTMRuVq070UaKKxwcSu3NEkA8xGX/2K4qW2IiqD0I1JZD3nfWdKzMsyF2KOBdc
         IYk0lizeekO8DOxdbYVBT1z8BJrJl06o1A0Si8kOAP7pJxqMk84ub2SMQuvkUKSfzVx7
         wXPPRzmZLnp4Qv5HF7Au65eHTmhXUsIV5wJ3JoUSgjHNmKgVJB95diRRu77bzYYoyJPM
         zxLjBBXuEx9J6V0ayjToVGDaVo8+CGoEWv8jNjCQp7I1ghKa1b98qpVR3PTLrwdHIYcK
         /ExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/Py9Wl5goNG9EkafS3McJwH0IeUf3VIZaz2X9X8WLpo=;
        b=JcH9uu1Y8M74OnFOX7QUD/cK22iZVtPGYZ+OGj8aSaO8FAOoRIIIBBaln3etVpF5GG
         GddgBgEaJTDUsyq/3GYIoBaV5p0MFNxz54jpbq+S9hloqI1x7pgmN2bkdwQbA6kCymA9
         +4vv6Au4h3edVNvwj7HeuYgWuUTvbNg2wjAOccrWig7Pv0UiYAxMizyAVY+djZuapXl1
         FJy3KO/1YsZ6+8/pi47j6J970h7wpJAZ5UJBztKoFmtx+LbgtfNJ//tQSIjDvysnFDkZ
         dJANsrtMlLz4fM0Yw94uA2rXyO/yid3ijxQ5Qla18P6hF61i9gEai2YUO5S0a6xI2Y2H
         blgg==
X-Gm-Message-State: AJIora8ltUQ06ldl0sk8cFV2PVQAKG7mMMSXey1g8ugXZ8Wrv3fg5VUT
        a/OGgVn4WWyi/hVy5pygaJJhi3uISc4=
X-Google-Smtp-Source: AGRyM1sotNG6tjyoxS7kiO4PovYl0UZv23UCjHzxQyjTWMOc6aF2Af5Ca5lzgT1YeCt1ZTBSvaftpXBbWTk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr192336pja.1.1655237245815; Tue, 14 Jun
 2022 13:07:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:32 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 07/42] KVM: selftests: Use kvm_cpu_has() to query PDCM in
 PMU selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use kvm_cpu_has() in the PMU test to query PDCM support instead of open
coding equivalent functionality using kvm_get_supported_cpuid_index().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e1f9aa34f90a..9fe2a9534686 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -79,6 +79,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_MWAIT		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 3)
 #define	X86_FEATURE_VMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 5)
 #define	X86_FEATURE_SMX			KVM_X86_CPU_FEATURE(0x1, 0, ECX, 6)
+#define	X86_FEATURE_PDCM		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 15)
 #define	X86_FEATURE_PCID		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 17)
 #define	X86_FEATURE_MOVBE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 22)
 #define	X86_FEATURE_TSC_DEADLINE_TIMER	KVM_X86_CPU_FEATURE(0x1, 0, ECX, 24)
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index eb592fae44ef..667d48e8c1e0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -17,7 +17,6 @@
 #include "kvm_util.h"
 #include "vmx.h"
 
-#define X86_FEATURE_PDCM	(1<<15)
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
 #define PMU_CAP_LBR_FMT		0x3f
 
@@ -55,7 +54,6 @@ static void guest_code(void)
 int main(int argc, char *argv[])
 {
 	struct kvm_cpuid2 *cpuid;
-	struct kvm_cpuid_entry2 *entry_1_0;
 	struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -70,11 +68,10 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	cpuid = kvm_get_supported_cpuid();
 
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
-
-	entry_1_0 = kvm_get_supported_cpuid_index(1, 0);
 	entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
-	TEST_REQUIRE(entry_1_0->ecx & X86_FEATURE_PDCM);
 
 	eax.full = entry_a_0->eax;
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
-- 
2.36.1.476.g0c4daa206d-goog

