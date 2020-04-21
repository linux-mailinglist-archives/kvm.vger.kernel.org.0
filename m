Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A01B2D82
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgDUQ4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 12:56:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54782 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729583AbgDUQ4q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 12:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587488203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=TnqGPGJRotySr0OkVjnPeHFN4meBGz0j3Dj8kBA70mU=;
        b=BDXviG3ry3OPRKVKEUllT3KnF3cCM1bk+pBWTp+XpKQlyCnLNGU1NZ9Ppa/Ryv0bXQk17F
        Kq2BoCKtR2IMTSO0DLZe+KO4nZokpwoVajpmGgEv8yqJEsyxHfFrbEtunDxXvwvW1qYEFI
        EZCav4CKCqHpAY/Uig83L9Py1bNAeMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-As9WFir0Oxyk884ufoUTXw-1; Tue, 21 Apr 2020 12:56:40 -0400
X-MC-Unique: As9WFir0Oxyk884ufoUTXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2026F1005509;
        Tue, 21 Apr 2020 16:56:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 600D948;
        Tue, 21 Apr 2020 16:56:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 3/3] KVM: x86: move nested-related kvm_x86_ops to a separate struct
Date:   Tue, 21 Apr 2020 12:56:32 -0400
Message-Id: <20200421165632.20157-4-pbonzini@redhat.com>
In-Reply-To: <20200421165632.20157-1-pbonzini@redhat.com>
References: <20200421165632.20157-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean up some of the patching of kvm_x86_ops, by moving kvm_x86_ops related to
nested virtualization into a separate struct.

As a result, these ops will always be non-NULL on VMX.  This is not a problem:

* check_nested_events is only called if is_guest_mode(vcpu) returns true

* get_nested_state treats VMXOFF state the same as nested being disabled

* set_nested_state fails if you attempt to set nested state while
  nesting is disabled

* nested_enable_evmcs could already be called on a CPU without VMX enabled
  in CPUID.

* nested_get_evmcs_version was fixed in the previous patch

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 29 ++++++++++++++++-------------
 arch/x86/kvm/hyperv.c           |  4 ++--
 arch/x86/kvm/svm/nested.c       |  6 +++++-
 arch/x86/kvm/svm/svm.c          | 13 +++++--------
 arch/x86/kvm/svm/svm.h          |  3 ++-
 arch/x86/kvm/vmx/nested.c       | 16 +++++++++-------
 arch/x86/kvm/vmx/nested.h       |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  7 +------
 arch/x86/kvm/x86.c              | 28 ++++++++++++++--------------
 9 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f26df2cb0591..a239a297be33 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1178,7 +1178,6 @@ struct kvm_x86_ops {
 			       struct x86_exception *exception);
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
-	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
 
 	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
@@ -1211,6 +1210,7 @@ struct kvm_x86_ops {
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
+	const struct kvm_x86_nested_ops *nested_ops;
 
 	/*
 	 * Architecture specific hooks for vCPU blocking due to
@@ -1238,14 +1238,6 @@ struct kvm_x86_ops {
 
 	void (*setup_mce)(struct kvm_vcpu *vcpu);
 
-	int (*get_nested_state)(struct kvm_vcpu *vcpu,
-				struct kvm_nested_state __user *user_kvm_nested_state,
-				unsigned user_data_size);
-	int (*set_nested_state)(struct kvm_vcpu *vcpu,
-				struct kvm_nested_state __user *user_kvm_nested_state,
-				struct kvm_nested_state *kvm_state);
-	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
-
 	int (*smi_allowed)(struct kvm_vcpu *vcpu);
 	int (*pre_enter_smm)(struct kvm_vcpu *vcpu, char *smstate);
 	int (*pre_leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
@@ -1257,16 +1249,27 @@ struct kvm_x86_ops {
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
-	int (*nested_enable_evmcs)(struct kvm_vcpu *vcpu,
-				   uint16_t *vmcs_version);
-	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
-
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 };
 
+struct kvm_x86_nested_ops {
+	int (*check_events)(struct kvm_vcpu *vcpu);
+	int (*get_state)(struct kvm_vcpu *vcpu,
+			 struct kvm_nested_state __user *user_kvm_nested_state,
+			 unsigned user_data_size);
+	int (*set_state)(struct kvm_vcpu *vcpu,
+			 struct kvm_nested_state __user *user_kvm_nested_state,
+			 struct kvm_nested_state *kvm_state);
+	bool (*get_vmcs12_pages)(struct kvm_vcpu *vcpu);
+
+	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
+			    uint16_t *vmcs_version);
+	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
+};
+
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index b850f676abe4..2f96ff9e60ee 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1799,8 +1799,8 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 	};
 	int i, nent = ARRAY_SIZE(cpuid_entries);
 
-	if (kvm_x86_ops.nested_get_evmcs_version)
-		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
+	if (kvm_x86_ops.nested_ops->get_evmcs_version)
+		evmcs_ver = kvm_x86_ops.nested_ops->get_evmcs_version(vcpu);
 
 	/* Skip NESTED_FEATURES if eVMCS is not supported */
 	if (!evmcs_ver)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3e5bd739a6f6..6ea047e6882e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -784,7 +784,7 @@ static bool nested_exit_on_intr(struct vcpu_svm *svm)
 	return (svm->nested.intercept & 1ULL);
 }
 
-int svm_check_nested_events(struct kvm_vcpu *vcpu)
+static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool block_nested_events =
@@ -825,3 +825,7 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 
 	return NESTED_EXIT_CONTINUE;
 }
+
+struct kvm_x86_nested_ops svm_nested_ops = {
+	.check_events = svm_check_nested_events,
+};
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb95283ab68d..c86f7278509b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3902,9 +3902,9 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	/*
 	 * TODO: Last condition latch INIT signals on vCPU when
 	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
-	 * To properly emulate the INIT intercept, SVM should implement
-	 * kvm_x86_ops.check_nested_events() and call nested_svm_vmexit()
-	 * there if an INIT signal is pending.
+	 * To properly emulate the INIT intercept,
+	 * svm_check_nested_events() should call nested_svm_vmexit()
+	 * if an INIT signal is pending.
 	 */
 	return !gif_set(svm) ||
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
@@ -4032,6 +4032,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.sched_in = svm_sched_in,
 
 	.pmu_ops = &amd_pmu_ops,
+	.nested_ops = &svm_nested_ops,
+
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
@@ -4046,14 +4048,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
 
-	.nested_enable_evmcs = NULL,
-	.nested_get_evmcs_version = NULL,
-
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
-
-	.check_nested_events = svm_check_nested_events,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ca95204f9dde..98c2890d561d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -398,9 +398,10 @@ int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct vcpu_svm *svm);
 int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 			       bool has_error_code, u32 error_code);
-int svm_check_nested_events(struct kvm_vcpu *vcpu);
 int nested_svm_exit_special(struct vcpu_svm *svm);
 
+extern struct kvm_x86_nested_ops svm_nested_ops;
+
 /* avic.c */
 
 #define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f228339cd0a0..56074d3443e0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6440,12 +6440,14 @@ __init int nested_vmx_hardware_setup(struct kvm_x86_ops *ops,
 	exit_handlers[EXIT_REASON_INVVPID]	= handle_invvpid;
 	exit_handlers[EXIT_REASON_VMFUNC]	= handle_vmfunc;
 
-	ops->check_nested_events = vmx_check_nested_events;
-	ops->get_nested_state = vmx_get_nested_state;
-	ops->set_nested_state = vmx_set_nested_state;
-	ops->get_vmcs12_pages = nested_get_vmcs12_pages;
-	ops->nested_enable_evmcs = nested_enable_evmcs;
-	ops->nested_get_evmcs_version = nested_get_evmcs_version;
-
 	return 0;
 }
+
+struct kvm_x86_nested_ops vmx_nested_ops = {
+	.check_events = vmx_check_nested_events,
+	.get_state = vmx_get_nested_state,
+	.set_state = vmx_set_nested_state,
+	.get_vmcs12_pages = nested_get_vmcs12_pages,
+	.enable_evmcs = nested_enable_evmcs,
+	.get_evmcs_version = nested_get_evmcs_version,
+};
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 1514ff4db77f..7ce9572c3d3a 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -278,4 +278,6 @@ static inline bool nested_cr4_valid(struct kvm_vcpu *vcpu, unsigned long val)
 #define nested_guest_cr4_valid	nested_cr4_valid
 #define nested_host_cr4_valid	nested_cr4_valid
 
+extern struct kvm_x86_nested_ops vmx_nested_ops;
+
 #endif /* __KVM_X86_VMX_NESTED_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b31949..455cd2c8dbce 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7862,6 +7862,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.post_block = vmx_post_block,
 
 	.pmu_ops = &intel_pmu_ops,
+	.nested_ops = &vmx_nested_ops,
 
 	.update_pi_irte = vmx_update_pi_irte,
 
@@ -7877,12 +7878,6 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.pre_leave_smm = vmx_pre_leave_smm,
 	.enable_smi_window = enable_smi_window,
 
-	.check_nested_events = NULL,
-	.get_nested_state = NULL,
-	.set_nested_state = NULL,
-	.get_vmcs12_pages = NULL,
-	.nested_enable_evmcs = NULL,
-	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0492baeb78ab..8c0b77ac8dc6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3442,14 +3442,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_X2APIC_API_VALID_FLAGS;
 		break;
 	case KVM_CAP_NESTED_STATE:
-		r = kvm_x86_ops.get_nested_state ?
-			kvm_x86_ops.get_nested_state(NULL, NULL, 0) : 0;
+		r = kvm_x86_ops.nested_ops->get_state ?
+			kvm_x86_ops.nested_ops->get_state(NULL, NULL, 0) : 0;
 		break;
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
 		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
-		r = kvm_x86_ops.nested_enable_evmcs != NULL;
+		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
 	default:
 		break;
@@ -4235,9 +4235,9 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		return kvm_hv_activate_synic(vcpu, cap->cap ==
 					     KVM_CAP_HYPERV_SYNIC2);
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
-		if (!kvm_x86_ops.nested_enable_evmcs)
+		if (!kvm_x86_ops.nested_ops->enable_evmcs)
 			return -ENOTTY;
-		r = kvm_x86_ops.nested_enable_evmcs(vcpu, &vmcs_version);
+		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
 		if (!r) {
 			user_ptr = (void __user *)(uintptr_t)cap->args[0];
 			if (copy_to_user(user_ptr, &vmcs_version,
@@ -4552,7 +4552,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		u32 user_data_size;
 
 		r = -EINVAL;
-		if (!kvm_x86_ops.get_nested_state)
+		if (!kvm_x86_ops.nested_ops->get_state)
 			break;
 
 		BUILD_BUG_ON(sizeof(user_data_size) != sizeof(user_kvm_nested_state->size));
@@ -4560,8 +4560,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (get_user(user_data_size, &user_kvm_nested_state->size))
 			break;
 
-		r = kvm_x86_ops.get_nested_state(vcpu, user_kvm_nested_state,
-						  user_data_size);
+		r = kvm_x86_ops.nested_ops->get_state(vcpu, user_kvm_nested_state,
+						     user_data_size);
 		if (r < 0)
 			break;
 
@@ -4582,7 +4582,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		int idx;
 
 		r = -EINVAL;
-		if (!kvm_x86_ops.set_nested_state)
+		if (!kvm_x86_ops.nested_ops->set_state)
 			break;
 
 		r = -EFAULT;
@@ -4604,7 +4604,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			break;
 
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = kvm_x86_ops.set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
+		r = kvm_x86_ops.nested_ops->set_state(vcpu, user_kvm_nested_state, &kvm_state);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	}
@@ -7700,7 +7700,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	 * from L2 to L1.
 	 */
 	if (is_guest_mode(vcpu)) {
-		r = kvm_x86_ops.check_nested_events(vcpu);
+		r = kvm_x86_ops.nested_ops->check_events(vcpu);
 		if (r != 0)
 			return r;
 	}
@@ -7762,7 +7762,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 		 * KVM_REQ_EVENT only on certain events and not unconditionally?
 		 */
 		if (is_guest_mode(vcpu)) {
-			r = kvm_x86_ops.check_nested_events(vcpu);
+			r = kvm_x86_ops.nested_ops->check_events(vcpu);
 			if (r != 0)
 				return r;
 		}
@@ -8185,7 +8185,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
-			if (unlikely(!kvm_x86_ops.get_vmcs12_pages(vcpu))) {
+			if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu))) {
 				r = 0;
 				goto out;
 			}
@@ -8528,7 +8528,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu))
-		kvm_x86_ops.check_nested_events(vcpu);
+		kvm_x86_ops.nested_ops->check_events(vcpu);
 
 	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
 		!vcpu->arch.apf.halted);
-- 
2.18.2

