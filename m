Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6486F1914BE
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbgCXPiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:38:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgCXPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:31 -0400
IronPort-SDR: hu/pJaY8+DLwSy7pcEs0Wd5PCNHg9ayrX0BmE1eDGpisEtCy/5ahZvnnGSWLO5kxw+q2M4pxJ2
 ltgL5LXkDmpw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:30 -0700
IronPort-SDR: ege+R4s2yWDYKvlJDc5AnRzo+hYyE4egePelGEqv/Y+jXhh0CGz+LeJo27Xi7V9G5hHMWuShun
 3xik4R2/VfCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319751"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 6/8] kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
Date:   Tue, 24 Mar 2020 23:18:57 +0800
Message-Id: <20200324151859.31068-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate MSR_IA32_CORE_CAPABILITIES in software and unconditionally
advertise its support to userspace. Like MSR_IA32_ARCH_CAPABILITIES, it
is a feature-enumerating MSR and can be fully emulated regardless of
hardware support. Existence of CORE_CAPABILITIES is enumerated via
CPUID.(EAX=7H,ECX=0):EDX[30].

Note, support for individual features enumerated via CORE_CAPABILITIES,
e.g., split lock detection, will be added in future patches.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  1 +
 arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9a183e9d4cb1..7e842ccb0608 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -597,6 +597,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
+	u64 core_capabilities;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 435a7da07d5f..1cacc776b329 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -344,6 +344,7 @@ void kvm_set_cpu_caps(void)
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
 	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
 	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
+	kvm_cpu_cap_set(X86_FEATURE_CORE_CAPABILITIES);
 
 	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ef57e3a315f..fc1a4e9e5659 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1248,6 +1248,7 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_CORE_CAPS,
 	MSR_IA32_MISC_ENABLE,
 	MSR_IA32_MCG_STATUS,
 	MSR_IA32_MCG_CTL,
@@ -1314,6 +1315,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_CORE_CAPS,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
@@ -1367,12 +1369,20 @@ static u64 kvm_get_arch_capabilities(void)
 	return data;
 }
 
+static u64 kvm_get_core_capabilities(void)
+{
+	return 0;
+}
+
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
 	case MSR_IA32_ARCH_CAPABILITIES:
 		msr->data = kvm_get_arch_capabilities();
 		break;
+	case MSR_IA32_CORE_CAPS:
+		msr->data = kvm_get_core_capabilities();
+		break;
 	case MSR_IA32_UCODE_REV:
 		rdmsrl_safe(msr->index, &msr->data);
 		break;
@@ -2745,6 +2755,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.arch_capabilities = data;
 		break;
+	case MSR_IA32_CORE_CAPS:
+		if (!msr_info->host_initiated)
+			return 1;
+		vcpu->arch.core_capabilities = data;
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
@@ -3072,6 +3087,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
+	case MSR_IA32_CORE_CAPS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_CORE_CAPABILITIES))
+			return 1;
+		msr_info->data = vcpu->arch.core_capabilities;
+		break;
 	case MSR_IA32_POWER_CTL:
 		msr_info->data = vcpu->arch.msr_ia32_power_ctl;
 		break;
@@ -9367,6 +9388,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto free_guest_fpu;
 
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+	vcpu->arch.core_capabilities = kvm_get_core_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-- 
2.20.1

