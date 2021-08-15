Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8133EC681
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhHOBDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235904AbhHOBC5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SR5OAIB+uURNVHLdFZPaUNNjtzGvD58sY4JtvBw8/WM=;
        b=DwpShyW+a3Gr6LsFY22uLv/VG8N+5xMTxlrTPcHKfivOWnS0AuNVxPRgqPHF+n0uPTx7xt
        L+dSpUK68pQRqqyPOxsXKJubyA9kXTHh3aRuGapEUzLmH4b5DcAAGEC7cfrgw8oxWLxy99
        8vcASfCdmZvoPPu6HeUKJkHNTfZBTIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-ZbDmkFBYOvGRZqSQ5OGYIw-1; Sat, 14 Aug 2021 21:02:27 -0400
X-MC-Unique: ZbDmkFBYOvGRZqSQ5OGYIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC892E74;
        Sun, 15 Aug 2021 01:02:25 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76ED16091B;
        Sun, 15 Aug 2021 01:02:19 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 08/15] KVM: arm64: Support page-ready notification
Date:   Sun, 15 Aug 2021 08:59:40 +0800
Message-Id: <20210815005947.83699-9-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The asynchronous page fault starts with a worker when the requested
page isn't present. The worker makes the requested page present
in the background and the worker, together with the associated
information, is queued to the completion queue after that. The
worker and the completion queue are checked as below.

   * A request (KVM_REQ_ASYNC_PF) is raised if the worker is the
     first one enqueued to the completion queue. With the request,
     the completion queue is checked and the worker is dequeued.
     A PPI is sent to guest as the page-ready notification and
     the guest should acknowledge the interrupt by SMCCC interface.

   * When the notification (PPI) is acknowledged by guest, the
     completion queue is checked again and next worker is dequeued
     if we have one. For this particular worker, another notification
     (PPI) is sent to the guest without raising the request. Once the
     notification (PPI) is acknowledged by the guest, the completion
     queue is checked to process next worker, which has been queued
     to it.

Similar to page-not-present notification, the shared memory region
is used to convey the reason and token associated with the page-ready
notification. The region is represented by "struct kvm_vcpu_pv_apf_data".

The feature isn't enabled by CONFIG_KVM_ASYNC_PF yet. Also, the control
path isn't implemented and will be done in the subsequent patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h      |  15 ++
 arch/arm64/include/uapi/asm/kvm_para.h |   1 +
 arch/arm64/kvm/arm.c                   |  24 ++-
 arch/arm64/kvm/async_pf.c              | 205 +++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c            |   5 +
 include/linux/arm-smccc.h              |  10 ++
 6 files changed, 257 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6b98aef936b4..bec95e263f93 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -48,6 +48,7 @@
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 #define KVM_REQ_SDEI		KVM_ARCH_REQ(6)
+#define KVM_REQ_ASYNC_PF	KVM_ARCH_REQ(7)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
@@ -302,10 +303,12 @@ struct kvm_arch_async_pf_control {
 		u64			control_block;
 		bool			send_user_only;
 		u64			sdei_event_num;
+		u32			irq;
 
 		u16			id;
 		bool			notpresent_pending;
 		u32			notpresent_token;
+		bool			pageready_pending;
 };
 
 struct kvm_vcpu_arch {
@@ -776,6 +779,13 @@ bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
 			     u32 esr, gpa_t gpa, gfn_t gfn);
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
+			       struct kvm_async_pf *work);
+void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+				 struct kvm_async_pf *work);
+void kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu, u64 *val);
 void kvm_arch_async_pf_destroy_vcpu(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_arch_async_pf_create_vcpu(struct kvm_vcpu *vcpu) { }
@@ -791,6 +801,11 @@ static inline bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
 {
 	return false;
 }
+
+static inline void kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu, u64 *val)
+{
+	val[0] = SMCCC_RET_NOT_SUPPORTED;
+}
 #endif
 
 /* Guest/host FPSIMD coordination helpers */
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
index 3fa04006714e..162325e2638f 100644
--- a/arch/arm64/include/uapi/asm/kvm_para.h
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -9,6 +9,7 @@
 #define KVM_ASYNC_PF_SEND_ALWAYS	(1 << 1)
 
 #define KVM_PV_REASON_PAGE_NOT_PRESENT	1
+#define KVM_PV_REASON_PAGE_READY	2
 
 struct kvm_vcpu_pv_apf_data {
 	__u32	reason;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index af251896b41d..84f11c6b790c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -503,9 +503,23 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
+	struct kvm_arch_async_pf_control *apf = v->arch.apf;
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
-	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+
+	if ((irq_lines || kvm_vgic_vcpu_pending_irq(v)) &&
+	    !v->arch.power_off && !v->arch.pause)
+		return true;
+
+	if (apf && (apf->control_block & KVM_ASYNC_PF_ENABLED)) {
+		if (kvm_check_async_pf_completion_queue(v))
+			return true;
+
+		if (apf->notpresent_pending ||
+		    apf->pageready_pending)
+			return true;
+	}
+
+	return false;
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -695,6 +709,9 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
+		if (kvm_check_request(KVM_REQ_ASYNC_PF, vcpu))
+			kvm_check_async_pf_completion(vcpu);
+
 		if (kvm_check_request(KVM_REQ_SDEI, vcpu))
 			kvm_sdei_deliver(vcpu);
 
@@ -825,7 +842,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || need_new_vmid_gen(&vcpu->arch.hw_mmu->vmid) ||
-		    kvm_request_pending(vcpu)) {
+		    (kvm_request_pending(vcpu) &&
+		     READ_ONCE(vcpu->requests) != (1UL << KVM_REQ_ASYNC_PF))) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
 			kvm_pmu_sync_hwstate(vcpu);
diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
index 742bb8a0a8c0..0d2393e24ce6 100644
--- a/arch/arm64/kvm/async_pf.c
+++ b/arch/arm64/kvm/async_pf.c
@@ -138,6 +138,211 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
+{
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+
+	kvm_make_request(KVM_REQ_ASYNC_PF, vcpu);
+	if (apf && !apf->pageready_pending)
+		kvm_vcpu_kick(vcpu);
+}
+
+bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	struct kvm_async_pf *work;
+	u32 reason, token;
+	int ret;
+
+	if (!apf || !(apf->control_block & KVM_ASYNC_PF_ENABLED))
+		return true;
+
+	if (apf->pageready_pending)
+		goto fail;
+
+	ret = read_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason),
+			 &reason);
+	if (ret) {
+		kvm_err("%s: Error %d to read reason (%d-%d)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		goto fail;
+	}
+
+	ret = read_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token),
+			 &token);
+	if (ret) {
+		kvm_err("%s: Error %d to read token (%d-%d)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		goto fail;
+	}
+
+	/*
+	 * There might be pending page-not-present notification (SDEI)
+	 * to be delivered. However, the corresponding work has been
+	 * completed. For this case, we need to cancel the notification
+	 * early to avoid the overhead because of the injected SDEI
+	 * and interrupt.
+	 */
+	if (apf->notpresent_pending) {
+		spin_lock(&vcpu->async_pf.lock);
+		work = list_first_entry_or_null(&vcpu->async_pf.done,
+						typeof(*work), link);
+		spin_unlock(&vcpu->async_pf.lock);
+		if (!work)
+			goto fail;
+
+		if (reason == KVM_PV_REASON_PAGE_NOT_PRESENT &&
+		    work->arch.token == apf->notpresent_token &&
+		    token == apf->notpresent_token) {
+			kvm_make_request(KVM_REQ_ASYNC_PF, vcpu);
+			return true;
+		}
+	}
+
+	if (reason || token)
+		goto fail;
+
+	return true;
+
+fail:
+	kvm_make_request(KVM_REQ_ASYNC_PF, vcpu);
+	return false;
+}
+
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
+			       struct kvm_async_pf *work)
+{
+	struct kvm_memory_slot *memslot;
+	unsigned int esr = work->arch.esr;
+	phys_addr_t gpa = work->cr2_or_gpa;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	unsigned long hva;
+	bool write_fault, writable;
+	int idx;
+
+	/*
+	 * We shouldn't issue prefault for special work to wake up
+	 * all pending tasks because the associated token (address)
+	 * is invalid.
+	 */
+	if (work->wakeup_all)
+		return;
+
+	/*
+	 * The gpa was validated before the work is started. However, the
+	 * memory slots might be changed since then. So we need to redo the
+	 * validatation here.
+	 */
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	if (esr_dabt_is_s1ptw(esr))
+		write_fault = true;
+	else if (ESR_ELx_EC(esr) == ESR_ELx_EC_IABT_LOW)
+		write_fault = false;
+	else
+		write_fault = esr_dabt_is_wnr(esr);
+
+	memslot = gfn_to_memslot(vcpu->kvm, gfn);
+	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
+	if (kvm_is_error_hva(hva) || (write_fault && !writable))
+		goto out;
+
+	kvm_handle_user_mem_abort(vcpu, memslot, gpa, hva, esr, true);
+
+out:
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+}
+
+/*
+ * It's guaranteed that no pending asynchronous page fault when this is
+ * called. It means all previous issued asynchronous page faults have
+ * been acknowledged.
+ */
+void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
+				 struct kvm_async_pf *work)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	int ret;
+
+	/*
+	 * The work could be completed prior to page-not-present notification
+	 * delivery. In this case, what we need to do is just to cancel the
+	 * page-not-present notification to avoid unnecessary overhead.
+	 */
+	if (work->wakeup_all) {
+		work->arch.token = ~0;
+	} else {
+		kvm_async_pf_remove_slot(vcpu, work->arch.gfn);
+
+		if (apf->notpresent_pending &&
+		    apf->notpresent_token == work->arch.token &&
+		    !kvm_sdei_cancel(vcpu, apf->sdei_event_num)) {
+			apf->notpresent_pending = false;
+			apf->notpresent_token = 0;
+			goto done;
+		}
+	}
+
+	ret = write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token),
+			  work->arch.token);
+	if (ret) {
+		kvm_err("%s: Error %d to write token (%d-%d %08x)\n",
+			__func__, ret, kvm->userspace_pid,
+			vcpu->vcpu_idx, work->arch.token);
+		goto done;
+	}
+
+	ret = write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason),
+			  KVM_PV_REASON_PAGE_READY);
+	if (ret) {
+		kvm_err("%s: Error %d to write reason (%d-%d %08x)\n",
+			__func__, ret, kvm->userspace_pid,
+			vcpu->vcpu_idx, work->arch.token);
+		goto done;
+	}
+
+	apf->pageready_pending = true;
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_idx,
+			    apf->irq, true, NULL);
+	return;
+
+done:
+	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason), 0);
+	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token), 0);
+}
+
+void kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	u32 func;
+	long ret = SMCCC_RET_SUCCESS;
+
+	if (!apf) {
+		val[0] = SMCCC_RET_NOT_SUPPORTED;
+		return;
+	}
+
+	func = smccc_get_arg1(vcpu);
+	switch (func) {
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK:
+		if (!apf->pageready_pending)
+			break;
+
+		kvm_vgic_inject_irq(kvm, vcpu->vcpu_idx,
+				    apf->irq, false, NULL);
+		apf->pageready_pending = false;
+		kvm_check_async_pf_completion(vcpu);
+		break;
+	default:
+		ret = SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	val[0] = ret;
+}
+
 void kvm_arch_async_pf_destroy_vcpu(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.apf);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index d3fc893a4f58..bf423cb27280 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -129,10 +129,15 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
 		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		if (vcpu->arch.apf)
+			val[0] |= BIT(ARM_SMCCC_KVM_FUNC_ASYNC_PF);
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
+	case ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID:
+		kvm_arch_async_pf_hypercall(vcpu, val);
+		break;
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 7d1cabe15262..e7d8ade1b3dd 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -107,6 +107,7 @@
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
 #define ARM_SMCCC_KVM_FUNC_PTP			1
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF		2
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -133,6 +134,15 @@
 #define KVM_PTP_VIRT_COUNTER			0
 #define KVM_PTP_PHYS_COUNTER			1
 
+/* Asynchronous page fault service */
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK	5
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,		\
+			   ARM_SMCCC_KVM_FUNC_ASYNC_PF)
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.23.0

