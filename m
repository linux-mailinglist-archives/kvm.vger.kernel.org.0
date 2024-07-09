Return-Path: <kvm+bounces-21173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB4A92B8E6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 13:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C04E1F2340A
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 11:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE691581E5;
	Tue,  9 Jul 2024 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVrq05DN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE0155382;
	Tue,  9 Jul 2024 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526281; cv=none; b=dHbD8TNG9VzxQwQvmCg+no1ASE6GVjm2JBe4m/0eXgkzWRxDXxWwDqJHck1il1PJnzP9GIKGoKmaPSQElcd2sf7orz4cdS4r45wp/ldggzFAnelCx0ZZeYjUCWgNnFAhoc7v1+qAVn+/EyB+O6X2YZa/pjuhbRvepL+fxjXqrSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526281; c=relaxed/simple;
	bh=mcr1Q83MzDxEGUd1avareyzVmIooEbR7/Dw3XlUo3Vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwuGpPUV8K5JvrhKBzSD4hpvjE+Zs4ycdE41fYuRjSy6L7AWwP3cvUXJnc7DxVKJMH137Y504RCHd79byHi9D6Vn06At3iFa3Cku4EHXwTk6OhYexwwMLOouAvfCBLSAy3ANUYXl6V+lKN8IsCmr2w5fmJXxCVl9XC0ji10dppY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVrq05DN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B8C3277B;
	Tue,  9 Jul 2024 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720526281;
	bh=mcr1Q83MzDxEGUd1avareyzVmIooEbR7/Dw3XlUo3Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lVrq05DNc6FHAVJmrJZr8SpnL7TggHUDO9DahF3RLoVsfC65pfiPRbuvsw+ZvB2VH
	 i24w0UPDjAi9cS4aRBVWps9FqfK5glM3G8lUxCk+EX936e+zhm/nQaBBcAdBfLewZ+
	 Gjuiz/EuqRArL9zVe3NylTJCC6ZqSL0JVd1ivtfT8NkJd/TYmRWg8apXWdS7tU+6Sw
	 72WiWL1DKAqU09Xzom5qrs5vzR5nIsMEla/2vJw29h4zQOAYf3Q1Fn7oBnLn1RVb79
	 PS4rQNTT3ai3MzsOU+Ypvs7HiM73UYdGUZjEEsVSXy4aUPar9g7Oe6WX3NlgOetXFV
	 QsR+nCZISOXdg==
Date: Tue, 9 Jul 2024 12:57:54 +0100
From: Will Deacon <will@kernel.org>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v4 08/15] arm64: mm: Avoid TLBI when marking pages as
 valid
Message-ID: <20240709115754.GD13242@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-9-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-9-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:54:58AM +0100, Steven Price wrote:
> When __change_memory_common() is purely setting the valid bit on a PTE
> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
> either the entry isn't changing (the valid bit was already set) or the
> entry was invalid and so should not have been cached in the TLB.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> v4: New patch
> ---
>  arch/arm64/mm/pageattr.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 0e270a1c51e6..547a9e0b46c2 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>  	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>  					&data);
>  
> -	flush_tlb_kernel_range(start, start + size);
> +	/*
> +	 * If the memory is being made valid without changing any other bits
> +	 * then a TLBI isn't required as a non-valid entry cannot be cached in
> +	 * the TLB.
> +	 */
> +	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
> +		flush_tlb_kernel_range(start, start + size);
>  	return ret;

Can you elaborate on when this actually happens, please? It feels like a
case of "Doctor, it hurts when I do this" rather than something we should
be trying to short-circuit in the low-level code.

Will

