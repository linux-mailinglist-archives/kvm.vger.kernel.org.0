Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E3A36B040
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhDZJJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhDZJJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB6AC061763
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:47 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so2681213pjz.0
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FyptFyp3SyGnFZnAfWqIco1W5xYNar4z+brwR/7K1Qs=;
        b=Dwj2TQhSHanr+DcnkGMAn4cCQdrEqWE2GA5gf5cA/g0o5BfK70YUus85kYUeUaMSW9
         8VawpLzkbE0lkJdot8kmkSIMyW5JtDR7rzvl7kkygWLyXwzey3gfz47HFFW51aql0GwY
         G8gek6QXOKddMzftArLWvsRYJdrtIUodSyLvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FyptFyp3SyGnFZnAfWqIco1W5xYNar4z+brwR/7K1Qs=;
        b=WCMh9BwuaS3uQbj9N/Z52SWSSWoifM9hhFEGD4YGEdomcIxmzZ0+B+oYH8GMH9VDUm
         KZmdMYwdPBlEcTlzGHIO3Gfi2c4TIqt3QwO4c381NJxl9QX9MVsLDRaIoFRCrOrH207g
         GpqQMbS2DblpMGOTDoWbg2nPEjQRSOCHdPebiTPq2itwogx3yoE99zNafcHZvgS0LCef
         ZTEmrVDZ3mWutyu/fFUSurUKt1LZs4lHz2WsOFwzPKmkc+3FKlU/7SddHu2KHJpg7EWp
         w7zaa0qtWzn5h/iSezN0yoQ3nqeVD9ClICbCD/zGbvZjMjfuxep0QJOG4jd8V5oDPN8e
         46Cw==
X-Gm-Message-State: AOAM531+nKaXsnAkEYwQ5wl/b1stQ8TM8zpvpW9776OX5EZVVTtYMAzI
        sWUkOYR8dsoLY+DXPFs2iNV+sOs1VUB5LQ==
X-Google-Smtp-Source: ABdhPJxZMCEPxK7rD0Opc39txVircSohOFkFpiPkj5pJ5scEvSMNlFtubplHz81Ev36IJZ8c3+uMaw==
X-Received: by 2002:a17:90a:e643:: with SMTP id ep3mr9330612pjb.194.1619428126486;
        Mon, 26 Apr 2021 02:08:46 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id i11sm10716676pfo.183.2021.04.26.02.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:46 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH 6/6] x86/kvm: Add a guest side support for virtual suspend time injection
Date:   Mon, 26 Apr 2021 18:06:45 +0900
Message-Id: <20210426090644.2218834-7-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements virtual suspend time injection support for kvm
guests. If this functionality is enabled and the host supports
KVM_FEATURE_HOST_SUSPEND_TIME,
the guest will register struct kvm_host_suspend_time through MSR to
monitor how much time we spend during the host's suspension. If the
duration is increased, the guest will advance CLOCK_BOOTTIME to match
with the host's suspension.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>

---

 arch/x86/include/asm/kvm_para.h     |  9 +++++++++
 arch/x86/kernel/kvmclock.c          | 25 +++++++++++++++++++++++++
 include/linux/timekeeper_internal.h |  4 ++++
 kernel/time/timekeeping.c           | 27 +++++++++++++++++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 338119852512..e552efa931a8 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -18,6 +18,15 @@ static inline bool kvm_check_and_clear_guest_paused(void)
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
index 1fc0962c89c0..630460beb05a 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -49,6 +49,9 @@ early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
 
 static struct pvclock_vsyscall_time_info
 			hv_clock_boot[HVC_BOOT_ARRAY_SIZE] __bss_decrypted __aligned(PAGE_SIZE);
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+static struct kvm_host_suspend_time suspend_time __bss_decrypted;
+#endif
 static struct pvclock_wall_clock wall_clock __bss_decrypted;
 static DEFINE_PER_CPU(struct pvclock_vsyscall_time_info *, hv_clock_per_cpu);
 static struct pvclock_vsyscall_time_info *hvclock_mem;
@@ -164,6 +167,20 @@ static int kvm_cs_enable(struct clocksource *cs)
 	return 0;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/*
+ * kvm_get_suspend_time_and_clear_request - This function
+ * checks how much suspend time is injected by the host.
+ * A returned value is a total time passed during the guest in a suspend
+ * state while this guest is running. (Not a duration of the last host
+ * suspend.)
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
@@ -324,6 +341,14 @@ void __init kvmclock_init(void)
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
index 342a032ad552..6b89e0d42596 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2114,6 +2114,29 @@ static u64 logarithmic_accumulation(struct timekeeper *tk, u64 offset,
 	return offset;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+/*
+ * timekeeping_inject_suspend_time - Inject virtual suspend time
+ * if it is requested by kvm host.
+ * This function should be called under holding timekeeper_lock and
+ * only from timekeeping_advance().
+ */
+static void timekeeping_inject_virtual_suspend_time(struct timekeeper *tk)
+{
+	struct timespec64 delta;
+	u64 suspend_time;
+
+	suspend_time = kvm_get_suspend_time();
+	if (suspend_time <= tk->suspend_time_injected) {
+		/* Sufficient amount of suspend time is already injected. */
+		return;
+	}
+	delta = ns_to_timespec64(suspend_time - tk->suspend_time_injected);
+	__timekeeping_inject_sleeptime(tk, &delta);
+	tk->suspend_time_injected = suspend_time;
+}
+#endif
+
 /*
  * timekeeping_advance - Updates the timekeeper to the current time and
  * current NTP tick length
@@ -2143,6 +2166,10 @@ static void timekeeping_advance(enum timekeeping_adv_mode mode)
 	/* Do some additional sanity checking */
 	timekeeping_check_update(tk, offset);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING_GUEST
+	timekeeping_inject_virtual_suspend_time(tk);
+#endif
+
 	/*
 	 * With NO_HZ we may have to accumulate many cycle_intervals
 	 * (think "ticks") worth of time at once. To do this efficiently,
-- 
2.31.1.498.g6c1eba8ee3d-goog

