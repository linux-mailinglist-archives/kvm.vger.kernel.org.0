Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56855C34F
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 20:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAS5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 14:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfGAS5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 14:57:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DE4B30C583D;
        Mon,  1 Jul 2019 18:57:28 +0000 (UTC)
Received: from amt.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72FA4183A6;
        Mon,  1 Jul 2019 18:57:27 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 4FDBF10514D;
        Mon,  1 Jul 2019 15:56:50 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x61Iuo7Y028554;
        Mon, 1 Jul 2019 15:56:50 -0300
Message-ID: <20190701185528.078114514@asus.localdomain>
User-Agent: quilt/0.66
Date:   Mon, 01 Jul 2019 15:53:11 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org, linux-pm@vger.kernel.org
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
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/5] add cpuidle-haltpoll driver
References: <20190701185310.540706841@asus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 01 Jul 2019 18:57:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a cpuidle driver that calls the architecture default_idle routine.

To be used in conjunction with the haltpoll governor.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 arch/x86/kernel/process.c          |    2 -
 drivers/cpuidle/Kconfig            |    9 +++++
 drivers/cpuidle/Makefile           |    1 
 drivers/cpuidle/cpuidle-haltpoll.c |   65 +++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 1 deletion(-)

Index: linux-2.6-newcpuidle.git/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/arch/x86/kernel/process.c
+++ linux-2.6-newcpuidle.git/arch/x86/kernel/process.c
@@ -580,7 +580,7 @@ void __cpuidle default_idle(void)
 	safe_halt();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
-#ifdef CONFIG_APM_MODULE
+#if defined(CONFIG_APM_MODULE) || defined(CONFIG_HALTPOLL_CPUIDLE_MODULE)
 EXPORT_SYMBOL(default_idle);
 #endif
 
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/Kconfig
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/Kconfig
@@ -51,6 +51,15 @@ depends on PPC
 source "drivers/cpuidle/Kconfig.powerpc"
 endmenu
 
+config HALTPOLL_CPUIDLE
+       tristate "Halt poll cpuidle driver"
+       depends on X86 && KVM_GUEST
+       default y
+       help
+         This option enables halt poll cpuidle driver, which allows to poll
+         before halting in the guest (more efficient than polling in the
+         host via halt_poll_ns for some scenarios).
+
 endif
 
 config ARCH_NEEDS_CPU_IDLE_COUPLED
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/Makefile
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/Makefile
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/Makefile
@@ -7,6 +7,7 @@ obj-y += cpuidle.o driver.o governor.o s
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
 # ARM SoC drivers
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
===================================================================
--- /dev/null
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cpuidle driver for haltpoll governor.
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
+#include <linux/sched/idle.h>
+#include <linux/kvm_para.h>
+
+static int default_enter_idle(struct cpuidle_device *dev,
+			      struct cpuidle_driver *drv, int index)
+{
+	if (current_clr_polling_and_test()) {
+		local_irq_enable();
+		return index;
+	}
+	default_idle();
+	return index;
+}
+
+static struct cpuidle_driver haltpoll_driver = {
+	.name = "haltpoll",
+	.owner = THIS_MODULE,
+	.states = {
+		{ /* entry 0 is for polling */ },
+		{
+			.enter			= default_enter_idle,
+			.exit_latency		= 1,
+			.target_residency	= 1,
+			.power_usage		= -1,
+			.name			= "haltpoll idle",
+			.desc			= "default architecture idle",
+		},
+	},
+	.safe_state_index = 0,
+	.state_count = 2,
+};
+
+static int __init haltpoll_init(void)
+{
+	struct cpuidle_driver *drv = &haltpoll_driver;
+
+	cpuidle_poll_state_init(drv);
+
+	if (!kvm_para_available())
+		return 0;
+
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


