Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556C73C9A4F
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 10:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240569AbhGOIRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 04:17:10 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11422 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbhGOIRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 04:17:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQRrw5Mgtzcd91;
        Thu, 15 Jul 2021 16:10:56 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 16:14:14 +0800
Received: from [10.174.185.67] (10.174.185.67) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 16:14:13 +0800
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <5962d403-80c4-0ac4-4f37-96b055a2b4d0@huawei.com>
Date:   Thu, 15 Jul 2021 16:14:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/7/15 14:49, Tian, Kevin wrote:
>> From: Shenming Lu <lushenming@huawei.com>
>> Sent: Thursday, July 15, 2021 2:29 PM
>>
>> On 2021/7/15 11:55, Tian, Kevin wrote:
>>>> From: Shenming Lu <lushenming@huawei.com>
>>>> Sent: Thursday, July 15, 2021 11:21 AM
>>>>
>>>> On 2021/7/9 15:48, Tian, Kevin wrote:
>>>>> 4.6. I/O page fault
>>>>> +++++++++++++++++++
>>>>>
>>>>> uAPI is TBD. Here is just about the high-level flow from host IOMMU
>> driver
>>>>> to guest IOMMU driver and backwards. This flow assumes that I/O page
>>>> faults
>>>>> are reported via IOMMU interrupts. Some devices report faults via
>> device
>>>>> specific way instead of going through the IOMMU. That usage is not
>>>> covered
>>>>> here:
>>>>>
>>>>> -   Host IOMMU driver receives a I/O page fault with raw fault_data {rid,
>>>>>     pasid, addr};
>>>>>
>>>>> -   Host IOMMU driver identifies the faulting I/O page table according to
>>>>>     {rid, pasid} and calls the corresponding fault handler with an opaque
>>>>>     object (registered by the handler) and raw fault_data (rid, pasid, addr);
>>>>>
>>>>> -   IOASID fault handler identifies the corresponding ioasid and device
>>>>>     cookie according to the opaque object, generates an user fault_data
>>>>>     (ioasid, cookie, addr) in the fault region, and triggers eventfd to
>>>>>     userspace;
>>>>>
>>>>
>>>> Hi, I have some doubts here:
>>>>
>>>> For mdev, it seems that the rid in the raw fault_data is the parent device's,
>>>> then in the vSVA scenario, how can we get to know the mdev(cookie) from
>>>> the
>>>> rid and pasid?
>>>>
>>>> And from this point of view，would it be better to register the mdev
>>>> (iommu_register_device()) with the parent device info?
>>>>
>>>
>>> This is what is proposed in this RFC. A successful binding generates a new
>>> iommu_dev object for each vfio device. For mdev this object includes
>>> its parent device, the defPASID marking this mdev, and the cookie
>>> representing it in userspace. Later it is iommu_dev being recorded in
>>> the attaching_data when the mdev is attached to an IOASID:
>>>
>>> 	struct iommu_attach_data *__iommu_device_attach(
>>> 		struct iommu_dev *dev, u32 ioasid, u32 pasid, int flags);
>>>
>>> Then when a fault is reported, the fault handler just needs to figure out
>>> iommu_dev according to {rid, pasid} in the raw fault data.
>>>
>>
>> Yeah, we have the defPASID that marks the mdev and refers to the default
>> I/O address space, but how about the non-default I/O address spaces?
>> Is there a case that two different mdevs (on the same parent device)
>> are used by the same process in the guest, thus have a same pasid route
>> in the physical IOMMU? It seems that we can't figure out the mdev from
>> the rid and pasid in this case...
>>
>> Did I misunderstand something?... :-)
>>
> 
> No. You are right on this case. I don't think there is a way to 
> differentiate one mdev from the other if they come from the
> same parent and attached by the same guest process. In this
> case the fault could be reported on either mdev (e.g. the first
> matching one) to get it fixed in the guest.
> 

OK. Thanks,

Shenming
