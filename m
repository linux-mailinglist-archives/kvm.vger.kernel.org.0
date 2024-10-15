Return-Path: <kvm+bounces-28959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA0F99FC1B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 01:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FD1C1C241EB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 23:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884F61D63EA;
	Tue, 15 Oct 2024 23:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="gkNOHaCx"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F40F173357;
	Tue, 15 Oct 2024 23:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033850; cv=none; b=MLf4GR0jzqln0nUbPH2Kj/aox6kEuu16WW0/WSBYngF3WIfYrpRUvWeUea9EHsKREXnApaYu8K1fXEkWBhvYjGxV2W9B6x+scrI7rtSsEicr9iE1raXwvz6MgE1GGVR7QmsGKaygJsgJqjlceA3BMRtXCV63QmWmwLbDVoT6WD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033850; c=relaxed/simple;
	bh=CrNU3zPe4V+PSWdy/5qXKcKFUpFWUo8dNTGLeeWXTak=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jmieylNxGL5OW6YCFvi22mb5K80bAXIwsckh/FqfpKkA2+RunLv1URBwhj/HJiTkEU2pxy5seM6TlvvMwFlYtSpuJ6/BFiTwkMQ7yX0JtwdhMpXWyHgq+dob7pJKnDnAilQoph20KSp1wDR5rEgXM+bzLmZHMczaMcUXKxSS7yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=gkNOHaCx; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729032033;
	bh=CrNU3zPe4V+PSWdy/5qXKcKFUpFWUo8dNTGLeeWXTak=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=gkNOHaCxYvhA1CiBD5NWIOWLJSFHbxggYZ/ekEHnVhTi/GOZWYN2D9D302L/VWlJ4
	 PMSbWqw3Oi1lnz83Z7dbEaid/nmWmzbEgcM5PVetYPGgIytWzMbNFa/m9OLM/qpOqE
	 iNRpt1jOxq39PkncVYT8TtY9ipFPSZ6genbbhkjw=
Received: by gentwo.org (Postfix, from userid 1003)
	id 1D6704040C; Tue, 15 Oct 2024 15:40:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 1C335400C9;
	Tue, 15 Oct 2024 15:40:33 -0700 (PDT)
Date: Tue, 15 Oct 2024 15:40:33 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-pm@vger.kernel.org, 
    kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <87jze9rq15.fsf@oracle.com>
Message-ID: <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com> <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org> <Zw6dZ7HxvcHJaDgm@arm.com> <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Here is a patch that keeps the cpuidle stuiff generic but allows an
override by arm64..


From: Christoph Lameter (Ampere) <cl@linux.com>
Subject: Revise cpu poll idle to make full use of wfet() and wfe()

ARM64 has instructions that can wait for an event and timeouts.

Clean up the code in drivers/cpuidle/ to wait until the end
of a period and allow the override of the handling of the
waiting by an architecture.

Provide an optimized wait function for arm64.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/arch/arm64/lib/delay.c
===================================================================
--- linux.orig/arch/arm64/lib/delay.c
+++ linux/arch/arm64/lib/delay.c
@@ -12,6 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/timex.h>
+#include <linux/sched/clock.h>
+#include <linux/cpuidle.h>

 #include <clocksource/arm_arch_timer.h>

@@ -67,3 +69,27 @@ void __ndelay(unsigned long nsecs)
 	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
 }
 EXPORT_SYMBOL(__ndelay);
+
+void cpuidle_wait_for_resched_with_timeout(u64 end)
+{
+	u64 start;
+
+	while (!need_resched() && (start = local_clock_noinstr()) < end) {
+
+		if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
+
+			/* Processor supports waiting for a specified period */
+			wfet(xloops_to_cycles((end - start) * 0x5UL));
+
+		} else
+		if (arch_timer_evtstrm_available() && start + ARCH_TIMER_EVT_STREAM_PERIOD_US * 1000 < end) {
+
+			/* We can wait until a periodic event occurs */
+			wfe();
+
+		} else
+			/* Need to spin until the end */
+			cpu_relax();
+	}
+}
+
Index: linux/drivers/cpuidle/poll_state.c
===================================================================
--- linux.orig/drivers/cpuidle/poll_state.c
+++ linux/drivers/cpuidle/poll_state.c
@@ -8,35 +8,29 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>

-#define POLL_IDLE_RELAX_COUNT	200
+__weak void cpuidle_wait_for_resched_with_timeout(u64 end)
+{
+	while (!need_resched() && local_clock_noinstr() < end) {
+		cpu_relax();
+	}
+}

 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();
+	u64 time_start = local_clock_noinstr();
+	u64 time_end = time_start + cpuidle_poll_time(drv, dev);

 	dev->poll_time_limit = false;

 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
-		u64 limit;

-		limit = cpuidle_poll_time(drv, dev);
+		cpuidle_wait_for_resched_with_timeout(time_end);
+
+		if (!need_resched())
+			dev->poll_time_limit = true;

-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
-			loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}
-		}
 	}
 	raw_local_irq_disable();

Index: linux/include/linux/cpuidle.h
===================================================================
--- linux.orig/include/linux/cpuidle.h
+++ linux/include/linux/cpuidle.h
@@ -202,6 +202,9 @@ extern int cpuidle_play_dead(void);
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
 static inline struct cpuidle_device *cpuidle_get_device(void)
 {return __this_cpu_read(cpuidle_devices); }
+
+extern __weak void cpuidle_wait_for_resched_with_timeout(u64);
+
 #else
 static inline void disable_cpuidle(void) { }
 static inline bool cpuidle_not_available(struct cpuidle_driver *drv,

