Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F65846B9C7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 12:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbhLGLJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 06:09:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235453AbhLGLJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 06:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638875180;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nRg5DINjCe5e0zYHOQ+el+Q1dd4HwA20H1HpRmk80lA=;
        b=UvBWhiYPafXFxZEhYeBB26n0uO/kgqERqyr96lMl70A/d7UioVCRGBL/RKYoAVHgUko5E+
        y6RdNkxM3FvBekLMDsW3FZRrGuhlDg9BacUQpG1/Otsvs7hbvFwhDCf5jmtvyJI6aDrMto
        O/HZ5i2cja7O4Nm/UYVehh+hqkil1kc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-sFiFwUabM221AElPOI_JNQ-1; Tue, 07 Dec 2021 06:06:19 -0500
X-MC-Unique: sFiFwUabM221AElPOI_JNQ-1
Received: by mail-wr1-f71.google.com with SMTP id c4-20020adfed84000000b00185ca4eba36so2797530wro.21
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 03:06:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=nRg5DINjCe5e0zYHOQ+el+Q1dd4HwA20H1HpRmk80lA=;
        b=Gb11Q4V0dR4IOS3TKpyb8B9p0iCmemWs3w5uDrk0NaLCSwwNrxBZG2Hie1tpyQX6bk
         50P+Ewgkepm+sN2EJ9kJ4lppLDKbLjb/C78lNgUDOS4TAdXY2UKXdIzRdpcfgoGOhASX
         XydKrNu4Lv4EFtRIJBbf6JLYf/61nNnmkiv7kiD+yAHrxIUcTlZrL4oDOYBBhr+vx6eI
         0rsgLME41sTBJODlp7NXJwpTcRG82Epmy+EwNNvil4yRYUi0tCPgk4qXOBoPjPW85Ygc
         fe1a1+ecCJD1NtVNkCh8pfc3PAunDawlxbWLF1apESQiCh5ytE5Hy+1taaKr7YmtGo6g
         XVUQ==
X-Gm-Message-State: AOAM530FeNvBHhqYPqz1SAR479WoSRl3ibCtg3/y/UxX0XjNSN1o4630
        HYGX3/SOcnQKYVbfZe//CFbpYd3PZLi1lXRFoQC9QGWlsA1aX+gAUV2lXKdzQHWYO2sWxsI2+hU
        7BzmVuopUVuCY
X-Received: by 2002:a05:600c:3b28:: with SMTP id m40mr6117115wms.100.1638875177874;
        Tue, 07 Dec 2021 03:06:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxi/ivnznn7trJTjiidNkJzjz1zRWIo5Uu4Z3R2uCviGWKVwvEBCQ2nckpYn4cvfIBk5jTULQ==
X-Received: by 2002:a05:600c:3b28:: with SMTP id m40mr6117074wms.100.1638875177635;
        Tue, 07 Dec 2021 03:06:17 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id g4sm14083363wro.12.2021.12.07.03.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 03:06:17 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Zhangfei Gao <zhangfei.gao@linaro.org>, eric.auger.pro@gmail.com,
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
 <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <15a9875b-130a-e889-4e13-e063ef2ce4f9@redhat.com>
Date:   Tue, 7 Dec 2021 12:06:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c1e9dd67-0000-28b5-81c0-239ceda560ed@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 12/7/21 11:35 AM, Zhangfei Gao wrote:
>
>
> On 2021/12/7 下午6:27, Eric Auger wrote:
>> Hi Zhangfei,
>>
>> On 12/3/21 1:27 PM, Zhangfei Gao wrote:
>>> Hi, Eric
>>>
>>> On 2021/10/27 下午6:44, Eric Auger wrote:
>>>> This series brings the IOMMU part of HW nested paging support
>>>> in the SMMUv3.
>>>>
>>>> The SMMUv3 driver is adapted to support 2 nested stages.
>>>>
>>>> The IOMMU API is extended to convey the guest stage 1
>>>> configuration and the hook is implemented in the SMMUv3 driver.
>>>>
>>>> This allows the guest to own the stage 1 tables and context
>>>> descriptors (so-called PASID table) while the host owns the
>>>> stage 2 tables and main configuration structures (STE).
>>>>
>>>> This work mainly is provided for test purpose as the upper
>>>> layer integration is under rework and bound to be based on
>>>> /dev/iommu instead of VFIO tunneling. In this version we also get
>>>> rid of the MSI BINDING ioctl, assuming the guest enforces
>>>> flat mapping of host IOVAs used to bind physical MSI doorbells.
>>>> In the current QEMU integration this is achieved by exposing
>>>> RMRs to the guest, using Shameer's series [1]. This approach
>>>> is RFC as the IORT spec is not really meant to do that
>>>> (single mapping flag limitation).
>>>>
>>>> Best Regards
>>>>
>>>> Eric
>>>>
>>>> This series (Host) can be found at:
>>>> https://github.com/eauger/linux/tree/v5.15-rc7-nested-v16
>>>> This includes a rebased VFIO integration (although not meant
>>>> to be upstreamed)
>>>>
>>>> Guest kernel branch can be found at:
>>>> https://github.com/eauger/linux/tree/shameer_rmrr_v7
>>>> featuring [1]
>>>>
>>>> QEMU integration (still based on VFIO and exposing RMRs)
>>>> can be found at:
>>>> https://github.com/eauger/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
>>>> (use iommu=nested-smmuv3 ARM virt option)
>>>>
>>>> Guest dependency:
>>>> [1] [PATCH v7 0/9] ACPI/IORT: Support for IORT RMR node
>>> Thanks a lot for upgrading these patches.
>>>
>>> I have basically verified these patches on HiSilicon Kunpeng920.
>>> And integrated them to these branches.
>>> https://github.com/Linaro/linux-kernel-uadk/tree/uacce-devel-5.16
>>> https://github.com/Linaro/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
>>>
>>> Though they are provided for test purpose,
>>>
>>> Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> Thank you very much. As you mentioned, until we do not have the
>> /dev/iommu integration this is maintained for testing purpose. The SMMU
>> changes shouldn't be much impacted though.
>> The added value of this respin was to propose an MSI binding solution
>> based on RMRRs which simplify things at kernel level.
>
> Current RMRR solution requires uefi enabled,
> and QEMU_EFI.fd  has to be provided to start qemu.
>
> Any plan to support dtb as well, which will be simpler since no need
> QEMU_EFI.fd anymore.
Yes the solution is based on ACPI IORT nodes. No clue if some DT
integration is under work. Shameer?

Thanks

Eric
>
> Thanks
>
>

