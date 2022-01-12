Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D677E48CD02
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357453AbiALUST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 15:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357421AbiALUST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 15:18:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EB7C06173F;
        Wed, 12 Jan 2022 12:18:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id pf13so7437233pjb.0;
        Wed, 12 Jan 2022 12:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2RtAa5Tk2Vk+PL4X9zkXj+Jm0en8y5bHa3POmWQqDmY=;
        b=PGiOz4Pn3lfF5kZT/ZxEgKKs4SxzIuVKwFsMbVvEFlCHq54QtehYcYAKcRhwYnUjNa
         Uq9Rqag7jay8Wt/XY6n0xDmI8z+20UV6Y2CJWTzHrjyxcyHEAFZg8iUhJDCO2NlpH+2j
         MmUtBDe6rc9rbX/ajjV3vaXnwYpEuYmdOQ0RtKjHPkmf7dgQBNhTjVuhOYM+MFU1ZKlv
         kv3XNWJCFwcOdOWJ5S2ox+4pAvezLj4cYMMdf1W5QXLq8Df/UrzNs7wp7bh+u0FHVh35
         7wLZPNOg9Sua/QvMQaRP3XnaWOVvKoh1Ep+csm19ZhTXVF//uat3XMYFdaGRO/1YedO7
         1BXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2RtAa5Tk2Vk+PL4X9zkXj+Jm0en8y5bHa3POmWQqDmY=;
        b=Y7K7h8cvAKi/tY1SmY8CV7yDOG6wa48qcQa4v2XBNASlVsu5TgBzp8U9jrZDIQvwM/
         3kI7Ee1t5ULVwRKVFAmDyZPeWtB5gqgcO6YINI5tE1ym961ALuEtTvKPlJIGvo4jzY6k
         9bvvM9niCPYHt//xtZSxKi2NGcTtuF/bpmcaUDhIjsd86fJYi26nKoYHxR+xLFcGL7DA
         OZ7sofRc7eV0kKAMTIO//rJcKIFxx5Gt+4AFatbal/2qCNA0Wy7XXzTSX1/KxEJczbd9
         pblurcySnxPTC0XZ17T2D+NRQR1ZjkEAZXE1YVPmcwwBSxnMuYeWU2m2TyQHRtm5WqYP
         eYwQ==
X-Gm-Message-State: AOAM53336WNnn37H+cU3mgYkanwMhmdY2qrjT0VOjce/X/eehgaPVdxo
        h+1o9KzX5zYhYPUL/qXHHdg=
X-Google-Smtp-Source: ABdhPJwGdSwQ6EmqzwAY4C0hc5kulNjebeiiOGYrfa1wkEy/9k+WhTGk13xQcx5lUvKicBdEFuDfPQ==
X-Received: by 2002:a17:90b:390b:: with SMTP id ob11mr10592937pjb.66.1642018698316;
        Wed, 12 Jan 2022 12:18:18 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id j22sm425668pfj.102.2022.01.12.12.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 12:18:17 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 12 Jan 2022 10:18:16 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <Yd83iDzoUOWPB6yH@slm.duckdns.org>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <Yd1w/TxTcGk5Ht53@hirez.programming.kicks-ass.net>
 <20220111162950.jk3edkm3nh5apviq@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111162950.jk3edkm3nh5apviq@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Jan 11, 2022 at 11:29:50AM -0500, Daniel Jordan wrote:
...
> This problem arises with multithreaded jobs, but is also an issue in other
> places.  CPU activity from async memory reclaim (kswapd, cswapd?[5]) should be
> accounted to the cgroup that the memory belongs to, and similarly CPU activity
> from net rx should be accounted to the task groups that correspond to the
> packets being received.  There are also vague complaints from Android[6].

These are pretty big holes in CPU cycle accounting right now and I think
spend-first-and-backcharge is the right solution for most of them given
experiences from other controllers. That said,

> Each use case has its own requirements[7].  In padata and reclaim, the task
> group to account to is known ahead of time, but net rx has to spend cycles
> processing a packet before its destination task group is known, so any solution
> should be able to work without knowing the task group in advance.  Furthermore,
> the CPU controller shouldn't throttle reclaim or net rx in real time since both
> are doing high priority work.  These make approaches that run kthreads directly
> in a task group, like cgroup-aware workqueues[8] or a kernel path for
> CLONE_INTO_CGROUP, infeasible.  Running kthreads directly in cgroups also has a
> downside for padata because helpers' MAX_NICE priority is "shadowed" by the
> priority of the group entities they're running under.
> 
> The proposed solution of remote charging can accrue debt to a task group to be
> paid off or forgiven later, addressing all these issues.  A kthread calls the
> interface
> 
>     void cpu_cgroup_remote_begin(struct task_struct *p,
>                                  struct cgroup_subsys_state *css);
> 
> to begin remote charging to @css, causing @p's current sum_exec_runtime to be
> updated and saved.  The @css arg isn't required and can be removed later to
> facilitate the unknown cgroup case mentioned above.  Then the kthread calls
> another interface
> 
>     void cpu_cgroup_remote_charge(struct task_struct *p,
>                                   struct cgroup_subsys_state *css);
> 
> to account the sum_exec_runtime that @p has used since the first call.
> Internally, a new field cfs_bandwidth::debt is added to keep track of unpaid
> debt that's only used when the debt exceeds the quota in the current period.
> 
> Weight-based control isn't implemented for now since padata helpers run at
> MAX_NICE and so always yield to anything higher priority, meaning they would
> rarely compete with other task groups.

If we're gonna do this, let's please do it right and make weight based
control work too. Otherwise, its usefulness is pretty limited.

Thanks.

-- 
tejun
