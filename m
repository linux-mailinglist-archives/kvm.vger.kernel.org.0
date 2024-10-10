Return-Path: <kvm+bounces-28372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 777D1997FC6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 10:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 147D81F25044
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 08:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEAC1FF7CE;
	Thu, 10 Oct 2024 07:45:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D6F1B5337;
	Thu, 10 Oct 2024 07:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728546314; cv=none; b=uv5WIlUBb3dZ63ItG2Xl9ozHWtg7NLGMCvAKwWtHHAVLcubyHBGvlhVxf8FdnzGG1KhUB/CEH19hH6VFxEr54toabVffRcU1TNIZZKGXJnlfMD1CdtwszFpgCNUnB3ycbyuOTLHSvHR68WIzKuf0V6mgAN8nN6gA5VMOOkWjgbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728546314; c=relaxed/simple;
	bh=cS2TIFxGUB5Comdq0Q2G2vFiFm96puaf/ga5iXFe2ts=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Pdy6o0Oz2QpAF+13FG4U0f7tY4ZA8m6JH6rwiDnHGJUE/ahgiRW8ZZ9ATWE1c4tCFWKafKYsjgvYKkSmBmHbw9fls339qW/clPfMoKBZzv8eDhC8eG7qCjxJIZz92QGDP+Lym5HS/MAefpIvxKZabUfAtCG6+H8BdjqTjFWOaKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XPMDQ21KDzfdCy;
	Thu, 10 Oct 2024 15:42:46 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 700BB1400D8;
	Thu, 10 Oct 2024 15:45:10 +0800 (CST)
Received: from [10.174.178.247] (10.174.178.247) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 10 Oct 2024 15:45:09 +0800
Subject: Re: [PATCH v3 3/9] ACPI/IORT: Support CANWBS memory access flag
To: Jason Gunthorpe <jgg@nvidia.com>, <acpica-devel@lists.linux.dev>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, Lorenzo
 Pieralisi <lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin
 Chen <nicolinc@nvidia.com>, <patches@lists.linux.dev>, "Rafael J. Wysocki"
	<rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
References: <3-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
From: Hanjun Guo <guohanjun@huawei.com>
Message-ID: <180134a4-051e-3a92-1652-0c3c53ffd6fa@huawei.com>
Date: Thu, 10 Oct 2024 15:45:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500002.china.huawei.com (7.185.36.57)

On 2024/10/10 0:23, Jason Gunthorpe wrote:
> From: Nicolin Chen<nicolinc@nvidia.com>
> 
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memory
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
> 
> This CANWBS defines the coherency of memory accesses to be not marked IOWB
> cacheable/shareable. Its value further implies the coherency impact from a
> pair of mismatched memory attributes (e.g. in a nested translation case):
>    0x0: Use of mismatched memory attributes for accesses made by this
>         device may lead to a loss of coherency.
>    0x1: Coherency of accesses made by this device to locations in
>         Conventional memory are ensured as follows, even if the memory
>         attributes for the accesses presented by the device or provided by
>         the SMMU are different from Inner and Outer Write-back cacheable,
>         Shareable.
> 
> Note that the loss of coherency on a CANWBS-unsupported HW typically could
> occur to an SMMU that doesn't implement the S2FWB feature where additional
> cache flush operations would be required to prevent that from happening.
> 
> Add a new ACPI_IORT_MF_CANWBS flag and set IOMMU_FWSPEC_PCI_RC_CANWBS upon
> the presence of this new flag.
> 
> CANWBS and S2FWB are similar features, in that they both guarantee the VM
> can not violate coherency, however S2FWB can be bypassed by PCI No Snoop
> TLPs, while CANWBS cannot. Thus CANWBS meets the requirements to set
> IOMMU_CAP_ENFORCE_CACHE_COHERENCY.
> 
> Architecturally ARM has expected that VFIO would disable No Snoop through
> PCI Config space, if this is done then the two would have the same
> protections.

Acked-by: Hanjun Guo <guohanjun@huawei.com>

Thanks
Hanjun

