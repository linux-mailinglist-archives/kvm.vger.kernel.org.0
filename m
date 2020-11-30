Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA96A2C829E
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 11:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgK3Kuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 05:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgK3Kup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 05:50:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0785C0613CF;
        Mon, 30 Nov 2020 02:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AIVO2TFFZ6gXrvadr3YfinNxPmoHqYbfbKTZmCqeEyE=; b=ByhK66SAfuQQGbsjnwDNjfyO51
        JXES2lYxiweMt0ZkAgHngwLEtOtKZumXWpW6m8wZH5zFdXgBhUer2KwKQLEcOnDac+xC3n/+l2ERM
        Hdn7IwbXGj1b1zyB9fmevKxBSJ5OCNVjh/RQte91+nnZJ5D4bvpMybAieYJZtMBNdmWvnvkJn2K5l
        ZVdG92/6zOOp1pl08bRiT5iX6x43fO8WZW3CMrMBME2jYtTvTgtwBGDDi0qy7sl+uFePrOpK93Riu
        uUaL6/ZWWxPEdcD33h2pLbdOwU4j1l17lYakjltJnpvFXOIqkDttCAJa4GU7t+EGo1N8PEcpbPKPV
        iRHa5wlA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjgkT-0004V4-T2; Mon, 30 Nov 2020 10:49:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 490DD3003E1;
        Mon, 30 Nov 2020 11:49:35 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 28645200D4EEA; Mon, 30 Nov 2020 11:49:35 +0100 (CET)
Date:   Mon, 30 Nov 2020 11:49:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <20201130104935.GN3040@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
 <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
 <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
 <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
 <682011d8-934f-4c76-69b0-788f71d91961@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <682011d8-934f-4c76-69b0-788f71d91961@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 27, 2020 at 10:14:49AM +0800, Xu, Like wrote:

> > OK, but the code here wanted to inspect the guest DS from the host. It
> > states this is somehow complicated/expensive. But surely we can at the
> > very least map the first guest DS page somewhere so we can at least
> > access the control bits without too much magic.
> We note that the SDM has a contiguous present memory mapping
> assumption about the DS save area and the PEBS buffer area.
> 
> Therefore, we revisit your suggestion here and move it a bit forward:
> 
> When the PEBS is enabled, KVM will cache the following values:
> - gva ds_area (kvm msr trap)
> - hva1 for "gva ds_area" (walk guest page table)
> - hva2 for "gva pebs_buffer_base" via hva1 (walk guest page table)

What this [gh]va? Guest/Host Virtual Address? I think you're assuming I
know about all this virt crap,.. I don't.

> if the "gva ds_area" cache hits,

what?

> - access PEBS "interrupt threshold" and "Counter Reset[]" via hva1
> - get "gva2 pebs_buffer_base" via __copy_from_user(hva1)

But you already had hva2, so what's the point?

> if the "gva2 pebs_buffer_base" cache hits,

What?

> - we get "gva2 pebs_index" via __copy_from_user(hva2),

pebs_index is in ds_are, which would be hva1

> - rewrite the guest PEBS records via hva2 and pebs_index
> 
> If any cache misses, setup the cache values via walking tables again.
> 
> I wonder if you would agree with this optimization idea,
> we look forward to your confirmation for the next step.

I'm utterly confused. I really can't follow.
