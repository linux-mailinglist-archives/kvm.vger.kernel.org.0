Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81479204313
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgFVV6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:58:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:15498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbgFVV6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:36 -0400
IronPort-SDR: aIkEwIzzf17Cim69ChfKJ9Vgt1V+++clzShtOc9NNP12MAqcB3PHK8xcqJgUdJ1C0+8J1M2C1J
 icJNOZgITk5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142148015"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142148015"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:58:34 -0700
IronPort-SDR: CAppCz7dXbT4sTVSv+h8HAXnPOaxC+Y+sZTw0KHOjIoygjPGkrEqK/vQlmndC3uPLddFqHGO4+
 6IaMd5IF1uGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="300987310"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2020 14:58:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: nVMX: Plumb L2 GPA through to PML emulation
Date:   Mon, 22 Jun 2020 14:58:29 -0700
Message-Id: <20200622215832.22090-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622215832.22090-1-sean.j.christopherson@intel.com>
References: <20200622215832.22090-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly pass the L2 GPA to kvm_arch_write_log_dirty(), which for all
intents and purposes is vmx_write_pml_buffer(), instead of having the
latter pull the GPA from vmcs.GUEST_PHYSICAL_ADDRESS.  If the dirty bit
update is the result of KVM emulation (rare for L2), then the GPA in the
VMCS may be stale and/or hold a completely unrelated GPA.

Fixes: c5f983f6e8455 ("nVMX: Implement emulated Page Modification Logging")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu.h              | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h  | 7 ++++---
 arch/x86/kvm/vmx/vmx.c          | 6 +++---
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..446ea70a554d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1220,7 +1220,7 @@ struct kvm_x86_ops {
 	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
-	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0ad06bfe2c2c..444bb9c54548 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -222,7 +222,7 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
+int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..76817d13c86e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1745,10 +1745,10 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
  * Emulate arch specific page modification logging for the
  * nested hypervisor
  */
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
+int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa)
 {
 	if (kvm_x86_ops.write_log_dirty)
-		return kvm_x86_ops.write_log_dirty(vcpu);
+		return kvm_x86_ops.write_log_dirty(vcpu, l2_gpa);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 38c576495048..cddd40029553 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -235,7 +235,7 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 					     struct kvm_mmu *mmu,
 					     struct guest_walker *walker,
-					     int write_fault)
+					     gpa_t addr, int write_fault)
 {
 	unsigned level, index;
 	pt_element_t pte, orig_pte;
@@ -260,7 +260,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 				!(pte & PT_GUEST_DIRTY_MASK)) {
 			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 #if PTTYPE == PTTYPE_EPT
-			if (kvm_arch_write_log_dirty(vcpu))
+			if (kvm_arch_write_log_dirty(vcpu, addr))
 				return -EINVAL;
 #endif
 			pte |= PT_GUEST_DIRTY_MASK;
@@ -457,7 +457,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);
 
 	if (unlikely(!accessed_dirty)) {
-		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker, write_fault);
+		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker,
+							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
 		else if (ret)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08e26a9518c2..a2e7e106cc8f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7501,11 +7501,11 @@ static void vmx_flush_log_dirty(struct kvm *kvm)
 	kvm_flush_pml_buffers(kvm);
 }
 
-static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
+static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gpa_t gpa, dst;
+	gpa_t dst;
 
 	if (is_guest_mode(vcpu)) {
 		WARN_ON_ONCE(vmx->nested.pml_full);
@@ -7524,7 +7524,7 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
 			return 1;
 		}
 
-		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS) & ~0xFFFull;
+		gpa &= ~0xFFFull;
 		dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
 
 		if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
-- 
2.26.0

