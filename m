Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198EF1FC128
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 23:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgFPVtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 17:49:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36737 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726044AbgFPVtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 17:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592344159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDD3KfbOqwS5bW7URIU0KF/wEHz10zThSyNo+J1Fe9Q=;
        b=DDUC1sUU9qb6nEDUMVXP6EZno2vu6cm1WzwgW4Kq96uBgmAaK46cfNma90/a2Idh7NI1CC
        oozmRm5hiL5gR1O7v6N28lPUvP7QmjMm5knqEtXIt08akxOgWzIHHQxCVYhVapUJBL/L2S
        i8LRFA/sbcr0hoiAR4Aj60JqnV/ISPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-44JbRXPJN9ecGvY5VUOvhg-1; Tue, 16 Jun 2020 17:49:16 -0400
X-MC-Unique: 44JbRXPJN9ecGvY5VUOvhg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 149F010059B8;
        Tue, 16 Jun 2020 21:49:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-132.rdu2.redhat.com [10.10.114.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 511E15D9D3;
        Tue, 16 Jun 2020 21:49:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C8781225E4B; Tue, 16 Jun 2020 17:49:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, vkuznets@redhat.com,
        pbonzini@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/3] kvm: Add capability to be able to report async pf error to guest
Date:   Tue, 16 Jun 2020 17:48:46 -0400
Message-Id: <20200616214847.24482-3-vgoyal@redhat.com>
In-Reply-To: <20200616214847.24482-1-vgoyal@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As of now asynchronous page fault mecahanism assumes host will always be
successful in resolving page fault. So there are only two states, that
is page is not present and page is ready.

If a page is backed by a file and that file has been truncated (as
can be the case with virtio-fs), then page fault handler on host returns
-EFAULT.

As of now async page fault logic does not look at error code (-EFAULT)
returned by get_user_pages_remote() and returns PAGE_READY to guest.
Guest tries to access page and page fault happnes again. And this
gets kvm into an infinite loop. (Killing host process gets kvm out of
this loop though).

This patch adds another state to async page fault logic which allows
host to return error to guest. Once guest knows that async page fault
can't be resolved, it can send SIGBUS to host process (if user space
was accessing the page in question).

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/virt/kvm/cpuid.rst     |  4 +++
 Documentation/virt/kvm/msr.rst       | 10 +++++---
 arch/x86/include/asm/kvm_host.h      |  3 +++
 arch/x86/include/asm/kvm_para.h      |  8 +++---
 arch/x86/include/uapi/asm/kvm_para.h | 10 ++++++--
 arch/x86/kernel/kvm.c                | 34 ++++++++++++++++++++-----
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/mmu/mmu.c               |  2 +-
 arch/x86/kvm/x86.c                   | 38 ++++++++++++++++++++--------
 9 files changed, 83 insertions(+), 29 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
index a7dff9186bed..a4497f3a6e7f 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -92,6 +92,10 @@ KVM_FEATURE_ASYNC_PF_INT          14          guest checks this feature bit
                                               async pf acknowledgment msr
                                               0x4b564d07.
 
+KVM_FEATURE_ASYNC_PF_ERROR        15          paravirtualized async PF error
+                                              can be enabled by setting bit 4
+                                              when writing to msr 0x4b564d02
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest-side
                                               per-cpu warps are expeced in
                                               kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
index e37a14c323d2..513eb8e0b0eb 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -202,19 +202,21 @@ data:
 
 		/* Used for 'page ready' events delivered via interrupt notification */
 		__u32 token;
-
-		__u8 pad[56];
+                __u32 ready_flags;
+		__u8 pad[52];
 		__u32 enabled;
 	  };
 
-	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
+	Bits 5 of the MSR is reserved and should be zero. Bit 0 is set to 1
 	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
 	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
 	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
 	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
 	present in CPUID. Bit 3 enables interrupt based delivery of 'page ready'
 	events. Bit 3 can only be set if KVM_FEATURE_ASYNC_PF_INT is present in
-	CPUID.
+	CPUID. Bit 4 enables reporting of page fault errors if hypervisor
+        encounters errors while faulting in page. Bit 4 can only be set if
+        KVM_FEATURE_ASYNC_PF_ERROR is present in CPUID.
 
 	'Page not present' events are currently always delivered as synthetic
 	#PF exception. During delivery of these events APF CR2 register contains
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 348a73106556..ff8dbc604dbe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -779,6 +779,7 @@ struct kvm_vcpu_arch {
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
 		gfn_t error_gfn;
+		bool send_pf_error;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
@@ -1680,6 +1681,8 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu);
 bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
+void kvm_arch_async_page_fault_error(struct kvm_vcpu *vcpu,
+				     struct kvm_async_pf *work);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index bbc43e5411d9..6c738e91ca2c 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -89,8 +89,8 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
-void kvm_async_pf_task_wait_schedule(u32 token);
-void kvm_async_pf_task_wake(u32 token);
+void kvm_async_pf_task_wait_schedule(u32 token, bool user_mode);
+void kvm_async_pf_task_wake(u32 token, bool is_err);
 u32 kvm_read_and_reset_apf_flags(void);
 void kvm_disable_steal_time(void);
 bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
@@ -120,8 +120,8 @@ static inline void kvm_spinlock_init(void)
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
 #else /* CONFIG_KVM_GUEST */
-#define kvm_async_pf_task_wait_schedule(T) do {} while(0)
-#define kvm_async_pf_task_wake(T) do {} while(0)
+#define kvm_async_pf_task_wait_schedule(T, U) do {} while(0)
+#define kvm_async_pf_task_wake(T, I) do {} while(0)
 
 static inline bool kvm_para_available(void)
 {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 812e9b4c1114..b43fd2ddc949 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -32,6 +32,7 @@
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
 #define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_ASYNC_PF_ERROR	15
 
 #define KVM_HINTS_REALTIME      0
 
@@ -85,6 +86,7 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
 #define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+#define KVM_ASYNC_PF_SEND_ERROR			(1 << 4)
 
 /* MSR_KVM_ASYNC_PF_INT */
 #define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
@@ -119,14 +121,18 @@ struct kvm_mmu_op_release_pt {
 #define KVM_PV_REASON_PAGE_NOT_PRESENT 1
 #define KVM_PV_REASON_PAGE_READY 2
 
+
+/* Bit flags for ready_flags field */
+#define KVM_PV_REASON_PAGE_ERROR 1
+
 struct kvm_vcpu_pv_apf_data {
 	/* Used for 'page not present' events delivered via #PF */
 	__u32 flags;
 
 	/* Used for 'page ready' events delivered via interrupt notification */
 	__u32 token;
-
-	__u8 pad[56];
+	__u32 ready_flags;
+	__u8 pad[52];
 	__u32 enabled;
 };
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index ff95429d206b..2ee9c9d971ae 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -75,6 +75,7 @@ struct kvm_task_sleep_node {
 	struct swait_queue_head wq;
 	u32 token;
 	int cpu;
+	bool is_err;
 };
 
 static struct kvm_task_sleep_head {
@@ -97,7 +98,14 @@ static struct kvm_task_sleep_node *_find_apf_task(struct kvm_task_sleep_head *b,
 	return NULL;
 }
 
-static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
+static void handle_async_pf_error(bool user_mode)
+{
+	if (user_mode)
+		send_sig_info(SIGBUS, SEND_SIG_PRIV, current);
+}
+
+static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n,
+				    bool user_mode)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
@@ -107,6 +115,8 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
 	e = _find_apf_task(b, token);
 	if (e) {
 		/* dummy entry exist -> wake up was delivered ahead of PF */
+		if (e->is_err)
+			handle_async_pf_error(user_mode);
 		hlist_del(&e->link);
 		raw_spin_unlock(&b->lock);
 		kfree(e);
@@ -128,14 +138,14 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
  * Invoked from the async pagefault handling code or from the VM exit page
  * fault handler. In both cases RCU is watching.
  */
-void kvm_async_pf_task_wait_schedule(u32 token)
+void kvm_async_pf_task_wait_schedule(u32 token, bool user_mode)
 {
 	struct kvm_task_sleep_node n;
 	DECLARE_SWAITQUEUE(wait);
 
 	lockdep_assert_irqs_disabled();
 
-	if (!kvm_async_pf_queue_task(token, &n))
+	if (!kvm_async_pf_queue_task(token, &n, user_mode))
 		return;
 
 	for (;;) {
@@ -148,6 +158,8 @@ void kvm_async_pf_task_wait_schedule(u32 token)
 		local_irq_disable();
 	}
 	finish_swait(&n.wq, &wait);
+	if (n.is_err)
+		handle_async_pf_error(user_mode);
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_schedule);
 
@@ -177,7 +189,7 @@ static void apf_task_wake_all(void)
 	}
 }
 
-void kvm_async_pf_task_wake(u32 token)
+void kvm_async_pf_task_wake(u32 token, bool is_err)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
@@ -208,9 +220,11 @@ void kvm_async_pf_task_wake(u32 token)
 		}
 		n->token = token;
 		n->cpu = smp_processor_id();
+		n->is_err = is_err;
 		init_swait_queue_head(&n->wq);
 		hlist_add_head(&n->link, &b->list);
 	} else {
+		n->is_err = is_err;
 		apf_task_wake_one(n);
 	}
 	raw_spin_unlock(&b->lock);
@@ -256,14 +270,15 @@ bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 		panic("Host injected async #PF in kernel mode\n");
 
 	/* Page is swapped out by the host. */
-	kvm_async_pf_task_wait_schedule(token);
+	kvm_async_pf_task_wait_schedule(token, user_mode(regs));
 	return true;
 }
 NOKPROBE_SYMBOL(__kvm_handle_async_pf);
 
 __visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs)
 {
-	u32 token;
+	u32 token, ready_flags;
+	bool is_err;
 
 	entering_ack_irq();
 
@@ -271,7 +286,9 @@ __visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs)
 
 	if (__this_cpu_read(apf_reason.enabled)) {
 		token = __this_cpu_read(apf_reason.token);
-		kvm_async_pf_task_wake(token);
+		ready_flags = __this_cpu_read(apf_reason.ready_flags);
+		is_err = ready_flags & KVM_PV_REASON_PAGE_ERROR;
+		kvm_async_pf_task_wake(token, is_err);
 		__this_cpu_write(apf_reason.token, 0);
 		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 	}
@@ -335,6 +352,9 @@ static void kvm_guest_cpu_init(void)
 
 		wrmsrl(MSR_KVM_ASYNC_PF_INT, KVM_ASYNC_PF_VECTOR);
 
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_ERROR))
+			pa |= KVM_ASYNC_PF_SEND_ERROR;
+
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
 		pr_info("KVM setup async PF for cpu %d\n", smp_processor_id());
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 253b8e875ccd..f811f36e0c24 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -712,7 +712,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
-			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
+			     (1 << KVM_FEATURE_ASYNC_PF_ERROR);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e207900ab303..634182bb07c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4175,7 +4175,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
 		vcpu->arch.apf.host_apf_flags = 0;
 		local_irq_disable();
-		kvm_async_pf_task_wait_schedule(fault_address);
+		kvm_async_pf_task_wait_schedule(fault_address, 0);
 		local_irq_enable();
 	} else {
 		WARN_ONCE(1, "Unexpected host async PF flags: %x\n", flags);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c5205434b9c..c3b2097f2eaa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2690,8 +2690,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
 	gpa_t gpa = data & ~0x3f;
 
-	/* Bits 4:5 are reserved, Should be zero */
-	if (data & 0x30)
+	/* Bits 5 is reserved, Should be zero */
+	if (data & 0x20)
 		return 1;
 
 	vcpu->arch.apf.msr_en_val = data;
@@ -2703,11 +2703,12 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u64)))
+					sizeof(u64) + sizeof(u32)))
 		return 1;
 
 	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
+	vcpu->arch.apf.send_pf_error = data & KVM_ASYNC_PF_SEND_ERROR;
 
 	kvm_async_pf_wakeup_all(vcpu);
 
@@ -10481,12 +10482,25 @@ static inline int apf_put_user_notpresent(struct kvm_vcpu *vcpu)
 				      sizeof(reason));
 }
 
-static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token)
+static inline int apf_put_user_ready(struct kvm_vcpu *vcpu, u32 token,
+				     bool is_err)
 {
 	unsigned int offset = offsetof(struct kvm_vcpu_pv_apf_data, token);
+	int ret;
+	u32 ready_flags = 0;
+
+	if (is_err && vcpu->arch.apf.send_pf_error)
+		ready_flags = KVM_PV_REASON_PAGE_ERROR;
+
+	ret = kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
+					    &token, offset, sizeof(token));
+	if (ret < 0)
+		return ret;
 
+	offset = offsetof(struct kvm_vcpu_pv_apf_data, ready_flags);
 	return kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.apf.data,
-					     &token, offset, sizeof(token));
+					    &ready_flags, offset,
+					    sizeof(ready_flags));
 }
 
 static inline bool apf_pageready_slot_free(struct kvm_vcpu *vcpu)
@@ -10571,6 +10585,8 @@ bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 				 struct kvm_async_pf *work)
 {
+	bool present_injected = false;
+
 	struct kvm_lapic_irq irq = {
 		.delivery_mode = APIC_DM_FIXED,
 		.vector = vcpu->arch.apf.vec
@@ -10584,16 +10600,18 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 
 	if ((work->wakeup_all || work->notpresent_injected) &&
 	    kvm_pv_async_pf_enabled(vcpu) &&
-	    !apf_put_user_ready(vcpu, work->arch.token)) {
+	    !apf_put_user_ready(vcpu, work->arch.token, work->error_code)) {
 		vcpu->arch.apf.pageready_pending = true;
 		kvm_apic_set_irq(vcpu, &irq, NULL);
+		present_injected = true;
 	}
 
-	if (work->error_code) {
+	if (work->error_code &&
+	    (!present_injected || !vcpu->arch.apf.send_pf_error)) {
 		/*
-		 * Page fault failed and we don't have a way to report
-		 * errors back to guest yet. So save this pfn and force
-		 * sync page fault next time.
+		 * Page fault failed. If we did not report error back
+		 * to guest, save this pfn and force sync page fault next
+		 * time.
 		 */
 		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
 	}
-- 
2.25.4

