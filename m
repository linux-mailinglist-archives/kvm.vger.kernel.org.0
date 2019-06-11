Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E393D713
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 21:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405039AbfFKTmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 15:42:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55698 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391080AbfFKTmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 15:42:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB6073092641;
        Tue, 11 Jun 2019 19:42:32 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1814B1001B01;
        Tue, 11 Jun 2019 19:42:30 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 97AC2105152;
        Tue, 11 Jun 2019 16:42:14 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5BJgEYL011941;
        Tue, 11 Jun 2019 16:42:14 -0300
Message-Id: <20190611194107.269706590@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Tue, 11 Jun 2019 16:40:55 -0300
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
        linux-pm@vger.kernel.org
Subject: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
References: <20190611194054.878923294@amt.cnet>
Content-Disposition: inline; filename=01-cpuidle-haltpoll
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 11 Jun 2019 19:42:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The cpuidle_haltpoll driver allows the guest vcpus to poll for a specified
amount of time before halting. This provides the following benefits
to host side polling:

        1) The POLL flag is set while polling is performed, which allows
           a remote vCPU to avoid sending an IPI (and the associated
           cost of handling the IPI) when performing a wakeup.

        2) The HLT VM-exit cost can be avoided.

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
DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)	   1.29   (-3.7%)
UpdateC00T03 (1 thread)   4.72           4.18 (-12%)	   4.53   (-5%)

---
 Documentation/virtual/guest-halt-polling.txt |   96 +++++++++++++++++
 arch/x86/kernel/process.c                    |    2 
 drivers/cpuidle/Kconfig                      |    9 +
 drivers/cpuidle/Makefile                     |    1 
 drivers/cpuidle/cpuidle-haltpoll.c           |  145 +++++++++++++++++++++++++++
 5 files changed, 252 insertions(+), 1 deletion(-)

Index: linux-2.6.git/Documentation/virtual/guest-halt-polling.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/Documentation/virtual/guest-halt-polling.txt	2019-06-11 16:38:55.072877644 -0300
@@ -0,0 +1,96 @@
+Guest halt polling
+==================
+
+The cpuidle_haltpoll driver allows the guest vcpus to poll for a specified
+amount of time before halting. This provides the following benefits
+to host side polling:
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
+The cpuidle_haltpoll module has 5 tunable module parameters:
+
+1) guest_halt_poll_ns:
+
+Maximum amount of time, in nanoseconds, that polling is
+performed before halting.
+
+Default: 0
+
+2) guest_halt_poll_shrink:
+
+Division factor used to shrink per-cpu guest_halt_poll_ns when
+wakeup event occurs after the global guest_halt_poll_ns.
+
+Default: 2
+
+3) guest_halt_poll_grow:
+
+Multiplication factor used to grow per-cpu guest_halt_poll_ns
+when event occurs after per-cpu guest_halt_poll_ns
+but before global guest_halt_poll_ns.
+
+Default: 2
+
+4) guest_halt_poll_grow_start:
+
+The per-cpu guest_halt_poll_ns eventually reaches zero
+in case of an idle system. This value sets the initial
+per-cpu guest_halt_poll_ns when growing. This can
+be increased from 10000, to avoid misses during the initial
+growth stage:
+
+10000, 20000, 40000, ... (example assumes guest_halt_poll_grow=2).
+
+Default: 10000
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
+	/sys/module/cpuidle_haltpoll/parameters/
+
+Host and guest polling
+======================
+
+KVM also performs host side polling (that is, it can poll for a certain
+amount of time before halting) on behalf of guest vcpus.
+
+Modern hosts support poll control MSRs, which are used by
+cpuidle_haltpoll to disable host side polling on a per-VM basis.
+
+If the KVM host does not support this interface, then both guest side
+and host side polling can be performed, which can incur extra CPU and
+energy consumption. One might consider disabling host side polling
+manually if upgrading to a new host is not an option.
+
+Further Notes
+=============
+
+Care should be taken when setting the guest_halt_poll_ns parameter
+as a large value has the potential to drive the cpu usage to 100% on a
+machine which would be almost entirely idle otherwise.
+
Index: linux-2.6.git/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/process.c	2019-06-11 12:14:37.731286353 -0300
+++ linux-2.6.git/arch/x86/kernel/process.c	2019-06-11 12:14:44.699424799 -0300
@@ -580,7 +580,7 @@
 	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
-#ifdef CONFIG_APM_MODULE
+#if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
Index: linux-2.6.git/drivers/cpuidle/Kconfig
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/Kconfig	2019-06-11 12:14:37.731286353 -0300
+++ linux-2.6.git/drivers/cpuidle/Kconfig	2019-06-11 16:38:13.984060707 -0300
@@ -51,6 +51,15 @@
 source "drivers/cpuidle/Kconfig.powerpc"
 endmenu
 
+config HALTPOLL_CPUIDLE
+       tristate "Halt poll cpuidle driver"
+       depends on X86
+       default y
+       help
+         This option enables halt poll cpuidle driver, which allows to poll
+         before halting in the guest (more efficient than polling in the
+         host via halt_poll_ns for some scenarios).
+
 endif
 
 config ARCH_NEEDS_CPU_IDLE_COUPLED
Index: linux-2.6.git/drivers/cpuidle/Makefile
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/Makefile	2019-06-11 12:14:37.731286353 -0300
+++ linux-2.6.git/drivers/cpuidle/Makefile	2019-06-11 12:14:44.700424819 -0300
@@ -7,6 +7,7 @@
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
 # ARM SoC drivers
Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-11 16:37:23.328053569 -0300
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cpuidle driver for halt polling.
+ *
+ * Copyright 2019 Red Hat, Inc. and/or its affiliates.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ * Authors: Marcelo Tosatti <mtosatti@redhat.com>
+ */
+
+#include <linux/init.h>
+#include <linux/cpuidle.h>
+#include <linux/module.h>
+#include <linux/sched/clock.h>
+#include <linux/sched/idle.h>
+
+static unsigned int guest_halt_poll_ns __read_mostly = 200000;
+module_param(guest_halt_poll_ns, uint, 0644);
+
+/* division factor to shrink halt_poll_ns */
+static unsigned int guest_halt_poll_shrink __read_mostly = 2;
+module_param(guest_halt_poll_shrink, uint, 0644);
+
+/* multiplication factor to grow per-cpu halt_poll_ns */
+static unsigned int guest_halt_poll_grow __read_mostly = 2;
+module_param(guest_halt_poll_grow, uint, 0644);
+
+/* value in ns to start growing per-cpu halt_poll_ns */
+static unsigned int guest_halt_poll_grow_start __read_mostly = 10000;
+module_param(guest_halt_poll_grow_start, uint, 0644);
+
+/* value in ns to start growing per-cpu halt_poll_ns */
+static bool guest_halt_poll_allow_shrink __read_mostly = true;
+module_param(guest_halt_poll_allow_shrink, bool, 0644);
+
+static DEFINE_PER_CPU(unsigned int, halt_poll_ns);
+
+static void adjust_haltpoll_ns(unsigned int block_ns,
+			       unsigned int *cpu_halt_poll_ns)
+{
+	unsigned int val;
+
+	/* Grow cpu_halt_poll_ns if
+	 * cpu_halt_poll_ns < block_ns < guest_halt_poll_ns
+	 */
+	if (block_ns > *cpu_halt_poll_ns && block_ns <= guest_halt_poll_ns) {
+		val = *cpu_halt_poll_ns * guest_halt_poll_grow;
+
+		if (val < guest_halt_poll_grow_start)
+			val = guest_halt_poll_grow_start;
+		if (val > guest_halt_poll_ns)
+			val = guest_halt_poll_ns;
+
+		*cpu_halt_poll_ns = val;
+	} else if (block_ns > guest_halt_poll_ns &&
+		   guest_halt_poll_allow_shrink) {
+		unsigned int shrink = guest_halt_poll_shrink;
+
+		val = *cpu_halt_poll_ns;
+		if (shrink == 0)
+			val = 0;
+		else
+			val /= shrink;
+		*cpu_halt_poll_ns = val;
+	}
+}
+
+static int haltpoll_enter_idle(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index)
+{
+	unsigned int *cpu_halt_poll_ns;
+	unsigned long long start, now, block_ns;
+	int cpu = smp_processor_id();
+
+	cpu_halt_poll_ns = per_cpu_ptr(&halt_poll_ns, cpu);
+
+	if (current_set_polling_and_test()) {
+		local_irq_enable();
+		goto out;
+	}
+
+	start = sched_clock();
+	local_irq_enable();
+	for (;;) {
+		if (need_resched()) {
+			current_clr_polling();
+			goto out;
+		}
+
+		now = sched_clock();
+		if (now - start > *cpu_halt_poll_ns)
+			break;
+
+		cpu_relax();
+	}
+
+	local_irq_disable();
+	if (current_clr_polling_and_test()) {
+		local_irq_enable();
+		goto out;
+	}
+
+	default_idle();
+	block_ns = sched_clock() - start;
+	adjust_haltpoll_ns(block_ns, cpu_halt_poll_ns);
+
+out:
+	return index;
+}
+
+static struct cpuidle_driver haltpoll_driver = {
+	.name = "haltpoll_idle",
+	.owner = THIS_MODULE,
+	.states = {
+		{ /* entry 0 is for polling */ },
+		{
+			.enter			= haltpoll_enter_idle,
+			.exit_latency		= 0,
+			.target_residency	= 0,
+			.power_usage		= -1,
+			.name			= "Halt poll",
+			.desc			= "Halt poll idle",
+		},
+	},
+	.safe_state_index = 0,
+	.state_count = 2,
+};
+
+static int __init haltpoll_init(void)
+{
+	return cpuidle_register(&haltpoll_driver, NULL);
+}
+
+static void __exit haltpoll_exit(void)
+{
+	cpuidle_unregister(&haltpoll_driver);
+}
+
+module_init(haltpoll_init);
+module_exit(haltpoll_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
+


