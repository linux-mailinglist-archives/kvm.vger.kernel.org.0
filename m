Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF66C48EE19
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243353AbiANQai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiANQah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:30:37 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90006C061574;
        Fri, 14 Jan 2022 08:30:37 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so22555173pja.1;
        Fri, 14 Jan 2022 08:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=McBFRt0xW8oYX4Ag1XsMER97DYFpCs3j7XG1ixU4FDo=;
        b=a9EtpM5fZyStOorZ4XyDyPTTWIeWJp1m8rgkblkXI5QBqLyAlDS/obdGP5LXqJFSow
         8jsE4B0lacFd6PDobxJQvYbHD4LbtZMs8mDWi8mUGjVis9URF6QoLBaDQt7qRfKmXDlO
         y5li58aUPUzGbX+fndZEpo/2O5/QaD4bx9dTWoJFvua9UJp0UhNcjRjbSdG+sBkeRemN
         jj+rCUF8G/zyfGHLNeYnZqAKzVvgx2YTM9Yow8dcg5y6LhH1dr9S7E+2EQQ5v9H9bcHh
         bhCa+ZRyNhFuzP/4I4CFRWYZ7baOQtlV1HhUt+SRvfA1/CgwR38MDGkr3Bpr6hE7GKyK
         GRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=McBFRt0xW8oYX4Ag1XsMER97DYFpCs3j7XG1ixU4FDo=;
        b=zkS1/+ISaEly+kBEEnygW9RTZjM5+EU4FyC4m5L9tkNZ7FZbiSuuNt9hvA0DLj+qds
         KqYOX4mQFPd4Dc7+oelyDwybcjZEpAiKHyPh5opcfsjI0OKhbpzcIBiJMBY5fynN8KNa
         BxAIiemog21tmsopzlY5Uo/eXHep9w8GNaYjDK8uhaSZAfxA9VAmjTmsrV5n3rkI5xMw
         TiHo+5Ex26CPonZ4u/+LRugJ5M49YbuDYgY0mLkKsU36S1cnI/Lh1W/L8nnQa2eooJWr
         3YFxmKGEbtjohXDPlw2QPpBMSytSiJPZlK0nAD5E9/7cTzvW3qlklPQpvM1f7wNpWjE8
         oJtg==
X-Gm-Message-State: AOAM530j4DiHRK7LUsLqbq9uZ5tkbhaNw6uHHFcIkRpkrdPYvs3OKbpI
        UvLYCZ0Ff1HVLT+D1+e7Xgc=
X-Google-Smtp-Source: ABdhPJxwZCKfDpKHDsHA7rXcy07S2mA0pBNMbPGORichSXE9GoyQYoxfKOZ7tLi1iPJ6nMjhSYNkpg==
X-Received: by 2002:a17:90a:748:: with SMTP id s8mr334066pje.139.1642177836736;
        Fri, 14 Jan 2022 08:30:36 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id z16sm5017479pgi.89.2022.01.14.08.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:30:36 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 14 Jan 2022 06:30:34 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
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
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-mm@kvack.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC 15/16] sched/fair: Account kthread runtime debt for CFS
 bandwidth
Message-ID: <YeGlKpumqRxT9L7A@slm.duckdns.org>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Fri, Jan 14, 2022 at 10:31:55AM +0100, Peter Zijlstra wrote:
> So part of the problem I have with this is that these external things
> can consume all the bandwidth and basically indefinitely starve the
> group.
> 
> This is doulby so if you're going to account things like softirq network
> processing.

So, anything which is accounted this way should slow down / stall the
originator so that backcharges can't run away. In many cases, these
connections are already there - e.g. if you keep charging socket rx buffers
to a cgroup, the processes in the cgroup will slow down and the backpressure
on the network socket will slow down the incoming packets. Sometimes, the
backpressure propagation needs to be added explicitly - e.g. filesystem
metadata writes can run away because something can keeping on issuing
metadata updates without getting throttled neither on memory or io side. So,
for situations like that, we need to add an explicit mechanism to throttle
the originator asynchronously.

Thanks.

-- 
tejun
