Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F113EC683
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhHOBDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:03:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235904AbhHOBDI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qjly44S3dCILyQ2iKSon07QnRkN6c5EsaYukhQEINi4=;
        b=B5/VcoE1DZitnY0XeWid1XT+BeorSxtvnzn/YGt86Qfg6V7c3XteDNv3HTlkGuOBEpbq9/
        g2CuJLJryuDvt/uh58ldO32cxqrZDl7qY1WyT3iVvRfG6JiqEGtW9RqzFe/kCvXTCsJ/LJ
        JEwvmyyI72r/Gi2pq6OrkbAbMVJz0xk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-RpErKFr2PG-KVwK3G5OIjg-1; Sat, 14 Aug 2021 21:02:35 -0400
X-MC-Unique: RpErKFr2PG-KVwK3G5OIjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA9828799E0;
        Sun, 15 Aug 2021 01:02:33 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBFDA6091B;
        Sun, 15 Aug 2021 01:02:25 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 09/15] KVM: arm64: Support async PF hypercalls
Date:   Sun, 15 Aug 2021 08:59:41 +0800
Message-Id: <20210815005947.83699-10-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This introduces (SMCCC) KVM vendor specific services to configure
the asynchronous page fault functionality. The following services
are introduced:

   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION
     Returns the version, which can be used to identify ABI changes
     in the future.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS
     Return maximal number of tokens that current vCPU can have.
     It's used by guest to allocate the required resources.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_{SDEI, IRQ}
     Return the associated SDEI or (PPI) IRQ number, configured by
     vCPU ioctl command.
   * ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE
     Enable or disable asynchronous page fault on current vCPU.

The corresponding SDEI event and (PPI) IRQ are owned by VMM. So they
are configured by vCPU ioctl interface and it will be implemented when
the asynchronous page fault capability is exported in the subsequent
patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/async_pf.c | 119 ++++++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h |   5 ++
 2 files changed, 124 insertions(+)

diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
index 0d2393e24ce6..3bc69a631996 100644
--- a/arch/arm64/kvm/async_pf.c
+++ b/arch/arm64/kvm/async_pf.c
@@ -313,11 +313,114 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token), 0);
 }
 
+static void kvm_arch_async_sdei_notifier(struct kvm_vcpu *vcpu,
+					 unsigned long num,
+					 unsigned int state)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+
+	if (!apf)
+		return;
+
+	if (num != apf->sdei_event_num) {
+		kvm_err("%s: Invalid event number (%d-%d %lx-%llx)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			num, apf->sdei_event_num);
+		return;
+	}
+
+	switch (state) {
+	case KVM_SDEI_NOTIFY_DELIVERED:
+		if (!apf->notpresent_pending)
+			break;
+
+		apf->notpresent_token = 0;
+		apf->notpresent_pending = false;
+		break;
+	case KVM_SDEI_NOTIFY_COMPLETED:
+		break;
+	default:
+		kvm_err("%s: Invalid state (%d-%d %lx-%d)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			num, state);
+	}
+}
+
+static long kvm_arch_async_enable(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	gpa_t gpa = (data & ~0x3FUL);
+	bool enabled, enable;
+	int ret;
+
+	if (!apf || !irqchip_in_kernel(kvm))
+		return SMCCC_RET_NOT_SUPPORTED;
+
+	/* Bail if the state transition isn't allowed */
+	enabled = !!(apf->control_block & KVM_ASYNC_PF_ENABLED);
+	enable = !!(data & KVM_ASYNC_PF_ENABLED);
+	if (enable == enabled) {
+		kvm_debug("%s: Async PF has been %s on (%d-%d %llx-%llx)\n",
+			  __func__, enabled ? "enabled" : "disabled",
+			  kvm->userspace_pid, vcpu->vcpu_idx,
+			  apf->control_block, data);
+		return SMCCC_RET_NOT_REQUIRED;
+	}
+
+	/* To disable the functinality */
+	if (!enable) {
+		kvm_clear_async_pf_completion_queue(vcpu);
+		apf->control_block = data;
+		return SMCCC_RET_SUCCESS;
+	}
+
+	/*
+	 * The SDEI event and IRQ number should have been given
+	 * prior to enablement.
+	 */
+	if (!apf->sdei_event_num || !apf->irq) {
+		kvm_err("%s: Invalid SDEI event or IRQ (%d-%d %llx-%d)\n",
+			__func__, kvm->userspace_pid, vcpu->vcpu_idx,
+			apf->sdei_event_num, apf->irq);
+		return SMCCC_RET_INVALID_PARAMETER;
+	}
+
+	/* Register SDEI event notifier */
+	ret = kvm_sdei_register_notifier(kvm, apf->sdei_event_num,
+					 kvm_arch_async_sdei_notifier);
+	if (ret) {
+		kvm_err("%s: Error %d registering SDEI notifier (%d-%d %llx)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx,
+			apf->sdei_event_num);
+		return SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	/* Initialize cache shared by host and guest */
+	ret = kvm_gfn_to_hva_cache_init(kvm, &apf->cache, gpa,
+			offsetofend(struct kvm_vcpu_pv_apf_data, token));
+	if (ret) {
+		kvm_err("%s: Error %d initializing cache (%d-%d)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		return SMCCC_RET_NOT_SUPPORTED;
+	}
+
+	/* Flush the token table */
+	kvm_async_pf_reset_slot(vcpu);
+	apf->send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
+	kvm_async_pf_wakeup_all(vcpu);
+	apf->control_block = data;
+
+	return SMCCC_RET_SUCCESS;
+}
+
 void kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu, u64 *val)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
 	u32 func;
+	u64 data;
 	long ret = SMCCC_RET_SUCCESS;
 
 	if (!apf) {
@@ -327,6 +430,22 @@ void kvm_arch_async_pf_hypercall(struct kvm_vcpu *vcpu, u64 *val)
 
 	func = smccc_get_arg1(vcpu);
 	switch (func) {
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION:
+		val[1] = 0x010000; /* v1.0.0 */
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS:
+		val[1] = ASYNC_PF_PER_VCPU;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI:
+		val[1] = apf->sdei_event_num;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ:
+		val[1] = apf->irq;
+		break;
+	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE:
+		data = (smccc_get_arg3(vcpu) << 32) | smccc_get_arg2(vcpu);
+		ret = kvm_arch_async_enable(vcpu, data);
+		break;
 	case ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK:
 		if (!apf->pageready_pending)
 			break;
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index e7d8ade1b3dd..979424f620d5 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -135,6 +135,11 @@
 #define KVM_PTP_PHYS_COUNTER			1
 
 /* Asynchronous page fault service */
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_VERSION	0
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_SLOTS	1
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_SDEI	2
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ		3
+#define ARM_SMCCC_KVM_FUNC_ASYNC_PF_ENABLE	4
 #define ARM_SMCCC_KVM_FUNC_ASYNC_PF_IRQ_ACK	5
 
 #define ARM_SMCCC_VENDOR_HYP_KVM_ASYNC_PF_FUNC_ID		\
-- 
2.23.0

