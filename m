Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7493D2B67A9
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 15:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgKQOkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 09:40:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:50205 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgKQOkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 09:40:10 -0500
IronPort-SDR: VDgxn0vlquGxhQZaHMxe1d0hmgd/MGjbzS45ntjQ4oIZv7NjX5bL5zdHWAMpirnmjp7XgZakIE
 PBjG2N+7DFTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232549946"
X-IronPort-AV: E=Sophos;i="5.77,485,1596524400"; 
   d="scan'208";a="232549946"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 06:40:01 -0800
IronPort-SDR: DFsIXHLgQqIVojG6gawwZvtSoSb8ApdFQe8B9nj2WzAOlvdK4OTMF/92Jcikey/4ur9YlPerar
 TBhKilJZCdmQ==
X-IronPort-AV: E=Sophos;i="5.77,485,1596524400"; 
   d="scan'208";a="367884411"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.210.201]) ([10.254.210.201])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 06:39:57 -0800
Cc:     baolu.lu@linux.intel.com, Cornelia Huck <cohuck@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20201112022407.2063896-1-baolu.lu@linux.intel.com>
 <20201116125631.2d043fcd@w520.home>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH 1/1] vfio/type1: Add subdev_ioasid callback to
 vfio_iommu_driver_ops
Message-ID: <c4526653-2e0d-2f9a-66ad-b3dba284a4d3@linux.intel.com>
Date:   Tue, 17 Nov 2020 22:39:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201116125631.2d043fcd@w520.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 2020/11/17 3:56, Alex Williamson wrote:
> On Thu, 12 Nov 2020 10:24:07 +0800
> Lu Baolu<baolu.lu@linux.intel.com>  wrote:
> 
>> Add API for getting the ioasid of a subdevice (vfio/mdev). This calls
>> into the backend IOMMU module to get the actual value or error number
>> if ioasid for subdevice is not supported. The physical device driver
>> implementations which rely on the vfio/mdev framework for mediated
>> device user level access could typically consume this interface like
>> below:
>>
>> 	struct device *dev = mdev_dev(mdev);
>> 	unsigned int pasid;
>> 	int ret;
>>
>> 	ret = vfio_subdev_ioasid(dev, &pasid);
>> 	if (ret < 0)
>> 		return ret;
>>
>>           /* Program device context with pasid value. */
>>           ....
> 
> Seems like an overly specific callback.  We already export means for
> you to get a vfio_group, test that a device is an mdev, and get the
> iommu device from an mdev.  So you can already test whether a given
> device is an mdev with an iommu backing device that supports aux
> domains.  The only missing piece seems to be that you can't get the
> domain for a group in order to retrieve the pasid.  So why aren't we
> exporting a callback that given a vfio_group provides the iommu domain?

Make sense! Thanks for your guidance. :-)

So what we want to export in vfio.c is

struct iommu_domain *vfio_group_get_domain(struct vfio_group *group)

What the callers need to do are:

	unsigned int pasid;
	struct vfio_group *vfio_group;
	struct iommu_domain *iommu_domain;
	struct device *dev = mdev_dev(mdev);
	struct device *iommu_device = mdev_get_iommu_device(dev);

	if (!iommu_device ||
	    !iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
		return -EINVAL;

	vfio_group = vfio_group_get_external_user_from_dev(dev);
	if (IS_ERR_OR_NULL(vfio_group))
		return -EFAULT;

	iommu_domain = vfio_group_get_domain(vfio_group);
	if (IS_ERR_OR_NULL(iommu_domain)) {
		vfio_group_put_external_user(vfio_group);
		return -EFAULT;
	}

	pasid = iommu_aux_get_pasid(iommu_domain, iommu_device);
	if (pasid < 0) {
		vfio_group_put_external_user(vfio_group);
		return -EFAULT;
	}

	/* Program device context with pasid value. */
	...

	/* After use of this pasid */

	/* Clear the pasid value in device context */
	...

	vfio_group_put_external_user(vfio_group);

Do I understand your points correctly?

Best regards,
baolu



