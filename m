Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D02C76F492
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 23:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjHCVTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 17:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjHCVTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 17:19:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA3E211E
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 14:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691097508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxsbW3bAHVEZm7hXwF+kjqoxRoiowudt/Vzyxy79JVs=;
        b=bcTeyAZ8F/+GuudXM6pbKADXfzGKYdaqJFiHNUyzesGv7AN9YQadwLTQyQVWZziD3brUMq
        Qj85HCxy4hmbNDNMT/zBS53Era8Rs3PLCqF+lma/FFgeAfi9zRGGdZaGfe9XmQ3Hf/pKLi
        cF5eHmhSd9l9df6CZKED1OfkKtTRMro=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-td5WY62ZNjq4ABPEH7Ie6A-1; Thu, 03 Aug 2023 17:18:27 -0400
X-MC-Unique: td5WY62ZNjq4ABPEH7Ie6A-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-786ec569fe6so131169039f.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 14:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691097506; x=1691702306;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zxsbW3bAHVEZm7hXwF+kjqoxRoiowudt/Vzyxy79JVs=;
        b=CWvwYOL4/gLylfXLAeHH1JDa67ex+8SJPcGMl+08BhfL9gUKsQqWXrtkgXkGtyf2d4
         jdvaGXL1a5HfnP2292SXGi71pr5gvj8oxQ/tpSRsBB0+doYwEqHrOdzJoubQv3qrYdz/
         aOPiFqyKhySh/ZIqgqhVTvAQGcatyXH2CwQWRk78ocqcC/n/4dPOk/1PjM4VAebk8Gh7
         EvSYPMTiMX+auB7rgKUMiZ3nQ5OqXaArhbcgAvIk6XR9AyPB14lNqAiFnNF1YNMiN6F0
         2vTqtopPyXD1HNXHRY8EIF09Jc9jlD9m0/gqaI3XR/pJWcnz/UpTYYJ/5ChwsI9CAIoK
         Lggw==
X-Gm-Message-State: ABy/qLYt4A0xt58phA4OqdYaw15Dm+4MJfYDeO1IDh0YZJkR49vfzIxV
        tLSr7Mr0rPHKiZy/6t1Tz0jF/dz0hsG9q+JpPq9uvC2MN6vho3hsQ08ApyN58AsB3VHLByUn2RL
        vOPvFn3+zFX//rmZQJALT
X-Received: by 2002:a5d:9755:0:b0:783:72b9:ed67 with SMTP id c21-20020a5d9755000000b0078372b9ed67mr19118009ioo.10.1691097506021;
        Thu, 03 Aug 2023 14:18:26 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFaIIK4smhA5e+B+dxZ7qnh0iU3KDmvXmnlaWl3LKCFTBWJarYK7Dcp5ZoSbiwC+Qu49SilQQ==
X-Received: by 2002:a5d:9755:0:b0:783:72b9:ed67 with SMTP id c21-20020a5d9755000000b0078372b9ed67mr19117998ioo.10.1691097505661;
        Thu, 03 Aug 2023 14:18:25 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id m21-20020a5d8995000000b00790af7745b1sm204360iol.20.2023.08.03.14.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 14:18:24 -0700 (PDT)
Date:   Thu, 3 Aug 2023 15:18:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: align capability structures
Message-ID: <20230803151823.4e5943e6.alex.williamson@redhat.com>
In-Reply-To: <20230803144109.2331944-1-stefanha@redhat.com>
References: <20230803144109.2331944-1-stefanha@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Aug 2023 10:41:09 -0400
Stefan Hajnoczi <stefanha@redhat.com> wrote:

> The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> structs:
> 
>   +------+---------+---------+-----+
>   | info | caps[0] | caps[1] | ... |
>   +------+---------+---------+-----+
> 
> Both the info and capability struct sizes are not always multiples of
> sizeof(u64), leaving u64 fields in later capability structs misaligned.
> 
> Userspace applications currently need to handle misalignment manually in
> order to support CPU architectures and programming languages with strict
> alignment requirements.
> 
> Make life easier for userspace by ensuring alignment in the kernel.
> The new layout is as follows:
> 
>   +------+---+---------+---------+---+-----+
>   | info | 0 | caps[0] | caps[1] | 0 | ... |
>   +------+---+---------+---------+---+-----+
> 
> In this example info and caps[1] have sizes that are not multiples of
> sizeof(u64), so zero padding is added to align the subsequent structure.
> 
> Adding zero padding between structs does not break the uapi. The memory
> layout is specified by the info.cap_offset and caps[i].next fields
> filled in by the kernel. Applications use these field values to locate
> structs and are therefore unaffected by the addition of zero padding.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/linux/vfio.h             |  2 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c |  7 +++--
>  drivers/s390/cio/vfio_ccw_ops.c  |  7 +++--
>  drivers/vfio/pci/vfio_pci_core.c | 14 ++++++---
>  drivers/vfio/vfio_iommu_type1.c  |  7 +++--
>  drivers/vfio/vfio_main.c         | 53 +++++++++++++++++++++++++++-----
>  6 files changed, 71 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 2c137ea94a3e..ff0864e73cc3 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -272,7 +272,7 @@ struct vfio_info_cap {
>  struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  					       size_t size, u16 id,
>  					       u16 version);
> -void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
> +ssize_t vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
>  
>  int vfio_info_add_capability(struct vfio_info_cap *caps,
>  			     struct vfio_info_cap_header *cap, size_t size);
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index de675d799c7d..9060e9c6ac7c 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1297,7 +1297,10 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  				info.argsz = sizeof(info) + caps.size;
>  				info.cap_offset = 0;
>  			} else {
> -				vfio_info_cap_shift(&caps, sizeof(info));
> +				ssize_t cap_offset = vfio_info_cap_shift(&caps, sizeof(info));
> +				if (cap_offset < 0)
> +					return cap_offset;
> +
>  				if (copy_to_user((void __user *)arg +
>  						  sizeof(info), caps.buf,
>  						  caps.size)) {
> @@ -1305,7 +1308,7 @@ static long intel_vgpu_ioctl(struct vfio_device *vfio_dev, unsigned int cmd,
>  					kfree(sparse);
>  					return -EFAULT;
>  				}
> -				info.cap_offset = sizeof(info);
> +				info.cap_offset = cap_offset;

The copy_to_user() above needs to be modified to make this true:

	copy_to_user((void __user *)arg + cap_offset,...

Same for all similar below.

>  			}
>  
>  			kfree(caps.buf);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 5b53b94f13c7..63d5163376a5 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -361,13 +361,16 @@ static int vfio_ccw_mdev_get_region_info(struct vfio_ccw_private *private,
>  			info->argsz = sizeof(*info) + caps.size;
>  			info->cap_offset = 0;
>  		} else {
> -			vfio_info_cap_shift(&caps, sizeof(*info));
> +			ssize_t cap_offset = vfio_info_cap_shift(&caps, sizeof(*info));
> +			if (cap_offset < 0)
> +				return cap_offset;
> +
>  			if (copy_to_user((void __user *)arg + sizeof(*info),
>  					 caps.buf, caps.size)) {
>  				kfree(caps.buf);
>  				return -EFAULT;
>  			}
> -			info->cap_offset = sizeof(*info);
> +			info->cap_offset = cap_offset;
>  		}
>  
>  		kfree(caps.buf);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 20d7b69ea6ff..92c093b99187 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -966,12 +966,15 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  		if (info.argsz < sizeof(info) + caps.size) {
>  			info.argsz = sizeof(info) + caps.size;
>  		} else {
> -			vfio_info_cap_shift(&caps, sizeof(info));
> +			ssize_t cap_offset = vfio_info_cap_shift(&caps, sizeof(info));
> +			if (cap_offset < 0)
> +				return cap_offset;
> +
>  			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
>  				kfree(caps.buf);
>  				return -EFAULT;
>  			}
> -			info.cap_offset = sizeof(*arg);
> +			info.cap_offset = cap_offset;
>  		}
>  
>  		kfree(caps.buf);
> @@ -1107,12 +1110,15 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
>  			info.argsz = sizeof(info) + caps.size;
>  			info.cap_offset = 0;
>  		} else {
> -			vfio_info_cap_shift(&caps, sizeof(info));
> +			ssize_t cap_offset = vfio_info_cap_shift(&caps, sizeof(info));
> +			if (cap_offset < 0)
> +				return cap_offset;
> +
>  			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
>  				kfree(caps.buf);
>  				return -EFAULT;
>  			}
> -			info.cap_offset = sizeof(*arg);
> +			info.cap_offset = cap_offset;
>  		}
>  
>  		kfree(caps.buf);
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ebe0ad31d0b0..ab64b9e3ed7c 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2808,14 +2808,17 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>  		if (info.argsz < sizeof(info) + caps.size) {
>  			info.argsz = sizeof(info) + caps.size;
>  		} else {
> -			vfio_info_cap_shift(&caps, sizeof(info));
> +			ssize_t cap_offset = vfio_info_cap_shift(&caps, sizeof(info));
> +			if (cap_offset < 0)
> +				return cap_offset;
> +
>  			if (copy_to_user((void __user *)arg +
>  					sizeof(info), caps.buf,
>  					caps.size)) {
>  				kfree(caps.buf);
>  				return -EFAULT;
>  			}
> -			info.cap_offset = sizeof(info);
> +			info.cap_offset = cap_offset;
>  		}
>  
>  		kfree(caps.buf);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f0ca33b2e1df..4fc8698577a7 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1171,8 +1171,18 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  {
>  	void *buf;
>  	struct vfio_info_cap_header *header, *tmp;
> +	size_t header_offset;
> +	size_t new_size;
>  
> -	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
> +	/*
> +	 * Reserve extra space when the previous capability was not a multiple of
> +	 * the largest field size. This ensures that capabilities are properly
> +	 * aligned.
> +	 */

If we simply start with:

	size = ALIGN(size, sizeof(u64));

then shouldn't there never be a previous misaligned size to correct?

I wonder if we really need all this complexity, we're drawing from a
finite set of info structs for the initial alignment, we can pad those
without breaking the uapi and we can introduce a warning to avoid such
poor alignment in the future.  Allocating an aligned size for each
capability is then sufficiently trivial to handle runtime.  ex:

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 902f06e52c48..2d074cbd371d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1362,6 +1362,8 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	void *buf;
 	struct vfio_info_cap_header *header, *tmp;
 
+	size = ALIGN(size, sizeof(u64));
+
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
@@ -1395,6 +1397,8 @@ void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
 	struct vfio_info_cap_header *tmp;
 	void *buf = (void *)caps->buf;
 
+	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
+
 	for (tmp = buf; tmp->next; tmp = buf + tmp->next - offset)
 		tmp->next += offset;
 }
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index fa06e3eb4955..fd2761841ffe 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -217,6 +217,7 @@ struct vfio_device_info {
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32	pad;		/* Size must be aligned for caps */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
@@ -1444,6 +1445,7 @@ struct vfio_iommu_type1_info {
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
 	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32	pad;		/* Size must be aligned for caps */
 };
 
 /*

Thanks,
Alex


> +	header_offset = ALIGN(caps->size, sizeof(u64));
> +	new_size = header_offset + size;
> +
> +	buf = krealloc(caps->buf, new_size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
>  		caps->buf = NULL;
> @@ -1181,10 +1191,10 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	}
>  
>  	caps->buf = buf;
> -	header = buf + caps->size;
> +	header = buf + header_offset;
>  
>  	/* Eventually copied to user buffer, zero */
> -	memset(header, 0, size);
> +	memset(buf + caps->size, 0, new_size - caps->size);
>  
>  	header->id = id;
>  	header->version = version;
> @@ -1193,20 +1203,47 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	for (tmp = buf; tmp->next; tmp = buf + tmp->next)
>  		; /* nothing */
>  
> -	tmp->next = caps->size;
> -	caps->size += size;
> +	tmp->next = header_offset;
> +	caps->size = new_size;
>  
>  	return header;
>  }
>  EXPORT_SYMBOL_GPL(vfio_info_cap_add);
>  
> -void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
> +/*
> + * Adjust the capability next fields to account for the given offset at which
> + * capability structures start and any padding added for alignment. Returns the
> + * cap_offset or -errno.
> + */
> +ssize_t vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
>  {
>  	struct vfio_info_cap_header *tmp;
> +	struct vfio_info_cap_header *next_tmp;
>  	void *buf = (void *)caps->buf;
> +	size_t pad = ALIGN(offset, sizeof(u64)) - offset;
> +	size_t cap_offset = offset + pad;
>  
> -	for (tmp = buf; tmp->next; tmp = buf + tmp->next - offset)
> -		tmp->next += offset;
> +	/* Shift the next fields to account for offset and pad */
> +	for (tmp = buf; tmp->next; tmp = next_tmp) {
> +		next_tmp = buf + tmp->next;
> +		tmp->next += cap_offset;
> +	}
> +
> +	/* Pad with zeroes so capabilities start with proper alignment */
> +	buf = krealloc(caps->buf, caps->size + pad, GFP_KERNEL);
> +	if (!buf) {
> +		kfree(caps->buf);
> +		caps->buf = NULL;
> +		caps->size = 0;
> +		return -ENOMEM;
> +	}
> +
> +	memmove(buf + pad, buf, caps->size);
> +	memset(buf, 0, pad);
> +
> +	caps->buf = buf;
> +	caps->size += pad;
> +	return cap_offset;
>  }
>  EXPORT_SYMBOL(vfio_info_cap_shift);
>  

