Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7556548BDCD
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 05:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbiALEB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 23:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiALEB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 23:01:28 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DC5C06173F;
        Tue, 11 Jan 2022 20:01:27 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so9311284pjf.3;
        Tue, 11 Jan 2022 20:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d53LL3T6h+D1WTE/NgbxNw9obHcix/vzUSjioj1FtYY=;
        b=KKHzC070zBr/u0XK820VILYr0DngmO75JLFImD1ALRyc45gi3y8tEkvcnURsJylwFj
         vJCM71mAonm6u+AESk4QSQrnABzTUT1bFWGpp6VELGETD5OcR2F+pXzt1/28f73/64c2
         sgd0i2zFh/+04VH/AWpjXLW7OtIjlGFN8vM3sf7/n3gP/PvH1B68aUKAq4Axz2YbgoJF
         BLbeV2RRgP0qhLncExD/+ew12KeYwUWsy61QuHWoR3dbTSolCwP5toFMy4+fTtiYsbpV
         x/FflcOukX2iq2f+5aV77reuBXJs0I/gpfyFz67OYK69v+6FpIuw4/0/HpMhSGnIpsH9
         jLoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d53LL3T6h+D1WTE/NgbxNw9obHcix/vzUSjioj1FtYY=;
        b=clsD+GfR+AMDnAF6CN1FBjjoL4KbEGPLzCk1QQABv1QWmhfPjQcPHs7fqyUPohbEK2
         /3OIcg03tnR9v/g66hmWfsNLrj/AaQnZbZQFeT7K/X4skeFiqVUj95+4OU2Dua1vFOaW
         nQQy4Ic0x+Um6LuyrxRLxAGANF5O3LeN8E+kVsLRKsQeVIkbM8l9bOcV39Q0QVPH4i41
         2f2mf/z1h/Qll8XWuTHbf2bATNDL/I1m7yiK2ET/WaQ6aCJ0oeB2POp3j+KtZpcJK5M5
         gKFP9YL2Af3y7mA5vhNR8ddHl8iib+gLYGUUuQsgd53w5latLNvp1UADtIavAnKVwBUS
         z5Qw==
X-Gm-Message-State: AOAM533vni7w6R3uDWewp6HF9pGsONgvi46pWGBvOK/DMmggSpTR9KWZ
        8IHWGXq2y48M7aLhBjqfISBpX6GK/bLYbx7TpwGBDg==
X-Google-Smtp-Source: ABdhPJxrOqUB4ODul7BqoF/ImoKz/NTrACI9TZ8xUhAH+WLV5aq+zYg5YexfW7ItBha1hz4M9LoTkw==
X-Received: by 2002:a63:7303:: with SMTP id o3mr6812514pgc.280.1641960087380;
        Tue, 11 Jan 2022 20:01:27 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l3sm773965pgs.74.2022.01.11.20.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 20:01:26 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Make the module parameter of vPMU more common
Date:   Wed, 12 Jan 2022 12:01:16 +0800
Message-Id: <20220112040116.23937-1-likexu@tencent.com>
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

To keep "pmu" for the module param, e.g. same as ept, vpid, etc,
a harmless wrapper interface is introduced, which also helps to
distinguish the use of temporary variable with the same name.

Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
Suggested-by : Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1 -> v2 Changelog:
- prefer we keep "pmu" for the module param; (Sean)
- move the definition of module_param into the context of pmu;

Previous:
https://lore.kernel.org/kvm/20220111073823.21885-1-likexu@tencent.com/

 arch/x86/kvm/cpuid.c            | 6 +++---
 arch/x86/kvm/pmu.c              | 5 +++++
 arch/x86/kvm/pmu.h              | 8 ++++++++
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 6 +-----
 arch/x86/kvm/svm/svm.h          | 1 -
 arch/x86/kvm/vmx/capabilities.h | 4 ++++
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 8 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..b62ccc551f42 100644
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
+		if (!kvm_pmu_supported() || !cap.version)
 			memset(&cap, 0, sizeof(cap));
 
 		eax.split.version_id = min(cap.version, 2);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e632693a2266..7aef8180d2ec 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,11 @@
 #include "lapic.h"
 #include "pmu.h"
 
+/* Enable/disable PMU virtualization */
+bool __read_mostly pmu = true;
+EXPORT_SYMBOL_GPL(pmu);
+module_param(pmu, bool, 0444);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..43b1eb4bc38e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,14 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
+extern bool pmu;
+
+/* A wrapper interface to return the module parameter of the vPMU. */
+static inline bool kvm_pmu_supported(void)
+{
+	return pmu;
+}
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..794753abdda3 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!pmu)
+	if (!kvm_pmu_supported())
 		return NULL;
 
 	switch (msr) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6cb38044a860..e1c2b792ba69 100644
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
 
@@ -4712,7 +4708,7 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
-	if (!pmu)
+	if (!kvm_pmu_supported())
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
index c8029b7845b6..9181a57e7e91 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -389,6 +390,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
 
+	if (!kvm_pmu_supported())
+		return perf_cap;
+
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ffccfd9823c0..70e7f1fff36b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry)
+	if (!kvm_pmu_supported() || !entry)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.33.1

