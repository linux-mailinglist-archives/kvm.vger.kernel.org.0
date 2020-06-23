Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02397205184
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732620AbgFWL6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:58474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732578AbgFWL6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:33 -0400
IronPort-SDR: rupZRBzTxkE7NtOkSPo6EvNfVKu6lfAral80sx3SfaZycRERQpJ8xKcBOeLpYnOOGLeRJ3m25C
 aztTi4zltXWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="228710113"
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="228710113"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 04:58:33 -0700
IronPort-SDR: uVAnUNFTByGXkW9TyRZCZbEIB48K8uxJ+DwXuuu55pSWYlwlD3r7Qt0dLM/UAmMZ3qG8vn6J6J
 2oPNxdYz1VwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,271,1589266800"; 
   d="scan'208";a="285745900"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga007.jf.intel.com with ESMTP; 23 Jun 2020 04:58:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 5/7] KVM: X86: Rename cpuid_update() to update_vcpu_model()
Date:   Tue, 23 Jun 2020 19:58:14 +0800
Message-Id: <20200623115816.24132-6-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200623115816.24132-1-xiaoyao.li@intel.com>
References: <20200623115816.24132-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The name of callback cpuid_update() is misleading that it's not about
updating CPUID settings of vcpu but updating the configurations of vcpu
based on the CPUIDs. So rename it to update_vcpu_model().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 4 ++--
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f852ee350beb..e8ae89eef199 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1083,7 +1083,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(u32 index);
-	void (*cpuid_update)(struct kvm_vcpu *vcpu);
+	void (*update_vcpu_model)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 001f5a94880e..d2f93823f9fd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -224,7 +224,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 
 	cpuid_fix_nx_cap(vcpu);
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_x86_ops.update_vcpu_model(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 
@@ -254,7 +254,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	}
 
 	kvm_apic_set_version(vcpu);
-	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_x86_ops.update_vcpu_model(vcpu);
 	kvm_update_cpuid(vcpu);
 	kvm_update_vcpu_model(vcpu);
 out:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c0da4dd78ac5..480d0354910a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3551,7 +3551,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
-static void svm_cpuid_update(struct kvm_vcpu *vcpu)
+static void svm_update_vcpu_model(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4051,7 +4051,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.get_exit_info = svm_get_exit_info,
 
-	.cpuid_update = svm_cpuid_update,
+	.update_vcpu_model = svm_update_vcpu_model,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d1af20b050a8..86ba7cd49c97 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6322,7 +6322,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 
 	/*
 	 * secondary cpu-based controls.  Do not include those that
-	 * depend on CPUID bits, they are added later by vmx_cpuid_update.
+	 * depend on CPUID bits, they are added later by vmx_update_vcpu_model.
 	 */
 	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
 		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b1a23ad986ff..147c696d6445 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7251,7 +7251,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
+static void vmx_update_vcpu_model(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7945,7 +7945,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.get_exit_info = vmx_get_exit_info,
 
-	.cpuid_update = vmx_cpuid_update,
+	.update_vcpu_model = vmx_update_vcpu_model,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-- 
2.18.2

