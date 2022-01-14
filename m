Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD70048EE52
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbiANQiM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiANQiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:38:12 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75500C061574;
        Fri, 14 Jan 2022 08:38:11 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m21so3204980pfd.3;
        Fri, 14 Jan 2022 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UdAhn1yP8utSK2rJWKDnZNaAaZ8ZXIqz54JjwpJvgpQ=;
        b=FQVcQ0AcdShPy4qgO3i9uPzOtqze3SVxLhUjkznY3+NjqH5zxeeYYcdHlyORH7YzCJ
         eaeps+kM4+knX1Tt+p6X+l2Z1osOl+3/oB4Asy3CDb+L/uQjrplvtjr6Or1cmFQ3oMZW
         +mKI3MVFc3Y4lWRTRk+6hwx03WI4CGPgfjOsWGMMtmzJcFLixgCcJIwY9tIg9PgfhgKz
         iCm4pDLp9JT59E3Vz1FUfKGDOaj2HF+NOVuIZUQaVBoVd4ZOn9YAowHCHFmw8k7eTZ72
         WU/1o6ohDldo/9Dkzqpq2N6wnpSPDqxBWELYegHy6Sm3yvg234/ckkpMlNEfbF7RX66D
         VC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=UdAhn1yP8utSK2rJWKDnZNaAaZ8ZXIqz54JjwpJvgpQ=;
        b=ndbtu2K/gkpWRkp7aXTOqJs+njwSq7Xjxm8NYVwXOLLrX+EJ0oA7fWfitFH0P70fqe
         MJncsXL3w5NznOhzHYNL8Ov3strVfEfmsuk1BXOtnQGUn1u6XB/Inq9EGMFV6+q2atLj
         LIaA8g5dxMsR0L5cYkXOL8Yd/lrwtAlwbVICr/Q/ahw4AKn3dJZMWnF/S+bPKzwQX9s4
         mmvwtmQVv3OGTqP3Elw6shDCzB+eKpOuKBeCgZp5PbwG1SDeEX1zE0zub3ZOf8I1LPlF
         ejpa3RZYTSE9PjMRiQ/LTw6lZxV+LiMkKED7ncuT83QFAib6+sIUn5b45BBLt8ltqjIg
         B1Cg==
X-Gm-Message-State: AOAM533jJSgUrwHybEjLW/uPCoNyY9PTQmGZBTVBOmlaPcdxTtrBc/2E
        c7wo9gDGBBM1XiYqVRAUVJI=
X-Google-Smtp-Source: ABdhPJxiT42ScAmY7IPzWzRpYUt/AJjQ0wnb6ujH//Zxut8aB5TCaMGGIE6mc38OJ9xD1Lo5a5NA2A==
X-Received: by 2002:a65:6ab3:: with SMTP id x19mr8588083pgu.416.1642178290941;
        Fri, 14 Jan 2022 08:38:10 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id w64sm636354pfd.0.2022.01.14.08.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:38:10 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 14 Jan 2022 06:38:09 -1000
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
Message-ID: <YeGm8cbX6Krw+O3o@slm.duckdns.org>
References: <20220106004656.126790-1-daniel.m.jordan@oracle.com>
 <20220106004656.126790-16-daniel.m.jordan@oracle.com>
 <YeFDC0mV3yurUFbl@hirez.programming.kicks-ass.net>
 <YeFE9j4Qynp9sNXS@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFE9j4Qynp9sNXS@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Fri, Jan 14, 2022 at 10:40:06AM +0100, Peter Zijlstra wrote:
> You could do a special case sched_move_task(), that takes a css argument
> instead of using the current task_css. Then for cgroups it looks like
> nothing changes, but the scheduler will DTRT and act like it is in the
> target cgroup. Then at the end, simply move it back to task_css.
> 
> This obviously doesn't work for SoftIRQ accounting, but that is
> 'special' anyway. Softirq stuff is not otherwise under scheduler
> control and has preemption disabled.

So, if this particular use case doesn't fit the backcharge model (I'm not
sure yet). I'd much prefer it to maintain dynamic per-cgroup helper threads
than move tasks around dynamically. Nothing else is using migration this way
and we don't even need migration for seeding cgroups w/ CLONE_INTO_CGROUP.
In the future, this should allow further optimizations and likely
simplifications. It'd suck to have an odd exception usage.

Thanks.

-- 
tejun
