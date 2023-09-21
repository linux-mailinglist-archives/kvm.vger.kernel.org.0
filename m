Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994237A9A21
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjIUSgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjIUSgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E144AD569
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 11:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695319441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pD7tefHLtUrliixxocdkZvjm/zaq4ygqOegWFqR6dIo=;
        b=fjJsf4AGiAhQAmYTZ6yYMGVoeiU4HW95qFReyLIukQ6v5x2VjifYk4ilI2yjdWMmhOLqbc
        +/cDnO46t1ZydsbSwv6qkSUTojHp2ionKQOM1A68C/51ikfvEg5WjRMnsXGnDMw5jlvDBE
        hy+naVyB3a7zsfe/i/imFiATx3Vw2dc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-vPIJuFZjM4iF0oX2Du4Thw-1; Thu, 21 Sep 2023 09:46:27 -0400
X-MC-Unique: vPIJuFZjM4iF0oX2Du4Thw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae0601d689so78804766b.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 06:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695303986; x=1695908786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pD7tefHLtUrliixxocdkZvjm/zaq4ygqOegWFqR6dIo=;
        b=p7jIQQzHrmh4J1FJOf6GbIq8ixv07SX3T3K/7spC6SdYoZVDucYCck8reyeZJsvoW1
         jqXktgyS01LfNj10eOgP0GWLb4+1x7fafQoVzahGnMGnseTYeO9TM2xwhaIsvprlLj46
         7fuUY1JV9rxRZssPNq8ZEMS6vS19JdUcGT2fuRWpWwyPUoaOySPosUGVqnN1GnYBZdFl
         BWVTgL1erKMxrLN8uuYiyf5DLUWJwRJybaeCkfQC3z2zxQczCSXd25O0xoMlrdHsm7SP
         RCamWbX1kGdAM9NdrZbEKwKombapmeaYLFFTzXfnsuS4PjBGv3PJyQZJpDnM0brP+xh+
         A/fg==
X-Gm-Message-State: AOJu0YyDD3Fb6li9S+uvJL1Lb3Z2ISvck1uRy3VAlcgZ3Oaspq5tP4F2
        U0vd1gWEkVXs4URnepnjr3ia+1EhX+tG/H4HSUXzl9zLXkkHtGwQ9YXSR2wL9vhjqzel4/E75Mp
        xSGBdYzrG8PDj
X-Received: by 2002:a17:907:3e15:b0:9ad:e403:239f with SMTP id hp21-20020a1709073e1500b009ade403239fmr6211304ejc.16.1695303986553;
        Thu, 21 Sep 2023 06:46:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHs9L6ehtx6mY/P0YeIfqEguc+IZ+ptSKdD6kk1obNofGgXaLJ5xjpnBXqDpRE/Qvku06L07A==
X-Received: by 2002:a17:907:3e15:b0:9ad:e403:239f with SMTP id hp21-20020a1709073e1500b009ade403239fmr6211270ejc.16.1695303986151;
        Thu, 21 Sep 2023 06:46:26 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b009a1be9c29d7sm1083322ejb.179.2023.09.21.06.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 06:46:25 -0700 (PDT)
Date:   Thu, 21 Sep 2023 09:46:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 01/11] virtio-pci: Use virtio pci device layer vq
 info instead of generic one
Message-ID: <20230921093540-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-2-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-2-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:40:30PM +0300, Yishai Hadas wrote:
> From: Feng Liu <feliu@nvidia.com>
> 
> Currently VQ deletion callback vp_del_vqs() processes generic
> virtio_device level VQ list instead of VQ information available at PCI
> layer.
> 
> To adhere to the layering, use the pci device level VQ information
> stored in the virtqueues or vqs.
> 
> This also prepares the code to handle PCI layer admin vq life cycle to
> be managed within the pci layer and thereby avoid undesired deletion of
> admin vq by upper layer drivers (net, console, vfio), in the del_vqs()
> callback.

> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_common.c | 12 +++++++++---
>  drivers/virtio/virtio_pci_common.h |  1 +
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index c2524a7207cf..7a3e6edc4dd6 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -232,12 +232,16 @@ static void vp_del_vq(struct virtqueue *vq)
>  void vp_del_vqs(struct virtio_device *vdev)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> -	struct virtqueue *vq, *n;
> +	struct virtqueue *vq;
>  	int i;
>  
> -	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
> +	for (i = 0; i < vp_dev->nvqs; i++) {
> +		if (!vp_dev->vqs[i])
> +			continue;
> +
> +		vq = vp_dev->vqs[i]->vq;
>  		if (vp_dev->per_vq_vectors) {
> -			int v = vp_dev->vqs[vq->index]->msix_vector;
> +			int v = vp_dev->vqs[i]->msix_vector;
>  
>  			if (v != VIRTIO_MSI_NO_VECTOR) {
>  				int irq = pci_irq_vector(vp_dev->pci_dev, v);
> @@ -294,6 +298,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
>  	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>  	if (!vp_dev->vqs)
>  		return -ENOMEM;
> +	vp_dev->nvqs = nvqs;
>  
>  	if (per_vq_vectors) {
>  		/* Best option: one for change interrupt, one per vq. */
> @@ -365,6 +370,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
>  	vp_dev->vqs = kcalloc(nvqs, sizeof(*vp_dev->vqs), GFP_KERNEL);
>  	if (!vp_dev->vqs)
>  		return -ENOMEM;
> +	vp_dev->nvqs = nvqs;
>  
>  	err = request_irq(vp_dev->pci_dev->irq, vp_interrupt, IRQF_SHARED,
>  			dev_name(&vdev->dev), vp_dev);
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 4b773bd7c58c..602021967aaa 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -60,6 +60,7 @@ struct virtio_pci_device {
>  
>  	/* array of all queues for house-keeping */
>  	struct virtio_pci_vq_info **vqs;
> +	u32 nvqs;

I don't much like it that we are adding more duplicated info here.
In fact, we tried removing the vqs array in
5c34d002dcc7a6dd665a19d098b4f4cd5501ba1a - there was some bug in that
patch and the author didn't have the time to debug
so I reverted but I don't really think we need to add to that.

>  
>  	/* MSI-X support */
>  	int msix_enabled;
> -- 
> 2.27.0

