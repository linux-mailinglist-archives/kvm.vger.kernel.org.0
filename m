Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A571CAE8E
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 15:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbgEHNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 09:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729949AbgEHNKh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 09:10:37 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6F3C05BD43;
        Fri,  8 May 2020 06:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=9fPfGBUeWH76iSErjKUiHDxoBdDt6EY4XksU520aETo=; b=s7KP3XCxpCx+K/Slw5SeghBHSX
        TwDFHErvrjxjAo0LAa20vuJ5CUoqLVW2GxY6UAsl/HND70HEQnUtYP9rnoF0yCY36kJVyRG59c/mE
        vTxDEZqi1rcZdyalffvFZVNlI3+6mQX2hNklBwG1Q46qE+VMjpG6ca9Zh4JOkAnXBGtw3hOmUceji
        EcriRSBQmV/kbrXCWHGZ8gQjmGa8imgUaQ+Xt7ZVjUOujiO5EfWLQCo5shW8djvF0CNj54jO/NR4p
        DNmAvxLY3gZIyOSdDO2qmu4gb4Ed/9jBxVN2yPyqJ49OdZWnisW17pdzAOdMebTsQAHOUt+mkorgl
        N8AILqaQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX2kw-0003No-Ks; Fri, 08 May 2020 13:09:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4404F30797E;
        Fri,  8 May 2020 15:09:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 282C82B8D7782; Fri,  8 May 2020 15:09:31 +0200 (CEST)
Date:   Fri, 8 May 2020 15:09:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.w.wang@intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH v10 08/11] KVM: x86/pmu: Add LBR feature emulation via
 guest LBR event
Message-ID: <20200508130931.GE5298@hirez.programming.kicks-ass.net>
References: <20200423081412.164863-1-like.xu@linux.intel.com>
 <20200423081412.164863-9-like.xu@linux.intel.com>
 <20200424121626.GB20730@hirez.programming.kicks-ass.net>
 <87abf620-d292-d997-c9be-9a5d2544f3fa@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87abf620-d292-d997-c9be-9a5d2544f3fa@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 11:16:40AM +0800, Like Xu wrote:
> On 2020/4/24 20:16, Peter Zijlstra wrote:

> > And I suppose that is why you need that horrible:
> > needs_guest_lbr_without_counter() thing to begin with.
> 
> Do you suggest to use event->attr.config check to replace
> "needs_branch_stack(event) && is_kernel_event(event) &&
> event->attr.exclude_host" check for guest LBR event ?

That's what the BTS thing does.

> > Please allocate yourself an event from the pseudo event range:
> > event==0x00. Currently we only have umask==3 for Fixed2 and umask==4
> > for Fixed3, given you claim 58, which is effectively Fixed25,
> > umask==0x1a might be appropriate.
> 
> OK, I assume that adding one more field ".config = 0x1a00" is
> efficient enough for perf_event_attr to allocate guest LBR events.

Uh what? The code is already setting .config. You just have to change it
do another value.

> > Also, I suppose we need to claim 0x0000 as an error, so that other
> > people won't try this again.
> 
> Does the following fix address your concern on this ?
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 2405926e2dba..32d2a3f8c51f 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -498,6 +498,9 @@ int x86_pmu_max_precise(void)
> 
>  int x86_pmu_hw_config(struct perf_event *event)
>  {
> +       if (!unlikely(event->attr.config & X86_ARCH_EVENT_MASK))
> +               return -EINVAL;
> +
>         if (event->attr.precise_ip) {
>                 int precise = x86_pmu_max_precise();

That wouldn't work right for AMD. But yes, something like that.

> > Also, what happens if you fail programming due to a conflicting cpu
> > event? That pinned doesn't guarantee you'll get the event, it just means
> > you'll error instead of getting RR.
> > 
> > I didn't find any code checking the event state.
> > 
> 
> Error instead of RR is expected.
> 
> If the KVM fails programming due to a conflicting cpu event
> the LBR registers will not be passthrough to the guest,
> and KVM would return zero for any guest LBR records accesses
> until the next attempt to program the guest LBR event.
> 
> Every time before cpu enters the non-root mode where irq is
> disabled, the "event-> oncpu! =-1" check will be applied.
> (more details in the comment around intel_pmu_availability_check())
> 
> The guests administer is supposed to know the result of guest
> LBR records is inaccurate if someone is using LBR to record
> guest or hypervisor on the host side.
> 
> Is this acceptable to you？
> 
> If there is anything needs to be improved, please let me know.

It might be nice to emit a pr_warn() or something on the host when this
happens. Then at least the host admin can know he wrecked things for
which guest.
