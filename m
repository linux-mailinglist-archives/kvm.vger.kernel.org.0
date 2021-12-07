Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5CA46B0AE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 03:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbhLGCht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 21:37:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:6439 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhLGChs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 21:37:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="217498038"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="217498038"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 18:34:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="515056584"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 06 Dec 2021 18:34:11 -0800
Cc:     baolu.lu@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Subject: Re: [PATCH v3 18/18] drm/tegra: Use the iommu dma_owner mechanism
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-19-baolu.lu@linux.intel.com>
 <20211206124033.GY4670@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b99c974b-d7a6-900a-1de1-4e926b93c9ce@linux.intel.com>
Date:   Tue, 7 Dec 2021 10:34:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206124033.GY4670@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 8:40 PM, Jason Gunthorpe wrote:
> On Mon, Dec 06, 2021 at 09:59:03AM +0800, Lu Baolu wrote:
> 
>> @@ -941,48 +944,44 @@ int host1x_client_iommu_attach(struct host1x_client *client)
>>   	 * not the shared IOMMU domain, don't try to attach it to a different
>>   	 * domain. This allows using the IOMMU-backed DMA API.
>>   	 */
>> -	if (domain && domain != tegra->domain)
>> +	client->group = NULL;
>> +	if (!client->dev->iommu_group || (domain && domain != tegra->domain))
>> +		return iommu_device_set_dma_owner(client->dev,
>> +						  DMA_OWNER_DMA_API, NULL);
>> +
>> +	if (!tegra->domain)
>>   		return 0;
> 
> This if should be removed completely now
> 
> Jason
> 

Sure.

Best regards,
baolu
