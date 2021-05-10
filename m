Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368BB378DCD
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344849AbhEJMx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 08:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245646AbhEJMNe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 08:13:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7788DC0611CC;
        Mon, 10 May 2021 05:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hgWKawcsmXyf/l2+3vEwOhYJ9xgud2VHY8Z8IPJF1w8=; b=k42pJsX2WLlKvruyN8PNJivDyZ
        ffOn188g03X9FmI6TkpJONi0Qz2pdy2kB9vYEHDDxtQlChs7w92Pfb+Uz8BonqjueTs1HqWZeErpj
        pOBBZ20ra5bGCrmwqIh930icE2Ri940t6qJfHWg26uauAi2UOREq+fJhILXRNRjPMGf12iWaJ1lJC
        Hh4R/UOxTDRblhm89WOSYb6K3cEZUi1WID/rUepmD6pbzAd5FH1R0+iMqeEEp8A4X3sw6XxuhPIJk
        J4mnk9jkHDWOBZ4YTPN7zcl1IIkSqdBwuefml5auPMtlR0ULkuKyy4Q1q88WTvmba+shetUGvHvIe
        l3qCOUbA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lg4ez-00EBfk-H3; Mon, 10 May 2021 12:05:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9B9A63002C4;
        Mon, 10 May 2021 14:05:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8077C20275859; Mon, 10 May 2021 14:05:13 +0200 (CEST)
Date:   Mon, 10 May 2021 14:05:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 7/6] delayacct: Add sysctl to enable at runtime
Message-ID: <YJkhebGJAywaZowX@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505105940.190490250@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Just like sched_schedstats, allow runtime enabling (and disabling) of
delayacct. This is useful if one forgot to add the delayacct boot time
option.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 Documentation/accounting/delay-accounting.rst |    6 ++--
 kernel/delayacct.c                            |   36 ++++++++++++++++++++++++--
 kernel/sysctl.c                               |   12 ++++++++
 3 files changed, 50 insertions(+), 4 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst
+++ b/Documentation/accounting/delay-accounting.rst
@@ -74,8 +74,10 @@ Delay accounting is disabled by default
 
    delayacct
 
-to the kernel boot options. The rest of the instructions
-below assume this has been done.
+to the kernel boot options. The rest of the instructions below assume this has
+been done. Alternatively, use sysctl kernel.sched_delayacct to switch the state
+at runtime. Note however that only tasks started after enabling it will have
+delayacct information.
 
 After the system has booted up, use a utility
 similar to  getdelays.c to access the delays
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -18,6 +18,17 @@ DEFINE_STATIC_KEY_FALSE(delayacct_key);
 int delayacct_on __read_mostly;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;
 
+static void set_delayacct(bool enabled)
+{
+	if (enabled) {
+		static_branch_enable(&delayacct_key);
+		delayacct_on = 1;
+	} else {
+		delayacct_on = 0;
+		static_branch_disable(&delayacct_key);
+	}
+}
+
 static int __init delayacct_setup_enable(char *str)
 {
 	delayacct_on = 1;
@@ -29,9 +40,30 @@ void delayacct_init(void)
 {
 	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC|SLAB_ACCOUNT);
 	delayacct_tsk_init(&init_task);
-	if (delayacct_on)
-		static_branch_enable(&delayacct_key);
+	set_delayacct(delayacct_on);
+}
+
+#ifdef CONFIG_PROC_SYSCTL
+int sysctl_delayacct(struct ctl_table *table, int write, void *buffer,
+		     size_t *lenp, loff_t *ppos)
+{
+	int state = delayacct_on;
+	struct ctl_table t;
+	int err;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	t = *table;
+	t.data = &state;
+	err = proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+	if (err < 0)
+		return err;
+	if (write)
+		set_delayacct(state);
+	return err;
 }
+#endif
 
 void __delayacct_tsk_init(struct task_struct *tsk)
 {
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -71,6 +71,7 @@
 #include <linux/coredump.h>
 #include <linux/latencytop.h>
 #include <linux/pid.h>
+#include <linux/delayacct.h>
 
 #include "../lib/kstrtox.h"
 
@@ -1727,6 +1728,17 @@ static struct ctl_table kern_table[] = {
 		.extra2		= SYSCTL_ONE,
 	},
 #endif /* CONFIG_SCHEDSTATS */
+#ifdef CONFIG_TASK_DELAY_ACCT
+	{
+		.procname	= "sched_delayacct",
+		.data		= NULL,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= sysctl_delayacct,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_TASK_DELAY_ACCT */
 #ifdef CONFIG_NUMA_BALANCING
 	{
 		.procname	= "numa_balancing",
