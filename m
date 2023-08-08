Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F7B774F46
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 01:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjHHX33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 19:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjHHX33 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 19:29:29 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CB31BC3
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 16:29:27 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-40fee14093dso32994731cf.1
        for <kvm@vger.kernel.org>; Tue, 08 Aug 2023 16:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1691537367; x=1692142167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YE/LYcFZQN6MbPrG0CFAYL17czJIbn0IYvyYFqhferI=;
        b=dMqr9o4M8WjFFzRLn3gT0X6z7XpuuP1kZX6/7LHdZZZBgoyat6Lus4tIiafgpDz0MU
         2RMgaDaSko0mTB53fcS93V6hYpsQvZA/Kark6Mou+j7xe5Yk/01OXIA6qJThHTELrmh8
         r0vAzUAjLjpcS009YhV7uDp6m6kyIt1Y9tYTKxiTqrT+en7vXX71HF+Witbyt758JIhu
         dDzYlg5+Aeg/id0tq5zhGKH4v+VMKRUWhH+bOs+2/Nn3CWJ1yjRDt5LeTeLWHxQ0aY+t
         NlpK/eVBUVS5jRbrwsd0efK74bHY9MAdcXbmUDPXvQR6KcimiyXj+l0gspcKbwOfwcq0
         GnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691537367; x=1692142167;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YE/LYcFZQN6MbPrG0CFAYL17czJIbn0IYvyYFqhferI=;
        b=jlfaOBLTHq+2J9+ugYCULL9NyVZi2hxx7yqBtdkr1WG9+Z1+fbUa+WJP0RnQr9CGG7
         DygT+dKrQumva/TqsOlSSjRixSV25zPAi7hzPmNsgGGKxTXwEYZ05w5gEAHBUtqb/5D1
         T2+hLe0nGYgWNNoaxk9SyNv/VKyMsB7vc4jVE7yA6QPEc4hTPPdMeYxPdjSTbf/BcXWx
         aOFlQWEwBIMBocEzv1l+noGOym7bZP5Yf40Jkkica1nv4XNsrAJytb2f+apW3TOy+Tl3
         WwUok/NB9xDYLQy6mPaG4Ytb8K6X8cAl8uvzVylFbWQC63Eqf8402vnXMYDmP6A/3EHX
         G5fw==
X-Gm-Message-State: AOJu0YwUCrJA+la2AXpx9JOe7s8w0pIpVm41RBoLoFUTZW75oLh68aax
        ucALxISRIF0xZd2rNMFMk2Sqgg==
X-Google-Smtp-Source: AGHT+IEb1Hn6gZeP0sARPggqx3KdSzmLFtqIymY6Wbvb0zN5J0Q+Z1g0X9mqlML8w4Y/XbBaZe/2Tg==
X-Received: by 2002:a05:622a:11c1:b0:40f:f058:1478 with SMTP id n1-20020a05622a11c100b0040ff0581478mr1403575qtk.30.1691537367126;
        Tue, 08 Aug 2023 16:29:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id v29-20020a05622a189d00b00403b3156f18sm3683586qtc.8.2023.08.08.16.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 16:29:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qTW8j-004xs5-Pa;
        Tue, 08 Aug 2023 20:29:25 -0300
Date:   Tue, 8 Aug 2023 20:29:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: align capability structures
Message-ID: <ZNLP1dU1Ijzm/NPE@ziepe.ca>
References: <20230803144109.2331944-1-stefanha@redhat.com>
 <20230803151823.4e5943e6.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230803151823.4e5943e6.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023 at 03:18:23PM -0600, Alex Williamson wrote:

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 902f06e52c48..2d074cbd371d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1362,6 +1362,8 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
>  	void *buf;
>  	struct vfio_info_cap_header *header, *tmp;
>  
> +	size = ALIGN(size, sizeof(u64));
> +
>  	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
> @@ -1395,6 +1397,8 @@ void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
>  	struct vfio_info_cap_header *tmp;
>  	void *buf = (void *)caps->buf;
>  
> +	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
> +
>  	for (tmp = buf; tmp->next; tmp = buf + tmp->next - offset)
>  		tmp->next += offset;
>  }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fa06e3eb4955..fd2761841ffe 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -217,6 +217,7 @@ struct vfio_device_info {
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32	pad;		/* Size must be aligned for caps */
>  };
>  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
>  
> @@ -1444,6 +1445,7 @@ struct vfio_iommu_type1_info {
>  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
>  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32	pad;		/* Size must be aligned for caps */
>  };

IMHO this is partially being caused by not using __aligned_u64 for the
other __u64's in the same struct..

Both of these structs have u64s in them and many arches will
automatically add the above padding. __aligned_u64 will force the
reset to do it, and then making padding explicit as you have done will
make it really true.

This is a subtle x64/x32 compatability issue also. It is probably best
just to do the change across the whole header file.

Please also include the matching hunk for iommufd:

--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -483,6 +483,8 @@ static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
                        rc = cap_size;
                        goto out_put;
                }
+               cap_size = ALIGN(cap_size, sizeof(u64));
+
                if (last_cap && info.argsz >= total_cap_size &&
                    put_user(total_cap_size, &last_cap->next)) {
                        rc = -EFAULT;

Thanks,
Jason
