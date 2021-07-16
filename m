Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487A93CB1F1
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 07:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhGPFiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 01:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhGPFiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 01:38:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF06C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 22:35:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g24so5796641pji.4
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 22:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ighxmF8GYk5h0Ig4SFD1RnulXAkbQmLXTB6ztSGreKE=;
        b=Uw9A+AzZQ+ZmXy9w7LM617tymW6f8ifn886exYAAJhOPFW5YJ00fRfsQVWBkTfDaK8
         wNEQyWRnGB4lYt82c2/gIzYKyJIFhFWDigEyWN8ds/9iNd5wjyen5ViHkNhA96Zc4G+R
         2UwqEwGCHtuW5tSDoG5vJc6bdEuRMfjJnpIbU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ighxmF8GYk5h0Ig4SFD1RnulXAkbQmLXTB6ztSGreKE=;
        b=lQDIkzhH1rwsN5S3lNyCvuPnE6qtVQFIdg06WYC/5lsYzZkosUArgk1AVbCfamjOD0
         DPSXFpaWjKP6OYQri7PNdGUMx+7hrAtQFeCopfBt2blQ4HXBnS+K+cfndKDJqw6Ze5aQ
         nng+QxQqWyxzK5CRk3gE6arT3Bf9NQmSEiydTvMWRXaU8PL5Djm1hFR/Ij7v6wf22ZcS
         87e/lqFY27gUEKwaO+0Eai8GatUNJXwr7HMPqq4KrszpjSTNdJGYaN0apS6Y4KyjEwKm
         w1OxzSlKDVKcVU7zVHFgc5URWepqRhX3FwvV3UjOBUlHEHeiMQj5ZUGzy2Jgtn72mO36
         VAmg==
X-Gm-Message-State: AOAM5338chlhYz0HDmyLXXc7ITB4cnszyKynmCenHfppUXzHvyHsKWjN
        rRJG8Eii7vqPCK/2dSWMXneSKg==
X-Google-Smtp-Source: ABdhPJzljIUs653ngTHsnifRxU7xReS8liTha5Ihhy9GEcsaDzx9mORSzRl+WRQ/uJwXFTAJ/GhM5Q==
X-Received: by 2002:a17:90b:184:: with SMTP id t4mr14192743pjs.161.1626413713209;
        Thu, 15 Jul 2021 22:35:13 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:d1af:356e:50a6:75e8])
        by smtp.gmail.com with ESMTPSA id i18sm8864253pfa.149.2021.07.15.22.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 22:35:12 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH] x86/kvm: do not touch watchdogs in pvclock
Date:   Fri, 16 Jul 2021 14:34:05 +0900
Message-Id: <20210716053405.1243239-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When host suspends a VM it may signal the guest that its
being suspended via KVM_KVMCLOCK_CTRL ioctl, so that once
resumed guest VCPUs can discover PVCLOCK_GUEST_STOPPED bit
and touch watchdogs to update stale timeouts.

The way it's implemented is that every kvm_clock_read() calls
pvclock_clocksource_read(), which tests PVCLOCK_GUEST_STOPPED
and invokes pvclock_touch_watchdogs() when needed. This scheme
appears not to be always working as intended. For instance,
when lockdep is enabled we have the following:

<IRQ>
apic_timer_interrupt()
 smp_apic_timer_interrupt()
  hrtimer_interrupt()
   _raw_spin_lock_irqsave()
    lock_acquire()
     __lock_acquire()
      sched_clock_cpu()
       sched_clock()
        kvm_sched_clock_read()
         kvm_clock_read()
          pvclock_clocksource_read()
           pvclock_touch_watchdogs()

Since this is VM and VCPU resume path, jiffies still maybe
be outdated here, which is often the case on my device.
pvclock_clocksource_read() clears PVCLOCK_GUEST_STOPPED,
touches watchdogs, but it uses stale jiffies: 4294740764
(for example).

Now comes in the sched tick IRQ, which invokes RCU watchdog:

<IRQ>
apic_timer_interrupt()
 smp_apic_timer_interrupt()
  hrtimer_interrupt()
   __hrtimer_run_queues()
    tick_sched_timer()
     tick_sched_handle()
      update_process_times()
       rcu_sched_clock_irq()

At this point, however, jiffies are already updated and include
the VM suspension time (approx 80 seconds in this case): 4294819216,
but PVCLOCK_GUEST_STOPPED is already cleared and we used outdated
jiffies, so RCU watchdog concludes it's a stall.

There are probably more scenarios under which resuming VCPUs can
invoke kvm_clock_read() too early.

Both lockup and RCU watchdogs call kvm_check_and_clear_guest_paused()
from hard IRQ contexts, so we probably can remove one from
pvclock_clocksource_read() and avoid preliminary PVCLOCK_GUEST_STOPPED
handling from some random paths.

That is, since kvm_check_and_clear_guest_paused() is for watchdogs
then only watchdogs should use it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 arch/x86/kernel/pvclock.c  | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ad273e5861c1..af90b889e923 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -150,8 +150,8 @@ bool kvm_check_and_clear_guest_paused(void)
 		return ret;
 
 	if ((src->pvti.flags & PVCLOCK_GUEST_STOPPED) != 0) {
-		src->pvti.flags &= ~PVCLOCK_GUEST_STOPPED;
 		pvclock_touch_watchdogs();
+		src->pvti.flags &= ~PVCLOCK_GUEST_STOPPED;
 		ret = true;
 	}
 	return ret;
diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index eda37df016f0..b176e083e543 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -77,11 +77,6 @@ u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 		flags = src->flags;
 	} while (pvclock_read_retry(src, version));
 
-	if (unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
-		src->flags &= ~PVCLOCK_GUEST_STOPPED;
-		pvclock_touch_watchdogs();
-	}
-
 	if ((valid_flags & PVCLOCK_TSC_STABLE_BIT) &&
 		(flags & PVCLOCK_TSC_STABLE_BIT))
 		return ret;
-- 
2.32.0.402.g57bb445576-goog

