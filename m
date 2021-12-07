Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B10A46B93B
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhLGKjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 05:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLGKjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 05:39:06 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F19C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 02:35:37 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b11so9102503pld.12
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 02:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=JxiMwx4C7x5k8y2Xl9TOjw2NlxLDyAqVmINHy5bpGck=;
        b=vK5p9DHLGcOw0yiyBwJ9laMSSiVhDZQCvmpDM1iH75e2UfhLDYH/mf7e2HrefL/sMv
         fhAra2Bm7cbrxeJgUQNpQ12hDCle+9SXTLYbiM/gw88s5dtwt+0nnivf4XJuwXg6Ninb
         QSHEiaoZSstIGC2u3byuj1+L3cvdSkzGWuh2L6DBWe5yDmt9EbHOF47NYdZG8yq0KxCj
         VPIxhqGjsxNJ2uUnhPpAblUNr8sjLY3nb7KpYeFPQYSSuKMUNWtZUIB+sUlCmkMtyJyQ
         RZ1FrGLgkEUTcsMN1wKyAmyuWlOXBASfTDmzMQLTSA9EpwcFt8NZ221OOL4/vrP9wrdN
         gMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JxiMwx4C7x5k8y2Xl9TOjw2NlxLDyAqVmINHy5bpGck=;
        b=kKe1Okod9kBMCY0Udj4bSAgM9e54OnFTGRloKtB0Mv6Q1f9cpBNNNAQR7syMhq5T/D
         0P6PZddqdO1yb717lPsq9DLwfeb5V+mZ3DH1Xa2nm26g3LkNdByX1HOeKooeaEK1Glmf
         eWDd/CMLitMOEP8FnwH5ITHUlsS+d6/ml3cI42oXaeTTTL6fGjR/7A5WehvvDk1erhEO
         uqs1Rm3hTJOQiTm/BtLHe9CblI++w+2Ghy2g3JUyEg3fIcD/3/cOfUKDjMpBEUv2WCLZ
         tvu7JP9TMcj24cJBI+QNrEIceetSOrrrz7XLjbp+6oyUKP+8sYYqOp/35xWabHkG02x7
         mPjg==
X-Gm-Message-State: AOAM5327kZ8xDtVBpYfh4oH6jXF319+XUPilminc3U2tg7aA+ljEbYYr
        asgas3nSopWJK4lZI+nv48lEhg==
X-Google-Smtp-Source: ABdhPJxVXLdqIw+lDiAPUjGajLKImI1eWzIJDKJ3QTpNQZ82cEF0W15LjnO9lyFohe3k4lFOhliP3g==
X-Received: by 2002:a17:90a:cb98:: with SMTP id a24mr5558447pju.153.1638873336553;
        Tue, 07 Dec 2021 02:35:36 -0800 (PST)
Received: from [10.59.0.6] ([94.177.118.48])
        by smtp.gmail.com with ESMTPSA id y22sm9020940pfa.107.2021.12.07.02.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 02:35:36 -0800 (PST)
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To:     eric.auger@redhat.com, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhukeqian1@huawei.com
Cc:     alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, kevin.tian@intel.com, ashok.raj@intel.com,
        maz@kernel.org, peter.maydell@linaro.org, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, wangxingang5@huawei.com,
        jiangkunkun@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, chenxiang66@hisilicon.com,
        sumitg@nvidia.com, nicolinc@nvidia.com, vdumpa@nvidia.com,
        zhangfei.gao@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <ee119b42-92b1-5744-4321-6356bafb498f@linaro.org>
 <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
Date:   Tue, 7 Dec 2021 18:35:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7763531a-625d-10c6-c35e-2ce41e75f606@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/7 下午6:27, Eric Auger wrote:
> Hi Zhangfei,
>
> On 12/3/21 1:27 PM, Zhangfei Gao wrote:
>> Hi, Eric
>>
>> On 2021/10/27 下午6:44, Eric Auger wrote:
>>> This series brings the IOMMU part of HW nested paging support
>>> in the SMMUv3.
>>>
>>> The SMMUv3 driver is adapted to support 2 nested stages.
>>>
>>> The IOMMU API is extended to convey the guest stage 1
>>> configuration and the hook is implemented in the SMMUv3 driver.
>>>
>>> This allows the guest to own the stage 1 tables and context
>>> descriptors (so-called PASID table) while the host owns the
>>> stage 2 tables and main configuration structures (STE).
>>>
>>> This work mainly is provided for test purpose as the upper
>>> layer integration is under rework and bound to be based on
>>> /dev/iommu instead of VFIO tunneling. In this version we also get
>>> rid of the MSI BINDING ioctl, assuming the guest enforces
>>> flat mapping of host IOVAs used to bind physical MSI doorbells.
>>> In the current QEMU integration this is achieved by exposing
>>> RMRs to the guest, using Shameer's series [1]. This approach
>>> is RFC as the IORT spec is not really meant to do that
>>> (single mapping flag limitation).
>>>
>>> Best Regards
>>>
>>> Eric
>>>
>>> This series (Host) can be found at:
>>> https://github.com/eauger/linux/tree/v5.15-rc7-nested-v16
>>> This includes a rebased VFIO integration (although not meant
>>> to be upstreamed)
>>>
>>> Guest kernel branch can be found at:
>>> https://github.com/eauger/linux/tree/shameer_rmrr_v7
>>> featuring [1]
>>>
>>> QEMU integration (still based on VFIO and exposing RMRs)
>>> can be found at:
>>> https://github.com/eauger/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
>>> (use iommu=nested-smmuv3 ARM virt option)
>>>
>>> Guest dependency:
>>> [1] [PATCH v7 0/9] ACPI/IORT: Support for IORT RMR node
>> Thanks a lot for upgrading these patches.
>>
>> I have basically verified these patches on HiSilicon Kunpeng920.
>> And integrated them to these branches.
>> https://github.com/Linaro/linux-kernel-uadk/tree/uacce-devel-5.16
>> https://github.com/Linaro/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
>>
>> Though they are provided for test purpose,
>>
>> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Thank you very much. As you mentioned, until we do not have the
> /dev/iommu integration this is maintained for testing purpose. The SMMU
> changes shouldn't be much impacted though.
> The added value of this respin was to propose an MSI binding solution
> based on RMRRs which simplify things at kernel level.

Current RMRR solution requires uefi enabled,
and QEMU_EFI.fd  has to be provided to start qemu.

Any plan to support dtb as well, which will be simpler since no need 
QEMU_EFI.fd anymore.

Thanks


