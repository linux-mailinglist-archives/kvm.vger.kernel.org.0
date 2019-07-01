Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E7C16ACB
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 20:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbfEGS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 14:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbfEGS5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 14:57:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A0C2A3082E51;
        Tue,  7 May 2019 18:57:20 +0000 (UTC)
Received: from amt.cnet (ovpn-112-11.gru2.redhat.com [10.97.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C41F1837C;
        Tue,  7 May 2019 18:57:18 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 53394105182;
        Tue,  7 May 2019 15:56:59 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x47IusZB029563;
        Tue, 7 May 2019 15:56:54 -0300
Date:   Tue, 7 May 2019 15:56:49 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190507185647.GA29409@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 07 May 2019 18:57:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Certain workloads perform poorly on KVM compared to baremetal
due to baremetal's ability to perform mwait on NEED_RESCHED
bit of task flags (therefore skipping the IPI).

This patch introduces a configurable busy-wait delay before entering the
architecture delay routine, allowing wakeup IPIs to be skipped 
(if the IPI happens in that window).

The real-life workload which this patch improves performance
is SAP HANA (by 5-10%) (for which case setting idle_spin to 30 
is sufficient).

This patch improves the attached server.py and client.py example 
as follows:

Host:                           31.814230202231556
Guest:                          38.17718765199993       (83 %)
Guest, idle_spin=50us:          33.317709898000004      (95 %)
Guest, idle_spin=220us:         32.27826551499999       (98 %)

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

---
 kernel/sched/idle.c |   86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index f5516bae0c1b..bca7656a7ea0 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -216,6 +216,29 @@ static void cpuidle_idle_call(void)
 	rcu_idle_exit();
 }
 
+static unsigned int spin_before_idle_us;

+static void do_spin_before_idle(void)
+{
+	ktime_t now, end_spin;
+
+	now = ktime_get();
+	end_spin = ktime_add_ns(now, spin_before_idle_us*1000);
+
+	rcu_idle_enter();
+	local_irq_enable();
+	stop_critical_timings();
+
+	do {
+		cpu_relax();
+		now = ktime_get();
+	} while (!tif_need_resched() && ktime_before(now, end_spin));
+
+	start_critical_timings();
+	rcu_idle_exit();
+	local_irq_disable();
+}
+
 /*
  * Generic idle loop implementation
  *
@@ -259,6 +282,8 @@ static void do_idle(void)
 			tick_nohz_idle_restart_tick();
 			cpu_idle_poll();
 		} else {
+			if (spin_before_idle_us)
+				do_spin_before_idle();
 			cpuidle_idle_call();
 		}
 		arch_cpu_idle_exit();
@@ -465,3 +490,64 @@ const struct sched_class idle_sched_class = {
 	.switched_to		= switched_to_idle,
 	.update_curr		= update_curr_idle,
 };
+
+
+static ssize_t store_idle_spin(struct kobject *kobj,
+			       struct kobj_attribute *attr,
+			       const char *buf, size_t count)
+{
+	unsigned int val;
+
+	if (kstrtouint(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	if (val > USEC_PER_SEC)
+		return -EINVAL;
+
+	spin_before_idle_us = val;
+	return count;
+}
+
+static ssize_t show_idle_spin(struct kobject *kobj,
+			      struct kobj_attribute *attr,
+			      char *buf)
+{
+	ssize_t ret;
+
+	ret = sprintf(buf, "%d\n", spin_before_idle_us);
+
+	return ret;
+}
+
+static struct kobj_attribute idle_spin_attr =
+	__ATTR(idle_spin, 0644, show_idle_spin, store_idle_spin);
+
+static struct attribute *sched_attrs[] = {
+	&idle_spin_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group sched_attr_group = {
+	.attrs = sched_attrs,
+};
+
+static struct kobject *sched_kobj;
+
+static int __init sched_sysfs_init(void)
+{
+	int error;
+
+	sched_kobj = kobject_create_and_add("sched", kernel_kobj);
+	if (!sched_kobj)
+		return -ENOMEM;
+
+	error = sysfs_create_group(sched_kobj, &sched_attr_group);
+	if (error)
+		goto err;
+	return 0;
+
+err:
+	kobject_put(sched_kobj);
+	return error;
+}
+postcore_initcall(sched_sysfs_init);

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="client.py"

#!/bin/python3

import socket
import sys
import struct, fcntl, os
import os, errno, time
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server_address = ('127.0.0.1', 999)
print ("connecting to 127.0.0.1")
sock.connect(server_address)

nr_writes = 0

start_time = time.clock_gettime(time.CLOCK_MONOTONIC)

while nr_writes < 90000:
	data = sock.recv(4096)
	if len(data) == 0:
		print("connection closed!\n");
		exit(0);
	# sleep 20us
	time.sleep(20/1000000)
	sock.send(data)
	nr_writes = nr_writes+1

end_time = time.clock_gettime(time.CLOCK_MONOTONIC)
delta = end_time - start_time
print(delta)

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="server.py"

#!/bin/python3

import socket
import sys
import struct, fcntl, os
import os, errno, time
import time

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('127.0.0.1', 999))
sock.listen(10)
conn, addr = sock.accept()

nr_written=0
while 1:
	conn.sendall(b"a response line of text")
	data = conn.recv(1024)
	if not data:
        	break
	# sleep 200us
	time.sleep(200/1000000)
	nr_written = nr_written+1

--lrZ03NoBR/3+SXJZ--
