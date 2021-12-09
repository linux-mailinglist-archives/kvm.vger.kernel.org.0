Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8777346E37D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 08:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhLIHxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 02:53:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230154AbhLIHxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 02:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639036210;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AygQgJSDL/0VPHQil7DxyO7LMzsaDLMXqw5yWmd50s=;
        b=UZCDwd9TcK2YHsmsB9CiSYD+XGIjyweFLVoups/KK584TqBgUSUvGj/J0Yumlw2U3S263R
        z0f97qJ7OpQrvjg8nKfP4IxgqeN5U1W0prDwAoX1eUfLNdoxQku0DaFIhfD5VqD/ZlOmbr
        23EUTKWOOrUtTmsg7xMzI1NXZ3Q3soA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-419-hvQWXYS8NniEtbca9RoEUQ-1; Thu, 09 Dec 2021 02:50:08 -0500
X-MC-Unique: hvQWXYS8NniEtbca9RoEUQ-1
Received: by mail-wm1-f72.google.com with SMTP id ay34-20020a05600c1e2200b00337fd217772so2098863wmb.4
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 23:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=/AygQgJSDL/0VPHQil7DxyO7LMzsaDLMXqw5yWmd50s=;
        b=lv6yPVfpdzHjE5PeDzKxIMUeIR6ttZYH9iho+WhUhYI+3RBisXgjqL+fIL+5fYckKP
         uzdy/KR40dBcFFDmkxotlNrQFMl9eY2VI+V4oA2lfXY98WY4Q1ZUrizOJjFTB6NkHORv
         lNVdKglEwNh7/V5ZMPx1GpV/mFwmntV6VqCCRuTjYK5C+tRetSkfE0ea4HvJn1sZCzO2
         TxNK/CZ+GgEVCuZh+9hb1ANFL0FvKVRc+rbx7L969vbohqs7DnGEg+0VC/XRh0oCjWoj
         i6QPV5B8n95xzkw96IlA88hg3KJao3/Pxf21zl6vvVZFO7+s0TGnsB39vtzWkehmlfA+
         eZaw==
X-Gm-Message-State: AOAM531yjiYg7wHWrrqUhF6npds4gXhsNBmqyRPJC9nh9aiHi8f5aZGm
        8DOVmanfm6reXku0fS5UIaUJznxaLKqaeaAk4H45QVQ3wfgO0P/9Ssfq2DzttBlXo9FEQ/7Ah8m
        +gKnJK6ToNMPT
X-Received: by 2002:a5d:68c1:: with SMTP id p1mr4404832wrw.585.1639036207474;
        Wed, 08 Dec 2021 23:50:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxM7es35fO3bx5eEMf/Nb497G7NrF+/56L4RejjxGuiXbl8ZtgmWYluATX5InHERKthnvKkg==
X-Received: by 2002:a5d:68c1:: with SMTP id p1mr4404796wrw.585.1639036207210;
        Wed, 08 Dec 2021 23:50:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l5sm6766694wrs.59.2021.12.08.23.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 23:50:06 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, peter.maydell@linaro.org,
        kvm@vger.kernel.org, vivek.gautam@arm.com,
        kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com,
        ashok.raj@intel.com, maz@kernel.org, vsethi@nvidia.com,
        zhangfei.gao@linaro.org, kevin.tian@intel.com, will@kernel.org,
        alex.williamson@redhat.com, wangxingang5@huawei.com,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b576084b-482f-bcb7-35a6-d786dbb305e1@redhat.com>
Date:   Thu, 9 Dec 2021 08:50:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211208183102.GD6385@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 12/8/21 7:31 PM, Jason Gunthorpe wrote:
> On Wed, Dec 08, 2021 at 05:20:39PM +0000, Jean-Philippe Brucker wrote:
>> On Wed, Dec 08, 2021 at 08:56:16AM -0400, Jason Gunthorpe wrote:
>>> From a progress perspective I would like to start with simple 'page
>>> tables in userspace', ie no PASID in this step.
>>>
>>> 'page tables in userspace' means an iommufd ioctl to create an
>>> iommu_domain where the IOMMU HW is directly travesering a
>>> device-specific page table structure in user space memory. All the HW
>>> today implements this by using another iommu_domain to allow the IOMMU
>>> HW DMA access to user memory - ie nesting or multi-stage or whatever.
>>>
>>> This would come along with some ioctls to invalidate the IOTLB.
>>>
>>> I'm imagining this step as a iommu_group->op->create_user_domain()
>>> driver callback which will create a new kind of domain with
>>> domain-unique ops. Ie map/unmap related should all be NULL as those
>>> are impossible operations.
>>>
>>> From there the usual struct device (ie RID) attach/detatch stuff needs
>>> to take care of routing DMAs to this iommu_domain.
>>>
>>> Step two would be to add the ability for an iommufd using driver to
>>> request that a RID&PASID is connected to an iommu_domain. This
>>> connection can be requested for any kind of iommu_domain, kernel owned
>>> or user owned.
>>>
>>> I don't quite have an answer how exactly the SMMUv3 vs Intel
>>> difference in PASID routing should be resolved.
>> In SMMUv3 the user pgd is always stored in the PASID table (actually
>> called "context descriptor table" but I want to avoid confusion with
>> the VT-d "context table"). And to access the PASID table, the SMMUv3 first
>> translate its GPA into a PA using the stage-2 page table. For userspace to
>> pass individual pgds to the kernel, as opposed to passing whole PASID
>> tables, the host kernel needs to reserve GPA space and map it in stage-2,
>> so it can store the PASID table in there. Userspace manages GPA space.
> It is what I thought.. So in the SMMUv3 spec the STE is completely in
> kernel memory, but it points to an S1ContextPtr that must be an IPA if
> the "stage 1 translation tables" are IPA. Only via S1ContextPtr can we
> decode the substream?
Yes that's correct. S1ContextPtr is the IPA of the L1 Context Descriptor
Table which is then indexed by substreamID.

>
> So in SMMUv3 land we don't really ever talk about PASID, we have a
> 'user page table' that is bound to an entire RID and *all* PASIDs.
in ARM terminology substreamID matches the PASID and this is what
indexes the L1 Context Descriptor Table.

>
> While Intel would have a 'user page table' that is only bound to a RID
> & PASID
>
> Certianly it is not a difference we can hide from userspace.
>  
>> This would be easy for a single pgd. In this case the PASID table has a
>> single entry and userspace could just pass one GPA page during
>> registration. However it isn't easily generalized to full PASID support,
>> because managing a multi-level PASID table will require runtime GPA
>> allocation, and that API is awkward. That's why we opted for "attach PASID
>> table" operation rather than "attach page table" (back then the choice was
>> easy since VT-d used the same concept).
> I think the entire context descriptor table should be in userspace,
> and filled in by userspace, as part of the userspace page table.

In ARM nested mode the L1 Context Descriptor Table is fully managed by
the guest and the userspace only needs to trap its S1ContextPtr and pass
it to the host.
>
> The kernel API should accept the S1ContextPtr IPA and all the parts of
> the STE that relate to the defining the layout of what the S1Context
> points to an thats it.
Yes that's exactly what is done currently. At config time the host must
trap guest STE changes (format and S1ContextPtr) and "incorporate" those
changes into the stage2 related STE information. The STE is owned by the
host kernel as it contains the stage2 information (S2TTB).

In
https://developer.arm.com/documentation/ihi0070/latest
(ARM_IHI_0070_D_b_System_Memory_Management_Unit_Architecture_Specification.pdf)
Synthetic diagrams can be found in 3.3.2 StreamIDs to Context
Descriptors. They give the global view.

Note this series only coped with a single CD in the Context Descriptor
Table.

Thanks

Eric
>
> We should have another mode where the kernel owns everything, and the
> S1ContexPtr is a PA with Stage 2 bypassed.
>
> That part is fine, the more open question is what does the driver
> interface look like when userspace tell something like vfio-pci to
> connect to this thing. At some level the attaching device needs to
> authorize iommufd to take the entire PASID table and RID.
>
> Specifically we cannot use this thing with a mdev, while the Intel
> version of a userspace page table can be.
>
> Maybe that is just some 'allow whole device' flag in an API
>
> Jason
>

