Return-Path: <kvm+bounces-21933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EBE93796D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A0FF283922
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 14:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6684B144D15;
	Fri, 19 Jul 2024 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLErxwio"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DB7286A8;
	Fri, 19 Jul 2024 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721401137; cv=none; b=ZNSF23s/vIIj6cHkESI60N7nTC8h3iLHNW3BnjuuPH0ATiVrJSyecNY6Ee7XFjuEXgbT7FtXonD/1p6lQmGe2CY8MoTJDm1L9SCsGtWs6bsfWwdElvmU9S42iHMOsR1t+prJ75Td6WfXkCr/D+ODYv0J9osv4E7BCT3joqvSu+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721401137; c=relaxed/simple;
	bh=5y3aMdrz73UFJ48GfmtyrJi/HKGoasQoG92KFO9KEyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NqpTP4eeN2ZFU1GhuNKsTfvTW5+39UR8ftQWrZDq5Ps+xEhZxXE97tCdwRPjF+Y2fWtswnkicfCIrosh5Cm/ReDNHlDjcZKzMNjXMPAkhpXRGgGy85CD1yw9AhduJ9uTkmlmGAYUtbb/OCOgmcM/G0erXdJUfyERhbpZV2H3lbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLErxwio; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AB6C32782;
	Fri, 19 Jul 2024 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721401137;
	bh=5y3aMdrz73UFJ48GfmtyrJi/HKGoasQoG92KFO9KEyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLErxwio5Fg9lxA3hFdMteSJWFKJ9k5GZXqYiVuga9G6XmXPmBJoK0wNT00AwfozD
	 n6mI6mef5613sWsYWhWGbBSL3VBoyrLOk60egfU1tJGggtefB4HroSiHYaV+KFkZ2d
	 +KHzgIU8r0yW0FloFCdPa6bVnDqpilm16lyHdSWKisaKfT5RxF3yR4rvMUm5kD3KnI
	 vrHYuYUv/3cgWWK41sLROJXNCDrPMBe8X5Lz9hKhidKeHXXtGlvi1Gtk1ymQeRVf8v
	 SBLsATQ4xAwxmmeqSouqsiwrTP6RymOI6L+SrjVruX4GuTpupM3hNzKpk9PyqPbGsQ
	 fPhq6RWHYnLZQ==
Date: Fri, 19 Jul 2024 15:58:51 +0100
From: Will Deacon <will@kernel.org>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ricarkol@google.com
Subject: Re: [PATCH] KVM: arm64: Move data barrier to end of split walk
Message-ID: <20240719145851.GA23182@willie-the-truck>
References: <20240718223519.1673835-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718223519.1673835-1-coltonlewis@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[+Ricardo, as he wrote the original split walker]

On Thu, Jul 18, 2024 at 10:35:19PM +0000, Colton Lewis wrote:
> Moving the data barrier from stage2_split_walker to after the walk is
> finished in kvm_pgtable_stage2_split results in a roughly 70%
> reduction in Clear Dirty Log Time in dirty_log_perf_test (modified to
> use eager page splitting) when using huge pages. This gain holds
> steady through a range of vcpus used (tested 1-64) and memory
> used (tested 1-64GB).
> 
> This is safe to do because nothing else is using the page tables while
> they are still being mapped and this is how other page table walkers
> already function. None of them have a data barrier in the walker
> itself.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 9e2bbee77491..9788af2ca8c0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1547,7 +1547,6 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 */
>  	new = kvm_init_table_pte(childp, mm_ops);
>  	stage2_make_pte(ctx, new);
> -	dsb(ishst);
>  	return 0;
>  }
>  
> @@ -1559,8 +1558,11 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  		.flags	= KVM_PGTABLE_WALK_LEAF,
>  		.arg	= mc,
>  	};
> +	int ret;
>  
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	dsb(ishst);
> +	return ret;
>  }

This looks ok to me, but it would be great if Ricardo could have a look
as well.

Will

