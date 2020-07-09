Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60B1219771
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 06:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgGIEep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 00:34:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:10037 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgGIEen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 00:34:43 -0400
IronPort-SDR: PzMzDfVoZV2MMWlZobaJpC1UVUozhknBEKNA/CCHPhOh+xU3zwi4T6ubUQYVi+S2OjRVnC4GaM
 0yV743qs+X9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147011572"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="147011572"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 21:34:42 -0700
IronPort-SDR: a9b7pDPOzk5iGSq7O6KegK6d7knOuQMjm5taHcNUM/jMlgULo8i9s0PrTBWi6teZk/atdwyI4D
 txME5jrxnSoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="297942898"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 08 Jul 2020 21:34:39 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v4 4/5] KVM: x86: Rename cpuid_update() callback to vcpu_after_set_cpuid()
Date:   Thu,  9 Jul 2020 12:34:25 +0800
Message-Id: <20200709043426.92712-5-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200709043426.92712-1-xiaoyao.li@intel.com>
References: <20200709043426.92712-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The name of callback cpuid_update() is misleading that it's not about
updating CPUID settings of vcpu but updating the configurations of vcpu
based on the CPUIDs. So rename it to vcpu_after_set_cpuid().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 4 ++--
 arch/x86/kvm/svm/svm.c          | 4 ++--
 arch/x86/kvm/vmx/nested.c       | 3 ++-
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16461a674406..3d7d818a282c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1052,7 +1052,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(u32 index);
-	void (*cpuid_update)(struct kvm_vcpu *vcpu);
+	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b602c0c9078e..832a24c1334e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -228,7 +228,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
@@ -257,7 +257,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_x86_ops.cpuid_update(vcpu);
+	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
 	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 out:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6d49afa3063f..535ad311ad02 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3595,7 +3595,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
-static void svm_cpuid_update(struct kvm_vcpu *vcpu)
+static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4095,7 +4095,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.get_exit_info = svm_get_exit_info,
 
-	.cpuid_update = svm_cpuid_update,
+	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7693d41a2446..e4080ab2df21 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6354,7 +6354,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 
 	/*
 	 * secondary cpu-based controls.  Do not include those that
-	 * depend on CPUID bits, they are added later by vmx_cpuid_update.
+	 * depend on CPUID bits, they are added later by
+	 * vmx_vcpu_after_set_cpuid.
 	 */
 	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
 		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0cdc78f2f2f4..2b41d987b101 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7282,7 +7282,7 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
-static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -7940,7 +7940,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.get_exit_info = vmx_get_exit_info,
 
-	.cpuid_update = vmx_cpuid_update,
+	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-- 
2.18.4

