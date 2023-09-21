Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD997A9A1B
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 20:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjIUSgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 14:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjIUSgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 14:36:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025A940079
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e1Dy+qxUIsvP08PXthETRtICNDaWynbQea+1pitxzmk=;
        b=RnHUiyJdB4etZHsnJV2d+am9k1g9ZKv5s8V0lp7sTNnyeS1G/ckyN+ovI5oxurGUWpW1HO
        z8+Wb5N8szTlEVowwFxDLBMJyhOCVgBhiQ0rOpjZQX0nC/z0WVr5ifQPzvqE3vv2TMDyTb
        xPmF361weK0hWyz9PUI+R9iTWey9ucY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-eKGYEENqPJSfbBMoxfyuTQ-1; Thu, 21 Sep 2023 09:57:58 -0400
X-MC-Unique: eKGYEENqPJSfbBMoxfyuTQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99388334de6so77046866b.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 06:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695304678; x=1695909478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1Dy+qxUIsvP08PXthETRtICNDaWynbQea+1pitxzmk=;
        b=YOfqj90H6sgx/MjmmVBBmpuwEYSMF5tSVq3pmW35Fl/ix0kdvIyrKc7bqG+Zoxca16
         trXYH7A7W169z5RBPDQJE8yC44YzijANOjz1cu3F11hUKJz9C1XFwEz+b1qooQxLdk/T
         Sjz40LeYo3X10VBln8T6dQzo9hfBNPk3is+7zYxNFLE5g0n2opZlM3OqIrWOTZxjjJqv
         BgDQmB/rvD39gOZl8EXqWsGTyPDnMbgKYl3lQ2/zS7rDLIy8OhRCUqylvzTBjzLMMCsX
         TSWkN0h/ailSr7zLuUu5UTQJdlP0GNjdd+fsKf7kl7u+CTJKq659sLiIiu5UfRARuDCy
         bVLw==
X-Gm-Message-State: AOJu0YzdV9zNSR1TrZwi+nplApvFKiclyDQSDAUh6zAFamwrysLRO6Ty
        GAX8AXS5yyZJUeTxLxXlLniYh2efwZVOyk/+4rBjv2sKAmQqWvBL1fOW5t00imNriiN2k/scBVU
        rEf7zB23FBOTk
X-Received: by 2002:a17:906:8a64:b0:9a1:a916:17c0 with SMTP id hy4-20020a1709068a6400b009a1a91617c0mr5241976ejc.50.1695304677812;
        Thu, 21 Sep 2023 06:57:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdCvL5opRJK3mVyxGjNUls7MWSFIqctHRj7hOXwFR3APXpu3I0EzJPrqa/eC6hDBdHcMTVAQ==
X-Received: by 2002:a17:906:8a64:b0:9a1:a916:17c0 with SMTP id hy4-20020a1709068a6400b009a1a91617c0mr5241955ejc.50.1695304677409;
        Thu, 21 Sep 2023 06:57:57 -0700 (PDT)
Received: from redhat.com ([2.52.150.187])
        by smtp.gmail.com with ESMTPSA id rp13-20020a170906d96d00b009ada9f7217asm1095930ejb.88.2023.09.21.06.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 06:57:56 -0700 (PDT)
Date:   Thu, 21 Sep 2023 09:57:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, jasowang@redhat.com, jgg@nvidia.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 03/11] virtio-pci: Introduce admin virtqueue
Message-ID: <20230921095216-mutt-send-email-mst@kernel.org>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-4-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921124040.145386-4-yishaih@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023 at 03:40:32PM +0300, Yishai Hadas wrote:
> From: Feng Liu <feliu@nvidia.com>
> 
> Introduce support for the admin virtqueue. By negotiating
> VIRTIO_F_ADMIN_VQ feature, driver detects capability and creates one
> administration virtqueue. Administration virtqueue implementation in
> virtio pci generic layer, enables multiple types of upper layer
> drivers such as vfio, net, blk to utilize it.
> 
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/virtio/Makefile                |  2 +-
>  drivers/virtio/virtio.c                | 37 +++++++++++++--
>  drivers/virtio/virtio_pci_common.h     | 15 +++++-
>  drivers/virtio/virtio_pci_modern.c     | 10 +++-
>  drivers/virtio/virtio_pci_modern_avq.c | 65 ++++++++++++++++++++++++++

if you have a .c file without a .h file you know there's something
fishy. Just add this inside drivers/virtio/virtio_pci_modern.c ?

>  include/linux/virtio_config.h          |  4 ++
>  include/linux/virtio_pci_modern.h      |  3 ++
>  7 files changed, 129 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/virtio/virtio_pci_modern_avq.c
> 
> diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
> index 8e98d24917cc..dcc535b5b4d9 100644
> --- a/drivers/virtio/Makefile
> +++ b/drivers/virtio/Makefile
> @@ -5,7 +5,7 @@ obj-$(CONFIG_VIRTIO_PCI_LIB) += virtio_pci_modern_dev.o
>  obj-$(CONFIG_VIRTIO_PCI_LIB_LEGACY) += virtio_pci_legacy_dev.o
>  obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
>  obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
> -virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o
> +virtio_pci-y := virtio_pci_modern.o virtio_pci_common.o virtio_pci_modern_avq.o
>  virtio_pci-$(CONFIG_VIRTIO_PCI_LEGACY) += virtio_pci_legacy.o
>  obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
>  obj-$(CONFIG_VIRTIO_INPUT) += virtio_input.o
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 3893dc29eb26..f4080692b351 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -302,9 +302,15 @@ static int virtio_dev_probe(struct device *_d)
>  	if (err)
>  		goto err;
>  
> +	if (dev->config->create_avq) {
> +		err = dev->config->create_avq(dev);
> +		if (err)
> +			goto err;
> +	}
> +
>  	err = drv->probe(dev);
>  	if (err)
> -		goto err;
> +		goto err_probe;
>  
>  	/* If probe didn't do it, mark device DRIVER_OK ourselves. */
>  	if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
> @@ -316,6 +322,10 @@ static int virtio_dev_probe(struct device *_d)
>  	virtio_config_enable(dev);
>  
>  	return 0;
> +
> +err_probe:
> +	if (dev->config->destroy_avq)
> +		dev->config->destroy_avq(dev);
>  err:
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>  	return err;
> @@ -331,6 +341,9 @@ static void virtio_dev_remove(struct device *_d)
>  
>  	drv->remove(dev);
>  
> +	if (dev->config->destroy_avq)
> +		dev->config->destroy_avq(dev);
> +
>  	/* Driver should have reset device. */
>  	WARN_ON_ONCE(dev->config->get_status(dev));
>  
> @@ -489,13 +502,20 @@ EXPORT_SYMBOL_GPL(unregister_virtio_device);
>  int virtio_device_freeze(struct virtio_device *dev)
>  {
>  	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
> +	int ret;
>  
>  	virtio_config_disable(dev);
>  
>  	dev->failed = dev->config->get_status(dev) & VIRTIO_CONFIG_S_FAILED;
>  
> -	if (drv && drv->freeze)
> -		return drv->freeze(dev);
> +	if (drv && drv->freeze) {
> +		ret = drv->freeze(dev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (dev->config->destroy_avq)
> +		dev->config->destroy_avq(dev);
>  
>  	return 0;
>  }
> @@ -532,10 +552,16 @@ int virtio_device_restore(struct virtio_device *dev)
>  	if (ret)
>  		goto err;
>  
> +	if (dev->config->create_avq) {
> +		ret = dev->config->create_avq(dev);
> +		if (ret)
> +			goto err;
> +	}
> +
>  	if (drv->restore) {
>  		ret = drv->restore(dev);
>  		if (ret)
> -			goto err;
> +			goto err_restore;
>  	}
>  
>  	/* If restore didn't do it, mark device DRIVER_OK ourselves. */
> @@ -546,6 +572,9 @@ int virtio_device_restore(struct virtio_device *dev)
>  
>  	return 0;
>  
> +err_restore:
> +	if (dev->config->destroy_avq)
> +		dev->config->destroy_avq(dev);
>  err:
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>  	return ret;
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 602021967aaa..9bffa95274b6 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -41,6 +41,14 @@ struct virtio_pci_vq_info {
>  	unsigned int msix_vector;
>  };
>  
> +struct virtio_avq {

admin_vq would be better. and this is pci specific yes? so virtio_pci_

> +	/* Virtqueue info associated with this admin queue. */
> +	struct virtio_pci_vq_info info;
> +	/* Name of the admin queue: avq.$index. */
> +	char name[10];
> +	u16 vq_index;
> +};
> +
>  /* Our device structure */
>  struct virtio_pci_device {
>  	struct virtio_device vdev;
> @@ -58,10 +66,13 @@ struct virtio_pci_device {
>  	spinlock_t lock;
>  	struct list_head virtqueues;
>  
> -	/* array of all queues for house-keeping */
> +	/* Array of all virtqueues reported in the
> +	 * PCI common config num_queues field
> +	 */
>  	struct virtio_pci_vq_info **vqs;
>  	u32 nvqs;
>  
> +	struct virtio_avq *admin;

and this could be thinkably admin_vq.

>  	/* MSI-X support */
>  	int msix_enabled;
>  	int intx_enabled;
> @@ -115,6 +126,8 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
>  		const char * const names[], const bool *ctx,
>  		struct irq_affinity *desc);
>  const char *vp_bus_name(struct virtio_device *vdev);
> +void vp_destroy_avq(struct virtio_device *vdev);
> +int vp_create_avq(struct virtio_device *vdev);
>  
>  /* Setup the affinity for a virtqueue:
>   * - force the affinity for per vq vector
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index d6bb68ba84e5..a72c87687196 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -37,6 +37,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>  
>  	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
>  		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
> +
> +	if (features & BIT_ULL(VIRTIO_F_ADMIN_VQ))
> +		__virtio_set_bit(vdev, VIRTIO_F_ADMIN_VQ);
>  }
>  
>  /* virtio config->finalize_features() implementation */
> @@ -317,7 +320,8 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>  	else
>  		notify = vp_notify;
>  
> -	if (index >= vp_modern_get_num_queues(mdev))
> +	if (!((index < vp_modern_get_num_queues(mdev) ||
> +	      (vp_dev->admin && vp_dev->admin->vq_index == index))))
>  		return ERR_PTR(-EINVAL);
>  
>  	/* Check if queue is either not available or already active. */
> @@ -509,6 +513,8 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
>  	.get_shm_region  = vp_get_shm_region,
>  	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
>  	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
> +	.create_avq = vp_create_avq,
> +	.destroy_avq = vp_destroy_avq,
>  };
>  
>  static const struct virtio_config_ops virtio_pci_config_ops = {
> @@ -529,6 +535,8 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
>  	.get_shm_region  = vp_get_shm_region,
>  	.disable_vq_and_reset = vp_modern_disable_vq_and_reset,
>  	.enable_vq_after_reset = vp_modern_enable_vq_after_reset,
> +	.create_avq = vp_create_avq,
> +	.destroy_avq = vp_destroy_avq,
>  };
>  
>  /* the PCI probing function */
> diff --git a/drivers/virtio/virtio_pci_modern_avq.c b/drivers/virtio/virtio_pci_modern_avq.c
> new file mode 100644
> index 000000000000..114579ad788f
> --- /dev/null
> +++ b/drivers/virtio/virtio_pci_modern_avq.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <linux/virtio.h>
> +#include "virtio_pci_common.h"
> +
> +static u16 vp_modern_avq_num(struct virtio_pci_modern_device *mdev)
> +{
> +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> +
> +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> +	return vp_ioread16(&cfg->admin_queue_num);
> +}
> +
> +static u16 vp_modern_avq_index(struct virtio_pci_modern_device *mdev)
> +{
> +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> +
> +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> +	return vp_ioread16(&cfg->admin_queue_index);
> +}
> +
> +int vp_create_avq(struct virtio_device *vdev)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> +	struct virtio_avq *avq;
> +	struct virtqueue *vq;
> +	u16 admin_q_num;
> +
> +	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
> +		return 0;
> +
> +	admin_q_num = vp_modern_avq_num(&vp_dev->mdev);
> +	if (!admin_q_num)
> +		return -EINVAL;
> +
> +	vp_dev->admin = kzalloc(sizeof(*vp_dev->admin), GFP_KERNEL);
> +	if (!vp_dev->admin)
> +		return -ENOMEM;
> +
> +	avq = vp_dev->admin;
> +	avq->vq_index = vp_modern_avq_index(&vp_dev->mdev);
> +	sprintf(avq->name, "avq.%u", avq->vq_index);
> +	vq = vp_dev->setup_vq(vp_dev, &vp_dev->admin->info, avq->vq_index, NULL,
> +			      avq->name, NULL, VIRTIO_MSI_NO_VECTOR);
> +	if (IS_ERR(vq)) {
> +		dev_err(&vdev->dev, "failed to setup admin virtqueue");
> +		kfree(vp_dev->admin);
> +		return PTR_ERR(vq);
> +	}
> +
> +	vp_dev->admin->info.vq = vq;
> +	vp_modern_set_queue_enable(&vp_dev->mdev, avq->info.vq->index, true);
> +	return 0;
> +}
> +
> +void vp_destroy_avq(struct virtio_device *vdev)
> +{
> +	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> +
> +	if (!vp_dev->admin)
> +		return;
> +
> +	vp_dev->del_vq(&vp_dev->admin->info);
> +	kfree(vp_dev->admin);
> +}
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 2b3438de2c4d..028c51ea90ee 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -93,6 +93,8 @@ typedef void vq_callback_t(struct virtqueue *);
>   *	Returns 0 on success or error status
>   *	If disable_vq_and_reset is set, then enable_vq_after_reset must also be
>   *	set.
> + * @create_avq: initialize admin virtqueue resource.
> + * @destroy_avq: destroy admin virtqueue resource.
>   */
>  struct virtio_config_ops {
>  	void (*get)(struct virtio_device *vdev, unsigned offset,
> @@ -120,6 +122,8 @@ struct virtio_config_ops {
>  			       struct virtio_shm_region *region, u8 id);
>  	int (*disable_vq_and_reset)(struct virtqueue *vq);
>  	int (*enable_vq_after_reset)(struct virtqueue *vq);
> +	int (*create_avq)(struct virtio_device *vdev);
> +	void (*destroy_avq)(struct virtio_device *vdev);
>  };
>  
>  /* If driver didn't advertise the feature, it will never appear. */
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index 067ac1d789bc..f6cb13d858fd 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -10,6 +10,9 @@ struct virtio_pci_modern_common_cfg {
>  
>  	__le16 queue_notify_data;	/* read-write */
>  	__le16 queue_reset;		/* read-write */
> +
> +	__le16 admin_queue_index;	/* read-only */
> +	__le16 admin_queue_num;		/* read-only */
>  };


ouch.
actually there's a problem

        mdev->common = vp_modern_map_capability(mdev, common,
                                      sizeof(struct virtio_pci_common_cfg), 4,
                                      0, sizeof(struct virtio_pci_common_cfg),
                                      NULL, NULL);

extending this structure means some calls will start failing on
existing devices.

even more of an ouch, when we added queue_notify_data and queue_reset we
also possibly broke some devices. well hopefully not since no one
reported failures but we really need to fix that.


>  
>  struct virtio_pci_modern_device {
> -- 
> 2.27.0

