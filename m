Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFB4605B7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbfGEMJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47170 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbfGEMJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:09:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63664C057F3C;
        Fri,  5 Jul 2019 12:09:41 +0000 (UTC)
Received: from [10.36.116.95] (ovpn-116-95.ams2.redhat.com [10.36.116.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 366B88227E;
        Fri,  5 Jul 2019 12:09:33 +0000 (UTC)
Subject: Re: [PATCH v7 2/6] vfio/type1: Check reserve region conflict and
 update iova list
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Linuxarm <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
 <20190626151248.11776-3-shameerali.kolothum.thodi@huawei.com>
 <20190703143427.2d63c15f@x1.home>
 <5FC3163CFD30C246ABAA99954A238FA83F2DDB68@lhreml524-mbs.china.huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d70c59ec-e837-7697-acb1-c2b5027570ee@redhat.com>
Date:   Fri, 5 Jul 2019 14:09:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <5FC3163CFD30C246ABAA99954A238FA83F2DDB68@lhreml524-mbs.china.huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 05 Jul 2019 12:09:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 7/4/19 2:51 PM, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
>> Behalf Of Alex Williamson
>> Sent: 03 July 2019 21:34
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: eric.auger@redhat.com; pmorel@linux.vnet.ibm.com;
>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>> iommu@lists.linux-foundation.org; Linuxarm <linuxarm@huawei.com>; John
>> Garry <john.garry@huawei.com>; xuwei (O) <xuwei5@huawei.com>;
>> kevin.tian@intel.com
>> Subject: Re: [PATCH v7 2/6] vfio/type1: Check reserve region conflict and
>> update iova list
>>
>> On Wed, 26 Jun 2019 16:12:44 +0100
>> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:
>>
>>> This retrieves the reserved regions associated with dev group and
>>> checks for conflicts with any existing dma mappings. Also update
>>> the iova list excluding the reserved regions.
>>>
>>> Reserved regions with type IOMMU_RESV_DIRECT_RELAXABLE are
>>> excluded from above checks as they are considered as directly
>>> mapped regions which are known to be relaxable.
>>>
>>> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 96
>> +++++++++++++++++++++++++++++++++
>>>  1 file changed, 96 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c
>> b/drivers/vfio/vfio_iommu_type1.c
>>> index 970d1ec06aed..b6bfdfa16c33 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -1559,6 +1641,7 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>>>  	phys_addr_t resv_msi_base;
>>>  	struct iommu_domain_geometry geo;
>>>  	LIST_HEAD(iova_copy);
>>> +	LIST_HEAD(group_resv_regions);
>>>
>>>  	mutex_lock(&iommu->lock);
>>>
>>> @@ -1644,6 +1727,13 @@ static int vfio_iommu_type1_attach_group(void
>> *iommu_data,
>>>  		goto out_detach;
>>>  	}
>>>
>>> +	iommu_get_group_resv_regions(iommu_group, &group_resv_regions);
>>
>> This can fail and should have an error case.  I assume we'd fail the
>> group attach on failure.  Thanks,
> 
> Right. I will add the check. Do you think we should do the same in vfio_iommu_has_sw_msi()
> as well? (In fact, it looks like iommu_get_group_resv_regions() ret is not checked anywhere in
> kernel). 

I think the can be the topic of another series. I just noticed that in
iommu_insert_resv_region(), which is recursive in case ot merge, I
failed to propagate returned value or recursive calls. This also needs
to be fixed. I volunteer to work on those changes if you prefer. Just
let me know.

Thanks

Eric
> 
> Thanks,
> Shameer
> 
> 
