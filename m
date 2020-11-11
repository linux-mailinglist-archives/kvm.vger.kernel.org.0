Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB592AEC24
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 09:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKKIjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 03:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKKIjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 03:39:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C14AC0613D1;
        Wed, 11 Nov 2020 00:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=W3lJaiDZSwNSAcZaX98qdexwXd6h8lkb9yfjmwrRXNk=; b=ZsE/OpcOFZGT4E28OStxABf08B
        +HZ7yJo2mwOHaQqNSY+FgV2WtLq7ldZ3hlKzhxJbI71XJ0wuf+L+A2muDsx6LCBzcsBHzr47Kk86o
        6tLTYe7r2C3OggUGSUDEA7eQKDTDgTqp57LDTfBGGt0W1gP8ENEJ2NwPptTbS2ALiU28N+Vddac5b
        BuzVi4xwvwPrrNBhbBcdWgV4yenlZcJuanWhg5EbnIC9gsfN1jWnY0iKko43SStsj7wf4RtkVxNUF
        jkHLrtG432Vvmu68BfftOKuTuRVuw3y8NRcp+yIeH6Intuf8iLp4tAZqiV3s/hbAD8QEc8p8Gg5Eq
        TvMo+vzA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kclec-0000Er-Ia; Wed, 11 Nov 2020 08:38:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A984E301324;
        Wed, 11 Nov 2020 09:38:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 95C6929B3D8D2; Wed, 11 Nov 2020 09:38:57 +0100 (CET)
Date:   Wed, 11 Nov 2020 09:38:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Stephane Eranian <eranian@google.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
Message-ID: <20201111083857.GS2611@hirez.programming.kicks-ass.net>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
 <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 12:52:04PM -0800, Stephane Eranian wrote:

> What is implemented is Freeze-on-Overflow, yet it is described as Freeze-on-PMI.
> That, in itself, is a problem. I agree with you on that point.

Exactly.

> However, there are use cases for both modes.
> 
> I can sample on event A and count on B, C and when A overflows, I want
> to snapshot B, C.
> For that I want B, C at the moment of the overflow, not at the moment
> the PMI is delivered. Thus, youd
> would want the Freeze-on-overflow behavior. You can collect in this
> mode with the perf tool,
> IIRC: perf record -e '{cycles,instructions,branches:S}' ....

Right, but we never supported that. Also, in that case the group must
then be fully exlusive so as not to mess with other groups. A better
solution might be an extention to Adaptive PEBS.

> The other usage model is that of the replay-debugger (rr) which you are alluding
> to, which needs precise count of an event including during the skid
> window. For that, you need
> Freeze-on-PMI (delivered). Note that this tool likely only cares about
> user level occurrences of events.

Correct, RR only cares about user-only counting.

> As for counter independence, I am not sure it holds in all cases. If
> the events are setup for user+kernel

This is true; however if it were an actual Freeze-on-PMI we could
actually do u+k independence correctly too.


Anyway, as it stands I think the whole counter_freezing thing is a
trainwreck and it needs to go.
