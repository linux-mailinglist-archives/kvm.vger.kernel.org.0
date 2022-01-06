Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C0485F21
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 04:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiAFDTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 22:19:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:13445 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbiAFDTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 22:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641439150; x=1672975150;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=jVs1PWNNKTf5pqsikfeVCGpxxqUkOICSdcJS6faPCaM=;
  b=MvKbXQ4wF3qU6a/wkmKEKpY4wVAGI4VQxJd/Uq5Xd8/1lzq7Oj/AEV9Z
   nV9SuiAg82yUL7ydIrGI5RTLaIoyZDmwbVn6NLlPbR2KotqP8bjtrVAmV
   wOi/gMS2VthEJ5zkhZuGoHp/BpQDIpFuMGBarm0LmeaP/eptUdncXLGyJ
   gt9q47sHXtaUBlCOl5qe8b7zannkUBooRZb1kzVzuPWNj9OKaTLAQYocp
   UgLJKYms7ihvmcgARoT1IYVU9WJb6HalnKlj67qXqNYIR1kxeZThZNSPt
   lEpZ3VscZudu+Dqwu+fnbwW0zc/cE7P3GIaE0HJGoqGCMbPJKzhGEHKVG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240127293"
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="240127293"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 19:19:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,265,1635231600"; 
   d="scan'208";a="526808939"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2022 19:19:03 -0800
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/14] iommu: Add dma ownership management interfaces
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>
References: <YdQcgFhIMYvUwABV@infradead.org>
 <20220104164100.GA101735@bhelgaas> <20220104192348.GK2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <370335ad-0a2f-3668-9229-c65896f12828@linux.intel.com>
Date:   Thu, 6 Jan 2022 11:18:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104192348.GK2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 3:23 AM, Jason Gunthorpe wrote:
>>>> The vfio oriented interfaces are,
>>>>
>>>> 	int iommu_group_set_dma_owner(struct iommu_group *group,
>>>> 				      void *owner);
>>>> 	void iommu_group_release_dma_owner(struct iommu_group *group);
>>>> 	bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>>>>
>>>> The device userspace assignment must be disallowed if the set dma owner
>>>> interface returns failure.
>> Can you connect this back to the "never a mixture" from the beginning?
>> If all you cared about was prevent an IOMMU group from containing
>> devices with a mixture of kernel drivers and userspace drivers, I
>> assume you could do that without iommu_device_use_dma_api().  So is
>> this a way to*allow*  a mixture under certain restricted conditions?
> It is not about user/kernel, it is about arbitrating the shared
> group->domain against multiple different requests to set it to
> something else.
> 
> Lu, Given that the word 'user' was deleted from the API entirely it
> makes sense to reword these commit messages to focus less on user vs
> kernel and more on ownership of the domain pointer.

Sure. Will do it.

Best regards,
baolu
