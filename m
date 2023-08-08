Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221E9774A26
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjHHUU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjHHUUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:20:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C7B5593C
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 12:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691522788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOQXy1OfWlgrnfVJYJmwccjJ8wwzdh/vPU5z5GkOlHM=;
        b=DaoN4dFezUOJzciRpwr8LEcEZKqzYBGK+dXzFEAk5WBDBrwdJwMLCxxPlvbssNhFCcmT30
        yyrrbrWKfq7A0gLzl5IGTt9ml2MkAcEmrvrvmOsyVfQWwIQNLjOcsPHBes7MOCjAZeBYy6
        zAv3BwDuDCpJZ1evVOLULdposvpTM24=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-SMI2COAMMhWyN8ndpbJtvg-1; Tue, 08 Aug 2023 15:26:27 -0400
X-MC-Unique: SMI2COAMMhWyN8ndpbJtvg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77a1d6d2f7fso618455539f.2
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 12:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691522786; x=1692127586;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOQXy1OfWlgrnfVJYJmwccjJ8wwzdh/vPU5z5GkOlHM=;
        b=RGmBekouhvdJ8U1s151chv8hqDEYsvkM9Rm25+wAMAbAnsPN7cMERiTutfrjpLOJ5G
         hs8Vy60KXpzq3TgDNWVrD8R3wgUUFLJhq+2/WH7y++C2E0CRnXCp4xwZ79Ut6WQ36A/F
         g2zVtWGn5Q7Q5qMBxYlYbfQOobxB82ngxuTLzWi7RJ1zhY2ewHALVFdFg6PGdhhTfaBD
         k42MUlBEaZKwkJ9+ykh+fdSSP/ULIkvHfjSh5nsnK1HnUTSR8QHYOWHcFSyatdbwEKeo
         DwjXUlXv1ZF7hYSJBCP6I8KSKdDV5qCTWwwQiZtU98zqIa2jIFy9WThsZDUEJuytzub2
         nuBg==
X-Gm-Message-State: AOJu0Yw/91HxbS9VQhMh4AJ+fxvsyGVAM0oR3fpB6fIUmfL90ET1NCep
        V6riZECHnle5D8qdSzUG10WJOq4MXwteOVejOgaD+N/FRllFcoLUDxPcmGxMBSfUtu81LyEYrHh
        o6C9HfEsnIduR
X-Received: by 2002:a5d:8703:0:b0:783:4bc6:636e with SMTP id u3-20020a5d8703000000b007834bc6636emr560738iom.21.1691522786511;
        Tue, 08 Aug 2023 12:26:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6j4eQLjtlHakpjvsIeW5urMxOtXfUS2YPte21G2xG+Juk+2tMgOK5xY6ZmmtdLnt6e9PBAg==
X-Received: by 2002:a5d:8703:0:b0:783:4bc6:636e with SMTP id u3-20020a5d8703000000b007834bc6636emr560726iom.21.1691522786254;
        Tue, 08 Aug 2023 12:26:26 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id ga9-20020a0566381f0900b004290fd3a68dsm3404666jab.1.2023.08.08.12.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 12:26:25 -0700 (PDT)
Date:   Tue, 8 Aug 2023 13:26:24 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio: align capability structures
Message-ID: <20230808132624.6734abb6.alex.williamson@redhat.com>
In-Reply-To: <20230808144216.2656505-1-stefanha@redhat.com>
References: <20230808144216.2656505-1-stefanha@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Aug 2023 10:42:16 -0400
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
> Make life easier for userspace by ensuring alignment in the kernel. This
> is done by padding info struct definitions and by copying out zeroes
> after capability structs that are not aligned.
> 
> The new layout is as follows:
> 
>   +------+---------+---+---------+-----+
>   | info | caps[0] | 0 | caps[1] | ... |
>   +------+---------+---+---------+-----+
> 
> In this example caps[0] has a size that is not multiples of sizeof(u64),
> so zero padding is added to align the subsequent structure.
> 
> Adding zero padding between structs does not break the uapi. The memory
> layout is specified by the info.cap_offset and caps[i].next fields
> filled in by the kernel. Applications use these field values to locate
> structs and are therefore unaffected by the addition of zero padding.
> 
> Note that code that copies out info structs with padding is updated to
> always zero the struct and copy out as many bytes as userspace
> requested. This makes the code shorter and avoids potential information
> leaks by ensuring padding is initialized.
> 
> Originally-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> v2:
> - Simplify padding approach as suggested by Alex
> 
>  include/uapi/linux/vfio.h        |  2 ++
>  drivers/vfio/pci/vfio_pci_core.c | 11 ++---------
>  drivers/vfio/vfio_iommu_type1.c  | 11 ++---------
>  drivers/vfio/vfio_main.c         |  6 ++++++
>  4 files changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 20c804bdc09c..8fe85f5c7b61 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -217,6 +217,7 @@ struct vfio_device_info {
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   pad;
>  };
>  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
>  
> @@ -1304,6 +1305,7 @@ struct vfio_iommu_type1_info {
>  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
>  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32   pad;
>  };
>  
>  /*
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 20d7b69ea6ff..e2ba2a350f6c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -920,24 +920,17 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
>  				   struct vfio_device_info __user *arg)
>  {
>  	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
> -	struct vfio_device_info info;
> +	struct vfio_device_info info = {};
>  	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> -	unsigned long capsz;
>  	int ret;
>  
> -	/* For backward compatibility, cannot require this */
> -	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
> -
>  	if (copy_from_user(&info, arg, minsz))
>  		return -EFAULT;
>  
>  	if (info.argsz < minsz)
>  		return -EINVAL;
>  
> -	if (info.argsz >= capsz) {
> -		minsz = capsz;
> -		info.cap_offset = 0;
> -	}
> +	minsz = min_t(size_t, info.argsz, sizeof(info));

Thanks for catching these, LGTM.  I'll see if anyone else offers a
review in the next couple days and otherwise apply this and
20230801155352.1391945-1-stefanha@redhat.com this week.  Thanks,

Alex

>  
>  	info.flags = VFIO_DEVICE_FLAGS_PCI;
>  
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ebe0ad31d0b0..f812c475a626 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2762,27 +2762,20 @@ static int vfio_iommu_dma_avail_build_caps(struct vfio_iommu *iommu,
>  static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
>  				     unsigned long arg)
>  {
> -	struct vfio_iommu_type1_info info;
> +	struct vfio_iommu_type1_info info = {};
>  	unsigned long minsz;
>  	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> -	unsigned long capsz;
>  	int ret;
>  
>  	minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
>  
> -	/* For backward compatibility, cannot require this */
> -	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
> -
>  	if (copy_from_user(&info, (void __user *)arg, minsz))
>  		return -EFAULT;
>  
>  	if (info.argsz < minsz)
>  		return -EINVAL;
>  
> -	if (info.argsz >= capsz) {
> -		minsz = capsz;
> -		info.cap_offset = 0; /* output, no-recopy necessary */
> -	}
> +	minsz = min_t(size_t, info.argsz, sizeof(info));
>  
>  	mutex_lock(&iommu->lock);
>  	info.flags = VFIO_IOMMU_INFO_PGSIZES;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f0ca33b2e1df..2850478301d2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1172,6 +1172,9 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	void *buf;
>  	struct vfio_info_cap_header *header, *tmp;
>  
> +	/* Ensure that the next capability struct will be aligned */
> +	size = ALIGN(size, sizeof(u64));
> +
>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
> @@ -1205,6 +1208,9 @@ void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
>  	struct vfio_info_cap_header *tmp;
>  	void *buf = (void *)caps->buf;
>  
> +	/* Capability structs should start with proper alignment */
> +	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
> +
>  	for (tmp = buf; tmp->next; tmp = buf + tmp->next - offset)
>  		tmp->next += offset;
>  }

