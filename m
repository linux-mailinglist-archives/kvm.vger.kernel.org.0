Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1466E135C16
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgAIO7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:59:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732005AbgAIO6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:58:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GjELQ4ch6bUfpWMojlZkE0ODIq70oi5Kwek7NgAA0/Y=;
        b=AfXEHq0c5ejjCgOQ9pK23hC3DwjwyDBXZZfXALckWelocuxX2TOu8JkLgAw2jQpMagnzAp
        xdNbwF8G52D8OryprlkQufJAtl30oc3TIL4aGs37cvf/PYVqsFe7ndkKGbPizcmC0Uapd9
        GhJbS+zoKV3/IoyrkleYUPwudHbytgs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-lJbKYCYXNySNP5JPvIgHQw-1; Thu, 09 Jan 2020 09:58:04 -0500
X-MC-Unique: lJbKYCYXNySNP5JPvIgHQw-1
Received: by mail-qk1-f198.google.com with SMTP id m13so4283430qka.9
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GjELQ4ch6bUfpWMojlZkE0ODIq70oi5Kwek7NgAA0/Y=;
        b=cF1/330Q9y96uQRQFpJIUzWgZ/i1HQ3OxUR2CD1YCSlCWkfQ3rT4qUUq6ReXZ08wVV
         rVE7Nts2qz6Wo9t8jbz7wvd+TM5X8k9wk6TLma6SUZ8S4VwTj9Vv7xyvMRelhtSCaHxR
         5YeLt47JIaddT77lCvPQ5De3wCE5bjRaqzCq7aObInnwEfYrxKHV4A6CwJDxLq7Eorxx
         WsRogeVpMLpgTlmFyZh5IOs6y4a0hge0yL/9XVf61u5QKy487e0GLzPg51/ulOLFob+9
         YfPaHFadpxAOuwu7Xbp4OoE8HsqfrJLrVCVTu4vIAs69W5SPZAtw0mquVKeruYYQTwVQ
         tTiA==
X-Gm-Message-State: APjAAAXJHZOHtVFhpPVL1qSOuzU/Lt4ZFNtq6fYQKI/Ll/82WWKVRkZ4
        lMpt7zdL7Dx7kuoLJiKl4ijqa/tKUV7PbK20d7BikR/X2BLuwLfyPlAm2YWM3bR6PUcPp74gX2R
        4dNEzAl8XoflH
X-Received: by 2002:a05:620a:6cc:: with SMTP id 12mr10223277qky.307.1578581883431;
        Thu, 09 Jan 2020 06:58:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqzP44DUKoC71rp7Hfr+zAsn6v+OupR+yTVgvz266MrANVKdmmxph98eVT1lNqyPZF1oF3il/A==
X-Received: by 2002:a05:620a:6cc:: with SMTP id 12mr10223249qky.307.1578581883060;
        Thu, 09 Jan 2020 06:58:03 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:00 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 11/21] KVM: Move running VCPU from ARM to common code
Date:   Thu,  9 Jan 2020 09:57:19 -0500
Message-Id: <20200109145729.32898-12-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
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
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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
index 556cd818eccf..abc3f6f3ad76 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -284,8 +284,6 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c61260cf63c5..12302f9035f9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,8 +446,6 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
-struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
-struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
 void kvm_arm_halt_guest(struct kvm *kvm);
 void kvm_arm_resume_guest(struct kvm *kvm);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 763adf8c47b0..cbd633ece959 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1340,6 +1340,9 @@ static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
 }
 #endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
 
+struct kvm_vcpu *kvm_get_running_vcpu(void);
+struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
+
 #ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
 bool kvm_arch_has_irq_bypass(void);
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f182b2380345..63dd6f27997c 100644
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
index 8de4daf25097..b00a9870e5ec 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -51,9 +51,6 @@ __asm__(".arch_extension	virt");
 DEFINE_PER_CPU(kvm_host_data_t, kvm_host_data);
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 
-/* Per-CPU variable containing the currently running vcpu. */
-static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
-
 /* The VMID used in the VTTBR */
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
@@ -62,31 +59,8 @@ static DEFINE_SPINLOCK(kvm_vmid_lock);
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
@@ -406,7 +380,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->cpu = cpu;
 	vcpu->arch.host_cpu_context = &cpu_data->host_ctxt;
 
-	kvm_arm_set_running_vcpu(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vcpu_load_sysregs(vcpu);
@@ -432,8 +405,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
index 028dfc27479b..5bbd8b8730fa 100644
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
@@ -4297,8 +4301,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	WRITE_ONCE(vcpu->preempted, false);
 	WRITE_ONCE(vcpu->ready, false);
 
+	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_sched_in(vcpu, cpu);
-
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
@@ -4312,6 +4316,25 @@ static void kvm_sched_out(struct preempt_notifier *pn,
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

