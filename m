Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D987192C1
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 07:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjFAFyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 01:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjFAFx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 01:53:56 -0400
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3C4129
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 22:52:26 -0700 (PDT)
Date:   Thu, 1 Jun 2023 05:51:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685598704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kif2qeAXQCW7i+UsiaxamX1gDtjMAdvKI4QGcpfc7/o=;
        b=dJ86w/hbV9/J6uvQdQoPyEKC4c1xOpHUDVpxgpa1uRSFOYpU9UasHMZfxl9xInPH18XlsU
        /zgeuRpyAINH0GxgTMYJ6jhK6PZlYYsK+iJeueLzM3dxtfqGUQURoh1XoQt6mT8buM5Y9A
        6Zf90Wan+PZSA9f6oS8I7f0mIepA0IM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: selftests: Print summary stats of memory
 latency distribution
Message-ID: <ZHgx7GpYNoF/Go8O@linux.dev>
References: <20230327212635.1684716-1-coltonlewis@google.com>
 <20230327212635.1684716-3-coltonlewis@google.com>
 <ZHe1wEIYC6qsgupI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHe1wEIYC6qsgupI@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 02:01:52PM -0700, Sean Christopherson wrote:
> On Mon, Mar 27, 2023, Colton Lewis wrote:
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index f65e491763e0..d441f485e9c6 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -219,4 +219,14 @@ uint32_t guest_get_vcpuid(void);
> >  uint64_t cycles_read(void);
> >  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
> > 
> > +#define MEASURE_CYCLES(x)			\
> > +	({					\
> > +		uint64_t start;			\
> > +		start = cycles_read();		\
> > +		isb();				\
> 
> Would it make sense to put the necessary barriers inside the cycles_read() (or
> whatever we end up calling it)?  Or does that not make sense on ARM?

+1. Additionally, the function should have a name that implies ordering,
like read_system_counter_ordered() or similar.

> > +		x;				\
> > +		dsb(nsh);			\

I assume you're doing this because you want to wait for outstanding
loads and stores to complete due to 'x', right?

My knee-jerk reaction was that you could just do an mb() and share the
implementation between arches, but it would seem the tools/ flavor of
the barrier demotes to a DMB because... reasons.

> > +		cycles_read() - start;		\
> > +	})
> > +
> >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> ...
> 
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 5d977f95d5f5..7352e02db4ee 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -1137,4 +1137,14 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> >  uint64_t cycles_read(void);
> >  uint64_t cycles_to_ns(struct kvm_vcpu *vcpu, uint64_t cycles);
> > 
> > +#define MEASURE_CYCLES(x)			\
> > +	({					\
> > +		uint64_t start;			\
> > +		start = cycles_read();		\
> > +		asm volatile("mfence");		\
> 
> This is incorrect as placing the barrier after the RDTSC allows the RDTSC to be
> executed before earlier loads, e.g. could measure memory accesses from whatever
> was before MEASURE_CYCLES().  And per the kernel's rdtsc_ordered(), it sounds like
> RDTSC can only be hoisted before prior loads, i.e. will be ordered with respect
> to future loads and stores.

Same thing goes for the arm64 variant of the function... You want to
insert an isb() immediately _before_ you read the counter register to
avoid speculation.

arch_timer_read_cntvct_el0() back over in the kernel is a good example of
this. You can very likely ignore the ECV alternative for now.

-- 
Thanks,
Oliver
