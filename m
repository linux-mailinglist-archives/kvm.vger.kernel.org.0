Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B285EFD5
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 01:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfGCX7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 19:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfGCX7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 19:59:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C627A3B48;
        Wed,  3 Jul 2019 23:59:50 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E9CF1001B20;
        Wed,  3 Jul 2019 23:59:49 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 90700105174;
        Wed,  3 Jul 2019 20:59:02 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x63Nx2in023715;
        Wed, 3 Jul 2019 20:59:02 -0300
Message-Id: <20190703235828.538807297@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Wed, 03 Jul 2019 20:51:28 -0300
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
Subject: [patch 4/5] cpuidle: add haltpoll governor
References: <20190703235124.783034907@amt.cnet>
Content-Disposition: inline; filename=03-cpuidle-haltpoll-governor
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 03 Jul 2019 23:59:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpuidle_haltpoll governor, in conjunction with the haltpoll cpuidle
driver, allows guest vcpus to poll for a specified amount of time before
halting.
This provides the following benefits to host side polling:

        1) The POLL flag is set while polling is performed, which allows
           a remote vCPU to avoid sending an IPI (and the associated
           cost of handling the IPI) when performing a wakeup.

        2) The VM-exit cost can be avoided.

The downside of guest side polling is that polling is performed
even with other runnable tasks in the host.

Results comparing halt_poll_ns and server/client application
where a small packet is ping-ponged:

host                                        --> 31.33
halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)

For the SAP HANA benchmarks (where idle_spin is a parameter
of the previous version of the patch, results should be the
same):

hpns == halt_poll_ns

                          idle_spin=0/   idle_spin=800/    idle_spin=0/
                          hpns=200000    hpns=0            hpns=800000
DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)      1.29   (-3.7%)
UpdateC00T03 (1 thread)   4.72           4.18 (-12%)       4.53   (-5%)

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>


---
 Documentation/virtual/guest-halt-polling.txt |   79 ++++++++++++
 drivers/cpuidle/Kconfig                      |   11 +
 drivers/cpuidle/governors/Makefile           |    1 
 drivers/cpuidle/governors/haltpoll.c         |  175 +++++++++++++++++++++++++++
 4 files changed, 266 insertions(+)

Index: linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/Kconfig
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
@@ -33,6 +33,17 @@ config CPU_IDLE_GOV_TEO
 	  Some workloads benefit from using it and it generally should be safe
 	  to use.  Say Y here if you are not happy with the alternatives.
 
+config CPU_IDLE_GOV_HALTPOLL
+	bool "Haltpoll governor (for virtualized systems)"
+	depends on KVM_GUEST
+	help
+	  This governor implements haltpoll idle state selection, to be
+	  used in conjunction with the haltpoll cpuidle driver, allowing
+	  for polling for a certain amount of time before entering idle
+	  state.
+
+	  Some virtualized workloads benefit from using it.
+
 config DT_IDLE_STATES
 	bool
 
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/governors/Makefile
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/governors/Makefile
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/governors/Makefile
@@ -6,3 +6,4 @@
 obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
 obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
 obj-$(CONFIG_CPU_IDLE_GOV_TEO) += teo.o
+obj-$(CONFIG_CPU_IDLE_GOV_HALTPOLL) += haltpoll.o
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/governors/haltpoll.c
===================================================================
--- /dev/null
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/governors/haltpoll.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * haltpoll.c - haltpoll idle governor
+ *
+ * Copyright 2019 Red Hat, Inc. and/or its affiliates.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Authors: Marcelo Tosatti <mtosatti@redhat.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/cpuidle.h>
+#include <linux/time.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+#include <linux/tick.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/kvm_para.h>
+
+static unsigned int guest_halt_poll_ns __read_mostly = 200000;
+module_param(guest_halt_poll_ns, uint, 0644);
+
+/* division factor to shrink halt_poll_ns */
+static unsigned int guest_halt_poll_shrink __read_mostly = 2;
+module_param(guest_halt_poll_shrink, uint, 0644);
+
+/* multiplication factor to grow per-cpu poll_limit_ns */
+static unsigned int guest_halt_poll_grow __read_mostly = 2;
+module_param(guest_halt_poll_grow, uint, 0644);
+
+/* value in us to start growing per-cpu halt_poll_ns */
+static unsigned int guest_halt_poll_grow_start __read_mostly = 50000;
+module_param(guest_halt_poll_grow_start, uint, 0644);
+
+/* allow shrinking guest halt poll */
+static bool guest_halt_poll_allow_shrink __read_mostly = true;
+module_param(guest_halt_poll_allow_shrink, bool, 0644);
+
+/**
+ * haltpoll_select - selects the next idle state to enter
+ * @drv: cpuidle driver containing state data
+ * @dev: the CPU
+ * @stop_tick: indication on whether or not to stop the tick
+ */
+static int haltpoll_select(struct cpuidle_driver *drv,
+			   struct cpuidle_device *dev,
+			   bool *stop_tick)
+{
+	int latency_req = cpuidle_governor_latency_req(dev->cpu);
+
+	if (!drv->state_count || latency_req == 0) {
+		*stop_tick = false;
+		return 0;
+	}
+
+	if (dev->poll_limit_ns == 0)
+		return 1;
+
+	/* Last state was poll? */
+	if (dev->last_state_idx == 0) {
+		/* Halt if no event occurred on poll window */
+		if (dev->poll_time_limit == true)
+			return 1;
+
+		*stop_tick = false;
+		/* Otherwise, poll again */
+		return 0;
+	}
+
+	*stop_tick = false;
+	/* Last state was halt: poll */
+	return 0;
+}
+
+static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
+{
+	unsigned int val;
+	u64 block_ns = block_us*NSEC_PER_USEC;
+
+	/* Grow cpu_halt_poll_us if
+	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
+	 */
+	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
+		val = dev->poll_limit_ns * guest_halt_poll_grow;
+
+		if (val < guest_halt_poll_grow_start)
+			val = guest_halt_poll_grow_start;
+		if (val > guest_halt_poll_ns)
+			val = guest_halt_poll_ns;
+
+		dev->poll_limit_ns = val;
+	} else if (block_ns > guest_halt_poll_ns &&
+		   guest_halt_poll_allow_shrink) {
+		unsigned int shrink = guest_halt_poll_shrink;
+
+		val = dev->poll_limit_ns;
+		if (shrink == 0)
+			val = 0;
+		else
+			val /= shrink;
+		dev->poll_limit_ns = val;
+	}
+}
+
+/**
+ * haltpoll_reflect - update variables and update poll time
+ * @dev: the CPU
+ * @index: the index of actual entered state
+ */
+static void haltpoll_reflect(struct cpuidle_device *dev, int index)
+{
+	dev->last_state_idx = index;
+
+	if (index != 0)
+		adjust_poll_limit(dev, dev->last_residency);
+}
+
+/**
+ * haltpoll_enable_device - scans a CPU's states and does setup
+ * @drv: cpuidle driver
+ * @dev: the CPU
+ */
+static int haltpoll_enable_device(struct cpuidle_driver *drv,
+				  struct cpuidle_device *dev)
+{
+	dev->poll_limit_ns = 0;
+
+	return 0;
+}
+
+static struct cpuidle_governor haltpoll_governor = {
+	.name =			"haltpoll",
+	.rating =		21,
+	.enable =		haltpoll_enable_device,
+	.select =		haltpoll_select,
+	.reflect =		haltpoll_reflect,
+};
+
+static int __init init_haltpoll(void)
+{
+	if (kvm_para_available())
+		return cpuidle_register_governor(&haltpoll_governor);
+
+	return 0;
+}
+
+postcore_initcall(init_haltpoll);
Index: linux-2.6-newcpuidle.git/Documentation/virtual/guest-halt-polling.txt
===================================================================
--- /dev/null
+++ linux-2.6-newcpuidle.git/Documentation/virtual/guest-halt-polling.txt
@@ -0,0 +1,79 @@
+Guest halt polling
+==================
+
+The cpuidle_haltpoll driver, with the haltpoll governor, allows
+the guest vcpus to poll for a specified amount of time before
+halting.
+This provides the following benefits to host side polling:
+
+	1) The POLL flag is set while polling is performed, which allows
+	   a remote vCPU to avoid sending an IPI (and the associated
+ 	   cost of handling the IPI) when performing a wakeup.
+
+	2) The VM-exit cost can be avoided.
+
+The downside of guest side polling is that polling is performed
+even with other runnable tasks in the host.
+
+The basic logic as follows: A global value, guest_halt_poll_ns,
+is configured by the user, indicating the maximum amount of
+time polling is allowed. This value is fixed.
+
+Each vcpu has an adjustable guest_halt_poll_ns
+("per-cpu guest_halt_poll_ns"), which is adjusted by the algorithm
+in response to events (explained below).
+
+Module Parameters
+=================
+
+The haltpoll governor has 5 tunable module parameters:
+
+1) guest_halt_poll_ns:
+Maximum amount of time, in nanoseconds, that polling is
+performed before halting.
+
+Default: 200000
+
+2) guest_halt_poll_shrink:
+Division factor used to shrink per-cpu guest_halt_poll_ns when
+wakeup event occurs after the global guest_halt_poll_ns.
+
+Default: 2
+
+3) guest_halt_poll_grow:
+Multiplication factor used to grow per-cpu guest_halt_poll_ns
+when event occurs after per-cpu guest_halt_poll_ns
+but before global guest_halt_poll_ns.
+
+Default: 2
+
+4) guest_halt_poll_grow_start:
+The per-cpu guest_halt_poll_ns eventually reaches zero
+in case of an idle system. This value sets the initial
+per-cpu guest_halt_poll_ns when growing. This can
+be increased from 10000, to avoid misses during the initial
+growth stage:
+
+10k, 20k, 40k, ... (example assumes guest_halt_poll_grow=2).
+
+Default: 50000
+
+5) guest_halt_poll_allow_shrink:
+
+Bool parameter which allows shrinking. Set to N
+to avoid it (per-cpu guest_halt_poll_ns will remain
+high once achieves global guest_halt_poll_ns value).
+
+Default: Y
+
+The module parameters can be set from the debugfs files in:
+
+	/sys/module/haltpoll/parameters/
+
+Further Notes
+=============
+
+- Care should be taken when setting the guest_halt_poll_ns parameter as a
+large value has the potential to drive the cpu usage to 100% on a machine which
+would be almost entirely idle otherwise.
+


