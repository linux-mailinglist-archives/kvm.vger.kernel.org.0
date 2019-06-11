Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756383CAF5
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbfFKMRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:17:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43766 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfFKMRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:17:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so6875122pgv.10;
        Tue, 11 Jun 2019 05:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tI3hDDTqnqdirzeRUyGFwfCtxp+U+fG86cEeE/MH7Ag=;
        b=NFLv/C6919OIXOKCc4m3w9M86HhoIyX2sr9xKoBaR//aTJ+4zkw6nS5GkYickv4tPW
         X2H/nRabt4pGXQ8CSNeN2rr6pQ0cZ31kZv+xUEus5a9nK7hMaiN5/kKFjkYgxagfJ/4x
         yTzy0wjngFbgevbzAe4pEbgh6gjm77MZn4Iv2pn4HkChi3Uz/xxYLJdnUGG9aCyAer+Q
         Up4GNmGqQGit9KM2ad1XlXWQyHlso1d4ReBznJ9xh1AuQQ9+Xg2nCus/t9xj8EdSOcwV
         NhkyWB47gDkk4A51bbVqkqSs6v4ne/PXlVhEghsMxRIIJpNwcwlSBTy1DY8MqOPDXzQB
         qrGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tI3hDDTqnqdirzeRUyGFwfCtxp+U+fG86cEeE/MH7Ag=;
        b=dQpYYSXVWvFAje+HRc8ESbdpVTFDuYnJGY0OceZJAAf+hnI25KnaZlKbWVimIUJ8C5
         6mS7LSiO5cgXR0wPaM29ryjLbdQrgEIWbWLBkDljyBRyXPaEYufAjIvXmg1frql1Fclu
         0umZCPqjYawiwIAHAWILK8/BNdrNRgNVnkPeQJ3gqCsbvvMtZ9lmKTNsCPiPRZOa4vr+
         AxxYCsZZ4BOWge0m2eG9jn19qyQpShvgqWzFnF/cnljhqRceAcvehNnV6DaefOY7kMha
         /MdI1Nyrp5ijE7vHB7PYX94mA3bteVAzaJ8loSX6En00Nd7l6L4H/gTmDU9xWD9MHwZY
         WUeg==
X-Gm-Message-State: APjAAAU5Nd4Vfs7fJlXGWL3yd497/hTMxnSnXmeX6YTHGHa+MEKuoGLY
        FPFcL+0/fQQ8kyk+EjntCmRqL2SM
X-Google-Smtp-Source: APXvYqySmdFBdQB2S20bpRa4V8kezNXzmkB2zhLDpGu7zRkf1zM/QLQcdt5iL7fwmK5UIYtwM+yNKg==
X-Received: by 2002:a63:d658:: with SMTP id d24mr20326915pgj.191.1560255441515;
        Tue, 11 Jun 2019 05:17:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v4sm19649478pff.45.2019.06.11.05.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:17:21 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 1/4] KVM: LAPIC: Make lapic timer unpinned when timer is injected by pi
Date:   Tue, 11 Jun 2019 20:17:06 +0800
Message-Id: <1560255429-7105-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
References: <1560255429-7105-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Make lapic timer unpinned when timer is injected by posted-interrupt,
the emulated timer can be offload to the housekeeping cpus.

The host admin should fine tuned, e.g. dedicated instances scenario 
w/ nohz_full cover the pCPUs which vCPUs resident, several pCPUs 
surplus for housekeeping, disable mwait/hlt/pause vmexits to occupy 
the pCPUs, fortunately preemption timer is disabled after mwait is 
exposed to guest which makes emulated timer offload can be possible. 

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c            | 20 ++++++++++++++++----
 arch/x86/kvm/lapic.h            |  1 +
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              |  5 +++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++++
 7 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..e57eeba 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -127,6 +127,12 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
+inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
+{
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+}
+EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer_enabled);
+
 static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 		u32 dest_id, struct kvm_lapic ***cluster, u16 *mask) {
 	switch (map->mode) {
@@ -1581,7 +1587,9 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 	    likely(ns > apic->lapic_timer.timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
-		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start(&ktimer->timer, expire,
+			posted_interrupt_inject_timer_enabled(vcpu) ?
+			HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 	} else
 		apic_timer_expired(apic);
 
@@ -1683,7 +1691,8 @@ static void start_sw_period(struct kvm_lapic *apic)
 
 	hrtimer_start(&apic->lapic_timer.timer,
 		apic->lapic_timer.target_expiration,
-		HRTIMER_MODE_ABS_PINNED);
+		posted_interrupt_inject_timer_enabled(apic->vcpu) ?
+		HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 }
 
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
@@ -2320,7 +2329,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	apic->vcpu = vcpu;
 
 	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_ABS_PINNED);
+		posted_interrupt_inject_timer_enabled(vcpu) ?
+		HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 	apic->lapic_timer.timer.function = apic_timer_fn;
 	if (timer_advance_ns == -1) {
 		apic->lapic_timer.timer_advance_ns = 1000;
@@ -2509,7 +2519,9 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
 
 	timer = &vcpu->arch.apic->lapic_timer.timer;
 	if (hrtimer_cancel(timer))
-		hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+		hrtimer_start_expires(timer,
+			posted_interrupt_inject_timer_enabled(vcpu) ?
+			HRTIMER_MODE_ABS : HRTIMER_MODE_ABS_PINNED);
 }
 
 /*
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index f974a3d..7b85a7c 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -231,6 +231,7 @@ void kvm_lapic_switch_to_hv_timer(struct kvm_vcpu *vcpu);
 void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu);
 bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu);
 void kvm_lapic_restart_hv_timer(struct kvm_vcpu *vcpu);
+inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu);
 
 static inline enum lapic_mode kvm_apic_mode(u64 apic_base)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da24f18..6d3c0b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7042,7 +7042,8 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 	u64 tscl, guest_tscl, delta_tsc, lapic_timer_advance_cycles;
 	struct kvm_timer *ktimer = &vcpu->arch.apic->lapic_timer;
 
-	if (kvm_mwait_in_guest(vcpu->kvm))
+	if (kvm_mwait_in_guest(vcpu->kvm) ||
+		posted_interrupt_inject_timer_enabled(vcpu))
 		return -EOPNOTSUPP;
 
 	vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6200d5a..35c4884 100644
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
@@ -7030,6 +7034,7 @@ int kvm_arch_init(void *opaque)
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 
 	kvm_lapic_init();
+	pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 275b3b6..aa539d6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -296,6 +296,8 @@ extern unsigned int min_timer_period_us;
 
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

