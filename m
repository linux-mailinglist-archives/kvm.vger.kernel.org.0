Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB53233CFE
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 03:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgGaBog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 21:44:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:3013 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbgGaBof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 21:44:35 -0400
IronPort-SDR: vbdVS+aoENj745Vg8HMVg0hykweIOwDLXiL5OzEcX2gFDB26BhqGhlbdCQQSIJBhr51YtVd7s2
 JWFPGG3w/PdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="236583967"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="236583967"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 18:44:35 -0700
IronPort-SDR: cfRKvsDxm4yOMDLo81V0xyyXW4gTHfvlBOsPcObRur/TTiR45aV6gEteo0ZencSLtnrg/c93LC
 B3Ay+1LJP/Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="395179334"
Received: from allen-box.sh.intel.com (HELO [10.239.159.139]) ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2020 18:44:32 -0700
Cc:     baolu.lu@linux.intel.com, Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group() APIs
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
 <20200714055703.5510-5-baolu.lu@linux.intel.com>
 <DM5PR11MB14351AE909E031B578EA3170C3710@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <72cfd471-5cb3-3b3c-b0bf-c8413991acac@linux.intel.com>
Date:   Fri, 31 Jul 2020 09:39:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB14351AE909E031B578EA3170C3710@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/30/20 5:36 PM, Liu, Yi L wrote:
>> From: Lu Baolu<baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 14, 2020 1:57 PM
>>
>> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
>> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the vfio_group
>> data structure so that it could be reused in other places.
>>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
>>   1 file changed, 7 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 5e556ac9102a..f8812e68de77 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>   struct vfio_group {
>>   	struct iommu_group	*iommu_group;
>>   	struct list_head	next;
>> +	struct device		*iommu_device;
> I know mdev group has only one device, so such a group has a single
> iommu_device. But I guess may be helpful to add a comment here or in
> commit message. Otherwise, it looks weird that a group structure
> contains a single iommu_device field instead of a list of iommu_device.
> 

Right! I will add some comments if this is still needed in the next
version.

Best regards,
baolu
