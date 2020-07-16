Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E65221AF1
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgGPDld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:41:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:4818 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgGPDl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:27 -0400
IronPort-SDR: xLzV4NPm6/C2rbfrJ9ErdouWwJqhNtRzG2jtmtvnoRDuGSoOhGnoP4hH/Mar88wI4vipjyetrJ
 b0o34kQ0LDCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137442917"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="137442917"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:25 -0700
IronPort-SDR: nFWoIpOy0jlxWE8XqOBWtYhLjQm/ASOqwhRyEwLP8OQNE487N64iQ/41NF6mjcarQP5yaWZxfX
 plYGn4eIk2nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905490"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 Jul 2020 20:41:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] KVM: x86: Dynamically calculate TDP level from max level and MAXPHYADDR
Date:   Wed, 15 Jul 2020 20:41:20 -0700
Message-Id: <20200716034122.5998-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Calculate the desired TDP level on the fly using the max TDP level and
MAXPHYADDR instead of doing the same when CPUID is updated.  This avoids
the hidden dependency on cpuid_maxphyaddr() in vmx_get_tdp_level() and
also standardizes the "use 5-level paging iff MAXPHYADDR > 48" behavior
across x86.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/cpuid.c            |  2 --
 arch/x86/kvm/mmu/mmu.c          | 17 +++++++++++++----
 arch/x86/kvm/svm/svm.c          |  4 ++--
 arch/x86/kvm/vmx/vmx.c          |  6 +++---
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ce60f4c38843f..ffd45b68e1d46 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -639,7 +639,7 @@ struct kvm_vcpu_arch {
 	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
 
 	int maxphyaddr;
-	int tdp_level;
+	int max_tdp_level;
 
 	/* emulate context */
 
@@ -1133,7 +1133,7 @@ struct kvm_x86_ops {
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
-	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
+	int (*get_max_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7d92854082a14..fa873e3e6e90e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -140,9 +140,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
 
-	/* Note, maxphyaddr must be updated before tdp_level. */
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0fb033ce6cc57..559b4b92b5e27 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4846,13 +4846,22 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 	return role;
 }
 
+static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
+{
+	/* Use 5-level TDP if and only if it's useful/necessary. */
+	if (vcpu->arch.max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
+		return 4;
+
+	return vcpu->arch.max_tdp_level;
+}
+
 static union kvm_mmu_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 {
 	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
 
 	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = vcpu->arch.tdp_level;
+	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 	role.base.direct = true;
 	role.base.gpte_is_8_bytes = true;
 
@@ -4873,7 +4882,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
 	context->update_pte = nonpaging_update_pte;
-	context->shadow_root_level = vcpu->arch.tdp_level;
+	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -4973,7 +4982,7 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu)
 		kvm_calc_shadow_root_page_role_common(vcpu, false);
 
 	role.base.direct = false;
-	role.base.level = vcpu->arch.tdp_level;
+	role.base.level = kvm_mmu_get_tdp_level(vcpu);
 
 	return role;
 }
@@ -5683,7 +5692,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
 	 * skip allocating the PDP table.
 	 */
-	if (tdp_enabled && vcpu->arch.tdp_level > PT32E_ROOT_LEVEL)
+	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;
 
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c70d7dd333061..c94faca46e760 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -254,7 +254,7 @@ static inline void invlpga(unsigned long addr, u32 asid)
 	asm volatile (__ex("invlpga %1, %0") : : "c"(asid), "a"(addr));
 }
 
-static int get_npt_level(struct kvm_vcpu *vcpu)
+static int get_max_npt_level(void)
 {
 #ifdef CONFIG_X86_64
 	return PT64_ROOT_4LEVEL;
@@ -4109,7 +4109,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_tdp_level = get_npt_level,
+	.get_max_tdp_level = get_max_npt_level,
 	.get_mt_mask = svm_get_mt_mask,
 
 	.get_exit_info = svm_get_exit_info,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da75878171cea..c0b1c7bd1248a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3065,9 +3065,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vmx->emulation_required = emulation_required(vcpu);
 }
 
-static int vmx_get_tdp_level(struct kvm_vcpu *vcpu)
+static int vmx_get_max_tdp_level(void)
 {
-	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
+	if (cpu_has_vmx_ept_5levels())
 		return 5;
 	return 4;
 }
@@ -7959,7 +7959,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_tdp_level = vmx_get_tdp_level,
+	.get_max_tdp_level = vmx_get_max_tdp_level,
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f526d94c33f3..6b8347d703430 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9520,7 +9520,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
+	vcpu->arch.max_tdp_level = kvm_x86_ops.get_max_tdp_level();
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.26.0

