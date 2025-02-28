Return-Path: <kvm+bounces-39721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE21DA4983D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 12:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E5B93B369D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 11:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE732620D4;
	Fri, 28 Feb 2025 11:21:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09306849C;
	Fri, 28 Feb 2025 11:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740741660; cv=none; b=qBPDstM9lX9/Nh1xejXLhW5G2xPcHUuZYvDK62I8gSzuhlBCJdEwIwISvQCoar4ruA8MI+ft3tKA9jWGNLxlmxUmlXfubAnJvKf6NNhr4oUjtgiV2+91y0uXe7hKheHlVscUhfMRqJ78tglwish7QKswELFZykD41wo3AOcbmNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740741660; c=relaxed/simple;
	bh=VQaJDe/L26P+xJD399jAoSxFwXV/7P7VoarP0wr20PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K5qdeFXONKq3ghBH+IK1oWuLkEhgahboGrOH1CsZYMXnqXsIiElYeoGsVYgSoSWCeOWwgkzK7NtjO9kVhJ1LBjVkwtFA+wxZc2NER+z2+M44JPp6QaRqryrJVK+C8kMNKsZe8wvD5xsVeTFj0sXJWZB3fTY6hVb8hbSaU7nqVDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D44211063;
	Fri, 28 Feb 2025 03:21:13 -0800 (PST)
Received: from [10.1.196.40] (e121345-lin.cambridge.arm.com [10.1.196.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4248B3F673;
	Fri, 28 Feb 2025 03:20:57 -0800 (PST)
Message-ID: <9c3ba9fa-c433-4d6e-9570-dd11daf5a06d@arm.com>
Date: Fri, 28 Feb 2025 11:20:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
To: Nicolin Chen <nicolinc@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: joro@8bytes.org, will@kernel.org, alex.williamson@redhat.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1740600272.git.nicolinc@nvidia.com>
 <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
 <20250227195036.GK39591@nvidia.com> <Z8DSGF0tGgvkJh41@Asurada-Nvidia>
 <20250227210336.GP39591@nvidia.com> <Z8D1/BWdTY4TtoB3@Asurada-Nvidia>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <Z8D1/BWdTY4TtoB3@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/02/2025 11:32 pm, Nicolin Chen wrote:
> On Thu, Feb 27, 2025 at 05:03:36PM -0400, Jason Gunthorpe wrote:
>> On Thu, Feb 27, 2025 at 12:59:04PM -0800, Nicolin Chen wrote:
>>> On Thu, Feb 27, 2025 at 03:50:36PM -0400, Jason Gunthorpe wrote:
>>>> On Wed, Feb 26, 2025 at 12:16:05PM -0800, Nicolin Chen wrote:
>>>>> The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
>>>>> default domain, iommu_put_dma_cookie() can be simply added to this helper.
>>>>>
>>>>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
>>>>> ---
>>>>>   drivers/iommu/iommu.c | 11 ++++++++---
>>>>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>>>
>>>> Let's try to do what Robin suggested and put a private_data_owner
>>>> value in the struct then this patch isn't used, we'd just do
>>>>
>>>>        if (domain->private_data_owner == DMA)
>>>> 	iommu_put_dma_cookie(domain);
>>>>
>>>> Instead of this change and the similar VFIO change
>>>
>>> Ack. I assume I should go with a smaller series starting with this
>>> "private_data_owner", and then later a bigger series for the other
>>> bits like translation_type that you mentioned in the other thread.
>>
>> That could work, you could bitfiled type and steal a few bits for
>> "private_data_owner" ?
>>
>> Then try the sw_msi removal at the same time too?
> 
> Ack. I drafted four patches:
>    iommu: Add private_data_owner to iommu_domain_free
>    iommu: Turn iova_cookie to dma-iommu private pointer
>    iommufd: Move iommufd_sw_msi and related functions to driver.c
>    iommu: Drop sw_msi from iommu_domain
> 
> Will do some proper build tests and then wrap them up.

Ah, I spent yesterday also writing up a patch to sort things out more 
generally - expect to see that shortly, then we can decide what we like.

Cheers,
Robin.

