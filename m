Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF794D13B3
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 10:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345406AbiCHJs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 04:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345547AbiCHJry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 04:47:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF124198E;
        Tue,  8 Mar 2022 01:46:58 -0800 (PST)
Received: from kwepemi100002.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KCVnB5SHxzdZn9;
        Tue,  8 Mar 2022 17:45:34 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi100002.china.huawei.com (7.221.188.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 17:46:56 +0800
Received: from [10.67.102.118] (10.67.102.118) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 17:46:55 +0800
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
 <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <e69d8246-79ba-fa37-fecf-c9f28db692f8@huawei.com>
Date:   Tue, 8 Mar 2022 17:46:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20220307125239.7261c97d.alex.williamson@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/3/8 3:52, Alex Williamson wrote:
> On Mon, 7 Mar 2022 19:29:06 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> 
>>> -----Original Message-----
>>> From: Alex Williamson [mailto:alex.williamson@redhat.com]
>>> Sent: 07 March 2022 19:05
>>> To: Jason Gunthorpe <jgg@nvidia.com>
>>> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>>> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>>> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
>>> mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
>>> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
>>> <prime.zeng@hisilicon.com>; Jonathan Cameron
>>> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
>>> Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
>>> migration
>>>
>>> On Fri, 4 Mar 2022 16:57:20 -0400
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>   
>>>> On Thu, Mar 03, 2022 at 11:01:30PM +0000, Shameer Kolothum wrote:  
>>>>> From: Longfang Liu <liulongfang@huawei.com>
>>>>>
>>>>> VMs assigned with HiSilicon ACC VF devices can now perform live  
>>> migration  
>>>>> if the VF devices are bind to the hisi_acc_vfio_pci driver.
>>>>>
>>>>> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
>>>>> Signed-off-by: Shameer Kolothum  
>>> <shameerali.kolothum.thodi@huawei.com>  
>>>>> ---
>>>>>  drivers/vfio/pci/hisilicon/Kconfig            |    7 +
>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1078 ++++++++++++++++-
>>>>>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  114 ++
>>>>>  3 files changed, 1181 insertions(+), 18 deletions(-)
>>>>>  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
>>>>>
>>>>> diff --git a/drivers/vfio/pci/hisilicon/Kconfig  
>>> b/drivers/vfio/pci/hisilicon/Kconfig  
>>>>> index dc723bad05c2..2a68d39f339f 100644
>>>>> --- a/drivers/vfio/pci/hisilicon/Kconfig
>>>>> +++ b/drivers/vfio/pci/hisilicon/Kconfig
>>>>> @@ -3,6 +3,13 @@ config HISI_ACC_VFIO_PCI
>>>>>  	tristate "VFIO PCI support for HiSilicon ACC devices"
>>>>>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
>>>>>  	depends on VFIO_PCI_CORE
>>>>> +	depends on PCI && PCI_MSI  
>>>>
>>>> PCI is already in the depends from the 2nd line in
>>>> drivers/vfio/pci/Kconfig, but it is harmless
>>>>  
>>>>> +	depends on UACCE || UACCE=n
>>>>> +	depends on ACPI  
>>>>
>>>> Scratching my head a bit on why we have these  
>>>
>>> Same curiosity from me, each of the CRYPTO_DEV_HISI_* options selected
>>> also depend on these so they seem redundant.  
>>
>> Yes, they are redundant now since we have added CRYPTO_DEV_HISI_ drivers
>> as "depends" now. I will remove that.
>>  
>>> I think we still require acks from Bjorn and Zaibo for select patches
>>> in this series.  
>>
>> I checked with Ziabo. He moved projects and is no longer looking into crypto stuff.
>> Wangzhou and LiuLongfang now take care of this. Received acks from Wangzhou
>> already and I will request Longfang to provide his. Hope that's ok.
> 
> Maybe a good time to have them update MAINTAINERS as well.  Thanks,
> 
> Alex
> 
OK, we have discussed it internally, I will send a patch to update
MAINTAINERS of crypto stuff.
Thanks.
Longfang
> .
> 
