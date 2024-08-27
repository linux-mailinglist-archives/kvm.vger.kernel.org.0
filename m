Return-Path: <kvm+bounces-25189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D372796157D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 19:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EFD71C22656
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159201D175E;
	Tue, 27 Aug 2024 17:31:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8951D1727;
	Tue, 27 Aug 2024 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724779882; cv=none; b=DNdSG4aiLCOJ6DRsIWyzJCstoBib81zKxSp7ByJTRcnTFoqnCCeeuxuLGaPYm6P3kU+sMkpcQQ9RomyFwSPWVug9yXHo3qxxZtmDnginUGM3ZIpPZY9SJVNXQzOZinlfgd3rfDNzx5Rz6Zs7Fo4tt4f2VsCQfvI3pCW1mqwS0bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724779882; c=relaxed/simple;
	bh=2u1GmynmHFpL3Vl/Pdkx/SlWV3DjIEoLeBWv92M7MD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KpcVsvswiIXpopwTbAjnbYH8zuocPZbu69r3NGOFEefVTRraq1IAgcoQwIVIXPnu9OjRgVXzZig587mH1GYc5869TOOypwokwEVPDhSL6kf+9Pxn0ULWb0j9knY+p/0y+YfNWAii8nCOLarOw86cWBZmbXQBIvXrUYoPPB57Ioo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FD8ADA7;
	Tue, 27 Aug 2024 10:31:46 -0700 (PDT)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3DD83F66E;
	Tue, 27 Aug 2024 10:31:18 -0700 (PDT)
Message-ID: <a0cfcbe4-cab4-48b2-bcba-0bc28d97e996@arm.com>
Date: Tue, 27 Aug 2024 18:31:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] vfio/iommu: Flag to allow userspace to set DMA
 buffers system cacheable
To: Jason Gunthorpe <jgg@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: Manoj Vishwanathan <manojvishy@google.com>, Will Deacon
 <will@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 David Dillow <dillow@google.com>
References: <20240826071641.2691374-1-manojvishy@google.com>
 <20240826110447.6522e0a7.alex.williamson@redhat.com>
 <20240826231749.GM3773488@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20240826231749.GM3773488@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/08/2024 12:17 am, Jason Gunthorpe wrote:
> On Mon, Aug 26, 2024 at 11:04:47AM -0600, Alex Williamson wrote:
>> On Mon, 26 Aug 2024 07:16:37 +0000
>> Manoj Vishwanathan <manojvishy@google.com> wrote:
>>
>>> Hi maintainers,
>>>
>>> This RFC patch introduces the ability for userspace to control whether
>>> device (DMA) buffers are marked as cacheable, enabling them to utilize
>>> the system-level cache.
>>>
>>> The specific changes made in this patch are:
>>>
>>> * Introduce a new flag in `include/linux/iommu.h`:
>>>      * `IOMMU_SYS_CACHE` -  Indicates if the associated page should be cached in the system's cache hierarchy.
>>> * Add `VFIO_DMA_MAP_FLAG_SYS_CACHE` to `include/uapi/linux/vfio.h`:
> 
> You'll need a much better description of what this is supposed to do
> when you resend it.
> 
> IOMMU_CACHE already largely means that pages should be cached.
> 
> So I don't know what ARM's "INC_OCACHE" actually is doing. Causing
> writes to land in a cache somewhere in hierarchy? Something platform
> specific?

Kinda both - the Inner Non-Cacheable attribute means it's still 
fundamentally non-snooping and non-coherent with CPU caches, but the 
Outer Write-back Write-allocate attribute can still control allocation 
in a system cache downstream of the point of coherency if the platform 
is built with such a thing (it's not overly common).

However, as you point out, this is in direct conflict with the Inner 
Write-back Write-allocate attribute implied by the IOMMU_CACHE which 
VFIO adds in further down in vfio_iommu_map(). Plus the way it's 
actually implemented in patch #2, IOMMU_CACHE still takes precedence and 
would lead to this new value being completely ignored, so there's a lot 
which smells suspicious here...

Thanks,
Robin.

> I have no idea. By your description it sounds similar to the
> x86 data placement stuff, whatever that was called, and the more
> modern TPH approach.
> 
> Jason

