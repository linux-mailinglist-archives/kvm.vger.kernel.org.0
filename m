Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107C420D35D
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 21:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgF2S6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 14:58:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41786 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730232AbgF2S6R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 14:58:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oy5l01hfztOMplxTNHhOMx7JM2vgkWGI3b7lgHWBSLA=;
        b=ICVLkiQ5mbdv4StNz03UrThm2RjOefTyhg8tJVwN9hv9LZdmrmsbmCEfbrYURGkPy6xvdQ
        RKgPIyovulq75JoheXAlS1AXYR2MCN8IJhB+8++bxjxzYOW0vD/BxLG16SwkR2XehmCSJJ
        QFVRf+5abnDnK1MbrGIBb+ioOhJ+gek=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-y_QQeCLTMai8yxADHGNjyQ-1; Mon, 29 Jun 2020 11:57:22 -0400
X-MC-Unique: y_QQeCLTMai8yxADHGNjyQ-1
Received: by mail-wm1-f69.google.com with SMTP id t145so18646038wmt.2
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 08:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oy5l01hfztOMplxTNHhOMx7JM2vgkWGI3b7lgHWBSLA=;
        b=o4f+JR4eT5Lkl2X1gbo/qnZ5UBUpA6P7S3nrf07qynAokADvcYxE/tpri8g7ONJHYA
         P1HkKzJysMrMO/5qlY5ucGySsiyx8xfFjp/kH8RU+XS7wfW517ZZMgaPYC3aEFDpQfbD
         40DNPrPM2vmnAmWWAq0+vujOxuxumKozfe/oiMBKcx/o5igE8iuKln6EamnGIol1Nzml
         U7UgcYW+/v1PckyuZ7uNEHPFQ/L/sjjXB03e8FE0dYDBQrdhA9tZ9d6u+KjAjgh9Ah6M
         MC/Lgq4xhfwhtl5xp+pRiVysJEBpFH6S0VgsrZrpqzp3LDExCkf/2f+XhyzsJ4d+lSjW
         dgdA==
X-Gm-Message-State: AOAM531W/5cQKPLdjqzI4fbWq5CA6ezApqy/XOXadsly7PAe7+os/HK+
        0MmAcwqtx0q3xIWvQ83jtkOkQsxvhBD17HdoogbTkEIap3Acf08TdH5ec0GMG2jpm+luG490urh
        RWDzRSc/fE8LA
X-Received: by 2002:a1c:a589:: with SMTP id o131mr16317490wme.12.1593446241167;
        Mon, 29 Jun 2020 08:57:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3Q991U1StDDA7B+9BT+HZk+cVYRj7n2VJpgHLiwVYyouUoA4w6BqhRBNFB4h0zTI9ALDIzg==
X-Received: by 2002:a1c:a589:: with SMTP id o131mr16317466wme.12.1593446240963;
        Mon, 29 Jun 2020 08:57:20 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id d18sm241639wrj.8.2020.06.29.08.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 08:57:17 -0700 (PDT)
Date:   Mon, 29 Jun 2020 11:57:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
Message-ID: <20200629115651-mutt-send-email-mst@kernel.org>
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 12:43:57PM +0200, Pierre Morel wrote:
> An architecture protecting the guest memory against unauthorized host
> access may want to enforce VIRTIO I/O device protection through the
> use of VIRTIO_F_IOMMU_PLATFORM.
> 
> Let's give a chance to the architecture to accept or not devices
> without VIRTIO_F_IOMMU_PLATFORM.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/mm/init.c     |  6 ++++++
>  drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>  include/linux/virtio.h  |  2 ++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 6dc7c3b60ef6..215070c03226 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -45,6 +45,7 @@
>  #include <asm/kasan.h>
>  #include <asm/dma-mapping.h>
>  #include <asm/uv.h>
> +#include <linux/virtio.h>
>  
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>  
> @@ -161,6 +162,11 @@ bool force_dma_unencrypted(struct device *dev)
>  	return is_prot_virt_guest();
>  }
>  
> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev)
> +{
> +	return is_prot_virt_guest();
> +}
> +
>  /* protected virtualization */
>  static void pv_init(void)
>  {
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a977e32a88f2..aa8e01104f86 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -167,6 +167,21 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>  }
>  EXPORT_SYMBOL_GPL(virtio_add_status);
>  
> +/*
> + * arch_needs_virtio_iommu_platform - provide arch specific hook when finalizing
> + *				      features for VIRTIO device dev
> + * @dev: the VIRTIO device being added
> + *
> + * Permits the platform to provide architecture specific functionality when
> + * devices features are finalized. This is the default implementation.
> + * Architecture implementations can override this.
> + */
> +
> +int __weak arch_needs_virtio_iommu_platform(struct virtio_device *dev)
> +{
> +	return 0;
> +}
> +
>  int virtio_finalize_features(struct virtio_device *dev)
>  {
>  	int ret = dev->config->finalize_features(dev);
> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
>  	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>  		return 0;
>  
> +	if (arch_needs_virtio_iommu_platform(dev) &&
> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> +		dev_warn(&dev->dev,
> +			 "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");
> +		return -ENODEV;
> +	}
> +
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>  	status = dev->config->get_status(dev);
>  	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {

Well don't you need to check it *before* VIRTIO_F_VERSION_1, not after?



> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index a493eac08393..e8526ae3463e 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -195,4 +195,6 @@ void unregister_virtio_driver(struct virtio_driver *drv);
>  #define module_virtio_driver(__virtio_driver) \
>  	module_driver(__virtio_driver, register_virtio_driver, \
>  			unregister_virtio_driver)
> +
> +int arch_needs_virtio_iommu_platform(struct virtio_device *dev);
>  #endif /* _LINUX_VIRTIO_H */
> -- 
> 2.25.1

