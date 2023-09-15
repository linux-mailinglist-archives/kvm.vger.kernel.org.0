Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE597A1265
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 02:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjIOAgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 20:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjIOAgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 20:36:17 -0400
X-Greylist: delayed 107615 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 14 Sep 2023 17:36:13 PDT
Received: from out-228.mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315E5269D
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 17:36:13 -0700 (PDT)
Date:   Fri, 15 Sep 2023 00:36:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694738171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Le1euXjuyATm+iKFXV8Nq4cU7P8ZVw3zL2AgCqC+74=;
        b=xUqQPORlOLQi1jtHKUkeo4SqsZBJJWfE/2cQhUzagdWuMvKntRopREk1HgKX2PZ1RPN4BF
        sFgHG8wWRdj3v07fKWXzgGHs932sljYChxo/Bl6MDjJHM2iLhs9O366CeDLSxq+uMB+Nfx
        zLSh9Cg+/4loiEufQAp8XLU4roVU328=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Message-ID: <ZQOm9gUo8un+claf@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <ZQHxm+L890yTpY91@linux.dev>
 <14eb2648eb594dd9a46a179733cee0df@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14eb2648eb594dd9a46a179733cee0df@huawei.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 09:47:48AM +0000, Shameerali Kolothum Thodi wrote:

[...]

> > What you're proposing here is complicated and I fear not easily
> > maintainable. Keeping the *two* sources of dirty state seems likely to
> > fail (eventually) with some very unfortunate consequences.
> 
> It does adds complexity to the dirty state management code. I have tried
> to separate the code path using appropriate FLAGS etc to make it more
> manageable. But this is probably one area we can work on if the overall
> approach does have some benefits.

I'd be a bit more amenable to a solution that would select either
write-protection or dirty state management, but not both.

> > The vCPU:memory ratio you're testing doesn't seem representative of what
> > a typical cloud provider would be configuring, and the dirty log
> > collection is going to scale linearly with the size of guest memory.
> 
> I was limited by the test setup I had. I will give it a go with a higher mem
> system. 

Thanks. Dirty log collection needn't be single threaded, but the
fundamental concern of dirty log collection time scaling linearly w.r.t.
the size to memory remains. Write-protection helps spread the cost of
collecting dirty state out across all the vCPU threads.

There could be some value in giving userspace the ability to parallelize
calls to dirty log ioctls to work on non-intersecting intervals.

> > Slow dirty log collection is going to matter a lot for VM blackout,
> > which from experience tends to be the most sensitive period of live
> > migration for guest workloads.
> > 
> > At least in our testing, the split GET/CLEAR dirty log ioctls
> > dramatically improved the performance of a write-protection based ditry
> > tracking scheme, as the false positive rate for dirtied pages is
> > significantly reduced. FWIW, this is what we use for doing LM on arm64 as
> > opposed to the D-bit implemenation that we use on x86.
> 
> Guess, by D-bit on x86 you mean the PML feature. Unfortunately that is
> something we lack on ARM yet.

Sorry, this was rather nonspecific. I was describing the pre-copy
strategies we're using at Google (out of tree). We're carrying patches
to use EPT D-bit for exitless dirty tracking.

> > Faster pre-copy performance would help the benchmark complete faster,
> > but the goal for a live migration should be to minimize the lost
> > computation for the entire operation. You'd need to test with a
> > continuous workload rather than one with a finite amount of work.
> 
> Ok. Though the above is not representative of a real workload, I thought
> it gives some idea on how "Guest up time improvement" is benefitting the
> overall availability of the workload during migration. I will check within our
> wider team to see if I can setup a more suitable test/workload to show some
> improvement with this approach. 
> 
> Please let me know if there is a specific workload you have in mind.

No objection to the workload you've chosen, I'm more concerned about the
benchmark finishing before live migration completes.

What I'm looking for is something like this:

 - Calculate the ops/sec your benchmark completes in steady state

 - Do a live migration and sample the rate throughout the benchmark,
   accounting for VM blackout time

 - Calculate the area under the curve of:

     y = steady_state_rate - live_migration_rate(t)

 - Compare the area under the curve for write-protection and your DBM
   approach.

> Thanks for getting back on this. Appreciate if you can do a quick glance
> through the rest of the patches as well for any gross errors especially with
> respect to page table walk locking, usage of DBM FLAGS etc.

I'll give it a read when I have some spare cycles. To be entirely clear,
I don't have any fundamental objections to using DBM for dirty tracking.
I just want to make sure that all alternatives have been considered
in the current scheme before we seriously consider a new approach with
its own set of tradeoffs.

-- 
Thanks,
Oliver
