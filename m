Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA2641B0F0
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 15:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241020AbhI1Nhb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 09:37:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:37605 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240971AbhI1NhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 09:37:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="222803124"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="222803124"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 06:35:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="553993941"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.212.203]) ([10.254.212.203])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 06:35:08 -0700
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
Date:   Tue, 28 Sep 2021 21:35:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928115751.GK964074@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2021/9/28 19:57, Jason Gunthorpe wrote:
> On Tue, Sep 28, 2021 at 07:30:41AM +0000, Tian, Kevin wrote:
> 
>>> Also, don't call it "hint", there is nothing hinty about this, it has
>>> definitive functional impacts.
>>
>> possibly dma_mode (too broad?) or dma_usage
> 
> You just need a flag to specify if the driver manages DMA ownership
> itself, or if it requires the driver core to setup kernel ownership
> 
> DMA_OWNER_KERNEL
> DMA_OWNER_DRIVER_CONTROLLED
> 
> ?
> 
> There is a bool 'suprress_bind_attrs' already so it could be done like
> this:
> 
>   bool suppress_bind_attrs:1;
> 
>   /* If set the driver must call iommu_XX as the first action in probe() */
>   bool suppress_dma_owner:1;
> 
> Which is pretty low cost.

Yes. Pretty low cost to fix the BUG_ON() issue. Any kernel-DMA driver
binding is blocked if the device's iommu group has been put into user-
dma mode.

Another issue is, when putting a device into user-dma mode, all devices
belonging to the same iommu group shouldn't be bound with a kernel-dma
driver. Kevin's prototype checks this by READ_ONCE(dev->driver). This is
not lock safe as discussed below,

https://lore.kernel.org/linux-iommu/20210927130935.GZ964074@nvidia.com/

Any guidance on this?

Best regards,
baolu
