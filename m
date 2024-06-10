Return-Path: <kvm+bounces-19251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 213F39027C1
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:27:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313101C21C9C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92787147C89;
	Mon, 10 Jun 2024 17:27:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2A714532C;
	Mon, 10 Jun 2024 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040448; cv=none; b=YLx63nASStJKPVcJViCOegmaPVF4pAwT2u2TFhbMhes0WSbDHSpHgdfbu3JA5aNhwpCRLH8/gts7y0+LtunVipgSEiEUYhZN5Qt7zTWplqG3M8TvgzLoSwe0oa92uTU82r4gxTL11XEFuDQb7lawpAFQcthb7g29HuY4Dxr8BKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040448; c=relaxed/simple;
	bh=wJYRldg3T8FDmjjLK/CGxgQ4cydiTmDEgBrsTZOAVPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKl2WC3imrOGQG/+VEJFOgUNF9GO/zU93mXDN8n7MhMsCcWX4aS0UBLxnuyQIb4tkqiMgunLzsgv7DX6q3T+81hpXzHbFjSUnA3knIWTsUhwHObrjVNjE49VLZMiF6iqTiwS+CqWL1eA2/iAdbLxB1ovgnrBWO6hcUK6yuPQV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E42C4AF1C;
	Mon, 10 Jun 2024 17:27:24 +0000 (UTC)
Date: Mon, 10 Jun 2024 18:27:22 +0100
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
Subject: Re: [PATCH v3 09/14] arm64: Enable memory encrypt for Realms
Message-ID: <Zmc3euO2YGh-g9Th@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-10-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-10-steven.price@arm.com>

On Wed, Jun 05, 2024 at 10:30:01AM +0100, Steven Price wrote:
> +static int __set_memory_encrypted(unsigned long addr,
> +				  int numpages,
> +				  bool encrypt)
> +{
> +	unsigned long set_prot = 0, clear_prot = 0;
> +	phys_addr_t start, end;
> +	int ret;
> +
> +	if (!is_realm_world())
> +		return 0;
> +
> +	if (!__is_lm_address(addr))
> +		return -EINVAL;
> +
> +	start = __virt_to_phys(addr);
> +	end = start + numpages * PAGE_SIZE;
> +
> +	/*
> +	 * Break the mapping before we make any changes to avoid stale TLB
> +	 * entries or Synchronous External Aborts caused by RIPAS_EMPTY
> +	 */
> +	ret = __change_memory_common(addr, PAGE_SIZE * numpages,
> +				     __pgprot(0),
> +				     __pgprot(PTE_VALID));
> +
> +	if (encrypt) {
> +		clear_prot = PROT_NS_SHARED;
> +		ret = rsi_set_memory_range_protected(start, end);
> +	} else {
> +		set_prot = PROT_NS_SHARED;
> +		ret = rsi_set_memory_range_shared(start, end);
> +	}
> +
> +	if (ret)
> +		return ret;
> +
> +	set_prot |= PTE_VALID;
> +
> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
> +				      __pgprot(set_prot),
> +				      __pgprot(clear_prot));
> +}

This works, does break-before-make and also rejects vmalloc() ranges
(for the time being).

One particular aspect I don't like is doing the TLBI twice. It's
sufficient to do it when you first make the pte invalid. We could guess
this in __change_memory_common() if set_mask has PTE_VALID. The call
sites are restricted to this file, just add a comment. An alternative
would be to add a bool flush argument to this function.

-- 
Catalin

