Return-Path: <kvm+bounces-61093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D5DC0A44E
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 08:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1CBA94E64B0
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 07:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4969F2773F8;
	Sun, 26 Oct 2025 07:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="w1EvaNvl"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050E722F386;
	Sun, 26 Oct 2025 07:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761465320; cv=none; b=en3Ugy9s//nS8mX1w5xmoojCYFWWMUG4a+ZK7f3S3eUT8BFXMYH6FnNtY+UdFablghvTyYmalhZaXPnWmVWJnCy271oAo3aKEBjM7N7dULbXOEYZUoEZQiYqnH8SDjGpYGYtYpGSri8+QXGeYg2UMoft8+ofutcK5JsBRdq5TB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761465320; c=relaxed/simple;
	bh=6gQ0b96ksH6i06Ro3IgrAKOKydTsy37oius49iYhX08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=heeYJLX3O+Dt0L/nrsVZaxWIGr4aGqurxxxFpD53kpuFHu7l26CW5iFMW8sQSb41lvrt2tVSRB5tf40kQz58QfJFAoJtm1hZiiTsNAXgHHXMTUwvNBlScb2aSrO3kesdmKfDdTt/+rymfXhK988G4NG6Payi7sR8KApfQ3D0yZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=w1EvaNvl; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761465308; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gbW6lsAeQnITBSvhA7va7FPK1N1OCTuc7ZM09ubMnwE=;
	b=w1EvaNvl6VFnpLbbIhM9EH3J+k5X0NviL/4AMSLRUIkIBb+piVyJkusnscjydLGVvKu8spPiicc04LDecNvsFhKSVDF04tSt5ysDuE6zx/nxRA6UgIWJq00z4h8gD83xtiiQbxddnm0/V0kAPbJPASglw5DenO0U0CUmqenwv14=
Received: from 30.246.176.102(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqyle5w_1761465304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Oct 2025 15:55:06 +0800
Message-ID: <3db524e7-b6ce-4652-8420-fdb4639ac73a@linux.alibaba.com>
Date: Sun, 26 Oct 2025 15:55:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO
 regions
To: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
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
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20251022125012.GB244727@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/22 20:50, Jason Gunthorpe 写道:
> On Mon, Oct 13, 2025 at 06:26:11PM +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> Add support for exporting PCI device MMIO regions through dma-buf,
>> enabling safe sharing of non-struct page memory with controlled
>> lifetime management. This allows RDMA and other subsystems to import
>> dma-buf FDs and build them into memory regions for PCI P2P operations.
>>
>> The implementation provides a revocable attachment mechanism using
>> dma-buf move operations. MMIO regions are normally pinned as BARs
>> don't change physical addresses, but access is revoked when the VFIO
>> device is closed or a PCI reset is issued. This ensures kernel
>> self-defense against potentially hostile userspace.
> 
> Let's enhance this:
> 
> Currently VFIO can take MMIO regions from the device's BAR and map
> them into a PFNMAP VMA with special PTEs. This mapping type ensures
> the memory cannot be used with things like pin_user_pages(), hmm, and
> so on. In practice only the user process CPU and KVM can safely make
> use of these VMA. When VFIO shuts down these VMAs are cleaned by
> unmap_mapping_range() to prevent any UAF of the MMIO beyond driver
> unbind.
> 
> However, VFIO type 1 has an insecure behavior where it uses
> follow_pfnmap_*() to fish a MMIO PFN out of a VMA and program it back
> into the IOMMU. This has a long history of enabling P2P DMA inside
> VMs, but has serious lifetime problems by allowing a UAF of the MMIO
> after the VFIO driver has been unbound.

Hi, Jason,

Can you elaborate on this more?

 From my understanding of the VFIO type 1 implementation:

- When a device is opened through VFIO type 1, it increments the
   device->refcount
- During unbind, the driver waits for this refcount to drop to zero via
   wait_for_completion(&device->comp)
- This should prevent the unbind() from completing while the device is
   still in use

Given this refcount mechanism, I do not figure out how the UAF can
occur.

Thanks.

