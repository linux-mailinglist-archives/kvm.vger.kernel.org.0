Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A28C580647
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 23:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbiGYVSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 17:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiGYVSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 17:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DF3F237D4
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658783895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NWyiHW5I2/geA1CEWbRzyNY6UqPET26DY1+YZLfRCI=;
        b=GFnRcScho2HqGfIsavFTZpFg0SDeQ48BZHbI+nax0W9xPrTO+LtIrO3CU0U7LZUpUrUd32
        7/8HW+DaPKq5I17evhEng1uDUPag6vadt/RDS+gOBtoQSoRr8ECr0iCwlTWknnx8GB0MaY
        bDOqI+NUl60ku5hTpQ0hZMHjs/qgy0c=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-Qx8l389sM6OWiyUq0BOdAw-1; Mon, 25 Jul 2022 17:17:59 -0400
X-MC-Unique: Qx8l389sM6OWiyUq0BOdAw-1
Received: by mail-il1-f197.google.com with SMTP id h7-20020a92c267000000b002dd80cf0989so702597ild.5
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 14:17:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2NWyiHW5I2/geA1CEWbRzyNY6UqPET26DY1+YZLfRCI=;
        b=bjXDeLZ7s35RW+eJSEiIDnkhDEsLI6svke35x8JXhExZwgE98LSOTsnBYwQb2tKCKa
         WbyCMu4XH/pJoYJiAoJdCr15a3YJeNY29EFMLDAIiyMN9bGjMBRn/9gnnoR22TuhlLoy
         RBRFc7ehybWmAZeylIUIBEk4JaR4UE0FCc1kN8LnyHE+V9ylQWjqpLqL209QPwm3qVbQ
         nrMVh3tvzZ5Q710JvKlou3i36QJ6Vy19RuDd71zxxHEdItu7i92xfKgZGUDcsHlkgz0C
         9TAkg/c4fpXv3eto6IK7R7zGP4sJATdrQI3rzmqJ8DzJ+D+MTz5qrG2yMR/SIOdVW0in
         uJ/w==
X-Gm-Message-State: AJIora/LskPbWl4K8Ex+f1ydzFAfSpjpw02feuyZOxA1TyOkP9AIHp6i
        EV5/v2t3FbP7dTMGcndS4cDEP/SPLNKpSDSgFP1s7CFdc+DA1AXRPX2T2HZ6KPa8sFJRF7bnAIZ
        Rog3wKTt77TZ4
X-Received: by 2002:a05:6e02:148c:b0:2dc:38ae:5c6a with SMTP id n12-20020a056e02148c00b002dc38ae5c6amr5550201ilk.115.1658783878650;
        Mon, 25 Jul 2022 14:17:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uXwuWmhW15O2ymdEn2whv1cs+NjXgAHFLetXDjRt4kzq/rgyjNkTHVfDxBgkGk5gC+VO8tdQ==
X-Received: by 2002:a05:6e02:148c:b0:2dc:38ae:5c6a with SMTP id n12-20020a056e02148c00b002dc38ae5c6amr5550196ilk.115.1658783878367;
        Mon, 25 Jul 2022 14:17:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h76-20020a6bb74f000000b0067baeb55e65sm6614546iof.38.2022.07.25.14.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 14:17:58 -0700 (PDT)
Date:   Mon, 25 Jul 2022 15:17:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <cohuck@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <terrence.xu@intel.com>
Subject: Re: [PATCH v4 00/10] cover-letter: Update vfio_pin/unpin_pages API
Message-ID: <20220725151755.12d53f2e.alex.williamson@redhat.com>
In-Reply-To: <20220723020256.30081-1-nicolinc@nvidia.com>
References: <20220723020256.30081-1-nicolinc@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 19:02:46 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> This is a preparatory series for IOMMUFD v2 patches. It prepares for
> replacing vfio_iommu_type1 implementations of vfio_pin/unpin_pages()
> with IOMMUFD version.
> 
> There's a gap between these two versions: the vfio_iommu_type1 version
> inputs a non-contiguous PFN list and outputs another PFN list for the
> pinned physical page list, while the IOMMUFD version only supports a
> contiguous address input by accepting the starting IO virtual address
> of a set of pages to pin and by outputting to a physical page list.
> 
> The nature of existing callers mostly aligns with the IOMMUFD version,
> except s390's vfio_ccw_cp code where some additional change is needed
> along with this series. Overall, updating to "iova" and "phys_page"
> does improve the caller side to some extent.
> 
> Also fix a misuse of physical address and virtual address in the s390's
> crypto code. And update the input naming at the adjacent vfio_dma_rw().
> 
> This is on github:
> https://github.com/nicolinc/iommufd/commits/vfio_pin_pages-v4
> 
> Terrence has tested this series on i915; Eric has tested on s390.
> 
> Thanks!
> 
> Changelog
> v4:
>  * Dropped double-shifting at two gvt_unpin_guest_page calls, fixing
>    a bug that's discovered by Alex
>  * Added Reviewed-by from Anthony Krowiak
>  * Rebased on top of linux-vfio's next
> v3: https://lore.kernel.org/kvm/20220708224427.1245-1-nicolinc@nvidia.com/
>  * Added a patch to replace roundup with DIV_ROUND_UP in i915 gvt
>  * Dropped the "driver->ops->unpin_pages" and NULL checks in PATCH-1
>  * Changed to use WARN_ON and separate into lines in PATCH-1
>  * Replaced "guest" words with "user" and fix typo in PATCH-5
>  * Updated commit log of PATCH-1, PATCH-6, and PATCH-10
>  * Added Reviewed/Acked-by from Christoph, Jason, Kirti, Kevin and Eric
>  * Added Tested-by from Terrence (i915) and Eric (s390)
> v2: https://lore.kernel.org/kvm/20220706062759.24946-1-nicolinc@nvidia.com/
>  * Added a patch to make vfio_unpin_pages return void
>  * Added two patches to remove PFN list from two s390 callers
>  * Renamed "phys_page" parameter to "pages" for vfio_pin_pages
>  * Updated commit log of kmap_local_page() patch
>  * Added Harald's "Reviewed-by" to pa_ind patch
>  * Rebased on top of Alex's extern removal path
> v1: https://lore.kernel.org/kvm/20220616235212.15185-1-nicolinc@nvidia.com/
> 
> Nicolin Chen (10):
>   vfio: Make vfio_unpin_pages() return void
>   drm/i915/gvt: Replace roundup with DIV_ROUND_UP
>   vfio/ap: Pass in physical address of ind to ap_aqic()
>   vfio/ccw: Only pass in contiguous pages
>   vfio: Pass in starting IOVA to vfio_pin/unpin_pages API
>   vfio/ap: Change saved_pfn to saved_iova
>   vfio/ccw: Change pa_pfn list to pa_iova list
>   vfio: Rename user_iova of vfio_dma_rw()
>   vfio/ccw: Add kmap_local_page() for memcpy
>   vfio: Replace phys_pfn with pages for vfio_pin_pages()
> 
>  .../driver-api/vfio-mediated-device.rst       |   6 +-
>  arch/s390/include/asm/ap.h                    |   6 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  45 ++--
>  drivers/s390/cio/vfio_ccw_cp.c                | 195 +++++++++++-------
>  drivers/s390/crypto/ap_queue.c                |   2 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  54 +++--
>  drivers/s390/crypto/vfio_ap_private.h         |   4 +-
>  drivers/vfio/vfio.c                           |  54 ++---
>  drivers/vfio/vfio.h                           |   8 +-
>  drivers/vfio/vfio_iommu_type1.c               |  45 ++--
>  include/linux/vfio.h                          |   9 +-
>  11 files changed, 213 insertions(+), 215 deletions(-)
> 

Applied to vfio next branch for v5.20.  Thanks,

Alex

