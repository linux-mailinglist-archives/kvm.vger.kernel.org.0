Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45291C2302
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgEBEdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:33:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:44408 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgEBEci (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:38 -0400
IronPort-SDR: djKHMF+fgWLvDTYGv/tWDw3ppY0V075L01j4FJ5eBxlihjFY/ZE7JJUdmO35wR5l9k3xu2oiQk
 99H9BDZtF7Sg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: uLieiuDmvkOOa2qIqraIfiqhVDFAZD6YzUXOhw2yVmbeVaedCrtZThNv7hXw7Lg02F6BdYg06+
 4NHonDARlKZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516144"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 01 May 2020 21:32:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] KVM: x86/mmu: Capture TDP level when updating CPUID
Date:   Fri,  1 May 2020 21:32:34 -0700
Message-Id: <20200502043234.12481-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Snapshot the TDP level now that it's invariant (SVM) or dependent only
on host capabilities and guest CPUID (VMX).  This avoids having to call
kvm_x86_ops.get_tdp_level() when initializing a TDP MMU and/or
calculating the page role, and thus avoids the associated retpoline.

Drop the WARN in vmx_get_tdp_level() as updating CPUID while L2 is
active is legal, if dodgy.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 6 +++---
 arch/x86/kvm/svm/nested.c       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 --
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55c8f78bc9e8..90840593cd6c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -686,6 +686,7 @@ struct kvm_vcpu_arch {
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
 	int maxphyaddr;
+	int tdp_level;
 
 	/* emulate context */
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6828be99b908..44dfaefdad0e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -124,8 +124,9 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
-	/* Update physical-address width */
+	/* Note, maxphyaddr must be updated before tdp_level. */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
+	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e618472c572b..10cb8db54cd0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4894,7 +4894,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = kvm_x86_ops.get_tdp_level(vcpu);
+	role.base.level = vcpu->arch.tdp_level;
 	role.base.direct = true;
 	role.base.gpte_is_8_bytes = true;
 
@@ -4915,7 +4915,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
 	context->update_pte = nonpaging_update_pte;
-	context->shadow_root_level = kvm_x86_ops.get_tdp_level(vcpu);
+	context->shadow_root_level = vcpu->arch.tdp_level;
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -5680,7 +5680,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
 	 * skip allocating the PDP table.
 	 */
-	if (tdp_enabled && kvm_x86_ops.get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+	if (tdp_enabled && vcpu->arch.tdp_level > PT32E_ROOT_LEVEL)
 		return 0;
 
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7c86ccb0e939..1afff0b6f30e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -85,7 +85,7 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
 	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-	vcpu->arch.mmu->shadow_root_level = kvm_x86_ops.get_tdp_level(vcpu);
+	vcpu->arch.mmu->shadow_root_level = vcpu->arch.tdp_level;
 	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9c6e72e9660..f1bde5c41eee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3008,8 +3008,6 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int vmx_get_tdp_level(struct kvm_vcpu *vcpu)
 {
-	WARN_ON(is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)));
-
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
-- 
2.26.0

