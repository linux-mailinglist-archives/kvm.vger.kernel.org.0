Return-Path: <kvm+bounces-38160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6603DA35D5D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9B1188D6DB
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3A48263F41;
	Fri, 14 Feb 2025 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7N/9TGo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CF5263C65
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 12:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739535454; cv=none; b=qz3cyNivjy6lcv/GBCLOvyvTOZmiWIlgmXurZm9iDLHIDrUp/oaKk2Ms+/8DJxNeOIIEMvv/6CflYR+ElQT2bnhIUWKuhSnB+ITto+x5hNX3ZbI1PlZgR/GKWl0jL2TlzCWVXKfglDROiPOPo5lr5vuntWnVi3YnKVo7H3KGxiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739535454; c=relaxed/simple;
	bh=508bg14U3UMJ8jdr3pX2AL6akRM/QyTn1EwYOGL0phw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clpOlMvOjjMB+ddGNyTh87l8f/kn2RMvhhwzqoKIf4NJbo/ShDchTyUzqq28ZL+FzkAvibbCQlQN1dA0UfBOBT3yJvLiHOeiemH6FCE7HHGYoJoUopquG1kkOgzID+ta45WIFtrJlbRgfpzn6Aybn3YY2fwpzI9AkISWhImEgp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J7N/9TGo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739535451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BZijvutShOwbMhwLPMjJwb8XWzeFIQw45xdK6ukivSY=;
	b=J7N/9TGovXCge1ko/0xLQVccvL2XxhtJ1uUVxvQ7FI/oWVJLZfO4MnOjNNP119rIdfgkDD
	TLI7Iw5ExEyybxgy8YFlNCSAILmlzeXbpXRSwVAfp62eNNFpLfOK1bti6p//jUC2jlj5Yq
	SDxdcjnhaEDUyuK7YVdZKDLBM/wLhQw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-mn4ozv40PTaKV_NQUnO63A-1; Fri, 14 Feb 2025 07:17:29 -0500
X-MC-Unique: mn4ozv40PTaKV_NQUnO63A-1
X-Mimecast-MFC-AGG-ID: mn4ozv40PTaKV_NQUnO63A_1739535449
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ab7fa2b5be0so245703566b.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 04:17:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739535448; x=1740140248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZijvutShOwbMhwLPMjJwb8XWzeFIQw45xdK6ukivSY=;
        b=nBQR4EjodHayUltx8ly2jS9u6UGjCFFDqvbZNDyIzSPFSJyT4JauQqfod4BZp3rBhZ
         hBsfbWTf0MFyfpwfSrzVdr4uEQ9SXWBPljiZnPq4qS7ftpF83YkXUVOTlzlquFUfPxOT
         IDmcGe57TPuySJHtucH48GFW3qCB9iCgRYyegJJxrSTz+1m9cpYIQNDkLIaNFkApcqxJ
         2xNg5BYDgek7eYTk7GBuySzW0XYtIYmCpt3e93WP9AovP9LLTJkx6fjyHUe2RX1qTd4R
         k+EOikOa+od/ESVCM9+JZSM7RZS1aLMbhOtTw7bUm/gof6usTPYVen1xL+X5IP7AE6OT
         Z9dA==
X-Forwarded-Encrypted: i=1; AJvYcCXUn52u1Duab2U7jMo3WNnOumofdPRxdDKty/x0D2XQZObbqFH6nUPuCXzLflK0VaYqpLU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2qCEWGq+fsypp2I4T7b0VJPb4VTk0D4/AZDRV5oL4Pt5qGK70
	KPTT0Ese8Xwn/TJ1EYz1U1MNSUAIkRNVJn9IDIN9h/y8IyhHmCA41iGrljOD7L1/0E0uIQ9znL0
	GyNmJx9uSX1y07dhogradT0UDRwlDipQ8VqnApUKvR/K41qVQQA==
X-Gm-Gg: ASbGncsHavepXzaoNqaYo/sn7Cn8z8Bvh4hXwEqZbB5NgWI7Qhq7ZbuLE1gt/Xxg+p3
	LZiGCBqoXFr4UHDlxzHIFDpiNXO1y572nHpt/GbDscEQY0WWlIJCUzzGmAZVjbxu4MLiK9eYR5C
	8nzDBe0nhGslN5cO0S6Bte3veCvYVcK9LUjXBERJASW1YbRcJCkoltu8UahFcZWQZrhanrQVJ7Q
	GAiChGE5bJaVI3E5A1PetgWRMYqkpiMLuwBC6sOk7QkIZVNg8yOcsEvOPd7ubtquB/n7w==
X-Received: by 2002:a17:907:3fa2:b0:ab7:5b58:f467 with SMTP id a640c23a62f3a-ab7f347aa6cmr1198347766b.40.1739535448550;
        Fri, 14 Feb 2025 04:17:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGPf+AeSUeRn24l529Z9ZendqwqQDqP06Hke8qwzwFNKUt9IcGq+7DW+H44R0X87YfMunCk/g==
X-Received: by 2002:a17:907:3fa2:b0:ab7:5b58:f467 with SMTP id a640c23a62f3a-ab7f347aa6cmr1198344266b.40.1739535448190;
        Fri, 14 Feb 2025 04:17:28 -0800 (PST)
Received: from redhat.com ([2.55.187.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5323226asm334107966b.8.2025.02.14.04.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 04:17:26 -0800 (PST)
Date: Fri, 14 Feb 2025 07:17:22 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
	eperezma@redhat.com, horms@kernel.org, jasowang@redhat.com,
	kuba@kernel.org, kvm@vger.kernel.org, lei19.wang@samsung.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com,
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
	ying01.gao@samsung.com, ying123.xu@samsung.com
Subject: Re: [Patch net v3] vsock/virtio: fix variables initialization during
 resuming
Message-ID: <20250214071714-mutt-send-email-mst@kernel.org>
References: <CAGxU2F7PKH34N7Jd5d=STCAybJi-DDTB-XGiXSAS9BBvGVN4GA@mail.gmail.com>
 <CGME20250214012219epcas5p2840feb4b4539929f37c171375e2f646b@epcas5p2.samsung.com>
 <20250214012200.1883896-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214012200.1883896-1-junnan01.wu@samsung.com>

On Fri, Feb 14, 2025 at 09:22:00AM +0800, Junnan Wu wrote:
> When executing suspend to ram twice in a row,
> the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
> Then after virtqueue_get_buf and `rx_buf_nr` decreased
> in function virtio_transport_rx_work,
> the condition to fill rx buffer
> (rx_buf_nr < rx_buf_max_nr / 2) will never be met.
> 
> It is because that `rx_buf_nr` and `rx_buf_max_nr`
> are initialized only in virtio_vsock_probe(),
> but they should be reset whenever virtqueues are recreated,
> like after a suspend/resume.
> 
> Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
> virtio_vsock_vqs_init(), so we are sure that they are properly
> initialized, every time we initialize the virtqueues, either when we
> load the driver or after a suspend/resume.
> 
> To prevent erroneous atomic load operations on the `queued_replies`
> in the virtio_transport_send_pkt_work() function
> which may disrupt the scheduling of vsock->rx_work
> when transmitting reply-required socket packets,
> this atomic variable must undergo synchronized initialization
> alongside the preceding two variables after a suspend/resume.
> 
> Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
> Link: https://lore.kernel.org/virtualization/20250207052033.2222629-1-junnan01.wu@samsung.com/
> Co-developed-by: Ying Gao <ying01.gao@samsung.com>
> Signed-off-by: Ying Gao <ying01.gao@samsung.com>
> Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  net/vmw_vsock/virtio_transport.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index b58c3818f284..f0e48e6911fc 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>  	};
>  	int ret;
>  
> +	mutex_lock(&vsock->rx_lock);
> +	vsock->rx_buf_nr = 0;
> +	vsock->rx_buf_max_nr = 0;
> +	mutex_unlock(&vsock->rx_lock);
> +
> +	atomic_set(&vsock->queued_replies, 0);
> +
>  	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
>  	if (ret < 0)
>  		return ret;
> @@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  
>  	vsock->vdev = vdev;
>  
> -	vsock->rx_buf_nr = 0;
> -	vsock->rx_buf_max_nr = 0;
> -	atomic_set(&vsock->queued_replies, 0);
>  
>  	mutex_init(&vsock->tx_lock);
>  	mutex_init(&vsock->rx_lock);
> -- 
> 2.34.1


