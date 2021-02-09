Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CBA315AC3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 01:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbhBJALS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 19:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbhBIX02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 18:26:28 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4515C061793
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 15:25:12 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 203so276192ybz.2
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 15:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=iH07BZvtOZg2/xaJwWGnBDe966Ae6BJm3E9r806bdwI=;
        b=AgNamMZV9wWprYcKCAqmQ4P76pONk5DoMf07lgpUbFo+VwOmIh/rjIaXXcNf/9JHCK
         /KAh0KQuQnKfYyZz1m+vZYYEcs3xgu9d638kjzPP/tP0OlJnqKmjNGo5oj2zcYBLKyFu
         OHh/Q4/hyjZAMRZwdtje5bvyNnL4yDF9Q1UWp66UbCcYe1+ZxQLztzkNQOBvB1fuJr0H
         rZ5ptVioj7tQ6VixNybGazPTKdihxDqe1elZseZ5uAtYmhaSBwegishZhvLItdOT3wki
         4fOpuFUUmshehQwbIXMUsD3l4bNRHlNauCoHbPK5xY2Ee+HCGKDEjFjHsx2T2Jg6KoEW
         CQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=iH07BZvtOZg2/xaJwWGnBDe966Ae6BJm3E9r806bdwI=;
        b=lX0KiFqSMXiVXqIxi27HmTMqmkMzcpR34TRa9g1g5yh1D2pDo0KgXpt53XhlJ41pcj
         uoGNn7hcHKPyWUurgidIZEy1WXUUN4MSm2zbk1aSeHQT29fU0T911vjYXZsnWgpxl3WE
         0BNoYtj/hun170MerMsaEyr9iI9sDTnKKxNj0WAPhRqDzY+dgV21Wz9x4K8qqbAn69G7
         ARuoIFrpiGp7B37DY4ZX67M4lP9vMUJaO1Cc6hUhP59v7zmWRW4aaqonwZPTt1CJpZqK
         O9l3YuYx8A4HrdCs/zNWbF4oYYmBiozc2CT0z0XTPLb78oFRrpSwcWbqAhh3gGR9Kvjw
         1nnw==
X-Gm-Message-State: AOAM531gX61KEXeAZ2JyYjY1JBVjMTP5tDZm2YJ7Y6MX1lGgXiQjTP1c
        puiUsiOjvSvGiHU+ufWIH1G/vN/PwMiATvYtLI/aBrtlpPxv+AfMj9X3vicAJ1a7SkVr9A0Ulc0
        8gl+NsSC0ygwbb1fAGFhED7oYf91fbjFGJc7tcrxfKRxzmXUp3k44rHFy7sNCC4wOBpwSjj3n4D
        QHQmU=
X-Google-Smtp-Source: ABdhPJzpYx+D1ANvlSJf8IUioFKvF3V5cH6Wf32p9niDo0AVSRF8Q8ha70GDsKFpvdbXPvCgIrM5UQTlRB6dwWsahJ8r5A==
Sender: "makarandsonare via sendgmr" 
        <makarandsonare@makarandsonare.sea.corp.google.com>
X-Received: from makarandsonare.sea.corp.google.com ([2620:15c:100:202:f836:545e:9426:1a3a])
 (user=makarandsonare job=sendgmr) by 2002:a25:5388:: with SMTP id
 h130mr313989ybb.329.1612913111933; Tue, 09 Feb 2021 15:25:11 -0800 (PST)
Date:   Tue,  9 Feb 2021 15:24:31 -0800
Message-Id: <20210209232431.1834019-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH ] KVM: VMX: Enable/disable PML when dirty logging gets enabled/disabled
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, if enable_pml=1 PML remains enabled for the entire lifetime
of the VM irrespective of whether dirty logging is enable or disabled.
When dirty logging is disabled, all the pages of the VM are manually
marked dirty, so that PML is effectively non-operational. Clearing
the dirty bits is an expensive operation which can cause severe MMU
lock contention in a performance sensitive path when dirty logging
is disabled after a failed or canceled live migration. Also, this
would break if some other code path clears the dirty bits in which
case, PML will actually start logging dirty pages even when dirty
logging is disabled incurring unnecessary vmexits when the PML buffer
becomes full. In order to avoid this extra overhead, we should
enable or disable PML in VMCS when dirty logging gets enabled
or disabled instead of keeping it always enabled.

Tested:
	kvm-unit-tests
	dirty_log_test
	dirty_log_perf_test

Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/vmx/nested.c       |  5 ++++
 arch/x86/kvm/vmx/vmx.c          | 49 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.h          |  3 ++
 arch/x86/kvm/x86.c              |  4 +++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             | 14 ++++++++--
 7 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1ed1206c196db..6aca4f0f9d806 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -91,6 +91,8 @@
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
 #define KVM_REQ_MSR_FILTER_CHANGED	KVM_ARCH_REQ(29)
+#define KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE \
+	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1029,6 +1031,7 @@ struct kvm_arch {
 	} msr_filter;
 
 	bool bus_lock_detection_enabled;
+	bool pml_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
 	struct task_struct *nx_lpage_recovery_thread;
@@ -1295,6 +1298,7 @@ struct kvm_x86_ops {
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
 	int (*cpu_dirty_log_size)(void);
+	void (*update_vcpu_dirty_logging_state)(struct kvm_vcpu *vcpu);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b2f0b5e9cd638..9e8e89fdc03a2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4495,6 +4495,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_set_virtual_apic_mode(vcpu);
 	}
 
+	if (vmx->nested.deferred_update_pml_vmcs) {
+		vmx->nested.deferred_update_pml_vmcs = false;
+		vmx_update_pml_in_vmcs(vcpu);
+	}
+
 	/* Unpin physical memory we referred to in vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		kvm_release_page_clean(vmx->nested.apic_access_page);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 777177ea9a35e..eb6639f0ee7eb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4276,7 +4276,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	*/
 	exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
 
-	if (!enable_pml)
+	if (!enable_pml || !vcpu->kvm->arch.pml_enabled)
 		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
 	if (cpu_has_vmx_xsaves()) {
@@ -7133,7 +7133,8 @@ static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
 		SECONDARY_EXEC_SHADOW_VMCS |
 		SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
-		SECONDARY_EXEC_DESC;
+		SECONDARY_EXEC_DESC |
+		SECONDARY_EXEC_ENABLE_PML;
 
 	u32 new_ctl = vmx->secondary_exec_control;
 	u32 cur_ctl = secondary_exec_controls_get(vmx);
@@ -7509,6 +7510,19 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 				     struct kvm_memory_slot *slot)
 {
+	/*
+	 * Check all slots and enable PML if dirty logging
+	 * is being enabled for the 1st slot
+	 *
+	 */
+	if (enable_pml &&
+	    kvm->dirty_logging_enable_count == 1 &&
+	    !kvm->arch.pml_enabled) {
+		kvm->arch.pml_enabled = true;
+		kvm_make_all_cpus_request(kvm,
+			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
+	}
+
 	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
 		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
 	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
@@ -7517,9 +7531,39 @@ static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 static void vmx_slot_disable_log_dirty(struct kvm *kvm,
 				       struct kvm_memory_slot *slot)
 {
+	/*
+	 * Check all slots and disable PML if dirty logging
+	 * is being disabled for the last slot
+	 *
+	 */
+	if (enable_pml &&
+	    kvm->dirty_logging_enable_count == 0 &&
+	    kvm->arch.pml_enabled) {
+		kvm->arch.pml_enabled = false;
+		kvm_make_all_cpus_request(kvm,
+			KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE);
+	}
+
 	kvm_mmu_slot_set_dirty(kvm, slot);
 }
 
+void vmx_update_pml_in_vmcs(struct kvm_vcpu *vcpu)
+{
+	if (cpu_has_secondary_exec_ctrls()) {
+		if (is_guest_mode(vcpu)) {
+			to_vmx(vcpu)->nested.deferred_update_pml_vmcs = true;
+			return;
+		}
+
+		if (vcpu->kvm->arch.pml_enabled)
+			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
+				SECONDARY_EXEC_ENABLE_PML);
+		else
+			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
+				SECONDARY_EXEC_ENABLE_PML);
+	}
+}
+
 static void vmx_flush_log_dirty(struct kvm *kvm)
 {
 	kvm_flush_pml_buffers(kvm);
@@ -7747,6 +7791,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.slot_disable_log_dirty = vmx_slot_disable_log_dirty,
 	.flush_log_dirty = vmx_flush_log_dirty,
 	.enable_log_dirty_pt_masked = vmx_enable_log_dirty_pt_masked,
+	.update_vcpu_dirty_logging_state = vmx_update_pml_in_vmcs,
 
 	.pre_block = vmx_pre_block,
 	.post_block = vmx_post_block,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 12c53d05a902b..b7dc413cda7bd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -181,6 +181,8 @@ struct nested_vmx {
 
 	struct loaded_vmcs vmcs02;
 
+	bool deferred_update_pml_vmcs;
+
 	/*
 	 * Guest pages referred to in the vmcs02 with host-physical
 	 * pointers, so we must keep them pinned while L2 runs.
@@ -393,6 +395,7 @@ int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 	u32 msr, int type, bool value);
+void vmx_update_pml_in_vmcs(struct kvm_vcpu *vcpu);
 
 static inline u8 vmx_get_rvi(void)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d9f931c632936..75b924c9c5af0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8984,6 +8984,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
 			static_call(kvm_x86_msr_filter_changed)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_VCPU_DIRTY_LOGGING_STATE,
+				      vcpu))
+			kvm_x86_ops.update_vcpu_dirty_logging_state(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f417447129b9c..a8a28ba955923 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -518,6 +518,7 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+	uint dirty_logging_enable_count;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee4ac2618ec59..c6e5b026bbfe8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -307,6 +307,7 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
 {
 	return kvm_make_all_cpus_request_except(kvm, req, NULL);
 }
+EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
 
 #ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
 void kvm_flush_remote_tlbs(struct kvm *kvm)
@@ -1366,15 +1367,24 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 
 	/* Allocate/free page dirty bitmap as needed */
-	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
+	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
 		new.dirty_bitmap = NULL;
-	else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
+
+		if (old.flags & KVM_MEM_LOG_DIRTY_PAGES) {
+			WARN_ON(kvm->dirty_logging_enable_count == 0);
+			--kvm->dirty_logging_enable_count;
+		}
+
+	} else if (!new.dirty_bitmap && !kvm->dirty_ring_size) {
 		r = kvm_alloc_dirty_bitmap(&new);
 		if (r)
 			return r;
 
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
+
+		++kvm->dirty_logging_enable_count;
+		WARN_ON(kvm->dirty_logging_enable_count == 0);
 	}
 
 	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
-- 
2.30.0.478.g8a0d178c01-goog

