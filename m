Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021414BB6B1
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 11:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiBRKRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 05:17:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiBRKRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 05:17:41 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E2F5433
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 02:17:23 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id j2so18721689ybu.0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 02:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Iyy5NDpqyWYMvwDNnRCQYWfvKM6GZvR51fujVV6RFrs=;
        b=i3vFnj30bfPYmDOKbVR++ln/B2wxebX0RvLUuYBE5RBi9Ffd+vU4uWK4dUmWSnkY2Z
         3ue2wPXNtiRL0cCemvzPb5jV6GuqQ4KmIOk4wnE4Qg84fJsUWu0s9iCHOMT6lyFJryS2
         gN5Ax3F2GovUh2eAQVgwDyNQPHmKjogA+5cmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Iyy5NDpqyWYMvwDNnRCQYWfvKM6GZvR51fujVV6RFrs=;
        b=X6HHz8pVBagmddMwgb5kEI6QGUxAAvnAGKYy8Dh7dzNr3orb2hj+AuIZ5/sz6UGykw
         QObCw5ijMq4s7f/wMT/Jet5HY2sG35VxXKYF7D5FRU+8OmLOFwu8R6cjsKnDz9MaW/qs
         3yuMC1d18nwPhs+KoEE8fCulsftpo/6M4xpNgHKuZHMgZ8hlJ4izfJ2Xr0XgUYV/uPoz
         jLURReDVQw37WkcfFtFQSDIN7TQU3oJPWYrCKITD1tX55YQylFGDjPBhhc3V9UQ9MtxK
         HzfW4xsmncgEkuIz7IMWNvlD8rPiu+B7mFWV2T9GBJAWfWMn82uCLCW+HKgRy+Dwk2bP
         ZPNg==
X-Gm-Message-State: AOAM532Cgqkkt3lmfdUfnKpaG1Q7SUj5IDXCMe24m0JKgs6UeqFfRIA+
        Y1/hkQHtk21hfHN7s//7zrhFj4OdexibkwcYKSN2yg==
X-Google-Smtp-Source: ABdhPJyCoXyY9OiZrukbFFfVcGF7PFDFU+nJDGRxtxAWinTEDCkHxTXuhe7uiSaf4Brj9mb5hjCDOg/9eFE3HtRRkbM=
X-Received: by 2002:a25:5206:0:b0:61d:fcd7:fa74 with SMTP id
 g6-20020a255206000000b0061dfcd7fa74mr6611554ybb.534.1645179442571; Fri, 18
 Feb 2022 02:17:22 -0800 (PST)
MIME-Version: 1.0
From:   David Stevens <stevensd@chromium.org>
Date:   Fri, 18 Feb 2022 19:17:12 +0900
Message-ID: <CAD=HUj7QkS8Yh6-AF_wj0FSubsyxsb9JfTbaVHJmRyXw+gepUg@mail.gmail.com>
Subject: VFIO_IOMMU_TYPE1 inefficiencies for certain use cases
To:     alex.williamson@redhat.com, Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I'm working on a consumer virtualization project that uses VFIO for
passthrough devices. However, the way it's using them is a little
unusual, and that results in some pretty significant inefficiencies in
the vfio_iommu_type1 implementation. Before going ahead and trying to
address the problems myself, I'm hoping to get some guidance about
what sort of changes might be able to be merged upstream.

The usage pattern that is not well supported by VFIO is many small,
dynamic mappings. We have this pattern because we are using
virtio-iommu to isolate some untrusted passthrough devices within the
guest, and also because for the rest of the passthrough devices we're
using coIOMMU [1] to support overcommit of memory in the host by not
pinning all of the guest's memory. Both of these rely on using
VFIO_IOMMU_MAP_DMA at the page granularity. This results in a lot of
metadata overhead from the struct vfio_dma. At 80 bytes of metadata
per page (actually 128 due to rounding in kmalloc), 1-2% of total
system memory can end up being used for VFIO metadata.

First, is this sort of use case something that upstream wants to address?

If it's something that is worth addressing, here are two possible
approaches I've thought of. I haven't implemented either yet, so there
might be details I'm missing, or the API changes or maintenance costs
might not be acceptable. Both are a little bit different from
VFIO_TYPE1_IOMMU, so they would probably require at least a
VFIO_TYPE1v3_IOMMU type.

1) Add an alternative xarray implementation for vfio_iommu.dma_list
that maintains the iova -> vaddr mapping at the page granularity. Most
of the metadata in struct vfio_dma can be packed into the extra bits
in the vaddr. The two exceptions are vfio_dma.task and
vfio_dma.pfn_list. The lack of space for vfio_dma.task could be
addressed by requiring that all mappings have the same task. Without
vfio_dma.pfn_list, we would lose the refcount maintained by struct
vfio_pfn, which means every call to vfio_iommu_type1_pin_pages would
require re-pinning the page. This might be a bit more inefficient,
although it seems like it should be okay from a correctness
standpoint.

One downside of this approach is that it is only more memory efficient
than the rbtree if the mapping is quite dense, since a struct xa_node
is quite a bit larger than a struct vfio_dma. This would help the most
problematic coIOMMU cases, but it would still leave certain
virtio-iommu cases unaddressed. Also, although most of the struct
vfio_dma metadata could be packed into the xarray today, that might no
longer be the case if more metadata was added in the future.

2) A second alternative would be to drop the VFIO metadata altogether
and basically directly expose the iommu APIs (with the required
locking/validation). This would be incompatible with mediated devices,
and it wouldn't be able to support the various bells and whistles of
the VFIO api. However, I think the core mapping/unmapping logic could
still be shared between the normal struct vfio_dma tree and this
approach. Personally, I'm a little more in favor of this one, since it
completely avoids VFIO memory overhead in both of my use cases.

Do either of those approaches sound like something that might work? If
neither is okay, are there any suggestions for approaches to take?

Thanks,
David

[1] https://www.usenix.org/conference/atc20/presentation/tian
