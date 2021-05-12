Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8DC37BBDF
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhELLf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhELLfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:35:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB43C061574;
        Wed, 12 May 2021 04:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sLA8x8bF7v1sDQnZimx3oxH0nvPNKA3JqIaZJ/Rl+VY=; b=BEMKies3QWEHNNHELX5UfwpO4X
        j620BVMz4ol4HXg779xn71wRKkIv48A3TSOINy68yh5iQcKKE7pW8HxX7pS66L91L88qUcdMhdjm3
        2hM5VajuL/M2z14QEoKezFsjS8IhO6galWkwUDhXzfSTJVNdOmjRXKV1XhkOUDGW8XugN7zK/ALqa
        MUe5OX2FZjsVX9x4Sr+e/goHGSfHuYExhjbOTC7xKg9VJdGhSTE5NSUvE/2wrU9t6veaxLx1yYm9W
        PswX+z6+4t5SiNs+JMrvoImp33d4OREZE+hazZcOoXFmNGLfPyCMIwGMm+LkDiUDHuTqoVo6kewHJ
        jSNK0PdA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lgn5z-008DkT-2f; Wed, 12 May 2021 11:32:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 421D430019C;
        Wed, 12 May 2021 13:32:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 06A092040BF80; Wed, 12 May 2021 13:32:04 +0200 (CEST)
Date:   Wed, 12 May 2021 13:32:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mel Gorman <mgorman@suse.de>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 3/6] sched: Simplify sched_info_on()
Message-ID: <YJu8s0f7Cc78GEWN@hirez.programming.kicks-ass.net>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.121458839@infradead.org>
 <20210512111040.GC3672@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512111040.GC3672@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 12:10:40PM +0100, Mel Gorman wrote:
> As delta is !0 iff t->sched_info.last_queued, why not this?
> 
> diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
> index 33ffd41935ba..37e33c0eeb7c 100644
> --- a/kernel/sched/stats.h
> +++ b/kernel/sched/stats.h
> @@ -158,15 +158,14 @@ static inline void psi_sched_switch(struct task_struct *prev,
>   */
>  static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
>  {
> -	unsigned long long delta = 0;
> -
>  	if (t->sched_info.last_queued) {
> +		unsigned long long delta;
> +
>  		delta = rq_clock(rq) - t->sched_info.last_queued;
>  		t->sched_info.last_queued = 0;
> +		t->sched_info.run_delay += delta;
> +		rq_sched_info_dequeue(rq, delta);
>  	}
> -	t->sched_info.run_delay += delta;
> -
> -	rq_sched_info_dequeue(rq, delta);
>  }

Right.. clearly I missed the obvious there.. Lemme go add another patch
on top of the lot.

Something like this I suppose.

---
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 33ffd41935ba..111072ee9663 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -160,10 +160,11 @@ static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
 {
 	unsigned long long delta = 0;
 
-	if (t->sched_info.last_queued) {
-		delta = rq_clock(rq) - t->sched_info.last_queued;
-		t->sched_info.last_queued = 0;
-	}
+	if (!t->sched_info.last_queued)
+		return;
+
+	delta = rq_clock(rq) - t->sched_info.last_queued;
+	t->sched_info.last_queued = 0;
 	t->sched_info.run_delay += delta;
 
 	rq_sched_info_dequeue(rq, delta);
@@ -176,12 +177,14 @@ static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
  */
 static void sched_info_arrive(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(rq), delta = 0;
+	unsigned long long now, delta = 0;
 
-	if (t->sched_info.last_queued) {
-		delta = now - t->sched_info.last_queued;
-		t->sched_info.last_queued = 0;
-	}
+	if (!t->sched_info.last_queued)
+		return;
+
+	now = rq_clock(rq);
+	delta = now - t->sched_info.last_queued;
+	t->sched_info.last_queued = 0;
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;


