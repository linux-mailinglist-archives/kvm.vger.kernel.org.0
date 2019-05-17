Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A802C21CE9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfEQRzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 13:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfEQRzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 13:55:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC61A307D913;
        Fri, 17 May 2019 17:49:25 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5271410027B7;
        Fri, 17 May 2019 17:49:24 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 7157510519B;
        Fri, 17 May 2019 14:49:07 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4HHmxmY011000;
        Fri, 17 May 2019 14:48:59 -0300
Date:   Fri, 17 May 2019 14:48:59 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [PATCH] x86: add cpuidle_kvm driver to allow guest side halt polling
Message-ID: <20190517174857.GA8611@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 17 May 2019 17:49:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


The cpuidle_kvm driver allows the guest vcpus to poll for a specified
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
halt_poll_ns=300000 / no guest busy spin    --> 33.40	(93.8%)
halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73	(95.7%)

For the SAP HANA benchmarks (where idle_spin is a parameter 
of the previous version of the patch, results should be the
same):

hpns == halt_poll_ns

                          idle_spin=0/   idle_spin=800/	   idle_spin=0/
			  hpns=200000    hpns=0            hpns=800000
DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78	  (+1%)
InsertC16T02 (100 thread) 2.14     	 2.07 (-3%)        2.18   (+1.8%)
DeleteC00T01 (1 thread)   1.34 		 1.28 (-4.5%)	   1.29   (-3.7%)
UpdateC00T03 (1 thread)	  4.72		 4.18 (-12%)	   4.53   (-5%)

---
 Documentation/virtual/kvm/guest-halt-polling.txt |   39 ++++++++
 arch/x86/Kconfig                                 |    9 +
 arch/x86/kernel/Makefile                         |    1 
 arch/x86/kernel/cpuidle_kvm.c                    |  105 +++++++++++++++++++++++
 arch/x86/kernel/process.c                        |    2 
 5 files changed, 155 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/Kconfig
===================================================================
--- linux-2.6.git.orig/arch/x86/Kconfig	2019-04-22 13:49:42.858303265 -0300
+++ linux-2.6.git/arch/x86/Kconfig	2019-05-16 14:18:41.254852745 -0300
@@ -805,6 +805,15 @@
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config KVM_CPUIDLE
+	tristate "KVM cpuidle driver"
+	depends on KVM_GUEST
+	default y
+	help
+	  This option enables KVM cpuidle driver, which allows to poll
+	  before halting in the guest (more efficient than polling in the
+	  host via halt_poll_ns for some scenarios).
+
 config PVH
 	bool "Support for running PVH guests"
 	---help---
Index: linux-2.6.git/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/Makefile	2019-04-22 13:49:42.869303331 -0300
+++ linux-2.6.git/arch/x86/kernel/Makefile	2019-05-17 12:59:51.673274881 -0300
@@ -112,6 +112,7 @@
 obj-$(CONFIG_DEBUG_NMI_SELFTEST) += nmi_selftest.o
 
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
+obj-$(CONFIG_KVM_CPUIDLE)	+= cpuidle_kvm.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
Index: linux-2.6.git/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/process.c	2019-04-22 13:49:42.876303374 -0300
+++ linux-2.6.git/arch/x86/kernel/process.c	2019-05-17 13:19:18.055435117 -0300
@@ -580,7 +580,7 @@
 	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
-#ifdef CONFIG_APM_MODULE
+#if defined(CONFIG_APM_MODULE) || defined(CONFIG_KVM_CPUIDLE_MODULE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
Index: linux-2.6.git/arch/x86/kernel/cpuidle_kvm.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/arch/x86/kernel/cpuidle_kvm.c	2019-05-17 13:38:02.553941356 -0300
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cpuidle driver for KVM guests.
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
+#include <linux/timekeeping.h>
+#include <linux/sched/idle.h>
+
+unsigned int guest_halt_poll_ns;
+module_param(guest_halt_poll_ns, uint, 0644);
+
+static int kvm_enter_idle(struct cpuidle_device *dev,
+			  struct cpuidle_driver *drv, int index)
+{
+	int do_halt = 0;
+
+	/* No polling */
+	if (guest_halt_poll_ns == 0) {
+		if (current_clr_polling_and_test()) {
+			local_irq_enable();
+			return index;
+		}
+		default_idle();
+		return index;
+	}
+
+	local_irq_enable();
+	if (!current_set_polling_and_test()) {
+		ktime_t now, end_spin;
+
+		now = ktime_get();
+		end_spin = ktime_add_ns(now, guest_halt_poll_ns);
+
+		while (!need_resched()) {
+			cpu_relax();
+			now = ktime_get();
+
+			if (!ktime_before(now, end_spin)) {
+				do_halt = 1;
+				break;
+			}
+		}
+	}
+
+	if (do_halt) {
+		/*
+		 * No events while busy spin window passed,
+		 * halt.
+		 */
+		local_irq_disable();
+		if (current_clr_polling_and_test()) {
+			local_irq_enable();
+			return index;
+		}
+		default_idle();
+	} else {
+		current_clr_polling();
+	}
+
+	return index;
+}
+
+static struct cpuidle_driver kvm_idle_driver = {
+	.name = "kvm_idle",
+	.owner = THIS_MODULE,
+	.states = {
+		{ /* entry 0 is for polling */ },
+		{
+			.enter			= kvm_enter_idle,
+			.exit_latency		= 0,
+			.target_residency	= 0,
+			.power_usage		= -1,
+			.name			= "KVM",
+			.desc			= "KVM idle",
+		},
+	},
+	.safe_state_index = 0,
+	.state_count = 2,
+};
+
+static int __init kvm_cpuidle_init(void)
+{
+	return cpuidle_register(&kvm_idle_driver, NULL);
+}
+
+static void __exit kvm_cpuidle_exit(void)
+{
+	cpuidle_unregister(&kvm_idle_driver);
+}
+
+module_init(kvm_cpuidle_init);
+module_exit(kvm_cpuidle_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marcelo Tosatti <mtosatti@redhat.com>");
+
Index: linux-2.6.git/Documentation/virtual/kvm/guest-halt-polling.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/Documentation/virtual/kvm/guest-halt-polling.txt	2019-05-17 13:36:39.274703710 -0300
@@ -0,0 +1,39 @@
+KVM guest halt polling
+======================
+
+The cpuidle_kvm driver allows the guest vcpus to poll for a specified
+amount of time before halting. This provides the following benefits
+to host side polling:
+
+	1) The POLL flag is set while polling is performed, which allows
+	   a remote vCPU to avoid sending an IPI (and the associated
+ 	   cost of handling the IPI) when performing a wakeup.
+
+	2) The HLT VM-exit cost can be avoided.
+
+The downside of guest side polling is that polling is performed
+even with other runnable tasks in the host.
+
+Module Parameters
+=================
+
+The cpuidle_kvm module has 1 tuneable module parameter: guest_halt_poll_ns,
+the amount of time, in nanoseconds, that polling is performed before
+halting.
+
+This module parameter can be set from the debugfs files in:
+
+	/sys/module/cpuidle_kvm/parameters/
+
+Further Notes
+=============
+
+- Care should be taken when setting the guest_halt_poll_ns parameter as a
+large value has the potential to drive the cpu usage to 100% on a machine which
+would be almost entirely idle otherwise.
+
+- The effective amount of time that polling is performed is the host poll
+value (see halt-polling.txt) plus guest_halt_poll_ns. If all guests
+on a host system support and have properly configured guest_halt_poll_ns,
+then setting halt_poll_ns to 0 in the host is probably the best choice.
+
