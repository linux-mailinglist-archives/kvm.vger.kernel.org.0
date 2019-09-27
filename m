Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3F1BFD1F
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfI0CRR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:17:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:25572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfI0CRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:17:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:17:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="193020666"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 19:17:13 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 3/7] KVM: VMX: Pass through CET related MSRs to Guest
Date:   Fri, 27 Sep 2019 10:19:23 +0800
Message-Id: <20190927021927.23057-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190927021927.23057-1-weijiang.yang@intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET MSRs pass through Guest directly to enhance performance.
CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
these MSRs are defined in kernel and re-used here.

MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
the contents could differ from process to process, therefore,
kernel needs to save/restore them during context switch, it makes
sense to pass through them so that the guest kernel can
use xsaves/xrstors to operate them efficiently. Other MSRs are used
for non-user mode protection. See CET spec for detailed info.

The difference between CET VMCS state fields and xsave components is that,
the former used for CET state storage during VMEnter/VMExit,
whereas the latter used for state retention between Guest task/process
switch.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c   |  1 +
 arch/x86/kvm/cpuid.h   |  2 ++
 arch/x86/kvm/vmx/vmx.c | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1aa86b87b6ab..0a47b9e565be 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -66,6 +66,7 @@ u64 kvm_supported_xss(void)
 {
 	return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
 }
+EXPORT_SYMBOL_GPL(kvm_supported_xss);
 
 #define F(x) bit(X86_FEATURE_##x)
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..1d77b880084d 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -27,6 +27,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
 
+u64 kvm_supported_xss(void);
+
 static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.maxphyaddr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a84198cff397..f720baa7a9ba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7001,6 +7001,43 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_intercept_cet_msrs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap;
+	u64 kvm_xss;
+	bool cet_en;
+
+	msr_bitmap = vmx->vmcs01.msr_bitmap;
+	kvm_xss = kvm_supported_xss();
+	cet_en = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+		 guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+
+	/*
+	 * U_CET is a must for USER CET, per CET spec., U_CET and PL3_SPP are
+	 * a bundle for USER CET xsaves.
+	 */
+	if (cet_en && (kvm_xss & XFEATURE_MASK_CET_USER)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
+	}
+	/*
+	 * S_CET is a must for KERNEL CET, PL0_SSP ... PL2_SSP are a bundle
+	 * for CET KERNEL xsaves.
+	 */
+	if (cet_en && (kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
+
+		/* SSP_TAB only available for KERNEL SHSTK.*/
+		if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+			vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
+						      MSR_TYPE_RW);
+	}
+}
+
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7025,6 +7062,8 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
+
+	vmx_intercept_cet_msrs(vcpu);
 }
 
 static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
-- 
2.17.2

