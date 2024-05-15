Return-Path: <kvm+bounces-17424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 178DF8C654B
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 13:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAB08283530
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 11:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DEB679E5;
	Wed, 15 May 2024 11:01:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5B6166E;
	Wed, 15 May 2024 11:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715770867; cv=none; b=U+es19TjtnsbD95AZaBVIz5qPe1/+hrwGvZ5MkClahcQb1xrfKn/WTZ4uv0Lk/BLGI9KInPmcHTrYPGptrTcpsToPAh423advDErUj3PZ/ySnDzveRFbj3kgNnH4zOAEMABLGrBCz1tHm604KQ8Wrm9wl1BcpIiF97U19/zrZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715770867; c=relaxed/simple;
	bh=qpg84gYPLFPNjhtRges7kVRAYlORPDiwFGtGDMreZmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJUNBKFvwluWjEqAYCjBkG6hY5WJO5RkqRYv/HET59YbH7JgJl+LMgsWWfS7eHmyDZz1WvCyltVDk/h5o2nUCvYooV/sNSII9l8SSAUXnyYEO8Q2MgP5ZrAMhRILkXLAFvn22XdvMPh793LnSU79Q/fNt2X1aF9VOIOREswNgjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA0BC116B1;
	Wed, 15 May 2024 11:01:03 +0000 (UTC)
Date: Wed, 15 May 2024 12:01:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [PATCH v2 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
Message-ID: <ZkSV7Z8QFQYLETzD@arm.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084213.1733764-13-steven.price@arm.com>

On Fri, Apr 12, 2024 at 09:42:11AM +0100, Steven Price wrote:
> @@ -198,6 +201,33 @@ static DEFINE_IDA(its_vpeid_ida);
>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>  
> +static struct page *its_alloc_shared_pages_node(int node, gfp_t gfp,
> +						unsigned int order)
> +{
> +	struct page *page;
> +
> +	if (node == NUMA_NO_NODE)
> +		page = alloc_pages(gfp, order);
> +	else
> +		page = alloc_pages_node(node, gfp, order);

I think you can just call alloc_pages_node() in both cases. This
function takes care of the NUMA_NO_NODE case itself.

> +
> +	if (page)
> +		set_memory_decrypted((unsigned long)page_address(page),
> +				     1 << order);
> +	return page;
> +}
> +
> +static struct page *its_alloc_shared_pages(gfp_t gfp, unsigned int order)
> +{
> +	return its_alloc_shared_pages_node(NUMA_NO_NODE, gfp, order);
> +}
> +
> +static void its_free_shared_pages(void *addr, unsigned int order)
> +{
> +	set_memory_encrypted((unsigned long)addr, 1 << order);
> +	free_pages((unsigned long)addr, order);
> +}

More of a nitpick on the naming: Are these functions used by the host as
well? The 'shared' part of the name does not make much sense, so maybe
just call them its_alloc_page() etc.

> @@ -3432,7 +3468,16 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>  	nr_ites = max(2, nvecs);
>  	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
>  	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
> -	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
> +	itt_order = get_order(sz);
> +	page = its_alloc_shared_pages_node(its->numa_node,
> +					   GFP_KERNEL | __GFP_ZERO,
> +					   itt_order);

How much do we waste by going for a full page always if this is going to
be used on the host?

> +	if (!page)
> +		return NULL;
> +	itt = (void *)page_address(page);

page_address() has the void * type already.

-- 
Catalin

