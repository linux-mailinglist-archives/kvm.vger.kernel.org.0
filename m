Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE836BA4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 07:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfFFFbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 01:31:36 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44101 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfFFFbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 01:31:35 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so438825pll.11;
        Wed, 05 Jun 2019 22:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IT1IMW2tnp8hWUTESHyDf/ZzNbL50G7rSj8GTtdEWdQ=;
        b=va3VZGjxtyXUVZPKHZ7UpDdRSRqYG5elT54E3bP4lBUZhnmm1XkJi9R9Xj7u6mtjUG
         AcpYPzf4JRCUL3bWHV9EHzCs8r8txITdoK/K0hCQ3Xo9wj6daf7CvAXIwCtPteht4RXc
         FquDFM4K6s3RFWxgXj/k2OeGxSFBsR1bTnqq+Hc3/23MOYC2Ri6Dc3gb4Q9K0L7gJTJB
         BLPIT1Zp7ZBY5eYOHFdRXDmNCFevjcOHXCrQ9PX/XXUicUbj7hB+J0XNJHeVrrvxItLE
         nkbf2Jkkie+0kydL0j6IA9jOMq1wo6XJpEAzWgZ1TsF7ZVn8zmWm8YMLN6A/no+9KLC7
         LkKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IT1IMW2tnp8hWUTESHyDf/ZzNbL50G7rSj8GTtdEWdQ=;
        b=E7lp6eAlLzUkNTsavPSxziqXRKYvkxtjkPSbGwGoH6aYH3yqSNhfgb29Hj9IxrKJu+
         wUpQYRM6UblJrQUvOAgGN68YdH8G3e0SXaT7D1P8wYqXcKq3Hb5eOpI7snJMeMXNgKwM
         5hrEWpuxjWz3ypgxOCHHzLNJodDkSd6AJ3KVLPZlQn0+s/Tg3vQ53rfhaafYGZXQTlGb
         oq/qiylFVwSKpdARdzShloUMzlehyFMIPfuUIN2GSLdfJOGCekiRa05iAluWPEtoijio
         gf6J9wAxr+QJRc0L7ilpozzei2DqQkgzoaNzECha9C9wybNBSFI59D0unUHFevMzQCmW
         szrg==
X-Gm-Message-State: APjAAAVfv5AAlib1QUi5+7JlyRnDYLqbejC5O/HS4B8BS072ygCrQ1AH
        7r4/XmtYVeML3ETdGvMVY3/VHzBF
X-Google-Smtp-Source: APXvYqzVOwrrWodZ6942t7gA2+PpBekdyMJFrUST5uyxLlw+GlTDr9p198h//HsJ195+OasbJYaZ7g==
X-Received: by 2002:a17:902:5c6:: with SMTP id f64mr47361260plf.208.1559799094339;
        Wed, 05 Jun 2019 22:31:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f11sm721547pjg.1.2019.06.05.22.31.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 22:31:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 1/3] KVM: LAPIC: Make lapic timer unpinned when timer is injected by posted-interrupt
Date:   Thu,  6 Jun 2019 13:31:24 +0800
Message-Id: <1559799086-13912-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
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
 arch/x86/kvm/x86.c              |  5 +++++
 arch/x86/kvm/x86.h              |  2 ++
 include/linux/sched/isolation.h |  2 ++
 kernel/sched/isolation.c        |  6 ++++++
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fcf42a3..09b7387 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -127,6 +127,12 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 	return apic->vcpu->vcpu_id;
 }
 
+static inline bool posted_interrupt_inject_timer_enabled(struct kvm_vcpu *vcpu)
+{
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		kvm_mwait_in_guest(vcpu->kvm);
+}
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6200d5a..2ef2394 100644
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

