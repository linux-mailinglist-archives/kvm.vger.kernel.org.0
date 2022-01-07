Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33B6486FE5
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 02:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344496AbiAGBuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 20:50:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:45746 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344437AbiAGBux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 20:50:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641520253; x=1673056253;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Rk4TSsiNTO3YfMWheOgfWU447KggZGjywO0GgwnX7XY=;
  b=SSFMxT9FgoQy3lYRGFjXF9Y9jb6UguAW2C3JmtooaUCFyoow14vokMg8
   ugNHPPyZ+0VNWww82ZQ9nDFvKBZ9iXopx5S01hbkZRK1afBoMgDCT08pU
   Gfdxa+YR44M+wzKCrBC7Stzn3U3ME/V0q1XmRd1qh4B5s0VPWGr/fGbQt
   zjnFF8agYL0Z5qKrWXlfvXxQ2TvuSBE82nY6bXV78wnrIAYUP3xlnNm4E
   AJL1dsrTtb8yjoPN+4Cwntf/BNyAWnR5u1CkgvHvg4ueCVfR+7fGQ5Mv9
   NL1TSUp9vHjKKr9cPS+QHAECNZW58z5GTiZhp29RmDwUz7CUzToSli4UC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10219"; a="303533983"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="303533983"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 17:50:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="527209322"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Jan 2022 17:50:45 -0800
Cc:     baolu.lu@linux.intel.com, Bjorn Helgaas <helgaas@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
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
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <YdQcgFhIMYvUwABV@infradead.org>
 <20220104164100.GA101735@bhelgaas> <20220104192348.GK2328285@nvidia.com>
 <9486face-0778-b8d0-6989-94c2e876446b@linux.intel.com>
 <20220106154635.GG2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b5fb659a-aa8b-587c-8bc1-20d7fd1ecd26@linux.intel.com>
Date:   Fri, 7 Jan 2022 09:50:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220106154635.GG2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/22 11:46 PM, Jason Gunthorpe wrote:
> On Thu, Jan 06, 2022 at 11:54:06AM +0800, Lu Baolu wrote:
>> On 1/5/22 3:23 AM, Jason Gunthorpe wrote:
>>>>>> The device driver oriented interfaces are,
>>>>>>
>>>>>> 	int iommu_device_use_dma_api(struct device *dev);
>>>>>> 	void iommu_device_unuse_dma_api(struct device *dev);
>>>> Nit, do we care whether it uses the actual DMA API?  Or is it just
>>>> that iommu_device_use_dma_api() tells us the driver may program the
>>>> device to do DMA?
>>> As the main purpose, yes this is all about the DMA API because it
>>> asserts the group domain is the DMA API's domain.
>>>
>>> There is a secondary purpose that has to do with the user/kernel
>>> attack you mentioned above. Maintaining the DMA API domain also
>>> prevents VFIO from allowing userspace to operate any device in the
>>> group which blocks P2P attacks to MMIO of other devices.
>>>
>>> This is why, even if the driver doesn't use DMA, it should still do a
>>> iommu_device_use_dma_api(), except in the special cases where we don't
>>> care about P2P attacks (eg pci-stub, bridges, etc).
>>>
>>
>> By the way, use_dma_api seems hard to read. How about
>>
>> 	iommu_device_use_default_dma()?
> 
> You could just say "use default domain"
> 
> IMHO the way the iommu subsystem has its own wonky language is a
> little troublesome. In the rest of the kernel we call this the DMA
> API, while the iommu subsystem calls the domain that the DMA API uses
> the 'default domain' not the 'DMA API' domain.
> 
> Still, it is probably better to align to the iommu language - just be
> sure to put in the function comment that this API 'allows the driver
> to use the DMA API eg dma_map_sg()'

iommu_device_use_default_domain() reads better. And add some comments
to link "default domain" with "DMA API". Thanks!

> 
> Jason
> 

Best regards,
baolu
