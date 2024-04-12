Return-Path: <kvm+bounces-14520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921F38A2CBC
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3A341C21619
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CDD7446BD;
	Fri, 12 Apr 2024 10:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q5wzc5tB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9044E3FBA4;
	Fri, 12 Apr 2024 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918657; cv=none; b=TK+OGF7d2kaWwNFhNFRtNoLx5wow7ZXtY7gZN36Rnsfry9XYl2sVHwb1L/x3QpzwRFUYzau/xLd+uSiisJDefEtkw8n8XDenDkMJxPdDK7Bpjv/JyrThd9PrezZLdv8uT1xo8lTCj5oQ1SL5TI/DtZZmkJPUJWDuMZ2rRCVMimA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918657; c=relaxed/simple;
	bh=1VOBD4fGV0wS/+b3v+F56U0irySBTtLVMq1jk0/3aNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZ5NrSGjR2vHbYESpFrN2YuDNHcmOK04iyfeOHTNeZxjqsiRqYBFem/P1ivJ8zV5RYg6WHGWhoNkka+Tx27diygzBGDek4g7aPRT4noMEB2DIcKmsEIqjZWuYNaJLVUa/jDVf3mH4lSeSfXkEcUzlyLMwNhjoK111FoOtn5pitg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q5wzc5tB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E150DC2BD10;
	Fri, 12 Apr 2024 10:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712918657;
	bh=1VOBD4fGV0wS/+b3v+F56U0irySBTtLVMq1jk0/3aNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5wzc5tBoiGBsuRhpRnOXn+/JuA2Y0L1EtRojaOy61UqRCGrwmOi61B2T1bcDZaV7
	 NbeRh9B8kksCJt8R7pFX3UfmmSq/2LH88b9pMLZWTv2gnx4GpA7DoH+Ua+/V5vG0Nk
	 hQ9OiK295o+5817rlVHgqnSFpwuxD94ALmfSL/fo+n9Eqg2oPkF9PNzAWoq+5vRQyS
	 L84JYDrUOnGdWUMq7ZD58Z1trqP5rnJGDBgLeKsRca2aKXrhpgBlqIPrNxvH9n1XP1
	 tdm7TK+oNWh6Sghw9RDsr0XR1COHVxmNS79Ysf/5OIwilPqZvdbbq19zgYHTJOcM6C
	 Q1X6HLwip4qhg==
Date: Fri, 12 Apr 2024 11:44:09 +0100
From: Will Deacon <will@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: delete .change_pte MMU notifier callback
Message-ID: <20240412104408.GA27645@willie-the-truck>
References: <20240405115815.3226315-1-pbonzini@redhat.com>
 <20240405115815.3226315-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405115815.3226315-2-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Apr 05, 2024 at 07:58:12AM -0400, Paolo Bonzini wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index dc04bc767865..ff17849be9f4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1768,40 +1768,6 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  	return false;
>  }
>  
> -bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
> -{
> -	kvm_pfn_t pfn = pte_pfn(range->arg.pte);
> -
> -	if (!kvm->arch.mmu.pgt)
> -		return false;
> -
> -	WARN_ON(range->end - range->start != 1);
> -
> -	/*
> -	 * If the page isn't tagged, defer to user_mem_abort() for sanitising
> -	 * the MTE tags. The S2 pte should have been unmapped by
> -	 * mmu_notifier_invalidate_range_end().
> -	 */
> -	if (kvm_has_mte(kvm) && !page_mte_tagged(pfn_to_page(pfn)))
> -		return false;
> -
> -	/*
> -	 * We've moved a page around, probably through CoW, so let's treat
> -	 * it just like a translation fault and the map handler will clean
> -	 * the cache to the PoC.
> -	 *
> -	 * The MMU notifiers will have unmapped a huge PMD before calling
> -	 * ->change_pte() (which in turn calls kvm_set_spte_gfn()) and
> -	 * therefore we never need to clear out a huge PMD through this
> -	 * calling path and a memcache is not required.
> -	 */
> -	kvm_pgtable_stage2_map(kvm->arch.mmu.pgt, range->start << PAGE_SHIFT,
> -			       PAGE_SIZE, __pfn_to_phys(pfn),
> -			       KVM_PGTABLE_PROT_R, NULL, 0);
> -
> -	return false;
> -}
> -
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>  	u64 size = (range->end - range->start) << PAGE_SHIFT;

Thanks. It's nice to see this code retire:

Acked-by: Will Deacon <will@kernel.org>

Also, if you're in the business of hacking the MMU notifier code, it
would be really great to change the .clear_flush_young() callback so
that the architecture could handle the TLB invalidation. At the moment,
the core KVM code invalidates the whole VMID courtesy of 'flush_on_ret'
being set by kvm_handle_hva_range(), whereas we could do a much
lighter-weight and targetted TLBI in the architecture page-table code
when we actually update the ptes for small ranges.

Will

