Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F326331037C
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 04:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhBEDV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 22:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229717AbhBEDVz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 22:21:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612495227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cn2ONu1FukrWGtswjFQszGnfs2KLfPIjCZoaoca5e5I=;
        b=RWEev3z322QjjwedIUl6vp6J4rFGHiinAGNVfn+5HY+aw3g9/gPE6DVsFCqIrLlvMAZRHI
        PqPWvcshcJ7jZXDOHRhvL48WsmCIzE3poJen4oNbe2qe085vXp5Vqhfg1qP4OQEaUhQ51B
        AQ2vZ5+lRUBQt4FHZGd35WqEyE1qNCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-3pKCSlWEMg6dxzIFWl2cpw-1; Thu, 04 Feb 2021 22:20:23 -0500
X-MC-Unique: 3pKCSlWEMg6dxzIFWl2cpw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F27B591271;
        Fri,  5 Feb 2021 03:20:21 +0000 (UTC)
Received: from [10.72.12.112] (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 495135C1B4;
        Fri,  5 Feb 2021 03:20:13 +0000 (UTC)
Subject: Re: [PATCH v3 08/13] vdpa: add return value to get_config/set_config
 callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
 <20210204172230.85853-9-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fe6d02be-b6f9-b07f-a86b-97912dddffdc@redhat.com>
Date:   Fri, 5 Feb 2021 11:20:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204172230.85853-9-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/5 上午1:22, Stefano Garzarella wrote:
> All implementations of these callbacks already validate inputs.
>
> Let's return an error from these callbacks, so the caller doesn't
> need to validate the input anymore.
>
> We update all implementations to return -EINVAL in case of invalid
> input.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   include/linux/vdpa.h              | 18 ++++++++++--------
>   drivers/vdpa/ifcvf/ifcvf_main.c   | 24 ++++++++++++++++--------
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 +++++++++++------
>   drivers/vdpa/vdpa_sim/vdpa_sim.c  | 16 ++++++++++------
>   4 files changed, 47 insertions(+), 28 deletions(-)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 4ab5494503a8..0e0cbd5fb41b 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -157,6 +157,7 @@ struct vdpa_iova_range {
>    *				@buf: buffer used to read to
>    *				@len: the length to read from
>    *				configuration space
> + *				Returns integer: success (0) or error (< 0)
>    * @set_config:			Write to device specific configuration space
>    *				@vdev: vdpa device
>    *				@offset: offset from the beginning of
> @@ -164,6 +165,7 @@ struct vdpa_iova_range {
>    *				@buf: buffer used to write from
>    *				@len: the length to write to
>    *				configuration space
> + *				Returns integer: success (0) or error (< 0)
>    * @get_generation:		Get device config generation (optional)
>    *				@vdev: vdpa device
>    *				Returns u32: device generation
> @@ -231,10 +233,10 @@ struct vdpa_config_ops {
>   	u32 (*get_vendor_id)(struct vdpa_device *vdev);
>   	u8 (*get_status)(struct vdpa_device *vdev);
>   	void (*set_status)(struct vdpa_device *vdev, u8 status);
> -	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> -			   void *buf, unsigned int len);
> -	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> -			   const void *buf, unsigned int len);
> +	int (*get_config)(struct vdpa_device *vdev, unsigned int offset,
> +			  void *buf, unsigned int len);
> +	int (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> +			  const void *buf, unsigned int len);
>   	u32 (*get_generation)(struct vdpa_device *vdev);
>   	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>   
> @@ -329,8 +331,8 @@ static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
>   }
>   
>   
> -static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> -				   void *buf, unsigned int len)
> +static inline int vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
> +				  void *buf, unsigned int len)
>   {
>           const struct vdpa_config_ops *ops = vdev->config;
>   
> @@ -339,8 +341,8 @@ static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
>   	 * If it does happen we assume a legacy guest.
>   	 */
>   	if (!vdev->features_valid)
> -		vdpa_set_features(vdev, 0);
> -	ops->get_config(vdev, offset, buf, len);
> +		return vdpa_set_features(vdev, 0);
> +	return ops->get_config(vdev, offset, buf, len);
>   }
>   
>   /**
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 7c8bbfcf6c3e..f5e6a90d8114 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -332,24 +332,32 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>   	return IFCVF_QUEUE_ALIGNMENT;
>   }
>   
> -static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
> -				  unsigned int offset,
> -				  void *buf, unsigned int len)
> +static int ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
> +				 unsigned int offset,
> +				 void *buf, unsigned int len)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
> +	if (offset + len > sizeof(struct virtio_net_config))
> +		return -EINVAL;
> +
>   	ifcvf_read_net_config(vf, offset, buf, len);
> +
> +	return 0;
>   }
>   
> -static void ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
> -				  unsigned int offset, const void *buf,
> -				  unsigned int len)
> +static int ifcvf_vdpa_set_config(struct vdpa_device *vdpa_dev,
> +				 unsigned int offset, const void *buf,
> +				 unsigned int len)
>   {
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	WARN_ON(offset + len > sizeof(struct virtio_net_config));
> +	if (offset + len > sizeof(struct virtio_net_config))
> +		return -EINVAL;
> +
>   	ifcvf_write_net_config(vf, offset, buf, len);
> +
> +	return 0;
>   }
>   
>   static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 029822060017..9323b5ff7988 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1796,20 +1796,25 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
>   }
>   
> -static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
> -				 unsigned int len)
> +static int mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
> +				unsigned int len)
>   {
>   	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>   	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>   
> -	if (offset + len < sizeof(struct virtio_net_config))
> -		memcpy(buf, (u8 *)&ndev->config + offset, len);
> +	if (offset + len > sizeof(struct virtio_net_config))
> +		return -EINVAL;


It looks to me we should use ">=" here?

Thanks


> +
> +	memcpy(buf, (u8 *)&ndev->config + offset, len);
> +
> +	return 0
>   }
>   
> -static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
> -				 unsigned int len)
> +static int mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
> +				unsigned int len)
>   {
>   	/* not supported */
> +	return 0;
>   }
>   
>   static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index a7aeb5d01c3e..3808b01ac703 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -462,32 +462,36 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
>   	spin_unlock(&vdpasim->lock);
>   }
>   
> -static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
> -			     void *buf, unsigned int len)
> +static int vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
> +			      void *buf, unsigned int len)
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   
>   	if (offset + len > vdpasim->dev_attr.config_size)
> -		return;
> +		return -EINVAL;
>   
>   	if (vdpasim->dev_attr.get_config)
>   		vdpasim->dev_attr.get_config(vdpasim, vdpasim->config);
>   
>   	memcpy(buf, vdpasim->config + offset, len);
> +
> +	return 0;
>   }
>   
> -static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
> -			     const void *buf, unsigned int len)
> +static int vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
> +			      const void *buf, unsigned int len)
>   {
>   	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>   
>   	if (offset + len > vdpasim->dev_attr.config_size)
> -		return;
> +		return -EINVAL;
>   
>   	memcpy(vdpasim->config + offset, buf, len);
>   
>   	if (vdpasim->dev_attr.set_config)
>   		vdpasim->dev_attr.set_config(vdpasim, vdpasim->config);
> +
> +	return 0;
>   }
>   
>   static u32 vdpasim_get_generation(struct vdpa_device *vdpa)

