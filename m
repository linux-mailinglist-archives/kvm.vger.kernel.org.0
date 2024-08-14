Return-Path: <kvm+bounces-24099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B9195157D
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C8561F256EF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 07:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F593143C5D;
	Wed, 14 Aug 2024 07:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ig1OHb7/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E7213B5AD
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 07:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723620445; cv=none; b=f4xdyaJxn5eG9fyxR9VcCYpK3B1sncpP0NuUQIxR4iUv8mJMUHeBkUfSd3/wSeaCZiZF4Ud1CyRHwtndiCP1xz/z3gajSMP/xh7F2D6dN9vgLG1GUSSPyuGAWoY4YX27nacEIIlRiVQLXhXUHhyZpMzmw5dJ1l9PBHfmad30Q3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723620445; c=relaxed/simple;
	bh=1UP383j6hjG1P69n1FRHYze421i09BJSQebpheB6rVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzXGpd3IQ7xsJRJKhkNLbiDsbuM2OliCQ7jOaH7B4Ow+EXG4/A47xC34ob/Q/HAMEaZai7UHOCXQ2Uf6aWFOi1ykS5yCps7Mlu6zHq5NxVxFPV/TGZjPtBZWNXvChbp+zzrqQ+VYdaT9Wxr3mvtrltShubsM3p7K7XGqZa3/VIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ig1OHb7/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723620442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lWW6/JtLLOdbS2RriwQ1Xt/j+3UDgvX+fkiP4SLbmfs=;
	b=ig1OHb7/8HU5AdHi5UcFcewvvtA4l2CrGBLUJk5tMGqa80X6Ji+/IjZXrCLpjga5VYITwe
	q8jW9l5YDgscKolQvrDbAUtc4EKybOSlYdpEH4Ms2XnTJZlFr7B8mvMTdlyXcSbApyyVhw
	5ub5y7iAjSTjkUsn/VB/W//97+mxPbk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-fN2keFNgNXmkp8S2mGtTaQ-1; Wed, 14 Aug 2024 03:27:21 -0400
X-MC-Unique: fN2keFNgNXmkp8S2mGtTaQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a77e044ff17so405875966b.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 00:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723620440; x=1724225240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWW6/JtLLOdbS2RriwQ1Xt/j+3UDgvX+fkiP4SLbmfs=;
        b=O+d7Ht6NNgwrypUfENnI5NQHdGEACT3BCdpm0UYBpY2Vs1TOW8gUtODOM52j8YTHPd
         RKMvPuXYwzc1S3GIfhfGvcw530SXpxJKH3AAWwiFVXYbmvDMP6aK2Wks+DgmHCdKypVh
         Nks/OnIBXEZa74TsgR2ysESUjt0KxM9F6L7ZlwHF5CRWlKM4d5QC+9quckxA8U80305/
         seeNCOjqC2yRo4Y4/Af1lXA4G6oKF1nsMsXIHdrJmAQSR0rbN465FtGpL4kXxU7iUB6E
         x/5dfnr4qaS+NxSbv//u/dgtmoZDNL1M/3N55qQmfeE97FuE/oNTY6j8Iiznk7e5jVDV
         vIIw==
X-Forwarded-Encrypted: i=1; AJvYcCXcRNHAJqylz5rgM69YC2bsd2O3E0YwukTNwj2OX2/s9eozTQaKjORsDXr49xVt/Y6XPbErmGM1bf6geFa7zWD27H1V
X-Gm-Message-State: AOJu0YyNzVV9Zs3XifmDBmrW2GIdqj6SYJ7fuuL2c4ebGQAzBZu/hvZA
	ouO8XfynU4p8z3Th3ctjZgw8IRoxTKUrXjqBNZyE5ujVkFeqKaBuBRogPd5jH9ii+uJrl7unXSS
	tWDLUmYr8jVrYauusD7Ab+3xMNcl79GuMoC4pg5V+q91FY+ToMA==
X-Received: by 2002:a17:907:e6cb:b0:a7a:83f8:cfd5 with SMTP id a640c23a62f3a-a8366c31b00mr116566066b.18.1723620440174;
        Wed, 14 Aug 2024 00:27:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWLP3dpgqeL2l8ABzufX/5DIla/d7Ejaojfhfx0OWK/1bdtH+0ljIF9zLiuDaMf7faqOl25Q==
X-Received: by 2002:a17:907:e6cb:b0:a7a:83f8:cfd5 with SMTP id a640c23a62f3a-a8366c31b00mr116563466b.18.1723620439327;
        Wed, 14 Aug 2024 00:27:19 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:dcde:9c09:aa95:551d:d374])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f411d225sm137283666b.107.2024.08.14.00.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 00:27:18 -0700 (PDT)
Date: Wed, 14 Aug 2024 03:27:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: dtatulea@nvidia.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost_vdpa: assign irq bypass producer token
 correctly
Message-ID: <20240814032700-mutt-send-email-mst@kernel.org>
References: <20240808082044.11356-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808082044.11356-1-jasowang@redhat.com>

On Thu, Aug 08, 2024 at 04:20:44PM +0800, Jason Wang wrote:
> We used to call irq_bypass_unregister_producer() in
> vhost_vdpa_setup_vq_irq() which is problematic as we don't know if the
> token pointer is still valid or not.
> 
> Actually, we use the eventfd_ctx as the token so the life cycle of the
> token should be bound to the VHOST_SET_VRING_CALL instead of
> vhost_vdpa_setup_vq_irq() which could be called by set_status().
> 
> Fixing this by setting up  irq bypass producer's token when handling
> VHOST_SET_VRING_CALL and un-registering the producer before calling
> vhost_vring_ioctl() to prevent a possible use after free as eventfd
> could have been released in vhost_vring_ioctl().
> 
> Fixes: 2cf1ba9a4d15 ("vhost_vdpa: implement IRQ offloading in vhost_vdpa")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Want to post a non-RFC version?

> ---
> Note for Dragos: Please check whether this fixes your issue. I
> slightly test it with vp_vdpa in L2.
> ---
>  drivers/vhost/vdpa.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e31ec9ebc4ce..388226a48bcc 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -209,11 +209,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>  	if (irq < 0)
>  		return;
>  
> -	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>  	if (!vq->call_ctx.ctx)
>  		return;
>  
> -	vq->call_ctx.producer.token = vq->call_ctx.ctx;
>  	vq->call_ctx.producer.irq = irq;
>  	ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>  	if (unlikely(ret))
> @@ -709,6 +707,12 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			vq->last_avail_idx = vq_state.split.avail_index;
>  		}
>  		break;
> +	case VHOST_SET_VRING_CALL:
> +		if (vq->call_ctx.ctx) {
> +			vhost_vdpa_unsetup_vq_irq(v, idx);
> +			vq->call_ctx.producer.token = NULL;
> +		}
> +		break;
>  	}
>  
>  	r = vhost_vring_ioctl(&v->vdev, cmd, argp);
> @@ -747,13 +751,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  			cb.callback = vhost_vdpa_virtqueue_cb;
>  			cb.private = vq;
>  			cb.trigger = vq->call_ctx.ctx;
> +			vq->call_ctx.producer.token = vq->call_ctx.ctx;
> +			vhost_vdpa_setup_vq_irq(v, idx);
>  		} else {
>  			cb.callback = NULL;
>  			cb.private = NULL;
>  			cb.trigger = NULL;
>  		}
>  		ops->set_vq_cb(vdpa, idx, &cb);
> -		vhost_vdpa_setup_vq_irq(v, idx);
>  		break;
>  
>  	case VHOST_SET_VRING_NUM:
> @@ -1419,6 +1424,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  	for (i = 0; i < nvqs; i++) {
>  		vqs[i] = &v->vqs[i];
>  		vqs[i]->handle_kick = handle_vq_kick;
> +		vqs[i]->call_ctx.ctx = NULL;
>  	}
>  	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>  		       vhost_vdpa_process_iotlb_msg);
> -- 
> 2.31.1


