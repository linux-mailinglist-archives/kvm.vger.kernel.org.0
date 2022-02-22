Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11254C01CA
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 20:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbiBVTFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 14:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiBVTFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 14:05:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 363951168C3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 11:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645556704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=187+FGRx7EusHu1HGYCu4Vg/fgHrmwo/AFwe4LUvMAY=;
        b=iKrp9ZBWYFagU+8zH9mFeXPVzU2e7mq2JmetZcJYdd8RChuwGClYjZXhQVVxugTaXs3MAv
        hyOgyPoEgFdqbGwXSVTXvwg2ECjFp65A4yUkqXbQ1nOoySi4izPAzNpeAmBEbBzAYJcZHc
        CMbFyV/kTUFpDACMNr/shxvUv24pZbg=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-LEoUO2jMPIu2v_jVf_Dihg-1; Tue, 22 Feb 2022 14:05:03 -0500
X-MC-Unique: LEoUO2jMPIu2v_jVf_Dihg-1
Received: by mail-ot1-f71.google.com with SMTP id 71-20020a9d034d000000b005af37922de5so4929315otv.10
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 11:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=187+FGRx7EusHu1HGYCu4Vg/fgHrmwo/AFwe4LUvMAY=;
        b=lxsJRYJHE014w+ljiv4MnGrVJd3fdy4+Rx6Y9RHAT7aoS6Cb4AFhHRQmIDTlHQIfBn
         OugBinS2A6nqV2zmpf0hKgET7PnueCGgS4hpAQk8SLdCQpo3kIFhkbk0wqLkpV8dZtIL
         jJ+MvVtZGS95G8a/gs0DznXmmv/XOX1R3Vm1TCH4vPSYFPqr1VDoXkMO1J8yxP+Or5F/
         YR10eFDG/barNp1AUkhRfLVdbFoYl07jdv23dmKfc2KNbF6J7jyM9qOoxpeMCR8lEDzQ
         oUCq7rA+YfzWjYakDshVz3GehIO4tUT8qy9VsIDXP/tu3G8xBm+p5TUF7dW6UO+dT9mU
         2/bg==
X-Gm-Message-State: AOAM533wGtZTZXMi8/iuZBBJHa7IvY7XjxkUZ353lggmqKfs/jYM6LWD
        HY22/dphb7pLqaCfsnq9fmHxUP5GQFC96OtsFC/R0Fw2t96QTgI3SI2kp1uFoQclEwk4eZ+uDUx
        UWnxpME8Fn8oj
X-Received: by 2002:a05:6808:d4d:b0:2d4:8fe6:fc4 with SMTP id w13-20020a0568080d4d00b002d48fe60fc4mr2575873oik.235.1645556702745;
        Tue, 22 Feb 2022 11:05:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyo/c9slhC5S61X87AcVm/IK2FJA3uqQWEzKCfQ5Rvxt7dMTdmq7zsi0YUKkaQX5usT9/Pqvg==
X-Received: by 2002:a05:6808:d4d:b0:2d4:8fe6:fc4 with SMTP id w13-20020a0568080d4d00b002d48fe60fc4mr2575861oik.235.1645556702484;
        Tue, 22 Feb 2022 11:05:02 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bj38sm6068143oib.20.2022.02.22.11.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 11:05:02 -0800 (PST)
Date:   Tue, 22 Feb 2022 12:05:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     David Stevens <stevensd@chromium.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: VFIO_IOMMU_TYPE1 inefficiencies for certain use cases
Message-ID: <20220222120500.6094849c.alex.williamson@redhat.com>
In-Reply-To: <CAD=HUj7QkS8Yh6-AF_wj0FSubsyxsb9JfTbaVHJmRyXw+gepUg@mail.gmail.com>
References: <CAD=HUj7QkS8Yh6-AF_wj0FSubsyxsb9JfTbaVHJmRyXw+gepUg@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On Fri, 18 Feb 2022 19:17:12 +0900
David Stevens <stevensd@chromium.org> wrote:

> Hi all,
> 
> I'm working on a consumer virtualization project that uses VFIO for
> passthrough devices. However, the way it's using them is a little
> unusual, and that results in some pretty significant inefficiencies in
> the vfio_iommu_type1 implementation. Before going ahead and trying to
> address the problems myself, I'm hoping to get some guidance about
> what sort of changes might be able to be merged upstream.
> 
> The usage pattern that is not well supported by VFIO is many small,
> dynamic mappings. We have this pattern because we are using
> virtio-iommu to isolate some untrusted passthrough devices within the
> guest, and also because for the rest of the passthrough devices we're
> using coIOMMU [1] to support overcommit of memory in the host by not
> pinning all of the guest's memory. Both of these rely on using
> VFIO_IOMMU_MAP_DMA at the page granularity. This results in a lot of
> metadata overhead from the struct vfio_dma. At 80 bytes of metadata
> per page (actually 128 due to rounding in kmalloc), 1-2% of total
> system memory can end up being used for VFIO metadata.
> 
> First, is this sort of use case something that upstream wants to address?
> 
> If it's something that is worth addressing, here are two possible
> approaches I've thought of. I haven't implemented either yet, so there
> might be details I'm missing, or the API changes or maintenance costs
> might not be acceptable. Both are a little bit different from
> VFIO_TYPE1_IOMMU, so they would probably require at least a
> VFIO_TYPE1v3_IOMMU type.
> 
> 1) Add an alternative xarray implementation for vfio_iommu.dma_list
> that maintains the iova -> vaddr mapping at the page granularity. Most
> of the metadata in struct vfio_dma can be packed into the extra bits
> in the vaddr. The two exceptions are vfio_dma.task and
> vfio_dma.pfn_list. The lack of space for vfio_dma.task could be
> addressed by requiring that all mappings have the same task. Without
> vfio_dma.pfn_list, we would lose the refcount maintained by struct
> vfio_pfn, which means every call to vfio_iommu_type1_pin_pages would
> require re-pinning the page. This might be a bit more inefficient,
> although it seems like it should be okay from a correctness
> standpoint.
> 
> One downside of this approach is that it is only more memory efficient
> than the rbtree if the mapping is quite dense, since a struct xa_node
> is quite a bit larger than a struct vfio_dma. This would help the most
> problematic coIOMMU cases, but it would still leave certain
> virtio-iommu cases unaddressed. Also, although most of the struct
> vfio_dma metadata could be packed into the xarray today, that might no
> longer be the case if more metadata was added in the future.
> 
> 2) A second alternative would be to drop the VFIO metadata altogether
> and basically directly expose the iommu APIs (with the required
> locking/validation). This would be incompatible with mediated devices,
> and it wouldn't be able to support the various bells and whistles of
> the VFIO api. However, I think the core mapping/unmapping logic could
> still be shared between the normal struct vfio_dma tree and this
> approach. Personally, I'm a little more in favor of this one, since it
> completely avoids VFIO memory overhead in both of my use cases.
> 
> Do either of those approaches sound like something that might work? If
> neither is okay, are there any suggestions for approaches to take?

I'd advise looking at discussions[1][2] (and hopefully patch series
before too long) around development of the iommufd.  This driver is
meant to provide a common iommu mapping interface for various userspace
use cases, including both vfio and vdpa.  I think the best approach at
this point would be to work with that effort to champion a low-latency,
space efficient, page mapping interface that could be used with your
design.  Perhaps a nested paging solution, which is clearly something
the iommufd work intends to enable, would fit your needs.

In the interim, I don't think we want to promote further extensions to
the existing vfio type1 backend.  Thanks,

Alex

[1]https://lore.kernel.org/all/?q=iommufd
[2]https://lore.kernel.org/all/20210919063848.1476776-1-yi.l.liu@intel.com/

