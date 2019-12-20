Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2206D128378
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLTVCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 16:02:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30095 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727580AbfLTVCE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 16:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576875723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xw6vxNv2Dzp8BiJgba6J6ltllpBfM6qD76X6Uw0YGI0=;
        b=H2XHyXZICe0ZF36oiLuULK9bXTl3LZQDozwf1VtvpVemrn4rx89E7RYh5s1TKmslOL0kux
        uUv4KrvXK1IgUSBbUDz1UAvRb6sTXFCHfuEKSvu3OWoq93ywsDueFwQZJ785CDkAUGyiqz
        erJUQyX7eqBWjArOP+VvapeKhr7ZQhA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-JYpOaaAsMRK40bm1v5de_A-1; Fri, 20 Dec 2019 16:02:01 -0500
X-MC-Unique: JYpOaaAsMRK40bm1v5de_A-1
Received: by mail-qv1-f69.google.com with SMTP id v3so935844qvm.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 13:02:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xw6vxNv2Dzp8BiJgba6J6ltllpBfM6qD76X6Uw0YGI0=;
        b=HH/xZCsksC1C1x0/Rk9d+aDpyvkXS2qYCxroN1CnF2m7dPy/K6bV8LCVgEMUMh7tHV
         RElaPOwLlMN/QHQ65ZtsQdEIHarz3jzp/HJqRTGuJXqjdtpWSfCrBBhdVP3q2uhiE8XJ
         ItQgocsBVgH84Rss/mi6zn1YDy9r3UuKIW7p0kceAev7O2SpZhrnVLVIIahC34tseJt9
         vrpz4/I8Iu5mDbEtGCeSzW9QFyCbBGYtYlum55g1ljAtn0ix2XwpVip9VEg9FZVXDFiu
         EzkmNdS4mqRPW29YDsgIiHkJ3oHccirfj4Yc9SBq+MtLM0FpYQ+Tvkvmi0mfC+AzxwMf
         MjSg==
X-Gm-Message-State: APjAAAWlsW2Ysu8aGBYubmP9DOoOlJ8HhgAgSvw0jXmaIW0SqHr5H1Bp
        AkTstZ4YfJfqRFBaTgQBfEJXiQomfSXwoc1Y2vppqqpR5T/520e79jh0as09d3/YN4RwtUthVGN
        EZz3VSJyMj6ix
X-Received: by 2002:ac8:541a:: with SMTP id b26mr13788171qtq.276.1576875721031;
        Fri, 20 Dec 2019 13:02:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqzT5oWo6p+6Ll1ByC/kV6xa+HbcTKEqscWADuYQ4gGZR1CWopyTrBlWNXSJHOEDZdLf5lzecQ==
X-Received: by 2002:ac8:541a:: with SMTP id b26mr13788131qtq.276.1576875720685;
        Fri, 20 Dec 2019 13:02:00 -0800 (PST)
Received: from xz-x1.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q25sm3243836qkq.88.2019.12.20.13.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 13:01:59 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH v2 07/17] KVM: Move running VCPU from ARM to common code
Date:   Fri, 20 Dec 2019 16:01:37 -0500
Message-Id: <20191220210147.49617-8-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220210147.49617-1-peterx@redhat.com>
References: <20191220210147.49617-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

For ring-based dirty log tracking, it will be more efficient to account
writes during schedule-out or schedule-in to the currently running VCPU.
We would like to do it even if the write doesn't use the current VCPU's
address space, as is the case for cached writes (see commit 4e335d9e7ddb,
"Revert "KVM: Support vCPU-based gfn->hva cache"", 2017-05-02).

Therefore, add a mechanism to track the currently-loaded kvm_vcpu struct.
There is already something similar in KVM/ARM; one important difference
is that kvm_arch_vcpu_{load,put} have two callers in virt/kvm/kvm_main.c:
we have to update both the architecture-independent vcpu_{load,put} and
the preempt notifiers.

Another change made in the process is to allow using kvm_get_running_vcpu()
in preemptible code.  This is allowed because preempt notifiers ensure
that the value does not change even after the VCPU thread is migrated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/arm/include/asm/kvm_host.h   |  2 --
 arch/arm64/include/asm/kvm_host.h |  2 --
 include/linux/kvm_host.h          |  3 +++
 virt/kvm/arm/arch_timer.c         |  2 +-
 virt/kvm/arm/arm.c                | 29 -----------------------------
 virt/kvm/arm/perf.c               |  6 +++---
 virt/kvm/arm/vgic/vgic-mmio.c     | 15 +++------------
 virt/kvm/kvm_main.c               | 25 ++++++++++++++++++++++++-
 8 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8a37c8e89777..40eff9cc3744 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -274,8 +274,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f656169db8c3..df8d72f7c20e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -430,8 +430,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 24854c9e3717..b4f7bef38e0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1323,6 +1323,9 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
 
+struct kvm_vcpu *kvm_get_running_vcpu(void);
+struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
+
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index e2bb5bd60227..085e7fed850c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -1022,7 +1022,7 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
 
 bool kvm_arch_timer_get_input_level(int vintid)
 {
-	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
 
 	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86c6aa1cb58e..f7dbb94ec525 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -47,9 +47,6 @@ __asm__(".arch_extension	virt");
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
-/* Per-CPU variable containing the currently running vcpu. */
-static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
-
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
@@ -58,31 +55,8 @@ static DEFINE_SPINLOCK(kvm_vmid_lock);
 static bool vgic_present;
 
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
-
-static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
-{
-	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
-}
-
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-/**
- * kvm_arm_get_running_vcpu - get the vcpu running on the current CPU.
- * Must be called from non-preemptible context
- */
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
-{
-	return __this_cpu_read(kvm_arm_running_vcpu);
-}
-
-/**
- * kvm_arm_get_running_vcpus - get the per-CPU array of currently running vcpus.
- */
-struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
-{
-	return &kvm_arm_running_vcpu;
-}
-
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -374,7 +348,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->cpu = cpu;
 	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
 
-	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
@@ -398,8 +371,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_restore_host(vcpu);
 
 	vcpu->cpu = -1;
-
-	kvm_arm_set_running_vcpu(NULL);
 }
 
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/perf.c b/virt/kvm/arm/perf.c
index 918cdc3839ea..d45b8b9a4415 100644
--- a/virt/kvm/arm/perf.c
+++ b/virt/kvm/arm/perf.c
@@ -13,14 +13,14 @@
 
 static int kvm_is_in_guest(void)
 {
-        return kvm_arm_get_running_vcpu() != NULL;
+        return kvm_get_running_vcpu() != NULL;
 }
 
 static int kvm_is_user_mode(void)
 {
 	struct kvm_vcpu *vcpu;
 
-	vcpu = kvm_arm_get_running_vcpu();
+	vcpu = kvm_get_running_vcpu();
 
 	if (vcpu)
 		return !vcpu_mode_priv(vcpu);
@@ -32,7 +32,7 @@ static unsigned long kvm_get_guest_ip(void)
 {
 	struct kvm_vcpu *vcpu;
 
-	vcpu = kvm_arm_get_running_vcpu();
+	vcpu = kvm_get_running_vcpu();
 
 	if (vcpu)
 		return *vcpu_pc(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 0d090482720d..d656ebd5f9d4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -190,15 +190,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
  * value later will give us the same value as we update the per-CPU variable
  * in the preempt notifier handlers.
  */
-static struct kvm_vcpu *vgic_get_mmio_requester_vcpu(void)
-{
-	struct kvm_vcpu *vcpu;
-
-	preempt_disable();
-	vcpu = kvm_arm_get_running_vcpu();
-	preempt_enable();
-	return vcpu;
-}
 
 /* Must be called with irq->irq_lock held */
 static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
@@ -221,7 +212,7 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
+	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -274,7 +265,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !vgic_get_mmio_requester_vcpu();
+	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -335,7 +326,7 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 				    bool active)
 {
 	unsigned long flags;
-	struct kvm_vcpu *requester_vcpu = vgic_get_mmio_requester_vcpu();
+	struct kvm_vcpu *requester_vcpu = kvm_get_running_vcpu();
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 17969cf110dd..5c606d158854 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -108,6 +108,7 @@ struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
 
 static __read_mostly struct preempt_ops kvm_preempt_ops;
+static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_running_vcpu);
 
 struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
@@ -199,6 +200,8 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 void vcpu_load(struct kvm_vcpu *vcpu)
 {
 	int cpu = get_cpu();
+
+	__this_cpu_write(kvm_running_vcpu, vcpu);
 	preempt_notifier_register(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_load(vcpu, cpu);
 	put_cpu();
@@ -210,6 +213,7 @@ void vcpu_put(struct kvm_vcpu *vcpu)
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
+	__this_cpu_write(kvm_running_vcpu, NULL);
 	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(vcpu_put);
@@ -4294,8 +4298,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	WRITE_ONCE(vcpu->preempted, false);
 	WRITE_ONCE(vcpu->ready, false);
 
+	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_sched_in(vcpu, cpu);
-
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
@@ -4309,6 +4313,25 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 		WRITE_ONCE(vcpu->ready, true);
 	}
 	kvm_arch_vcpu_put(vcpu);
+	__this_cpu_write(kvm_running_vcpu, NULL);
+}
+
+/**
+ * kvm_get_running_vcpu - get the vcpu running on the current CPU.
+ * Thanks to preempt notifiers, this can also be called from
+ * preemptible context.
+ */
+struct kvm_vcpu *kvm_get_running_vcpu(void)
+{
+        return __this_cpu_read(kvm_running_vcpu);
+}
+
+/**
+ * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
+ */
+struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void)
+{
+        return &kvm_running_vcpu;
 }
 
 static void check_processor_compat(void *rtn)
-- 
2.24.1

