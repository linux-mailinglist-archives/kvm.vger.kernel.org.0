Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D161C22FC
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 06:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgEBEc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 00:32:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:55787 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbgEBEcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 00:32:39 -0400
IronPort-SDR: OOfs137t8Hq4U/bUYFLUjR9vZQ9qqbRANxG/IDfbVzCAhhdoOEjUHKsu0ueG/dVdQZhQefy2Ft
 ndiMz2KUpIOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 21:32:37 -0700
IronPort-SDR: orXBMWpAMww+scwUjtZn9GeWpvtZzBizQ0wen0KjdYyh7FGskRKV21xZyhfai+QfAofqFhNsqa
 890fbkddcoPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,342,1583222400"; 
   d="scan'208";a="433516129"
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
Subject: [PATCH 06/10] KVM: VMX: Add proper cache tracking for CR4
Date:   Fri,  1 May 2020 21:32:30 -0700
Message-Id: <20200502043234.12481-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move CR4 caching into the standard register caching mechanism in order
to take advantage of the availability checks provided by regs_avail.
This avoids multiple VMREADs and retpolines (when configured) during
nested VMX transitions as kvm_read_cr4_bits() is invoked multiple times
on each transition, e.g. when stuffing CR0 and CR3.

As an added bonus, this eliminates a kvm_x86_ops hook, saves a retpoline
on SVM when reading CR4, and squashes the confusing naming discrepancy
of "cache_reg" vs. "decache_cr4_guest_bits".

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  5 +++--
 arch/x86/kvm/svm/svm.c          |  5 -----
 arch/x86/kvm/vmx/vmx.c          | 18 +++++++++---------
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d71d1f38b7a0..dbf7d3f2edbc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -168,6 +168,7 @@ enum kvm_reg {
 
 	VCPU_EXREG_PDPTR = NR_VCPU_REGS,
 	VCPU_EXREG_CR3,
+	VCPU_EXREG_CR4,
 	VCPU_EXREG_RFLAGS,
 	VCPU_EXREG_SEGMENTS,
 	VCPU_EXREG_EXIT_INFO_1,
@@ -1091,7 +1092,6 @@ struct kvm_x86_ops {
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
-	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	int (*set_cr4)(struct kvm_vcpu *vcpu, unsigned long cr4);
 	void (*set_efer)(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 62558b9bdda7..921a539bcb96 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -129,8 +129,9 @@ static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
 static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 {
 	ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
-	if (tmask & vcpu->arch.cr4_guest_owned_bits)
-		kvm_x86_ops.decache_cr4_guest_bits(vcpu);
+	if ((tmask & vcpu->arch.cr4_guest_owned_bits) &&
+	    !kvm_register_is_available(vcpu, VCPU_EXREG_CR4))
+		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR4);
 	return vcpu->arch.cr4 & mask;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f40a43a288b9..e09f7e8b961f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1528,10 +1528,6 @@ static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
 
-static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
-{
-}
-
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
@@ -3998,7 +3994,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
-	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr4 = svm_set_cr4,
 	.set_efer = svm_set_efer,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e157bdc218ea..31316cffb427 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2187,6 +2187,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 {
+	unsigned long guest_owned_bits;
+
 	kvm_register_mark_available(vcpu, reg);
 
 	switch (reg) {
@@ -2204,6 +2206,12 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
 			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 		break;
+	case VCPU_EXREG_CR4:
+		guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
+
+		vcpu->arch.cr4 &= ~guest_owned_bits;
+		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
@@ -2905,14 +2913,6 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & cr0_guest_owned_bits;
 }
 
-static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
-{
-	ulong cr4_guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
-
-	vcpu->arch.cr4 &= ~cr4_guest_owned_bits;
-	vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & cr4_guest_owned_bits;
-}
-
 static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
@@ -3111,6 +3111,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		return 1;
 
 	vcpu->arch.cr4 = cr4;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR4);
 
 	if (!enable_unrestricted_guest) {
 		if (enable_ept) {
@@ -7782,7 +7783,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.decache_cr0_guest_bits = vmx_decache_cr0_guest_bits,
-	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr4 = vmx_set_cr4,
 	.set_efer = vmx_set_efer,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fa61dc802183..39d0f32372e7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -453,6 +453,7 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_PDPTR)
 				  | (1 << VCPU_EXREG_SEGMENTS)
 				  | (1 << VCPU_EXREG_CR3)
+				  | (1 << VCPU_EXREG_CR4)
 				  | (1 << VCPU_EXREG_EXIT_INFO_1)
 				  | (1 << VCPU_EXREG_EXIT_INFO_2));
 	vcpu->arch.regs_dirty = 0;
-- 
2.26.0

