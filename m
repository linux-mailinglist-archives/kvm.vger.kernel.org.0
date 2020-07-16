Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70535221AEA
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgGPDle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:41:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:4816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgGPDl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:27 -0400
IronPort-SDR: pc6P02SkZTYxULKjhVjsL1kioXRhBsap74Av0BbOvNc+HISx2Pn1OQXRsHP2XOfVKjyx+vLOw8
 fEAqBQyFXMqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="137442919"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="137442919"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:25 -0700
IronPort-SDR: JIh1Iw7mvK1AXZSu+Bj6d/C3EOwGZWaVQoQIJ5m7p1vKzGKBUscdwdHNpSE6a0Eb/fzcovHJ1t
 Xo/hMmLFdutg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905496"
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
Subject: [PATCH 9/9] KVM: x86: Specify max TDP level via kvm_configure_mmu()
Date:   Wed, 15 Jul 2020 20:41:22 -0700
Message-Id: <20200716034122.5998-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Capture the max TDP level during kvm_configure_mmu() instead of using a
kvm_x86_ops hook to do it at every vCPU creation.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/mmu/mmu.c          | 9 ++++++---
 arch/x86/kvm/svm/svm.c          | 3 +--
 arch/x86/kvm/vmx/vmx.c          | 3 +--
 arch/x86/kvm/x86.c              | 1 -
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd45b68e1d46..5ab3af7275d81 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1133,7 +1133,6 @@ struct kvm_x86_ops {
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
-	int (*get_max_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
@@ -1509,7 +1508,8 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
 		     bool skip_mmu_sync);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
+void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
+		       int tdp_huge_page_level);
 
 static inline u16 kvm_read_ldt(void)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c867b35759ab5..862bf418214e2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -93,6 +93,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 bool tdp_enabled = false;
 
 static int max_huge_page_level __read_mostly;
+static int max_tdp_level __read_mostly;
 
 enum {
 	AUDIT_PRE_PAGE_FAULT,
@@ -4849,10 +4850,10 @@ static union kvm_mmu_role kvm_calc_mmu_role_common(struct kvm_vcpu *vcpu,
 static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 {
 	/* Use 5-level TDP if and only if it's useful/necessary. */
-	if (vcpu->arch.max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
+	if (max_tdp_level == 5 && cpuid_maxphyaddr(vcpu) <= 48)
 		return 4;
 
-	return vcpu->arch.max_tdp_level;
+	return max_tdp_level;
 }
 
 static union kvm_mmu_role
@@ -5580,9 +5581,11 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
-void kvm_configure_mmu(bool enable_tdp, int tdp_huge_page_level)
+void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
+		       int tdp_huge_page_level)
 {
 	tdp_enabled = enable_tdp;
+	max_tdp_level = tdp_max_root_level;
 
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c94faca46e760..5f47b44c5c324 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -885,7 +885,7 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled && !npt)
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled, PG_LEVEL_1G);
+	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
@@ -4109,7 +4109,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.set_tss_addr = svm_set_tss_addr,
 	.set_identity_map_addr = svm_set_identity_map_addr,
-	.get_max_tdp_level = get_max_npt_level,
 	.get_mt_mask = svm_get_mt_mask,
 
 	.get_exit_info = svm_get_exit_info,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c0b1c7bd1248a..a70d8f6d8aba7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7959,7 +7959,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_max_tdp_level = vmx_get_max_tdp_level,
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
@@ -8110,7 +8109,7 @@ static __init int hardware_setup(void)
 		ept_lpage_level = PG_LEVEL_2M;
 	else
 		ept_lpage_level = PG_LEVEL_4K;
-	kvm_configure_mmu(enable_ept, ept_lpage_level);
+	kvm_configure_mmu(enable_ept, vmx_get_max_tdp_level(), ept_lpage_level);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b8347d703430..831179adedaa9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9520,7 +9520,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	fx_init(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-	vcpu->arch.max_tdp_level = kvm_x86_ops.get_max_tdp_level();
 
 	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
 
-- 
2.26.0

