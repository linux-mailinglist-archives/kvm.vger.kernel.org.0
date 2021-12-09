Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C567546E439
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 09:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhLIIfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 03:35:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43207 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232591AbhLIIfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 03:35:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639038688;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uvBIC0o3bZPQQpqjTxSxuYUJIG6d5FYvKo3oyhBhNk=;
        b=bJErgL4BNcoJgjssOC4PZRmO/3+3tiamOZij3eKMndlZrIAdxQN2vMDJGOehkionrfo1i3
        t0FjxapRVAwJwBEUo/aNzEA7/b1g1phAEW07Rd+9NeN+OXE9LgMPceOxzDFDIUqO6XO33J
        C3L40uJFwIeikVHW2vdXupsufVtcUiY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-i5zcf7phPoyhgwWqJb-h0A-1; Thu, 09 Dec 2021 03:31:27 -0500
X-MC-Unique: i5zcf7phPoyhgwWqJb-h0A-1
Received: by mail-wm1-f71.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so4494211wmc.7
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 00:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=2uvBIC0o3bZPQQpqjTxSxuYUJIG6d5FYvKo3oyhBhNk=;
        b=dqig2Lq77r6CuYjWLxb1VM9IvdE0edGD4a4k1ZBjUlUkPcJFF5t4msH/Cu5iggyFk0
         NokOCXHzALi9J1uHNQe1jfom61JxeQ+2Lsve7Fc1I4gRX50X4AkNMZY84OgJTucMANms
         pAXBAJHaBQN2S+gjc351K7N8FNT1WBvMtqCB27+CdXq3plIZ7JWM70eRMxQGsNJ+luox
         rbRHs6t0DlRZnVRkghO4i6uXHUkPMGlY2JfyM7KYLEARMDiw1aqGRBeIm/Y3f4/DDiqM
         kPURDRc73SG4/uYZgXXYC/n0LlyUGb5KqkDuLE77Xgro3XWLee125BFzuV7z5y0PNOZW
         uA7Q==
X-Gm-Message-State: AOAM5314wKhBH3dlE2lsr9/DJrPvR5JVXVDYkl4dTJ59OuCX16I0H+i7
        JjtFJM7GDQeGjfkKhTFiRIe+slytI8Hkia0KQ0k3HXJh33UW9Kry040gXEqzPk34736zIe8wtGc
        TO5OR22XakO0H
X-Received: by 2002:a5d:4492:: with SMTP id j18mr4748821wrq.397.1639038686506;
        Thu, 09 Dec 2021 00:31:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcFMzZ6oSrHPIkHCcGww2cxWRbpaxmaT3tH/H01UWWsCEBaPG7MIyo4lDX2577yKs6aksMcA==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr4748779wrq.397.1639038686169;
        Thu, 09 Dec 2021 00:31:26 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f19sm9049910wmq.34.2021.12.09.00.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:31:25 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        jean-philippe@linaro.org, ashok.raj@intel.com, maz@kernel.org,
        vsethi@nvidia.com, zhangfei.gao@linaro.org, kevin.tian@intel.com,
        will@kernel.org, alex.williamson@redhat.com,
        wangxingang5@huawei.com, linux-kernel@vger.kernel.org,
        lushenming@huawei.com, iommu@lists.linux-foundation.org,
        robin.murphy@arm.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <af3530b2-54d2-2807-e783-32110a066c87@redhat.com>
Date:   Thu, 9 Dec 2021 09:31:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211208125616.GN6385@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 12/8/21 1:56 PM, Jason Gunthorpe wrote:
> On Wed, Dec 08, 2021 at 08:33:33AM +0100, Eric Auger wrote:
>> Hi Baolu,
>>
>> On 12/8/21 3:44 AM, Lu Baolu wrote:
>>> Hi Eric,
>>>
>>> On 12/7/21 6:22 PM, Eric Auger wrote:
>>>> On 12/6/21 11:48 AM, Joerg Roedel wrote:
>>>>> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>>>>>> Signed-off-by: Jean-Philippe Brucker<jean-philippe.brucker@arm.com>
>>>>>> Signed-off-by: Liu, Yi L<yi.l.liu@linux.intel.com>
>>>>>> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
>>>>>> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>>>>> Signed-off-by: Eric Auger<eric.auger@redhat.com>
>>>>> This Signed-of-by chain looks dubious, you are the author but the last
>>>>> one in the chain?
>>>> The 1st RFC in Aug 2018
>>>> (https://lists.cs.columbia.edu/pipermail/kvmarm/2018-August/032478.html)
>>>> said this was a generalization of Jacob's patch
>>>>
>>>>
>>>>    [PATCH v5 01/23] iommu: introduce bind_pasid_table API function
>>>>
>>>>
>>>>   
>>>> https://lists.linuxfoundation.org/pipermail/iommu/2018-May/027647.html
>>>>
>>>> So indeed Jacob should be the author. I guess the multiple rebases got
>>>> this eventually replaced at some point, which is not an excuse. Please
>>>> forgive me for that.
>>>> Now the original patch already had this list of SoB so I don't know if I
>>>> shall simplify it.
>>> As we have decided to move the nested mode (dual stages) implementation
>>> onto the developing iommufd framework, what's the value of adding this
>>> into iommu core?
>> The iommu_uapi_attach_pasid_table uapi should disappear indeed as it is
>> is bound to be replaced by /dev/iommu fellow API.
>> However until I can rebase on /dev/iommu code I am obliged to keep it to
>> maintain this integration, hence the RFC.
> Indeed, we are getting pretty close to having the base iommufd that we
> can start adding stuff like this into. Maybe in January, you can look
> at some parts of what is evolving here:
>
> https://github.com/jgunthorpe/linux/commits/iommufd
> https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-v2
> https://github.com/luxis1999/iommufd/commits/iommufd-v5.16-rc2
Interesting. thank you for the preview links. I will have a look asap

Eric
>
> From a progress perspective I would like to start with simple 'page
> tables in userspace', ie no PASID in this step.
>
> 'page tables in userspace' means an iommufd ioctl to create an
> iommu_domain where the IOMMU HW is directly travesering a
> device-specific page table structure in user space memory. All the HW
> today implements this by using another iommu_domain to allow the IOMMU
> HW DMA access to user memory - ie nesting or multi-stage or whatever.
>
> This would come along with some ioctls to invalidate the IOTLB.
>
> I'm imagining this step as a iommu_group->op->create_user_domain()
> driver callback which will create a new kind of domain with
> domain-unique ops. Ie map/unmap related should all be NULL as those
> are impossible operations.
>
> From there the usual struct device (ie RID) attach/detatch stuff needs
> to take care of routing DMAs to this iommu_domain.
>
> Step two would be to add the ability for an iommufd using driver to
> request that a RID&PASID is connected to an iommu_domain. This
> connection can be requested for any kind of iommu_domain, kernel owned
> or user owned.
>
> I don't quite have an answer how exactly the SMMUv3 vs Intel
> difference in PASID routing should be resolved.
>
> to get answers I'm hoping to start building some sketch RFCs for these
> different things on iommufd, hopefully in January. I'm looking at user
> page tables, PASID, dirty tracking and userspace IO fault handling as
> the main features iommufd must tackle.
>
> The purpose of the sketches would be to validate that the HW features
> we want to exposed can work will with the choices the base is making.
>
> Jason
>

