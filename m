Return-Path: <kvm+bounces-32008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 407079D10C8
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 13:42:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81D9BB26878
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2024 12:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4C219D070;
	Mon, 18 Nov 2024 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Z0iZxJzu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EEDB176ADE;
	Mon, 18 Nov 2024 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731933674; cv=none; b=Oj+GWa+eUA5wXtJXb4l73Is8uNWETaO9hB/uk5kJvu1PlaoAI/WnKFfnG12+qyLRjuQc4f9lY9yRht7YJdoGc09HTLmQKvH3WRvB0EVMgtFH8J3P2x+PsSlkKXVe0TVZPMBNOVtfAWIXAZYueScEKo8S2UL+kMag0Hy368oSrt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731933674; c=relaxed/simple;
	bh=8zCNhAYj0VQZXEo3nPh1Zo9y1eb0jQjv/hk5n3jEcn8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBNiQxSHFAnL+jQCAUzEvmNx33cuuTskPnCjYJYaR3UnqeAhNfP1F4bKRVejtiXeGpTxJUm7LK46Qq58cY/D9LSQvfZVJ57UQNb2l6VncElm4DLhwJZSUxLRNsKezWA4ci7tWBbkI0J6TMBLjIwO4hZ0DM/USD33WbRbggQK/hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Z0iZxJzu; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1731933672; x=1763469672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yXWzOy4nHoc072Ub0A3QUH3HAOeon+hpWGwOWYadjPI=;
  b=Z0iZxJzuajNm5C8nHqcKuLLDQsLyTxSqmDnNGWImirTOUfOmBqF993NJ
   aoq+rACUwify1/AVU1WcMDswsDE93+SmZ+2e+LlB4na74p8tbSpPqmShZ
   6+O4cNT71xqePdTRYSs07hwJo0yBJKb3GpSve5fw1x6R7WebtJGvigPUe
   U=;
X-IronPort-AV: E=Sophos;i="6.12,164,1728950400"; 
   d="scan'208";a="443750017"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.124.125.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 12:41:08 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:18171]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.54:2525] with esmtp (Farcaster)
 id 4f47d125-d5ee-4c84-bfe0-b81856ec61f5; Mon, 18 Nov 2024 12:41:07 +0000 (UTC)
X-Farcaster-Flow-ID: 4f47d125-d5ee-4c84-bfe0-b81856ec61f5
Received: from EX19D020UWC003.ant.amazon.com (10.13.138.187) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:41:02 +0000
Received: from EX19MTAUWC002.ant.amazon.com (10.250.64.143) by
 EX19D020UWC003.ant.amazon.com (10.13.138.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 18 Nov 2024 12:41:01 +0000
Received: from email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Mon, 18 Nov 2024 12:41:01 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-iad-all-1a-8c151b82.us-east-1.amazon.com (Postfix) with ESMTPS id 0A28040413;
	Mon, 18 Nov 2024 12:40:58 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <corbet@lwn.net>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
CC: <jthoughton@google.com>, <david@redhat.com>, <peterx@redhat.com>,
	<oleg@redhat.com>, <vkuznets@redhat.com>, <gshan@redhat.com>,
	<graf@amazon.de>, <jgowans@amazon.com>, <roypat@amazon.co.uk>,
	<derekmn@amazon.com>, <nsaenz@amazon.es>, <xmarcalx@amazon.com>,
	<kalyazin@amazon.com>
Subject: [RFC PATCH 5/6] KVM: x86: async_pf_user: add infrastructure
Date: Mon, 18 Nov 2024 12:39:47 +0000
Message-ID: <20241118123948.4796-6-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241118123948.4796-1-kalyazin@amazon.com>
References: <20241118123948.4796-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Add both generic and x86-specific infrastructure for async PF.
The functionality is gated by the KVM_ASYNC_PF_USER config option.
The async PF user implementation is mostly isolated from the original
(kernel) implementation.  The only piece that is shared between the two
is the struct apf within struct kvm_vcpu_arch (x86) that is tracking
guest-facing state.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +-
 arch/x86/kvm/Kconfig            |   6 +
 arch/x86/kvm/lapic.c            |   2 +
 arch/x86/kvm/mmu/mmu.c          |  19 +++
 arch/x86/kvm/x86.c              |  75 ++++++++++++
 include/linux/kvm_host.h        |  30 +++++
 include/linux/kvm_types.h       |   1 +
 include/uapi/linux/kvm.h        |   8 ++
 virt/kvm/Kconfig                |   3 +
 virt/kvm/Makefile.kvm           |   1 +
 virt/kvm/async_pf_user.c        | 197 ++++++++++++++++++++++++++++++++
 virt/kvm/async_pf_user.h        |  24 ++++
 virt/kvm/kvm_main.c             |  14 +++
 13 files changed, 391 insertions(+), 1 deletion(-)
 create mode 100644 virt/kvm/async_pf_user.c
 create mode 100644 virt/kvm/async_pf_user.h

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bb2e164c523..36cea4c9000f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -122,6 +122,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
+#define KVM_REQ_APF_USER_READY		KVM_ARCH_REQ(29)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -164,6 +165,7 @@
 #define KVM_NR_VAR_MTRR 8
 
 #define ASYNC_PF_PER_VCPU 64
+#define ASYNC_PF_USER_PER_VCPU 64
 
 enum kvm_reg {
 	VCPU_REGS_RAX = __VCPU_REGS_RAX,
@@ -973,7 +975,7 @@ struct kvm_vcpu_arch {
 
 	struct {
 		bool halted;
-		gfn_t gfns[ASYNC_PF_PER_VCPU];
+		gfn_t gfns[ASYNC_PF_PER_VCPU + ASYNC_PF_USER_PER_VCPU];
 		struct gfn_to_hva_cache data;
 		u64 msr_en_val; /* MSR_KVM_ASYNC_PF_EN */
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
@@ -983,6 +985,7 @@ struct kvm_vcpu_arch {
 		u32 host_apf_flags;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
+		bool pageready_user_pending;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
@@ -2266,11 +2269,18 @@ void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
+bool kvm_arch_async_page_not_present_user(struct kvm_vcpu *vcpu,
+					struct kvm_async_pf_user *apf);
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work);
+void kvm_arch_async_page_present_user(struct kvm_vcpu *vcpu,
+				struct kvm_async_pf_user *apf);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
+void kvm_arch_async_page_ready_user(struct kvm_vcpu *vcpu,
+				struct kvm_async_pf_user *apf);
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
+void kvm_arch_async_page_present_user_queued(struct kvm_vcpu *vcpu);
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 191dfba3e27a..255597942d59 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -209,4 +209,10 @@ config KVM_MAX_NR_VCPUS
 	  the memory footprint of each KVM guest, regardless of how many vCPUs are
 	  created for a given VM.
 
+config KVM_ASYNC_PF_USER
+	bool "Support for async PF handled by userspace"
+	depends on KVM && KVM_USERFAULT && KVM_ASYNC_PF && X86_64
+	help
+	  Support for async PF handled by userspace.
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index acd7d48100a1..723c9584d47a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -515,6 +515,7 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 	/* Check if there are APF page ready requests pending */
 	if (enabled) {
 		kvm_make_request(KVM_REQ_APF_READY, apic->vcpu);
+		kvm_make_request(KVM_REQ_APF_USER_READY, apic->vcpu);
 		kvm_xen_sw_enable_lapic(apic->vcpu);
 	}
 }
@@ -2560,6 +2561,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 			static_branch_slow_dec_deferred(&apic_hw_disabled);
 			/* Check if there are APF page ready requests pending */
 			kvm_make_request(KVM_REQ_APF_READY, vcpu);
+			kvm_make_request(KVM_REQ_APF_USER_READY, vcpu);
 		} else {
 			static_branch_inc(&apic_hw_disabled.key);
 			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 004e068cabae..adf0161af894 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4304,6 +4304,25 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, work->arch.error_code, true, NULL);
 }
 
+void kvm_arch_async_page_ready_user(struct kvm_vcpu *vcpu, struct kvm_async_pf_user *apf)
+{
+        int r;
+
+        if ((vcpu->arch.mmu->root_role.direct != apf->arch.direct_map) ||
+              apf->wakeup_all)
+                return;
+
+        r = kvm_mmu_reload(vcpu);
+        if (unlikely(r))
+                return;
+
+        if (!vcpu->arch.mmu->root_role.direct &&
+              apf->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
+                return;
+
+        kvm_mmu_do_page_fault(vcpu, apf->cr2_or_gpa, apf->arch.error_code, true, NULL);
+}
+
 static inline u8 kvm_max_level_for_order(int order)
 {
 	BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL > PG_LEVEL_1G);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0a04de5dbada..2b8cd3af326b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -942,6 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
 		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_clear_async_pf_user_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
 
 		/*
@@ -3569,6 +3570,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 
 	if (!kvm_pv_async_pf_enabled(vcpu)) {
 		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_clear_async_pf_user_completion_queue(vcpu);
 		kvm_async_pf_hash_reset(vcpu);
 		return 0;
 	}
@@ -3581,6 +3583,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
 	kvm_async_pf_wakeup_all(vcpu);
+	kvm_async_pf_user_wakeup_all(vcpu);
 
 	return 0;
 }
@@ -4019,6 +4022,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & 0x1) {
 			vcpu->arch.apf.pageready_pending = false;
 			kvm_check_async_pf_completion(vcpu);
+			vcpu->arch.apf.pageready_user_pending = false;
+			kvm_check_async_pf_user_completion(vcpu);
 		}
 		break;
 	case MSR_KVM_STEAL_TIME:
@@ -10924,6 +10929,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+		if (kvm_check_request(KVM_REQ_APF_USER_READY, vcpu))
+			kvm_check_async_pf_user_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
 			static_call(kvm_x86_msr_filter_changed)(vcpu);
 
@@ -12346,6 +12353,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvmclock_reset(vcpu);
 
 	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_clear_async_pf_user_completion_queue(vcpu);
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
 
@@ -12671,6 +12679,7 @@ static void kvm_unload_vcpu_mmus(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		kvm_clear_async_pf_completion_queue(vcpu);
+		kvm_clear_async_pf_user_completion_queue(vcpu);
 		kvm_unload_vcpu_mmu(vcpu);
 	}
 }
@@ -13119,6 +13128,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return true;
 
+	if (!list_empty_careful(&vcpu->async_pf_user.done))
+		return true;
+
 	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
 	    kvm_apic_init_sipi_allowed(vcpu))
 		return true;
@@ -13435,6 +13447,37 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 	}
 }
 
+bool kvm_arch_async_page_not_present_user(struct kvm_vcpu *vcpu,
+						struct kvm_async_pf_user *apf)
+{
+	struct x86_exception fault;
+
+	trace_kvm_async_pf_not_present(apf->arch.token, apf->cr2_or_gpa, 1);
+	kvm_add_async_pf_gfn(vcpu, apf->arch.gfn);
+
+	if (!apf_put_user_notpresent(vcpu)) {
+		fault.vector = PF_VECTOR;
+		fault.error_code_valid = true;
+		fault.error_code = 0;
+		fault.nested_page_fault = false;
+		fault.address = apf->arch.token;
+		fault.async_page_fault = true;
+		kvm_inject_page_fault(vcpu, &fault);
+		return true;
+	} else {
+		/*
+		 * It is not possible to deliver a paravirtualized asynchronous
+		 * page fault, but putting the guest in an artificial halt state
+		 * can be beneficial nevertheless: if an interrupt arrives, we
+		 * can deliver it timely and perhaps the guest will schedule
+		 * another process.  When the instruction that triggered a page
+		 * fault is retried, hopefully the page will be ready in the host.
+		 */
+		kvm_make_request(KVM_REQ_APF_HALT, vcpu);
+		return false;
+	}
+}
+
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
@@ -13460,6 +13503,31 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 }
 
+void kvm_arch_async_page_present_user(struct kvm_vcpu *vcpu,
+				struct kvm_async_pf_user *apf)
+{
+        struct kvm_lapic_irq irq = {
+                .delivery_mode = APIC_DM_FIXED,
+                .vector = vcpu->arch.apf.vec
+        };
+
+        if (apf->wakeup_all)
+                apf->arch.token = ~0; /* broadcast wakeup */
+        else
+                kvm_del_async_pf_gfn(vcpu, apf->arch.gfn);
+        trace_kvm_async_pf_ready(apf->arch.token, apf->cr2_or_gpa, 1);
+
+        if ((apf->wakeup_all || apf->notpresent_injected) &&
+            kvm_pv_async_pf_enabled(vcpu) &&
+            !apf_put_user_ready(vcpu, apf->arch.token)) {
+                vcpu->arch.apf.pageready_user_pending = true;
+                kvm_apic_set_irq(vcpu, &irq, NULL);
+        }
+
+        vcpu->arch.apf.halted = false;
+        vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+}
+
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
 {
 	kvm_make_request(KVM_REQ_APF_READY, vcpu);
@@ -13467,6 +13535,13 @@ void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
 		kvm_vcpu_kick(vcpu);
 }
 
+void kvm_arch_async_page_present_user_queued(struct kvm_vcpu *vcpu)
+{
+	kvm_make_request(KVM_REQ_APF_USER_READY, vcpu);
+	if (!vcpu->arch.apf.pageready_user_pending)
+		kvm_vcpu_kick(vcpu);
+}
+
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_pv_async_pf_enabled(vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3b9780d85877..d0aa0680127a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -257,6 +257,27 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
+#ifdef CONFIG_KVM_ASYNC_PF_USER
+struct kvm_async_pf_user {
+	struct list_head link;
+	struct list_head queue;
+	gpa_t  cr2_or_gpa;
+	struct kvm_arch_async_pf arch;
+	bool   wakeup_all;
+	bool   resolved;
+	bool   notpresent_injected;
+};
+
+void kvm_clear_async_pf_user_completion_queue(struct kvm_vcpu *vcpu);
+void kvm_check_async_pf_user_completion(struct kvm_vcpu *vcpu);
+bool kvm_setup_async_pf_user(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+			unsigned long hva, struct kvm_arch_async_pf *arch);
+int kvm_async_pf_user_wakeup_all(struct kvm_vcpu *vcpu);
+#endif
+
+int kvm_async_pf_user_ready(struct kvm_vcpu *vcpu,
+			struct kvm_async_pf_user_ready *apf_ready);
+
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
 	unsigned long attributes;
@@ -368,6 +389,15 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+#ifdef CONFIG_KVM_ASYNC_PF_USER
+	struct {
+		u32 queued;
+		struct list_head queue;
+		struct list_head done;
+		spinlock_t lock;
+	} async_pf_user;
+#endif
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	/*
 	 * Cpu relax intercept or pause loop exit optimization
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..149c7e48b2fb 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -5,6 +5,7 @@
 
 struct kvm;
 struct kvm_async_pf;
+struct kvm_async_pf_user;
 struct kvm_device_ops;
 struct kvm_gfn_range;
 struct kvm_interrupt;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 8cd8e08f11e1..ef3840a1c5e9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1561,4 +1561,12 @@ struct kvm_fault {
 
 #define KVM_READ_USERFAULT		_IOR(KVMIO, 0xd5, struct kvm_fault)
 
+/* for KVM_ASYNC_PF_USER_READY */
+struct kvm_async_pf_user_ready {
+	/* in */
+	__u32 token;
+};
+
+#define KVM_ASYNC_PF_USER_READY _IOW(KVMIO,  0xd6, struct kvm_async_pf_user_ready)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index f1b660d593e4..91abbd9a8e70 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -45,6 +45,9 @@ config KVM_MMIO
 config KVM_ASYNC_PF
        bool
 
+config KVM_ASYNC_PF_USER
+       bool
+
 # Toggle to switch between direct notification and batch job
 config KVM_ASYNC_PF_SYNC
        bool
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 724c89af78af..980217e0b03a 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -9,6 +9,7 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
+kvm-$(CONFIG_KVM_ASYNC_PF_USER) += $(KVM)/async_pf_user.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
diff --git a/virt/kvm/async_pf_user.c b/virt/kvm/async_pf_user.c
new file mode 100644
index 000000000000..d72ce5733e1a
--- /dev/null
+++ b/virt/kvm/async_pf_user.c
@@ -0,0 +1,197 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * kvm support for asyncrhonous fault in userspace
+ *
+ * Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Author:
+ *      Nikita Kalyazin <kalyazin@amazon.com>
+ */
+
+#include <uapi/linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include "async_pf_user.h"
+#include <trace/events/kvm.h>
+
+static struct kmem_cache *async_pf_user_cache;
+
+int kvm_async_pf_user_init(void)
+{
+	async_pf_user_cache = KMEM_CACHE(kvm_async_pf_user, 0);
+
+	if (!async_pf_user_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void kvm_async_pf_user_deinit(void)
+{
+	kmem_cache_destroy(async_pf_user_cache);
+	async_pf_user_cache = NULL;
+}
+
+void kvm_async_pf_user_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	INIT_LIST_HEAD(&vcpu->async_pf_user.done);
+	INIT_LIST_HEAD(&vcpu->async_pf_user.queue);
+	spin_lock_init(&vcpu->async_pf_user.lock);
+}
+
+int kvm_async_pf_user_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf_user_ready *apf_ready)
+{
+	struct kvm_async_pf_user *apf = NULL;
+	bool first;
+
+	spin_lock(&vcpu->async_pf_user.lock);
+	list_for_each_entry(apf, &vcpu->async_pf_user.queue, queue) {
+		if (apf->arch.token == apf_ready->token)
+			break;
+	}
+	spin_unlock(&vcpu->async_pf_user.lock);
+
+	if (unlikely(!apf || apf->arch.token != apf_ready->token))
+		return -EINVAL;
+
+	spin_lock(&vcpu->async_pf_user.lock);
+    first = list_empty(&vcpu->async_pf_user.done);
+	apf->resolved = true;
+    list_add_tail(&apf->link, &vcpu->async_pf_user.done);
+    spin_unlock(&vcpu->async_pf_user.lock);
+
+    kvm_arch_async_page_present_user_queued(vcpu);
+
+	if (first)
+		kvm_arch_async_page_present_user_queued(vcpu);
+
+    trace_kvm_async_pf_completed(0, apf->cr2_or_gpa, 1);
+
+    __kvm_vcpu_wake_up(vcpu);
+
+	return 0;
+}
+
+void kvm_clear_async_pf_user_completion_queue(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->async_pf_user.lock);
+
+	/* cancel outstanding work queue item */
+	while (!list_empty(&vcpu->async_pf_user.queue)) {
+		struct kvm_async_pf_user *apf =
+			list_first_entry(&vcpu->async_pf_user.queue,
+					 typeof(*apf), queue);
+		list_del(&apf->queue);
+
+		/*
+		 * If userspace has already notified us that the fault
+		 * had been resolved, we will delete the item when
+		 * iterating over the `done` list.
+		 * Otherwise, we free it now, and if at a later point
+		 * userspaces comes back regarding this fault, it will
+		 * be rejected due to an inexistent token.
+		 * Note that we do not have a way to "cancel" the work
+		 * like with traditional (kernel) async pf.
+		 */
+		if (!apf->resolved)
+			kmem_cache_free(async_pf_user_cache, apf);
+	}
+
+	while (!list_empty(&vcpu->async_pf_user.done)) {
+		struct kvm_async_pf_user *apf =
+			list_first_entry(&vcpu->async_pf_user.done,
+					 typeof(*apf), link);
+		list_del(&apf->link);
+
+		/*
+		 * Unlike with traditional (kernel) async pf,
+		 * we know for sure that once the work has been queued,
+		 * userspace has done with it and no residual resources
+		 * are still being held by KVM.
+		 */
+		kmem_cache_free(async_pf_user_cache, apf);
+	}
+	spin_unlock(&vcpu->async_pf_user.lock);
+
+	vcpu->async_pf_user.queued = 0;
+}
+
+void kvm_check_async_pf_user_completion(struct kvm_vcpu *vcpu)
+{
+	struct kvm_async_pf_user *apf;
+
+	while (!list_empty_careful(&vcpu->async_pf_user.done) &&
+	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
+		spin_lock(&vcpu->async_pf_user.lock);
+		apf = list_first_entry(&vcpu->async_pf_user.done, typeof(*apf),
+					      link);
+		list_del(&apf->link);
+		spin_unlock(&vcpu->async_pf_user.lock);
+
+		kvm_arch_async_page_ready_user(vcpu, apf);
+		kvm_arch_async_page_present_user(vcpu, apf);
+
+		list_del(&apf->queue);
+		vcpu->async_pf_user.queued--;
+	}
+}
+
+/*
+ * Try to schedule a job to handle page fault asynchronously. Returns 'true' on
+ * success, 'false' on failure (page fault has to be handled synchronously).
+ */
+bool kvm_setup_async_pf_user(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+			unsigned long hva, struct kvm_arch_async_pf *arch)
+{
+	struct kvm_async_pf_user *apf;
+
+	if (vcpu->async_pf_user.queued >= ASYNC_PF_USER_PER_VCPU)
+		return false;
+
+	/*
+	 * do alloc nowait since if we are going to sleep anyway we
+	 * may as well sleep faulting in page
+	 */
+	apf = kmem_cache_zalloc(async_pf_user_cache, GFP_NOWAIT | __GFP_NOWARN);
+	if (!apf)
+		return false;
+
+	apf->wakeup_all = false;
+	apf->cr2_or_gpa = cr2_or_gpa;
+	apf->arch = *arch;
+
+	list_add_tail(&apf->queue, &vcpu->async_pf_user.queue);
+	vcpu->async_pf_user.queued++;
+	apf->notpresent_injected = kvm_arch_async_page_not_present_user(vcpu, apf);
+
+	return true;
+}
+
+int kvm_async_pf_user_wakeup_all(struct kvm_vcpu *vcpu)
+{
+	struct kvm_async_pf_user *apf;
+	bool first;
+
+	if (!list_empty_careful(&vcpu->async_pf_user.done))
+		return 0;
+
+	apf = kmem_cache_zalloc(async_pf_user_cache, GFP_ATOMIC);
+	if (!apf)
+		return -ENOMEM;
+
+	apf->wakeup_all = true;
+	INIT_LIST_HEAD(&apf->queue); /* for list_del to work */
+
+	spin_lock(&vcpu->async_pf_user.lock);
+	first = list_empty(&vcpu->async_pf_user.done);
+	list_add_tail(&apf->link, &vcpu->async_pf_user.done);
+	spin_unlock(&vcpu->async_pf_user.lock);
+
+	if (first)
+		kvm_arch_async_page_present_user_queued(vcpu);
+
+	vcpu->async_pf_user.queued++;
+	return 0;
+}
diff --git a/virt/kvm/async_pf_user.h b/virt/kvm/async_pf_user.h
new file mode 100644
index 000000000000..35fa12858c05
--- /dev/null
+++ b/virt/kvm/async_pf_user.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * kvm support for asyncrhonous fault in userspace
+ *
+ * Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Author:
+ *      Nikita Kalyazin <kalyazin@amazon.com>
+ */
+
+#ifndef __KVM_ASYNC_PF_USER_H__
+#define __KVM_ASYNC_PF_USER_H__
+
+#ifdef CONFIG_KVM_ASYNC_PF_USER
+int kvm_async_pf_user_init(void);
+void kvm_async_pf_user_deinit(void);
+void kvm_async_pf_user_vcpu_init(struct kvm_vcpu *vcpu);
+#else
+#define kvm_async_pf_user_init() (0)
+#define kvm_async_pf_user_deinit() do {} while (0)
+#define kvm_async_pf_user_vcpu_init(C) do {} while (0)
+#endif
+
+#endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 90ce6b8ff0ab..a1a122acf93a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -59,6 +59,7 @@
 
 #include "coalesced_mmio.h"
 #include "async_pf.h"
+#include "async_pf_user.h"
 #include "kvm_mm.h"
 #include "vfio.h"
 
@@ -493,6 +494,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	rcuwait_init(&vcpu->wait);
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
+	kvm_async_pf_user_vcpu_init(vcpu);
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
 	kvm_vcpu_set_dy_eligible(vcpu, false);
@@ -4059,6 +4061,11 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
 		return true;
 #endif
 
+#ifdef CONFIG_KVM_ASYNC_PF_USER
+	if (!list_empty_careful(&vcpu->async_pf_user.done))
+		return true;
+#endif
+
 	return false;
 }
 
@@ -6613,6 +6620,10 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		goto err_async_pf;
 
+	r = kvm_async_pf_user_init();
+	if (r)
+		goto err_async_pf_user;
+
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
@@ -6644,6 +6655,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_vfio_ops_exit();
 err_vfio:
+	kvm_async_pf_user_deinit();
+err_async_pf_user:
 	kvm_async_pf_deinit();
 err_async_pf:
 	kvm_irqfd_exit();
@@ -6677,6 +6690,7 @@ void kvm_exit(void)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_vfio_ops_exit();
+	kvm_async_pf_user_deinit();
 	kvm_async_pf_deinit();
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
-- 
2.40.1


