Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B996B3D76F4
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhG0Njc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 09:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbhG0Njc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 09:39:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B30C061757;
        Tue, 27 Jul 2021 06:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SvJgypLsn2Yu019XvY5aZgrSVnoahMm/wBmKaM/UYD8=; b=hLQPanqJHf8DHFegslat7Um+aw
        4aWns23p/yQyiiDqt6NPS8rzymkpVxh7pSudbQuYvkIfVeUzuwGZj+9tJfzX3f4YWtDkHUU1xFlh8
        MwPuwF+BcFmEamsNeo+g2+xxrnPWMqNIreOC86zq74FcdcfqPuoKm7rDJ+DdnAojnWJfq5fjFrlKg
        P3pRG5r9J7xWcjtiU7Ey5hDhXJT++MGTfDX+uRAas8MXE+U73roHocrTuUpPQ5wFfOG2+XetmYaXa
        aeaWIDhrBZDF5E9Glv264OMmMKrY9O7JEzksGxb6eNW7xbeEEtuqHyXUhCYPtbJGGI9iRjogB/Quq
        keArqh6w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8NCe-00F2gn-Vm; Tue, 27 Jul 2021 13:33:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9440430005A;
        Tue, 27 Jul 2021 15:33:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7CF92213986E4; Tue, 27 Jul 2021 15:33:00 +0200 (CEST)
Date:   Tue, 27 Jul 2021 15:33:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, bristot@redhat.com,
        bsegall@google.com, dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
Message-ID: <YQALDHw7Cr+vbeqN@hirez.programming.kicks-ass.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723093523.GX3809@techsingularity.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 10:35:23AM +0100, Mel Gorman wrote:
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 44c452072a1b..ddc0212d520f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  			se = second;
>  	}
>  
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> +	if (cfs_rq->next &&
> +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
>  		/*
>  		 * Someone really wants this to run. If it's not unfair, run it.
>  		 */

With a little more context this function reads like:

	se = left;

	if (cfs_rq->skip && cfs_rq->skip == se) {
		...
+		if (cfs_rq->next && (cfs_rq->skip == left || ...))

If '...' doesn't change @left (afaict it doesn't), then your change (+)
is equivalent to '&& true', or am I reading things wrong?
