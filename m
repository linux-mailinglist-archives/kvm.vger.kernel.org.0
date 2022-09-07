Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CD45AFEF3
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 10:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiIGI2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 04:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiIGI1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 04:27:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B482ABD75;
        Wed,  7 Sep 2022 01:27:28 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4BE24D6E;
        Wed,  7 Sep 2022 01:27:34 -0700 (PDT)
Received: from [10.57.15.197] (unknown [10.57.15.197])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A58783F534;
        Wed,  7 Sep 2022 01:27:48 -0700 (PDT)
Message-ID: <f5cf7bd7-4cd9-ef9c-7f25-f814b2f1e41f@arm.com>
Date:   Wed, 7 Sep 2022 09:27:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
Content-Language: en-GB
To:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-4-nipun.gupta@amd.com>
 <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
 <DM6PR12MB30829DDDC62B36B17F87B204E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <DM6PR12MB30829DDDC62B36B17F87B204E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-07 04:17, Gupta, Nipun wrote:
> [AMD Official Use Only - General]
> 
> 
> 
>> -----Original Message-----
>> From: Saravana Kannan <saravanak@google.com>
>> Sent: Wednesday, September 7, 2022 5:41 AM
>> To: Gupta, Nipun <Nipun.Gupta@amd.com>
>> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
>> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
>> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
>> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
>> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
>> jeffrey.l.hugo@gmail.com; Michael.Srba@seznam.cz; mani@kernel.org;
>> yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com;
>> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
>> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
>> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
>> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
>> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
>> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx)
>> <git@amd.com>
>> Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
>> for CDX bus
>>
>> [CAUTION: External Email]
>>
>> On Tue, Sep 6, 2022 at 6:48 AM Nipun Gupta <nipun.gupta@amd.com> wrote:
>>>
>>> With new CDX bus supported for AMD FPGA devices on ARM
>>> platform, the bus requires registration for the SMMU v3
>>> driver.
>>>
>>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
>>> ---
>>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
>>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> index d32b02336411..8ec9f2baf12d 100644
>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>> @@ -29,6 +29,7 @@
>>>   #include <linux/platform_device.h>
>>>
>>>   #include <linux/amba/bus.h>
>>> +#include <linux/cdx/cdx_bus.h>
>>>
>>>   #include "arm-smmu-v3.h"
>>>   #include "../../iommu-sva-lib.h"
>>> @@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct
>> iommu_ops *ops)
>>>                  if (err)
>>>                          goto err_reset_pci_ops;
>>>          }
>>> +#endif
>>> +#ifdef CONFIG_CDX_BUS
>>> +       if (cdx_bus_type.iommu_ops != ops) {
>>> +               err = bus_set_iommu(&cdx_bus_type, ops);
>>> +               if (err)
>>> +                       goto err_reset_amba_ops;
>>> +       }
>>
>> I'm not an expert on IOMMUs, so apologies if the question is stupid.
>>
>> Why does the CDX bus need special treatment here (like PCI) when there
>> are so many other busses (eg: I2C, SPI, etc) that don't need any
>> changes here?
> 
> AFAIU, the devices on I2C/SPI does not use SMMU. Apart from PCI/AMBA,
> FSL-MC is another similar bus (on SMMUv2) which uses SMMU ops.
> 
> The devices here are behind SMMU. Robin can kindly correct or add
> more here from SMMU perspective.

Indeed, there is no need to describe and handle how DMA may or may not 
be translated for I2C/SPI/USB/etc. because they are not DMA-capable 
buses (in those cases the relevant bus *controller* often does DMA, but 
it does that for itself as the platform/PCI/etc. device it is).

Note that I have a series pending[1] that will make this patch a whole 
lot simpler.

Thanks,
Robin.

[1] 
https://lore.kernel.org/linux-iommu/cover.1660572783.git.robin.murphy@arm.com/T/#t

> 
> Thanks,
> Nipun
> 
>>
>> -Saravana
>>
>>>   #endif
>>>          if (platform_bus_type.iommu_ops != ops) {
>>>                  err = bus_set_iommu(&platform_bus_type, ops);
>>>                  if (err)
>>> -                       goto err_reset_amba_ops;
>>> +                       goto err_reset_cdx_ops;
>>>          }
>>>
>>>          return 0;
>>>
>>> -err_reset_amba_ops:
>>> +err_reset_cdx_ops:
>>> +#ifdef CONFIG_CDX_BUS
>>> +       bus_set_iommu(&cdx_bus_type, NULL);
>>> +#endif
>>> +err_reset_amba_ops: __maybe_unused;
>>>   #ifdef CONFIG_ARM_AMBA
>>>          bus_set_iommu(&amba_bustype, NULL);
>>>   #endif
>>> --
>>> 2.25.1
>>>
