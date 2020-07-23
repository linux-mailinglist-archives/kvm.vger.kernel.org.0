Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACBE22B0D7
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbgGWN4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 09:56:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:31940 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbgGWN4G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 09:56:06 -0400
IronPort-SDR: PIQ3QiaNhlzLGinTIuwfnAj8MDytEyW6XEHbKNzPz/48h2zNztC1XlBC1LHzmWH1tr6dFLXs6K
 pwZTJbubijWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="215132657"
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="215132657"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 06:56:04 -0700
IronPort-SDR: SIAukGYZbjWvyy0aLs0D8OR6l46I51tDLGzOil9oSQS2xiBwpLatn3fS4/poyVdi7TcZ0H+Rpp
 6RyeS99Yu2Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="488375975"
Received: from ychan16-mobl1.ccr.corp.intel.com (HELO [10.255.29.206]) ([10.255.29.206])
  by fmsmga006.fm.intel.com with ESMTP; 23 Jul 2020 06:56:00 -0700
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/4] iommu aux-domain APIs extensions
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <f5f3e7bc-6c88-5680-ad6f-f1eb721a7445@linux.intel.com>
Date:   Thu, 23 Jul 2020 21:55:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714055703.5510-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg and Alex,

Any comments for this series?

Just check to see whether we could make it for v5.9. The first aux-
domain capable device driver has been posted [1].

[1] 
https://lore.kernel.org/linux-pci/159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com/

Best regards,
baolu

On 2020/7/14 13:56, Lu Baolu wrote:
> This series aims to extend the IOMMU aux-domain API set so that it
> could be more friendly to vfio/mdev usage. The interactions between
> vfio/mdev and iommu during mdev creation and passthr are:
> 
> 1. Create a group for mdev with iommu_group_alloc();
> 2. Add the device to the group with
> 
>         group = iommu_group_alloc();
>         if (IS_ERR(group))
>                 return PTR_ERR(group);
> 
>         ret = iommu_group_add_device(group, &mdev->dev);
>         if (!ret)
>                 dev_info(&mdev->dev, "MDEV: group_id = %d\n",
>                          iommu_group_id(group));
> 
> 3. Allocate an aux-domain with iommu_domain_alloc();
> 4. Attach the aux-domain to the iommu_group.
> 
>         iommu_group_for_each_dev {
>                 if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
>                         return iommu_aux_attach_device(domain, iommu_device);
>                 else
>                         return iommu_attach_device(domain, iommu_device);
>          }
> 
>     where, iommu_device is the aux-domain-capable device. The mdev's in
>     the group are all derived from it.
> 
> In the whole process, an iommu group was allocated for the mdev and an
> iommu domain was attached to the group, but the group->domain leaves
> NULL. As the result, iommu_get_domain_for_dev() (or other similar
> interfaces) doesn't work anymore.
> 
> The iommu_get_domain_for_dev() is a necessary interface for device
> drivers that want to support vfio/mdev based aux-domain. For example,
> 
>          unsigned long pasid;
>          struct iommu_domain *domain;
>          struct device *dev = mdev_dev(mdev);
>          struct device *iommu_device = vfio_mdev_get_iommu_device(dev);
> 
>          domain = iommu_get_domain_for_dev(dev);
>          if (!domain)
>                  return -ENODEV;
> 
>          pasid = iommu_aux_get_pasid(domain, iommu_device);
>          if (pasid <= 0)
>                  return -EINVAL;
> 
>           /* Program the device context */
>           ....
> 
> We tried to address this by extending iommu_aux_at(de)tach_device() so that
> the users could pass in an optional device pointer (for example vfio/mdev).
> (v2 of this series)
> 
> https://lore.kernel.org/linux-iommu/20200707013957.23672-1-baolu.lu@linux.intel.com/
> 
> But that will cause a lock issue as group->mutex has been applied in
> iommu_group_for_each_dev(), but has to be reapplied again in the
> iommu_aux_attach_device().
> 
> This version tries to address this by introducing two new APIs into the
> aux-domain API set:
> 
> /**
>   * iommu_aux_attach_group - attach an aux-domain to an iommu_group which
>   *                          contains sub-devices (for example mdevs)
>   *                          derived from @dev.
>   * @domain: an aux-domain;
>   * @group:  an iommu_group which contains sub-devices derived from @dev;
>   * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>   *
>   * Returns 0 on success, or an error value.
>   */
> int iommu_aux_attach_group(struct iommu_domain *domain,
>                             struct iommu_group *group, struct device *dev)
> 
> /**
>   * iommu_aux_detach_group - detach an aux-domain from an iommu_group
>   *
>   * @domain: an aux-domain;
>   * @group:  an iommu_group which contains sub-devices derived from @dev;
>   * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>   *
>   * @domain must have been attached to @group via
>   * iommu_aux_attach_group().
>   */
> void iommu_aux_detach_group(struct iommu_domain *domain,
>                              struct iommu_group *group, struct device *dev)
> 
> This version is evolved according to feedbacks from Robin(v1) and
> Alex(v2). Your comments are very appreciated.
> 
> Best regards,
> baolu
> 
> ---
> Change log:
>   - v1->v2:
>     - https://lore.kernel.org/linux-iommu/20200627031532.28046-1-baolu.lu@linux.intel.com/
>     - Suggested by Robin.
> 
>   - v2->v3:
>     - https://lore.kernel.org/linux-iommu/20200707013957.23672-1-baolu.lu@linux.intel.com/
>     - Suggested by Alex
> 
> Lu Baolu (4):
>    iommu: Check IOMMU_DEV_FEAT_AUX feature in aux api's
>    iommu: Add iommu_aux_at(de)tach_group()
>    iommu: Add iommu_aux_get_domain_for_dev()
>    vfio/type1: Use iommu_aux_at(de)tach_group() APIs
> 
>   drivers/iommu/iommu.c           | 92 ++++++++++++++++++++++++++++++---
>   drivers/vfio/vfio_iommu_type1.c | 44 +++-------------
>   include/linux/iommu.h           | 24 +++++++++
>   3 files changed, 116 insertions(+), 44 deletions(-)
> 
