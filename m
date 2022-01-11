Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C233348A888
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 08:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348563AbiAKHif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 02:38:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbiAKHie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 02:38:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B285C06173F;
        Mon, 10 Jan 2022 23:38:34 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo4332183pjb.2;
        Mon, 10 Jan 2022 23:38:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aSFGM/gOtWEIdQ8s/qIWiC6bRqOFDJFspWBP5HCcU2M=;
        b=KO3do/4TL4c1Mx65rpa4UAuDDdPNHh+XqAv14goa1MUM+IJOkbZqIwb0SnYkOHqm2n
         s0IwVqx94REDTtyLLHq8uXbOIdO5cqkHBYj3CWH6yYcJv9rist61zUEEcsTHsnTfokeI
         1Pzae4OL9Q9NH/A4FdZtIfyimZ/zDImJQPs8Z86acp9tMPV0G862XmxARaD9fY3o4LxF
         z4M/Pr+RDb4bXVqxvmVxjwip/HSkJfSrLgffup9M2O8KgLNnEHCBfWkJdm9wJNHzFvks
         KeY65dcSsaupF+/EsXWeDHmyXmjMkfaCNnY8ab3/rl8I8kgMzo1ydHROP+vR8QFiUuT3
         AlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aSFGM/gOtWEIdQ8s/qIWiC6bRqOFDJFspWBP5HCcU2M=;
        b=ni0zGRy+esocccSzOpC3FrRv7S2fHPOjtZ5voQzmpsKLsxAyf9q81DF4nkmN56Jhw+
         5Fee2zoR1oVzMAjkyzmT8DSH3FWw8co0XYiRcpeFRtcSKq44S296NNFjjQ7Ta6IGrM4n
         A1s0R4GCQ5qK1lBiozuff9X+MiT9vbh4q2j6ve8vrLLVd3c2FlGK5j8DFz7oE0ZP37RJ
         LAGphUkuYUlMDSCY8YYRi9oHmCVX2bOX2GnFpwuywva3tlfTsxHiWEKgpAWzkyTQubVc
         BrZgPT9EB24g2SdU/VDKae3ssFEXz7npWAYT9y7JcD7tMbCHAlKigLUoiIU6Q+LAPvyv
         jVOA==
X-Gm-Message-State: AOAM530R+OIBa/UoaWw4ydks+F3y5mvucEyHARUmrIejERAvz/Sgl1Ix
        IPKNmHFgpndvvq7+dYiBjQw=
X-Google-Smtp-Source: ABdhPJzUen6Trd4KsFKQCtsbp1BuxIAeUM+g0wIV8lZagW6Od6HumXP69rDl9zO3iQaT4jL0PR1C4Q==
X-Received: by 2002:a17:902:ceca:b0:14a:3eba:41ed with SMTP id d10-20020a170902ceca00b0014a3eba41edmr3149026plg.118.1641886713988;
        Mon, 10 Jan 2022 23:38:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c19sm4878180pfo.91.2022.01.10.23.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 23:38:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Making the module parameter of vPMU more common
Date:   Tue, 11 Jan 2022 15:38:23 +0800
Message-Id: <20220111073823.21885-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The new module parameter to control PMU virtualization should apply
to Intel as well as AMD, for situations where userspace is not trusted.
If the module parameter allows PMU virtualization, there could be a
new KVM_CAP or guest CPUID bits whereby userspace can enable/disable
PMU virtualization on a per-VM basis.

If the module parameter does not allow PMU virtualization, there
should be no userspace override, since we have no precedent for
authorizing that kind of override. If it's false, other counter-based
profiling features (such as LBR including the associated CPUID bits
if any) will not be exposed.

Change its name from "pmu" to "enable_pmu" as we have temporary
variables with the same name in our code like "struct kvm_pmu *pmu".

Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
Suggested-by : Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c            | 6 +++---
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 8 ++------
 arch/x86/kvm/svm/svm.h          | 1 -
 arch/x86/kvm/vmx/capabilities.h | 4 ++++
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 arch/x86/kvm/x86.c              | 5 +++++
 arch/x86/kvm/x86.h              | 1 +
 8 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..b2ff8bfd8220 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,10 +770,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		perf_get_x86_pmu_capability(&cap);
 
 		/*
-		 * Only support guest architectural pmu on a host
-		 * with architectural pmu.
+		 * The guest architecture pmu is only supported if the architecture
+		 * pmu exists on the host and the module parameters allow it.
 		 */
-		if (!cap.version)
+		if (!cap.version || !enable_pmu)
 			memset(&cap, 0, sizeof(cap));
 
 		eax.split.version_id = min(cap.version, 2);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..5aa45f13b16d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!pmu)
+	if (!enable_pmu)
 		return NULL;
 
 	switch (msr) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6cb38044a860..549f73ce5ebc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -192,10 +192,6 @@ module_param(vgif, int, 0444);
 static int lbrv = true;
 module_param(lbrv, int, 0444);
 
-/* enable/disable PMU virtualization */
-bool pmu = true;
-module_param(pmu, bool, 0444);
-
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -4573,7 +4569,7 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
 	/* AMD PMU PERFCTR_CORE CPUID */
-	if (pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
 
 	/* CPUID 0x8000001F (SME/SEV features) */
@@ -4712,7 +4708,7 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
-	if (!pmu)
+	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
 	svm_set_cpu_caps();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..47ef8f4a9358 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -32,7 +32,6 @@
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
-extern bool pmu;
 
 /*
  * Clean bits in VMCB.
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c8029b7845b6..959b59d13b5a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "x86.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -389,6 +390,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
 
+	if (!enable_pmu)
+		return perf_cap;
+
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ffccfd9823c0..466d18fc0c5d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry)
+	if (!entry || !enable_pmu)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c194a8cbd25f..bff2ff8cb35f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -187,6 +187,11 @@ module_param(force_emulation_prefix, bool, S_IRUGO);
 int __read_mostly pi_inject_timer = -1;
 module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
 
+/* Enable/disable PMU virtualization */
+bool __read_mostly enable_pmu = true;
+EXPORT_SYMBOL_GPL(enable_pmu);
+module_param(enable_pmu, bool, 0444);
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index da7031e80f23..1ebd5a7594da 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -336,6 +336,7 @@ extern u64 host_xcr0;
 extern u64 supported_xcr0;
 extern u64 host_xss;
 extern u64 supported_xss;
+extern bool enable_pmu;
 
 static inline bool kvm_mpx_supported(void)
 {
-- 
2.33.1

