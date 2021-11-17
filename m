Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA2454246
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 09:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhKQIGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 03:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKQIGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 03:06:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E9FC061570;
        Wed, 17 Nov 2021 00:03:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so4602911pja.1;
        Wed, 17 Nov 2021 00:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iAec7dX6paqqylAPJYmrr3gF9uJOlk5ObTezi2q4dtY=;
        b=TpDrYx/7yrgIWVSAo4xUFPBS0dA8o/n4tUkB/bVlGacZI8P7Nrb5Is++tV8ea9Mwak
         V2p7wGheQJcs45nNuRLBSLUxCmiJRS1mFJ/JjTy+24Nk8JgtQup8B++C/HDQZsNCvnnc
         kOhFti5JBiWRDK8S4KwkaF/7eTw4ul79XVXPSAkJY3Cfcug/l9W97Nuv2/sRtfj3yWMm
         mO5Z7EHa440Z8e2g8rTPAKZM42u/CPW/tFpbgzHRmgF6P6RnjcVXSNSrvIferja7D7en
         L8fxfnszldcfFmz0tKNCRUXlefFQwBBQYlYN6stQHQ4Of+7QGEbHhEuZxeNAUeNZm1uX
         COYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iAec7dX6paqqylAPJYmrr3gF9uJOlk5ObTezi2q4dtY=;
        b=O88QIXFA3TInfjdTPJSLP1GROkqiTFwyP6Ot2qd6xGAeHAarZT3WlV58P4L8Dtoa3T
         LT1KuC1Y2hS8ZT0GzX7GyHVqKyR8V6q3qmGIUlBkzGV9BokMeY9ZpBACjbLO9FYHjbOK
         gXVAElDiGJg2qwLwQVwBjUxvA8AMBd6cVGb6xRTSLhZeyulboy719KZhMXc4scu+umjZ
         CW4z6OZN3iPP+MsFhepwwlw65a2kFKvLog7BN2gmoquQ+Z6n3lrfQf8VbqIRpr3P/3wY
         1/JLMNmu4tf4cqEbNowo7R+mMlBrkwZrqzCjXP2/QwIAowmY/m42bdgxcPVivMJDEC1W
         QSUQ==
X-Gm-Message-State: AOAM532BwbKCtMrHD3BUfFpBdeZ3zhl4uF6my9lbfD8XwQS1bWaq4qLN
        5Qd7Xg1cs5WmUCMaBPvRaI8=
X-Google-Smtp-Source: ABdhPJwrfjd5YUxHD/E4An0YGF1xel0rO/TageeZ9rglOjTYqV2PbFvPfL/5PmsONArSss308Su59Q==
X-Received: by 2002:a17:90a:c58e:: with SMTP id l14mr7218764pjt.214.1637136203796;
        Wed, 17 Nov 2021 00:03:23 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i129sm2866776pfe.2.2021.11.17.00.03.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Nov 2021 00:03:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/svm: Add module param to control PMU virtualization
Date:   Wed, 17 Nov 2021 16:03:04 +0800
Message-Id: <20211117080304.38989-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

For Intel, the guest PMU can be disabled via clearing the PMU CPUID.
For AMD, all hw implementations support the base set of four
performance counters, with current mainstream hardware indicating
the presence of two additional counters via X86_FEATURE_PERFCTR_CORE.

In the virtualized world, the AMD guest driver may detect
the presence of at least one counter MSR. Most hypervisor
vendors would introduce a module param (like lbrv for svm)
to disable PMU for all guests.

Another control proposal per-VM is to pass PMU disable information
via MSR_IA32_PERF_CAPABILITIES or one bit in CPUID Fn4000_00[FF:00].
Both of methods require some guest-side changes, so a module
parameter may not be sufficiently granular, but practical enough.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c   |  2 +-
 arch/x86/kvm/svm/pmu.c |  4 ++++
 arch/x86/kvm/svm/svm.c | 11 +++++++++++
 arch/x86/kvm/svm/svm.h |  1 +
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..647af2a184ad 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -487,7 +487,7 @@ void kvm_set_cpu_caps(void)
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
 		F(3DNOWPREFETCH) | F(OSVW) | 0 /* IBS */ | F(XOP) |
 		0 /* SKINIT, WDT, LWP */ | F(FMA4) | F(TBM) |
-		F(TOPOEXT) | F(PERFCTR_CORE)
+		F(TOPOEXT) | 0 /* PERFCTR_CORE */
 	);
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fdf587f19c5f..a0bcf0144664 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -16,6 +16,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "pmu.h"
+#include "svm.h"
 
 enum pmu_type {
 	PMU_TYPE_COUNTER = 0,
@@ -100,6 +101,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
+	if (!pmuv)
+		return NULL;
+
 	switch (msr) {
 	case MSR_F15H_PERF_CTL0:
 	case MSR_F15H_PERF_CTL1:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21bb81710e0f..062e48c191ee 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -190,6 +190,10 @@ module_param(vgif, int, 0444);
 static int lbrv = true;
 module_param(lbrv, int, 0444);
 
+/* enable/disable PMU virtualization */
+bool pmuv = true;
+module_param(pmuv, bool, 0444);
+
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -952,6 +956,10 @@ static __init void svm_set_cpu_caps(void)
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
+	/* AMD PMU PERFCTR_CORE CPUID */
+	if (pmuv && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+
 	/* CPUID 0x8000001F (SME/SEV features) */
 	sev_set_cpu_caps();
 }
@@ -1085,6 +1093,9 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
+	if (!pmuv)
+		pr_info("PMU virtualization is disabled\n");
+
 	svm_set_cpu_caps();
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0d7bbe548ac3..08e1c19ffbdf 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -32,6 +32,7 @@
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
+extern bool pmuv;
 
 /*
  * Clean bits in VMCB.
-- 
2.33.1

