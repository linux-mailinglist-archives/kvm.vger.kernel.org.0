Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E48648AD29
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 12:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239003AbiAKL7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 06:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiAKL7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 06:59:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF377C06173F;
        Tue, 11 Jan 2022 03:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=L90dZXr+DchG0EERWhDGtHsJnyZXsrxTqBwOQGncg8Q=; b=SoTdUUyLlm0b3pZIpOMczUxg/U
        xJbtK0g+lu8BnWTD214WLoFzAQKb9gxtskfxFKvLcXy/J3ww+3uMdEDygFIA1epmBjKtSy8Hs85ef
        cNAfn+nm8dMuuOAzB5oRHc4+JgVJUpODgEfHI8npUAQNIy7rnRgf+OpHn9agoozCFC+0ZovL1vcP2
        9Xkuo0ZEy/cHKGNwt3GaA4fFE60C+lK3kvQjN+1Zl+XOy52ODKcFEKA3VMMv4pMpLC7UQep2R8auq
        Xw+1/sNbQmmr2In80BNcSG0MrBHplHV3Yx9T3L5RF7nnlw7zF07qsrKCoZNM2/gBfu1lvG1O3rh+P
        f58fiK8g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7Fnj-003DIw-Ch; Tue, 11 Jan 2022 11:58:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6ABDC3002C5;
        Tue, 11 Jan 2022 12:58:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 25934203E80F6; Tue, 11 Jan 2022 12:58:53 +0100 (CET)
Date:   Tue, 11 Jan 2022 12:58:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Segall <bsegall@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        Tejun Heo <tj@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106004656.126790-16-daniel.m.jordan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 05, 2022 at 07:46:55PM -0500, Daniel Jordan wrote:
> As before, helpers in multithreaded jobs don't honor the main thread's
> CFS bandwidth limits, which could lead to the group exceeding its quota.
> 
> Fix it by having helpers remote charge their CPU time to the main
> thread's task group.  A helper calls a pair of new interfaces
> cpu_cgroup_remote_begin() and cpu_cgroup_remote_charge() (see function
> header comments) to achieve this.
> 
> This is just supposed to start a discussion, so it's pretty simple.
> Once a kthread has finished a remote charging period with
> cpu_cgroup_remote_charge(), its runtime is subtracted from the target
> task group's runtime (cfs_bandwidth::runtime) and any remainder is saved
> as debt (cfs_bandwidth::debt) to pay off in later periods.
> 
> Remote charging tasks aren't throttled when the group reaches its quota,
> and a task group doesn't run at all until its debt is completely paid,
> but these shortcomings can be addressed if the approach ends up being
> taken.
> 

*groan*... and not a single word on why it wouldn't be much better to
simply move the task into the relevant cgroup..
