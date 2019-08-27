Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2619F1D6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbfH0RrX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 13:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfH0RrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 13:47:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC7E410F23E8;
        Tue, 27 Aug 2019 17:47:22 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 901A8194B9;
        Tue, 27 Aug 2019 17:47:18 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Tue, 27 Aug 2019 19:47:17 +0200
Date:   Tue, 27 Aug 2019 19:47:17 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Periodically revaluate to get
 conservative lapic_timer_advance_ns
Message-ID: <20190827174717.GB65641@flask>
References: <1565841817-25982-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565841817-25982-1-git-send-email-wanpengli@tencent.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 27 Aug 2019 17:47:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-08-15 12:03+0800, Wanpeng Li:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Even if for realtime CPUs, cache line bounces, frequency scaling, presence 
> of higher-priority RT tasks, etc can still cause different response. These 
> interferences should be considered and periodically revaluate whether 
> or not the lapic_timer_advance_ns value is the best, do nothing if it is,
> otherwise recaluate again. Set lapic_timer_advance_ns to the minimal 
> conservative value from all the estimated values.

IIUC, this patch is looking for the minimal timer_advance_ns because it
provides the best throughput:
When every code path ran as fast as possible and we don't have to wait
for the timer to expire, but still arrive exactly at the point when it
would have expired.
We always arrive late late if something delayed the execution, which
means higher latencies, but RT shouldn't be using an adaptive algorithm
anyway, so that is not an issue.

The computed conservative timer_advance_ns will converge to the minimal
measured timer_advance_ns as time progresses, because it can only go
down and will do so repeatedly by small steps as even one smaller
measurement sufficiently close is enough to decrease it.

With that in mind, wouldn't the following patch (completely untested)
give you about the same numbers?

The idea is that if we have to wait, we are wasting time and therefore
decrease timer_advance_ns to eliminate the time spent waiting.

The first run is special and just sets timer_advance_ns to the latency
we measured, regardless of what it is -- it deals with the possibility
that the default was too low.

This algorithm is also likely prone to turbo boost making few runs
faster than what is then achieved during a more common workload, but
we'd need to have a sliding window or some other more sophisticated
algorithm in order to deal with that.

I also like Paolo's idea of a smoothing -- if we use a moving average
based on advance_expire_delta, we wouldn't even have to convert it into
ns unless it reached a given threshold, which could make decently fast
to be run every time.

Something like

   moving_average = (apic->lapic_timer.moving_average * (weight - 1) + advance_expire_delta) / weight

   if (moving_average > threshold)
      recompute timer_advance_ns

   apic->lapic_timer.moving_average = moving_average

where weight would be a of 2 to make the operation fast.

This kind of moving average gives less value to old inputs and the
weight allows us to control the reaction speed of the approximation.
(A small number like 4 or 8 seems about right.)

I don't have any information on the latency, though.
Do you think that the added overhead isn't worth the smoothing?

Thanks.

---8<---
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e904ff06a83d..d7f2af2eb3ce 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1491,23 +1491,20 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns -= min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns -= (u32)ns;
 	} else {
 	/* too late */
+		/* This branch can only be taken on the initial calibration. */
+		if (apic->lapic_timer.timer_advance_adjust_done)
+			pr_err_once("kvm: broken expectation in lapic timer_advance_ns");
+
 		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns += min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns += (u32)ns;
 	}
 
-	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
-		apic->lapic_timer.timer_advance_adjust_done = true;
-	if (unlikely(timer_advance_ns > 5000)) {
-		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
-		apic->lapic_timer.timer_advance_adjust_done = false;
-	}
 	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
+	apic->lapic_timer.timer_advance_adjust_done = true;
 }
 
 static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
@@ -1526,7 +1523,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
 	if (guest_tsc < tsc_deadline)
 		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
 
-	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
+	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done) || guest_tsc < tsc_deadline)
 		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
 }
 
