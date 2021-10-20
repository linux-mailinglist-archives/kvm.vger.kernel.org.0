Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54273434ACE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhJTMHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhJTMHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:07:43 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE4DC06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:29 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m14so2767134pfc.9
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=daEoZ9rYJqo1FQMfaT8aFEhZ3akBhgJvK+CaM2KA7dQ=;
        b=BuMErA/DuZ/0Gh1Uip5zDi4nhZy8bA5ENyyLMru7SulwHDqlPXRRu5eNimVwwXElC5
         lq6qqAFosuH8kSRKMypo3mBPVPfFxgsCNvZm3K0A3h4isPdM1oj9JNELuPiXi0g495MS
         1sTscOCX5xW9BG0Y+KVKAbxzfafNY9PQlv49k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=daEoZ9rYJqo1FQMfaT8aFEhZ3akBhgJvK+CaM2KA7dQ=;
        b=2cfXjJJLB7HASAEiAsNkhkw31PwvRxM8jBu7KWdu7uLPF6gGYUW6KszvJKpisiozHL
         9VPAdXGua+oqbUa2ANLXzwglpzvt6/5jnWwbM/RTdfXDpyivV8z31/D5BdWzV74x7bVK
         Hrs24G3sYBGAQWExdixqW4/zpwRHZkheLmphpgBRjmUe7LORYRzfIUu/yVBemqiGB8wc
         jP/rh/cFndynxaDY1Bub6Z4Uu+i3VD9VfUV+54hCK+Ls2CYLFILJJp9Z6yoDsu5aua6N
         s6gdoHtby4rjEIUKqgfzrkZJ2WzTNA/dn0Xh/oRjmhk7xhHnzdQem9nonC9GYAuUCoK2
         f/cQ==
X-Gm-Message-State: AOAM530z4kAljNVZ+YumCkq6lHJgys+mhzZZUwMYNTPPV8bg1+zNSX9p
        LBO+IwqqWX1JJTT4tRgHxup+sA==
X-Google-Smtp-Source: ABdhPJx/Rvr3qcPZwTYCDZsWLdqpM8lN7/5ngKAA29ZJgCF1EtMVqY2etsqhKYaFyuZhxkUHOUFKeQ==
X-Received: by 2002:a63:7888:: with SMTP id t130mr26794255pgc.279.1634731528796;
        Wed, 20 Oct 2021 05:05:28 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
        by smtp.gmail.com with UTF8SMTPSA id d137sm2573453pfd.72.2021.10.20.05.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:05:28 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
        vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Cc:     suleiman@google.com, senozhatsky@google.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Hikaru Nishida <hikalium@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [RFC PATCH v3 5/5] kvm/x86: virtual suspend time injection: Implement guest side
Date:   Wed, 20 Oct 2021 21:04:30 +0900
Message-Id: <20211020210348.RFC.v3.5.I99f7da15fd68fc098709ea4bcf74525e0883ea92@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add guest side implementation of KVM virtual suspend time injection.

How it works from guest's view:
- Guest will be paused without going through suspend/resume path in the
  guest kernel
- Before resuming the execution of the guest's vcpus, host will adjust
  the hardware clock (and kvm_clock) to the time before the suspend.
  - By this action, guest's CLOCK_MONOTONIC behaves as expected (stops
    during the host's suspension.)
- the guest will receive an IRQ from the guest that notifies about the
  suspend which was invisible to the guest. In the handler, the guest
  can adjust their CLOCK_BOOTTIME to reflect the suspension.
  - Now, CLOCK_BOOTTIME includes the time passed during the host's
    suspension.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Reused HYPERVISOR_CALLBACK_VECTOR IRQ instead of adding a new one.
- Extracted arch-independent parts.

 arch/x86/Kconfig                    | 13 ++++++++
 arch/x86/include/asm/idtentry.h     |  2 +-
 arch/x86/include/asm/kvmclock.h     |  9 ++++++
 arch/x86/kernel/kvm.c               | 14 ++++++---
 arch/x86/kernel/kvmclock.c          | 26 ++++++++++++++++
 arch/x86/mm/fault.c                 |  2 +-
 include/linux/timekeeper_internal.h |  5 ++++
 include/linux/timekeeping.h         |  4 +++
 kernel/time/timekeeping.c           | 46 +++++++++++++++++++++++++++++
 9 files changed, 115 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d9830e7e1060..1d4a529d1577 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -824,6 +824,19 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_VIRT_SUSPEND_TIMING_GUEST
+	bool "Guest support for virtual suspend time injection"
+	depends on KVM_GUEST
+	default n
+	help
+	 This option makes the host's suspension reflected on the guest's clocks.
+	 In other words, guest's CLOCK_MONOTONIC will stop and
+	 CLOCK_BOOTTIME keeps running during the host's suspension.
+	 This feature will only be effective when both guest and host support
+	 this feature. For the host side, see KVM_VIRT_SUSPEND_TIMING.
+
+	 If unsure, say N.
+
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
 	prompt "Disable host haltpoll when loading haltpoll driver"
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 1345088e9902..5e30f84ea07e 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -686,7 +686,7 @@ DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_xen_hvm_callback);
 #endif
 
 #ifdef CONFIG_KVM_GUEST
-DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_kvm_asyncpf_interrupt);
+DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_kvm_hv_callback);
 #endif
 
 #undef X86_TRAP_OTHER
diff --git a/arch/x86/include/asm/kvmclock.h b/arch/x86/include/asm/kvmclock.h
index 9add14edc24d..2bf1a5c92319 100644
--- a/arch/x86/include/asm/kvmclock.h
+++ b/arch/x86/include/asm/kvmclock.h
@@ -20,4 +20,13 @@ static inline struct pvclock_vsyscall_time_info *this_cpu_hvclock(void)
 	return this_cpu_read(hv_clock_per_cpu);
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+u64 kvm_get_suspend_time(void);
+#else
+static inline u64 kvm_get_suspend_time(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_X86_KVM_CLOCK_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b656456c3a94..3d84ef6d9df2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -40,6 +40,7 @@
 #include <asm/ptrace.h>
 #include <asm/reboot.h>
 #include <asm/svm.h>
+#include <asm/kvmclock.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -270,7 +271,7 @@ noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 	return true;
 }
 
-DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
+DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_hv_callback)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	u32 token;
@@ -286,6 +287,8 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
 		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
 	}
 
+	timekeeping_inject_virtual_suspend_time(kvm_get_suspend_time());
+
 	set_irq_regs(old_regs);
 }
 
@@ -710,10 +713,13 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
-	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf)
 		static_branch_enable(&kvm_async_pf_enabled);
-		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
-	}
+
+	if ((kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) ||
+	    kvm_para_has_feature(KVM_FEATURE_HOST_SUSPEND_TIME))
+		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR,
+				asm_sysvec_kvm_hv_callback);
 
 #ifdef CONFIG_SMP
 	if (pv_tlb_flush_supported()) {
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 73c74b961d0f..3e16d0ab79f3 100644
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
 static struct pvclock_vsyscall_time_info *hvclock_mem;
 DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
@@ -281,6 +288,17 @@ static int kvmclock_setup_percpu(unsigned int cpu)
 	return p ? 0 : -ENOMEM;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/**
+ * kvm_get_suspend_time - duration of host suspend.
+ * Return: Cumulative duration of host suspend in nanoseconds.
+ */
+u64 kvm_get_suspend_time(void)
+{
+	return suspend_time.suspend_time_ns;
+}
+#endif
+
 void __init kvmclock_init(void)
 {
 	u8 flags;
@@ -295,6 +313,14 @@ void __init kvmclock_init(void)
 		return;
 	}
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+	if (kvm_para_has_feature(KVM_FEATURE_HOST_SUSPEND_TIME)) {
+		/* Register the suspend time structure */
+		wrmsrl(MSR_KVM_HOST_SUSPEND_TIME,
+		       slow_virt_to_phys(&suspend_time) | KVM_MSR_ENABLED);
+	}
+#endif
+
 	if (cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "kvmclock:setup_percpu",
 			      kvmclock_setup_percpu, NULL) < 0) {
 		return;
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 84a2c8c4af73..f36f49585d5d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1509,7 +1509,7 @@ DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
 	 * memory is swapped out). Note, the corresponding "page ready" event
 	 * which is injected when the memory becomes available, is delivered via
 	 * an interrupt mechanism and not a #PF exception
-	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_asyncpf_interrupt()).
+	 * (see arch/x86/kernel/kvm.c: sysvec_kvm_hv_callback()).
 	 *
 	 * We are relying on the interrupted context being sane (valid RSP,
 	 * relevant locks not held, etc.), which is fine as long as the
diff --git a/include/linux/timekeeper_internal.h b/include/linux/timekeeper_internal.h
index 84ff2844df2a..0d5b29122d40 100644
--- a/include/linux/timekeeper_internal.h
+++ b/include/linux/timekeeper_internal.h
@@ -68,6 +68,8 @@ struct tk_read_base {
  *			shifted nano seconds.
  * @ntp_error_shift:	Shift conversion between clock shifted nano seconds and
  *			ntp shifted nano seconds.
+ * @kvm_suspend_time:	The cumulative duration of suspend injected through KVM
+ *			in nano seconds.
  * @last_warning:	Warning ratelimiter (DEBUG_TIMEKEEPING)
  * @underflow_seen:	Underflow warning flag (DEBUG_TIMEKEEPING)
  * @overflow_seen:	Overflow warning flag (DEBUG_TIMEKEEPING)
@@ -124,6 +126,9 @@ struct timekeeper {
 	u32			ntp_err_mult;
 	/* Flag used to avoid updating NTP twice with same second */
 	u32			skip_second_overflow;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+	u64			kvm_suspend_time;
+#endif
 #ifdef CONFIG_DEBUG_TIMEKEEPING
 	long			last_warning;
 	/*
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index f7be69c81dab..a2228300c3f9 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -310,4 +310,8 @@ void read_persistent_wall_and_boot_offset(struct timespec64 *wall_clock,
 extern int update_persistent_clock64(struct timespec64 now);
 #endif
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+void timekeeping_inject_virtual_suspend_time(u64 total_duration_ns);
+#endif
+
 #endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e77580d9f8c1..5f474cde0bae 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2133,6 +2133,52 @@ static u64 logarithmic_accumulation(struct timekeeper *tk, u64 offset,
 	return offset;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/**
+ * timekeeping_inject_virtual_suspend_time - Inject virtual suspend time
+ * when requested by the kvm host.
+ * @total_duration_ns:	Total suspend time to be injected in nanoseconds.
+ */
+void timekeeping_inject_virtual_suspend_time(u64 total_duration_ns)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	if (total_duration_ns > tk->kvm_suspend_time) {
+		/*
+		 * Do injection only if the time is not injected yet.
+		 * total_duration_ns and tk->kvm_suspend_time values are
+		 * cumulative, so the delta between them will be an amount
+		 * of adjustments. For example, if the host suspends 2 times
+		 * during the guest is running and each suspend is 5 seconds,
+		 * total_duration_ns will be 5 seconds at the first injection
+		 * and tk->kvm_suspend_time was initialized to zero so the
+		 * adjustment injected here will be 5 - 0 = 5 seconds and
+		 * tk->kvm_suspend_time will be updated to 5 seconds.
+		 * On the second injection after the second resume,
+		 * total_duration_ns will be 10 seconds and
+		 * tk->kvm_suspend_time will be 5 seconds so 10 - 5 = 5 seconds
+		 * of the suspend time will be injected again.
+		 */
+		struct timespec64 delta =
+			ns_to_timespec64(total_duration_ns -
+					 tk->kvm_suspend_time);
+		tk->kvm_suspend_time = total_duration_ns;
+
+		write_seqcount_begin(&tk_core.seq);
+		timekeeping_forward_now(tk);
+		__timekeeping_inject_sleeptime(tk, &delta);
+		timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+		write_seqcount_end(&tk_core.seq);
+
+		/* signal hrtimers about time change */
+		clock_was_set_delayed();
+	}
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+}
+#endif
+
 /*
  * timekeeping_advance - Updates the timekeeper to the current time and
  * current NTP tick length
-- 
2.33.0.1079.g6e70778dc9-goog

