Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ABD204317
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 23:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbgFVV6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 17:58:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:15508 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730906AbgFVV6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 17:58:37 -0400
IronPort-SDR: QQxdv6LbPjaiE59QSRhse+K4QCqHu1mP9OCgznEageAnfi3kQH9yNeiF0mNXouFy44frjAYVSh
 CebDg3GOSzTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="142148022"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="142148022"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 14:58:35 -0700
IronPort-SDR: B9InyO7f4ezvFwZ/O9lxBgG3IMgwTpagGSEEb+Op2XfgvkNqYbZEdHYm6amzgCI3BT5DfKTYf5
 airZ6FUD4QNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="300987323"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 22 Jun 2020 14:58:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] KVM: x86/mmu: Make .write_log_dirty a nested operation
Date:   Mon, 22 Jun 2020 14:58:32 -0700
Message-Id: <20200622215832.22090-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622215832.22090-1-sean.j.christopherson@intel.com>
References: <20200622215832.22090-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move .write_log_dirty() into kvm_x86_nested_ops to help differentiate it
from the non-nested dirty log hooks.  And because it's a nested-only
operation.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/vmx/nested.c       | 38 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 38 ---------------------------------
 4 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 446ea70a554d..4e6219cb3933 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1220,7 +1220,6 @@ struct kvm_x86_ops {
 	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
-	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
@@ -1281,6 +1280,7 @@ struct kvm_x86_nested_ops {
 			 struct kvm_nested_state __user *user_kvm_nested_state,
 			 struct kvm_nested_state *kvm_state);
 	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
 			    uint16_t *vmcs_version);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 60e7b2308876..c733196fd45b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -260,7 +260,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 				!(pte & PT_GUEST_DIRTY_MASK)) {
 			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 #if PTTYPE == PTTYPE_EPT
-			if (kvm_x86_ops.write_log_dirty(vcpu, addr))
+			if (kvm_x86_ops.nested_ops->write_log_dirty(vcpu, addr))
 				return -EINVAL;
 #endif
 			pte |= PT_GUEST_DIRTY_MASK;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index adb11b504d5c..db9abcbeefd1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3205,6 +3205,43 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct vmcs12 *vmcs12;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	gpa_t dst;
+
+	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
+		return 0;
+
+	if (WARN_ON_ONCE(vmx->nested.pml_full))
+		return 1;
+
+	/*
+	 * Check if PML is enabled for the nested guest. Whether eptp bit 6 is
+	 * set is already checked as part of A/D emulation.
+	 */
+	vmcs12 = get_vmcs12(vcpu);
+	if (!nested_cpu_has_pml(vmcs12))
+		return 0;
+
+	if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
+		vmx->nested.pml_full = true;
+		return 1;
+	}
+
+	gpa &= ~0xFFFull;
+	dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
+
+	if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
+				 offset_in_page(dst), sizeof(gpa)))
+		return 0;
+
+	vmcs12->guest_pml_index--;
+
+	return 0;
+}
+
 /*
  * Intel's VMX Instruction Reference specifies a common set of prerequisites
  * for running VMX instructions (except VMXON, whose prerequisites are
@@ -6503,6 +6540,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.get_state = vmx_get_nested_state,
 	.set_state = vmx_set_nested_state,
 	.get_vmcs12_pages = nested_get_vmcs12_pages,
+	.write_log_dirty = nested_vmx_write_pml_buffer,
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index adf83047bb21..8bf06a59f356 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7501,43 +7501,6 @@ static void vmx_flush_log_dirty(struct kvm *kvm)
 	kvm_flush_pml_buffers(kvm);
 }
 
-static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
-{
-	struct vmcs12 *vmcs12;
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gpa_t dst;
-
-	if (WARN_ON_ONCE(!is_guest_mode(vcpu)))
-		return 0;
-
-	if (WARN_ON_ONCE(vmx->nested.pml_full))
-		return 1;
-
-	/*
-	 * Check if PML is enabled for the nested guest. Whether eptp bit 6 is
-	 * set is already checked as part of A/D emulation.
-	 */
-	vmcs12 = get_vmcs12(vcpu);
-	if (!nested_cpu_has_pml(vmcs12))
-		return 0;
-
-	if (vmcs12->guest_pml_index >= PML_ENTITY_NUM) {
-		vmx->nested.pml_full = true;
-		return 1;
-	}
-
-	gpa &= ~0xFFFull;
-	dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
-
-	if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
-				 offset_in_page(dst), sizeof(gpa)))
-		return 0;
-
-	vmcs12->guest_pml_index--;
-
-	return 0;
-}
-
 static void vmx_enable_log_dirty_pt_masked(struct kvm *kvm,
 					   struct kvm_memory_slot *memslot,
 					   gfn_t offset, unsigned long mask)
@@ -7966,7 +7929,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
 	.flush_log_dirty = vmx_flush_log_dirty,
 	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
-	.write_log_dirty = vmx_write_pml_buffer,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
-- 
2.26.0

