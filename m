Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2709F1C22FA
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgEBEc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:55789 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgEBEcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:39 -0400
IronPort-SDR: QD7Wq567xtdJYG3UE+jlptshPrLxetb31XxAk6LsjaBi48pLipj6YL1HVKxhiwRTjCuHOsaNzB
 ZtZAauQwMsfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: cfyH225YbbTDf4gsK8BWgsbuADymwi/uXEsVbWIFVOrSlBaAW0v3UZoJQRFJtrCV8EmK7wghFp
 5ncUCfmeMl6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516133"
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
Subject: [PATCH 07/10] KVM: VMX: Add proper cache tracking for CR0
Date:   Fri,  1 May 2020 21:32:31 -0700
Message-Id: <20200502043234.12481-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move CR0 caching into the standard register caching mechanism in order
to take advantage of the availability checks provided by regs_avail.
This avoids multiple VMREADs in the (uncommon) case where kvm_read_cr0()
is called multiple times in a single VM-Exit, and more importantly
eliminates a kvm_x86_ops hook, saves a retpoline on SVM when reading
CR0, and squashes the confusing naming discrepancy of "cache_reg" vs.
"decache_cr0_guest_bits".

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  5 +++--
 arch/x86/kvm/svm/svm.c          |  5 -----
 arch/x86/kvm/vmx/vmx.c          | 16 +++++++---------
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dbf7d3f2edbc..55c8f78bc9e8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -167,6 +167,7 @@ enum kvm_reg {
 	NR_VCPU_REGS,
 
 	VCPU_EXREG_PDPTR = NR_VCPU_REGS,
+	VCPU_EXREG_CR0,
 	VCPU_EXREG_CR3,
 	VCPU_EXREG_CR4,
 	VCPU_EXREG_RFLAGS,
@@ -1091,7 +1092,6 @@ struct kvm_x86_ops {
 	void (*set_segment)(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
-	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 921a539bcb96..ff2d0e9ca3bc 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -116,8 +116,9 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
-	if (tmask & vcpu->arch.cr0_guest_owned_bits)
-		kvm_x86_ops.decache_cr0_guest_bits(vcpu);
+	if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
+	    !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR0);
 	return vcpu->arch.cr0 & mask;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e09f7e8b961f..e185368a2d32 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1524,10 +1524,6 @@ static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 	mark_dirty(svm->vmcb, VMCB_DT);
 }
 
-static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
-{
-}
-
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
@@ -3993,7 +3989,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_segment = svm_set_segment,
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
-	.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 31316cffb427..0cb0c347de04 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2202,6 +2202,12 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		if (enable_ept)
 			ept_save_pdptrs(vcpu);
 		break;
+	case VCPU_EXREG_CR0:
+		guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
+
+		vcpu->arch.cr0 &= ~guest_owned_bits;
+		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
+		break;
 	case VCPU_EXREG_CR3:
 		if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
 			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
@@ -2905,14 +2911,6 @@ static void vmx_flush_tlb_guest(struct kvm_vcpu *vcpu)
 	vpid_sync_context(to_vmx(vcpu)->vpid);
 }
 
-static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
-{
-	ulong cr0_guest_owned_bits = vcpu->arch.cr0_guest_owned_bits;
-
-	vcpu->arch.cr0 &= ~cr0_guest_owned_bits;
-	vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & cr0_guest_owned_bits;
-}
-
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -3002,6 +3000,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vmcs_writel(CR0_READ_SHADOW, cr0);
 	vmcs_writel(GUEST_CR0, hw_cr0);
 	vcpu->arch.cr0 = cr0;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR0);
 
 	/* depends on vcpu->arch.cr0 to be set to a new value */
 	vmx->emulation_required = emulation_required(vcpu);
@@ -7782,7 +7781,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_segment = vmx_set_segment,
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.decache_cr0_guest_bits = vmx_decache_cr0_guest_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr4 = vmx_set_cr4,
 	.set_efer = vmx_set_efer,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 39d0f32372e7..5f3f141d7254 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -452,6 +452,7 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_RFLAGS)
 				  | (1 << VCPU_EXREG_PDPTR)
 				  | (1 << VCPU_EXREG_SEGMENTS)
+				  | (1 << VCPU_EXREG_CR0)
 				  | (1 << VCPU_EXREG_CR3)
 				  | (1 << VCPU_EXREG_CR4)
 				  | (1 << VCPU_EXREG_EXIT_INFO_1)
-- 
2.26.0

