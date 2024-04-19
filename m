Return-Path: <kvm+bounces-15251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B7A8AADAA
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A348283174
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C44E8288F;
	Fri, 19 Apr 2024 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fUooDE5x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DF980029;
	Fri, 19 Apr 2024 11:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713525880; cv=none; b=cu/pZXDGLfyPbrVpefNCRo3buAfVKfsbJVOnfWHSrza4ODBz0FnxBToz3eRbwnEOn/fYrQfi0PJt8I1pB1ucC7fmRRT4BRBuTvjK4eCo4ihjLg4UF7w+JPzMqzjt8ocN9v/oAb4693k0eW6Q6M6vxxzt3iDCIZNGQcVLohEdZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713525880; c=relaxed/simple;
	bh=seRCd4clFxTtL6vDMULl2f9q6ycCa2mn5kfveiu4RD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvv3ScEL4XGdZvyW1xxgkn01Mv/gzEaS/BDzJQqGN4oB6HD8R32syr5DPoW6tKAJHaD4/EBdKW8Lp6Z8NHBdf4olO3AvnP8O9srZP5xdBxNt+OyQXvgQqUPJ4474Grjs99Z5YIb0N0t930QCtQofDkINV/7y0l6lrH+0Kgi55K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fUooDE5x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7323C072AA;
	Fri, 19 Apr 2024 11:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713525880;
	bh=seRCd4clFxTtL6vDMULl2f9q6ycCa2mn5kfveiu4RD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fUooDE5xzZcwoxp6cnIxa6nSjyz1WVMPciR6eMgeZnScdWtd6RHnirzVrYzahjF7o
	 0Rhf5JDQK6Bbi//FiWWYsQhmxdD2E7SdEerccUuWi7NIJjAe8/oEc+JTPgi97aEKCx
	 1qr1ylbc2JY3/PXoVlXnIjiywl20S1TiLXHN1Go61pGazmBK5iADoaJAlP4Oea0qxL
	 4yJjj/ACTYEPqM9xhtpaqk87AOhVlC9pbpwjwCQyrrBWvF45vcjP2LjfAQa/iqIMmX
	 0M2vJIj9IINojXoqhh6KBgTnklOD9tdz9Fd6A0k9WyLbzTHYn8x5INZivUwtKZ68Bq
	 aiK1U7erJiBgQ==
Date: Fri, 19 Apr 2024 12:24:32 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
Message-ID: <20240419112432.GB2972@willie-the-truck>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
 <20240412104408.GA27645@willie-the-truck>
 <86jzl2sovz.wl-maz@kernel.org>
 <ZhlLHtfeSHk9gRRO@google.com>
 <86h6g5si0m.wl-maz@kernel.org>
 <Zh1d94Pl6gneVoDd@google.com>
 <20240418141932.GA1855@willie-the-truck>
 <ZiF6NgGYLSsPNEOg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiF6NgGYLSsPNEOg@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Apr 18, 2024 at 12:53:26PM -0700, Sean Christopherson wrote:
> On Thu, Apr 18, 2024, Will Deacon wrote:
> > On Mon, Apr 15, 2024 at 10:03:51AM -0700, Sean Christopherson wrote:
> > > On Sat, Apr 13, 2024, Marc Zyngier wrote:
> > > > On Fri, 12 Apr 2024 15:54:22 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > > > 
> > > > > On Fri, Apr 12, 2024, Marc Zyngier wrote:
> > > > > > On Fri, 12 Apr 2024 11:44:09 +0100, Will Deacon <will@kernel.org> wrote:
> > > > > > > On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> > > > > > > Also, if you're in the business of hacking the MMU notifier code, it
> > > > > > > would be really great to change the .clear_flush_young() callback so
> > > > > > > that the architecture could handle the TLB invalidation. At the moment,
> > > > > > > the core KVM code invalidates the whole VMID courtesy of 'flush_on_ret'
> > > > > > > being set by kvm_handle_hva_range(), whereas we could do a much
> > > > > > > lighter-weight and targetted TLBI in the architecture page-table code
> > > > > > > when we actually update the ptes for small ranges.
> > > > > > 
> > > > > > Indeed, and I was looking at this earlier this week as it has a pretty
> > > > > > devastating effect with NV (it blows the shadow S2 for that VMID, with
> > > > > > costly consequences).
> > > > > > 
> > > > > > In general, it feels like the TLB invalidation should stay with the
> > > > > > code that deals with the page tables, as it has a pretty good idea of
> > > > > > what needs to be invalidated and how -- specially on architectures
> > > > > > that have a HW-broadcast facility like arm64.
> > > > > 
> > > > > Would this be roughly on par with an in-line flush on arm64?  The simpler, more
> > > > > straightforward solution would be to let architectures override flush_on_ret,
> > > > > but I would prefer something like the below as x86 can also utilize a range-based
> > > > > flush when running as a nested hypervisor.
> > > 
> > > ...
> > > 
> > > > I think this works for us on HW that has range invalidation, which
> > > > would already be a positive move.
> > > > 
> > > > For the lesser HW that isn't range capable, it also gives the
> > > > opportunity to perform the iteration ourselves or go for the nuclear
> > > > option if the range is larger than some arbitrary constant (though
> > > > this is additional work).
> > > > 
> > > > But this still considers the whole range as being affected by
> > > > range->handler(). It'd be interesting to try and see whether more
> > > > precise tracking is (or isn't) generally beneficial.
> > > 
> > > I assume the idea would be to let arch code do single-page invalidations of
> > > stage-2 entries for each gfn?
> > 
> > Right, as it's the only code which knows which ptes actually ended up
> > being aged.
> > 
> > > Unless I'm having a brain fart, x86 can't make use of that functionality.  Intel
> > > doesn't provide any way to do targeted invalidation of stage-2 mappings.  AMD
> > > provides an instruction to do broadcast invalidations, but it takes a virtual
> > > address, i.e. a stage-1 address.  I can't tell if it's a host virtual address or
> > > a guest virtual address, but it's a moot point because KVM doen't have the guest
> > > virtual address, and if it's a host virtual address, there would need to be valid
> > > mappings in the host page tables for it to work, which KVM can't guarantee.
> > 
> > Ah, so it sounds like it would need to be an arch opt-in then.
> 
> Even if x86 (or some other arch code) could use the precise tracking, I think it
> would make sense to have the behavior be arch specific.  Adding infrastructure
> to get information from arch code, only to turn around and give it back to arch
> code would be odd.

Sorry, yes, that's what I had in mind. Basically, a way for the arch code
to say "I've handled the TLBI, don't worry about it."

> Unless arm64 can't do the invalidation immediately after aging the stage-2 PTE,
> the best/easiest solution would be to let arm64 opt out of the common TLB flush
> when a SPTE is made young.
> 
> With the range-based flushing bundled in, this?
> 
> ---
>  include/linux/kvm_host.h |  2 ++
>  virt/kvm/kvm_main.c      | 40 +++++++++++++++++++++++++---------------
>  2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index afbc99264ffa..8fe5f5e16919 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2010,6 +2010,8 @@ extern const struct kvm_stats_header kvm_vcpu_stats_header;
>  extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
>  
>  #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
> +int kvm_arch_flush_tlb_if_young(void);
> +
>  static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
>  {
>  	if (unlikely(kvm->mmu_invalidate_in_progress))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 38b498669ef9..5ebef8ef239c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -595,6 +595,11 @@ static void kvm_null_fn(void)
>  }
>  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
>  
> +int __weak kvm_arch_flush_tlb_if_young(void)
> +{
> +	return true;
> +}

I tend to find __weak functions a little ugly, but I think the gist of the
diff looks good to me. Thanks for putting it together!

> +
>  /* Iterate over each memslot intersecting [start, last] (inclusive) range */
>  #define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
>  	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
> @@ -611,6 +616,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  	struct kvm_gfn_range gfn_range;
>  	struct kvm_memory_slot *slot;
>  	struct kvm_memslots *slots;
> +	bool need_flush = false;
>  	int i, idx;
>  
>  	if (WARN_ON_ONCE(range->end <= range->start))
> @@ -663,10 +669,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  					break;
>  			}
>  			r.ret |= range->handler(kvm, &gfn_range);
> +
> +		       /*
> +			* Use a precise gfn-based TLB flush when possible, as
> +			* most mmu_notifier events affect a small-ish range.
> +			* Fall back to a full TLB flush if the gfn-based flush
> +			* fails, and don't bother trying the gfn-based flush
> +			* if a full flush is already pending.
> +			*/
> +		       if (range->flush_on_ret && !need_flush && r.ret &&
> +			   kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
> +							    gfn_range.end - gfn_range.start + 1))

What's that '+ 1' needed for here?

Will

