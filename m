Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647594E450
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 11:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfFUJlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 05:41:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33271 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfFUJkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 05:40:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id m4so2495982pgk.0;
        Fri, 21 Jun 2019 02:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FMsOX5W0VOv0pdIuUXbwft5LV3vGdPWiASZUECTOpTc=;
        b=eXAfwgNxx6BzNPECHfq21KTuG0a/N4DDkLFbeQq+oblCmRZie1bN8eSzc827+ir+/Z
         kPielmq5MQJBg0bChJdkfba3swQZCTaLZm2FQiH4oK+vsVY/GPIhsO0VcdAFPDS2uVhG
         tJWMHs6IdZS3rAB8s3c9rywEDa9D+snQ87mn2rTyUstTGcnpfBfn4j9Gx09Zxm39RrVm
         e0kjQcgH21x0GA1LdKXzJx7D59HkACBMcyc+0NX1Po2FYZuqzh2BeNAV2huvwNUNaEVE
         YIVlJsdinpWrII7ds4/bJulSzLgJzbXGcUpnJ+n5/C9fOEw0eKXbVkFe6Am2Pr/L7OnB
         a4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FMsOX5W0VOv0pdIuUXbwft5LV3vGdPWiASZUECTOpTc=;
        b=TVlrKQienAGeOxPKVHwyvsOFDfR+xSvTjLkh/2BU3sOrgtxqtyiFXEy/M9zftqMgCj
         d9vrsZEH46HuIfbmIAEgd4hfKmorJB6f4JX0YtpDUDYk9dvpvh8X2xR8Eo82y69RPoZC
         UPcOU9eQ5liZqOI+zzj2cYec1qgJ73IVpMJsqP/6Xkq3cilf5w4IxL22ZVZxhVPZ+gUl
         ofF5soZOyO2vicOfWNysk0tKgtu+VUizQgtxY3WTc41LgmtExdqnj3zrPZsCTUOTW85h
         Rx7rA9JGvsNkayAGabcsMLkvsbeFzNmwjECyfcpwGZ+d3nrGDxyy3hEqmEeZ4gTftAcD
         7QAw==
X-Gm-Message-State: APjAAAUPLYI8hLnMFElKLFLbdeqnpUbbtPe9liQoEhtttCkKpbxSOt3o
        jrsnqVvtcgynYuEX9A3fiepdqSHH
X-Google-Smtp-Source: APXvYqzeNO+RM+TprbZpIPWE1sKx5Wpe1LnsPcmLzc2hgSwupLyjVvnOM0CqOfkCtjh/YP6s7fH56Q==
X-Received: by 2002:a17:90a:5d0a:: with SMTP id s10mr5379341pji.94.1561110016931;
        Fri, 21 Jun 2019 02:40:16 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id y14sm1999506pjr.13.2019.06.21.02.40.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 21 Jun 2019 02:40:16 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v5 2/4] KVM: LAPIC: Inject timer interrupt via posted interrupt
Date:   Fri, 21 Jun 2019 17:40:00 +0800
Message-Id: <1561110002-4438-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/lapic.c            | 45 ++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/lapic.h            |  3 ++-
 arch/x86/kvm/svm.c              |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  5 +++--
 arch/x86/kvm/x86.c              |  5 +++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++++
 8 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 87ecb56..8869d30 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -122,6 +122,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
+bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
+{
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		kvm_hlt_in_guest(vcpu->kvm);
+}
+EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1432,6 +1439,19 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
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
@@ -1441,6 +1461,16 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
+	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
+		ktimer->expired_tscdeadline = ktimer->tscdeadline;
+
+	if (posted_interrupt_inject_timer(apic->vcpu)) {
+		if (apic->lapic_timer.timer_advance_ns)
+			kvm_wait_lapic_expire(vcpu, true);
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
 
@@ -1450,9 +1480,6 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	 */
 	if (swait_active(q))
 		swake_up_one(q);
-
-	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
-		ktimer->expired_tscdeadline = ktimer->tscdeadline;
 }
 
 /*
@@ -1528,7 +1555,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
 }
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 guest_tsc, tsc_deadline;
@@ -1536,7 +1563,7 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (apic->lapic_timer.expired_tscdeadline == 0)
 		return;
 
-	if (!lapic_timer_int_injected(vcpu))
+	if (!lapic_timer_int_injected(vcpu) && !pi_inject)
 		return;
 
 	tsc_deadline = apic->lapic_timer.expired_tscdeadline;
@@ -2373,13 +2400,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 3674717..3d8a043 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -225,7 +225,7 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
-void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
+void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu, bool pi_inject);
 
 bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			struct kvm_vcpu **dest_vcpu);
@@ -236,6 +236,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bbc31f7..7e65de4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5648,7 +5648,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d174b62..f74eb6a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6468,7 +6468,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
-		kvm_wait_lapic_expire(vcpu);
+		kvm_wait_lapic_expire(vcpu, false);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
@@ -7065,7 +7065,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
 	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
-	if (kvm_mwait_in_guest(vcpu->kvm))
+	if (kvm_mwait_in_guest(vcpu->kvm) ||
+		posted_interrupt_inject_timer(vcpu))
 		return -EOPNOTSUPP;
 
 	vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7c757d..74ee1f4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -54,6 +54,7 @@
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
+#include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 
 #include <trace/events/kvm.h>
@@ -155,6 +156,9 @@ EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
 static bool __read_mostly force_emulation_prefix = false;
 module_param(force_emulation_prefix, bool, S_IRUGO);
 
+bool __read_mostly pi_inject_timer = 0;
+module_param(pi_inject_timer, bool, S_IRUGO | S_IWUSR);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -7032,6 +7036,7 @@ int kvm_arch_init(void *opaque)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
 	kvm_lapic_init();
+	pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e08a128..10b26f4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -301,6 +301,8 @@ extern unsigned int min_timer_period_us;
 
 extern bool enable_vmware_backdoor;
 
+extern bool pi_inject_timer;
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
index 123ea07..ccb2808 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -14,6 +14,12 @@ EXPORT_SYMBOL_GPL(housekeeping_overridden);
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
2.7.4

