Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2CA373935
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhEELWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbhEELV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:21:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7C6C06174A;
        Wed,  5 May 2021 04:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=KWgKWqcKojvFWbBx5RMnNkzYaoIBCP6fm8wSr7RLIXA=; b=GktqExQRzr2dMR18KU8kv1UkCy
        /GAGq46ttPtITvgL+tv9Q4xq0qQp+3k5lt0nQxgvPQOsAgizCCYJkZ4A6qWQz6kw3t7+wJfk9Z2sS
        lT8DcRimaJyxOSJpOHr2JOjEAT3oDNLM1E3mlAMtGU7yW6wqTH1bZNX7GhtERQDgBya+1vHQsFwZt
        zXEPCeg8R4A5xHKYZObXPTyGcm8HhGejoQPra/o4gL59Py69lPz5+qE1kWC2XTxnwYT/PecTK8MuR
        /NlgflUkwQcL2++3ga+qxCtoL3ArWMstWDSX7eoJbrQC9OOG3e3gvyIzlX/xrDmgdypsPyDkv2Orp
        mjzPCsLA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXn-000FRD-EV; Wed, 05 May 2021 11:18:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9891B300312;
        Wed,  5 May 2021 13:18:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id EF566299E9868; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.248028369@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 5/6] delayacct: Add static_branch in scheduler hooks
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cheaper when delayacct is disabled.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/delayacct.h |    8 ++++++++
 kernel/delayacct.c        |    3 +++
 2 files changed, 11 insertions(+)

--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -58,8 +58,10 @@ struct task_delay_info {
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_TASK_DELAY_ACCT
+DECLARE_STATIC_KEY_TRUE(delayacct_key);
 extern int delayacct_on;	/* Delay accounting turned on/off */
 extern struct kmem_cache *delayacct_cache;
 extern void delayacct_init(void);
@@ -114,6 +116,9 @@ static inline void delayacct_tsk_free(st
 
 static inline void delayacct_blkio_start(void)
 {
+	if (!static_branch_likely(&delayacct_key))
+		return;
+
 	delayacct_set_flag(DELAYACCT_PF_BLKIO);
 	if (current->delays)
 		__delayacct_blkio_start();
@@ -121,6 +126,9 @@ static inline void delayacct_blkio_start
 
 static inline void delayacct_blkio_end(struct task_struct *p)
 {
+	if (!static_branch_likely(&delayacct_key))
+		return;
+
 	if (p->delays)
 		__delayacct_blkio_end(p);
 	delayacct_clear_flag(DELAYACCT_PF_BLKIO);
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -14,6 +14,7 @@
 #include <linux/delayacct.h>
 #include <linux/module.h>
 
+DEFINE_STATIC_KEY_TRUE(delayacct_key);
 int delayacct_on __read_mostly = 1;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;
 
@@ -28,6 +29,8 @@ void delayacct_init(void)
 {
 	delayacct_cache = KMEM_CACHE(task_delay_info, SLAB_PANIC|SLAB_ACCOUNT);
 	delayacct_tsk_init(&init_task);
+	if (!delayacct_on)
+		static_branch_disable(&delayacct_key);
 }
 
 void __delayacct_tsk_init(struct task_struct *tsk)


