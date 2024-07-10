Return-Path: <kvm+bounces-21308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF08A92D291
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD1C283511
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 13:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B7F192B79;
	Wed, 10 Jul 2024 13:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTTNBMZf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E61DDC5;
	Wed, 10 Jul 2024 13:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720617460; cv=none; b=iPu+uD7cZ+MTY7UIXJ+VRNNVLidu0fHKHA3VWfs9RXgZoeP0N9m24lXIoX6WQZjTziz8om4TAIkagU2bD71kPrEczqdAh++I5GQ0oiJianOgfdLRfbOwqWs6TLqn2qP2pg8Wxst7B69fmVRdNITexQPRSmZfYvN/ciOsm/6xmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720617460; c=relaxed/simple;
	bh=VmKKD27z2aOVSa1CLMwiPu6poVOxX6juNUr5X9b0taU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XToNS+q9bHy52JNzo71Bo5ZfixsO2FRxVnnwvfqLslMwqJchmnvSio95AAuzJuv9hBupIKyyGYggHWIoSsHK9qyDxf/btv5lNpFBR5ZZLGRDapHKDwlSDUAKGexaWqZKqosLULIK6xX5CaN523ZbUqKcxloz9C5jHRJoYwMTJJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTTNBMZf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE85C32781;
	Wed, 10 Jul 2024 13:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720617459;
	bh=VmKKD27z2aOVSa1CLMwiPu6poVOxX6juNUr5X9b0taU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTTNBMZfK6jQPbUQiR+ZQNJTyFKIzXUwDwG3CxLvDtdvvXlvNs0XOATi7iVLKYn9e
	 m8JNnSn7CylHOU7YGDW76bP/SAGy2NPMth/avv3ywV2QgxDJ3HYi0/ZA8Nebs6IWI1
	 8QETJa+mDNGc9DYlKRosmz0ZtQeqClTY4YmXtwmSxa2fmRewamQ2bks755KtcJLf+k
	 wX2zku7GU1H0KfM6grraBzhxffOcWHGPpTxG8UXhFQ4y2ywXNzBDcKGd4s7yGON3Ia
	 dHePDZM2Oskj6DKewi5UXiyHXthxYRPUUpDccMQ9/TP1nB4g4Kx9YUrc2YexMe741q
	 zacACTAkKZAiQ==
Date: Wed, 10 Jul 2024 14:17:33 +0100
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
Subject: Re: [PATCH v4 12/15] irqchip/gic-v3-its: Share ITS tables with a
 non-trusted hypervisor
Message-ID: <20240710131732.GA14582@willie-the-truck>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701095505.165383-13-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 10:55:02AM +0100, Steven Price wrote:
> Within a realm guest the ITS is emulated by the host. This means the
> allocations must have been made available to the host by a call to
> set_memory_decrypted(). Introduce an allocation function which performs
> this extra call.
> 
> For the ITT use a custom genpool-based allocator that calls
> set_memory_decrypted() for each page allocated, but then suballocates
> the size needed for each ITT. Note that there is no mechanism
> implemented to return pages from the genpool, but it is unlikely the
> peak number of devices will so much larger than the normal level - so
> this isn't expected to be an issue.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>  * Use BIT() macro.
>  * Use a genpool based allocator in its_create_device() to avoid
>    allocating a full page.
>  * Fix subject to drop "realm" and use gic-v3-its.
>  * Add error handling to ITS alloc/free.
> Changes since v2:
>  * Drop 'shared' from the new its_xxx function names as they are used
>    for non-realm guests too.
>  * Don't handle the NUMA_NO_NODE case specially - alloc_pages_node()
>    should do the right thing.
>  * Drop a pointless (void *) cast.
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 139 ++++++++++++++++++++++++++-----
>  1 file changed, 116 insertions(+), 23 deletions(-)

I gave this (and the following patch) a spin in a protected guest under
pKVM and was able to use MSIs for my virtio devices, so:

Tested-by: Will Deacon <will@kernel.org>

Will

