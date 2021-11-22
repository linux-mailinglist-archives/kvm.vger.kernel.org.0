Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7D459616
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 21:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhKVUeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 15:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhKVUeX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 15:34:23 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E96C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 12:31:16 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 284B46A2;
        Mon, 22 Nov 2021 20:31:15 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 284B46A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1637613075; bh=38c8szBRcFhkJvxMndhYg4axlYAnQw6cjZ5m2H/eLzk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=g/9z/b1pqJDEnkOqhZDw2IV7sVt2SkZH4dLJb+0ZLKQnnoIjEj4q73l7rj6+gCjkc
         e615DaRfdozdf2VHYLxb3RaZtSJdAdJF1EL01gptRpQd5kJRVfw0FzHggFT36Dlx9K
         6eA1UBfjL5bu27tXaY3dlO8xnEb+LHqudGgfinzD8zWpZiXiKBR1u1ocajD0YFvJiO
         xaC1gepYrxiCasGCYYsZOA/sZrzt5Gm+L4Yznm+Q2PdWhxqK38/bHLc5fC02EgL/tu
         fZeGlolnHkOEPYZxIB0QiQv9A+YRpDkAexNz6DJcao5ke8Hf68Ga7HBdEeGlWnXWpv
         9rEuza2WEKgtg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-doc@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Documentation for the migration region
In-Reply-To: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
References: <0-v1-0ec87874bede+123-vfio_mig_doc_jgg@nvidia.com>
Date:   Mon, 22 Nov 2021 13:31:14 -0700
Message-ID: <875yskvsod.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason Gunthorpe <jgg@nvidia.com> writes:

> Provide some more complete documentation for the migration region's
> behavior, specifically focusing on the device_state bits and the whole
> system view from a VMM.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/vfio.rst | 208 +++++++++++++++++++++++++++++-
>  1 file changed, 207 insertions(+), 1 deletion(-)
>
> Alex/Cornelia, here is the first draft of the requested documentation I promised
>
> We think it includes all the feedback from hns, Intel and NVIDIA on this mechanism.
>
> Our thinking is that NDMA would be implemented like this:
>
>    +#define VFIO_DEVICE_STATE_NDMA      (1 << 3)
>
> And a .add_capability ops will be used to signal to userspace driver support:
>
>    +#define VFIO_REGION_INFO_CAP_MIGRATION_NDMA    6
>
> I've described DIRTY TRACKING as a seperate concept here. With the current
> uAPI this would be controlled by VFIO_IOMMU_DIRTY_PAGES_FLAG_START, with our
> change in direction this would be per-tracker control, but no semantic change.
>
> Upon some agreement we'll include this patch in the next iteration of the mlx5 driver
> along with the NDMA bits.
>
> Thanks,
> Jason
>
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f978255b..b28c6fb89ee92f 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -242,7 +242,213 @@ group and can access them as follows::
>  VFIO User API
>  -------------------------------------------------------------------------------
>  
> -Please see include/linux/vfio.h for complete API documentation.
> +Please see include/uapi/linux/vfio.h for complete API documentation.
> +
> +-------------------------------------------------------------------------------
> +
> +VFIO migration driver API
> +-------------------------------------------------------------------------------
> +
> +VFIO drivers that support migration implement a migration control register
> +called device_state in the struct vfio_device_migration_info which is in its
> +VFIO_REGION_TYPE_MIGRATION region.
> +
> +The device_state triggers device action both when bits are set/cleared and
> +continuous behavior for each bit. For VMMs they can also control if the VCPUs in
> +a VM are executing (VCPU RUNNING) and if the IOMMU is logging DMAs (DIRTY
> +TRACKING). These two controls are not part of the device_state register, KVM
> +will be used to control the VCPU and VFIO_IOMMU_DIRTY_PAGES_FLAG_START on the
> +container controls dirty tracking.
> +
> +Along with the device_state the migration driver provides a data window which
> +allows streaming migration data into or out of the device.
> +
> +A lot of flexibility is provided to userspace in how it operates these bits. The
> +reference flow for saving device state in a live migration, with all features:
> +
> +  RUNNING, VCPU_RUNNING
> +     Normal operating state
> +  RUNNING, DIRTY TRACKING, VCPU RUNNING
> +     Log DMAs
> +     Stream all memory

So I'd recommend actually building the docs and looking at the result;
this will not render the way you expect it to.  I'd suggest using a
literal block for preformatted sections like this.

Thanks,

jon
