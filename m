Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC70728A184
	for <lists+kvm@lfdr.de>; Sat, 10 Oct 2020 23:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgJJVMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Oct 2020 17:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729503AbgJJSnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 10 Oct 2020 14:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602355204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rw2VWt86hKJi9HGvVLjPKNFu6SjFMiCf5SSss7xOy/Q=;
        b=NDXB7MozgOv6mB0GurJyezvozBdDdDpUmor6iuDTi4vCohrRGULG0Qza6XhO/7gbgTuVUz
        x4Yr9M4qPWD1Si+QpQRb1mgV6cVs9WvbftGN8z2qmAmYOf90kQnEvHjgJ0Mr5iroVY5q9i
        J+L5F8mdU7HvYLWfyFA2lOKSjrUsoMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-GxRZpKomMhKv13RVUMUygw-1; Sat, 10 Oct 2020 13:12:57 -0400
X-MC-Unique: GxRZpKomMhKv13RVUMUygw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 566D3805EE3;
        Sat, 10 Oct 2020 17:12:56 +0000 (UTC)
Received: from [10.36.113.210] (ovpn-113-210.ams2.redhat.com [10.36.113.210])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD4B810013D0;
        Sat, 10 Oct 2020 17:12:51 +0000 (UTC)
Subject: Re: [PATCH v6 05/10] vfio/fsl-mc: Allow userspace to MMAP fsl-mc
 device MMIO regions
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20201005173654.31773-1-diana.craciun@oss.nxp.com>
 <20201005173654.31773-6-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <90a72cfc-82eb-b867-e23a-7f363499d641@redhat.com>
Date:   Sat, 10 Oct 2020 19:12:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201005173654.31773-6-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 10/5/20 7:36 PM, Diana Craciun wrote:
> Allow userspace to mmap device regions for direct access of
> fsl-mc devices.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 68 ++++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 05dace5ddc2c..55190a2730fb 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -30,11 +30,20 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>  
>  	for (i = 0; i < count; i++) {
>  		struct resource *res = &mc_dev->regions[i];
> +		int no_mmap = is_fsl_mc_bus_dprc(mc_dev);
>  
>  		vdev->regions[i].addr = res->start;
>  		vdev->regions[i].size = resource_size(res);
> -		vdev->regions[i].flags = 0;
>  		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
> +		/*
> +		 * Only regions addressed with PAGE granularity may be
> +		 * MMAPed securely.
> +		 */
> +		if (!no_mmap && !(vdev->regions[i].addr & ~PAGE_MASK) &&
> +				!(vdev->regions[i].size & ~PAGE_MASK))
> +			vdev->regions[i].flags |=
> +					VFIO_REGION_INFO_FLAG_MMAP;
> +
>  	}
>  
>  	return 0;
> @@ -163,9 +172,64 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>  	return -EINVAL;
>  }
>  
> +static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
> +				 struct vm_area_struct *vma)
> +{
> +	u64 size = vma->vm_end - vma->vm_start;
> +	u64 pgoff, base;
> +	u8 region_cacheable;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	base = pgoff << PAGE_SHIFT;
> +
> +	if (region.size < PAGE_SIZE || base + size > region.size)
> +		return -EINVAL;
> +
> +	region_cacheable = (region.type & FSL_MC_REGION_CACHEABLE) &&
> +			   (region.type & FSL_MC_REGION_SHAREABLE);
> +	if (!region_cacheable)
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +
> +	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> +
> +	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> +			       size, vma->vm_page_prot);
> +}
> +
>  static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
>  {
> -	return -EINVAL;
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int index;
> +
> +	index = vma->vm_pgoff >> (VFIO_FSL_MC_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	if (vma->vm_end < vma->vm_start)
> +		return -EINVAL;
> +	if (vma->vm_start & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (vma->vm_end & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +	if (index >= mc_dev->obj_desc.region_count)
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ)
> +			&& (vma->vm_flags & VM_READ))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
> +			&& (vma->vm_flags & VM_WRITE))
> +		return -EINVAL;
> +
> +	vma->vm_private_data = mc_dev;
> +
> +	return vfio_fsl_mc_mmap_mmio(vdev->regions[index], vma);
>  }
>  
>  static const struct vfio_device_ops vfio_fsl_mc_ops = {
> 

