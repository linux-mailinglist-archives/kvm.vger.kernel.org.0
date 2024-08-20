Return-Path: <kvm+bounces-24649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A354958B7F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 17:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A54C0B22867
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE281940B5;
	Tue, 20 Aug 2024 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4P2cLKA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B0118E34B;
	Tue, 20 Aug 2024 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724168515; cv=none; b=lI/6ez04PicRB82VKWP17VvGy8j73J6guPaoD61vjcXLazFn0uCY1tn5UxVKiJ0tLrxDhblJ5Y44g27dcXkGc7Q4do1HtJaatMGzSIovKZ9yZdC3X9wV/x65HXTmdmy6EsDUFwUI/wC3s7ZFrRBPFIo5HIKkWdy0ibM4ewnONfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724168515; c=relaxed/simple;
	bh=WE7yieYzMSvd0478zSGwFrKvqNnaaK41R7XzRkUeMp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ongppFMX6cIlGCnnC+BG58tEKwXPauhqUQds4SRVqC/wdaS8Nvf6yrymTqAEYaF6xGQsh36ltIpLuYpph0Z6D/EK8rJoMHzDUs60gp3Fnh4paosm16OmZfZ/z3qDUUXWejFCMe9eWmjz0x4HwhRIQaRPIqsOXkYX3J370UdmWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4P2cLKA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5734C4AF0B;
	Tue, 20 Aug 2024 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724168514;
	bh=WE7yieYzMSvd0478zSGwFrKvqNnaaK41R7XzRkUeMp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M4P2cLKAU6WpevoXPoF5zaVxJL7YLSEdAfk1WAnPYGtTXKxCD95MMN1LMHjiCgiTa
	 EF2sYNX/kFxFwHffGsdB887YhiX4DA6qukVoruewnH7j8T12t1ow3tvRd9Mk2Cf2WZ
	 /tTIt7pxHLvK+v9E+HuE7XCCjePJwzKdJwsgJqmPic0lq+WFdkqCr1hdRMiwPOWFYt
	 keDstJGGiuEDm6AUvDSV+Ftc/XSysFDF2ffttStCWwMG0vz6j86yzGSYKk9lQJYmpq
	 QGR74mjsAyUlpN+k0NybxF94N0PZFtAjskjW+xdtljaDjaLn8dn7EoF3oyy8KbL38o
	 vNTNa0p+d9uJw==
Date: Tue, 20 Aug 2024 16:41:50 +0100
From: Will Deacon <will@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: Use precise range-based flush in mmu_notifier hooks
 when possible
Message-ID: <20240820154150.GA28750@willie-the-truck>
References: <20240802191617.312752-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240802191617.312752-1-seanjc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Sean,

On Fri, Aug 02, 2024 at 12:16:17PM -0700, Sean Christopherson wrote:
> Do arch-specific range-based TLB flushes (if they're supported) when
> flushing in response to mmu_notifier events, as a single range-based flush
> is almost always more performant.  This is especially true in the case of
> mmu_notifier events, as the majority of events that hit a running VM
> operate on a relatively small range of memory.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> This is *very* lightly tested, a thumbs up from the ARM world would be much
> appreciated.
> 
>  virt/kvm/kvm_main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..46bb95d58d53 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -599,6 +599,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  	struct kvm_gfn_range gfn_range;
>  	struct kvm_memory_slot *slot;
>  	struct kvm_memslots *slots;
> +	bool need_flush = false;
>  	int i, idx;
>  
>  	if (WARN_ON_ONCE(range->end <= range->start))
> @@ -651,10 +652,22 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
>  					goto mmu_unlock;
>  			}
>  			r.ret |= range->handler(kvm, &gfn_range);
> +
> +			/*
> +			 * Use a precise gfn-based TLB flush when possible, as
> +			 * most mmu_notifier events affect a small-ish range.
> +			 * Fall back to a full TLB flush if the gfn-based flush
> +			 * fails, and don't bother trying the gfn-based flush
> +			 * if a full flush is already pending.
> +			 */
> +			if (range->flush_on_ret && !need_flush && r.ret &&
> +			    kvm_arch_flush_remote_tlbs_range(kvm, gfn_range.start,
> +							     gfn_range.end - gfn_range.start))
> +				need_flush = true;

Thanks for having a crack at this.

We could still do better in the ->clear_flush_young() case if the
handler could do the invalidation as part of its page-table walk (for
example, it could use information about the page-table structure such
as the level of the leaves to optimise the invalidation further), but
this does at least avoid zapping the whole VMID on CPUs with range
support.

My only slight concern is that, should clear_flush_young() be extended
to operate on more than a single page-at-a-time in future, this will
silently end up invalidating the entire VMID for each memslot unless we
teach kvm_arch_flush_remote_tlbs_range() to return !0 in that case.

Will

