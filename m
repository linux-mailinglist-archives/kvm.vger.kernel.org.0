Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2AC4AE31
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 00:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731065AbfFRWvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 18:51:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:48880 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730936AbfFRWvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 18:51:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 15:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,390,1557212400"; 
   d="scan'208";a="358009371"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jun 2019 15:51:11 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Radim Krcmar" <rkrcmar@redhat.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Sai Praneeth Prakhya" <sai.praneeth.prakhya@intel.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v9 10/17] kvm/x86: Emulate MSR IA32_CORE_CAPABILITY
Date:   Tue, 18 Jun 2019 15:41:12 -0700
Message-Id: <1560897679-228028-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@linux.intel.com>

MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 5 of which
reports the capability of enabling detection of split locks (will be
supported on future processors based on Tremont microarchitecture and
later).

CPUID.(EAX=7H,ECX=0):EDX[30] enumerates the presence of the
IA32_CORE_CAPABILITY MSR.

Please check the latest Intel 64 and IA-32 Architectures Software
Developer's Manual for more detailed information on the MSR and
the split lock bit.

Since MSR_IA32_CORE_CAP is a feature-enumerating MSR that plays the
similar role as CPUID, it can be emulated in software regardless of host's
capability. What we need to do is to set the right value of it to report
the capability of guest.

In this patch, just set the guest's core_capability as 0, because we
haven't added support of the features it indicates to guest. It's for
bisectability.

Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  6 ++++++
 arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 450d69a1e6fa..ddac618e96a1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -572,6 +572,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
+	u64 core_capability;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9f65b5..7d064a7c5637 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -507,6 +507,12 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 * if the host doesn't support it.
 			 */
 			entry->edx |= F(ARCH_CAPABILITIES);
+			/*
+			 * Since we emulate MSR IA32_CORE_CAPABILITY in
+			 * software, we can always enable it for guest
+			 * regardless of host's capability.
+			 */
+			entry->edx |= F(CORE_CAPABILITY);
 		} else {
 			entry->ebx = 0;
 			entry->ecx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd759846..dc4c72bd6781 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1165,6 +1165,7 @@ static u32 emulated_msrs[] = {
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
 	MSR_IA32_ARCH_CAPABILITIES,
+	MSR_IA32_CORE_CAP,
 	MSR_IA32_MISC_ENABLE,
 	MSR_IA32_MCG_STATUS,
 	MSR_IA32_MCG_CTL,
@@ -1207,6 +1208,7 @@ static u32 msr_based_features[] = {
 
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
+	MSR_IA32_CORE_CAP,
 	MSR_IA32_ARCH_CAPABILITIES,
 };
 
@@ -1234,9 +1236,17 @@ u64 kvm_get_arch_capabilities(void)
 }
 EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
+static u64 kvm_get_core_capability(void)
+{
+	return 0;
+}
+
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_CORE_CAP:
+		msr->data = kvm_get_core_capability();
+		break;
 	case MSR_IA32_ARCH_CAPABILITIES:
 		msr->data = kvm_get_arch_capabilities();
 		break;
@@ -2495,6 +2505,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
+	case MSR_IA32_CORE_CAP:
+		if (!msr_info->host_initiated)
+			return 1;
+		vcpu->arch.core_capability = data;
+		break;
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
@@ -2808,6 +2823,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
 		break;
+	case MSR_IA32_CORE_CAP:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_CORE_CAPABILITY))
+			return 1;
+		msr_info->data = vcpu->arch.core_capability;
+		break;
 	case MSR_MTRRcap:
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
@@ -8853,6 +8874,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
+	vcpu->arch.core_capability = kvm_get_core_capability();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-- 
2.19.1

