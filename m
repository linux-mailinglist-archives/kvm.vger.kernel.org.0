Return-Path: <kvm+bounces-12487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06062886BAD
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:57:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55971B23425
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BFF13FB85;
	Fri, 22 Mar 2024 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYBrsepx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1153F9F9
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711108616; cv=none; b=miIPFFnliwOn9w4s9QFntiWW/UAfvd7aiUk6swr5DH3Mr4gJtUI3WXUdROpYOcmrdIMSyJeq2MhNKD8g8oKn60oVFB65bMGpTGK36gy7yUZsi92DMIR0pn/dEcrrEwT3Z44ueFmpqbAc4Usch0S2m77W7pKG5+7gMWzy3k3VN8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711108616; c=relaxed/simple;
	bh=sulsfC3nRd0LxdfOW1zC16Mdv3AZjGZeArE2KLK+Jrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xl4tgC6Olcwrp9RBnF0EJaNz6T6LZC30H6HRWv1ILOQ9iVEYI2aAsC1fb7G+gr0UCrlLsx5AJs5Pob4XDTfb9h+vSHjktHnPXN3fn2by9tA8nOe1495WuAgTKeiRx1BAcLSRxo0jkVDXRcCwk4lNh6GtlAbH/S+R2wEydeMvDGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYBrsepx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711108613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k8phzhH+bcCAhu8LzPRS+w6MFVuocyKpcgRJTQx5vTg=;
	b=FYBrsepx67G50MfFx02OzqbIy1cArODQXFHVI49Wc/D8bxSv8jpYTCXZ17NJYv8CDX1eoD
	zZ+NcGzJq5tG4NQqDzLMQzDr3q0KRhkhhZ8fthykvzY4ZGS8nEoqHUBma4cYBDneZhFw2a
	1gvHhtHpdJ9O5sIxlcYZBk9Uuy0KNJg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-Imk_odqlMfmefVRprfjtOQ-1; Fri, 22 Mar 2024 07:56:51 -0400
X-MC-Unique: Imk_odqlMfmefVRprfjtOQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5148eaa60acso2185004e87.0
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 04:56:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711108610; x=1711713410;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8phzhH+bcCAhu8LzPRS+w6MFVuocyKpcgRJTQx5vTg=;
        b=R79k/blldMJnn8MJXqjSMSuq35TsDz+6r3O7GFJDXy1i7J0XXADr3tK0d8ftyKCYKk
         9BY7eZcpQ7Sy9/1qIHRA/8bTlL/3CWNf5N7+2EtRZpVx8P7o1qF1oGIUx5Cg1pUGS9xJ
         ltKst3Xken4R2VOKLbktBLPYzrUV1pDqpTOBIvAVAIorcCnRnSVTkZGtrEGwIF22h6X6
         gS6V8zPgpibOPqZKClP+IIChwubAWQzk7TwwXhlHIM5AZRY/aQIFKU4fXQZ5QVwCVvy1
         vhAWG3f1wZhRRgEkuW2+kSmxCnzO9N6qEmMUaZ++eAhSM6WXnDfy2keiRvKZLSL0msMq
         nWLg==
X-Forwarded-Encrypted: i=1; AJvYcCUa0k6kIL0aWbqIb8O63a6P1Ay1gyNr2UTzmVHZ52wF5tDD/iZbLUb2FuxD2pxKwiTA1VhlxT5M1JfIGtlj7YZmk0ya
X-Gm-Message-State: AOJu0YyItuBDrHLG8n0SpzodCfKgcIzTzA/cJo5sLpdCKFDdPfVg4vRE
	EJ3kRGHH3yaR8KByx+2rJswKATufXmHIi5kINIQ5yCdhtO+f3koKuTP6Yao6DfKKOaXsrYhsNzp
	h/4TOu51BQ86osBUE3ztSpbqzNlw9L3lTxC3w9Bf7htc7mainiA==
X-Received: by 2002:a19:2d47:0:b0:513:8102:1a1e with SMTP id t7-20020a192d47000000b0051381021a1emr1519562lft.50.1711108610487;
        Fri, 22 Mar 2024 04:56:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQx6PbBrwZG4C6vyRezVR/JnZxZ2mjcNcbAkSDm5jCYhr8+aNKGnr1n8kbswqbAuJNosOaww==
X-Received: by 2002:a19:2d47:0:b0:513:8102:1a1e with SMTP id t7-20020a192d47000000b0051381021a1emr1519516lft.50.1711108609056;
        Fri, 22 Mar 2024 04:56:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71b:7e00:9339:4017:7111:82d0? (p200300cbc71b7e0093394017711182d0.dip0.t-ipconnect.de. [2003:cb:c71b:7e00:9339:4017:7111:82d0])
        by smtp.gmail.com with ESMTPSA id h11-20020a05600c350b00b0041477e76ec6sm2915008wmq.2.2024.03.22.04.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Mar 2024 04:56:48 -0700 (PDT)
Message-ID: <3620be9c-e288-4ff2-a7be-1fcf806e6e6e@redhat.com>
Date: Fri, 22 Mar 2024 12:56:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v4 1/6] virtio_balloon: remove the dependence where
 names[] is null
Content-Language: en-US
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Hans de Goede <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Vadim Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Cornelia Huck <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, linux-um@lists.infradead.org,
 platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20240321101532.59272-1-xuanzhuo@linux.alibaba.com>
 <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240321101532.59272-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.03.24 11:15, Xuan Zhuo wrote:
> Currently, the init_vqs function within the virtio_balloon driver relies
> on the condition that certain names array entries are null in order to
> skip the initialization of some virtual queues (vqs). This behavior is
> unique to this part of the codebase. In an upcoming commit, we plan to
> eliminate this dependency by removing the function entirely. Therefore,
> with this change, we are ensuring that the virtio_balloon no longer
> depends on the aforementioned function.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_balloon.c | 41 +++++++++++++++------------------
>   1 file changed, 19 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1f5b3dd31fcf..becc12a05407 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -531,49 +531,46 @@ static int init_vqs(struct virtio_balloon *vb)
>   	struct virtqueue *vqs[VIRTIO_BALLOON_VQ_MAX];
>   	vq_callback_t *callbacks[VIRTIO_BALLOON_VQ_MAX];
>   	const char *names[VIRTIO_BALLOON_VQ_MAX];
> -	int err;
> +	int err, nvqs, idx;
>   
> -	/*
> -	 * Inflateq and deflateq are used unconditionally. The names[]
> -	 * will be NULL if the related feature is not enabled, which will
> -	 * cause no allocation for the corresponding virtqueue in find_vqs.
> -	 */
>   	callbacks[VIRTIO_BALLOON_VQ_INFLATE] = balloon_ack;
>   	names[VIRTIO_BALLOON_VQ_INFLATE] = "inflate";
>   	callbacks[VIRTIO_BALLOON_VQ_DEFLATE] = balloon_ack;
>   	names[VIRTIO_BALLOON_VQ_DEFLATE] = "deflate";

I'd remove the static dependencies here completely and do it
consistently:

nvqs = 0;

callbacks[nvqs] = balloon_ack;
names[nvqs++] = "inflate";
callbacks[nvqs] = balloon_ack;
names[nvqs++] = "deflate";


> -	callbacks[VIRTIO_BALLOON_VQ_STATS] = NULL;
> -	names[VIRTIO_BALLOON_VQ_STATS] = NULL;
> -	callbacks[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> -	names[VIRTIO_BALLOON_VQ_FREE_PAGE] = NULL;
> -	names[VIRTIO_BALLOON_VQ_REPORTING] = NULL;
> +
> +	nvqs = VIRTIO_BALLOON_VQ_DEFLATE + 1;
>   
>   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> -		names[VIRTIO_BALLOON_VQ_STATS] = "stats";
> -		callbacks[VIRTIO_BALLOON_VQ_STATS] = stats_request;
> +		names[nvqs] = "stats";
> +		callbacks[nvqs] = stats_request;
> +		++nvqs;

callbacks[nvqs++] = stats_request;

If you prefer to keep it separate, "nvqs++" please.

... same here:

idx = 0;
vb->inflate_vq = vqs[idx++];
vb->deflate_vq = vqs[idx++];

...

>   
>   	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
>   	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> +
> +	idx = VIRTIO_BALLOON_VQ_DEFLATE + 1;
> +
>   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
>   		struct scatterlist sg;
>   		unsigned int num_stats;
> -		vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];
> +		vb->stats_vq = vqs[idx++];
>   
>   		/*
>   		 * Prime this virtqueue with one buffer so the hypervisor can
> @@ -593,10 +590,10 @@ static int init_vqs(struct virtio_balloon *vb)
>   	}
>   
>   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> -		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
> +		vb->free_page_vq = vqs[idx++];
>   
>   	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> -		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
> +		vb->reporting_vq = vqs[idx++];
>   

Apart from that LGTM

-- 
Cheers,

David / dhildenb


