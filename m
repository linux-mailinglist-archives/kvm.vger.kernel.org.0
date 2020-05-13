Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A831D14E3
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbgEMN3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 09:29:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729309AbgEMN3F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 09:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589376543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KoV5Wqms5AH46esJ6zYoKxLFFe0Vww3N0l8ERghmRN4=;
        b=RcTjyLBnCN8cwUOlTOor2lVXEpwVNshjO4b2+gSQU0hh4fIU54DPQ1j88OI7MeuGTVs0hf
        eyroIJPyYMQ7yHH3pDkSByAhbkKCtgYP8T4DIZOjv31b+F8M3AHaZeSTWPXe0kdvNK3dyL
        4Nv0/W1w59IqMEwopIqREGf/kwRL2vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-HnptDom5NM2MsQHnVL9a5Q-1; Wed, 13 May 2020 09:28:58 -0400
X-MC-Unique: HnptDom5NM2MsQHnVL9a5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DEED80183C;
        Wed, 13 May 2020 13:28:56 +0000 (UTC)
Received: from [10.36.112.22] (ovpn-112-22.ams2.redhat.com [10.36.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94BE910013BD;
        Wed, 13 May 2020 13:28:45 +0000 (UTC)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "bbhushan2@marvell.com" <bbhushan2@marvell.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
 <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
 <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <3858dd8c-ee55-b0d7-96cc-3c047ba8f652@redhat.com>
Date:   Wed, 13 May 2020 15:28:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 5/7/20 8:59 AM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: Shameerali Kolothum Thodi
>> Sent: 30 April 2020 10:38
>> To: 'Auger Eric' <eric.auger@redhat.com>; Zhangfei Gao
>> <zhangfei.gao@linaro.org>; eric.auger.pro@gmail.com;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
>> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com
>> Cc: jean-philippe@linaro.org; alex.williamson@redhat.com;
>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; peter.maydell@linaro.org;
>> tn@semihalf.com; bbhushan2@marvell.com
>> Subject: RE: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
>>
>> Hi Eric,
>>
>>> -----Original Message-----
>>> From: Auger Eric [mailto:eric.auger@redhat.com]
>>> Sent: 16 April 2020 08:45
>>> To: Zhangfei Gao <zhangfei.gao@linaro.org>; eric.auger.pro@gmail.com;
>>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
>>> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com
>>> Cc: jean-philippe@linaro.org; Shameerali Kolothum Thodi
>>> <shameerali.kolothum.thodi@huawei.com>; alex.williamson@redhat.com;
>>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; peter.maydell@linaro.org;
>>> tn@semihalf.com; bbhushan2@marvell.com
>>> Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
>>>
>>> Hi Zhangfei,
>>>
>>> On 4/16/20 6:25 AM, Zhangfei Gao wrote:
>>>>
>>>>
>>>> On 2020/4/14 下午11:05, Eric Auger wrote:
>>>>> This version fixes an issue observed by Shameer on an SMMU 3.2,
>>>>> when moving from dual stage config to stage 1 only config.
>>>>> The 2 high 64b of the STE now get reset. Otherwise, leaving the
>>>>> S2TTB set may cause a C_BAD_STE error.
>>>>>
>>>>> This series can be found at:
>>>>> https://github.com/eauger/linux/tree/v5.6-2stage-v11_10.1
>>>>> (including the VFIO part)
>>>>> The QEMU fellow series still can be found at:
>>>>> https://github.com/eauger/qemu/tree/v4.2.0-2stage-rfcv6
>>>>>
>>>>> Users have expressed interest in that work and tested v9/v10:
>>>>> - https://patchwork.kernel.org/cover/11039995/#23012381
>>>>> - https://patchwork.kernel.org/cover/11039995/#23197235
>>>>>
>>>>> Background:
>>>>>
>>>>> This series brings the IOMMU part of HW nested paging support
>>>>> in the SMMUv3. The VFIO part is submitted separately.
>>>>>
>>>>> The IOMMU API is extended to support 2 new API functionalities:
>>>>> 1) pass the guest stage 1 configuration
>>>>> 2) pass stage 1 MSI bindings
>>>>>
>>>>> Then those capabilities gets implemented in the SMMUv3 driver.
>>>>>
>>>>> The virtualizer passes information through the VFIO user API
>>>>> which cascades them to the iommu subsystem. This allows the guest
>>>>> to own stage 1 tables and context descriptors (so-called PASID
>>>>> table) while the host owns stage 2 tables and main configuration
>>>>> structures (STE).
>>>>>
>>>>>
>>>>
>>>> Thanks Eric
>>>>
>>>> Tested v11 on Hisilicon kunpeng920 board via hardware zip accelerator.
>>>> 1. no-sva works, where guest app directly use physical address via ioctl.
>>> Thank you for the testing. Glad it works for you.
>>>> 2. vSVA still not work, same as v10,
>>> Yes that's normal this series is not meant to support vSVM at this stage.
>>>
>>> I intend to add the missing pieces during the next weeks.
>>
>> Thanks for that. I have made an attempt to add the vSVA based on
>> your v10 + JPBs sva patches. The host kernel and Qemu changes can
>> be found here[1][2].
>>
>> This basically adds multiple pasid support on top of your changes.
>> I have done some basic sanity testing and we have some initial success
>> with the zip vf dev on our D06 platform. Please note that the STALL event is
>> not yet supported though, but works fine if we mlock() guest usr mem.
> 
> I have added STALL support for our vSVA prototype and it seems to be
> working(on our hardware). I have updated the kernel and qemu branches with
> the same[1][2]. I should warn you though that these are prototype code and I am pretty
> much re-using the VFIO_IOMMU_SET_PASID_TABLE interface for almost everything.
> But thought of sharing, in case if it is useful somehow!.

Thank you again for sharing the POC. I looked at the kernel and QEMU
branches.

Here are some preliminary comments:
- "arm-smmu-v3: Reset S2TTB while switching back from nested stage":  as
you mentionned S2TTB reset now is featured in v11
- "arm-smmu-v3: Add support for multiple pasid in nested mode": I could
easily integrate this into my series. Update the iommu api first and
pass multiple CD info in a separate patch
- "arm-smmu-v3: Add support to Invalidate CD": CD invalidation should be
cascaded to host through the PASID cache invalidation uapi (no pb you
warned us for the POC you simply used VFIO_IOMMU_SET_PASID_TABLE). I
think I should add this support in my original series although it does
not seem to trigger any issue up to now.
- "arm-smmu-v3: Remove duplication of fault propagation". I understand
the transcode is done somewhere else with SVA but we still need to do it
if a single CD is used, right? I will review the SVA code to better
understand.
- for the STALL response injection I would tend to use a new VFIO region
for responses. At the moment there is a single VFIO region for reporting
the fault.

On QEMU side:
- I am currently working on 3.2 range invalidation support which is
needed for DPDK/VFIO
- While at it I will look at how to incrementally introduce some of the
features you need in this series.

Thanks

Eric



> 
> Thanks,
> Shameer
> 
> [1]https://github.com/hisilicon/kernel-dev/commits/vsva-prototype-host-v1
> 
> [2]https://github.com/hisilicon/qemu/tree/v4.2.0-2stage-rfcv6-vsva-prototype-v1
> 

