Return-Path: <kvm+bounces-61300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CA23FC14F99
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 14:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CD9D3507299
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 13:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A4123496F;
	Tue, 28 Oct 2025 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="a4QvicBh"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E931F4606;
	Tue, 28 Oct 2025 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659222; cv=none; b=kl0vNYLq2wrJ6qf0mlAUa9dBdh1ZNRDYTWjlXBj2HrhPaZInt+sijamOD8QkFxAxEAekrd7sWlegZCPyh/tCirPRFbm3uFLeoAdm9MDhlQ4Xj4PZ2Ko7Lv1/JhoSIz0ATNlabLPWA2sPyc27NUvcj9ugAFeULe/JsyiesuENP6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659222; c=relaxed/simple;
	bh=3Wa50ZqGT8eSNTFPzwHcDHhGPw3XmeC01Xuy33bOsgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSDTWOvKslA8vkCQIO0iunDV0jNxi9Jy/alTiHUVHDcZcEuaYdzSEGq0VoCsODdmlNHCuD8QzjR817synYkG+On4hbAyC8wpAFWZzf12j878koTLL98vW/qGmD7/II8eHBVdMWQdloeoOCenhQ9FqNMrL0l59MyyM/47T1F6PwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=a4QvicBh; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761659214; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SdP4P384sbs4h39646JsReKLjr8gZ9zv4XENPQNf9Lk=;
	b=a4QvicBhKu7BrMaOW0kT0Dwui2BH/axotYbjhhLYIK2f0FBvkiEDY2yEy8ETyM1e0v8cCfuLtZjtug6WX2uf2MiFe/zsUPCh7z65Ya3IwctJcsOVQ/Vzv2uZ+PNN+K5lO3xGanvNfN6P+SppfRgGYeYswq1hgVZOuu47NKZdoxM=
Received: from 30.246.176.102(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WrCJu3H_1761659211 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Oct 2025 21:46:52 +0800
Message-ID: <0d95b8af-97e4-43b6-a35a-aa3ce153f0ee@linux.alibaba.com>
Date: Tue, 28 Oct 2025 21:46:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Leon Romanovsky <leonro@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
 kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Logan Gunthorpe <logang@deltatee.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
 <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
 <20251022125012.GB244727@nvidia.com>
 <3db524e7-b6ce-4652-8420-fdb4639ac73a@linux.alibaba.com>
 <20251027120904.GA896317@nvidia.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20251027120904.GA896317@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/27 20:09, Jason Gunthorpe 写道:
> On Sun, Oct 26, 2025 at 03:55:04PM +0800, Shuai Xue wrote:
>>
>>
>> 在 2025/10/22 20:50, Jason Gunthorpe 写道:
>>> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
>>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>>
>>>> Add support for exporting PCI device MMIO regions through dma-buf,
>>>> enabling safe sharing of non-struct page memory with controlled
>>>> lifetime management. This allows RDMA and other subsystems to import
>>>> dma-buf FDs and build them into memory regions for PCI P2P operations.
>>>>
>>>> The implementation provides a revocable attachment mechanism using
>>>> dma-buf move operations. MMIO regions are normally pinned as BARs
>>>> don't change physical addresses, but access is revoked when the VFIO
>>>> device is closed or a PCI reset is issued. This ensures kernel
>>>> self-defense against potentially hostile userspace.
>>>
>>> Let's enhance this:
>>>
>>> Currently VFIO can take MMIO regions from the device's BAR and map
>>> them into a PFNMAP VMA with special PTEs. This mapping type ensures
>>> the memory cannot be used with things like pin_user_pages(), hmm, and
>>> so on. In practice only the user process CPU and KVM can safely make
>>> use of these VMA. When VFIO shuts down these VMAs are cleaned by
>>> unmap_mapping_range() to prevent any UAF of the MMIO beyond driver
>>> unbind.
>>>
>>> However, VFIO type 1 has an insecure behavior where it uses
>>> follow_pfnmap_*() to fish a MMIO PFN out of a VMA and program it back
>>> into the IOMMU. This has a long history of enabling P2P DMA inside
>>> VMs, but has serious lifetime problems by allowing a UAF of the MMIO
>>> after the VFIO driver has been unbound.
>>
>> Hi, Jason,
>>
>> Can you elaborate on this more?
>>
>>  From my understanding of the VFIO type 1 implementation:
>>
>> - When a device is opened through VFIO type 1, it increments the
>>    device->refcount
>> - During unbind, the driver waits for this refcount to drop to zero via
>>    wait_for_completion(&device->comp)
>> - This should prevent the unbind() from completing while the device is
>>    still in use
>>
>> Given this refcount mechanism, I do not figure out how the UAF can
>> occur.
> 
> A second vfio device can be opened and then use follow_pfnmap_*() to
> read the first vfio device's PTEs. There is no relationship betweent
> the first and second VFIO devices, so once the first is unbound it
> sails through the device->comp while the second device retains the PFN
> in its type1 iommu_domain.
> 
> Jason

I see.

Thanks.

Best Regard,
Shuai


