Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0631A909
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhBMAwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbhBMAwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D19C061224
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:48 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u1so1524289ybu.14
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vAUj1QEzZ3IxK3/yVqmKPFgLci8u89T6WcbRl7o0ykk=;
        b=v38vgtVex5oPOQ/p2ju/i7R4VJ05Z3u4THIpVVuw3QoUoGddVSK9XylTZWnIX9NmBs
         c9sVuGNoEdF5IL6IK1z+luuyOYQThJD0LEa45+yjFtpq55453hF1Q7LNj6/6NCGl9aeM
         AEiy6Gr2Irjydjw8m9IVuJSfIADSSTziGYj7trFlDUXgqxuAU/+Zz17Ix+4V13YaQWpJ
         8JjXmQ2s+CYTltmHthWSU2bLn8bCxbzcg4L/5Q2ljHB7A6UuWBYMwi5f+chm87MAKd9E
         2swIPO+agfjeEL/Ls1uqim5leNDQLNGVR7hmVME4jXmGm8BofGNXpACQtYakKLYSiJB6
         5IQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vAUj1QEzZ3IxK3/yVqmKPFgLci8u89T6WcbRl7o0ykk=;
        b=EqOHVEoSfEJBj4cTSqDnn2zDsUgOILg7fT0xqFgA/l+lKLlLWBkCqBMVP3ybUBS1Ug
         xR00jvQvNfOyqGWlsxcw51zwkI1Xlyk3799V2wstVEzLJKLFowxHZ5IIYVTeOHNv0bBm
         oBEOggp1RiqZS5GxRxzxNkHhrU1uBglv4nFdXwdfAimaD/axz3rzf9XAui4qDywtHJfc
         ico5EM6DXx4RiUuDI0zR66BHeH061eK3UnGCReE0eq4g+TGxEPFsHknPjuA6DmUXoxk+
         OiVxpCsvnJjM3hkCYKaDYI9pnS7nscyy+jfVtIPpXYnLICP1Uf9XgXPtvqKqUMJSX0so
         DCLQ==
X-Gm-Message-State: AOAM531adGxTOitBgwNeXw1l/H8zH+hJ3vt6jGiV/LJlBb5OhT6r9xab
        twT5poG7qdBmMrvJe54iAOgmgM/BCKI=
X-Google-Smtp-Source: ABdhPJyVoTF6JdPZf5atU9FYPKpJaVfFucGsmKAXdWcBu9raL7IJ+KWWsssySoXqhCD6QceFfYMXuid8GD0=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:e752:: with SMTP id e79mr8095690ybh.373.1613177447390;
 Fri, 12 Feb 2021 16:50:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:12 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 11/14] KVM: VMX: Dynamically enable/disable PML based on
 memslot dirty logging
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

From: Makarand Sonare <makarandsonare@google.com>

Currently, if enable_pml=1 PML remains enabled for the entire lifetime
of the VM irrespective of whether dirty logging is enable or disabled.
When dirty logging is disabled, all the pages of the VM are manually
marked dirty, so that PML is effectively non-operational.  Setting
the dirty bits is an expensive operation which can cause severe MMU
lock contention in a performance sensitive path when dirty logging is
disabled after a failed or canceled live migration.

Manually setting dirty bits also fails to prevent PML activity if some
code path clears dirty bits, which can incur unnecessary VM-Exits.

In order to avoid this extra overhead, dynamically enable/disable PML
when dirty logging gets turned on/off for the first/last memslot.

Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/vmx/nested.c          |  5 +++++
 arch/x86/kvm/vmx/vmx.c             | 28 +++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  2 ++
 arch/x86/kvm/x86.c                 | 35 ++++++++++++++++++++++++++----
 6 files changed, 70 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 90affdb2cbbc..323641097f63 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -93,6 +93,7 @@ KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_NULL(request_immediate_exit)
 KVM_X86_OP(sched_in)
+KVM_X86_OP_NULL(update_cpu_dirty_logging)
 KVM_X86_OP_NULL(pre_block)
 KVM_X86_OP_NULL(post_block)
 KVM_X86_OP_NULL(vcpu_blocking)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5cf382ec48b0..ffcfa84c969d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -89,6 +89,8 @@
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
+#define KVM_REQ_UPDATE_CPU_DIRTY_LOGGING \
+	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1007,6 +1009,7 @@ struct kvm_arch {
 	u32 bsp_vcpu_id;
 
 	u64 disabled_quirks;
+	int cpu_dirty_logging_count;
 
 	enum kvm_irqchip_mode irqchip_mode;
 	u8 nr_reserved_ioapic_pins;
@@ -1275,6 +1278,7 @@ struct kvm_x86_ops {
 	 * value indicates CPU dirty logging is unsupported or disabled.
 	 */
 	int cpu_dirty_log_size;
+	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0c6dda9980a6..a63da447ede9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4493,6 +4493,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_set_virtual_apic_mode(vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_cpu_dirty_logging) {
+		vmx->nested.update_vmcs01_cpu_dirty_logging = false;
+		vmx_update_cpu_dirty_logging(vcpu);
+	}
+
 	/* Unpin physical memory we referred to in vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		kvm_release_page_clean(vmx->nested.apic_access_page);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 862d1f5627e7..1204e5f0fe67 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4277,7 +4277,12 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	*/
 	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
-	if (!enable_pml)
+	/*
+	 * PML is enabled/disabled when dirty logging of memsmlots changes, but
+	 * it needs to be set here when dirty logging is already active, e.g.
+	 * if this vCPU was created after dirty logging was enabled.
+	 */
+	if (!vcpu->kvm->arch.cpu_dirty_logging_count)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
 	if (cpu_has_vmx_xsaves()) {
@@ -7499,6 +7504,26 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		shrink_ple_window(vcpu);
 }
 
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (is_guest_mode(vcpu)) {
+		vmx->nested.update_vmcs01_cpu_dirty_logging = true;
+		return;
+	}
+
+	/*
+	 * Note, cpu_dirty_logging_count can be changed concurrent with this
+	 * code, but in that case another update request will be made and so
+	 * the guest will never run with a stale PML value.
+	 */
+	if (vcpu->kvm->arch.cpu_dirty_logging_count)
+		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_ENABLE_PML);
+	else
+		secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_ENABLE_PML);
+}
+
 static int vmx_pre_block(struct kvm_vcpu *vcpu)
 {
 	if (pi_pre_block(vcpu))
@@ -7706,6 +7731,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.sched_in = vmx_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
+	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12c53d05a902..89da5e1251f1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -165,6 +165,7 @@ struct nested_vmx {
 
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
+	bool update_vmcs01_cpu_dirty_logging;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
@@ -393,6 +394,7 @@ int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 	u32 msr, int type, bool value);
+void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
 static inline u8 vmx_get_rvi(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0d22f19aed0..b9a8c8af9713 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8987,6 +8987,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
 			static_call(kvm_x86_msr_filter_changed)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
+			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -10755,14 +10758,38 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	return 0;
 }
 
+
+static void kvm_mmu_update_cpu_dirty_logging(struct kvm *kvm, bool enable)
+{
+	struct kvm_arch *ka = &kvm->arch;
+
+	if (!kvm_x86_ops.cpu_dirty_log_size)
+		return;
+
+	if ((enable && ++ka->cpu_dirty_logging_count == 1) ||
+	    (!enable && --ka->cpu_dirty_logging_count == 0))
+		kvm_make_all_cpus_request(kvm, KVM_REQ_UPDATE_CPU_DIRTY_LOGGING);
+
+	WARN_ON_ONCE(ka->cpu_dirty_logging_count < 0);
+}
+
 static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     struct kvm_memory_slot *old,
 				     struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
+	bool log_dirty_pages = new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+
 	/*
-	 * Nothing to do for RO slots (which can't be dirtied and can't be made
-	 * writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
+	 * Update CPU dirty logging if dirty logging is being toggled.  This
+	 * applies to all operations.
+	 */
+	if ((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)
+		kvm_mmu_update_cpu_dirty_logging(kvm, log_dirty_pages);
+
+	/*
+	 * Nothing more to do for RO slots (which can't be dirtied and can't be
+	 * made writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
 	 */
 	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
 		return;
@@ -10792,7 +10819,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * MOVE/DELETE: The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot()
 	 */
-	if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+	if (!log_dirty_pages)
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
 
 	/*
@@ -10823,7 +10850,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * initial-all-set state.  Otherwise, depending on whether pml
 	 * is enabled the D-bit or the W-bit will be cleared.
 	 */
-	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (log_dirty_pages) {
 		if (kvm_x86_ops.cpu_dirty_log_size) {
 			if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
 				kvm_mmu_slot_leaf_clear_dirty(kvm, new);
-- 
2.30.0.478.g8a0d178c01-goog

