Return-Path: <kvm+bounces-17391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5828C5ABB
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 20:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D4BDB22113
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 18:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558691802D1;
	Tue, 14 May 2024 18:00:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9AE1802B6;
	Tue, 14 May 2024 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715709618; cv=none; b=J8iVnm0a3BzL6f9dxMR4wbjQWrJ+mcWvTDNk4q1C2TsvUJciJo6Jx+yNrDPJfAJiQ38uEcGGP0L3AeIDRe9uuHqD3h0PutFPvRQLy+fL9h8+26EVbXwF1LGpWYwDDkDlTArmjYDagnbey0H4RaMdsZNjsRCD+W+FFYdZGQycNug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715709618; c=relaxed/simple;
	bh=PGg21Fv5zTdyXu46lFNWZlRUE2G+nr6G9MZPkue/+SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwtc+Gt8OC24W5S6RwYCMqKinTQ0lsQmxI2DS89bsyVI80GZy8fVw9nd5kqL/OYu4OTMDkfbc0COvKpfq98QSUrMzCR5S0sL/nQ+Omn9lwi5qnN3P295EOjJkhKSPr0taYZILNi2EFJXQadlKttWcKt9j8HCeSWBwW5gYzkCdsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235D4C2BD10;
	Tue, 14 May 2024 18:00:14 +0000 (UTC)
Date: Tue, 14 May 2024 19:00:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <ZkOmrMIMFCgEKuVw@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-10-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
>  static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
> @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>  	pte = clear_pte_bit(pte, cdata->clear_mask);
>  	pte = set_pte_bit(pte, cdata->set_mask);
>  
> +	/* TODO: Break before make for PROT_NS_SHARED updates */
>  	__set_pte(ptep, pte);
>  	return 0;

Oh, this TODO is problematic, not sure we can do it safely. There are
some patches on the list to trap faults from other CPUs if they happen
to access the page when broken but so far we pushed back as complex and
at risk of getting the logic wrong.

From an architecture perspective, you are changing the output address
and D8.16.1 requires a break-before-make sequence (FEAT_BBM doesn't
help). So we either come up with a way to do BMM safely (stop_machine()
maybe if it's not too expensive or some way to guarantee no accesses to
this page while being changed) or we get the architecture clarified on
the possible side-effects here ("unpredictable" doesn't help).

>  }
> @@ -192,6 +197,43 @@ int set_direct_map_default_noflush(struct page *page)
>  				   PAGE_SIZE, change_page_range, &data);
>  }
>  
> +static int __set_memory_encrypted(unsigned long addr,
> +				  int numpages,
> +				  bool encrypt)
> +{
> +	unsigned long set_prot = 0, clear_prot = 0;
> +	phys_addr_t start, end;
> +
> +	if (!is_realm_world())
> +		return 0;
> +
> +	WARN_ON(!__is_lm_address(addr));

Just return from this function if it's not a linear map address. No
point in corrupting other areas since __virt_to_phys() will get it
wrong.

> +	start = __virt_to_phys(addr);
> +	end = start + numpages * PAGE_SIZE;
> +
> +	if (encrypt) {
> +		clear_prot = PROT_NS_SHARED;
> +		set_memory_range_protected(start, end);
> +	} else {
> +		set_prot = PROT_NS_SHARED;
> +		set_memory_range_shared(start, end);
> +	}
> +
> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
> +				      __pgprot(set_prot),
> +				      __pgprot(clear_prot));
> +}

Can someone summarise what the point of this protection bit is? The IPA
memory is marked as protected/unprotected already via the RSI call and
presumably the RMM disables/permits sharing with a non-secure hypervisor
accordingly irrespective of which alias the realm guest has the linear
mapping mapped to. What does it do with the top bit of the IPA? Is it
that the RMM will prevent (via Stage 2) access if the IPA does not match
the requested protection? IOW, it unmaps one or the other at Stage 2?

Also, the linear map is not the only one that points to this IPA. What
if this is a buffer mapped in user-space or remapped as non-cacheable
(upgraded to cacheable via FWB) in the kernel, the code above does not
(and cannot) change the user mappings.

It needs some digging into dma_direct_alloc() as well, it uses a
pgprot_decrypted() but that's not implemented by your patches. Not sure
it helps, it looks like the remap path in this function does not have a
dma_set_decrypted() call (or maybe I missed it).

-- 
Catalin

