Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C195589EA
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiFWUSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 16:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiFWUSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 16:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39FF126AEC
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656015494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D/1SGgS7UqOks1VSsH8z0y+t8W/VgcfJCo4UXbDDJys=;
        b=fsO3nPC3qPd2zyWdd+L1cZPjlDoMjXKOQTO8sic6pJtobbBNLH8S0u/JGgwUfvec2tnHnu
        vrtR3st9QQz0fvh9iJ4m7PY07YKaE7knqnksya6e5YmLoHlHWd18rVudHVqFzjJUgK7U20
        B8dMEmocygbJGnrdcHcAeYr4UlBskiI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-1wt8yPI9Pxy_oKs3l3P-hQ-1; Thu, 23 Jun 2022 16:18:13 -0400
X-MC-Unique: 1wt8yPI9Pxy_oKs3l3P-hQ-1
Received: by mail-io1-f69.google.com with SMTP id t11-20020a6bdb0b000000b00674fd106c0cso115694ioc.16
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 13:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D/1SGgS7UqOks1VSsH8z0y+t8W/VgcfJCo4UXbDDJys=;
        b=Ynj3FY2os8FcpmH0oP/X6lWDkhnoEP8vAvPMXy2Q+Oaw+fMgHDnhiIzQxwb0s5tTn8
         nDAemnAI5g0qK6d5s2AuUJ6tZNTFeasFBsiKpAalKWmGN7X1IJgPHGvamLQNfbkYNpva
         xQj3EirtPxyR2Xh/cuCTWNtPseI8NDtmSfb4CEhLBl2TT6GSEDgBX11/7HPdUAGjvlav
         9MMUZN97QMydpZgxwp/Vj5ZF6KXtR10VDPBIizcxymnX4phJhNNbp+j9eeab0XHQvo8b
         x86bj/+buiSDY5rK2n7TqNMOu7jsSvC5ayHKZdXb4wYS2DNvOQE6Qlmlt+GcnzLpl21I
         lJzw==
X-Gm-Message-State: AJIora+aS50S4yaUj2Ef6SXpq8IpsNkekXMFw5Eegizk0AUnZ/bowwWX
        hlMIqeDY7P6XNO4bL9vBe5fqSRjLDlJUCH4h+qMFnEAOkDgA2g3m4oJKAMwdak8e69hmOOBHbM+
        vRJEq/oQ3MdFy
X-Received: by 2002:a05:6e02:1bc6:b0:2d3:dba7:f626 with SMTP id x6-20020a056e021bc600b002d3dba7f626mr6366433ilv.299.1656015492471;
        Thu, 23 Jun 2022 13:18:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uo4C7ez/iBecC3OJ//ZRyob4/ITiRBgoiX4i17BPRQRzlcyu7fAx97fpSFztFuDnOm/w4PUQ==
X-Received: by 2002:a05:6e02:1bc6:b0:2d3:dba7:f626 with SMTP id x6-20020a056e021bc600b002d3dba7f626mr6366425ilv.299.1656015492238;
        Thu, 23 Jun 2022 13:18:12 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id u10-20020a02b1ca000000b00339da678a7csm158539jah.78.2022.06.23.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:18:11 -0700 (PDT)
Date:   Thu, 23 Jun 2022 16:18:09 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] kvm/x86: Allow to respond to generic signals during
 slow page faults
Message-ID: <YrTKgSPBRBKDaw3E@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-5-peterx@redhat.com>
 <YrR8sKap6KHT22Dx@google.com>
 <YrS/kegBGqsSLO7y@xz-m1.local>
 <YrTH5ARKVEmy1bUj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrTH5ARKVEmy1bUj@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 08:07:00PM +0000, Sean Christopherson wrote:
> On Thu, Jun 23, 2022, Peter Xu wrote:
> > Hi, Sean,
> > 
> > On Thu, Jun 23, 2022 at 02:46:08PM +0000, Sean Christopherson wrote:
> > > On Wed, Jun 22, 2022, Peter Xu wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index e92f1ab63d6a..b39acb7cb16d 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> > > >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> > > >  			       unsigned int access)
> > > >  {
> > > > +	/* NOTE: not all error pfn is fatal; handle intr before the other ones */
> > > > +	if (unlikely(is_intr_pfn(fault->pfn))) {
> > > > +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> > > > +		++vcpu->stat.signal_exits;
> > > > +		return -EINTR;
> > > > +	}
> > > > +
> > > >  	/* The pfn is invalid, report the error! */
> > > >  	if (unlikely(is_error_pfn(fault->pfn)))
> > > >  		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
> > > > @@ -4017,6 +4024,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > > >  		}
> > > >  	}
> > > >  
> > > > +	/* Allow to respond to generic signals in slow page faults */
> > > 
> > > "slow" is being overloaded here.  The previous call __gfn_to_pfn_memslot() will
> > > end up in hva_to_pfn_slow(), but because of passing a non-null async it won't wait.
> > > This code really should have a more extensive comment irrespective of the interruptible
> > > stuff, now would be a good time to add that.
> > 
> > Yes I agree, especially the "async" parameter along with "atomic" makes it
> > even more confusing as you said.  But isn't that also means the "slow" here
> > is spot-on?  I mean imho it's the "elsewhere" needs cleanup not this
> > comment itself since it's really stating the fact that this is the real
> > slow path?
> 
> No, because atomic=false here, i.e. KVM will try hva_to_pfn_slow() if hva_to_pfn_fast()
> fails.  So even if we agree that the "wait for IO" path is the true slow path,
> when reading KVM code the vast, vast majority of developers will associate "slow"
> with hva_to_pfn_slow().

Okay.  I think how we define slow matters, here my take is "when a major
fault happens" (as defined in the mm term), but probably that definition is
a bit far away from kvm as the hypervisor level indeed.

> 
> > Or any other suggestions greatly welcomed on how I should improve this
> > comment.
> 
> Something along these lines?
> 
> 	/*
> 	 * Allow gup to bail on pending non-fatal signals when it's also allowed
> 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
> 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
> 	 */

Taken.

> > 
> > > 
> > > Comments aside, isn't this series incomplete from the perspective that there are
> > > still many flows where KVM will hang if gfn_to_pfn() gets stuck in gup?  E.g. if
> > > KVM is retrieving a page pointed at by vmcs12.
> > 
> > Right.  The thing is I'm not confident I can make it complete easily in one
> > shot..
> > 
> > I mentioned some of that in cover letter or commit message of patch 1, in
> > that I don't think all the gup call sites are okay with being interrupted
> > by a non-fatal signal.
> > 
> > So what I want to do is doing it step by step, at least by introducing
> > FOLL_INTERRUPTIBLE and having one valid user of it that covers a very valid
> > use case.  I'm also pretty sure the page fault path is really the most
> > cases that will happen with GUP, so it already helps in many ways for me
> > when running with a patched kernel.
> > 
> > So when the complete picture is non-trivial to achieve in one shot, I think
> > this could be one option we go for.  With the facility (and example code on
> > x86 slow page fault) ready, hopefully we could start to convert many other
> > call sites to be signal-aware, outside page faults, or even outside x86,
> > because it's really a more generic problem, which I fully agree.
> > 
> > Does it sound reasonable to you?
> 
> Yep.  In fact, I'd be totally ok keeping this to just the page fault path.  I
> missed one cruicial detail on my first read through: gup already bails on SIGKILL,
> it's only these technically-not-fatal signals that gup ignores by default.  In
> other words, using FOLL_INTERRUPTIBLE is purely opportunsitically as userspace
> can always resort to SIGKILL if the VM really needs to die.
> 
> It would be very helpful to explicit call that out in the changelog, that way
> it's (hopefully) clear that KVM uses FOLL_INTERRUPTIBLE to be user friendly when
> it's easy to do so, and that it's not required for correctness/robustness.

Yes that's the case, sigkill is special. I can mention that somewhere in
the cover letter too besides the comment you suggested above.  Thanks,

-- 
Peter Xu

