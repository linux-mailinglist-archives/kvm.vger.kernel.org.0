Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5986E199F4C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbgCaTkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:40:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730413AbgCaTkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585683636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9XP7qOQdAyVIPUvWhW1SjxHhsmR51c3lqlU3bm8vzk=;
        b=TB22UnVoOerOyPqmvs5eu80sLUgJwIY7xLhn5quV9REi0SBhA3KGS61vb/r3uhaYA+HqOE
        C7yGksDYA+CAGe8rAru2h7rago1Ga/BrVQN3uJlcM4jtgH6uREz+Fyfym7mEAi8GByppAt
        rpc2yCpMDO2Q9vNlvEzb9iWZ8A6KptY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-ZfpoV4uaP2GLz7vv0Pc3aA-1; Tue, 31 Mar 2020 15:40:28 -0400
X-MC-Unique: ZfpoV4uaP2GLz7vv0Pc3aA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0134801E76;
        Tue, 31 Mar 2020 19:40:27 +0000 (UTC)
Received: from horse.redhat.com (ovpn-118-184.phx2.redhat.com [10.3.118.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FEB110002B5;
        Tue, 31 Mar 2020 19:40:21 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 65B5F2202C9; Tue, 31 Mar 2020 15:40:20 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, vgoyal@redhat.com, aarcange@redhat.com,
        dhildenb@redhat.com
Subject: [PATCH 2/4] kvm: async_pf: Send faulting gva address in case of error
Date:   Tue, 31 Mar 2020 15:40:09 -0400
Message-Id: <20200331194011.24834-3-vgoyal@redhat.com>
In-Reply-To: <20200331194011.24834-1-vgoyal@redhat.com>
References: <20200331194011.24834-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If async page fault returns/injects error in guest, also send guest virtu=
al
address at the time of page fault. This will be needed if guest decides
to send SIGBUS to task in guest. Guest process will need this info if it
were to take some action.

TODO: Nested kvm needs to be modified to use this. Also this patch only
      takes care of intel vmx.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/include/asm/kvm_host.h      | 14 ++++++++++-
 arch/x86/include/asm/kvm_para.h      |  8 +++----
 arch/x86/include/asm/vmx.h           |  2 ++
 arch/x86/include/uapi/asm/kvm_para.h |  9 ++++++-
 arch/x86/kernel/kvm.c                | 36 +++++++++++++++++-----------
 arch/x86/kvm/mmu/mmu.c               | 10 ++++----
 arch/x86/kvm/vmx/nested.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c               | 11 +++++++--
 arch/x86/kvm/x86.c                   | 34 +++++++++++++++++++-------
 9 files changed, 90 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 011a5aab9df6..0f83faeb5863 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -762,7 +762,7 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		u32 id;
 		bool send_user_only;
-		u32 host_apf_reason;
+		struct kvm_apf_reason host_apf_reason;
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool send_pf_error;
@@ -813,6 +813,10 @@ struct kvm_vcpu_arch {
 	bool gpa_available;
 	gpa_t gpa_val;
=20
+	/* GVA, if available at the time of VM exit */
+	bool gva_available;
+	gva_t gva_val;
+
 	/* be preempted when it's in kernel-mode(cpl=3D0) */
 	bool preempted_in_kernel;
=20
@@ -1275,8 +1279,16 @@ struct kvm_arch_async_pf {
 	gfn_t gfn;
 	unsigned long cr3;
 	bool direct_map;
+	bool gva_available;
+	gva_t gva_val;
 };
=20
+struct kvm_arch_async_pf_shared {
+	u32 reason;
+	u32 pad1;
+	u64 faulting_gva;
+} __packed;
+
 extern struct kvm_x86_ops *kvm_x86_ops;
 extern struct kmem_cache *x86_fpu_cache;
=20
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_p=
ara.h
index 3d6339c6cd47..2d464e470325 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -89,8 +89,8 @@ bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
-void kvm_async_pf_task_wake(u32 token, bool is_err);
-u32 kvm_read_and_reset_pf_reason(void);
+void kvm_async_pf_task_wake(u32 token, bool is_err, unsigned long addr);
+void kvm_read_and_reset_pf_reason(struct kvm_apf_reason *reason);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code,=
 unsigned long address);
=20
@@ -104,7 +104,7 @@ static inline void kvm_spinlock_init(void)
=20
 #else /* CONFIG_KVM_GUEST */
 #define kvm_async_pf_task_wait(T, I) do {} while(0)
-#define kvm_async_pf_task_wake(T, I) do {} while(0)
+#define kvm_async_pf_task_wake(T, I, A) do {} while(0)
=20
 static inline bool kvm_para_available(void)
 {
@@ -121,7 +121,7 @@ static inline unsigned int kvm_arch_para_hints(void)
 	return 0;
 }
=20
-static inline u32 kvm_read_and_reset_pf_reason(void)
+static inline void kvm_read_and_reset_pf_reason(struct kvm_apf_reason *r=
eason)
 {
 	return 0;
 }
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8521af3fef27..014cccb2d25d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -529,6 +529,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GLA_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -536,6 +537,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GLA_VALID		(1 << EPT_VIOLATION_GLA_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_=
BIT)
=20
 /*
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi=
/asm/kvm_para.h
index 09743b45af79..95dcb6dd3c8a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -116,10 +116,17 @@ struct kvm_mmu_op_release_pt {
=20
 struct kvm_vcpu_pv_apf_data {
 	__u32 reason;
-	__u8 pad[60];
+	__u8 pad1[4];
+	__u64 faulting_gva;
+	__u8 pad2[48];
 	__u32 enabled;
 };
=20
+struct kvm_apf_reason {
+	u32 reason;
+	u64 faulting_gva;
+};
+
 #define KVM_PV_EOI_BIT 0
 #define KVM_PV_EOI_MASK (0x1 << KVM_PV_EOI_BIT)
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b5e9e3fa82df..42d17e8c0135 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -75,6 +75,7 @@ struct kvm_task_sleep_node {
 	int cpu;
 	bool halted;
 	bool is_err;
+	unsigned long fault_addr;
 };
=20
 static struct kvm_task_sleep_head {
@@ -97,10 +98,10 @@ static struct kvm_task_sleep_node *_find_apf_task(str=
uct kvm_task_sleep_head *b,
 	return NULL;
 }
=20
-static void handle_async_pf_error(int user_mode)
+static void handle_async_pf_error(int user_mode, unsigned long fault_add=
r)
 {
 	if (user_mode)
-		send_sig_info(SIGBUS, SEND_SIG_PRIV, current);
+		force_sig_fault(SIGBUS, BUS_ADRERR, (void __user *)fault_addr);
 }
=20
 /*
@@ -121,7 +122,7 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_=
kernel)
 	if (e) {
 		/* dummy entry exist -> wake up was delivered ahead of PF */
 		if (e->is_err)
-			handle_async_pf_error(!interrupt_kernel);
+			handle_async_pf_error(!interrupt_kernel, e->fault_addr);
 		hlist_del(&e->link);
 		kfree(e);
 		raw_spin_unlock(&b->lock);
@@ -166,7 +167,7 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_=
kernel)
 		finish_swait(&n.wq, &wait);
=20
 	if (n.is_err)
-		handle_async_pf_error(!interrupt_kernel);
+		handle_async_pf_error(!interrupt_kernel, n.fault_addr);
=20
 	rcu_irq_exit();
 	return;
@@ -200,7 +201,7 @@ static void apf_task_wake_all(void)
 	}
 }
=20
-void kvm_async_pf_task_wake(u32 token, bool is_err)
+void kvm_async_pf_task_wake(u32 token, bool is_err, unsigned long fault_=
addr)
 {
 	u32 key =3D hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b =3D &async_pf_sleepers[key];
@@ -232,10 +233,12 @@ void kvm_async_pf_task_wake(u32 token, bool is_err)
 		n->token =3D token;
 		n->cpu =3D smp_processor_id();
 		n->is_err =3D is_err;
+		n->fault_addr =3D fault_addr;
 		init_swait_queue_head(&n->wq);
 		hlist_add_head(&n->link, &b->list);
 	} else {
 		n->is_err =3D is_err;
+		n->fault_addr =3D fault_addr;
 		apf_task_wake_one(n);
 	}
 	raw_spin_unlock(&b->lock);
@@ -243,16 +246,16 @@ void kvm_async_pf_task_wake(u32 token, bool is_err)
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
=20
-u32 kvm_read_and_reset_pf_reason(void)
+void kvm_read_and_reset_pf_reason(struct kvm_apf_reason *apf)
 {
-	u32 reason =3D 0;
-
 	if (__this_cpu_read(apf_reason.enabled)) {
-		reason =3D __this_cpu_read(apf_reason.reason);
+		apf->reason =3D __this_cpu_read(apf_reason.reason);
+		apf->faulting_gva =3D __this_cpu_read(apf_reason.faulting_gva);
 		__this_cpu_write(apf_reason.reason, 0);
+		__this_cpu_write(apf_reason.faulting_gva, 0);
+	} else {
+		apf->reason =3D 0;
 	}
-
-	return reason;
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
@@ -260,7 +263,11 @@ NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsi=
gned long address)
 {
-	switch (kvm_read_and_reset_pf_reason()) {
+	struct kvm_apf_reason apf_data;
+
+	kvm_read_and_reset_pf_reason(&apf_data);
+
+	switch (apf_data.reason) {
 	default:
 		do_page_fault(regs, error_code, address);
 		break;
@@ -270,12 +277,13 @@ do_async_page_fault(struct pt_regs *regs, unsigned =
long error_code, unsigned lon
 		break;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
-		kvm_async_pf_task_wake((u32)address, false);
+		kvm_async_pf_task_wake((u32)address, false, 0);
 		rcu_irq_exit();
 		break;
 	case KVM_PV_REASON_PAGE_FAULT_ERROR:
 		rcu_irq_enter();
-		kvm_async_pf_task_wake((u32)address, true);
+		kvm_async_pf_task_wake((u32)address, true,
+				       apf_data.faulting_gva);
 		rcu_irq_exit();
 		break;
 	}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7c6e081bade1..e3337c5f73e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4082,6 +4082,8 @@ static int kvm_arch_setup_async_pf(struct kvm_vcpu =
*vcpu, gpa_t cr2_or_gpa,
 	arch.direct_map =3D vcpu->arch.mmu->direct_map;
 	arch.cr3 =3D vcpu->arch.mmu->get_cr3(vcpu);
=20
+	arch.gva_available =3D vcpu->arch.gva_available;
+	arch.gva_val =3D vcpu->arch.gva_val;
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
@@ -4193,7 +4195,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u6=
4 error_code,
 #endif
=20
 	vcpu->arch.l1tf_flush_l1d =3D true;
-	switch (vcpu->arch.apf.host_apf_reason) {
+	switch (vcpu->arch.apf.host_apf_reason.reason) {
 	default:
 		trace_kvm_page_fault(fault_address, error_code);
=20
@@ -4203,15 +4205,15 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, =
u64 error_code,
 				insn_len);
 		break;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
-		vcpu->arch.apf.host_apf_reason =3D 0;
+		vcpu->arch.apf.host_apf_reason.reason =3D 0;
 		local_irq_disable();
 		kvm_async_pf_task_wait(fault_address, 0);
 		local_irq_enable();
 		break;
 	case KVM_PV_REASON_PAGE_READY:
-		vcpu->arch.apf.host_apf_reason =3D 0;
+		vcpu->arch.apf.host_apf_reason.reason =3D 0;
 		local_irq_disable();
-		kvm_async_pf_task_wake(fault_address, 0);
+		kvm_async_pf_task_wake(fault_address, 0, 0);
 		local_irq_enable();
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9750e590c89d..e8b026ec4acc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5560,7 +5560,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcp=
u, u32 exit_reason)
 		if (is_nmi(intr_info))
 			return false;
 		else if (is_page_fault(intr_info))
-			return !vmx->vcpu.arch.apf.host_apf_reason && enable_ept;
+			return !vmx->vcpu.arch.apf.host_apf_reason.reason && enable_ept;
 		else if (is_debug(intr_info) &&
 			 vcpu->guest_debug &
 			 (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 26f8f31563e9..80dffc7375b6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4676,7 +4676,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vc=
pu)
 	if (is_page_fault(intr_info)) {
 		cr2 =3D vmcs_readl(EXIT_QUALIFICATION);
 		/* EPT won't cause page fault directly */
-		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_reason && enable_ept);
+		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_reason.reason &&
+			     enable_ept);
 		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
 	}
=20
@@ -5159,6 +5160,7 @@ static int handle_ept_violation(struct kvm_vcpu *vc=
pu)
 	unsigned long exit_qualification;
 	gpa_t gpa;
 	u64 error_code;
+	gva_t gva;
=20
 	exit_qualification =3D vmcs_readl(EXIT_QUALIFICATION);
=20
@@ -5195,6 +5197,11 @@ static int handle_ept_violation(struct kvm_vcpu *v=
cpu)
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
=20
 	vcpu->arch.exit_qualification =3D exit_qualification;
+	if (exit_qualification | EPT_VIOLATION_GLA_VALID) {
+		gva =3D vmcs_readl(GUEST_LINEAR_ADDRESS);
+		vcpu->arch.gva_available =3D true;
+		vcpu->arch.gva_val =3D gva;
+	}
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
=20
@@ -6236,7 +6243,7 @@ static void handle_exception_nmi_irqoff(struct vcpu=
_vmx *vmx)
=20
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(vmx->exit_intr_info))
-		vmx->vcpu.arch.apf.host_apf_reason =3D kvm_read_and_reset_pf_reason();
+		kvm_read_and_reset_pf_reason(&vmx->vcpu.arch.apf.host_apf_reason);
=20
 	/* Handle machine checks before interrupts are enabled */
 	if (is_machine_check(vmx->exit_intr_info))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cd388f1891a..f3c79baf4998 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2627,7 +2627,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *=
vcpu, u64 data)
 	}
=20
 	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
-					sizeof(u32)))
+				      sizeof(struct kvm_arch_async_pf_shared)))
 		return 1;
=20
 	vcpu->arch.apf.send_user_only =3D !(data & KVM_ASYNC_PF_SEND_ALWAYS);
@@ -10261,12 +10261,18 @@ static void kvm_del_async_pf_gfn(struct kvm_vcp=
u *vcpu, gfn_t gfn)
 	}
 }
=20
-static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
+static int apf_put_user_u32(struct kvm_vcpu *vcpu, u32 val)
 {
-
 	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
 				      sizeof(val));
 }
+static int apf_put_user(struct kvm_vcpu *vcpu,
+			struct kvm_arch_async_pf_shared *val)
+{
+
+	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, val,
+				      sizeof(*val));
+}
=20
 static int apf_get_user(struct kvm_vcpu *vcpu, u32 *val)
 {
@@ -10309,12 +10315,16 @@ void kvm_arch_async_page_not_present(struct kvm=
_vcpu *vcpu,
 				     struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
+	struct kvm_arch_async_pf_shared apf_shared;
=20
 	trace_kvm_async_pf_not_present(work->arch.token, work->cr2_or_gpa);
 	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
=20
+	memset(&apf_shared, 0, sizeof(apf_shared));
+	apf_shared.reason =3D KVM_PV_REASON_PAGE_NOT_PRESENT;
+
 	if (kvm_can_deliver_async_pf(vcpu) &&
-	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
+	    !apf_put_user(vcpu, &apf_shared)) {
 		fault.vector =3D PF_VECTOR;
 		fault.error_code_valid =3D true;
 		fault.error_code =3D 0;
@@ -10339,15 +10349,21 @@ void kvm_arch_async_page_present(struct kvm_vcp=
u *vcpu,
 				 struct kvm_async_pf *work)
 {
 	struct x86_exception fault;
-	u32 val, async_pf_event =3D KVM_PV_REASON_PAGE_READY;
+	u32 val;
+	struct kvm_arch_async_pf_shared asyncpf_shared;
=20
 	if (work->wakeup_all)
 		work->arch.token =3D ~0; /* broadcast wakeup */
 	else
 		kvm_del_async_pf_gfn(vcpu, work->arch.gfn);
=20
-	if (work->error_code && vcpu->arch.apf.send_pf_error)
-		async_pf_event =3D KVM_PV_REASON_PAGE_FAULT_ERROR;
+	memset(&asyncpf_shared, 0, sizeof(asyncpf_shared));
+	asyncpf_shared.reason =3D KVM_PV_REASON_PAGE_READY;
+	if (work->error_code && vcpu->arch.apf.send_pf_error) {
+		asyncpf_shared.reason =3D KVM_PV_REASON_PAGE_FAULT_ERROR;
+		if (work->arch.gva_available)
+			asyncpf_shared.faulting_gva =3D work->arch.gva_val;
+	}
=20
 	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
=20
@@ -10356,7 +10372,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 		if (val =3D=3D KVM_PV_REASON_PAGE_NOT_PRESENT &&
 		    vcpu->arch.exception.pending &&
 		    vcpu->arch.exception.nr =3D=3D PF_VECTOR &&
-		    !apf_put_user(vcpu, 0)) {
+		    !apf_put_user_u32(vcpu, 0)) {
 			vcpu->arch.exception.injected =3D false;
 			vcpu->arch.exception.pending =3D false;
 			vcpu->arch.exception.nr =3D 0;
@@ -10364,7 +10380,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu =
*vcpu,
 			vcpu->arch.exception.error_code =3D 0;
 			vcpu->arch.exception.has_payload =3D false;
 			vcpu->arch.exception.payload =3D 0;
-		} else if (!apf_put_user(vcpu, async_pf_event)) {
+		} else if (!apf_put_user(vcpu, &asyncpf_shared)) {
 			fault.vector =3D PF_VECTOR;
 			fault.error_code_valid =3D true;
 			fault.error_code =3D 0;
--=20
2.25.1

