Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B5A59945F
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 07:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344942AbiHSFRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 01:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343577AbiHSFRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 01:17:30 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0345D3ED3;
        Thu, 18 Aug 2022 22:17:28 -0700 (PDT)
Date:   Fri, 19 Aug 2022 07:17:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660886247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HwGoynLkBCbr1HZnCZPCiFh9mHZZ5rs7ctpm3KuMn3w=;
        b=j6FTiU9S5r0+BvAMCX0XQXFh3z+nCsfNZCtvahzguQwuXcJTRcdDw0wXtiYacx4i3Owzqb
        rjtFguN+IAFTxrC0ix03qK53GuM8qgBOHtpT7Mbjkcv/1aLxWlS9rOHydVjF374KoY3MhC
        2FaYOkOPJ2Xylq3qQOP8TZt333eud68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcorr@google.com,
        michael.roth@amd.com, thomas.lendacky@amd.com, joro@8bytes.org,
        mizhang@google.com, pbonzini@redhat.com, vannapurve@google.com
Subject: Re: [V3 10/11] KVM: selftests: Add ucall pool based implementation
Message-ID: <20220819051725.6lgggz2ktbd35pqj@kamzik>
References: <20220810152033.946942-1-pgonda@google.com>
 <20220810152033.946942-11-pgonda@google.com>
 <20220816161350.b7x5brnyz5pyi7te@kamzik>
 <Yv5iKJbjW5VseagS@google.com>
 <20220818190514.ny77xpfwiruah6m5@kamzik>
 <Yv7LR8NMBMKVzS3Z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv7LR8NMBMKVzS3Z@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022 at 11:29:11PM +0000, Sean Christopherson wrote:
> On Thu, Aug 18, 2022, Andrew Jones wrote:
> > On Thu, Aug 18, 2022 at 04:00:40PM +0000, Sean Christopherson wrote:
> > > But why is "use_ucall_pool" optional?  Unless there's a use case that fundamentally
> > > conflicts with the pool approach, let's make the pool approach the _only_ approach.
> > > IIRC, ARM's implementation isn't thread safe, i.e. there's at least one other use
> > > case that _needs_ the pool implementation.
> > 
> > Really? The ucall structure is on the vcpu's stack like the other
> > architectures. Ah, you're probably thinking about the shared address used
> > to exit to userspace. The address doesn't matter as long as no VM maps
> > it, but, yes, a multi-VM test where the VMs have different maps could end
> > up breaking ucalls for one or more VMs.
> 
> Yah, that's what I was thinking of.
> 
> > It wouldn't be hard to make that address per-VM, though, if ever necessary.
> > 
> > > 
> > > By supporting both, we are signing ourselves up for extra maintenance and pain,
> > > e.g. inevitably we'll break whichever option isn't the default and not notice for
> > > quite some time.
> > 
> > uc pools are currently limited to a single VM. That could be changed, but
> > at the expense of even more code to maintain.
> 
> Unless I'm missing something, it's actually less code.  "globals" that are sync'd
> to the guest aren't truly global, each VM has a separate physical page that is a
> copy of the global, hence the need for sync_global_to_guest().
> 
> And FWIW, the code is actually "safe" in practice because I doubt any test spawns
> multiple VMs in parallel, i.e. the host might get confused over the value of
> ucall_pool, but guests won't stomp on each other so long as they're created
> serially.  Ditto for ARM's ucall_exit_mmio_addr.
> 
> To make this truly thread safe, we just need a way to atomically sync the pointer
> to the guest, and that's easy enough to add.

I like that.

> 
> With that out of the way, all of the conditional "use pool" code goes away, which
> IMO simplifies things overall.  Using a pool versus stack memory isn't _that_ much
> more complicated, and we _know_ the stack approach doesn't work for all VM types.
> 
> Indeed, this partial conversion is:
> 
>   7 files changed, 131 insertions(+), 18 deletions(-)
> 
> versus a full conversion:
> 
>   6 files changed, 89 insertions(+), 20 deletions(-)
> 
> And simplification is only a secondary concern, what I'm really worried about is
> things bitrotting and then some poor sod having to wade through unrelated issues
> because somebody else broke the pool implementation and didn't notice.
> 
> Argh, case in point, none of the x86 (or s390 or RISC-V) tests do ucall_init(),
> which would have been a lurking bug if any of them tried to switch to the pool.
> 
> Argh + case in point #2, this code is broken, and that bug may have sat unnoticed
> due to only the esoteric SEV test using the pool.
> 
> -static inline size_t uc_pool_idx(struct ucall *uc)
> +static noinline void ucall_free(struct ucall *uc)
>  {
> -       return uc->hva - ucall_pool->ucalls;
> -}
> -
> -static void ucall_free(struct ucall *uc)
> -{
> -       clear_bit(uc_pool_idx(uc), ucall_pool->in_use);
> +       /* Beware, here be pointer arithmetic.  */
> +       clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
>  }

Dropping the only once-used uc_pool_idx() and adding the comment looks
better, but I don't think there was a bug because uc == uc->hva.

> 
> 
> So my very strong vote is to fully switch to a single implementation.  That way
> our code either works or it doesn't, i.e. we notice very quickly if it breaks.
> 
> Peter, if I can convince Drew of One Pool To Rule Them All, can you slot in the

There are other hills for me to stand on, so I won't insist on this one.

> attached patches and slightly rework the ordering so that all SEV patches are at
> the end?  E.g. something like:
> 
>   KVM: selftests: Automatically do init_ucall() for non-barebones VMs
>   KVM: selftests: move vm_phy_pages_alloc() earlier in file
>   KVM: selftests: sparsebit: add const where appropriate
>   KVM: selftests: add hooks for managing encrypted guest memory
>   KVM: selftests: handle encryption bits in page tables
>   KVM: selftests: add support for encrypted vm_vaddr_* allocations
>   KVM: selftests: Consolidate common code for popuplating
>   KVM: selftests: Consolidate boilerplate code in get_ucall()
>   tools: Add atomic_test_and_set_bit()
>   KVM: selftests: Add macro to atomically sync per-VM "global" pointers
>   KVM: selftests: Add ucall pool based implementation
>   KVM: selftests: add library for creating/interacting with SEV guests
>   KVM: selftests: Add simple sev vm testing
> 
> The patches are tested on x86 and compile tested on arm.  I can provide more testing
> if/when necessary.  I also haven't addressed any other feedback in the "ucall pool"
> patch, though I'm guessing much of it no longer applies.

I skimmed the patches but don't know how to comment on attachments, so
I'll add the two things that popped to mind here.

1) Doing ucall_init() at VM create time may be too early for Arm. Arm
probes for an unmapped address for the MMIO address it needs, so it's
best to do that after all mapping.

2) We'll need to change the sanity checks in Arm's get_ucall() to not
check that the MMIO address == ucall_exit_mmio_addr since there's no
guarantee that the exiting guest's address matches whatever is lingering
in the host's version. We can either drop the sanity check altogether
or try to come up with something else.

Thanks,
drew
