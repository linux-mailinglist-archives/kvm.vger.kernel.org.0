Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC25C0D93
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfI0Vpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:45957 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728527AbfI0Vp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852078"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 7/8] KVM: x86: Add helpers to test/mark reg availability and dirtiness
Date:   Fri, 27 Sep 2019 14:45:22 -0700
Message-Id: <20190927214523.3376-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to prettify code that tests and/or marks whether or not a
register is available and/or dirty.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 45 +++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/nested.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c        | 29 ++++++++++------------
 arch/x86/kvm/x86.c            | 13 ++++------
 4 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index b85fc4b4e04f..9c2bc528800b 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -37,12 +37,37 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
+static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
+					     enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
+					 enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
+static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
+					       enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
+					   enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 {
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
 		return 0;
 
-	if (!test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, reg))
 		kvm_x86_ops->cache_reg(vcpu, reg);
 
 	return vcpu->arch.regs[reg];
@@ -55,13 +80,12 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
 		return;
 
 	vcpu->arch.regs[reg] = val;
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	kvm_register_mark_dirty(vcpu, reg);
 }
 
 static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
 {
-	if (!test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_REGS_RIP))
 		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RIP);
 
 	return vcpu->arch.regs[VCPU_REGS_RIP];
@@ -70,13 +94,12 @@ static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
 static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vcpu->arch.regs[VCPU_REGS_RIP] = val;
-	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty);
-	__set_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_avail);
+	kvm_register_mark_dirty(vcpu, VCPU_REGS_RIP);
 }
 
 static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
 {
-	if (!test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_REGS_RSP))
 		kvm_x86_ops->cache_reg(vcpu, VCPU_REGS_RSP);
 
 	return vcpu->arch.regs[VCPU_REGS_RSP];
@@ -85,16 +108,14 @@ static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
 static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	vcpu->arch.regs[VCPU_REGS_RSP] = val;
-	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty);
-	__set_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_avail);
+	kvm_register_mark_dirty(vcpu, VCPU_REGS_RSP);
 }
 
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 {
 	might_sleep();  /* on svm */
 
-	if (!test_bit(VCPU_EXREG_PDPTR,
-		      (unsigned long *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
 		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
 
 	return vcpu->arch.walk_mmu->pdptrs[index];
@@ -123,7 +144,7 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
-	if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
 		kvm_x86_ops->decache_cr3(vcpu);
 	return vcpu->arch.cr3;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b72a00b53e4a..8946f11c574c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1012,7 +1012,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		kvm_mmu_new_cr3(vcpu, cr3, false);
 
 	vcpu->arch.cr3 = cr3;
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	kvm_init_mmu(vcpu, false);
 
@@ -3986,7 +3986,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 
 	nested_ept_uninit_mmu_context(vcpu);
 	vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	/*
 	 * Use ept_save_pdptrs(vcpu) to load the MMU's cached PDPTRs
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 814d3e6d0264..ed03d0cd1cc8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -721,8 +721,8 @@ static bool vmx_segment_cache_test_set(struct vcpu_vmx *vmx, unsigned seg,
 	bool ret;
 	u32 mask = 1 << (seg * SEG_FIELD_NR + field);
 
-	if (!(vmx->vcpu.arch.regs_avail & (1 << VCPU_EXREG_SEGMENTS))) {
-		vmx->vcpu.arch.regs_avail |= (1 << VCPU_EXREG_SEGMENTS);
+	if (!kvm_register_is_available(&vmx->vcpu, VCPU_EXREG_SEGMENTS)) {
+		kvm_register_mark_available(&vmx->vcpu, VCPU_EXREG_SEGMENTS);
 		vmx->segment_cache.bitmask = 0;
 	}
 	ret = vmx->segment_cache.bitmask & mask;
@@ -1410,8 +1410,8 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long rflags, save_rflags;
 
-	if (!test_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail)) {
-		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_RFLAGS)) {
+		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
 		rflags = vmcs_readl(GUEST_RFLAGS);
 		if (vmx->rmode.vm86_active) {
 			rflags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
@@ -1429,7 +1429,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	unsigned long old_rflags;
 
 	if (enable_unrestricted_guest) {
-		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
+		kvm_register_mark_available(vcpu, VCPU_EXREG_RFLAGS);
 
 		vmx->rflags = rflags;
 		vmcs_writel(GUEST_RFLAGS, rflags);
@@ -2175,7 +2175,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, reg);
+
 	switch (reg) {
 	case VCPU_REGS_RSP:
 		vcpu->arch.regs[VCPU_REGS_RSP] = vmcs_readl(GUEST_RSP);
@@ -2862,7 +2863,7 @@ static void vmx_decache_cr3(struct kvm_vcpu *vcpu)
 {
 	if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 }
 
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
@@ -2877,8 +2878,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (!test_bit(VCPU_EXREG_PDPTR,
-		      (unsigned long *)&vcpu->arch.regs_dirty))
+	if (!kvm_register_is_dirty(vcpu, VCPU_EXREG_PDPTR))
 		return;
 
 	if (is_pae_paging(vcpu)) {
@@ -2900,10 +2900,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 		mmu->pdptrs[3] = vmcs_read64(GUEST_PDPTR3);
 	}
 
-	__set_bit(VCPU_EXREG_PDPTR,
-		  (unsigned long *)&vcpu->arch.regs_avail);
-	__set_bit(VCPU_EXREG_PDPTR,
-		  (unsigned long *)&vcpu->arch.regs_dirty);
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
 }
 
 static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
@@ -2912,7 +2909,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
 		vmx_decache_cr3(vcpu);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
@@ -6528,9 +6525,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->nested.need_vmcs12_to_shadow_sync)
 		nested_sync_vmcs12_to_shadow(vcpu);
 
-	if (test_bit(VCPU_REGS_RSP, (unsigned long *)&vcpu->arch.regs_dirty))
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RSP))
 		vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
-	if (test_bit(VCPU_REGS_RIP, (unsigned long *)&vcpu->arch.regs_dirty))
+	if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
 		vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
 
 	cr3 = __get_current_cr3_fast();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ed07d8d2caa..cd6bd7991c39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -709,10 +709,8 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
 	ret = 1;
 
 	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
-	__set_bit(VCPU_EXREG_PDPTR,
-		  (unsigned long *)&vcpu->arch.regs_avail);
-	__set_bit(VCPU_EXREG_PDPTR,
-		  (unsigned long *)&vcpu->arch.regs_dirty);
+	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
+
 out:
 
 	return ret;
@@ -730,8 +728,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	if (!is_pae_paging(vcpu))
 		return false;
 
-	if (!test_bit(VCPU_EXREG_PDPTR,
-		      (unsigned long *)&vcpu->arch.regs_avail))
+	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
 		return true;
 
 	gfn = (kvm_read_cr3(vcpu) & 0xffffffe0ul) >> PAGE_SHIFT;
@@ -976,7 +973,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
 	vcpu->arch.cr3 = cr3;
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	return 0;
 }
@@ -8766,7 +8763,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	vcpu->arch.cr2 = sregs->cr2;
 	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
 	vcpu->arch.cr3 = sregs->cr3;
-	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	kvm_set_cr8(vcpu, sregs->cr8);
 
-- 
2.22.0

