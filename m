Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D17B5EFD0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 01:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGCX7v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 19:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbfGCX7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 19:59:51 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F1F9A859FB;
        Wed,  3 Jul 2019 23:59:49 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E02F1001B1B;
        Wed,  3 Jul 2019 23:59:49 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 3F4A9105171;
        Wed,  3 Jul 2019 20:59:01 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x63Nx03M023713;
        Wed, 3 Jul 2019 20:59:00 -0300
Message-Id: <20190703235828.405864213@amt.cnet>
User-Agent: quilt/0.60-1
Date:   Wed, 03 Jul 2019 20:51:26 -0300
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
Subject: [patch 2/5] cpuidle: add poll_limit_ns to cpuidle_device structure
References: <20190703235124.783034907@amt.cnet>
Content-Disposition: inline; filename=01-poll-time
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 03 Jul 2019 23:59:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a poll_limit_ns variable to cpuidle_device structure. 

Calculate and configure it in the new cpuidle_poll_time
function, in case its zero.

Individual governors are allowed to override this value.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 drivers/cpuidle/cpuidle.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/cpuidle/poll_state.c |   11 ++---------
 include/linux/cpuidle.h      |    8 ++++++++
 3 files changed, 50 insertions(+), 9 deletions(-)

Index: linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/cpuidle.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle.c
@@ -362,6 +362,36 @@ void cpuidle_reflect(struct cpuidle_devi
 }
 
 /**
+ * cpuidle_poll_time - return amount of time to poll for,
+ * governors can override dev->poll_limit_ns if necessary
+ *
+ * @drv:   the cpuidle driver tied with the cpu
+ * @dev:   the cpuidle device
+ *
+ */
+u64 cpuidle_poll_time(struct cpuidle_driver *drv,
+		      struct cpuidle_device *dev)
+{
+	int i;
+	u64 limit_ns;
+
+	if (dev->poll_limit_ns)
+		return dev->poll_limit_ns;
+
+	limit_ns = TICK_NSEC;
+	for (i = 1; i < drv->state_count; i++) {
+		if (drv->states[i].disabled || dev->states_usage[i].disable)
+			continue;
+
+		limit_ns = (u64)drv->states[i].target_residency * NSEC_PER_USEC;
+	}
+
+	dev->poll_limit_ns = limit_ns;
+
+	return dev->poll_limit_ns;
+}
+
+/**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
  */
 void cpuidle_install_idle_handler(void)
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/poll_state.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/poll_state.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/poll_state.c
@@ -20,16 +20,9 @@ static int __cpuidle poll_idle(struct cp
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
+		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
 			cpu_relax();
Index: linux-2.6-newcpuidle.git/include/linux/cpuidle.h
===================================================================
--- linux-2.6-newcpuidle.git.orig/include/linux/cpuidle.h
+++ linux-2.6-newcpuidle.git/include/linux/cpuidle.h
@@ -86,6 +86,7 @@ struct cpuidle_device {
 	ktime_t			next_hrtimer;
 
 	int			last_residency;
+	u64			poll_limit_ns;
 	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_driver_kobj *kobj_driver;
@@ -132,6 +133,8 @@ extern int cpuidle_select(struct cpuidle
 extern int cpuidle_enter(struct cpuidle_driver *drv,
 			 struct cpuidle_device *dev, int index);
 extern void cpuidle_reflect(struct cpuidle_device *dev, int index);
+extern u64 cpuidle_poll_time(struct cpuidle_driver *drv,
+			     struct cpuidle_device *dev);
 
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
 extern struct cpuidle_driver *cpuidle_get_driver(void);
@@ -166,6 +169,9 @@ static inline int cpuidle_enter(struct c
 				struct cpuidle_device *dev, int index)
 {return -ENODEV; }
 static inline void cpuidle_reflect(struct cpuidle_device *dev, int index) { }
+extern u64 cpuidle_poll_time(struct cpuidle_driver *drv,
+			     struct cpuidle_device *dev)
+{return 0; }
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
Index: linux-2.6-newcpuidle.git/drivers/cpuidle/sysfs.c
===================================================================
--- linux-2.6-newcpuidle.git.orig/drivers/cpuidle/sysfs.c
+++ linux-2.6-newcpuidle.git/drivers/cpuidle/sysfs.c
@@ -334,6 +334,7 @@ struct cpuidle_state_kobj {
 	struct cpuidle_state_usage *state_usage;
 	struct completion kobj_unregister;
 	struct kobject kobj;
+	struct cpuidle_device *device;
 };
 
 #ifdef CONFIG_SUSPEND
@@ -391,6 +392,7 @@ static inline void cpuidle_remove_s2idle
 #define kobj_to_state_obj(k) container_of(k, struct cpuidle_state_kobj, kobj)
 #define kobj_to_state(k) (kobj_to_state_obj(k)->state)
 #define kobj_to_state_usage(k) (kobj_to_state_obj(k)->state_usage)
+#define kobj_to_device(k) (kobj_to_state_obj(k)->device)
 #define attr_to_stateattr(a) container_of(a, struct cpuidle_state_attr, attr)
 
 static ssize_t cpuidle_state_show(struct kobject *kobj, struct attribute *attr,
@@ -414,10 +416,14 @@ static ssize_t cpuidle_state_store(struc
 	struct cpuidle_state *state = kobj_to_state(kobj);
 	struct cpuidle_state_usage *state_usage = kobj_to_state_usage(kobj);
 	struct cpuidle_state_attr *cattr = attr_to_stateattr(attr);
+	struct cpuidle_device *dev = kobj_to_device(kobj);
 
 	if (cattr->store)
 		ret = cattr->store(state, state_usage, buf, size);
 
+	/* reset poll time cache */
+	dev->poll_limit_ns = 0;
+
 	return ret;
 }
 
@@ -468,6 +474,7 @@ static int cpuidle_add_state_sysfs(struc
 		}
 		kobj->state = &drv->states[i];
 		kobj->state_usage = &device->states_usage[i];
+		kobj->device = device;
 		init_completion(&kobj->kobj_unregister);
 
 		ret = kobject_init_and_add(&kobj->kobj, &ktype_state_cpuidle,


