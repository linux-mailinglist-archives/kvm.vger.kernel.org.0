Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399063D76E7
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhG0Nfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 09:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhG0Nfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 09:35:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F92C061757;
        Tue, 27 Jul 2021 06:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FfyHKXilEVpvQwZNUQeVcTBtETi4MM5qnXqsygqJ5GM=; b=clx/HWdtuYepQP+w777uZzHziW
        hJ0u9tgrLOXfZAeH9tArRyAk8l2dGOF70RZ9q0ewZI13VNqKP+1AiS7SYWLkB3ckl7g2eS6GNzERU
        frWGN/FlQQhkAxnX/J11GQ1cTDFE8KZdZ4q9/f7Mw8Vp0GaVQ1Yrytu+DDRQxj0Y6u58E/vOSeJyy
        WZg/JqJEkd7GDsijv8jIlzp4luPxFiu9haUZu4Y6uY4zcEND2L2UEhnpS6d1XTS3ZV1HbyB9W/3HY
        dH4PdLqYtLaGi56pJA3mtqQUcz2RC/P5O61vGpO9NYfgpn9/Qfj/52z5xtp0e3BB1HkyxA00Yy2xl
        p1++rhAg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8N9X-00F2SB-AH; Tue, 27 Jul 2021 13:31:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2E40A300233;
        Tue, 27 Jul 2021 15:29:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E9F982C85C9EB; Tue, 27 Jul 2021 15:29:44 +0200 (CEST)
Date:   Tue, 27 Jul 2021 15:29:44 +0200
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
Message-ID: <YQAKSO759lvZurgw@hirez.programming.kicks-ass.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
 <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
 <20210723162137.GY3809@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723162137.GY3809@techsingularity.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 05:21:37PM +0100, Mel Gorman wrote:

> I'm still not a fan because vruntime gets distorted. From the docs
> 
>    Small detail: on "ideal" hardware, at any time all tasks would have the same
>    p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
>    would ever get "out of balance" from the "ideal" share of CPU time
> 
> If yield_to impacts this "ideal share" then it could have other
> consequences.

Note that we already violate this ideal both subtly and explicitly.

For an example of the latter consider pretty much the entirety of
place_entity() with GENTLE_FAIR_SLEEPERS being the most egregious
example.

That said; adding to vruntime will only penalize the task itself, while
subtracting from vruntime will penalize everyone else. And in that sense
addition to vruntime is a safe option.

I've not fully considered the case at hand; just wanted to give some
context.
