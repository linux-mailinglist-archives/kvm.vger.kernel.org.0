Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FE031BA2E
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 14:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhBONTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 08:19:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230165AbhBONS5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 08:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613395049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h54p7eSoqjSAmVfvcPSfZz+3iobn0f7oTIY4AbSr0ms=;
        b=Cfcc3HXra4HgnHntm/xfEUu2QHMEXkI1TWTqSYV9Oprn6NOK6Z4qmZ9bB+oLyPJ67qW0lM
        +te+Gn/yUtP9G+meLDl82iK+9/w43jklDP+fwWzl/Si6p2Xr3n7GBZvIH67DggNiujJNs0
        jHtlPFbwcFFGssZKPltX0w64yGmDlvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-G6ulSkeZNoaGcyXJbfBRZQ-1; Mon, 15 Feb 2021 08:17:22 -0500
X-MC-Unique: G6ulSkeZNoaGcyXJbfBRZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAE7D801962;
        Mon, 15 Feb 2021 13:17:19 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D885C233;
        Mon, 15 Feb 2021 13:17:11 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        wangxingang <wangxingang5@huawei.com>
Cc:     Xieyingtai <xieyingtai@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <dae77da3-527a-9737-fe2b-c4a0af081321@redhat.com>
Date:   Mon, 15 Feb 2021 14:17:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 12/3/20 7:42 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: kvmarm-bounces@lists.cs.columbia.edu
>> [mailto:kvmarm-bounces@lists.cs.columbia.edu] On Behalf Of Auger Eric
>> Sent: 01 December 2020 13:59
>> To: wangxingang <wangxingang5@huawei.com>
>> Cc: Xieyingtai <xieyingtai@huawei.com>; jean-philippe@linaro.org;
>> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> vivek.gautam@arm.com; alex.williamson@redhat.com;
>> zhangfei.gao@linaro.org; robin.murphy@arm.com;
>> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com
>> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
>> unmanaged ASIDs
>>
>> Hi Xingang,
>>
>> On 12/1/20 2:33 PM, Xingang Wang wrote:
>>> Hi Eric
>>>
>>> On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>>>> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void
>> *cookie)
>>>> 	 * insertion to guarantee those are observed before the TLBI. Do be
>>>> 	 * careful, 007.
>>>> 	 */
>>>> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>>> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>>>> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>>>> +		cmd.tlbi.asid	= ext_asid;
>>>> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>>>> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>>>
>>> Found a problem here, the cmd for guest stage 1 invalidation is built,
>>> but it is not delivered to smmu.
>>>
>>
>> Thank you for the report. I will fix that soon. With that fixed, have
>> you been able to run vSVA on top of the series. Do you need other stuff
>> to be fixed at SMMU level? 
> 
> I am seeing another issue with this series. This is when you have the vSMMU
> in non-strict mode(iommu.strict=0). Any network pass-through dev with iperf run 
> will be enough to reproduce the issue. It may randomly stop/hang.
> 
> It looks like the .flush_iotlb_all from guest is not propagated down to the host
> correctly. I have a temp hack to fix this in Qemu wherein CMDQ_OP_TLBI_NH_ASID
> will result in a CACHE_INVALIDATE with IOMMU_INV_GRANU_PASID flag and archid
> set.

Thank you for the analysis. Indeed the NH_ASID was not properly handled
as asid info was not passed down. I fixed domain invalidation and added
asid based invalidation.

Thanks

Eric
> 
> Please take a look and let me know. 
> 
> As I am going to respin soon, please let me
>> know what is the best branch to rebase to alleviate your integration.
> 
> Please find the latest kernel and Qemu branch with vSVA support added here,
> 
> https://github.com/hisilicon/kernel-dev/tree/5.10-rc4-2stage-v13-vsva
> https://github.com/hisilicon/qemu/tree/v5.2.0-rc1-2stage-rfcv7-vsva
> 
> I have done some basic minimum vSVA tests on a HiSilicon D06 board with
> a zip dev that supports STALL. All looks good so far apart from the issues
> that have been already reported/discussed.
> 
> The kernel branch is actually a rebase of sva/uacce related patches from a
> Linaro branch here,
> 
> https://github.com/Linaro/linux-kernel-uadk/tree/uacce-devel-5.10
> 
> I think going forward it will be good(if possible) to respin your series on top of
> a sva branch with STALL/PRI support added. 
> 
> Hi Jean/zhangfei,
> Is it possible to have a branch with minimum required SVA/UACCE related patches
> that are already public and can be a "stable" candidate for future respin of Eric's series?
> Please share your thoughts.
> 
> Thanks,
> Shameer 
> 
>> Best Regards
>>
>> Eric
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

