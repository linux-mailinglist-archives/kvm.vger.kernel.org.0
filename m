Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FEB199F48
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgCaTkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:40:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48252 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727740AbgCaTkc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:40:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585683630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7evanx/JUXfji21NZZBHbn76ofL2zUbOkCQZCYcXArk=;
        b=LqcKas9pJr5SCx638hTXTNuzjx/w5ivQD0MjOqSLls+bQP8iafNjQIvB49ne1KeutVetOu
        56haRtTKnS7CVjOmM8IU3YXThJaLEUf4/TRR+23OhFAuDqMzmEvZPQ57fGkLoSoeMwa1If
        lQhcLbSjsstHej/EZCEWX+uOKyGhxCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-acg85Hg7Mpuo67cZAyxyUQ-1; Tue, 31 Mar 2020 15:40:27 -0400
X-MC-Unique: acg85Hg7Mpuo67cZAyxyUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E879C193579E;
        Tue, 31 Mar 2020 19:40:26 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-184.phx2.redhat.com [10.3.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3079862697;
        Tue, 31 Mar 2020 19:40:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 604F22202B3; Tue, 31 Mar 2020 15:40:20 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, aarcange@redhat.com,
        dhildenb@redhat.com
Subject: [PATCH 1/4] kvm: Add capability to be able to report async pf error to guest
Date:   Tue, 31 Mar 2020 15:40:08 -0400
Message-Id: <20200331194011.24834-2-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
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
 Documentation/virt/kvm/cpuid.rst     |  4 ++++
 Documentation/virt/kvm/msr.rst       | 11 ++++++++---
 arch/x86/include/asm/kvm_host.h      |  3 +++
 arch/x86/include/asm/kvm_para.h      |  4 ++--
 arch/x86/include/uapi/asm/kvm_para.h |  3 +++
 arch/x86/kernel/kvm.c                | 29 +++++++++++++++++++++++++---
 arch/x86/kvm/cpuid.c                 |  3 ++-
 arch/x86/kvm/mmu/mmu.c               |  2 +-
 arch/x86/kvm/x86.c                   | 13 +++++++++----
 include/linux/kvm_host.h             |  1 +
 virt/kvm/async_pf.c                  |  6 ++++--
 11 files changed, 63 insertions(+), 16 deletions(-)

diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cp=
uid.rst
index 01b081f6e7ea..a00bc5e964e0 100644
--- a/Documentation/virt/kvm/cpuid.rst
+++ b/Documentation/virt/kvm/cpuid.rst
@@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest ch=
ecks this feature bit
                                               before using paravirtualiz=
ed
                                               sched yield.
=20
+KVM_FEATURE_ASYNC_PF_ERROR        14          paravirtualized async PF e=
rror
+                                              can be enabled by setting =
bit 3
+                                              when writing to msr 0x4b56=
4d02
+
 KVM_FEATURE_CLOCSOURCE_STABLE_BIT 24          host will warn if no guest=
-side
                                               per-cpu warps are expeced =
in
                                               kvmclock
diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.=
rst
index 33892036672d..93f5e555dcdf 100644
--- a/Documentation/virt/kvm/msr.rst
+++ b/Documentation/virt/kvm/msr.rst
@@ -192,18 +192,23 @@ MSR_KVM_ASYNC_PF_EN:
 data:
 	Bits 63-6 hold 64-byte aligned physical address of a
 	64 byte memory area which must be in guest RAM and must be
-	zeroed. Bits 5-3 are reserved and should be zero. Bit 0 is 1
+	zeroed. Bits 5-4 are reserved and should be zero. Bit 0 is 1
 	when asynchronous page faults are enabled on the vcpu 0 when
 	disabled. Bit 1 is 1 if asynchronous page faults can be injected
 	when vcpu is in cpl =3D=3D 0. Bit 2 is 1 if asynchronous page faults
 	are delivered to L1 as #PF vmexits.  Bit 2 can be set only if
-	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID.
+	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID. Bit 3 is 1 if
+        asynchronous page fault can return error if hypervisor encounter=
s
+        errors trying to fault in the page. Bit 3 can be set only if
+        KVM_FEATURE_ASYNC_PF_ERROR is present in CPUID.
=20
 	First 4 byte of 64 byte memory location will be written to by
 	the hypervisor at the time of asynchronous page fault (APF)
 	injection to indicate type of asynchronous page fault. Value
 	of 1 means that the page referred to by the page fault is not
-	present. Value 2 means that the page is now available. Disabling
+	present. Value 2 means that the page is now available. Value 3
+        means that hypervisor met with error while trying to fault in
+        page and task should probably be sent SIGBUS. Disabling
 	interrupt inhibits APFs. Guest must not enable interrupt
 	before the reason is read, or it may be overwritten by another
 	APF. Since APF uses the same exception vector as regular page
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 98959e8cd448..011a5aab9df6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -765,6 +765,7 @@ struct kvm_vcpu_arch {
 		u32 host_apf_reason;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
+		bool send_pf_error;
 	} apf;
=20
 	/* OSVW MSRs (AMD only) */
@@ -1642,6 +1643,8 @@ void kvm_arch_async_page_present(struct kvm_vcpu *v=
cpu,
 				 struct kvm_async_pf *work);
 void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
 			       struct kvm_async_pf *work);
+void kvm_arch_async_page_fault_error(struct kvm_vcpu *vcpu,
+				 struct kvm_async_pf *work);
 bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu);
 extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
=20
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_p=
ara.h
index 9b4df6eaa11a..3d6339c6cd47 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -89,7 +89,7 @@ bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
-void kvm_async_pf_task_wake(u32 token);
+void kvm_async_pf_task_wake(u32 token, bool is_err);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code,=
 unsigned long address);
@@ -104,7 +104,7 @@ static inline void kvm_spinlock_init(void)
=20
 #else /* CONFIG_KVM_GUEST */
 #define kvm_async_pf_task_wait(T, I) do {} while(0)
-#define kvm_async_pf_task_wake(T) do {} while(0)
+#define kvm_async_pf_task_wake(T, I) do {} while(0)
=20
 static inline bool kvm_para_available(void)
 {
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index 2a8e0b6b9805..09743b45af79 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -31,6 +31,7 @@
 #define KVM_FEATURE_PV_SEND_IPI	11
 #define KVM_FEATURE_POLL_CONTROL	12
 #define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_ERROR	14
=20
 #define KVM_HINTS_REALTIME      0
=20
@@ -81,6 +82,7 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_SEND_ERROR			(1 << 3)
=20
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
@@ -110,6 +112,7 @@ struct kvm_mmu_op_release_pt {
=20
 #define KVM_PV_REASON_PAGE_NOT_PRESENT 1
 #define KVM_PV_REASON_PAGE_READY 2
+#define KVM_PV_REASON_PAGE_FAULT_ERROR 3
=20
 struct kvm_vcpu_pv_apf_data {
 	__u32 reason;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..b5e9e3fa82df 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -74,6 +74,7 @@ struct kvm_task_sleep_node {
 	u32 token;
 	int cpu;
 	bool halted;
+	bool is_err;
 };
=20
 static struct kvm_task_sleep_head {
@@ -96,6 +97,12 @@ static struct kvm_task_sleep_node *_find_apf_task(stru=
ct kvm_task_sleep_head *b,
 	return NULL;
 }
=20
+static void handle_async_pf_error(int user_mode)
+{
+	if (user_mode)
+		send_sig_info(SIGBUS, SEND_SIG_PRIV, current);
+}
+
 /*
  * @interrupt_kernel: Is this called from a routine which interrupts the=
 kernel
  * 		      (other than user space)?
@@ -113,6 +120,8 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_=
kernel)
 	e =3D _find_apf_task(b, token);
 	if (e) {
 		/* dummy entry exist -> wake up was delivered ahead of PF */
+		if (e->is_err)
+			handle_async_pf_error(!interrupt_kernel);
 		hlist_del(&e->link);
 		kfree(e);
 		raw_spin_unlock(&b->lock);
@@ -156,6 +165,9 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_=
kernel)
 	if (!n.halted)
 		finish_swait(&n.wq, &wait);
=20
+	if (n.is_err)
+		handle_async_pf_error(!interrupt_kernel);
+
 	rcu_irq_exit();
 	return;
 }
@@ -188,7 +200,7 @@ static void apf_task_wake_all(void)
 	}
 }
=20
-void kvm_async_pf_task_wake(u32 token)
+void kvm_async_pf_task_wake(u32 token, bool is_err)
 {
 	u32 key =3D hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b =3D &async_pf_sleepers[key];
@@ -219,10 +231,13 @@ void kvm_async_pf_task_wake(u32 token)
 		}
 		n->token =3D token;
 		n->cpu =3D smp_processor_id();
+		n->is_err =3D is_err;
 		init_swait_queue_head(&n->wq);
 		hlist_add_head(&n->link, &b->list);
-	} else
+	} else {
+		n->is_err =3D is_err;
 		apf_task_wake_one(n);
+	}
 	raw_spin_unlock(&b->lock);
 	return;
 }
@@ -255,7 +270,12 @@ do_async_page_fault(struct pt_regs *regs, unsigned l=
ong error_code, unsigned lon
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
-		kvm_async_pf_task_wake((u32)address);
+		kvm_async_pf_task_wake((u32)address, false);
+		rcu_irq_exit();
+		break;
+	case KVM_PV_REASON_PAGE_FAULT_ERROR:
+		rcu_irq_enter();
+		kvm_async_pf_task_wake((u32)address, true);
 		rcu_irq_exit();
 		break;
 	}
@@ -316,6 +336,9 @@ static void kvm_guest_cpu_init(void)
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |=3D KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
=20
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_ERROR))
+			pa |=3D KVM_ASYNC_PF_SEND_ERROR;
+
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
 		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..1ce1d998cbc2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -716,7 +716,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_en=
try2 *entry, u32 function,
 			     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
-			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
+			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_ASYNC_PF_ERROR);
=20
 		if (sched_info_on())
 			entry->eax |=3D (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 87e9ba27ada1..7c6e081bade1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4211,7 +4211,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u6=
4 error_code,
 	case KVM_PV_REASON_PAGE_READY:
 		vcpu->arch.apf.host_apf_reason =3D 0;
 		local_irq_disable();
-		kvm_async_pf_task_wake(fault_address);
+		kvm_async_pf_task_wake(fault_address, 0);
 		local_irq_enable();
 		break;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3156e25b0774..9cd388f1891a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2614,8 +2614,8 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *=
vcpu, u64 data)
 {
 	gpa_t gpa =3D data & ~0x3f;
=20
-	/* Bits 3:5 are reserved, Should be zero */
-	if (data & 0x38)
+	/* Bits 4:5 are reserved, Should be zero */
+	if (data & 0x30)
 		return 1;
=20
 	vcpu->arch.apf.msr_val =3D data;
@@ -2632,6 +2632,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *=
vcpu, u64 data)
=20
 	vcpu->arch.apf.send_user_only =3D !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit =3D data & KVM_ASYNC_PF_DELIVERY_A=
S_PF_VMEXIT;
+	vcpu->arch.apf.send_pf_error =3D data & KVM_ASYNC_PF_SEND_ERROR;
 	kvm_async_pf_wakeup_all(vcpu);
 	return 0;
 }
@@ -10338,12 +10339,16 @@ void kvm_arch_async_page_present(struct kvm_vcp=
u *vcpu,
 				 struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
-	u32 val;
+	u32 val, async_pf_event =3D KVM_PV_REASON_PAGE_READY;
=20
 	if (work->wakeup_all)
 		work->arch.token =3D ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
+
+	if (work->error_code && vcpu->arch.apf.send_pf_error)
+		async_pf_event =3D KVM_PV_REASON_PAGE_FAULT_ERROR;
+
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
=20
 	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
@@ -10359,7 +10364,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 			vcpu->arch.exception.error_code =3D 0;
 			vcpu->arch.exception.has_payload =3D false;
 			vcpu->arch.exception.payload =3D 0;
-		} else if (!apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
+		} else if (!apf_put_user(vcpu, async_pf_event)) {
 			fault.vector =3D PF_VECTOR;
 			fault.error_code_valid =3D true;
 			fault.error_code =3D 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb9b2ac0791..363fda33f803 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -206,6 +206,7 @@ struct kvm_async_pf {
 	unsigned long addr;
 	struct kvm_arch_async_pf arch;
 	bool   wakeup_all;
+	unsigned int error_code;
 };
=20
 void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..d5268d34fc8e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -51,6 +51,7 @@ static void async_pf_execute(struct work_struct *work)
 	unsigned long addr =3D apf->addr;
 	gpa_t cr2_or_gpa =3D apf->cr2_or_gpa;
 	int locked =3D 1;
+	long ret;
=20
 	might_sleep();
=20
@@ -60,11 +61,12 @@ static void async_pf_execute(struct work_struct *work=
)
 	 * access remotely.
 	 */
 	down_read(&mm->mmap_sem);
-	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
-			&locked);
+	ret =3D get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL=
,
+				    &locked);
 	if (locked)
 		up_read(&mm->mmap_sem);
=20
+	apf->error_code =3D ret;
 	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
 		kvm_arch_async_page_present(vcpu, apf);
=20
--=20
2.25.1

