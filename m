Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E6148E7B0
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 10:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiANJkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 04:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiANJko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 04:40:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96204C061574;
        Fri, 14 Jan 2022 01:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qv7o7OYRZZ4rZLcvwJ7bYFuvssGmEGjJm6oL8qmozjM=; b=QnytaVkzeW+ITsuroNUZ4bA9aM
        a1lP6RQproSsli+QqaxifOPYiXnJUNVwMn1ibHVXIQyXBunu1eXcPXVLwt/abd/QnDUvcv9kwBuFa
        I6e0jlhjrzmRpX/ltQGAOj2ViNWC8bZKJONvoDhk4OBv1KOszfrX6LPx6GjiM2lfjSqNUjavjFwEJ
        2TSDw0/xGQhSLgKrcxCOvHF1UfFgVT5ZzjKY/7M4MZOUmBLeg55598jodeD8D2+Gz/521Gtu8tRqx
        2aWMic/+VOU2FcJnHNkB4nuaOSwM73elrE/xrL81GHPrAqggNvQUU/7PVzfMQJ+mtZbWkfZXrJZeZ
        T6iMdkTw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n8J43-005gxp-V2; Fri, 14 Jan 2022 09:40:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 360913002C1;
        Fri, 14 Jan 2022 10:40:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E0993203C1C62; Fri, 14 Jan 2022 10:40:06 +0100 (CET)
Date:   Fri, 14 Jan 2022 10:40:06 +0100
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
Message-ID: <YeFE9j4Qynp9sNXS@hirez.programming.kicks-ass.net>
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

On Fri, Jan 14, 2022 at 10:31:55AM +0100, Peter Zijlstra wrote:

> Also, by virtue of this being a start-stop annotation interface, the
> accrued time might be arbitrarily large and arbitrarily delayed. I'm not
> sure that's sensible.
> 
> For tasks it might be better to mark the task and have the tick DTRT
> instead of later trying to 'migrate' the time.

Which is then very close to simply sticking the task into the right
cgroup for a limited duration.

You could do a special case sched_move_task(), that takes a css argument
instead of using the current task_css. Then for cgroups it looks like
nothing changes, but the scheduler will DTRT and act like it is in the
target cgroup. Then at the end, simply move it back to task_css.

This obviously doesn't work for SoftIRQ accounting, but that is
'special' anyway. Softirq stuff is not otherwise under scheduler
control and has preemption disabled.
