Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336F7277D86
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 03:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgIYBQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 21:16:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:19131 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgIYBQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 21:16:02 -0400
IronPort-SDR: LR3nOIc2RDzAkGVlKfox2ym8TFf1dt1y4dhy7rnzRz4vuzCjd1SWS5Unxj5ZGGCT8ty5VHg/ze
 LmLKAuMgCLLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="158783710"
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="158783710"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 18:16:02 -0700
IronPort-SDR: NZiMjqbn0XOVlDBtUX7zjoy1iC028gY+0yUIsaChkilRAW690kEwU+Ebuf7GqU8PCaib8RhSY3
 jII3vzjkPEyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="413553113"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 24 Sep 2020 18:15:59 -0700
Cc:     baolu.lu@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/5] iommu aux-domain APIs extensions
To:     Joerg Roedel <joro@8bytes.org>
References: <20200922061042.31633-1-baolu.lu@linux.intel.com>
 <20200924095532.GK27174@8bytes.org>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <71f1fa5e-f468-0498-1ab4-1c2af9424d2d@linux.intel.com>
Date:   Fri, 25 Sep 2020 09:09:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924095532.GK27174@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg,

On 9/24/20 5:55 PM, Joerg Roedel wrote:
> On Tue, Sep 22, 2020 at 02:10:37PM +0800, Lu Baolu wrote:
>> Hi Jorge and Alex,
>>
>> A description of this patch series could be found here.
>>
>> https://lore.kernel.org/linux-iommu/20200901033422.22249-1-baolu.lu@linux.intel.com/
> 
> Hmm, I am wondering if we can avoid all this hassle and special APIs by
> making the mdev framework more visible outside of the vfio code. There
> is an underlying bus implementation for mdevs, so is there a reason
> those can't use the standard iommu-core code to setup IOMMU mappings?

The original purpose of this series is to enable the device driver to
retrieve the aux-domain through iommu core after iommu
ops.aux_attach_dev().

The domain was allocated in vfio/mdev, but it's also needed by the
device driver in mediated callbacks. The idea of this patch series is to
extend the aux-API so that the domain could be saved in group->domain
and get by the mediated driver through the existing
iommu_get_domain_for_dev().

Back when we were developing the aux-domain, I proposed to keep the
domain in vfio/mdev.

https://lore.kernel.org/linux-iommu/20181105073408.21815-7-baolu.lu@linux.intel.com/

It wasn't discussed at that time due to the lack of real consumer. Intel
is now adding aux-domain support in idxd (DMA streaming accelerator)
driver which becomes the first real consumer. So this problem is brought
back to the table.

> 
> What speaks against doing:
> 
> 	- IOMMU drivers capable of handling mdevs register iommu-ops
> 	  for the mdev_bus.
> 
> 	- iommu_domain_alloc() takes bus_type as parameter, so there can
> 	  be special domains be allocated for mdevs.
> 
> 	- Group creation and domain allocation will happen
> 	  automatically in the iommu-core when a new mdev is registered
> 	  through device-driver core code.
> 
> 	- There should be no need for special iommu_aux_* APIs, as one
> 	  can attach a domain directly to &mdev->dev with
> 	  iommu_attach_device(domain, &mdev->dev).
> 
> Doing it this way will probably also keep the mdev-special code in VFIO
> small.

Fully understand now. Thanks for guide.

> 
> Regards,
> 
> 	Joerg
> 

Best regards,
baolu
