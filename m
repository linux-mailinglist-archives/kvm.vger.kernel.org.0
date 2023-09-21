Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D7A7AA2D4
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjIUVfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjIUVep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFF3585F7
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYFUdBslfSemlERse4Us5f4NKymG/+Lupcjrt0UUg2s=;
        b=hZESd7VTjPQShEg3gQpVCUZNUSsu8g05cbAKkbp/tzRzD69W8r2kx50yODc8rTtXmp8FiL
        UufpdY+8f3GqrJkhMYQrRjuMdrqV4jYMBc0aa7Ab9e+QnEYH94V5NfqsZSriALMvWrVNoV
        3uGEqCW7UNzIcrsAy2S10RX5rsr370Q=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-it4GRAcdMtq0enQ9qCpZ5g-1; Thu, 21 Sep 2023 10:03:01 -0400
X-MC-Unique: it4GRAcdMtq0enQ9qCpZ5g-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99388334de6so77427166b.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 07:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695304980; x=1695909780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYFUdBslfSemlERse4Us5f4NKymG/+Lupcjrt0UUg2s=;
        b=gkHYPh9SQ41koMuQVKJohHPr5r31GC2x9TwcXRFpyq7cf4f/BskI2jTgHaTP0yzrHx
         4XRMUROjsaQQ3AWgkOpyaPSfXyiLk+ZJkJ2aIxZ71WMr8BsoPX7gjdHSD93D6H6Ja2ws
         j3zgYswifyW5WD4j9oxufoDG/H3uJYQ92dKF6oaY29ZfZvwX7RJrDA+7CYkQLPlWNxWQ
         3VMF3U6vGZpPZU++LqMIkTNEzUmAF+X7395R7oq0vWzKuEfH+trU23EymCvGWVk7v7oa
         E2uKdy2vaLatMqLcZOBnKo1BWirStyJExqnrAY1zxAqxh04Eqkkd0ahk4KqIp7Um/rPB
         7xHQ==
X-Gm-Message-State: AOJu0YxFPE0jMn5GTpTwHrUI1bceYmIij6rkV71dGi6/RoqMowMCefSI
        7cgO/qm6A9zT+LlZhsjnukwI/+9fs8lUZjFE4U/FTfdVeJICL4NuLEhtAApEAIe+E3hj+m1WRav
        bPWDlToB6vgke
X-Received: by 2002:a17:906:13:b0:9a5:7e63:2e0 with SMTP id 19-20020a170906001300b009a57e6302e0mr5496753eja.30.1695304980526;
        Thu, 21 Sep 2023 07:03:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGDrtu0JFw6590Ay/MhiYHIEI6g5Txx1wcLitr4s1+bWtmtSPAeMYJ5QGJ2kmybduZxOWLIA==
X-Received: by 2002:a17:906:13:b0:9a5:7e63:2e0 with SMTP id 19-20020a170906001300b009a57e6302e0mr5496721eja.30.1695304980143;
        Thu, 21 Sep 2023 07:03:00 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id dt11-20020a170906b78b00b009ae482d70besm1079598ejb.134.2023.09.21.07.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 07:02:59 -0700 (PDT)
Date:   Thu, 21 Sep 2023 10:02:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: Re: [PATCH v14 30/42] virtio_pci: introduce helper to get/set queue
 reset
Message-ID: <20230921100112-mutt-send-email-mst@kernel.org>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
 <20220801063902.129329-31-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801063902.129329-31-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022 at 02:38:50PM +0800, Xuan Zhuo wrote:
> Introduce new helpers to implement queue reset and get queue reset
> status.
> 
>  https://github.com/oasis-tcs/virtio-spec/issues/124
>  https://github.com/oasis-tcs/virtio-spec/issues/139
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/virtio_pci_modern_dev.c | 39 ++++++++++++++++++++++++++
>  include/linux/virtio_pci_modern.h      |  2 ++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index fa2a9445bb18..869cb46bef96 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -3,6 +3,7 @@
>  #include <linux/virtio_pci_modern.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> +#include <linux/delay.h>
>  
>  /*
>   * vp_modern_map_capability - map a part of virtio pci capability
> @@ -474,6 +475,44 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
>  }
>  EXPORT_SYMBOL_GPL(vp_modern_set_status);
>  
> +/*
> + * vp_modern_get_queue_reset - get the queue reset status
> + * @mdev: the modern virtio-pci device
> + * @index: queue index
> + */
> +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> +{
> +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> +
> +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> +
> +	vp_iowrite16(index, &cfg->cfg.queue_select);
> +	return vp_ioread16(&cfg->queue_reset);
> +}
> +EXPORT_SYMBOL_GPL(vp_modern_get_queue_reset);
> +

Actually, this does not validate that the config structure is big
enough. So it can access some unrelated memory. Don't know whether
that's exploitable e.g. for CoCo but not nice, anyway.
Need to validate the size and disable reset if it's too small.


> +/*
> + * vp_modern_set_queue_reset - reset the queue
> + * @mdev: the modern virtio-pci device
> + * @index: queue index
> + */
> +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> +{
> +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> +
> +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> +
> +	vp_iowrite16(index, &cfg->cfg.queue_select);
> +	vp_iowrite16(1, &cfg->queue_reset);
> +
> +	while (vp_ioread16(&cfg->queue_reset))
> +		msleep(1);
> +
> +	while (vp_ioread16(&cfg->cfg.queue_enable))
> +		msleep(1);
> +}
> +EXPORT_SYMBOL_GPL(vp_modern_set_queue_reset);
> +
>  /*
>   * vp_modern_queue_vector - set the MSIX vector for a specific virtqueue
>   * @mdev: the modern virtio-pci device
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index 05123b9a606f..c4eeb79b0139 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -113,4 +113,6 @@ void __iomem * vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
>  				       u16 index, resource_size_t *pa);
>  int vp_modern_probe(struct virtio_pci_modern_device *mdev);
>  void vp_modern_remove(struct virtio_pci_modern_device *mdev);
> +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
> +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
>  #endif
> -- 
> 2.31.0

