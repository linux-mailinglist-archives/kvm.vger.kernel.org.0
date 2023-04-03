Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EECA6D537E
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 23:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDCV3A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 17:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbjDCV26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 17:28:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E4C173F
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 14:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680557294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tf7MHv60vp2k26fwOLDFA2jNT1TsKbPHn/4l+Hwjf/s=;
        b=Q+7N8Eqx/QzYCWwXUMqJ4GNrNgd0Z35DVYQIQ3N6f/4M/evJtzQO+ctaFkSRdYdV/20MiV
        gxWrt0l/lS122kejwaiObUYQlrc3xgdKqPhtRayvvVt6McuyKN2wC7C+qr79UgFmQrfbFp
        CemeA5q5XYvNoTydL7OzwTUz87Iuleo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-8-pHF-YrM7mWS0tFTKyYMg-1; Mon, 03 Apr 2023 17:28:12 -0400
X-MC-Unique: 8-pHF-YrM7mWS0tFTKyYMg-1
Received: by mail-il1-f200.google.com with SMTP id c6-20020a056e020bc600b00325da077351so19829937ilu.11
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 14:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557292;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tf7MHv60vp2k26fwOLDFA2jNT1TsKbPHn/4l+Hwjf/s=;
        b=yUSwRoK5YHPP+U9qwIgj3vPo84fCqqzimG6RidOl9nqjMYlup6B7qGfBm+JwZSZqjy
         hKqBcrvGVYxRE86cRvB2+YJKg71NGhB+tchIJlj7vGOQMQaceQJHV/xq4UdZYNrdSJ97
         V6Ys8+0uNZxpffhUab3dBVS/AK+q8jI33OfP8E/WBC5O94/QMTZFTYyyq1KoAKjN28r0
         cmDSDVHONwlMfTgFE7MPe6vUkkDisMhaqc4QxQlSHG/k/ipRDL1nchJCW3GxsMYISU4z
         676mUHLVVy8vWk78lvx7L+J6iZEo6pS9apJEj4gMl+pZRZ9A/a7r2LJ+4sQp8oHExmrX
         Es+A==
X-Gm-Message-State: AAQBX9ejKCuvO+Zq4B0ir+YWb4jkjo08qc10KBiIEH+SKO03Mbys5On2
        PSPvpn+bzxPiX87hYgRzTL/sOhBrGfXvFD1GKRM+pZinWD4dNtp77PVs3HO6+L+t4Uip/hcmdKn
        GfOtf1keHNoZc
X-Received: by 2002:a5e:a616:0:b0:753:786a:c003 with SMTP id q22-20020a5ea616000000b00753786ac003mr635329ioi.3.1680557292183;
        Mon, 03 Apr 2023 14:28:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeBK8jTQpKRj3YBDYuYCPItaKYhl3sLPkbYtcifrm13UX1o2MlMCVl8RcR5FlNr5W/UN0JmA==
X-Received: by 2002:a5e:a616:0:b0:753:786a:c003 with SMTP id q22-20020a5ea616000000b00753786ac003mr635315ioi.3.1680557291980;
        Mon, 03 Apr 2023 14:28:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v11-20020a056638250b00b00408df9534c9sm2774141jat.130.2023.04.03.14.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:28:11 -0700 (PDT)
Date:   Mon, 3 Apr 2023 15:28:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <git@amd.com>, <harpreet.anand@amd.com>, <michal.simek@amd.com>
Subject: Re: [PATCH] vfio/cdx: add support for CDX bus
Message-ID: <20230403152809.239a4988.alex.williamson@redhat.com>
In-Reply-To: <20230403142525.29494-1-nipun.gupta@amd.com>
References: <20230403142525.29494-1-nipun.gupta@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 3 Apr 2023 19:55:25 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:
> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> new file mode 100644
> index 000000000000..82e4ef412c0f
> --- /dev/null
> +++ b/drivers/vfio/cdx/Makefile
...
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
> +
> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> +			       size, vma->vm_page_prot);
> +}
> +
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
> +
> +	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
> +}

I see discussion of MMIO_REGIONS_ENABLE controlling host access to the
device in mc_cdx_pcol.h.  Is a user of vfio-cdx able to manipulate
whether MMIO space of the device is enabled?  If so, what's the system
response to accessing MMIO through the mmap while disabled?  Is MMIO
space accessible even through calling the RESET ioctl?  Is there a
public specification somewhere for CDX?  Thanks,

Alex

