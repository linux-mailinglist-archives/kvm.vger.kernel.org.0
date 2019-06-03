Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CB133BA9
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 01:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFCXBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 19:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40138 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfFCXBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 19:01:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 133EB30821FF;
        Mon,  3 Jun 2019 23:01:21 +0000 (UTC)
Received: from amt.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 598D617154;
        Mon,  3 Jun 2019 23:01:20 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 55BB3105165;
        Mon,  3 Jun 2019 19:54:58 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x53MswxR007684;
        Mon, 3 Jun 2019 19:54:58 -0300
Message-Id: <20190603225254.360289262@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Mon, 03 Jun 2019 19:52:45 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-15?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= 
        <rkrcmar@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 3/3] cpuidle-haltpoll: disable host side polling when kvm virtualized
References: <20190603225242.289109849@amt.cnet>
Content-Disposition: inline; filename=03-pollcontrol-guest.patch
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 03 Jun 2019 23:01:21 +0000 (UTC)
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
 arch/x86/kernel/kvm.c                   |   40 ++++++++++++++++++++++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      |    9 ++++++-
 include/linux/cpuidle_haltpoll.h        |   16 ++++++++++++
 5 files changed, 79 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/arch/x86/include/asm/cpuidle_haltpoll.h	2019-06-03 19:38:42.328718617 -0300
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+void arch_haltpoll_enable(void);
+void arch_haltpoll_disable(void);
+
+#endif
Index: linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:12.376619124 -0300
+++ linux-2.6.git/drivers/cpuidle/cpuidle-haltpoll.c	2019-06-03 19:38:42.328718617 -0300
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/timekeeping.h>
 #include <linux/sched/idle.h>
+#include <linux/cpuidle_haltpoll.h>
 #define CREATE_TRACE_POINTS
 #include "cpuidle-haltpoll-trace.h"
 
@@ -157,11 +158,17 @@
 
 static int __init haltpoll_init(void)
 {
-	return cpuidle_register(&haltpoll_driver, NULL);
+	int ret = cpuidle_register(&haltpoll_driver, NULL);
+
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
 
Index: linux-2.6.git/include/linux/cpuidle_haltpoll.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/include/linux/cpuidle_haltpoll.h	2019-06-03 19:41:57.293366260 -0300
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
Index: linux-2.6.git/arch/x86/Kconfig
===================================================================
--- linux-2.6.git.orig/arch/x86/Kconfig	2019-06-03 19:38:12.376619124 -0300
+++ linux-2.6.git/arch/x86/Kconfig	2019-06-03 19:42:34.478489868 -0300
@@ -787,6 +787,7 @@
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select ARCH_CPUIDLE_HALTPOLL
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
@@ -795,6 +796,12 @@
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
Index: linux-2.6.git/arch/x86/kernel/kvm.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kvm.c	2019-06-03 19:38:12.376619124 -0300
+++ linux-2.6.git/arch/x86/kernel/kvm.c	2019-06-03 19:40:14.359024312 -0300
@@ -853,3 +853,43 @@
 }
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
+
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+
+void kvm_disable_host_haltpoll(void *i)
+{
+	wrmsrl(MSR_KVM_POLL_CONTROL, 0);
+}
+
+void kvm_enable_host_haltpoll(void *i)
+{
+	wrmsrl(MSR_KVM_POLL_CONTROL, 1);
+}
+
+void arch_haltpoll_enable(void)
+{
+	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
+		return;
+
+	preempt_disable();
+	/* Enabling guest halt poll disables host halt poll */
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
+	/* Enabling guest halt poll disables host halt poll */
+	kvm_enable_host_haltpoll(NULL);
+	smp_call_function(kvm_enable_host_haltpoll, NULL, 1);
+	preempt_enable();
+}
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+#endif


