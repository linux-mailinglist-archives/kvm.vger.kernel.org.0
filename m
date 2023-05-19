Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23FD7094F0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjESKed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjESKeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3B10CE;
        Fri, 19 May 2023 03:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=9vqHKqr8qLvPAc6CZjuNpJuO7WKwN2GzdLEYPcbYwQc=; b=U9rtCzfpSqdjhvWW5TY81J8GZh
        IYlZTFIX3AKFLrM8SUN+ShJMpaJYzC+L03QJfiw7hUfmJNbj4xhNr+ozknGdDXCNL+ISpphJ20T2c
        lCBD2Ip5Lg+StGepFx+6Utikm0Sy2o9SyjygXPiazxyIdCTXM4fQhF/YOKAIlJArKITFtryQZ4pPH
        1DkGKvPyRMhmm6cqgJTMmtn2Oh/CaLM6zmb1oV09yZyi8kwH91mzd1bhmcv9aU9Xc2NTvQRzNlc+m
        hQXoQdO/h+HpVOSIWO24LXum0ZEJ8pKP8fBKJ3QLT8cyhVTVhM1hS1xCE+JIc6izMjtpjibuU/UNM
        fXT3BH1Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqU-TS; Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D987C300AFA;
        Fri, 19 May 2023 12:32:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id B3B68235EF082; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.233598176@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:20:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, peterz@infradead.org, longman@redhat.com,
        boqun.feng@gmail.com, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, jstultz@google.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 01/13] seqlock/latch: Provide raw_read_seqcount_latch_retry()
References: <20230519102058.581557770@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The read side of seqcount_latch consists of:

  do {
    seq = raw_read_seqcount_latch(&latch->seq);
    ...
  } while (read_seqcount_latch_retry(&latch->seq, seq));

which is asymmetric in the raw_ department, and sure enough,
read_seqcount_latch_retry() includes (explicit) instrumentation where
raw_read_seqcount_latch() does not.

This inconsistency becomes a problem when trying to use it from
noinstr code. As such, fix it by renaming and re-implementing
raw_read_seqcount_latch_retry() without the instrumentation.

Specifically the instrumentation in question is kcsan_atomic_next(0)
in do___read_seqcount_retry(). Loosing this annotation is not a
problem because raw_read_seqcount_latch() does not pass through
kcsan_atomic_next(KCSAN_SEQLOCK_REGION_MAX).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/rbtree_latch.h |    2 +-
 include/linux/seqlock.h      |   15 ++++++++-------
 kernel/printk/printk.c       |    2 +-
 kernel/time/sched_clock.c    |    2 +-
 kernel/time/timekeeping.c    |    4 ++--
 5 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/rbtree_latch.h
+++ b/include/linux/rbtree_latch.h
@@ -206,7 +206,7 @@ latch_tree_find(void *key, struct latch_
 	do {
 		seq = raw_read_seqcount_latch(&root->seq);
 		node = __lt_find(key, root, seq & 1, ops->comp);
-	} while (read_seqcount_latch_retry(&root->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&root->seq, seq));
 
 	return node;
 }
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -671,9 +671,9 @@ typedef struct {
  *
  * Return: sequence counter raw value. Use the lowest bit as an index for
  * picking which data copy to read. The full counter must then be checked
- * with read_seqcount_latch_retry().
+ * with raw_read_seqcount_latch_retry().
  */
-static inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *s)
+static __always_inline unsigned raw_read_seqcount_latch(const seqcount_latch_t *s)
 {
 	/*
 	 * Pairs with the first smp_wmb() in raw_write_seqcount_latch().
@@ -683,16 +683,17 @@ static inline unsigned raw_read_seqcount
 }
 
 /**
- * read_seqcount_latch_retry() - end a seqcount_latch_t read section
+ * raw_read_seqcount_latch_retry() - end a seqcount_latch_t read section
  * @s:		Pointer to seqcount_latch_t
  * @start:	count, from raw_read_seqcount_latch()
  *
  * Return: true if a read section retry is required, else false
  */
-static inline int
-read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
+static __always_inline int
+raw_read_seqcount_latch_retry(const seqcount_latch_t *s, unsigned start)
 {
-	return read_seqcount_retry(&s->seqcount, start);
+	smp_rmb();
+	return unlikely(READ_ONCE(s->seqcount.sequence) != start);
 }
 
 /**
@@ -752,7 +753,7 @@ read_seqcount_latch_retry(const seqcount
  *			entry = data_query(latch->data[idx], ...);
  *
  *		// This includes needed smp_rmb()
- *		} while (read_seqcount_latch_retry(&latch->seq, seq));
+ *		} while (raw_read_seqcount_latch_retry(&latch->seq, seq));
  *
  *		return entry;
  *	}
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -597,7 +597,7 @@ static u64 latched_seq_read_nolock(struc
 		seq = raw_read_seqcount_latch(&ls->latch);
 		idx = seq & 0x1;
 		val = ls->val[idx];
-	} while (read_seqcount_latch_retry(&ls->latch, seq));
+	} while (raw_read_seqcount_latch_retry(&ls->latch, seq));
 
 	return val;
 }
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -77,7 +77,7 @@ notrace struct clock_read_data *sched_cl
 
 notrace int sched_clock_read_retry(unsigned int seq)
 {
-	return read_seqcount_latch_retry(&cd.seq, seq);
+	return raw_read_seqcount_latch_retry(&cd.seq, seq);
 }
 
 unsigned long long notrace sched_clock(void)
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -450,7 +450,7 @@ static __always_inline u64 __ktime_get_f
 		tkr = tkf->base + (seq & 0x01);
 		now = ktime_to_ns(tkr->base);
 		now += fast_tk_get_delta_ns(tkr);
-	} while (read_seqcount_latch_retry(&tkf->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&tkf->seq, seq));
 
 	return now;
 }
@@ -566,7 +566,7 @@ static __always_inline u64 __ktime_get_r
 		basem = ktime_to_ns(tkr->base);
 		baser = ktime_to_ns(tkr->base_real);
 		delta = fast_tk_get_delta_ns(tkr);
-	} while (read_seqcount_latch_retry(&tkf->seq, seq));
+	} while (raw_read_seqcount_latch_retry(&tkf->seq, seq));
 
 	if (mono)
 		*mono = basem + delta;


