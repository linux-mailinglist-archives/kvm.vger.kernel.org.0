Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0825C616
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgICQFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 12:05:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31770 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728254AbgICQFY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 12:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599149122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lywqd6voRznuMzn+og25jGwd7RuHrKT23MBfJquoAhQ=;
        b=ctGk2S+dpSCPwZb4cxpVo9StsbkhaWIyeJkVKrmFfpp1VnQG6ktgeCKOjaUIhu0/b3f0E9
        iQ1WnxDmrN4Nd0GQY+sGTg3jD7sdc7QOPeeVtCxD3ubul+LemGc7h7LLjEHi33EJsllFBP
        7W0ErRB853TLXtPpxN1NeFZvKQWUvcY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-h62wHkyWM16EAmB4I-Mwkw-1; Thu, 03 Sep 2020 12:05:20 -0400
X-MC-Unique: h62wHkyWM16EAmB4I-Mwkw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECEC107464A;
        Thu,  3 Sep 2020 16:05:19 +0000 (UTC)
Received: from [10.36.112.51] (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF4D65D9CC;
        Thu,  3 Sep 2020 16:05:14 +0000 (UTC)
Subject: Re: [PATCH v4 05/10] vfio/fsl-mc: Allow userspace to MMAP fsl-mc
 device MMIO regions
To:     Diana Craciun <diana.craciun@oss.nxp.com>,
        alex.williamson@redhat.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bharatb.linux@gmail.com,
        laurentiu.tudor@nxp.com, Bharat Bhushan <Bharat.Bhushan@nxp.com>
References: <20200826093315.5279-1-diana.craciun@oss.nxp.com>
 <20200826093315.5279-6-diana.craciun@oss.nxp.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ee1e9d74-5be6-6c92-5362-bff06539f21f@redhat.com>
Date:   Thu, 3 Sep 2020 18:05:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200826093315.5279-6-diana.craciun@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Diana,

On 8/26/20 11:33 AM, Diana Craciun wrote:
> Allow userspace to mmap device regions for direct access of
> fsl-mc devices.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 60 +++++++++++++++++++++++++++++--
>  1 file changed, 58 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 093b8d68496c..64d5c1fff51f 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -33,7 +33,8 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>  
>  		vdev->regions[i].addr = res->start;
>  		vdev->regions[i].size = resource_size(res);
> -		vdev->regions[i].flags = 0;
> +		vdev->regions[i].flags = VFIO_REGION_INFO_FLAG_MMAP;
Is the region always mmappable or does it depend on the
mc_dev->regions[i].flags. Also on VFIO platform we checked some
alignment addr/size constraints.
> +		vdev->regions[i].type = mc_dev->regions[i].flags & IORESOURCE_BITS;
>  	}
>  
>  	vdev->num_regions = mc_dev->obj_desc.region_count;
> @@ -164,9 +165,64 @@ static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
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
I see in fsl-mc-bus.c that IORESOURCE_CACHEABLE and IORESOURCE_MEM are
set on the regions flag?
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
> +	if (index >= vdev->num_regions)
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
Thanks

Eric

