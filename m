Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEAD3E281B
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbhHFKIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 06:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244866AbhHFKIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 06:08:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DF1C061798
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 03:08:15 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so22059665pjs.0
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 03:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5dkFSAbBEOLClHxOjqtsNkD++Mf5LpTY0qaM47dwAA=;
        b=ELl5wgcTQHoVhEnSceUmsGECDJ3YObRHs4J6XQdnbDr4IGtLrXvRZaZjKKizLhG9CQ
         p7GfW5K1patbQRvWnR7aXhw3IxA4+LDu+5GMs/tQLoF4VoeefEiP2J5vT5FlXuZ5RzlA
         UNLdjtnW9v6yCIvI/DRzhMx9qGQygoq5ZFBdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5dkFSAbBEOLClHxOjqtsNkD++Mf5LpTY0qaM47dwAA=;
        b=HWuccQzDonp3JmxK6zNTEsRR2auJVFQYdzLcVhpOOyBI6dIASJTBuRDk1riWlngGXb
         AnPc4O0BdmCnljfQcuJaE0whSDrrqreSCj9HHiFR84oqxh0JGCZN4WwHKvUhKx91+5qq
         lIy5jNIqWyiLA1xpV5KQrmXL5QP3DmFfj01iQWLUu5tAq4V6B4/Pu9tqc9WiFQxDTIsC
         Bj+8qqdR8T3F4L4XiPrgIq/88LcVru4Ozlp/+Su+nvAvTPup/x/k6OulgH8PpBNZoKo+
         nRNar3pFv0CT80JRZsWsI/CKTnB6r1EtJhEVqskmtO81k5HkZG5Lo3t+0xBOyW2DqhML
         /bSg==
X-Gm-Message-State: AOAM533G5DHJQFkeB+pM1/ZF2Ek0rV3Y5ecgBUXhli4d/MVBtFvlHC9D
        1L2Dg8g5wgqilUxq31R1k/3c+w==
X-Google-Smtp-Source: ABdhPJxZjbU3mkj2Xh2n8xpmyiYhU3yGXlt/V3hXH2qg+/EUU/BxKWiC04vUQjdYuYf8GYq+97DNbg==
X-Received: by 2002:aa7:85cf:0:b029:3bc:9087:a94f with SMTP id z15-20020aa785cf0000b02903bc9087a94fmr3965343pfn.78.1628244495150;
        Fri, 06 Aug 2021 03:08:15 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:b731:9e91:71e2:65e7])
        by smtp.gmail.com with UTF8SMTPSA id y13sm12148216pjn.34.2021.08.06.03.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:08:14 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Juergen Gross <jgross@suse.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Mike Travis <mike.travis@hpe.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [v2 PATCH 4/4] x86/kvm: Add guest side support for virtual suspend time injection
Date:   Fri,  6 Aug 2021 19:07:10 +0900
Message-Id: <20210806190607.v2.4.I2cbcd43256eacc3c92274adff6d0458b6a9c15ee@changeid>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210806100710.2425336-1-hikalium@chromium.org>
References: <20210806100710.2425336-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements virtual suspend time injection support for kvm
guests. If this functionality is enabled and the host supports
KVM_FEATURE_HOST_SUSPEND_TIME,
the guest will register struct kvm_host_suspend_time through MSR to
get how much time the guest spend during the host's suspension.
Host will notify the update on the structure (which happens if the host
went into suspension while the guest was running) through the irq and
the irq will trigger the adjustment of CLOCK_BOOTTIME inside a guest.

Before this patch, there was no way to adjust the CLOCK_BOOTTIME without
actually suspending the kernel. However, some guest applications rely on
the fact that there will be some difference between CLOCK_BOOTTIME and
CLOCK_MONOTONIC after the suspention of the execution and they will be
broken if we just pausing the guest instead of actually suspending them.
Pausing the guest kernels is one solution to solve the problem, but
if we could adjust the clocks without actually suspending them, we can
reduce the overhead of guest's suspend/resume cycles on every host's
suspensions. So this change will be useful for the devices which
experience suspend/resume frequently.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/Kconfig                    | 13 ++++++++++
 arch/x86/include/asm/idtentry.h     |  4 +++
 arch/x86/include/asm/kvm_para.h     |  9 +++++++
 arch/x86/kernel/kvmclock.c          | 40 +++++++++++++++++++++++++++++
 include/linux/timekeeper_internal.h |  4 +++
 kernel/time/timekeeping.c           | 33 ++++++++++++++++++++++++
 6 files changed, 103 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 45463c65ea0a..760fe7f04170 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -822,6 +822,19 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_VIRT_SUSPEND_TIMING_GUEST
+	bool "Virtual suspend time injection (guest side)"
+	depends on KVM_GUEST
+	default n
+	help
+	 This option makes the host's suspension reflected on the guest's clocks.
+	 In other words, guest's CLOCK_MONOTONIC will stop and
+	 CLOCK_BOOTTIME keeps running during the host's suspension.
+	 This feature will only be effective when both guest and host enable
+	 this option.
+
+	 If unsure, say N.
+
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
 	prompt "Disable host haltpoll when loading haltpoll driver"
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 1345088e9902..38f37c2a6063 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -671,6 +671,10 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
 #endif
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+DECLARE_IDTENTRY_SYSVEC(VIRT_SUSPEND_TIMING_VECTOR, sysvec_virtual_suspend_time);
+#endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 69299878b200..094023687c8b 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -16,6 +16,15 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 }
 #endif /* CONFIG_KVM_GUEST */
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+u64 kvm_get_suspend_time(void);
+#else
+static inline u64 kvm_get_suspend_time(void)
+{
+	return 0;
+}
+#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST */
+
 #define KVM_HYPERCALL \
         ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ad273e5861c1..1c92b54b1bce 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -16,11 +16,15 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/set_memory.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include <asm/hypervisor.h>
 #include <asm/mem_encrypt.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
+#include <asm/desc.h>
+#include <asm/idtentry.h>
 
 static int kvmclock __initdata = 1;
 static int kvmclock_vsyscall __initdata = 1;
@@ -48,6 +52,9 @@ early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+static struct kvm_suspend_time suspend_time __bss_decrypted;
+#endif
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
 static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
@@ -163,6 +170,18 @@ static int kvm_cs_enable(struct clocksource *cs)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/*
+ * kvm_get_suspend_time - This function returns total time passed during
+ * the host was in a suspend state while this guest was running.
+ * (Not a duration of the last host suspension but cumulative time.)
+ */
+u64 kvm_get_suspend_time(void)
+{
+	return suspend_time.suspend_time_ns;
+}
+#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST */
+
 struct clocksource kvm_clock = {
 	.name	= "kvm-clock",
 	.read	= kvm_clock_get_cycles,
@@ -290,6 +309,18 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 	return p ? 0 : -ENOMEM;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+void timekeeping_inject_virtual_suspend_time(void);
+DEFINE_IDTENTRY_SYSVEC(sysvec_virtual_suspend_time)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	timekeeping_inject_virtual_suspend_time();
+
+	set_irq_regs(old_regs);
+}
+#endif
+
 void __init kvmclock_init(void)
 {
 	u8 flags;
@@ -304,6 +335,15 @@ void __init kvmclock_init(void)
 		return;
 	}
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+	if (kvm_para_has_feature(KVM_FEATURE_HOST_SUSPEND_TIME)) {
+		alloc_intr_gate(VIRT_SUSPEND_TIMING_VECTOR, asm_sysvec_virtual_suspend_time);
+		/* Register the suspend time structure */
+		wrmsrl(MSR_KVM_HOST_SUSPEND_TIME,
+		       slow_virt_to_phys(&suspend_time) | KVM_MSR_ENABLED);
+	}
+#endif
+
 	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
 			      kvmclock_setup_percpu, NULL) < 0) {
 		return;
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 84ff2844df2a..a5fd515f0a9d 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -124,6 +124,10 @@ struct timekeeper {
 	u32			ntp_err_mult;
 	/* Flag used to avoid updating NTP twice with same second */
 	u32			skip_second_overflow;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+	/* suspend_time_injected keeps the duration injected through kvm */
+	u64			suspend_time_injected;
+#endif
 #ifdef CONFIG_DEBUG_TIMEKEEPING
 	long			last_warning;
 	/*
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3ac3fb479981..424c61d38646 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2125,6 +2125,39 @@ static u64 logarithmic_accumulation(struct timekeeper *tk, u64 offset,
 	return offset;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/*
+ * timekeeping_inject_virtual_suspend_time - Inject virtual suspend time
+ * when requested by the kvm host.
+ * This function should be called under irq context.
+ */
+void timekeeping_inject_virtual_suspend_time(void)
+{
+	/*
+	 * Only updates shadow_timekeeper so the change will be reflected
+	 * on the next call of timekeeping_advance().
+	 */
+	struct timekeeper *tk = &shadow_timekeeper;
+	unsigned long flags;
+	struct timespec64 delta;
+	u64 suspend_time;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	suspend_time = kvm_get_suspend_time();
+	if (suspend_time > tk->suspend_time_injected) {
+		/*
+		 * Do injection only if the time is not injected yet.
+		 * suspend_time and tk->suspend_time_injected values are
+		 * cummrative, so take a diff and inject the duration.
+		 */
+		delta = ns_to_timespec64(suspend_time - tk->suspend_time_injected);
+		__timekeeping_inject_sleeptime(tk, &delta);
+		tk->suspend_time_injected = suspend_time;
+	}
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+}
+#endif
+
 /*
  * timekeeping_advance - Updates the timekeeper to the current time and
  * current NTP tick length
-- 
2.32.0.605.g8dce9f2422-goog

