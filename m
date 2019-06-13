Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC644F9A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 00:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfFMWzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 18:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfFMWzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 18:55:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85BF359454;
        Thu, 13 Jun 2019 22:55:10 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F10CE1001B2E;
        Thu, 13 Jun 2019 22:55:06 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 011C2105186;
        Thu, 13 Jun 2019 19:53:04 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x5DMr38O025934;
        Thu, 13 Jun 2019 19:53:03 -0300
Message-ID: <20190613225022.969533311@redhat.com>
User-Agent: quilt/0.66
Date:   Thu, 13 Jun 2019 18:45:34 -0400
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
Subject: [patch 2/5] cpuidle: add get_poll_time callback
References: <20190613224532.949768676@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 13 Jun 2019 22:55:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "get_poll_time" callback to the cpuidle_governor structure,
and change poll state to poll for that amount of time.

Provide a default method for it, while allowing individual governors
to override it.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 drivers/cpuidle/cpuidle.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/cpuidle/poll_state.c |   11 ++---------
 include/linux/cpuidle.h      |    8 ++++++++
 3 files changed, 50 insertions(+), 9 deletions(-)

Index: linux-2.6.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/cpuidle.c	2019-06-13 17:57:33.111185824 -0400
+++ linux-2.6.git/drivers/cpuidle/cpuidle.c	2019-06-13 18:09:48.158500660 -0400
@@ -362,6 +362,46 @@
 }
 
 /**
+ * cpuidle_default_poll_time - default routine used to return poll time
+ * governors can override it if necessary
+ *
+ * @drv:   the cpuidle driver tied with the cpu
+ * @dev:   the cpuidle device
+ *
+ */
+static u64 cpuidle_default_poll_time(struct cpuidle_driver *drv,
+				     struct cpuidle_device *dev)
+{
+	int i;
+
+	for (i = 1; i < drv->state_count; i++) {
+		if (drv->states[i].disabled || dev->states_usage[i].disable)
+			continue;
+
+		return (u64)drv->states[i].target_residency * NSEC_PER_USEC;
+	}
+
+	return TICK_NSEC;
+}
+
+/**
+ * cpuidle_get_poll_time - tell the polling driver how much time to poll,
+ *			   in nanoseconds.
+ *
+ * @drv: the cpuidle driver tied with the cpu
+ * @dev: the cpuidle device
+ *
+ */
+u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
+			  struct cpuidle_device *dev)
+{
+	if (cpuidle_curr_governor->get_poll_time)
+		return cpuidle_curr_governor->get_poll_time(drv, dev);
+
+	return cpuidle_default_poll_time(drv, dev);
+}
+
+/**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
  */
 void cpuidle_install_idle_handler(void)
Index: linux-2.6.git/drivers/cpuidle/poll_state.c
===================================================================
--- linux-2.6.git.orig/drivers/cpuidle/poll_state.c	2019-06-13 17:57:33.111185824 -0400
+++ linux-2.6.git/drivers/cpuidle/poll_state.c	2019-06-13 18:01:19.846944820 -0400
@@ -20,16 +20,9 @@
 	local_irq_enable();
 	if (!current_set_polling_and_test()) {
 		unsigned int loop_count = 0;
-		u64 limit = TICK_NSEC;
-		int i;
+		u64 limit;
 
-		for (i = 1; i < drv->state_count; i++) {
-			if (drv->states[i].disabled || dev->states_usage[i].disable)
-				continue;
-
-			limit = (u64)drv->states[i].target_residency * NSEC_PER_USEC;
-			break;
-		}
+		limit = cpuidle_get_poll_time(drv, dev);
 
 		while (!need_resched()) {
 			cpu_relax();
Index: linux-2.6.git/include/linux/cpuidle.h
===================================================================
--- linux-2.6.git.orig/include/linux/cpuidle.h	2019-06-13 17:57:33.111185824 -0400
+++ linux-2.6.git/include/linux/cpuidle.h	2019-06-13 18:01:19.846944820 -0400
@@ -132,6 +132,8 @@
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
+extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
+				 struct cpuidle_device *dev);
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
@@ -166,6 +168,9 @@
 				struct cpuidle_device *dev, int index)
 {return -ENODEV; }
 static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
+extern u64 cpuidle_get_poll_time(struct cpuidle_driver *drv,
+				 struct cpuidle_device *dev)
+{return 0; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
@@ -246,6 +251,9 @@
 					struct cpuidle_device *dev,
 					bool *stop_tick);
 	void (*reflect)		(struct cpuidle_device *dev, int index);
+
+	u64 (*get_poll_time)	(struct cpuidle_driver *drv,
+					struct cpuidle_device *dev);
 };
 
 #ifdef CONFIG_CPU_IDLE


