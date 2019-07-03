Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B745EFD6
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 01:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfGCX7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 19:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfGCX7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 19:59:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EB42368E3;
        Wed,  3 Jul 2019 23:59:53 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D85DE19698;
        Wed,  3 Jul 2019 23:59:52 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id C3A29105172;
        Wed,  3 Jul 2019 20:59:01 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x63Nx1kk023714;
        Wed, 3 Jul 2019 20:59:01 -0300
Message-Id: <20190703235828.471136356@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Wed, 03 Jul 2019 20:51:27 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-pm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/5] governors: unify last_state_idx
References: <20190703235124.783034907@amt.cnet>
Content-Disposition: inline; filename=02-unify-last-used-idx
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 03 Jul 2019 23:59:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since this field is shared by all governors, move it to 
cpuidle device structure.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: linux-2.6-newcpuidle.git/drivers/cpuidle/governors/ladder.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/governors/ladder.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/governors/ladder.c
@@ -38,7 +38,6 @@ struct ladder_device_state {
 
 struct ladder_device {
 	struct ladder_device_state states[CPUIDLE_STATE_MAX];
-	int last_state_idx;
 };
 
 static DEFINE_PER_CPU(struct ladder_device, ladder_devices);
@@ -49,12 +48,13 @@ static DEFINE_PER_CPU(struct ladder_devi
  * @old_idx: the current state index
  * @new_idx: the new target state index
  */
-static inline void ladder_do_selection(struct ladder_device *ldev,
+static inline void ladder_do_selection(struct cpuidle_device *dev,
+				       struct ladder_device *ldev,
 				       int old_idx, int new_idx)
 {
 	ldev->states[old_idx].stats.promotion_count = 0;
 	ldev->states[old_idx].stats.demotion_count = 0;
-	ldev->last_state_idx = new_idx;
+	dev->last_state_idx = new_idx;
 }
 
 /**
@@ -68,13 +68,13 @@ static int ladder_select_state(struct cp
 {
 	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	struct ladder_device_state *last_state;
-	int last_residency, last_idx = ldev->last_state_idx;
+	int last_residency, last_idx = dev->last_state_idx;
 	int first_idx = drv->states[0].flags & CPUIDLE_FLAG_POLLING ? 1 : 0;
 	int latency_req = cpuidle_governor_latency_req(dev->cpu);
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
-		ladder_do_selection(ldev, last_idx, 0);
+		ladder_do_selection(dev, ldev, last_idx, 0);
 		return 0;
 	}
 
@@ -91,7 +91,7 @@ static int ladder_select_state(struct cp
 		last_state->stats.promotion_count++;
 		last_state->stats.demotion_count = 0;
 		if (last_state->stats.promotion_count >= last_state->threshold.promotion_count) {
-			ladder_do_selection(ldev, last_idx, last_idx + 1);
+			ladder_do_selection(dev, ldev, last_idx, last_idx + 1);
 			return last_idx + 1;
 		}
 	}
@@ -107,7 +107,7 @@ static int ladder_select_state(struct cp
 			if (drv->states[i].exit_latency <= latency_req)
 				break;
 		}
-		ladder_do_selection(ldev, last_idx, i);
+		ladder_do_selection(dev, ldev, last_idx, i);
 		return i;
 	}
 
@@ -116,7 +116,7 @@ static int ladder_select_state(struct cp
 		last_state->stats.demotion_count++;
 		last_state->stats.promotion_count = 0;
 		if (last_state->stats.demotion_count >= last_state->threshold.demotion_count) {
-			ladder_do_selection(ldev, last_idx, last_idx - 1);
+			ladder_do_selection(dev, ldev, last_idx, last_idx - 1);
 			return last_idx - 1;
 		}
 	}
@@ -139,7 +139,7 @@ static int ladder_enable_device(struct c
 	struct ladder_device_state *lstate;
 	struct cpuidle_state *state;
 
-	ldev->last_state_idx = first_idx;
+	dev->last_state_idx = first_idx;
 
 	for (i = first_idx; i < drv->state_count; i++) {
 		state = &drv->states[i];
@@ -167,9 +167,8 @@ static int ladder_enable_device(struct c
  */
 static void ladder_reflect(struct cpuidle_device *dev, int index)
 {
-	struct ladder_device *ldev = this_cpu_ptr(&ladder_devices);
 	if (index > 0)
-		ldev->last_state_idx = index;
+		dev->last_state_idx = index;
 }
 
 static struct cpuidle_governor ladder_governor = {
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/governors/menu.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/governors/menu.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/governors/menu.c
@@ -117,7 +117,6 @@
  */
 
 struct menu_device {
-	int		last_state_idx;
 	int             needs_update;
 	int             tick_wakeup;
 
@@ -455,7 +454,7 @@ static void menu_reflect(struct cpuidle_
 {
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
 
-	data->last_state_idx = index;
+	dev->last_state_idx = index;
 	data->needs_update = 1;
 	data->tick_wakeup = tick_nohz_idle_got_tick();
 }
@@ -468,7 +467,7 @@ static void menu_reflect(struct cpuidle_
 static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 {
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
-	int last_idx = data->last_state_idx;
+	int last_idx = dev->last_state_idx;
 	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;
 	unsigned int new_factor;
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/governors/teo.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/governors/teo.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/governors/teo.c
@@ -96,7 +96,6 @@ struct teo_idle_state {
  * @time_span_ns: Time between idle state selection and post-wakeup update.
  * @sleep_length_ns: Time till the closest timer event (at the selection time).
  * @states: Idle states data corresponding to this CPU.
- * @last_state: Idle state entered by the CPU last time.
  * @interval_idx: Index of the most recent saved idle interval.
  * @intervals: Saved idle duration values.
  */
@@ -104,7 +103,6 @@ struct teo_cpu {
 	u64 time_span_ns;
 	u64 sleep_length_ns;
 	struct teo_idle_state states[CPUIDLE_STATE_MAX];
-	int last_state;
 	int interval_idx;
 	unsigned int intervals[INTERVALS];
 };
@@ -130,7 +128,9 @@ static void teo_update(struct cpuidle_dr
 		 */
 		measured_us = sleep_length_us;
 	} else {
-		unsigned int lat = drv->states[cpu_data->last_state].exit_latency;
+		unsigned int lat;
+
+		lat = drv->states[dev->last_state_idx].exit_latency;
 
 		measured_us = ktime_to_us(cpu_data->time_span_ns);
 		/*
@@ -245,9 +245,9 @@ static int teo_select(struct cpuidle_dri
 	int max_early_idx, idx, i;
 	ktime_t delta_tick;
 
-	if (cpu_data->last_state >= 0) {
+	if (dev->last_state_idx >= 0) {
 		teo_update(drv, dev);
-		cpu_data->last_state = -1;
+		dev->last_state_idx = -1;
 	}
 
 	cpu_data->time_span_ns = local_clock();
@@ -394,7 +394,7 @@ static void teo_reflect(struct cpuidle_d
 {
 	struct teo_cpu *cpu_data = per_cpu_ptr(&teo_cpus, dev->cpu);
 
-	cpu_data->last_state = state;
+	dev->last_state_idx = state;
 	/*
 	 * If the wakeup was not "natural", but triggered by one of the safety
 	 * nets, assume that the CPU might have been idle for the entire sleep
Index: linux-2.6-newcpuidle.git/include/linux/cpuidle.h
===================================================================
--- linux-2.6-newcpuidle.git.orig/include/linux/cpuidle.h
+++ linux-2.6-newcpuidle.git/include/linux/cpuidle.h
@@ -85,6 +85,7 @@ struct cpuidle_device {
 	unsigned int		cpu;
 	ktime_t			next_hrtimer;
 
+	int			last_state_idx;
 	int			last_residency;
 	u64			poll_limit_ns;
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];


