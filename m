Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693EF1FA8BF
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgFPGXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 02:23:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31710 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726261AbgFPGXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 02:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592288582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VH7R/DoU62ut+esRu7Hjq7cJgKyK7i23Q0GKINZbgM=;
        b=L074jNjqCzjBqcI21Lh8nf+zRILP45p/Lg2LNjOQLEoZ22hJ4qgUmHRqyJgmUuFTMXG0wD
        dSJggUtqfl38Ysfb3ZlA+u5MKSUUhf41tgUM1hlPBXnO5vRStDjzU48GO2xjmPMZXgxV7V
        MdKrIF8XVqTtmPSj/4al0oWcEY4jvVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-dV-6KyFgPMiZJmzQP3PJeQ-1; Tue, 16 Jun 2020 02:22:58 -0400
X-MC-Unique: dV-6KyFgPMiZJmzQP3PJeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 057271085945;
        Tue, 16 Jun 2020 06:22:57 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72FE71001901;
        Tue, 16 Jun 2020 06:22:46 +0000 (UTC)
Subject: Re: [PATCH v2 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1592224764-1258-1-git-send-email-pmorel@linux.ibm.com>
 <1592224764-1258-2-git-send-email-pmorel@linux.ibm.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b45e321a-5acb-9be2-4cd6-ae75d7f78f05@redhat.com>
Date:   Tue, 16 Jun 2020 14:22:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592224764-1258-2-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/6/15 下午8:39, Pierre Morel wrote:
> An architecture protecting the guest memory against unauthorized host
> access may want to enforce VIRTIO I/O device protection through the
> use of VIRTIO_F_IOMMU_PLATFORM.
>
> Let's give a chance to the architecture to accept or not devices
> without VIRTIO_F_IOMMU_PLATFORM.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   arch/s390/mm/init.c     | 6 ++++++
>   drivers/virtio/virtio.c | 9 +++++++++
>   include/linux/virtio.h  | 2 ++
>   3 files changed, 17 insertions(+)
>
> diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
> index 87b2d024e75a..3f04ad09650f 100644
> --- a/arch/s390/mm/init.c
> +++ b/arch/s390/mm/init.c
> @@ -46,6 +46,7 @@
>   #include <asm/kasan.h>
>   #include <asm/dma-mapping.h>
>   #include <asm/uv.h>
> +#include <linux/virtio.h>
>   
>   pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(.bss..swapper_pg_dir);
>   
> @@ -162,6 +163,11 @@ bool force_dma_unencrypted(struct device *dev)
>   	return is_prot_virt_guest();
>   }
>   
> +int arch_needs_iommu_platform(struct virtio_device *dev)
> +{
> +	return is_prot_virt_guest();
> +}
> +
>   /* protected virtualization */
>   static void pv_init(void)
>   {
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index a977e32a88f2..30091089bee8 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -167,6 +167,11 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>   }
>   EXPORT_SYMBOL_GPL(virtio_add_status);
>   
> +int __weak arch_needs_iommu_platform(struct virtio_device *dev)
> +{
> +	return 0;
> +}
> +
>   int virtio_finalize_features(struct virtio_device *dev)
>   {
>   	int ret = dev->config->finalize_features(dev);
> @@ -179,6 +184,10 @@ int virtio_finalize_features(struct virtio_device *dev)
>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>   		return 0;
>   
> +	if (arch_needs_iommu_platform(dev) &&
> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM))
> +		return -EIO;
> +
>   	virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>   	status = dev->config->get_status(dev);
>   	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index a493eac08393..2c46b310c38c 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -195,4 +195,6 @@ void unregister_virtio_driver(struct virtio_driver *drv);
>   #define module_virtio_driver(__virtio_driver) \
>   	module_driver(__virtio_driver, register_virtio_driver, \
>   			unregister_virtio_driver)
> +
> +int arch_needs_iommu_platform(struct virtio_device *dev);
>   #endif /* _LINUX_VIRTIO_H */

