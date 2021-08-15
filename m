Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903A43EC67F
	for <lists+kvm@lfdr.de>; Sun, 15 Aug 2021 03:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhHOBDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Aug 2021 21:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234494AbhHOBCw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Aug 2021 21:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628989343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQp6B6pA1iB5jYUjj14Os/ot1s6TAom9wF+HKG9aQew=;
        b=Vc6FvBf+6jEzoAHXZGEd5t+R1IIsfuRTv8Cx5MtjHfnx6eGhtPrOUwu83vV8AhM0p9HNhy
        a5phzUosmvEzVRrKG7kk8rtLMJp+BLprPfnahtOZX32EWz0+uZJIuCe9eyWKUjdZAf37nh
        hxFg5ayo7BSGmNNd+bueTe3bVvpH1Pw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-u6bjrEv4OjWxErhr_SHmSQ-1; Sat, 14 Aug 2021 21:02:20 -0400
X-MC-Unique: u6bjrEv4OjWxErhr_SHmSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC9021008062;
        Sun, 15 Aug 2021 01:02:18 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88C2E6091B;
        Sun, 15 Aug 2021 01:02:13 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        james.morse@arm.com, mark.rutland@arm.com,
        Jonathan.Cameron@huawei.com, will@kernel.org, maz@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v4 07/15] KVM: arm64: Support page-not-present notification
Date:   Sun, 15 Aug 2021 08:59:39 +0800
Message-Id: <20210815005947.83699-8-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The requested page might be not resident in memory during the stage-2
page fault. For example, the requested page could be resident in swap
device (file). In this case, disk I/O is issued in order to fetch the
requested page and it could take tens of milliseconds, even hundreds
of milliseconds in extreme situation. During the period, the guest's
vCPU is suspended until the requested page becomes ready. Actually,
the something else on the guest's vCPU could be rescheduled during
the period, so that the time slice isn't wasted as the guest's vCPU
can see. This is the primary goal of the feature (Asynchronous Page
Fault).

This supports delivery of page-not-present notification through SDEI
event when the requested page isn't present. When the notification is
received on the guest's vCPU, something else (another process) can be
scheduled. The design is highlighted as below:

   * There is dedicated memory region shared by host and guest. It's
     represented by "struct kvm_vcpu_pv_apf_data". The field @reason
     indicates the reason why the SDEI event is triggered, while the
     unique @token is used by guest to associate the event with the
     suspended process.

   * One control block is associated with each guest's vCPU and it's
     represented by "struct kvm_arch_async_pf_control". It allows the
     guest to configure the functionality to indicate the situations
     where the host can deliver the page-not-present notification to
     kick off asyncrhonous page fault. Besides, runtime states are
     also maintained in this struct.

   * Before the page-not-present notification is sent to the guest's
     vCPU, a worker is started and executed asynchronously on host,
     to fetch the requested page. "struct kvm{_,_arch}async_pf" is
     associated with the worker, to track the work.

The feature isn't enabled by CONFIG_KVM_ASYNC_PF yet. Also, the
page-ready notification delivery and control path isn't implemented
and will be done in the subsequent patches.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h      |  52 +++++++++
 arch/arm64/include/uapi/asm/kvm_para.h |  15 +++
 arch/arm64/kvm/Makefile                |   1 +
 arch/arm64/kvm/arm.c                   |   3 +
 arch/arm64/kvm/async_pf.c              | 145 +++++++++++++++++++++++++
 arch/arm64/kvm/mmu.c                   |  33 +++++-
 6 files changed, 247 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/async_pf.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 581825b9df77..6b98aef936b4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -283,6 +283,31 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+/* Should be a power of two number */
+#define ASYNC_PF_PER_VCPU	64
+
+/*
+ * The association of gfn and token. The token will be sent to guest as
+ * page fault address. Also, the guest could be in aarch32 mode. So its
+ * length should be 32-bits.
+ */
+struct kvm_arch_async_pf {
+	u32	token;
+	gfn_t	gfn;
+	u32	esr;
+};
+
+struct kvm_arch_async_pf_control {
+		struct gfn_to_hva_cache	cache;
+		u64			control_block;
+		bool			send_user_only;
+		u64			sdei_event_num;
+
+		u16			id;
+		bool			notpresent_pending;
+		u32			notpresent_token;
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -346,6 +371,9 @@ struct kvm_vcpu_arch {
 	/* SDEI support */
 	struct kvm_sdei_vcpu *sdei;
 
+	/* Asynchronous page fault support */
+	struct kvm_arch_async_pf_control *apf;
+
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
@@ -741,6 +769,30 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 				struct kvm_arm_copy_mte_tags *copy_tags);
 
+#ifdef CONFIG_KVM_ASYNC_PF
+void kvm_arch_async_pf_create_vcpu(struct kvm_vcpu *vcpu);
+bool kvm_arch_async_not_present_allowed(struct kvm_vcpu *vcpu);
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+			     u32 esr, gpa_t gpa, gfn_t gfn);
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+				     struct kvm_async_pf *work);
+void kvm_arch_async_pf_destroy_vcpu(struct kvm_vcpu *vcpu);
+#else
+static inline void kvm_arch_async_pf_create_vcpu(struct kvm_vcpu *vcpu) { }
+static inline void kvm_arch_async_pf_destroy_vcpu(struct kvm_vcpu *vcpu) { }
+
+static inline bool kvm_arch_async_not_present_allowed(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+					   u32 esr, gpa_t gpa, gfn_t gfn)
+{
+	return false;
+}
+#endif
+
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/uapi/asm/kvm_para.h b/arch/arm64/include/uapi/asm/kvm_para.h
index cd212282b90c..3fa04006714e 100644
--- a/arch/arm64/include/uapi/asm/kvm_para.h
+++ b/arch/arm64/include/uapi/asm/kvm_para.h
@@ -2,4 +2,19 @@
 #ifndef _UAPI_ASM_ARM_KVM_PARA_H
 #define _UAPI_ASM_ARM_KVM_PARA_H
 
+#include <linux/types.h>
+
+/* Async PF */
+#define KVM_ASYNC_PF_ENABLED		(1 << 0)
+#define KVM_ASYNC_PF_SEND_ALWAYS	(1 << 1)
+
+#define KVM_PV_REASON_PAGE_NOT_PRESENT	1
+
+struct kvm_vcpu_pv_apf_data {
+	__u32	reason;
+	__u32	token;
+	__u8	pad[56];
+	__u32	enabled;
+};
+
 #endif /* _UAPI_ASM_ARM_KVM_PARA_H */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index eefca8ca394d..c9aa307ea542 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,4 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o async_pf.o
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7d9bbc888ae5..af251896b41d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -342,6 +342,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_sdei_create_vcpu(vcpu);
 
+	kvm_arch_async_pf_create_vcpu(vcpu);
+
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
 	err = kvm_vgic_vcpu_init(vcpu);
@@ -363,6 +365,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
+	kvm_arch_async_pf_destroy_vcpu(vcpu);
 	kvm_sdei_destroy_vcpu(vcpu);
 
 	kvm_arm_vcpu_destroy(vcpu);
diff --git a/arch/arm64/kvm/async_pf.c b/arch/arm64/kvm/async_pf.c
new file mode 100644
index 000000000000..742bb8a0a8c0
--- /dev/null
+++ b/arch/arm64/kvm/async_pf.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Asynchronous page fault support.
+ *
+ * Copyright (C) 2021 Red Hat, Inc.
+ *
+ * Author(s): Gavin Shan <gshan@redhat.com>
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+#include <kvm/arm_hypercalls.h>
+#include <kvm/arm_vgic.h>
+#include <asm/kvm_sdei.h>
+
+static inline int read_cache(struct kvm_vcpu *vcpu, u32 offset, u32 *val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+
+	return kvm_read_guest_offset_cached(kvm, &apf->cache,
+					    val, offset, sizeof(*val));
+}
+
+static inline int write_cache(struct kvm_vcpu *vcpu, u32 offset, u32 val)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+
+	return kvm_write_guest_offset_cached(kvm, &apf->cache,
+					     &val, offset, sizeof(val));
+}
+
+void kvm_arch_async_pf_create_vcpu(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.apf = kzalloc(sizeof(*(vcpu->arch.apf)), GFP_KERNEL);
+}
+
+bool kvm_arch_async_not_present_allowed(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	struct kvm_sdei_vcpu *vsdei = vcpu->arch.sdei;
+	u32 reason, token;
+	int ret;
+
+	if (!apf || !(apf->control_block & KVM_ASYNC_PF_ENABLED))
+		return false;
+
+	if (apf->send_user_only && vcpu_mode_priv(vcpu))
+		return false;
+
+	if (!irqchip_in_kernel(vcpu->kvm))
+		return false;
+
+	if (!vsdei || vsdei->critical_event || vsdei->normal_event)
+		return false;
+
+	/* Pending page fault, which isn't acknowledged by guest */
+	ret = read_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason),
+			 &reason);
+	if (ret) {
+		kvm_err("%s: Error %d to read reason (%d-%d)\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		return false;
+	}
+
+	ret = read_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token),
+			 &token);
+	if (ret) {
+		kvm_err("%s: Error %d to read token %d-%d\n",
+			__func__, ret, kvm->userspace_pid, vcpu->vcpu_idx);
+		return false;
+	}
+
+	if (reason || token)
+		return false;
+
+	return true;
+}
+
+bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu,
+			     u32 esr, gpa_t gpa, gfn_t gfn)
+{
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	struct kvm_arch_async_pf arch;
+	unsigned long hva = kvm_vcpu_gfn_to_hva(vcpu, gfn);
+
+	arch.token = (apf->id++ << 12) | vcpu->vcpu_id;
+	arch.gfn = gfn;
+	arch.esr = esr;
+
+	return kvm_setup_async_pf(vcpu, gpa, hva, &arch);
+}
+
+/*
+ * It's guaranteed that no pending asynchronous page fault when this is
+ * called. It means all previous issued asynchronous page faults have
+ * been acknowledged.
+ */
+bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
+				     struct kvm_async_pf *work)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	int ret;
+
+	kvm_async_pf_add_slot(vcpu, work->arch.gfn);
+
+	ret = write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token),
+			  work->arch.token);
+	if (ret) {
+		kvm_err("%s: Error %d to write token (%d-%d %08x)\n",
+			__func__, ret, kvm->userspace_pid,
+			vcpu->vcpu_idx, work->arch.token);
+		goto fail;
+	}
+
+	ret = write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason),
+			  KVM_PV_REASON_PAGE_NOT_PRESENT);
+	if (ret) {
+		kvm_err("%s: Error %d to write reason (%d-%d %08x)\n",
+			__func__, ret, kvm->userspace_pid,
+			vcpu->vcpu_idx, work->arch.token);
+		goto fail;
+	}
+
+	apf->notpresent_pending = true;
+	apf->notpresent_token = work->arch.token;
+
+	return !kvm_sdei_inject(vcpu, apf->sdei_event_num, true);
+
+fail:
+	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, token), 0);
+	write_cache(vcpu, offsetof(struct kvm_vcpu_pv_apf_data, reason), 0);
+	kvm_async_pf_remove_slot(vcpu, work->arch.gfn);
+	return false;
+}
+
+void kvm_arch_async_pf_destroy_vcpu(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.apf);
+	vcpu->arch.apf = NULL;
+}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e4038c5e931d..4ba78bd1f18c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -914,6 +914,33 @@ static inline bool is_write_fault(unsigned int esr)
 	return esr_dabt_is_wnr(esr);
 }
 
+static bool try_async_pf(struct kvm_vcpu *vcpu, unsigned int esr,
+			 gpa_t gpa, gfn_t gfn, kvm_pfn_t *pfn,
+			 bool write, bool *writable, bool prefault)
+{
+	struct kvm_arch_async_pf_control *apf = vcpu->arch.apf;
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	bool async = false;
+
+	if (apf) {
+		/* Bail if *pfn has correct page */
+		*pfn = __gfn_to_pfn_memslot(slot, gfn, false, &async,
+					    write, writable, NULL);
+		if (!async)
+			return false;
+
+		if (!prefault && kvm_arch_async_not_present_allowed(vcpu)) {
+			if (kvm_async_pf_find_slot(vcpu, gfn) ||
+			    kvm_arch_setup_async_pf(vcpu, esr, gpa, gfn))
+				return true;
+		}
+	}
+
+	*pfn = __gfn_to_pfn_memslot(slot, gfn, false, NULL,
+				    write, writable, NULL);
+	return false;
+}
+
 int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu,
 			      struct kvm_memory_slot *memslot,
 			      phys_addr_t fault_ipa,
@@ -1035,8 +1062,10 @@ int kvm_handle_user_mem_abort(struct kvm_vcpu *vcpu,
 	 */
 	smp_rmb();
 
-	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable, NULL);
+	if (try_async_pf(vcpu, esr, fault_ipa, gfn, &pfn,
+			 write_fault, &writable, prefault))
+		return 1;
+
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
-- 
2.23.0

