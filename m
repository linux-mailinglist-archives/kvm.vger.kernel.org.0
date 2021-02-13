Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A6131A90E
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhBMAxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhBMAwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:40 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485BCC061221
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:43 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s7so1574832ybj.0
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eB7aZXTG/r9znzgI5ELRRkyUfRHeewkpT855MZu37AE=;
        b=OVopWNaHtFPNCOpDQ1/tCi/GhbNIPMIFCXIxIk4h2rZQU17WGXCmdsamNVRvmid/Gl
         38AMLiyl6bBcg3RMgSzWBEQMsjvoYeQB9uc86BaQg/WBSo5CabOUHS+IPJpcuAM3LrH5
         CXbKdC4Iz6On9OGkJDk0bYRz42c/zFNtqxzhCafqhHMR1ttU/wgbpaiCkkeSoaepnnap
         ZeGIAP5HxLzbhWaMzAmteFCV3Ln+LysJ+94LNf1b+0MvknxBMqI8BteX2eq/kDGlLNj6
         T3sDrIeksAdHdldmrn7Ug7m5FmvQIblcIwRbV36CqDmgyXWh1r3VfU81xyuj+k5cDd3h
         lsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eB7aZXTG/r9znzgI5ELRRkyUfRHeewkpT855MZu37AE=;
        b=fz4PiSKxKBwtMYHbcm7XdyNl/XktQpEjB+LWRGc/rI9vBRFRTrBfJrKzf/6OErRhBv
         NOlvVX7OWgRCdt+bl6SG7p8ViGLyIsNC4uxfEWJTTmOk1Pn/mM6M4mKtP67+rTZ3VceS
         m2wx5LlCBuAUyCtLKjYej2rLoX9FUVqRVvpxwDEiZ8CmGI7m0RxLk6tCbSTzmweicPMi
         kntjL4a06wIWLXFyfM+gESX/8f0/pdrwItt85X7ugDjCiXret+c5QD4y2ztcZ40TKdFY
         QhWZpKpIRDbG3jYY7bysXjJXk+R1mG3lNDbGLyWymbeX55R986bnIh02ahylmvBMndrJ
         eIFQ==
X-Gm-Message-State: AOAM530/dqGf8uNZxYMF9RDgmuqRw6YgzrTOW8+aXot0hILrA2IYHwOb
        GLQJihFnai0TQF4gHW7UGWA/AjR44TA=
X-Google-Smtp-Source: ABdhPJz4tMH1EqczGDDlpnTKl59BDhmPNmaAEMWZFfS0wgHvCUC6pMK7TO8gbZZ33TZZ4xCW1FhHc0s5mXQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:20c2:: with SMTP id g185mr8171042ybg.31.1613177442563;
 Fri, 12 Feb 2021 16:50:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:10 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 09/14] KVM: x86: Move MMU's PML logic to common code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the facade of KVM's PML logic being vendor specific and move the
bits that aren't truly VMX specific into common x86 code.  The MMU logic
for dealing with PML is tightly coupled to the feature and to VMX's
implementation, bouncing through kvm_x86_ops obfuscates the code without
providing any meaningful separation of concerns or encapsulation.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  4 ---
 arch/x86/include/asm/kvm_host.h    | 27 ++-------------
 arch/x86/kvm/mmu/mmu.c             | 16 +++------
 arch/x86/kvm/vmx/vmx.c             | 55 +-----------------------------
 arch/x86/kvm/x86.c                 | 22 ++++++++----
 5 files changed, 24 insertions(+), 100 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 28c07cc01474..90affdb2cbbc 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -93,10 +93,6 @@ KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_NULL(request_immediate_exit)
 KVM_X86_OP(sched_in)
-KVM_X86_OP_NULL(slot_enable_log_dirty)
-KVM_X86_OP_NULL(slot_disable_log_dirty)
-KVM_X86_OP_NULL(flush_log_dirty)
-KVM_X86_OP_NULL(enable_log_dirty_pt_masked)
 KVM_X86_OP_NULL(pre_block)
 KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb59933610d9..5cf382ec48b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1271,29 +1271,9 @@ struct kvm_x86_ops {
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 
 	/*
-	 * Arch-specific dirty logging hooks. These hooks are only supposed to
-	 * be valid if the specific arch has hardware-accelerated dirty logging
-	 * mechanism. Currently only for PML on VMX.
-	 *
-	 *  - slot_enable_log_dirty:
-	 *	called when enabling log dirty mode for the slot.
-	 *  - slot_disable_log_dirty:
-	 *	called when disabling log dirty mode for the slot.
-	 *	also called when slot is created with log dirty disabled.
-	 *  - flush_log_dirty:
-	 *	called before reporting dirty_bitmap to userspace.
-	 *  - enable_log_dirty_pt_masked:
-	 *	called when reenabling log dirty for the GFNs in the mask after
-	 *	corresponding bits are cleared in slot->dirty_bitmap.
+	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer.  A zero
+	 * value indicates CPU dirty logging is unsupported or disabled.
 	 */
-	void (*slot_enable_log_dirty)(struct kvm *kvm,
-				      struct kvm_memory_slot *slot);
-	void (*slot_disable_log_dirty)(struct kvm *kvm,
-				       struct kvm_memory_slot *slot);
-	void (*flush_log_dirty)(struct kvm *kvm);
-	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
-					   struct kvm_memory_slot *slot,
-					   gfn_t offset, unsigned long mask);
 	int cpu_dirty_log_size;
 
 	/* pmu operations of sub-arch */
@@ -1439,9 +1419,6 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 			    struct kvm_memory_slot *memslot);
-void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
-				   struct kvm_memory_slot *slot,
-				   gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6c32e8e0f720..86182e79beaf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1250,9 +1250,9 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
  *
  * Used for PML to re-log the dirty GPAs after userspace querying dirty_bitmap.
  */
-void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     gfn_t gfn_offset, unsigned long mask)
+static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
 
@@ -1268,7 +1268,6 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 		mask &= mask - 1;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
 
 /**
  * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
@@ -1284,10 +1283,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
-	if (kvm_x86_ops.enable_log_dirty_pt_masked)
-		static_call(kvm_x86_enable_log_dirty_pt_masked)(kvm, slot,
-								gfn_offset,
-								mask);
+	if (kvm_x86_ops.cpu_dirty_log_size)
+		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else
 		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
@@ -5616,7 +5613,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_leaf_clear_dirty);
 
 void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 					struct kvm_memory_slot *memslot)
@@ -5633,7 +5629,6 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
 void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 			    struct kvm_memory_slot *memslot)
@@ -5649,7 +5644,6 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f843707dd7df..862d1f5627e7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5776,24 +5776,6 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 	vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
 }
 
-/*
- * Flush all vcpus' PML buffer and update logged GPAs to dirty_bitmap.
- * Called before reporting dirty_bitmap to userspace.
- */
-static void kvm_flush_pml_buffers(struct kvm *kvm)
-{
-	int i;
-	struct kvm_vcpu *vcpu;
-	/*
-	 * We only need to kick vcpu out of guest mode here, as PML buffer
-	 * is flushed at beginning of all VMEXITs, and it's obvious that only
-	 * vcpus running in guest are possible to have unflushed GPAs in PML
-	 * buffer.
-	 */
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vcpu_kick(vcpu);
-}
-
 static void vmx_dump_sel(char *name, uint32_t sel)
 {
 	pr_err("%s sel=0x%04x, attr=0x%05x, limit=0x%08x, base=0x%016lx\n",
@@ -7517,32 +7499,6 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		shrink_ple_window(vcpu);
 }
 
-static void vmx_slot_enable_log_dirty(struct kvm *kvm,
-				     struct kvm_memory_slot *slot)
-{
-	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
-		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
-	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
-}
-
-static void vmx_slot_disable_log_dirty(struct kvm *kvm,
-				       struct kvm_memory_slot *slot)
-{
-	kvm_mmu_slot_set_dirty(kvm, slot);
-}
-
-static void vmx_flush_log_dirty(struct kvm *kvm)
-{
-	kvm_flush_pml_buffers(kvm);
-}
-
-static void vmx_enable_log_dirty_pt_masked(struct kvm *kvm,
-					   struct kvm_memory_slot *memslot,
-					   gfn_t offset, unsigned long mask)
-{
-	kvm_mmu_clear_dirty_pt_masked(kvm, memslot, offset, mask);
-}
-
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
 	if (pi_pre_block(vcpu))
@@ -7749,10 +7705,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.sched_in = vmx_sched_in,
 
-	.slot_enable_log_dirty = vmx_slot_enable_log_dirty,
-	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
-	.flush_log_dirty = vmx_flush_log_dirty,
-	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 
 	.pre_block = vmx_pre_block,
@@ -7897,13 +7849,8 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
 		enable_pml = 0;
 
-	if (!enable_pml) {
-		vmx_x86_ops.slot_enable_log_dirty = NULL;
-		vmx_x86_ops.slot_disable_log_dirty = NULL;
-		vmx_x86_ops.flush_log_dirty = NULL;
-		vmx_x86_ops.enable_log_dirty_pt_masked = NULL;
+	if (!enable_pml)
 		vmx_x86_ops.cpu_dirty_log_size = 0;
-	}
 
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3fa140383f5d..e89fe98a0099 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5214,10 +5214,18 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+
 	/*
-	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
+	 * Flush all CPUs' dirty log buffers to the  dirty_bitmap.  Called
+	 * before reporting dirty_bitmap to userspace.  KVM flushes the buffers
+	 * on all VM-Exits, thus we only need to kick running vCPUs to force a
+	 * VM-Exit.
 	 */
-	static_call_cond(kvm_x86_flush_log_dirty)(kvm);
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vcpu_kick(vcpu);
 }
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
@@ -10809,8 +10817,10 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * is enabled the D-bit or the W-bit will be cleared.
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-		if (kvm_x86_ops.slot_enable_log_dirty) {
-			static_call(kvm_x86_slot_enable_log_dirty)(kvm, new);
+		if (kvm_x86_ops.cpu_dirty_log_size) {
+			if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
+				kvm_mmu_slot_leaf_clear_dirty(kvm, new);
+			kvm_mmu_slot_largepage_remove_write_access(kvm, new);
 		} else {
 			int level =
 				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
@@ -10826,8 +10836,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 			 */
 			kvm_mmu_slot_remove_write_access(kvm, new, level);
 		}
-	} else {
-		static_call_cond(kvm_x86_slot_disable_log_dirty)(kvm, new);
+	} else if (kvm_x86_ops.cpu_dirty_log_size) {
+		kvm_mmu_slot_set_dirty(kvm, new);
 	}
 }
 
-- 
2.30.0.478.g8a0d178c01-goog

