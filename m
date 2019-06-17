Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D174808C
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 13:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbfFQLZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 07:25:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41795 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbfFQLY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 07:24:57 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so5521799pff.8;
        Mon, 17 Jun 2019 04:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QPKDLIKuUo/Cxx8DOw5W6PJedXZazujOq7golYp3Fks=;
        b=tA0qRYkaZfjl4M9Xgshuurt4J9LYn2/8l/NM52Z03SIoXEsiIrURXtBgs+kheIN8Cx
         5sOevDE7GhaIvoVIOM9Tez6vb4fhxJMr4iSX+8kOcx/FlA7Poooz9tQx0WivVgZFTEC9
         D2GGhdq5ybPHYWN1BJWMuWq87HLzaT9kOxXOLVAvxN9cXhWlkNrJ2gp55Et37NW7WMPi
         0q/rjcGcXX49F2BLbtOr4RyS79XZsb1VIgFYw1hhR68ZzkyZa2vEhqHta6R9Nl4gnG+q
         GXlpJ0GeyrV1bgny6+gehH/7N4aVOYkA6alG6ZDBWpgqM2pN7gV/oCgvVDCc1mGZfP9T
         uOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QPKDLIKuUo/Cxx8DOw5W6PJedXZazujOq7golYp3Fks=;
        b=S84YQXsYPvn6F88veZUT5zjX3c4TEEtuyD5DZl3cKyt0GwGtR58wBKuBObQbKMQW+f
         xiitDbqMBM5A+p3L/oB4fIHCQHigxOpzMLRhFMHeViZYXvZcatcezomXZQvQ2B0M6eXA
         5wqXwY5sMpYMNswW74N38+SF+o8mjHTHvPvM3JaZc71GLe53jM1TqllhGD/Y/y6QLVPY
         AjAlTcsWof/TfNnBbUyDjp/hr84CNuAihf2h7fdz5Q/DMIVAYxwqJsrqkNavP4YTklQr
         DxAbzl433bdoQYJJE/kLO5s1dfpjDxPmCiz1i9pmE24W0bgpFP0hIUgskTUKZZvtFYXm
         Avxw==
X-Gm-Message-State: APjAAAWW9dREwl849Cuz1YC2a4GSz7prjjasAIgN112ANBUzJktIeUjX
        EDfzYiDhHnPGRCW2jtNz0cPjGE4f
X-Google-Smtp-Source: APXvYqyNxOvCEi4TDxlPotolIMkkx39ImcTurnQ3g624Ypaz0SN7cfn5kx9oHvGJIoKPS/Gb88qAMg==
X-Received: by 2002:a63:d4c:: with SMTP id 12mr16011589pgn.30.1560770696860;
        Mon, 17 Jun 2019 04:24:56 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id d4sm12535751pfc.149.2019.06.17.04.24.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 04:24:56 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 2/5] KVM: LAPIC: inject lapic timer interrupt by posted interrupt
Date:   Mon, 17 Jun 2019 19:24:44 +0800
Message-Id: <1560770687-23227-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/lapic.c            | 33 ++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              |  5 +++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++++
 7 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 87ecb56..9ceeee5 100644
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
@@ -1441,6 +1461,11 @@ static void apic_timer_expired(struct kvm_lapic *apic)
 	if (atomic_read(&apic->lapic_timer.pending))
 		return;
 
+	if (posted_interrupt_inject_timer(apic->vcpu)) {
+		kvm_apic_inject_pending_timer_irqs(apic);
+		return;
+	}
+
 	atomic_inc(&apic->lapic_timer.pending);
 	kvm_set_pending_timer(vcpu);
 
@@ -2373,13 +2398,7 @@ void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu)
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
index 3674717..e41936b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -236,6 +236,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8fbea03..f45c51e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7059,7 +7059,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
 	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
-	if (kvm_mwait_in_guest(vcpu->kvm))
+	if (kvm_mwait_in_guest(vcpu->kvm) ||
+		posted_interrupt_inject_timer(vcpu))
 		return -EOPNOTSUPP;
 
 	vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9450a16..dae18f7 100644
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

