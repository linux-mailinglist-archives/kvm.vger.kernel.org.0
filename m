Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CCB258657
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 05:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIADkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 23:40:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:62487 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgIADkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 23:40:10 -0400
IronPort-SDR: GAFvU7O0EQRfcymRArsXWKjZP3g/ubMy11GaareUnUBGHphZ15cb+uVGOiEvxOues+4njavCjD
 yqJtbF0abb5w==
X-IronPort-AV: E=McAfee;i="6000,8403,9730"; a="136620916"
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="136620916"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 20:40:09 -0700
IronPort-SDR: xGboYKzvsJlkHn6PaFg2gJdD6Ho9X+J4xWldMcYK4l8ocnu41LSY2oGnWtKaxhn0DKvjOlZD+S
 0KuPivwRFKtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,377,1592895600"; 
   d="scan'208";a="325180845"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga004.fm.intel.com with ESMTP; 31 Aug 2020 20:40:06 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 0/5] iommu aux-domain APIs extensions
Date:   Tue,  1 Sep 2020 11:34:17 +0800
Message-Id: <20200901033422.22249-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims to extend the IOMMU aux-domain API set so that it
could be more friendly to vfio/mdev usage. The interactions between
vfio/mdev and iommu during mdev creation and passthr are:

1. Create a group for mdev with iommu_group_alloc();
2. Add the device to the group with

       group = iommu_group_alloc();
       if (IS_ERR(group))
               return PTR_ERR(group);

       ret = iommu_group_add_device(group, &mdev->dev);
       if (!ret)
               dev_info(&mdev->dev, "MDEV: group_id = %d\n",
                        iommu_group_id(group));

3. Allocate an aux-domain with iommu_domain_alloc();
4. Attach the aux-domain to the iommu_group.

       iommu_group_for_each_dev {
               if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
                       return iommu_aux_attach_device(domain, iommu_device);
               else
                       return iommu_attach_device(domain, iommu_device);
        }

   where, iommu_device is the aux-domain-capable device. The mdev's in
   the group are all derived from it.

In the whole process, an iommu group was allocated for the mdev and an
iommu domain was attached to the group, but the group->domain leaves
NULL. As the result, iommu_get_domain_for_dev() (or other similar
interfaces) doesn't work anymore.

The iommu_get_domain_for_dev() is a necessary interface for device
drivers that want to support vfio/mdev based aux-domain. For example,

        unsigned long pasid;
        struct iommu_domain *domain;
        struct device *dev = mdev_dev(mdev);
        struct device *iommu_device = vfio_mdev_get_iommu_device(dev);

        domain = iommu_aux_get_domain_for_dev(dev);
        if (!domain)
                return -ENODEV;

        pasid = iommu_aux_get_pasid(domain, iommu_device);
        if (pasid <= 0)
                return -EINVAL;

         /* Program the device context */
         ....

We tried to address this by extending iommu_aux_at(de)tach_device() so that
the users could pass in an optional device pointer (for example vfio/mdev).
(v2 of this series)

https://lore.kernel.org/linux-iommu/20200707013957.23672-1-baolu.lu@linux.intel.com/

But that will cause a lock issue as group->mutex has been applied in
iommu_group_for_each_dev(), but has to be reapplied again in the
iommu_aux_attach_device().

We also tried to implement an equivalent iommu_attch_group() for groups
which includes subdevices derived from a single physical device. (v3 of
this series)

https://lore.kernel.org/linux-iommu/20200714055703.5510-1-baolu.lu@linux.intel.com/

But that's too harsh (requires that all subdevices in an iommu_group
must be derived from a same physical device) and breaks some generic
concept of iommmu_group.

This version continues to address this by introducing some new APIs into
the aux-domain API set according to comments during v3 reviewing period.

/**
 * iommu_attach_subdev_group - attach domain to an iommu_group which
 *                             contains subdevices.
 *
 * @domain: domain
 * @group:  iommu_group which contains subdevices
 * @fn:     callback for each subdevice in the @iommu_group to retrieve the
 *          physical device where the subdevice was created from.
 *
 * Returns 0 on success, or an error value.
 */
int iommu_attach_subdev_group(struct iommu_domain *domain,
                              struct iommu_group *group,
                              iommu_device_lookup_t fn)

/**
 * iommu_detach_subdev_group - detach domain from an iommu_group which
 *                             contains subdevices
 *
 * @domain: domain
 * @group:  iommu_group which contains subdevices
 * @fn:     callback for each subdevice in the @iommu_group to retrieve the
 *          physical device where the subdevice was created from.
 *
 * The domain must have been attached to @group via iommu_attach_subdev_group().
 */
void iommu_detach_subdev_group(struct iommu_domain *domain,
                               struct iommu_group *group,
                               iommu_device_lookup_t fn)

struct iommu_domain *iommu_aux_get_domain_for_dev(struct device *subdev)

This version is evolved according to feedbacks from Robin, Alex and Kevin.
I'm very appreciated to their contributions.

Best regards,
baolu

---
Change log:
 - v1->v2:
   - https://lore.kernel.org/linux-iommu/20200627031532.28046-1-baolu.lu@linux.intel.com/
   - Suggested by Robin.

 - v2->v3:
   - https://lore.kernel.org/linux-iommu/20200707013957.23672-1-baolu.lu@linux.intel.com/
   - Suggested by Alex, Kevin.

 - v3->v4:
   - https://lore.kernel.org/linux-iommu/20200714055703.5510-1-baolu.lu@linux.intel.com/
   - Evolve the aux_attach_group APIs to take an iommu_device lookup
     callback.
   - Add interface to check whether a domain is aux-domain for a device.
   - Return domain only if the domain is aux-domain in
     iommu_aux_get_domain_for_dev().

Lu Baolu (5):
  iommu: Add optional subdev in aux_at(de)tach ops
  iommu: Add iommu_at(de)tach_subdev_group()
  iommu: Add iommu_aux_get_domain_for_dev()
  vfio/type1: Use iommu_aux_at(de)tach_group() APIs
  iommu/vt-d: Add is_aux_domain support

 drivers/iommu/intel/iommu.c     | 135 +++++++++++++++++++--------
 drivers/iommu/iommu.c           | 158 +++++++++++++++++++++++++++++++-
 drivers/vfio/vfio_iommu_type1.c |  43 ++-------
 include/linux/intel-iommu.h     |  17 ++--
 include/linux/iommu.h           |  46 +++++++++-
 5 files changed, 315 insertions(+), 84 deletions(-)

-- 
2.17.1

