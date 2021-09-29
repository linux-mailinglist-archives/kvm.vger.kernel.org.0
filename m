Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CDC41BCB2
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 04:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243777AbhI2C1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 22:27:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:64380 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243226AbhI2C1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 22:27:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="204995620"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="204995620"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 19:25:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="476495153"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 28 Sep 2021 19:25:45 -0700
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
 <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
 <20210928140712.GL964074@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <4ba3294b-1628-0522-17ff-8aa38ed5a615@linux.intel.com>
Date:   Wed, 29 Sep 2021 10:22:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210928140712.GL964074@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/21 10:07 PM, Jason Gunthorpe wrote:
> On Tue, Sep 28, 2021 at 09:35:05PM +0800, Lu Baolu wrote:
>> Another issue is, when putting a device into user-dma mode, all devices
>> belonging to the same iommu group shouldn't be bound with a kernel-dma
>> driver. Kevin's prototype checks this by READ_ONCE(dev->driver). This is
>> not lock safe as discussed below,
>>
>> https://lore.kernel.org/linux-iommu/20210927130935.GZ964074@nvidia.com/
>>
>> Any guidance on this?
> 
> Something like this?
> 
> 
> int iommu_set_device_dma_owner(struct device *dev, enum device_dma_owner mode,
> 			       struct file *user_owner)
> {
> 	struct iommu_group *group = group_from_dev(dev);
> 
> 	spin_lock(&iommu_group->dma_owner_lock);
> 	switch (mode) {
> 		case DMA_OWNER_KERNEL:
> 			if (iommu_group->dma_users[DMA_OWNER_USERSPACE])
> 				return -EBUSY;
> 			break;
> 		case DMA_OWNER_SHARED:
> 			break;
> 		case DMA_OWNER_USERSPACE:
> 			if (iommu_group->dma_users[DMA_OWNER_KERNEL])
> 				return -EBUSY;
> 			if (iommu_group->dma_owner_file != user_owner) {
> 				if (iommu_group->dma_users[DMA_OWNER_USERSPACE])
> 					return -EPERM;
> 				get_file(user_owner);
> 				iommu_group->dma_owner_file = user_owner;
> 			}
> 			break;
> 		default:
> 			spin_unlock(&iommu_group->dma_owner_lock);
> 			return -EINVAL;
> 	}
> 	iommu_group->dma_users[mode]++;
> 	spin_unlock(&iommu_group->dma_owner_lock);
> 	return 0;
> }
> 
> int iommu_release_device_dma_owner(struct device *dev,
> 				   enum device_dma_owner mode)
> {
> 	struct iommu_group *group = group_from_dev(dev);
> 
> 	spin_lock(&iommu_group->dma_owner_lock);
> 	if (WARN_ON(!iommu_group->dma_users[mode]))
> 		goto err_unlock;
> 	if (!iommu_group->dma_users[mode]--) {
> 		if (mode == DMA_OWNER_USERSPACE) {
> 			fput(iommu_group->dma_owner_file);
> 			iommu_group->dma_owner_file = NULL;
> 		}
> 	}
> err_unlock:
> 	spin_unlock(&iommu_group->dma_owner_lock);
> }
> 
> 
> Where, the driver core does before probe:
> 
>     iommu_set_device_dma_owner(dev, DMA_OWNER_KERNEL, NULL)
> 
> pci_stub/etc does in their probe func:
> 
>     iommu_set_device_dma_owner(dev, DMA_OWNER_SHARED, NULL)
> 
> And vfio/iommfd does when a struct vfio_device FD is attached:
> 
>     iommu_set_device_dma_owner(dev, DMA_OWNER_USERSPACE, group_file/iommu_file)

Really good design. It also helps alleviating some pains elsewhere in
the iommu core.

Just a nit comment, we also need DMA_OWNER_NONE which will be set when
the driver core unbinds the driver from the device.

> 
> Jason
> 

Best regards,
baolu
