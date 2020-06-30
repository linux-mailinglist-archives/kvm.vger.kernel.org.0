Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED0920EAB0
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 03:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgF3BHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 21:07:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:23695 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgF3BHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 21:07:38 -0400
IronPort-SDR: 53mf9w8FfSoIP3vhlKdpOoIaQRWSO4Br3dHpnwmKyzyq9+Hr3C4mF5rGJLasCfREHWkkYIjZOI
 zheaixob2dJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="230966044"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="230966044"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:07:37 -0700
IronPort-SDR: kGRx+YEb453Pvy0g34UT43n3nzebgsN3dhv0bzJr1xJsVPwByS5GbjR+8qM+7tv+pkXsq5gbxp
 UJ+wLUq786mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="264981824"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 18:07:34 -0700
Cc:     baolu.lu@linux.intel.com, Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] iommu: Add iommu_group_get/set_domain()
To:     Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20200627031532.28046-1-baolu.lu@linux.intel.com>
 <acc0a8fd-bd23-fc34-aecc-67796ab216e7@arm.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <5dc1cece-6111-9b56-d04c-9553d592675b@linux.intel.com>
Date:   Tue, 30 Jun 2020 09:03:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <acc0a8fd-bd23-fc34-aecc-67796ab216e7@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Robin,

On 6/29/20 7:56 PM, Robin Murphy wrote:
> On 2020-06-27 04:15, Lu Baolu wrote:
>> The hardware assistant vfio mediated device is a use case of iommu
>> aux-domain. The interactions between vfio/mdev and iommu during mdev
>> creation and passthr are:
>>
>> - Create a group for mdev with iommu_group_alloc();
>> - Add the device to the group with
>>          group = iommu_group_alloc();
>>          if (IS_ERR(group))
>>                  return PTR_ERR(group);
>>
>>          ret = iommu_group_add_device(group, &mdev->dev);
>>          if (!ret)
>>                  dev_info(&mdev->dev, "MDEV: group_id = %d\n",
>>                           iommu_group_id(group));
>> - Allocate an aux-domain
>>     iommu_domain_alloc()
>> - Attach the aux-domain to the physical device from which the mdev is
>>    created.
>>     iommu_aux_attach_device()
>>
>> In the whole process, an iommu group was allocated for the mdev and an
>> iommu domain was attached to the group, but the group->domain leaves
>> NULL. As the result, iommu_get_domain_for_dev() doesn't work anymore.
>>
>> This adds iommu_group_get/set_domain() so that group->domain could be
>> managed whenever a domain is attached or detached through the aux-domain
>> api's.
> 
> Letting external callers poke around directly in the internals of 
> iommu_group doesn't look right to me.

Unfortunately, it seems that the vifo iommu abstraction is deeply bound
to the IOMMU subsystem. We can easily find other examples:

iommu_group_get/set_iommudata()
iommu_group_get/set_name()
...

> 
> If a regular device is attached to one or more aux domains for PASID 
> use, iommu_get_domain_for_dev() is still going to return the primary 
> domain, so why should it be expected to behave differently for mediated

Unlike the normal device attach, we will encounter two devices when it
comes to aux-domain.

- Parent physical device - this might be, for example, a PCIe device
with PASID feature support, hence it is able to tag an unique PASID
for DMA transfers originated from its subset. The device driver hence
is able to wrapper this subset into an isolated:

- Mediated device - a fake device created by the device driver mentioned
above.

Yes. All you mentioned are right for the parent device. But for mediated
device, iommu_get_domain_for_dev() doesn't work even it has an valid
iommu_group and iommu_domain.

iommu_get_domain_for_dev() is a necessary interface for device drivers
which want to support aux-domain. For example,

           struct iommu_domain *domain;
           struct device *dev = mdev_dev(mdev);
	  unsigned long pasid;

           domain = iommu_get_domain_for_dev(dev);
           if (!domain)
                   return -ENODEV;

           pasid = iommu_aux_get_pasid(domain, dev->parent);
	  if (pasid == IOASID_INVALID)
		  return -EINVAL;

	  /* Program the device context with the PASID value */
	  ....

Without this fix, iommu_get_domain_for_dev() always returns NULL and the
device driver has no means to support aux-domain.

Best regards,
baolu

> devices? AFAICS it's perfectly legitimate to have no primary domain if 
> traffic-without-PASID is invalid.
> 
> Robin.
