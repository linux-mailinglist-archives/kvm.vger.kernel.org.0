Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F606D81FD
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbjDEPdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237845AbjDEPdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:33:43 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0AB180
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:33:42 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id bb36so736271qtb.3
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 08:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1680708821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JAA83h3rMO9yiss39MIEuvqUfO0ThiaUitzgjnYkq/E=;
        b=VFVjB+wajJZwttZLFmf3dH6GInBwfa6fgjRbdG4XHeLh8yVA+kDknIw516FXMYv7gX
         SF45vZdirh06fUl+obsZmsZTMVmlK3sbHEmnLMLrlinCZvBHyOK6D00LTyFid2/Uenpx
         JCdm/5J2HOw2ZLn0wL7sWdFccemN8yuW2S5qA5BbzbpVvN4eMI3j0CSfFH1zA50mzVN9
         oSYsv5JvTyg7SDNQMP4nIj9xHu3oeIuYxX+KWDQvTkvKvb1XMedpjmvky27E4AAoGSAt
         mz3tgDEDM+lt1ipLb9cut24IDz8vWCXeoYiDQximUhIrfv8S4C149xyyu40wmuYsn0Qj
         AJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680708821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAA83h3rMO9yiss39MIEuvqUfO0ThiaUitzgjnYkq/E=;
        b=suD/zAMAvJ9jM/wFoprkmJ8ngluWv3vrJocKdywn2C1+3eGmCxsHEdmInfez1C2nys
         K9VOl0pyUI0uwuPsDZONOlMIq/MQ4eaQ70ee4ZIBuyQN/smiFGNr66MDvpwUrtb2EC+4
         IMKaEscY73xFwDl+2kI/twuGRo8pcscHkRh3m/Nr5TueHzCuGbc4e9WJhKUYFG9q9uPG
         HDu5sshHbLpjO2MClWf9wnWEhQhxz0Ps8G3bchCMfyUSOG3w44EnPX2yZidmggRSKxl3
         xOQ4pOmQK7VH0vHfW9Lc6WdwfdHCvEa+AGoYBVNevv3nr19LIzVWwO7mVqFizseUROUd
         bJDQ==
X-Gm-Message-State: AAQBX9e4/CcHNDRterEV1R2g2X3/dNNOS/SoBQ6N0XViOJW/kn0xMeAq
        heynZiiULZwpaaCjvYh52/pTun2sfK7lA7IR7vg=
X-Google-Smtp-Source: AKy350ZL3doRQBP2nu8UnusnIpVB12rSuYq2Qlw6uZRfd0UNr5PXOWG51ep5iSgydRWgvN5Ch/fdtw==
X-Received: by 2002:a05:622a:1749:b0:3e3:86d4:5df0 with SMTP id l9-20020a05622a174900b003e386d45df0mr5606985qtk.55.1680708821401;
        Wed, 05 Apr 2023 08:33:41 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id 84-20020a370a57000000b007422fa6376bsm4500271qkk.77.2023.04.05.08.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 08:33:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pk58m-007MHn-08;
        Wed, 05 Apr 2023 12:33:40 -0300
Date:   Wed, 5 Apr 2023 12:33:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, git@amd.com, harpreet.anand@amd.com,
        michal.simek@amd.com
Subject: Re: [PATCH] vfio/cdx: add support for CDX bus
Message-ID: <ZC2U0/v0toRVSWhf@ziepe.ca>
References: <20230403142525.29494-1-nipun.gupta@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403142525.29494-1-nipun.gupta@amd.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 07:55:25PM +0530, Nipun Gupta wrote:

> +enum {
> +	CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
> +};

This seems to be missing the file2alias part.

> +static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
> +{
> +	kfree(vdev->regions);
> +}
> +
> +static int vfio_cdx_reset_device(struct vfio_cdx_device *vdev)
> +{
> +	return cdx_dev_reset(&vdev->cdx_dev->dev);
> +}

Wrapper functions should be avoided.

> +static void vfio_cdx_close_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	int ret;
> +
> +	vfio_cdx_regions_cleanup(vdev);
> +
> +	/* reset the device before cleaning up the interrupts */
> +	ret = vfio_cdx_reset_device(vdev);
> +	if (WARN_ON(ret))
> +		dev_warn(core_vdev->dev,
> +			 "VFIO_CDX: reset device has failed (%d)\n", ret);

This is pretty problematic.. if the reset can fail the device is
returned to the system in an unknown state and it seems pretty likely
that it can be a way to attack the kernel.

> +	case VFIO_DEVICE_RESET:
> +	{
> +		return vfio_cdx_reset_device(vdev);
> +	}

What happens to MMIO access during this reset?

> +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
> +			      struct vm_area_struct *vma)
> +{
> +	u64 size = vma->vm_end - vma->vm_start;
> +	u64 pgoff, base;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	base = pgoff << PAGE_SHIFT;
> +
> +	if (region.size < PAGE_SIZE || base + size > region.size)
> +		return -EINVAL;
> +
> +	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

pgprot_device

> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> +			       size, vma->vm_page_prot);

io_remap_pfn_range
> +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
> +			 struct vm_area_struct *vma)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	struct cdx_device *cdx_dev = vdev->cdx_dev;
> +	unsigned int index;
> +
> +	index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +	if (vma->vm_start & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (vma->vm_end & ~PAGE_MASK)
> +		return -EINVAL;

The core code already assures these checks.

> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +	if (index >= cdx_dev->res_count)
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
> +	    (vma->vm_flags & VM_READ))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
> +	    (vma->vm_flags & VM_WRITE))
> +		return -EINVAL;
> +
> +	vma->vm_private_data = cdx_dev;

not needed

> diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
> new file mode 100644
> index 000000000000..8b6f1ee3f5cd
> --- /dev/null
> +++ b/drivers/vfio/cdx/vfio_cdx_private.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> + */
> +
> +#ifndef VFIO_CDX_PRIVATE_H
> +#define VFIO_CDX_PRIVATE_H
> +
> +#define VFIO_CDX_OFFSET_SHIFT    40
> +#define VFIO_CDX_OFFSET_MASK (((u64)(1) << VFIO_CDX_OFFSET_SHIFT) - 1)
> +
> +#define VFIO_CDX_OFFSET_TO_INDEX(off) ((off) >> VFIO_CDX_OFFSET_SHIFT)
> +
> +#define VFIO_CDX_INDEX_TO_OFFSET(index)	\
> +	((u64)(index) << VFIO_CDX_OFFSET_SHIFT)

use static inlines for function-line macros

> +struct vfio_cdx_region {
> +	u32			flags;
> +	u32			type;
> +	u64			addr;
> +	resource_size_t		size;
> +	void __iomem		*ioaddr;
> +};
> +
> +struct vfio_cdx_device {
> +	struct vfio_device	vdev;
> +	struct cdx_device	*cdx_dev;
> +	struct device		*dev;
> +	struct vfio_cdx_region	*regions;
> +};

This header file does not seem necessary right now

Jason
