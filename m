Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0D60E6F
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 03:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfGFB1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 21:27:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46028 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfGFB1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 21:27:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so4940952pfq.12;
        Fri, 05 Jul 2019 18:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NNjXy3Z+JkBisrvsAHyMaM38Y/RTLA2X5jgP8ICreyI=;
        b=aGXhlezw/CFlywn7dYoXvLe6JuOE2b9vPX2+KaBoAizgV7w84ipCBckQoGSxnTIlQC
         f+YLWwPReM/qVr1bPq9I7VJWUbo5wZEzBfzGAeMgN7nAYQYDUZl2WUuZ+fVoF2rpWsQH
         BhkPg2a64kBUhNo75VsKzgHoj/7V043sm4xv6aN734C9c9KaqiNAav0vU5NMFkBOikx5
         XzYYg3SqtOc3J3EK6t7rFQ9xwRr372x7Dh12gHhXP/ROMG2Rs3qPpHwAcplsjeXxUq7N
         kU3BRnI+U2ra6GK6vis8XYV2oMJNEJ3JamlTzgifkKbeouwjhEQtBEPvD8K9H8EP732H
         c8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NNjXy3Z+JkBisrvsAHyMaM38Y/RTLA2X5jgP8ICreyI=;
        b=JrlIYj+2ZdDHSHJI5jG0y078Dl6IqLVW66OS8RzeHoTDPgxbHthmR2wVpNKVACklg8
         OMdubI1TqhV9NTjmA9DKvL4W3oz3V+ZOwfHYCIqRY1aNc1lG7fIb2hg5A5VEUYcmYuNd
         4YL53KEN8Z62Qo2hIHVQ0fgv/QUqjPD7W1ftxCAgU7NoZXyuHzOfpMYDQ94JtxtUQu7i
         vY0Kz8qCBfzF0fF9U7NiP8m+qcU7Fgc72af7LzVXuJ/JyLkgvuD9fSvCI5R5iaIrvaGo
         uAwamyRcwqWtSj8CKZwlYqdRZFOwf+5YFY1UQuX5m4mxeYgXeoNtTzninh3WAWyTS7Jt
         SXTA==
X-Gm-Message-State: APjAAAUzxdS2SSTrh4XAUjN4y7+Iq6Vyo7n6i6jpqq4IsmimDHIvCY3G
        zNbPKZA1QD+GGceJTZJXlB/X3CSbr80=
X-Google-Smtp-Source: APXvYqzs3NLl1dIAPETCpezXtsyntab1AtWjg0ocZXzRf1j94piqkQBourRzIU7/gkJiGBOv/nJ9Rg==
X-Received: by 2002:a63:5c1c:: with SMTP id q28mr8351368pgb.288.1562376425811;
        Fri, 05 Jul 2019 18:27:05 -0700 (PDT)
Received: from localhost ([2409:8a00:7815:93e0:4a4d:7eff:feb0:5c9a])
        by smtp.gmail.com with ESMTPSA id n1sm8298511pgv.15.2019.07.05.18.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 18:27:05 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v7 2/2] KVM: LAPIC: Inject timer interrupt via posted interrupt
Date:   Sat,  6 Jul 2019 09:26:51 +0800
Message-Id: <1562376411-3533-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
References: <1562376411-3533-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/lapic.c            | 101 ++++++++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h            |   1 +
 arch/x86/kvm/vmx/vmx.c          |   3 +-
 arch/x86/kvm/x86.c              |   6 +++
 arch/x86/kvm/x86.h              |   2 +
 include/linux/sched/isolation.h |   2 +
 kernel/sched/isolation.c        |   6 +++
 7 files changed, 85 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 707ca9c..4869691 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -128,6 +128,17 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
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
@@ -1436,29 +1447,6 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 	}
 }
 
-static void apic_timer_expired(struct kvm_lapic *apic)
-{
-	struct kvm_vcpu *vcpu = apic->vcpu;
-	struct swait_queue_head *q = &vcpu->wq;
-	struct kvm_timer *ktimer = &apic->lapic_timer;
-
-	if (atomic_read(&apic->lapic_timer.pending))
-		return;
-
-	atomic_inc(&apic->lapic_timer.pending);
-	kvm_set_pending_timer(vcpu);
-
-	/*
-	 * For x86, the atomic_inc() is serialized, thus
-	 * using swait_active() is safe.
-	 */
-	if (swait_active(q))
-		swake_up_one(q);
-
-	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
-		ktimer->expired_tscdeadline = ktimer->tscdeadline;
-}
-
 /*
  * On APICv, this test will cause a busy wait
  * during a higher-priority task.
@@ -1532,7 +1520,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1540,9 +1528,6 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
-		return;
-
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
 	apic->lapic_timer.expired_tscdeadline = 0;
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
@@ -1554,8 +1539,59 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
+
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+{
+	if (!lapic_timer_int_injected(vcpu))
+		return;
+
+	__kvm_wait_lapic_expire(vcpu);
+}
 EXPORT_SYMBOL_GPL(kvm_wait_lapic_expire);
 
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
+static void apic_timer_expired(struct kvm_lapic *apic)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+	struct swait_queue_head *q = &vcpu->wq;
+	struct kvm_timer *ktimer = &apic->lapic_timer;
+
+	if (atomic_read(&apic->lapic_timer.pending))
+		return;
+
+	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
+		ktimer->expired_tscdeadline = ktimer->tscdeadline;
+
+	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
+		if (apic->lapic_timer.timer_advance_ns)
+			__kvm_wait_lapic_expire(vcpu);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
+	atomic_inc(&apic->lapic_timer.pending);
+	kvm_set_pending_timer(vcpu);
+
+	/*
+	 * For x86, the atomic_inc() is serialized, thus
+	 * using swait_active() is safe.
+	 */
+	if (swait_active(q))
+		swake_up_one(q);
+}
+
 static void start_sw_tscdeadline(struct kvm_lapic *apic)
 {
 	struct kvm_timer *ktimer = &apic->lapic_timer;
@@ -2377,13 +2413,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
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
@@ -2505,7 +2535,8 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 {
 	struct hrtimer *timer;
 
-	if (!lapic_in_kernel(vcpu))
+	if (!lapic_in_kernel(vcpu) ||
+		kvm_can_post_timer_interrupt(vcpu))
 		return;
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..e32dd7d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -231,6 +231,7 @@ int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b35b3800..d152552a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
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

