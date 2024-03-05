Return-Path: <kvm+bounces-10970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84468871DA0
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17DC41F27E21
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2815B664;
	Tue,  5 Mar 2024 11:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jA3A49vE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D355E58;
	Tue,  5 Mar 2024 11:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709637832; cv=none; b=YXEakB5dDQ2w5C288lLNeVfGlQytFvbg56avMDslxSg+4sl3eNhBOUHmA4k9kd0PsO8h5sfHVy5TrunZjWtmR2qez2x9UTBvkCN8MIlsyL96qRaEYA/GK5RfGjXPeem1HELVFOxoztTpqmJBcIsxtRU0sqkDlkrbgOPgukypmDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709637832; c=relaxed/simple;
	bh=JyjwkuHnYBoLTGojfsVzV+696GFqnuVrIlOLCLHz8hA=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=kStZ+gDxUr1Z1fnZ5g5BpHraDf2zZPUTz1Gawf+PKR7vjtBkWM86X/XyQITZBWcVR19u8y0ygbC04uMGeyT/3Ov1z4jiUvn4nqM2mwJOGgafCP4a8O+epaGEFGitk/maE09RqcPTLMYyj7z7lD8FFrsKUwGcJxpoHiCOSILkGHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jA3A49vE; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709637831; x=1741173831;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JyjwkuHnYBoLTGojfsVzV+696GFqnuVrIlOLCLHz8hA=;
  b=jA3A49vEeSSVhap6QLJlexe4DqpPllhv2dPhuGeU8odTytX9FVTCP3Ea
   zH6D15vw6mXXcbeLb6uDn++FNYp1lHbfSObQ7YIEe6d6pYP94cqWJ8RMN
   WTpE4vJmhzA2qXJYIJpZ83XvPJWXXUwPaNAK46Mw6Do3SVnOAN6C8Rk38
   HOjk1IRJNoTUIsoPTuxj3nGrFGaVD/hPoyv5xErjZ59nBPYOa9Lvuf1u1
   3bGo7i6/zLYLVZgCbUfORT1q9fTXTZdu2++4Kga1o7RURtdaoo5k84kGG
   4WAi8Ud+WUPtHbRc5skO9LQi/tsqBJZUAXTQWPxk2fdNoHjPA5BTqVNF9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4040098"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4040098"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 03:23:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14031011"
Received: from ijarvine-desk1.ger.corp.intel.com (HELO localhost) ([10.246.51.37])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 03:23:30 -0800
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 5 Mar 2024 13:23:25 +0200 (EET)
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>, 
    Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
    Johannes Berg <johannes@sipsolutions.net>, 
    Hans de Goede <hdegoede@redhat.com>, Vadim Pasternak <vadimp@nvidia.com>, 
    Bjorn Andersson <andersson@kernel.org>, 
    Mathieu Poirier <mathieu.poirier@linaro.org>, 
    Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>, 
    Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
    Vasily Gorbik <gor@linux.ibm.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
    Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org, 
    platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
    linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH vhost 1/4] virtio: find_vqs: pass struct instead of multi
 parameters
In-Reply-To: <20240304114719.3710-2-xuanzhuo@linux.alibaba.com>
Message-ID: <f0ff7ef2-ba67-4091-efad-dc8eb8042dc3@linux.intel.com>
References: <20240304114719.3710-1-xuanzhuo@linux.alibaba.com> <20240304114719.3710-2-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Mar 2024, Xuan Zhuo wrote:

> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
> 
> And find_vqs has multi implements in many places:
> 
>  arch/um/drivers/virtio_uml.c
>  drivers/platform/mellanox/mlxbf-tmfifo.c
>  drivers/remoteproc/remoteproc_virtio.c
>  drivers/s390/virtio/virtio_ccw.c
>  drivers/virtio/virtio_mmio.c
>  drivers/virtio/virtio_pci_legacy.c
>  drivers/virtio/virtio_pci_modern.c
>  drivers/virtio/virtio_vdpa.c
> 
> Every time, we try to add a new parameter, that is difficult.
> We must change every find_vqs implement.
> 
> One the other side, if we want to pass a parameter to vring,
> we must change the call path from transport to vring.
> Too many functions need to be changed.
> 
> So it is time to refactor the find_vqs. We pass a structure
> cfg to find_vqs(), that will be passed to vring by transport.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c             | 23 ++++-----
>  drivers/platform/mellanox/mlxbf-tmfifo.c | 13 ++----
>  drivers/remoteproc/remoteproc_virtio.c   | 28 ++++++-----
>  drivers/s390/virtio/virtio_ccw.c         | 29 ++++++------
>  drivers/virtio/virtio_mmio.c             | 26 +++++------
>  drivers/virtio/virtio_pci_common.c       | 59 +++++++++++-------------
>  drivers/virtio/virtio_pci_common.h       |  9 +---
>  drivers/virtio/virtio_pci_legacy.c       | 11 +++--
>  drivers/virtio/virtio_pci_modern.c       | 33 +++++++------
>  drivers/virtio/virtio_vdpa.c             | 36 +++++++--------
>  include/linux/virtio_config.h            | 51 ++++++++++++++++----
>  11 files changed, 172 insertions(+), 146 deletions(-)
> 
> diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
> index 8adca2000e51..c13dfeeb90c4 100644
> --- a/arch/um/drivers/virtio_uml.c
> +++ b/arch/um/drivers/virtio_uml.c
> @@ -937,8 +937,8 @@ static int vu_setup_vq_call_fd(struct virtio_uml_device *vu_dev,
>  }
>  
>  static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
> -				     unsigned index, vq_callback_t *callback,
> -				     const char *name, bool ctx)
> +				     unsigned index,
> +				     struct virtio_vq_config *cfg)
>  {
>  	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
>  	struct platform_device *pdev = vu_dev->pdev;
> @@ -953,10 +953,12 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
>  		goto error_kzalloc;
>  	}
>  	snprintf(info->name, sizeof(info->name), "%s.%d-%s", pdev->name,
> -		 pdev->id, name);
> +		 pdev->id, cfg->names[cfg->cfg_idx]);
>  
>  	vq = vring_create_virtqueue(index, num, PAGE_SIZE, vdev, true, true,
> -				    ctx, vu_notify, callback, info->name);
> +				    cfg->ctx ? cfg->ctx[cfg->cfg_idx] : false,

Based on the commit message, I don't understand why this transformation 
was made. It's perhaps some artifact of moving things around but please 
state it in the commit message because this isn't 1:1 transformation 
which would be just ctx -> cfg->ctx

> +				    vu_notify,
> +				    cfg->callbacks[cfg->cfg_idx], info->name);
>  	if (!vq) {
>  		rc = -ENOMEM;
>  		goto error_create;


> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index b655fccaf773..a9ae03904dcf 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -172,9 +172,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>  }
>  
>  static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int index,
> -				     void (*callback)(struct virtqueue *vq),
> -				     const char *name,
> -				     bool ctx,
> +				     struct virtio_vq_config *cfg,
>  				     u16 msix_vec)
>  {
>  	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
> @@ -186,13 +184,13 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned int in
>  	if (!info)
>  		return ERR_PTR(-ENOMEM);
>  
> -	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> +	vq = vp_dev->setup_vq(vp_dev, info, index, cfg,
>  			      msix_vec);

Should now easily fit to one line.


> @@ -126,10 +124,7 @@ bool vp_notify(struct virtqueue *vq);
>  /* the config->del_vqs() implementation */
>  void vp_del_vqs(struct virtio_device *vdev);
>  /* the config->find_vqs() implementation */
> -int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
> -		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		const char * const names[], const bool *ctx,
> -		struct irq_affinity *desc);
> +int vp_find_vqs(struct virtio_device *vdev, struct virtio_vq_config *cfg);

Without knowing better, do you expect cfg is mutated inside vp_find_vqs()? 
If not, mark it as const.

> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index da9b271b54db..1df8634d1258 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -96,6 +96,20 @@ typedef void vq_callback_t(struct virtqueue *);
>   * @create_avq: create admin virtqueue resource.
>   * @destroy_avq: destroy admin virtqueue resource.
>   */
> +
> +struct virtio_vq_config {
> +	unsigned int nvqs;
> +
> +	/* the vq index may not eq to the cfg index of the other array items */

Can you try to make this comment clearer, as is I don't understand what it 
means. E.g. what is "the other array"? not eq = not equal ?

> +	unsigned int cfg_idx;
> +
> +	struct virtqueue **vqs;
> +	vq_callback_t **callbacks;
> +	const char *const *names;
> +	const bool *ctx;
> +	struct irq_affinity *desc;
> +};

The placement of the struct is wrong. Now the documentation of struct 
virtio_config_ops is above your struct!?!

Please also document the members of the newly added struct with kerneldoc.

> +
>  struct virtio_config_ops {
>  	void (*get)(struct virtio_device *vdev, unsigned offset,
>  		    void *buf, unsigned len);
> @@ -105,10 +119,7 @@ struct virtio_config_ops {
>  	u8 (*get_status)(struct virtio_device *vdev);
>  	void (*set_status)(struct virtio_device *vdev, u8 status);
>  	void (*reset)(struct virtio_device *vdev);
> -	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
> -			struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -			const char * const names[], const bool *ctx,
> -			struct irq_affinity *desc);
> +	int (*find_vqs)(struct virtio_device *vdev, struct virtio_vq_config *cfg);
>  	void (*del_vqs)(struct virtio_device *);
>  	void (*synchronize_cbs)(struct virtio_device *);
>  	u64 (*get_features)(struct virtio_device *vdev);


-- 
 i.


