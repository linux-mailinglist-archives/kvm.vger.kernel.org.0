Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC14E601B
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 09:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiCXIPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240266AbiCXIO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EC496D3A0
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648109603;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdR6oSXMqEs5QEeFJD+qqMG0zJL2wvv5dMMWUkVUeNU=;
        b=Qj1n2Y9TOQV5Ts7llIm2bw4FY1BnT/QpckIcUViJhfZcdA5vOObhGa+ic7a7IeyxEKj3lU
        wSDMDMmyTUBJOvLdXfTHimnM0g8935xB7+P6SmJLMPA33hqj0GHIWMXx0Yp5QzeKExhuoT
        HbT+hlPtpo/iWr8CEWAgYcNfrfyV0B0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-FOmuI4pDNvGSmCvUg0h43w-1; Thu, 24 Mar 2022 04:13:21 -0400
X-MC-Unique: FOmuI4pDNvGSmCvUg0h43w-1
Received: by mail-wr1-f71.google.com with SMTP id i64-20020adf90c6000000b00203f2b5e090so1407556wri.9
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=kdR6oSXMqEs5QEeFJD+qqMG0zJL2wvv5dMMWUkVUeNU=;
        b=ZVcyP0YoqvM0u8VgrlC478Uy/u9h3ssML7eXqw/AqG5IrkB+eSrPe2oiTe03ZBPYen
         ZrRGE5+EJcbxY6/wQkmZsLGlit6nVK2VATK3IlB1pNvj6e9QrLZLfXkb0Svhm9cL9Fr6
         X9uCPQU3lS6yoqQdS2dDAdPLqMLVTQpWOtJHRS7pxhNZYq0xaZwnE8zmVsDZ44kfqc9X
         xMcA3rk+WCoFoGYKW7kCd6UKclAqYK/Jb3NfHJWq6AVquma1NJwYlRuwzOjDL6YeNcZc
         wIa10P0vESQJ2QzQ4r0iE80U2pN/Pi6YfaC0NDZSjru0j34fC2ryg1jEt40NbuYW+CwA
         XgTA==
X-Gm-Message-State: AOAM530dhxFJUOLoWb55RnBEWiMf+Wx5WnnBxz2DQuYrjDFia2k0lq1e
        B5uI7yd1DMGll2f287Lw7oIfFWCWB6K62k/RVOONVeZmmLv4rNabA6KEyi31WhU+YdAP/ssGjjo
        XH8rTOGn4W0+t
X-Received: by 2002:adf:ed44:0:b0:203:f01a:8823 with SMTP id u4-20020adfed44000000b00203f01a8823mr3532528wro.715.1648109600330;
        Thu, 24 Mar 2022 01:13:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykb968cvCLnkpRKg9daNsEmZubE3gLy10E3lBlAv85eiKoR4YsMpEUVyx/aU9lxRLfqvVTYg==
X-Received: by 2002:adf:ed44:0:b0:203:f01a:8823 with SMTP id u4-20020adfed44000000b00203f01a8823mr3532497wro.715.1648109600033;
        Thu, 24 Mar 2022 01:13:20 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f1-20020a1c6a01000000b0038c9f6a3634sm5479485wmc.7.2022.03.24.01.13.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 01:13:19 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <09a6557f-b881-081c-abdf-266516f7b0eb@redhat.com>
Date:   Thu, 24 Mar 2022 09:13:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220324003342.GV11336@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 3/24/22 1:33 AM, Jason Gunthorpe wrote:
> On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:
>
>> My overall question here would be whether we can actually achieve a
>> compatibility interface that has sufficient feature transparency that we
>> can dump vfio code in favor of this interface, or will there be enough
>> niche use cases that we need to keep type1 and vfio containers around
>> through a deprecation process?
> Other than SPAPR, I think we can.
>
>> The locked memory differences for one seem like something that
>> libvirt wouldn't want hidden
> I'm first interested to have an understanding how this change becomes
> a real problem in practice that requires libvirt to do something
> different for vfio or iommufd. We can discuss in the other thread
>
> If this is the make or break point then I think we can deal with it
> either by going back to what vfio does now or perhaps some other
> friendly compat approach..
>
>> and we have questions regarding support for vaddr hijacking
> I'm not sure what vaddr hijacking is? Do you mean
> VFIO_DMA_MAP_FLAG_VADDR ? There is a comment that outlines my plan to
> implement it in a functionally compatible way without the deadlock
> problem. I estimate this as a small project.
>
>> and different ideas how to implement dirty page tracking, 
> I don't think this is compatibility. No kernel today triggers qemu to
> use this feature as no kernel supports live migration. No existing
> qemu will trigger this feature with new kernels that support live
> migration v2. Therefore we can adjust qemu's dirty tracking at the
> same time we enable migration v2 in qemu.
>
> With Joao's work we are close to having a solid RFC to come with
> something that can be fully implemented.
>
> Hopefully we can agree to this soon enough that qemu can come with a
> full package of migration v2 support including the dirty tracking
> solution.
>
>> not to mention the missing features that are currently well used,
>> like p2p mappings, coherency tracking, mdev, etc.
> I consider these all mandatory things, they won't be left out.
>
> The reason they are not in the RFC is mostly because supporting them
> requires work outside just this iommufd area, and I'd like this series
> to remain self-contained.
>
> I've already got a draft to add DMABUF support to VFIO PCI which
> nicely solves the follow_pfn security problem, we want to do this for
> another reason already. I'm waiting for some testing feedback before
> posting it. Need some help from Daniel make the DMABUF revoke semantic
> him and I have been talking about. In the worst case can copy the
> follow_pfn approach.
>
> Intel no-snoop is simple enough, just needs some Intel cleanup parts.
>
> mdev will come along with the final VFIO integration, all the really
> hard parts are done already. The VFIO integration is a medium sized
> task overall.
>
> So, I'm not ready to give up yet :)
>
>> Where do we focus attention?  Is symlinking device files our proposal
>> to userspace and is that something achievable, or do we want to use
>> this compatibility interface as a means to test the interface and
>> allow userspace to make use of it for transition, if their use cases
>> allow it, perhaps eventually performing the symlink after deprecation
>> and eventual removal of the vfio container and type1 code?  Thanks,
> symlinking device files is definitely just a suggested way to expedite
> testing.
>
> Things like qemu that are learning to use iommufd-only features should
> learn to directly open iommufd instead of vfio container to activate
> those features.
>
> Looking long down the road I don't think we want to have type 1 and
> iommufd code forever. So, I would like to make an option to compile
> out vfio container support entirely and have that option arrange for
> iommufd to provide the container device node itself.
I am currently working on migrating the QEMU VFIO device onto the new
API because since after our discussions the compat mode cannot be used
anyway to implemented nesting. I hope I will be able to present
something next week.

Thanks

Eric
>
> I think we can get there pretty quickly, or at least I haven't got
> anything that is scaring me alot (beyond SPAPR of course)
>
> For the dpdk/etcs of the world I think we are already there.
>
> Jason
>

