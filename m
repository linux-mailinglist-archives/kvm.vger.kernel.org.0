Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13D6484E7B
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 07:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiAEGw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 01:52:57 -0500
Received: from mga06.intel.com ([134.134.136.31]:17379 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbiAEGw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 01:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641365576; x=1672901576;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=NfLc3B58P2xIUXLczC9zkU0pb72XnW/r7ysxWZe4Nnw=;
  b=ShMpdl0jmPfZmtTtFE04uwMekIluZUELtKLmOHatMLNy/BfzxFmDMaue
   D3OH4xBc3E7ygmU+Dh68R5tRq6qLVUtgyuEdsnYNSTu6w6WJYJ5jUpNUx
   SsBJJ30ZvM71Untl57j/YQkreI6AvGr++DBOyG4N4zmlJtMVkcfxnC+Pv
   8kO6sw6D0CoX9JvP9Iv3Jhub9Sy35VPAM1uMhhfXvcrXx6OZtmqq95whn
   HRb0O6KTHLwP3C/mCfCMv894Ng+7CwH2HGY+rm8Womt06DBgTfoUjy5lA
   gn9749xxdzZa9PUhI69399y6EUfJf9IL7SIioPwPyFeKT+3q/9UkqlqlQ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="303134244"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="303134244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 22:52:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="526391598"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga008.jf.intel.com with ESMTP; 04 Jan 2022 22:52:48 -0800
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
Subject: Re: [PATCH v5 00/14] Fix BUG_ON in vfio_iommu_group_notifier()
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104124800.GF2328285@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <f42e5d09-6578-98a4-a0f3-097f69bb7c3a@linux.intel.com>
Date:   Wed, 5 Jan 2022 14:52:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220104124800.GF2328285@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 1/4/22 8:48 PM, Jason Gunthorpe wrote:
> On Tue, Jan 04, 2022 at 09:56:30AM +0800, Lu Baolu wrote:
> 
>> v5:
>>    - Move kernel dma ownership auto-claiming from driver core to bus
>>      callback. (Greg)
>>    - Refactor the iommu interfaces to make them more specific.
>>      (Jason/Robin)
>>    - Simplify the dma ownership implementation by removing the owner
>>      type. (Jason)
>>    - Commit message refactoring for PCI drivers. (Bjorn)
>>    - Move iommu_attach/detach_device() improvement patches into another
>>      series as there are a lot of code refactoring and cleanup staffs
>>      in various device drivers.
> 
> Since you already have the code you should make this 'other series'
> right now. It should delete iommu_group_attach() and fix
> iommu_device_attach().

Yes. I am doing the functional and compile tests. I will post it once I
complete the testing.

> 
> You also didn't really do my suggestion, this messes up the normal
> __iommu_attach_group()/__iommu_detach_group() instead of adding the
> clear to purpose iommu_replace_group() for VFIO to use. This just
> makes it more difficult to normalize the APIs.

I didn't forget that. :-) It's part of the new series.

> 
> Otherwise it does seem to have turned out to be more understandable.
> 
> Jason
> 

Best regards,
baolu
