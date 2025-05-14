Return-Path: <kvm+bounces-46494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8061AB6B99
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 702044C3FDA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8999A278161;
	Wed, 14 May 2025 12:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6WiB3SC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068D327780B
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747226519; cv=none; b=aZK76xvzjzEuQjYIvJLiaFjOWKRWWU9HuXdgH3GQVWKGRIiqOLYLI0W5sjyO3Ha/sSq8sQtMqKdmE7Zqk093tlCcKyVMcSu/QwAz+KFU7HlWaD/iGhhFysthm8LDCrSgUesedbgzprNvVCAw/jogNK3Q9mKapm16iU3KcwB4WPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747226519; c=relaxed/simple;
	bh=EEGfYDjUdSZy0/RFIcEvsmm9uPhga5AdR3yZjbpPimk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QoNH1bzZ6/fY1bhdqg5BYcS7bqx9DSdxuPlYxH9uFZmQoD0cvJ7Ba4I2LOHdd9l7XJjJcoDxCBeKcUgHHbINvVXnxbdB6W9KkHh7A9Jh0PPMrH/na6k8JoEsd8/OxlfKYjCdbndv25uQk8yDLgM97byGiU2MSseHUEzvcE37Tvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6WiB3SC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747226517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BHHDRyYIIxfuAzn8skJQ0/Rzmdn0HuqApROcitBMMpk=;
	b=f6WiB3SCdX+5nhu3DI5XmdOFThx8ui/Msp+rmck/QgaNmAtqt6UTz22MLO7ezOeJKiiewN
	eIXEA26hf4W7cnkpN8zHhHFwd6J6YgmQRRh5puXE10DcUITeq0mdHHooL+JhEWz2Bg+NBw
	HbYmjThHsf4Ssy9UuvRrEO9FCh5fm24=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-YSxXsGjEN9q4tlqYHNIhew-1; Wed, 14 May 2025 08:41:55 -0400
X-MC-Unique: YSxXsGjEN9q4tlqYHNIhew-1
X-Mimecast-MFC-AGG-ID: YSxXsGjEN9q4tlqYHNIhew_1747226515
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43ea256f039so49768355e9.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 05:41:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747226515; x=1747831315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHHDRyYIIxfuAzn8skJQ0/Rzmdn0HuqApROcitBMMpk=;
        b=dXPZzMVQS9KPIJ3LSNgAGMKlJQfaQhACpFo3N/9rERpSUsJA2tOfwDrLzsA2PAy7M0
         a8fnil7wyJ6xm+8QQFRDSbce84ZXXpD653nTUz0enz1xYz6o+XakJ5vZJYjK3/267EUs
         Yy6FZhMoUm7QtY7BEZ8Pf4jmmBYM+EcVhNLg2XJNx6MATU2SMLqxLGvMuDNz+svKzJQ6
         YL/2DY/s9aO/FYwfsGnUHYvt6YqJkuy1Cm/hkrKPFbrwlfm4b8EL7tMwi7I8fS3oDF1i
         ZLM2XW8tgSV+/d+wQcXEKIT/HA2LeNhfJIfk0mpOeJUd5HsFuB9kmhlGRxkco8FcdIKf
         ZNwg==
X-Forwarded-Encrypted: i=1; AJvYcCV8jGozXPxFKGX8J7yAbIN5H6QW5HnSvZdD/yjoqtNqrHz48dy6Q4qPXXfdkkb508hKc44=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoSEseS0PRjIzwEgCXCUDbNeaTEEJYAVOkcvjbtsaqvpVZwtwu
	gIZSPxA8A3GN1McP5AGyb2Z7IEfAEvB8eLQN1NEl5Sphhx6KZkMGsKWGMHwEoiRb1w1gJSr9EfI
	NYTcG90xv4gnFGZJeM7CiyBs062Gjkty3yxvmZEF5Q0mSagw7AA==
X-Gm-Gg: ASbGncsfa1qFINFLRloszAhhjklJ6RKU7mtM8zlhv21jcY6NHkZ3xltVgxLHfmLco8i
	d3IWNDCu9aUww95gV2H+XXJYvUPYE4/SQHweWvYSnaB26ctiId8+j8dB4U0w0xN6vZBIKeOE/mM
	3zzMWJI9/4FlQ0U0Nst9spj+KrXY7Lc40skMKOLoL8xVeLnMZVlgzZ5SQ5sfbQTwt/ALf3yPEh0
	1Dv9U6lHJEoMN9k6BrPS7a7r4BHllXfvvIVooak5H4Kp4Hz1gkuWxDbuPm5s4Kp4TugjfRkWbeh
	H6fw6Q==
X-Received: by 2002:a05:600c:4e0e:b0:43c:fdbe:4398 with SMTP id 5b1f17b1804b1-442f20bae9amr29141625e9.6.1747226514677;
        Wed, 14 May 2025 05:41:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE48EoGZ2uk0nrpc2KvJ3SdazvxaUIGvnXn9PXwiAZf3ac9pN6HJ4xaShBQmCTJtS3wZo97WQ==
X-Received: by 2002:a05:600c:4e0e:b0:43c:fdbe:4398 with SMTP id 5b1f17b1804b1-442f20bae9amr29141345e9.6.1747226514281;
        Wed, 14 May 2025 05:41:54 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2f8csm19330179f8f.42.2025.05.14.05.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 05:41:53 -0700 (PDT)
Date: Wed, 14 May 2025 08:41:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: israelr@nvidia.com, stefanha@redhat.com, virtualization@lists.linux.dev,
	linux-block@vger.kernel.org, oren@nvidia.com, nitzanc@nvidia.com,
	dbenbasat@nvidia.com, smalin@nvidia.com, larora@nvidia.com,
	izach@nvidia.com, aaptel@nvidia.com, parav@nvidia.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio_blk: add length check for device writable
 portion
Message-ID: <20250514084133-mutt-send-email-mst@kernel.org>
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
 <20250224233106.8519-2-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224233106.8519-2-mgurtovoy@nvidia.com>

On Tue, Feb 25, 2025 at 01:31:05AM +0200, Max Gurtovoy wrote:
> Add a safety check to ensure that the length of data written by the
> device is at least as large the expected length. If this condition is
> not met, it indicates a potential error in the device's response.
> 
> This change aligns with the virtio specification, which states:
> "The driver MUST NOT make assumptions about data in device-writable
> buffers beyond the first len bytes, and SHOULD ignore this data."
> 
> By setting an error status when len is insufficient, we ensure that the
> driver does not process potentially invalid or incomplete data from the
> device.
> 
> Reviewed-by: Aurelien Aptel <aaptel@nvidia.com>
> Signed-off-by: Lokesh Arora <larora@nvidia.com>
> Signed-off-by: Israel Rukshin <israelr@nvidia.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---



my question is, is the device out of spec, too?



>  drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6a61ec35f426..58407cfee3ee 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -331,6 +331,20 @@ static inline u8 virtblk_vbr_status(struct virtblk_req *vbr)
>  	return *((u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1);
>  }
>  
> +static inline void virtblk_vbr_set_err_status_upon_len_err(struct virtblk_req *vbr,
> +		struct request *req, unsigned int len)
> +{
> +	unsigned int expected_len = vbr->in_hdr_len;
> +
> +	if (rq_dma_dir(req) == DMA_FROM_DEVICE)
> +		expected_len += blk_rq_payload_bytes(req);
> +
> +	if (unlikely(len < expected_len)) {
> +		u8 *status_ptr = (u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1;
> +		*status_ptr = VIRTIO_BLK_S_IOERR;
> +	}
> +}
> +
>  static inline void virtblk_request_done(struct request *req)
>  {
>  	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
> @@ -362,6 +376,9 @@ static void virtblk_done(struct virtqueue *vq)
>  		while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
>  			struct request *req = blk_mq_rq_from_pdu(vbr);
>  
> +			/* Check device writable portion length, and fail upon error */
> +			virtblk_vbr_set_err_status_upon_len_err(vbr, req, len);
> +
>  			if (likely(!blk_should_fake_timeout(req->q)))
>  				blk_mq_complete_request(req);
>  			req_done = true;
> @@ -1208,6 +1225,9 @@ static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
>  	while ((vbr = virtqueue_get_buf(vq->vq, &len)) != NULL) {
>  		struct request *req = blk_mq_rq_from_pdu(vbr);
>  
> +		/* Check device writable portion length, and fail upon error */
> +		virtblk_vbr_set_err_status_upon_len_err(vbr, req, len);
> +
>  		found++;
>  		if (!blk_mq_complete_request_remote(req) &&
>  		    !blk_mq_add_to_batch(req, iob, virtblk_vbr_status(vbr),
> -- 
> 2.18.1


