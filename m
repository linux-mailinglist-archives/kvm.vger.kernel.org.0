Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5784566A748
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 00:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjAMX5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 18:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjAMX5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 18:57:38 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46011869DC;
        Fri, 13 Jan 2023 15:57:37 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id fd15so10494091qtb.9;
        Fri, 13 Jan 2023 15:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=04WipWzvi3fgLXeN3WQIiUmtsXJgHxnpbmFiZjQ6EeQ=;
        b=QBxD6UJhEwCxoDKZHBBFwJseq/TT/58ZrBsDNTfB8TXXX28Tuj328/Z2O1fxlpawwH
         2ihQbx9jlf3Y/qBAS3f+Dv6WbLc16s3OqYHBZiq5U0cQUVCGcF2pAYsStqHBUhQq+xiR
         ypkQxW5NXD1p5hjXXTApSd8kZuABF6v2Ulgpa6OvARuQcqbcBaV4y9ruz9EnVjUTJAXC
         5QEhd1x8mr8KKPBK6bW4K7Pz6hR1ASB0GMr5NXSZDF2vDfNTC3cC10L5oBLNrg5xV5yQ
         BnW+AZF4jHQbFKWgypUlv5hgWpgYQc2d4iWO9UHSXWEgX5/ugL0Xkze0QWCsRjDSAeg+
         RYLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:feedback-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=04WipWzvi3fgLXeN3WQIiUmtsXJgHxnpbmFiZjQ6EeQ=;
        b=DIeARyEQkPBa4gRl4FdOfwXCRNTxwHwnij8PAWfO+M9b3M3/+BRjd45m6AUwTHUx8Y
         Z6ncx+qHUnYjayOeyoHjJQZMN9NT9gsqt7O7fzG+PpUHeHZrNgnkQX5X01mLpVUAhB7x
         mKcvFhwmyLoIHxF34Kc6lMUmG2iJMgNN9um7F/VzepWZ7AnKfCmwRtZT1+JcNK8IGhTM
         bvm2xzExalZjNmKGzEQ7HApdfimWHOck827k9cNCEuJjSHLR6kmM8CQAorNa0PbQr7El
         FmyKSZwKXd4nfqFcIrl8vwsxxh6skozGnXupynOsQt2LuyIBR79qM/JjOCeDfuwfVaVo
         QR2A==
X-Gm-Message-State: AFqh2kpb/X/ZTU713wO/Y43ghk1bDMt5rgmW4/QMnAsk8H9DyVguFDhU
        giuUeTpE2KU42QCaUXkc7eU=
X-Google-Smtp-Source: AMrXdXu4QLs5zM7t68JijViTTXpRKsMlqQVVej1K4Dq7BJ1vqtn9igYcToVOW9xPrM3isTtKzkFypQ==
X-Received: by 2002:ac8:6755:0:b0:3b1:546e:e6b6 with SMTP id n21-20020ac86755000000b003b1546ee6b6mr12854568qtp.35.1673654256400;
        Fri, 13 Jan 2023 15:57:36 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id d12-20020a05620a240c00b006fcc3858044sm13953432qkn.86.2023.01.13.15.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:57:33 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 0873E27C0054;
        Fri, 13 Jan 2023 18:57:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 13 Jan 2023 18:57:33 -0500
X-ME-Sender: <xms:7O_BY51Ue0qj6M9-j2f1LMSILgt4pQhNnz8yFA_Vf9l6datDtMNgFw>
    <xme:7O_BYwExOvNVe9InD66U0vRt2OyXxqkcxZOuGEPUwCyhBCCboEZ-GvaApXY2WKyTX
    tSbWTelUSG3y3MKKg>
X-ME-Received: <xmr:7O_BY54bGtpisgWMPl6sjDUR4e-wG9fNSNgjU-XmG0J4Eda6UeKUlhzBeOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrleelgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepgeeljeeitdehvdehgefgjeevfeejjeekgfevffeiueejhfeuiefggeeuheeg
    gefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    hoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieeg
    qddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigi
    hmvgdrnhgrmhgv
X-ME-Proxy: <xmx:7O_BY20ieRCA9QSFYbShpwdK2QmiAFFTv38axVVArepg0IxcwvFDBA>
    <xmx:7O_BY8FaQVeEolybmZaOOjrOyKocQTDauvw7EVxbIPuA0ldiyIAXTQ>
    <xmx:7O_BY3-mL2fj1rHtfW9Ituc3WxKr2YPM9E_cO9B-ma5DXSlAzL1THQ>
    <xmx:7O_BYxKyRk9Vixay-ess8fIBrdss39flZdvTB9yUJOuWsS-huTB-XA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Jan 2023 18:57:31 -0500 (EST)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 4/3] locking/lockdep: Improve the deadlock scenario print for sync and read lock
Date:   Fri, 13 Jan 2023 15:57:22 -0800
Message-Id: <20230113235722.1226525-1-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113065955.815667-1-boqun.feng@gmail.com>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lock scenario print is always a weak spot of lockdep splats. Improvement
can be made if we rework the dependency search and the error printing.

However without touching the graph search, we can improve a little for
the circular deadlock case, since we have the to-be-added lock
dependency, and know whether these two locks are read/write/sync.

In order to know whether a held_lock is sync or not, a bit was
"stolen" from ->references, which reduce our limit for the same lock
class nesting from 2^12 to 2^11, and it should still be good enough.

Besides, since we now have bit in held_lock for sync, we don't need the
"hardirqoffs being 1" trick, and also we can avoid the __lock_release()
if we jump out of __lock_acquire() before the held_lock stored.

With these changes, a deadlock case evolved with read lock and sync gets
a better print-out from:

	[...]  Possible unsafe locking scenario:
	[...]
	[...]        CPU0                    CPU1
	[...]        ----                    ----
	[...]   lock(srcuA);
	[...]                                lock(srcuB);
	[...]                                lock(srcuA);
	[...]   lock(srcuB);

to

	[...]  Possible unsafe locking scenario:
	[...]
	[...]        CPU0                    CPU1
	[...]        ----                    ----
	[...]   rlock(srcuA);
	[...]                                lock(srcuB);
	[...]                                lock(srcuA);
	[...]   sync(srcuB);

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/lockdep.h  |  3 ++-
 kernel/locking/lockdep.c | 48 ++++++++++++++++++++++++++--------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ba09df6a0872..febd7ecc225c 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -134,7 +134,8 @@ struct held_lock {
 	unsigned int read:2;        /* see lock_acquire() comment */
 	unsigned int check:1;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:12;					/* 32 bits */
+	unsigned int sync:1;
+	unsigned int references:11;					/* 32 bits */
 	unsigned int pin_count;
 };
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index cffa026a765f..4031d87f6829 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1880,6 +1880,8 @@ print_circular_lock_scenario(struct held_lock *src,
 	struct lock_class *source = hlock_class(src);
 	struct lock_class *target = hlock_class(tgt);
 	struct lock_class *parent = prt->class;
+	int src_read = src->read;
+	int tgt_read = tgt->read;
 
 	/*
 	 * A direct locking problem where unsafe_class lock is taken
@@ -1907,7 +1909,10 @@ print_circular_lock_scenario(struct held_lock *src,
 	printk(" Possible unsafe locking scenario:\n\n");
 	printk("       CPU0                    CPU1\n");
 	printk("       ----                    ----\n");
-	printk("  lock(");
+	if (tgt_read != 0)
+		printk("  rlock(");
+	else
+		printk("  lock(");
 	__print_lock_name(target);
 	printk(KERN_CONT ");\n");
 	printk("                               lock(");
@@ -1916,7 +1921,12 @@ print_circular_lock_scenario(struct held_lock *src,
 	printk("                               lock(");
 	__print_lock_name(target);
 	printk(KERN_CONT ");\n");
-	printk("  lock(");
+	if (src_read != 0)
+		printk("  rlock(");
+	else if (src->sync)
+		printk("  sync(");
+	else
+		printk("  lock(");
 	__print_lock_name(source);
 	printk(KERN_CONT ");\n");
 	printk("\n *** DEADLOCK ***\n\n");
@@ -4530,7 +4540,13 @@ mark_usage(struct task_struct *curr, struct held_lock *hlock, int check)
 					return 0;
 		}
 	}
-	if (!hlock->hardirqs_off) {
+
+	/*
+	 * For lock_sync(), don't mark the ENABLED usage, since lock_sync()
+	 * creates no critical section and no extra dependency can be introduced
+	 * by interrupts
+	 */
+	if (!hlock->hardirqs_off && !hlock->sync) {
 		if (hlock->read) {
 			if (!mark_lock(curr, hlock,
 					LOCK_ENABLED_HARDIRQ_READ))
@@ -4909,7 +4925,7 @@ static int __lock_is_held(const struct lockdep_map *lock, int read);
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
 			  struct lockdep_map *nest_lock, unsigned long ip,
-			  int references, int pin_count)
+			  int references, int pin_count, int sync)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -4960,7 +4976,8 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	class_idx = class - lock_classes;
 
-	if (depth) { /* we're holding locks */
+	if (depth && !sync) {
+		/* we're holding locks and the new held lock is not a sync */
 		hlock = curr->held_locks + depth - 1;
 		if (hlock->class_idx == class_idx && nest_lock) {
 			if (!references)
@@ -4994,6 +5011,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
+	hlock->sync = !!sync;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
@@ -5055,6 +5073,10 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (!validate_chain(curr, hlock, chain_head, chain_key))
 		return 0;
 
+	/* For lock_sync(), we are done here since no actual critical section */
+	if (hlock->sync)
+		return 1;
+
 	curr->curr_chain_key = chain_key;
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -5196,7 +5218,7 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
 				    hlock->read, hlock->check,
 				    hlock->hardirqs_off,
 				    hlock->nest_lock, hlock->acquire_ip,
-				    hlock->references, hlock->pin_count)) {
+				    hlock->references, hlock->pin_count, 0)) {
 		case 0:
 			return 1;
 		case 1:
@@ -5666,7 +5688,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	lockdep_recursion_inc();
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 0);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
@@ -5699,11 +5721,6 @@ EXPORT_SYMBOL_GPL(lock_release);
  * APIs are used to wait for one or multiple critical sections (on other CPUs
  * or threads), and it means that calling these APIs inside these critical
  * sections is potential deadlock.
- *
- * This annotation acts as an acqurie+release anontation pair with hardirqoff
- * being 1. Since there's no critical section, no interrupt can create extra
- * dependencies "inside" the annotation, hardirqoff == 1 allows us to avoid
- * false positives.
  */
 void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 	       int check, struct lockdep_map *nest_lock, unsigned long ip)
@@ -5717,10 +5734,9 @@ void lock_sync(struct lockdep_map *lock, unsigned subclass, int read,
 	check_flags(flags);
 
 	lockdep_recursion_inc();
-	__lock_acquire(lock, subclass, 0, read, check, 1, nest_lock, ip, 0, 0);
-
-	if (__lock_release(lock, ip))
-		check_chain_key(current);
+	__lock_acquire(lock, subclass, 0, read, check,
+		       irqs_disabled_flags(flags), nest_lock, ip, 0, 0, 1);
+	check_chain_key(current);
 	lockdep_recursion_finish();
 	raw_local_irq_restore(flags);
 }
-- 
2.38.1

