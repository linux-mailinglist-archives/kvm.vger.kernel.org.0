Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509CD55894A
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiFWTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiFWTkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F248BC2
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 12:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656012694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nmEi4t1UpiJzBwiXbayrACz8FUOD/bWJxWRST4uLWCo=;
        b=IfzG2W1lyiuV4RSkqryDh7sGdubF2sPMIM0q27+ET0BFoY5e3E6S3EkLzkGa/yFMTHLZn+
        kKNts6p9uUor8e90Ag4FNQQ8yorFImES8VSjnPQqV02URHAAM9JElaSVkbnQqPfQy8fKmg
        2Z3wP0uhw6xaXkSTQyF2/uHk4ZhFrIM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-felfA_SIM6aW-2hvmVQhLA-1; Thu, 23 Jun 2022 15:31:32 -0400
X-MC-Unique: felfA_SIM6aW-2hvmVQhLA-1
Received: by mail-il1-f199.google.com with SMTP id d1-20020a923601000000b002d93c039d9fso17575ila.9
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 12:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nmEi4t1UpiJzBwiXbayrACz8FUOD/bWJxWRST4uLWCo=;
        b=WLINaE+U+e24Q5TzAsZaQk7TQ9uy1YpE5/nRW75X+5onTkWOe6XyJieyHMmhXjAUFG
         D3JrST4VfFGFgxZhWphHoYNvjaX3JGK3nnHxZi1BRGSyJl34jULWnhj62F6GYMfMqQf1
         WNyWBrZgEOP9HtI9s2Hyuu0MGjVObf4MEaPSHtJuQmMcut+ZBSvvAwfSJ/A19xv2a18j
         hMrOhZRMok8j6umbIqzVrZicXmnZtYaDnrOpbh/4DfORfAdtzMta/kfD9k/Pba3hoOad
         qg8oh68IREEr2nrbLDivjzeW3UthG+/BhWyfgukd5FhbcXnW1wUMGtduyHGMD7fuWf+8
         1fPA==
X-Gm-Message-State: AJIora+NQ0pVltCTG9wJU2QuVbrsdd/6X5UTkLy9z2lXlG+0iJVGUlqM
        XciBSUxo44ZMYwZLMi9yNismV8Jq2DJQ0hi+EWjaUF2EYmBeBtcb/5eI2ATMlQo4AINnm2r7b/Q
        ZuLWMkF5Mt8Qo
X-Received: by 2002:a6b:2c89:0:b0:669:aa1e:7790 with SMTP id s131-20020a6b2c89000000b00669aa1e7790mr5626168ios.49.1656012692235;
        Thu, 23 Jun 2022 12:31:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v539MBz3A8fODK2oWdbD7Ma53P7m9iR4VQcs8hRmUxYNEp/givO9aGTtS2tXnL4Aiqc6xjVg==
X-Received: by 2002:a6b:2c89:0:b0:669:aa1e:7790 with SMTP id s131-20020a6b2c89000000b00669aa1e7790mr5626159ios.49.1656012691992;
        Thu, 23 Jun 2022 12:31:31 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id w2-20020a92db42000000b002d91d4d8ae0sm193674ilq.20.2022.06.23.12.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:31:31 -0700 (PDT)
Date:   Thu, 23 Jun 2022 15:31:29 -0400
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
Message-ID: <YrS/kegBGqsSLO7y@xz-m1.local>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-5-peterx@redhat.com>
 <YrR8sKap6KHT22Dx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrR8sKap6KHT22Dx@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Sean,

On Thu, Jun 23, 2022 at 02:46:08PM +0000, Sean Christopherson wrote:
> On Wed, Jun 22, 2022, Peter Xu wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index e92f1ab63d6a..b39acb7cb16d 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3012,6 +3012,13 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
> >  static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  			       unsigned int access)
> >  {
> > +	/* NOTE: not all error pfn is fatal; handle intr before the other ones */
> > +	if (unlikely(is_intr_pfn(fault->pfn))) {
> > +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> > +		++vcpu->stat.signal_exits;
> > +		return -EINTR;
> > +	}
> > +
> >  	/* The pfn is invalid, report the error! */
> >  	if (unlikely(is_error_pfn(fault->pfn)))
> >  		return kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
> > @@ -4017,6 +4024,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  		}
> >  	}
> >  
> > +	/* Allow to respond to generic signals in slow page faults */
> 
> "slow" is being overloaded here.  The previous call __gfn_to_pfn_memslot() will
> end up in hva_to_pfn_slow(), but because of passing a non-null async it won't wait.
> This code really should have a more extensive comment irrespective of the interruptible
> stuff, now would be a good time to add that.

Yes I agree, especially the "async" parameter along with "atomic" makes it
even more confusing as you said.  But isn't that also means the "slow" here
is spot-on?  I mean imho it's the "elsewhere" needs cleanup not this
comment itself since it's really stating the fact that this is the real
slow path?

Or any other suggestions greatly welcomed on how I should improve this
comment.

> 
> Comments aside, isn't this series incomplete from the perspective that there are
> still many flows where KVM will hang if gfn_to_pfn() gets stuck in gup?  E.g. if
> KVM is retrieving a page pointed at by vmcs12.

Right.  The thing is I'm not confident I can make it complete easily in one
shot..

I mentioned some of that in cover letter or commit message of patch 1, in
that I don't think all the gup call sites are okay with being interrupted
by a non-fatal signal.

So what I want to do is doing it step by step, at least by introducing
FOLL_INTERRUPTIBLE and having one valid user of it that covers a very valid
use case.  I'm also pretty sure the page fault path is really the most
cases that will happen with GUP, so it already helps in many ways for me
when running with a patched kernel.

So when the complete picture is non-trivial to achieve in one shot, I think
this could be one option we go for.  With the facility (and example code on
x86 slow page fault) ready, hopefully we could start to convert many other
call sites to be signal-aware, outside page faults, or even outside x86,
because it's really a more generic problem, which I fully agree.

Does it sound reasonable to you?

Thanks,

-- 
Peter Xu

