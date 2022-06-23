Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05F5589D1
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiFWUHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWUHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:07:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD311582B
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:07:05 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id jh14so213845plb.1
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iv5jva5TUOt2ku2nB7C0OTsUP7d83IExGKqGEiymvsc=;
        b=e1F6IgK+yYSsHs8pHQthv2V6RjdQQldw5p5m1hjIJdzXou3wx7+X4vB23gfg5Hwmgc
         AY/p1NkQWT6Xv76NktOc7f49to6KwwLUZsTKaxW8DpsjtfWPo9BjR6HPlgNdE3W0ddvW
         Z0gwq4RYiXQPgDLn6AO5FUfjWPEpD0JpLU3ydxlfIoOTWVO0zzWvnu8enNYS1jIvQ8G9
         Au+Q7jZfh2S2qABO1HrBiXSi23MpL8HpwONA2bwCIwA7C28d5rAjm1Unc7xcJUaQ//ui
         nAr/4XQUU7S9+1TeBPY39D7mexDzfj95Zi6CWTthGSWUDYIGMbTyzsVkRfLPuGsP71c7
         tP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iv5jva5TUOt2ku2nB7C0OTsUP7d83IExGKqGEiymvsc=;
        b=i5e2IA8k5HOTbr2mxElWmEWl+RUlwRe8KmnUBDXUUhKggej+YFBdXSOMN3LruYwqPY
         vBlI8NONCTlLLM1s6EA8GrjHB9+s0n3RqegGCMpnFtHgjyP+FUrGO0rl9StStsrvyyVx
         bgIXlHl2agSYaK754xWau8doxHyDubqeyg5+/Rn0h5m1LydV4cGrSN7BViE3McTqXl1O
         txaykQ2U4I3Ra9U22J4qnb9XkkCCh2iHu8O5llt8Eo2+Tj+f9KOrk1fi3ec1Cqq2BmGC
         qzab9DnOF5dwRk4S0XywbQA6Y/thAG0QpTDE+/oALZVWDwbshV+6ebCzD8cmbfk78tWs
         b9uw==
X-Gm-Message-State: AJIora+UTVwO4lu1Pivaqw4d7TypaIvEx5XiOyBMVWMhegWx/7S6WOxn
        1euVjamtrPfPjDl+WRiTo6FtA0YneRjGQA==
X-Google-Smtp-Source: AGRyM1t7UmjSfrw8HFzilsNA3C/f4EmxNXPzQ2pS+mk2EDomXk1Yc1oDdfr7iKBQ0z8tLOvc9qqoRw==
X-Received: by 2002:a17:90b:4a92:b0:1e8:2c09:d008 with SMTP id lp18-20020a17090b4a9200b001e82c09d008mr5734848pjb.169.1656014824610;
        Thu, 23 Jun 2022 13:07:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w16-20020a1709026f1000b0016160b3331bsm168701plk.305.2022.06.23.13.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:07:04 -0700 (PDT)
Date:   Thu, 23 Jun 2022 20:07:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] kvm/x86: Allow to respond to generic signals during
 slow page faults
Message-ID: <YrTH5ARKVEmy1bUj@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-5-peterx@redhat.com>
 <YrR8sKap6KHT22Dx@google.com>
 <YrS/kegBGqsSLO7y@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrS/kegBGqsSLO7y@xz-m1.local>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022, Peter Xu wrote:
> Hi, Sean,
> 
> On Thu, Jun 23, 2022 at 02:46:08PM +0000, Sean Christopherson wrote:
> > On Wed, Jun 22, 2022, Peter Xu wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e92f1ab63d6a..b39acb7cb16d 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > >  			       unsigned int access)
> > >  {
> > > +	/* NOTE: not all error pfn is fatal; handle intr before the other ones */
> > > +	if (unlikely(is_intr_pfn(fault->pfn))) {
> > > +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> > > +		++vcpu->stat.signal_exits;
> > > +		return -EINTR;
> > > +	}
> > > +
> > >  	/* The pfn is invalid, report the error! */
> > >  	if (unlikely(is_error_pfn(fault->pfn)))
> > >  		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
> > > @@ -4017,6 +4024,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > >  		}
> > >  	}
> > >  
> > > +	/* Allow to respond to generic signals in slow page faults */
> > 
> > "slow" is being overloaded here.  The previous call __gfn_to_pfn_memslot() will
> > end up in hva_to_pfn_slow(), but because of passing a non-null async it won't wait.
> > This code really should have a more extensive comment irrespective of the interruptible
> > stuff, now would be a good time to add that.
> 
> Yes I agree, especially the "async" parameter along with "atomic" makes it
> even more confusing as you said.  But isn't that also means the "slow" here
> is spot-on?  I mean imho it's the "elsewhere" needs cleanup not this
> comment itself since it's really stating the fact that this is the real
> slow path?

No, because atomic=false here, i.e. KVM will try hva_to_pfn_slow() if hva_to_pfn_fast()
fails.  So even if we agree that the "wait for IO" path is the true slow path,
when reading KVM code the vast, vast majority of developers will associate "slow"
with hva_to_pfn_slow().

> Or any other suggestions greatly welcomed on how I should improve this
> comment.

Something along these lines?

	/*
	 * Allow gup to bail on pending non-fatal signals when it's also allowed
	 * to wait for IO.  Note, gup always bails if it is unable to quickly
	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
	 */
> 
> > 
> > Comments aside, isn't this series incomplete from the perspective that there are
> > still many flows where KVM will hang if gfn_to_pfn() gets stuck in gup?  E.g. if
> > KVM is retrieving a page pointed at by vmcs12.
> 
> Right.  The thing is I'm not confident I can make it complete easily in one
> shot..
> 
> I mentioned some of that in cover letter or commit message of patch 1, in
> that I don't think all the gup call sites are okay with being interrupted
> by a non-fatal signal.
> 
> So what I want to do is doing it step by step, at least by introducing
> FOLL_INTERRUPTIBLE and having one valid user of it that covers a very valid
> use case.  I'm also pretty sure the page fault path is really the most
> cases that will happen with GUP, so it already helps in many ways for me
> when running with a patched kernel.
> 
> So when the complete picture is non-trivial to achieve in one shot, I think
> this could be one option we go for.  With the facility (and example code on
> x86 slow page fault) ready, hopefully we could start to convert many other
> call sites to be signal-aware, outside page faults, or even outside x86,
> because it's really a more generic problem, which I fully agree.
> 
> Does it sound reasonable to you?

Yep.  In fact, I'd be totally ok keeping this to just the page fault path.  I
missed one cruicial detail on my first read through: gup already bails on SIGKILL,
it's only these technically-not-fatal signals that gup ignores by default.  In
other words, using FOLL_INTERRUPTIBLE is purely opportunsitically as userspace
can always resort to SIGKILL if the VM really needs to die.

It would be very helpful to explicit call that out in the changelog, that way
it's (hopefully) clear that KVM uses FOLL_INTERRUPTIBLE to be user friendly when
it's easy to do so, and that it's not required for correctness/robustness.
