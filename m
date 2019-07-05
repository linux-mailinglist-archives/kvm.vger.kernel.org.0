Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF760876
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 16:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfGEOxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 10:53:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34646 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfGEOxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 10:53:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id i2so4733456plt.1;
        Fri, 05 Jul 2019 07:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KfWY5mjfljX9TQ8owEg5aulNWNs6bT1M9EEoVMXwx6s=;
        b=G/lZ0VJD+3aN58n6BcqLyDLgosGyylUbAfy/Tqrw2ssUs9cgN8XRuwTeej5CoF2PRk
         hfG13xCUFVpVY9ddePEyNrvLfToCQ5i/Dy4WEFmMm521NefzccUUpTDYTZgUst6n1yCj
         sxGDov5lPw6tNLsv39YXPgMmEmpKCSMwZ3qPHZzvNiMtZBbMn51cEXvVRFPiq2B+zhWY
         vUuSpdxVa1YsEIpV8wWGwAFoQAqk+bCQcdOrUl3247YJHamq+X8zqNc9WnhNf9nVN3aL
         IHSpdrwoPNPZA5gDkgeKvvFqDmb9KcFwAFPyZgvcf8LIeirC2/eEJxKoHYKC14M3SBnF
         lZjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KfWY5mjfljX9TQ8owEg5aulNWNs6bT1M9EEoVMXwx6s=;
        b=Kzw8gDoNrIZoKCg+qUPEBD28Z1liPVndj2lsCpbM7kVi2i0RQcrniFt2DjGG2qCMCt
         cFvMyNCAZR6heGytNEiYVBFQmv9jO5u1H5p9DkyOJAiZPGmkFafAAkM2Zh0WGB5iY8j8
         awa6F/s06Mb/R6/7Jwf1ZsvAyKu2K0GABS4hAUQGGWiOmw1gsF2P6uxJzJfZqU6PFksP
         j///+tDaJGrjvfQ7iHvvY3k5VnQB23AIVT4wwociLAo/H+/Ubte9VcbZwtCbNOUd9QVY
         pzsFbJh/IALbnqs/cgjFy1oFJePqaexjYWTYtJTA7Xy72tKNhWxxMBCpWzILdYADYKea
         WDUQ==
X-Gm-Message-State: APjAAAXqLQGel2L2xpPKxA9H6NY5/bQT9YjKGmNuQPUDmAtOinAbUkow
        5o5tQKuhqUXqOie4qkdofZFIpaTFv1A=
X-Google-Smtp-Source: APXvYqwstR7ZSlNGtwLMlktowCGbnJy0sA6Js/tWinMPT5K+pQkaYhOuQ0h5hEzAxSQRZ4LmII1+/g==
X-Received: by 2002:a17:902:7483:: with SMTP id h3mr6178783pll.28.1562338398050;
        Fri, 05 Jul 2019 07:53:18 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id g14sm8505574pgn.8.2019.07.05.07.53.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 07:53:17 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v6 2/2] KVM: LAPIC: Inject timer interrupt via posted interrupt
Date:   Fri,  5 Jul 2019 22:52:45 +0800
Message-Id: <1562338365-22789-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
References: <1562338365-22789-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Dedicated instances are currently disturbed by unnecessary jitter due 
to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
There is no hardware virtual timer on Intel for guest like ARM. Both 
programming timer in guest and the emulated timer fires incur vmexits.
This patch tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the emulated 
timers can be offload to the nearest busy housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected 
by posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

The host admin should fine tuned, e.g. dedicated instances scenario w/ 
nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus 
for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root  
mode, ~3% redis performance benefit can be observed on Skylake server.

w/o patch:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time   Avg time

EXTERNAL_INTERRUPT    42916    49.43%   39.30%   0.47us   106.09us   0.71us ( +-   1.09% )

w/ patch:

            VM-EXIT  Samples  Samples%  Time%   Min Time  Max Time         Avg time

EXTERNAL_INTERRUPT    6871     9.29%     2.96%   0.44us    57.88us   0.72us ( +-   4.02% )

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c            | 52 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/lapic.h            |  3 ++-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 ++--
 arch/x86/kvm/x86.c              |  6 +++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 +++++
 8 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9f09100..95affa5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -127,6 +127,17 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
+bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_can_post_timer_interrupt);
+
+static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
+{
+	return kvm_can_post_timer_interrupt(vcpu) && vcpu->mode == IN_GUEST_MODE;
+}
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1435,6 +1446,19 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 	}
 }
 
+static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
+{
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+
+	kvm_apic_local_deliver(apic, APIC_LVTT);
+	if (apic_lvtt_tscdeadline(apic))
+		ktimer->tscdeadline = 0;
+	if (apic_lvtt_oneshot(apic)) {
+		ktimer->tscdeadline = 0;
+		ktimer->target_expiration = 0;
+	}
+}
+
 static void apic_timer_expired(struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu = apic->vcpu;
@@ -1444,6 +1468,16 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
+	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
+		ktimer->expired_tscdeadline = ktimer->tscdeadline;
+
+	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
+		if (apic->lapic_timer.timer_advance_ns)
+			kvm_wait_lapic_expire(vcpu, true);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
 
@@ -1453,9 +1487,6 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	 */
 	if (swait_active(q))
 		swake_up_one(q);
-
-	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
-		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 }
 
 /*
@@ -1531,7 +1562,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1539,7 +1570,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
+	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
 		return;
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
@@ -2376,13 +2407,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (atomic_read(&apic->lapic_timer.pending) > 0) {
-		kvm_apic_local_deliver(apic, APIC_LVTT);
-		if (apic_lvtt_tscdeadline(apic))
-			apic->lapic_timer.tscdeadline = 0;
-		if (apic_lvtt_oneshot(apic)) {
-			apic->lapic_timer.tscdeadline = 0;
-			apic->lapic_timer.target_expiration = 0;
-		}
+		kvm_apic_inject_pending_timer_irqs(apic);
 		atomic_set(&apic->lapic_timer.pending, 0);
 	}
 }
@@ -2504,7 +2529,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		kvm_can_post_timer_interrupt(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..d96f252 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -220,7 +220,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
@@ -231,6 +231,7 @@ int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1e778d7..f120b64 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5645,7 +5645,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b35b3800..5d39a29 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6447,7 +6447,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
@@ -7036,7 +7036,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
 	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
-	if (kvm_mwait_in_guest(vcpu->kvm))
+	if (kvm_mwait_in_guest(vcpu->kvm) ||
+		kvm_can_post_timer_interrupt(vcpu))
 		return -EOPNOTSUPP;
 
 	vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e199ac7..ed63103 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -54,6 +54,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 
 #include <trace/events/kvm.h>
@@ -155,6 +156,9 @@
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
+int __read_mostly pi_inject_timer = -1;
+module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -7043,6 +7047,8 @@ int kvm_arch_init(void *opaque)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
 	kvm_lapic_init();
+	if (pi_inject_timer == -1)
+		pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0..bb1e99b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -296,6 +296,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 
 extern bool enable_vmware_backdoor;
 
+extern int pi_inject_timer;
+
 extern struct static_key kvm_no_apic_vcpu;
 
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index b0fb144..6fc5407 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -19,6 +19,7 @@ enum hk_flags {
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 extern int housekeeping_any_cpu(enum hk_flags flags);
 extern const struct cpumask *housekeeping_cpumask(enum hk_flags flags);
+extern bool housekeeping_enabled(enum hk_flags flags);
 extern void housekeeping_affine(struct task_struct *t, enum hk_flags flags);
 extern bool housekeeping_test_cpu(int cpu, enum hk_flags flags);
 extern void __init housekeeping_init(void);
@@ -38,6 +39,7 @@ static inline const struct cpumask *housekeeping_cpumask(enum hk_flags flags)
 static inline void housekeeping_affine(struct task_struct *t,
 				       enum hk_flags flags) { }
 static inline void housekeeping_init(void) { }
+static inline bool housekeeping_enabled(enum hk_flags flags) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 6873020..4d4bae8 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -13,6 +13,12 @@
 static cpumask_var_t housekeeping_mask;
 static unsigned int housekeeping_flags;
 
+bool housekeeping_enabled(enum hk_flags flags)
+{
+	return !!(housekeeping_flags & flags);
+}
+EXPORT_SYMBOL_GPL(housekeeping_enabled);
+
 int housekeeping_any_cpu(enum hk_flags flags)
 {
 	if (static_branch_unlikely(&housekeeping_overridden))
-- 
1.8.3.1

