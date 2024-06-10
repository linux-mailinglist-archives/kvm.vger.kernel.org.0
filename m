Return-Path: <kvm+bounces-19253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 846CD902800
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:50:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78FE51C2218F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:50:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F5C14A4E2;
	Mon, 10 Jun 2024 17:50:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC4147C86;
	Mon, 10 Jun 2024 17:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718041804; cv=none; b=jxmx+MQ/PYTk0t+/qrNKFXNXFk3VvrSOKnGpF95SqNS+wPdp0Jpr63DgXVjZfmzZCl4JA2Y17u1jZ4XJYSSMlsaqu//6/4b6pg1to8DkravVm+kM2godVHu/5FicK4biSKkvteTyI+uA7AFHf0yfnOxn9xNwkKz/Bv2vSKBUAPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718041804; c=relaxed/simple;
	bh=WoVq+0Vo2WUlILwBRL9qEzQohV9M9XZ8hqHTaINtZgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMTVtOK6ybkYTccQ8dG5kWS+DWMSVlj9bzoxiXS55HvpnQKSvVClmnNScrayVcLlwE11ilaQzE14gHO0HRaiy7PQp0IykjoQJteU8rB3hm0MJDbjEEFubrMgr1DM03k8ehpVzlKb5m2MMgzQfO8s+tvYNfdnRFwcqet9FmRgvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA17C4AF1A;
	Mon, 10 Jun 2024 17:50:01 +0000 (UTC)
Date: Mon, 10 Jun 2024 18:49:59 +0100
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
Subject: Re: [PATCH v3 06/14] arm64: Override set_fixmap_io
Message-ID: <Zmc8x3Xvs8uu9zHp@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-7-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605093006.145492-7-steven.price@arm.com>

On Wed, Jun 05, 2024 at 10:29:58AM +0100, Steven Price wrote:
> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
> +{
> +	pgprot_t prot = FIXMAP_PAGE_IO;
> +
> +	/*
> +	 * For now we consider all I/O as non-secure. For future
> +	 * filter the I/O base for setting appropriate permissions.
> +	 */
> +	prot = __pgprot(pgprot_val(prot) | PROT_NS_SHARED);
> +
> +	return __set_fixmap(idx, phys, prot);
> +}

In v2, Suzuki said that we want to keep this as a function rather than
just adding PROT_NS_SHARED to FIXMAP_PAGE_IO in case we want to change
this function in the future to allow protected MMIO.

https://lore.kernel.org/linux-arm-kernel/6ba1fd72-3bad-44ca-810d-572b70050772@arm.com/

What I don't understand is that all the other MMIO cases just statically
assume unprotected/shard MMIO. Should we drop this patch here as well,
adjust FIXMAP_PAGE_IO and think about protected MMIO later when we
actually have to do device assignment?

-- 
Catalin

