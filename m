Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76B1373932
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhEELWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbhEELV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:21:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA04C061761;
        Wed,  5 May 2021 04:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=nciwZ+Lsg8fk93SuI4bx84k4rYAnK6nrHeX7lP7LhA8=; b=VuwyUPHSCi4rWDAZAKX+kRkrjD
        gj8mDz5lZZ/Ki1H2SlM+e3NdiCqVfR9uHSnQcxwfQoL7B8hbx2MgnsTj3SdnWARRwlGo0393j7szp
        xX2JO3S0PlqL66UNh/UIECnER9mWrh0wZbPHGcbkaXFyzCaEpi4kaL7NAqvlgYd8W3PzdkmAie60B
        t0QU9JkVBpJIwg6qY1oXXzKqbEiZiukftWqYUJEkepJxdCkOXLwfdybf0tDQi/wbqznZr6G69Y/Op
        Wep+4hyJxPl34cY8aHqRE9jMOQpFldCA2ukEL5FFoQBgqMilpfSOv2E/Pf9hmZ1eizgu5quUzYdY6
        FBK9Ub3w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXn-000FRC-EJ; Wed, 05 May 2021 11:18:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 97B0F30030F;
        Wed,  5 May 2021 13:18:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 010EE299E9869; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.308018373@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 6/6] [RFC] delayacct: Default disabled
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assuming this stuff isn't actually used much; disable it by default
and avoid allocating and tracking the task_delay_info structure.

taskstats is changed to still report the regular sched and sched_info
and only skip the missing task_delay_info fields instead of not
reporting anything.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 Documentation/accounting/delay-accounting.rst   |    8 ++++----
 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 include/linux/delayacct.h                       |   16 ++++------------
 kernel/delayacct.c                              |   19 +++++++++++--------
 4 files changed, 20 insertions(+), 25 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst
+++ b/Documentation/accounting/delay-accounting.rst
@@ -69,13 +69,13 @@ Usage
 	CONFIG_TASK_DELAY_ACCT=y
 	CONFIG_TASKSTATS=y
 
-Delay accounting is enabled by default at boot up.
-To disable, add::
+Delay accounting is disabled by default at boot up.
+To enable, add::
 
-   nodelayacct
+   delayacct
 
 to the kernel boot options. The rest of the instructions
-below assume this has not been done.
+below assume this has been done.
 
 After the system has booted up, use a utility
 similar to  getdelays.c to access the delays
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3213,7 +3213,7 @@
 
 	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
 
-	nodelayacct	[KNL] Disable per-task delay accounting
+	delayacct	[KNL] Enable per-task delay accounting
 
 	nodsp		[SH] Disable hardware DSP at boot time.
 
--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -61,7 +61,7 @@ struct task_delay_info {
 #include <linux/jump_label.h>
 
 #ifdef CONFIG_TASK_DELAY_ACCT
-DECLARE_STATIC_KEY_TRUE(delayacct_key);
+DECLARE_STATIC_KEY_FALSE(delayacct_key);
 extern int delayacct_on;	/* Delay accounting turned on/off */
 extern struct kmem_cache *delayacct_cache;
 extern void delayacct_init(void);
@@ -69,7 +69,7 @@ extern void __delayacct_tsk_init(struct
 extern void __delayacct_tsk_exit(struct task_struct *);
 extern void __delayacct_blkio_start(void);
 extern void __delayacct_blkio_end(struct task_struct *);
-extern int __delayacct_add_tsk(struct taskstats *, struct task_struct *);
+extern int delayacct_add_tsk(struct taskstats *, struct task_struct *);
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
 extern void __delayacct_freepages_start(void);
 extern void __delayacct_freepages_end(void);
@@ -116,7 +116,7 @@ static inline void delayacct_tsk_free(st
 
 static inline void delayacct_blkio_start(void)
 {
-	if (!static_branch_likely(&delayacct_key))
+	if (!static_branch_unlikely(&delayacct_key))
 		return;
 
 	delayacct_set_flag(DELAYACCT_PF_BLKIO);
@@ -126,7 +126,7 @@ static inline void delayacct_blkio_start
 
 static inline void delayacct_blkio_end(struct task_struct *p)
 {
-	if (!static_branch_likely(&delayacct_key))
+	if (!static_branch_unlikely(&delayacct_key))
 		return;
 
 	if (p->delays)
@@ -134,14 +134,6 @@ static inline void delayacct_blkio_end(s
 	delayacct_clear_flag(DELAYACCT_PF_BLKIO);
 }
 
-static inline int delayacct_add_tsk(struct taskstats *d,
-					struct task_struct *tsk)
-{
-	if (!delayacct_on || !tsk->delays)
-		return 0;
-	return __delayacct_add_tsk(d, tsk);
-}
-
 static inline __u64 delayacct_blkio_ticks(struct task_struct *tsk)
 {
 	if (tsk->delays)
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -14,23 +14,23 @@
 #include <linux/delayacct.h>
 #include <linux/module.h>
 
-DEFINE_STATIC_KEY_TRUE(delayacct_key);
-int delayacct_on __read_mostly = 1;	/* Delay accounting turned on/off */
+DEFINE_STATIC_KEY_FALSE(delayacct_key);
+int delayacct_on __read_mostly;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;
 
-static int __init delayacct_setup_disable(char *str)
+static int __init delayacct_setup_enable(char *str)
 {
-	delayacct_on = 0;
+	delayacct_on = 1;
 	return 1;
 }
-__setup("nodelayacct", delayacct_setup_disable);
+__setup("delayacct", delayacct_setup_enable);
 
 void delayacct_init(void)
 {
 	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC|SLAB_ACCOUNT);
 	delayacct_tsk_init(&init_task);
-	if (!delayacct_on)
-		static_branch_disable(&delayacct_key);
+	if (delayacct_on)
+		static_branch_enable(&delayacct_key);
 }
 
 void __delayacct_tsk_init(struct task_struct *tsk)
@@ -83,7 +83,7 @@ void __delayacct_blkio_end(struct task_s
 	delayacct_end(&delays->lock, &delays->blkio_start, total, count);
 }
 
-int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
+int delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
 	u64 utime, stime, stimescaled, utimescaled;
 	unsigned long long t2, t3;
@@ -118,6 +118,9 @@ int __delayacct_add_tsk(struct taskstats
 	d->cpu_run_virtual_total =
 		(tmp < (s64)d->cpu_run_virtual_total) ?	0 : tmp;
 
+	if (!tsk->delays)
+		return 0;
+
 	/* zero XXX_total, non-zero XXX_count implies XXX stat overflowed */
 
 	raw_spin_lock_irqsave(&tsk->delays->lock, flags);


