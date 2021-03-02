Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46B32A6E1
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1836445AbhCBPyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239542AbhCBEQD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 23:16:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614658473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DTs5bTdT/130awTFS1tu5ijWxNu0Rt9MlaERqm9NUPU=;
        b=exvsORoxsheubC+CIm1xbrEzodG1sq0d3jV2NACEp1AYvPrWgEcNg7XSqQAVLRR0CHVmwA
        0PB9E1Ewd7x5NHteq2zq1PkO3HdU1k/h2mvxvn19+/5xuGDlKuWetU1+4vJ9oSKmMFcogJ
        KOeX00K7WZoJYg4wwOdVErizW4EJ5PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-O1ppRP1lMXWwFuAq_kwXYA-1; Mon, 01 Mar 2021 23:14:32 -0500
X-MC-Unique: O1ppRP1lMXWwFuAq_kwXYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43D3A1868405;
        Tue,  2 Mar 2021 04:14:31 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-215.pek2.redhat.com [10.72.13.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A424D5C730;
        Tue,  2 Mar 2021 04:14:22 +0000 (UTC)
Subject: Re: [RFC PATCH 01/10] vdpa: add get_config_size callback in
 vdpa_config_ops
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
 <20210216094454.82106-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5de4cd5b-04cb-46ca-1717-075e5e8542fd@redhat.com>
Date:   Tue, 2 Mar 2021 12:14:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210216094454.82106-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/16 5:44 下午, Stefano Garzarella wrote:
> This new callback is used to get the size of the configuration space
> of vDPA devices.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>   include/linux/vdpa.h              | 4 ++++
>   drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
>   drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
>   4 files changed, 25 insertions(+)
>
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 4ab5494503a8..fddf42b17573 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -150,6 +150,9 @@ struct vdpa_iova_range {
>    * @set_status:			Set the device status
>    *				@vdev: vdpa device
>    *				@status: virtio device status
> + * @get_config_size:		Get the size of the configuration space
> + *				@vdev: vdpa device
> + *				Returns size_t: configuration size


Rethink about this, how much we could gain by introducing a dedicated 
ops here? E.g would it be simpler if we simply introduce a 
max_config_size to vdpa device?

Thanks


>    * @get_config:			Read from device specific configuration space
>    *				@vdev: vdpa device
>    *				@offset: offset from the beginning of
> @@ -231,6 +234,7 @@ struct vdpa_config_ops {
>   	u32 (*get_vendor_id)(struct vdpa_device *vdev);
>   	u8 (*get_status)(struct vdpa_device *vdev);
>   	void (*set_status)(struct vdpa_device *vdev, u8 status);
> +	size_t (*get_config_size)(struct vdpa_device *vdev);
>   	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
>   			   void *buf, unsigned int len);
>   	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 7c8bbfcf6c3e..2443271e17d2 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -332,6 +332,11 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>   	return IFCVF_QUEUE_ALIGNMENT;
>   }
>   
> +static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
> +{
> +	return sizeof(struct virtio_net_config);
> +}
> +
>   static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>   				  unsigned int offset,
>   				  void *buf, unsigned int len)
> @@ -392,6 +397,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>   	.get_device_id	= ifcvf_vdpa_get_device_id,
>   	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
>   	.get_vq_align	= ifcvf_vdpa_get_vq_align,
> +	.get_config_size	= ifcvf_vdpa_get_config_size,
>   	.get_config	= ifcvf_vdpa_get_config,
>   	.set_config	= ifcvf_vdpa_set_config,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 10e9b09932eb..78043ee567b6 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1814,6 +1814,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
>   }
>   
> +static size_t mlx5_vdpa_get_config_size(struct vdpa_device *vdev)
> +{
> +	return sizeof(struct virtio_net_config);
> +}
> +
>   static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
>   				 unsigned int len)
>   {
> @@ -1900,6 +1905,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
>   	.get_vendor_id = mlx5_vdpa_get_vendor_id,
>   	.get_status = mlx5_vdpa_get_status,
>   	.set_status = mlx5_vdpa_set_status,
> +	.get_config_size = mlx5_vdpa_get_config_size,
>   	.get_config = mlx5_vdpa_get_config,
>   	.set_config = mlx5_vdpa_set_config,
>   	.get_generation = mlx5_vdpa_get_generation,
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index d5942842432d..779ae6c144d7 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -439,6 +439,13 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
>   	spin_unlock(&vdpasim->lock);
>   }
>   
> +static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
> +{
> +	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +
> +	return vdpasim->dev_attr.config_size;
> +}
> +
>   static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
>   			     void *buf, unsigned int len)
>   {
> @@ -566,6 +573,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
>   	.get_vendor_id          = vdpasim_get_vendor_id,
>   	.get_status             = vdpasim_get_status,
>   	.set_status             = vdpasim_set_status,
> +	.get_config_size        = vdpasim_get_config_size,
>   	.get_config             = vdpasim_get_config,
>   	.set_config             = vdpasim_set_config,
>   	.get_generation         = vdpasim_get_generation,
> @@ -593,6 +601,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
>   	.get_vendor_id          = vdpasim_get_vendor_id,
>   	.get_status             = vdpasim_get_status,
>   	.set_status             = vdpasim_set_status,
> +	.get_config_size        = vdpasim_get_config_size,
>   	.get_config             = vdpasim_get_config,
>   	.set_config             = vdpasim_set_config,
>   	.get_generation         = vdpasim_get_generation,

