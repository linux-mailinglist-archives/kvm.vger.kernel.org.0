Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E98447EA50
	for <lists+kvm@lfdr.de>; Fri, 24 Dec 2021 02:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350829AbhLXBaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 20:30:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:4950 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245122AbhLXBav (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 20:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640309451; x=1671845451;
  h=cc:subject:to:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=JjtBgOF28/vwd8lH1VxYSdGqqqEZptc6KfCcvvY2TOw=;
  b=DatNdB+9cyIoUt+WPoqDxJLeyOd4mhonXbno6RkONRcX1/71sKCOHAe6
   u2lyY4DtLj2FmqWh3YzWgBRCUPsTcXapn47b1MbwLL8Hqh6gKAQnB30AD
   YrPNvabyyyndzBlpPD5/3uYJoHVq/RjPb4H4s2LrkRbVPXvttC6x+d5oV
   oetLYr7AaR0flVNxm3SfLDmBqAFONB9Sm/pR8S8Nv+xHy460eeyW3IZqb
   MD0WsYvR7Nun1lTIuZtaTthBEnLxAEV66JhJ+lmlPCLS6uBq/lDSQlqxa
   hvwxK5RvqXcO3I6s8yPmjRGkJ1bIqtZYWMAj8u7XQST8GCnfpHdFsNylt
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10207"; a="301672017"
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="301672017"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 17:30:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="664737519"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2021 17:30:43 -0800
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v4 07/13] iommu: Add iommu_at[de]tach_device_shared() for
 multi-device groups
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20211217063708.1740334-1-baolu.lu@linux.intel.com>
 <20211217063708.1740334-8-baolu.lu@linux.intel.com>
 <dd797dcd-251a-1980-ca64-bb38e67a526f@arm.com>
 <20211221184609.GF1432915@nvidia.com>
 <aebbd9c7-a239-0f89-972b-a9059e8b218b@arm.com>
 <20211223005712.GA1779224@nvidia.com>
 <fea0fc91-ac4c-dfe4-f491-5f906bea08bd@linux.intel.com>
 <20211223140300.GC1779224@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <50b8bb0f-3873-b128-48e8-22f6142f7118@linux.intel.com>
Date:   Fri, 24 Dec 2021 09:30:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211223140300.GC1779224@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 12/23/21 10:03 PM, Jason Gunthorpe wrote:
>>> I think it would be clear why iommu_group_set_dma_owner(), which
>>> actually does detatch, is not the same thing as iommu_attach_device().
>> iommu_device_set_dma_owner() will eventually call
>> iommu_group_set_dma_owner(). I didn't get why
>> iommu_group_set_dma_owner() is special and need to keep.
> Not quite, they would not call each other, they have different
> implementations:
> 
> int iommu_device_use_dma_api(struct device *device)
> {
> 	struct iommu_group *group = device->iommu_group;
> 
> 	if (!group)
> 		return 0;
> 
> 	mutex_lock(&group->mutex);
> 	if (group->owner_cnt != 0 ||
> 	    group->domain != group->default_domain) {
> 		mutex_unlock(&group->mutex);
> 		return -EBUSY;
> 	}
> 	group->owner_cnt = 1;
> 	group->owner = NULL;
> 	mutex_unlock(&group->mutex);
> 	return 0;
> }

It seems that this function doesn't work for multi-device groups. When
the user unbinds all native drivers from devices in the group and start
to bind them with vfio-pci and assign them to user, how could iommu know
whether the group is viable for user?

> 
> int iommu_group_set_dma_owner(struct iommu_group *group, struct file *owner)
> {
> 	mutex_lock(&group->mutex);
> 	if (group->owner_cnt != 0) {
> 		if (group->owner != owner)
> 			goto err_unlock;
> 		group->owner_cnt++;
> 		mutex_unlock(&group->mutex);
> 		return 0;
> 	}
> 	if (group->domain && group->domain != group->default_domain)
> 		goto err_unlock;
> 
> 	__iommu_detach_group(group->domain, group);
> 	group->owner_cnt = 1;
> 	group->owner = owner;
> 	mutex_unlock(&group->mutex);
> 	return 0;
> 
> err_unlock;
> 	mutex_unlock(&group->mutex);
> 	return -EBUSY;
> }
> 
> It is the same as how we ended up putting the refcounting logic
> directly into the iommu_attach_device().
> 
> See, we get rid of the enum as a multiplexor parameter, each API does
> only wnat it needs, they don't call each other.

I like the idea of removing enum parameter and make the API name
specific. But I didn't get why they can't call each other even the
data in group is the same.

> 
> We don't need _USER anymore because iommu_group_set_dma_owner() always
> does detatch, and iommu_replace_group_domain() avoids ever reassigning
> default_domain. The sepecial USER behavior falls out automatically.

This means we will grow more group-centric interfaces. My understanding
is the opposite that we should hide the concept of group in IOMMU
subsystem, and the device drivers only faces device specific interfaces.

The iommu groups are created by the iommu subsystem. The device drivers
don't play any role in determining which device belongs to which group.
So the iommu interfaces for device driver shouldn't rely on the group.

Best regards,
baolu
