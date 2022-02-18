Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF14BC284
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 23:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240104AbiBRWTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 17:19:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbiBRWTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 17:19:20 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14F220181
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:19:01 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o5-20020a17090a4e8500b001b9c3948dd2so9167201pjh.3
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 14:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FQ6TqW9LDWiaBMsImTySrVeuKimH2Sgd7xTvRW+ZiUc=;
        b=f+y9glqe2GAIqQosesj7J0tJoAPFI66pL2Fq6iAyoWFG+hGBBOVSm9JpzIIdjWgfvZ
         Bj76rl5VwdfG/RacKfjjRW8lrraQrKuL0B4Zk3PpPJRON/jzCZQZbmSb9WdeK39X+Cxq
         E7j9M49Ex1F0u01suk6kHPBRap4TnB43qXp8RTVeXSXnmvVhP0OjrPDshcizFlDYpwaC
         hiG1Jp0WJeoFPGHHqBgSSD7nJ4f+xSRNdSthuMUZKWx13UjUR8Lmwsxa+kjtagZb3TyT
         wlnfSgq0ZLVCTsM3u/D8AT++bKL6t4GShyS+m6wlCFMcTxWAzrwrt2UovI/JxzrCeOVM
         o6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FQ6TqW9LDWiaBMsImTySrVeuKimH2Sgd7xTvRW+ZiUc=;
        b=DoYaaecsaIjgYNNzCYTyKpXHMXVk8+RluahSROfmzXOVPJkDY9wkRGpFowlHUM/vUP
         2OMSnNaY3L7MqeE+VrR+MUNFhux13QDbARdL5mHucKZt+l7O5MB0zfhJOTHp0fmh0gNl
         EbkZx1Gkn3YboSFVSQ/iwQBPuEYMHWkpR8dQxPsBuYCBmoum3+lNL8kffY6+G3GpE0pP
         9slBJMJGzUei3PiGpp02K7La2XPHFdME/Sg8NqTm1XTzQV1Auqx0S6kPlSpQkpfBWM7a
         SHD56l0adMsOqLGzRj3sU1YWuBSHNwlDoQTRKYnheTJnaJK1PQaHnAopHKtTFMa/qLIR
         E2Rw==
X-Gm-Message-State: AOAM530HIu+3rmPtHMJwKYP8PS0JV4bMi3/M49Wr5K5PsmykGJMHPNDw
        PKAdFNRvjra4dMPBAe14grcTdvfUyw==
X-Google-Smtp-Source: ABdhPJxXaT7tVhtYK1FZb5tv9Lq3jevXAOGZULk6rBw92Jnl7ZzKpGWK9GL+NdUyq3JMtEI1+0q2coCOIA==
X-Received: from swine1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:42e])
 (user=swine job=sendgmr) by 2002:a05:6a00:1709:b0:4c8:42df:c87c with SMTP id
 h9-20020a056a00170900b004c842dfc87cmr9607942pfc.5.1645222741107; Fri, 18 Feb
 2022 14:19:01 -0800 (PST)
Date:   Fri, 18 Feb 2022 14:18:20 -0800
In-Reply-To: <20220218221820.950118-1-swine@google.com>
Message-Id: <20220218221820.950118-2-swine@google.com>
Mime-Version: 1.0
References: <20220218221820.950118-1-swine@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH 2/2] timers: retpoline mitigation for time funcs
From:   Pete Swain <swine@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Johan Hovold <johan@kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Pete Swain <swine@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds indirect call exports for clock reads from tsc, apic,
hrtimer, via clock-event, timekeeper & posix interfaces.

Signed-off-by: Pete Swain <swine@google.com>
---
 arch/x86/kernel/apic/apic.c    |  8 +++++---
 arch/x86/kernel/tsc.c          |  3 ++-
 include/linux/hrtimer.h        | 19 ++++++++++++++++---
 kernel/time/clockevents.c      |  9 ++++++---
 kernel/time/hrtimer.c          |  3 ++-
 kernel/time/posix-cpu-timers.c |  4 ++--
 kernel/time/posix-timers.c     |  3 ++-
 kernel/time/timekeeping.c      |  2 +-
 8 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..523a569dd35e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -463,15 +463,17 @@ EXPORT_SYMBOL_GPL(setup_APIC_eilvt);
 /*
  * Program the next event, relative to now
  */
-static int lapic_next_event(unsigned long delta,
+INDIRECT_CALLABLE_SCOPE
+int lapic_next_event(unsigned long delta,
 			    struct clock_event_device *evt)
 {
 	apic_write(APIC_TMICT, delta);
 	return 0;
 }
 
-static int lapic_next_deadline(unsigned long delta,
-			       struct clock_event_device *evt)
+INDIRECT_CALLABLE_SCOPE
+int lapic_next_deadline(unsigned long delta,
+		       struct clock_event_device *evt)
 {
 	u64 tsc;
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index a698196377be..ff2868d5ddea 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1090,7 +1090,8 @@ static void tsc_resume(struct clocksource *cs)
  * checking the result of read_tsc() - cycle_last for being negative.
  * That works because CLOCKSOURCE_MASK(64) does not mask out any bit.
  */
-static u64 read_tsc(struct clocksource *cs)
+INDIRECT_CALLABLE_SCOPE
+u64 read_tsc(struct clocksource *cs)
 {
 	return (u64)rdtsc_ordered();
 }
diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 0ee140176f10..9d2d110f0b8c 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -20,6 +20,7 @@
 #include <linux/seqlock.h>
 #include <linux/timer.h>
 #include <linux/timerqueue.h>
+#include <linux/indirect_call_wrapper.h>
 
 struct hrtimer_clock_base;
 struct hrtimer_cpu_base;
@@ -297,14 +298,17 @@ static inline s64 hrtimer_get_expires_ns(const struct hrtimer *timer)
 	return ktime_to_ns(timer->node.expires);
 }
 
+INDIRECT_CALLABLE_DECLARE(extern ktime_t ktime_get(void));
+
 static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
 {
-	return ktime_sub(timer->node.expires, timer->base->get_time());
+	return ktime_sub(timer->node.expires,
+			INDIRECT_CALL_1(timer->base->get_time, ktime_get));
 }
 
 static inline ktime_t hrtimer_cb_get_time(struct hrtimer *timer)
 {
-	return timer->base->get_time();
+	return INDIRECT_CALL_1(timer->base->get_time, ktime_get);
 }
 
 static inline int hrtimer_is_hres_active(struct hrtimer *timer)
@@ -503,7 +507,9 @@ hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 static inline u64 hrtimer_forward_now(struct hrtimer *timer,
 				      ktime_t interval)
 {
-	return hrtimer_forward(timer, timer->base->get_time(), interval);
+	return hrtimer_forward(timer,
+			INDIRECT_CALL_1(timer->base->get_time, ktime_get),
+			interval);
 }
 
 /* Precise sleep: */
@@ -536,4 +542,11 @@ int hrtimers_dead_cpu(unsigned int cpu);
 #define hrtimers_dead_cpu	NULL
 #endif
 
+struct clock_event_device;
+INDIRECT_CALLABLE_DECLARE(extern __weak u64 read_tsc(struct clocksource *cs));
+INDIRECT_CALLABLE_DECLARE(extern int thread_cpu_clock_get(
+		const clockid_t which_clock, struct timespec64 *tp));
+INDIRECT_CALLABLE_DECLARE(extern __weak int lapic_next_deadline(
+		unsigned long delta, struct clock_event_device *evt));
+
 #endif
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 003ccf338d20..ac15412e87c4 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -245,7 +245,8 @@ static int clockevents_program_min_delta(struct clock_event_device *dev)
 
 		dev->retries++;
 		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-		if (dev->set_next_event((unsigned long) clc, dev) == 0)
+		if (INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
+				  (unsigned long) clc, dev) == 0)
 			return 0;
 
 		if (++i > 2) {
@@ -284,7 +285,8 @@ static int clockevents_program_min_delta(struct clock_event_device *dev)
 
 		dev->retries++;
 		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-		if (dev->set_next_event((unsigned long) clc, dev) == 0)
+		if (INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
+				  (unsigned long) clc, dev) == 0)
 			return 0;
 	}
 	return -ETIME;
@@ -331,7 +333,8 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 	delta = max(delta, (int64_t) dev->min_delta_ns);
 
 	clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
-	rc = dev->set_next_event((unsigned long) clc, dev);
+	rc = INDIRECT_CALL_1(dev->set_next_event, lapic_next_deadline,
+			   (unsigned long) clc, dev);
 
 	return (rc && force) ? clockevents_program_min_delta(dev) : rc;
 }
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 0ea8702eb516..e1e17fdfcd18 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1241,7 +1241,8 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	remove_hrtimer(timer, base, true, force_local);
 
 	if (mode & HRTIMER_MODE_REL)
-		tim = ktime_add_safe(tim, base->get_time());
+		tim = ktime_add_safe(tim,
+			INDIRECT_CALL_1(base->get_time, ktime_get));
 
 	tim = hrtimer_update_lowres(timer, tim, mode);
 
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 96b4e7810426..d8bf325fa84e 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1596,8 +1596,8 @@ static int thread_cpu_clock_getres(const clockid_t which_clock,
 {
 	return posix_cpu_clock_getres(THREAD_CLOCK, tp);
 }
-static int thread_cpu_clock_get(const clockid_t which_clock,
-				struct timespec64 *tp)
+INDIRECT_CALLABLE_SCOPE
+int thread_cpu_clock_get(const clockid_t which_clock, struct timespec64 *tp)
 {
 	return posix_cpu_clock_get(THREAD_CLOCK, tp);
 }
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 1cd10b102c51..35eac10ee796 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1089,7 +1089,8 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	if (!kc)
 		return -EINVAL;
 
-	error = kc->clock_get_timespec(which_clock, &kernel_tp);
+	error = INDIRECT_CALL_1(kc->clock_get_timespec, thread_cpu_clock_get,
+				which_clock, &kernel_tp);
 
 	if (!error && put_timespec64(&kernel_tp, tp))
 		error = -EFAULT;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index dcdcb85121e4..2b1a3b146614 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -190,7 +190,7 @@ static inline u64 tk_clock_read(const struct tk_read_base *tkr)
 {
 	struct clocksource *clock = READ_ONCE(tkr->clock);
 
-	return clock->read(clock);
+	return INDIRECT_CALL_1(clock->read, read_tsc, clock);
 }
 
 #ifdef CONFIG_DEBUG_TIMEKEEPING
-- 
2.35.1.473.g83b2b277ed-goog

