Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409255C350
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 20:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfGAS5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 14:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfGAS5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 14:57:31 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5509387630;
        Mon,  1 Jul 2019 18:57:31 +0000 (UTC)
Received: from amt.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE38287CF;
        Mon,  1 Jul 2019 18:57:30 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id E9743105171;
        Mon,  1 Jul 2019 15:56:52 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x61IuqN4028559;
        Mon, 1 Jul 2019 15:56:52 -0300
Message-ID: <20190701185528.230754447@asus.localdomain>
User-Agent: quilt/0.66
Date:   Mon, 01 Jul 2019 15:53:15 -0300
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
Subject: [patch 5/5] cpuidle-haltpoll: disable host side polling when kvm virtualized
References: <20190701185310.540706841@asus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 01 Jul 2019 18:57:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When performing guest side polling, it is not necessary to 
also perform host side polling. 

So disable host side polling, via the new MSR interface, 
when loading cpuidle-haltpoll driver.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 arch/x86/Kconfig                        |    7 +++++
 arch/x86/include/asm/cpuidle_haltpoll.h |    8 ++++++
 arch/x86/kernel/kvm.c                   |   42 ++++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      |   10 ++++++-
 include/linux/cpuidle_haltpoll.h        |   16 ++++++++++++
 5 files changed, 82 insertions(+), 1 deletion(-)

Index: linux-2.6-newcpuidle.git/arch/x86/include/asm/cpuidle_haltpoll.h
===================================================================
--- /dev/null
+++ linux-2.6-newcpuidle.git/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+void arch_haltpoll_enable(void);
+void arch_haltpoll_disable(void);
+
+#endif
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/cpuidle-haltpoll.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/sched/idle.h>
 #include <linux/kvm_para.h>
+#include <linux/cpuidle_haltpoll.h>
 
 static int default_enter_idle(struct cpuidle_device *dev,
 			      struct cpuidle_driver *drv, int index)
@@ -47,6 +48,7 @@ static struct cpuidle_driver haltpoll_dr
 
 static int __init haltpoll_init(void)
 {
+	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
 	cpuidle_poll_state_init(drv);
@@ -54,11 +56,16 @@ static int __init haltpoll_init(void)
 	if (!kvm_para_available())
 		return 0;
 
-	return cpuidle_register(&haltpoll_driver, NULL);
+	ret = cpuidle_register(&haltpoll_driver, NULL);
+	if (ret == 0)
+		arch_haltpoll_enable();
+
+	return ret;
 }
 
 static void __exit haltpoll_exit(void)
 {
+	arch_haltpoll_disable();
 	cpuidle_unregister(&haltpoll_driver);
 }
 
Index: linux-2.6-newcpuidle.git/include/linux/cpuidle_haltpoll.h
===================================================================
--- /dev/null
+++ linux-2.6-newcpuidle.git/include/linux/cpuidle_haltpoll.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CPUIDLE_HALTPOLL_H
+#define _CPUIDLE_HALTPOLL_H
+
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+#include <asm/cpuidle_haltpoll.h>
+#else
+static inline void arch_haltpoll_enable(void)
+{
+}
+
+static inline void arch_haltpoll_disable(void)
+{
+}
+#endif
+#endif
Index: linux-2.6-newcpuidle.git/arch/x86/Kconfig
===================================================================
--- linux-2.6-newcpuidle.git.orig/arch/x86/Kconfig
+++ linux-2.6-newcpuidle.git/arch/x86/Kconfig
@@ -787,6 +787,7 @@ config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select ARCH_CPUIDLE_HALTPOLL
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
@@ -795,6 +796,12 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config ARCH_CPUIDLE_HALTPOLL
+        def_bool n
+        prompt "Disable host haltpoll when loading haltpoll driver"
+        help
+	  If virtualized under KVM, disable host haltpoll.
+
 config PVH
 	bool "Support for running PVH guests"
 	---help---
Index: linux-2.6-newcpuidle.git/arch/x86/kernel/kvm.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/arch/x86/kernel/kvm.c
+++ linux-2.6-newcpuidle.git/arch/x86/kernel/kvm.c
@@ -853,3 +853,45 @@ void __init kvm_spinlock_init(void)
 }
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+
+static void kvm_disable_host_haltpoll(void *i)
+{
+	wrmsrl(MSR_KVM_POLL_CONTROL, 0);
+}
+
+static void kvm_enable_host_haltpoll(void *i)
+{
+	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
+}
+
+void arch_haltpoll_enable(void)
+{
+	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
+		printk(KERN_ERR "kvm: host does not support poll control\n");
+		printk(KERN_ERR "kvm: host upgrade recommended\n");
+		return;
+	}
+
+	preempt_disable();
+	/* Enable guest halt poll disables host halt poll */
+	kvm_disable_host_haltpoll(NULL);
+	smp_call_function(kvm_disable_host_haltpoll, NULL, 1);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_enable);
+
+void arch_haltpoll_disable(void)
+{
+	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
+		return;
+
+	preempt_disable();
+	/* Enable guest halt poll disables host halt poll */
+	kvm_enable_host_haltpoll(NULL);
+	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+#endif


