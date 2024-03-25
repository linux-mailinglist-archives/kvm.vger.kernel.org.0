Return-Path: <kvm+bounces-12580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC7F88A32B
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:54:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E8361C39B58
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50B015E1FC;
	Mon, 25 Mar 2024 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJJAB3/z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5339415CD7A
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 09:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711357979; cv=none; b=Nl1vEq5ad+bieWI6d3XzLd8ZUmP7PwguOMrMG4Ll3Jzvh9sEPia+Z9GgJQhsZR78AqJ7KMQIpmS5NpBXDbfeGIeuzmVYAFy4Lzca8fICv/x1vhGKFD2KwJsuqBoYT1UV4/t0fSqOZ/RlmNj8xMHKjWE5LVEYOnmTKuDtKwhYLUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711357979; c=relaxed/simple;
	bh=ACMMD4d3P9MVSSLJ/DEMYqlWW6kazp4GcWCNJPcctm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nt3t4rS0a4Z1y9OFCHoiSSS/Fl5g9d/dBytA9beF5oIvS73bWpg4BbooYcD+Ug07TC2WoBWRQHiiC2htD16SiY8LHHCT6TLY2r4oxUVG2cP3PSQWCRoD8QF+nP8GahIe7SqTyysLRO0T1FMkKhpsVa7JZUbDvtx8DVy/motUJrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GJJAB3/z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711357977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1sxJG9Rd8JSB6G8M3v8VO1p5IgxWq/SJrawonCcKSfU=;
	b=GJJAB3/z5ccaD9DJO6hEXmt5aY4yBUyHKmpGWRYMwGBgk33Dtd+6vjUMtKR3F/o7pkFGfI
	03bhoF04z0zsejJDy405KW6ErSBN7MGQDg6WKy09DKqv0J/KCFooCIoIFiunsnWEBHaP1m
	/Oy5WroL2GuiSSde9Ceb5iDCNyLrcF8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-nwi5LrdPMIa01J8rzyeWaw-1; Mon, 25 Mar 2024 05:12:55 -0400
X-MC-Unique: nwi5LrdPMIa01J8rzyeWaw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41413823c1bso24153765e9.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 02:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711357974; x=1711962774;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1sxJG9Rd8JSB6G8M3v8VO1p5IgxWq/SJrawonCcKSfU=;
        b=da8qEHEb3v4sz6hinvyU8gyN7e1A9kg8+95GYP+lsXaJ/SBYHAZr+avMwYQ7e8anw6
         6UVTn45yzTsLyXOvxJ3ABHj1ve5jrK1bWB6KwmfrRp8h3UW+lL4bTLPsIBdeYiv4x3ow
         CSSN/Qtg5Vv8TP7NEjvp5d1rnlx1sQ3Kh7m5WKa2ipi1XP9I86MX1d7Oh0EfA2rONmLn
         xmQb1jlAPH/afADZgJ5845ml9vOLyEtRnAzXgh8svYb5/YYRK2VcG9Y+Ja/CSv0V2a/+
         bWW68v6KyKP9tDjR4k/qxBcM8GxF7Y8pMv+1Dfnfk4PrR55BmJE/oC9alQTmZLeUqz9K
         Gkxg==
X-Forwarded-Encrypted: i=1; AJvYcCXy8cMGxStDPnbfdUtD0DfBAOXWnMKrwYSHYP3U3Yo4192rFTOjiwurvZLTnHpyTGuLlmlixNngxlof5AWEhJhc0mIc
X-Gm-Message-State: AOJu0Yz6HNjCKP9AQMwNzQPaLxe4xdyoQKLRYXy4eTXpSBhJFpuNAbs/
	xdkD3SKMS523zKPF6rryUvYjEdFiCnGRbKArh8vg9swA5wNsLGf1/cf/y1jSf5aleNfXoo4aHun
	LuZ7Q5XSYSnRAtglerwCz+I90Ft8aV7GWtCDpKcyJyBJJKI89bw==
X-Received: by 2002:a05:600c:1c13:b0:414:37f:18dc with SMTP id j19-20020a05600c1c1300b00414037f18dcmr4633361wms.1.1711357973809;
        Mon, 25 Mar 2024 02:12:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGbDxVphxm4LD39Nm0ODG91JF+LM1ahBlILvI0fg8O9MuHA0Av59aSpiVzAeU8+H/e1DLG/A==
X-Received: by 2002:a05:600c:1c13:b0:414:37f:18dc with SMTP id j19-20020a05600c1c1300b00414037f18dcmr4633326wms.1.1711357973418;
        Mon, 25 Mar 2024 02:12:53 -0700 (PDT)
Received: from ?IPV6:2003:cb:c738:b400:6a82:1eac:2b5:8fca? (p200300cbc738b4006a821eac02b58fca.dip0.t-ipconnect.de. [2003:cb:c738:b400:6a82:1eac:2b5:8fca])
        by smtp.gmail.com with ESMTPSA id gw8-20020a05600c850800b004146dd6bfe2sm7745532wmb.47.2024.03.25.02.12.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 02:12:53 -0700 (PDT)
Message-ID: <1b5123f9-6fd8-4783-aec7-5cc5507ee3b4@redhat.com>
Date: Mon, 25 Mar 2024 10:12:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vhost v5 1/6] virtio_balloon: remove the dependence where
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
References: <20240325090419.33677-1-xuanzhuo@linux.alibaba.com>
 <20240325090419.33677-2-xuanzhuo@linux.alibaba.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240325090419.33677-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.03.24 10:04, Xuan Zhuo wrote:
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
>   drivers/virtio/virtio_balloon.c | 46 +++++++++++++--------------------
>   1 file changed, 18 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 1f5b3dd31fcf..8409642e54d7 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -531,49 +531,39 @@ static int init_vqs(struct virtio_balloon *vb)
>   	struct virtqueue *vqs[VIRTIO_BALLOON_VQ_MAX];
>   	vq_callback_t *callbacks[VIRTIO_BALLOON_VQ_MAX];
>   	const char *names[VIRTIO_BALLOON_VQ_MAX];
> -	int err;
> +	int err, nvqs = 0, idx = 0;

Re-reading, you could just use a single variable for both purposes.

Assuming I didn't miss a functional change

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


