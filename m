Return-Path: <kvm+bounces-12985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3BF288F9E1
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E126289C06
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479AA42A8B;
	Thu, 28 Mar 2024 08:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LR7fCMkz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1633B42A88
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 08:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613751; cv=none; b=QXx3gNDhX7Ou7TfrNaid6ctsKPqSZGJ7p4iEagtYV/xEw/F/+uLpBxTJ9kyCURNmVLqCWmnUa6j3AYt+LPl0LGmwVtUNd64d6rU1GsUYEgP1gw3M6rjE8GWw3a0j4pddvz4zPMSTRzvnd41dOAG+NzDeDIuSoUOCI8BxuTbL01I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613751; c=relaxed/simple;
	bh=AEHEjkDnCHHUxB0G77hRCttazDS5YP2phnhrwEJqMM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aHME5fQ57XlSyNXN5SwV1zVhyftoz0A/KzukuVKwEFYH2XbTU1fK4NguM5dnPnSogNM1iG9GmshWVwXWW0wRZaslnryROhIp+G2mkAh/XZjD1cmdNWISRWnGs+Gr+RH8B7RNWxDlfKJJBnHxxH0fYAyBaBXULoM40WBKhZUg0FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LR7fCMkz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711613749;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zjUADkxK7W8MqHSaaLff78AqyJRHwq7pquaV+zZOTUA=;
	b=LR7fCMkz5IfEk6B9SFWIsRlsTbv21GkbArFiXiQPgeNJlj+zfToxGkkqhvJt/Jyf31Ur5D
	Avf+HCR3fZty530hjeMKEY6x9kxoCk1PCc3hfol2Z03xnf5HaQ+PJB4vtXLJ4oykKGpo5V
	waUYdmBRcAvwdWFQAQ6JHiWDW/2uEao=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-0VcHHiyIMz-P2lcYGnXGtg-1; Thu, 28 Mar 2024 04:15:47 -0400
X-MC-Unique: 0VcHHiyIMz-P2lcYGnXGtg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4148c035ab6so3447495e9.1
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 01:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711613746; x=1712218546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zjUADkxK7W8MqHSaaLff78AqyJRHwq7pquaV+zZOTUA=;
        b=wgghzVuxDqB+N47l9ANsRtF1fTwymC/rMz5GzjCEdfZ5zArJ1AGE/TiEn54Xi1vuE/
         TMTJB9gSoPE+EhaT4Zt8Mb5eonDlJynBn6e61Y8V96UH/TSOUBv1ekTpZlR07mD1fDTZ
         cd5rlIwXNnT8YCDzwuGSICDQd9vesP8JmhPXShOn3ZJ3spGEaXuzFdzghZVw1yd/2X8k
         5L8A39EqpYTQKU/g8Y9NPX+CHa2GtUPoaHshTtYMEs4WBmx1vR7FtmN35e9jBNjN3eGB
         O0xxEMweQcDUFrYZSyayfc692J5eUz2/iw0mfZhT+3hfzTwMeLLYGYw2OVgUkg6jAX1W
         U8iQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6dzYQls5K1VjUrEvW3xGZVE0CrEH7q9tKAOG+YEeAf29E/SnPO7bue5zgJ93JmQnFHZrsskvCpyr/2UcpuOoPnQG7
X-Gm-Message-State: AOJu0YxFApbz/9xfkEhFJg/XLM46OWOgQ/i3/DLwioPQicKEmCDTzHee
	Vvzmrqot6os96+ALi6AopV6I53FA66ra78ah4CG/F18LH/xC8/sVZ/6UvGGBQlk9qes4Hby8Lym
	JeZBoYIgNdeWGv4vHz7YEBukB4oQtOcaR1bvOfD1vQHvk0XeJ8w==
X-Received: by 2002:a05:600c:468a:b0:414:c42:e114 with SMTP id p10-20020a05600c468a00b004140c42e114mr1687521wmo.39.1711613746204;
        Thu, 28 Mar 2024 01:15:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8MDeRM7xS3BA3duuFbIO3KAqdPRdzqESI90M9Ta6qWW4GGp1Je55w6TxUEAK7EYkUeNt2Cw==
X-Received: by 2002:a05:600c:468a:b0:414:c42:e114 with SMTP id p10-20020a05600c468a00b004140c42e114mr1687496wmo.39.1711613745872;
        Thu, 28 Mar 2024 01:15:45 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s21-20020a05600c45d500b0041487f70d9fsm4599444wmo.21.2024.03.28.01.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 01:15:44 -0700 (PDT)
Message-ID: <66fd044e-37a8-4f03-a19a-fcd754bdcc40@redhat.com>
Date: Thu, 28 Mar 2024 09:15:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 19/19] vfio: amba: drop owner assignment
Content-Language: en-US
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Russell King <linux@armlinux.org.uk>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Mike Leach
 <mike.leach@linaro.org>, James Clark <james.clark@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Linus Walleij <linus.walleij@linaro.org>, Andi Shyti
 <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Michal Simek <michal.simek@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-input@vger.kernel.org, kvm@vger.kernel.org
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
 <20240326-module-owner-amba-v1-19-4517b091385b@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240326-module-owner-amba-v1-19-4517b091385b@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/26/24 21:23, Krzysztof Kozlowski wrote:
> Amba bus core already sets owner, so driver does not need to.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>
> ---
>
> Depends on first amba patch.
> ---
>  drivers/vfio/platform/vfio_amba.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 485c6f9161a9..ff8ff8480968 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -134,7 +134,6 @@ static struct amba_driver vfio_amba_driver = {
>  	.id_table = vfio_amba_ids,
>  	.drv = {
>  		.name = "vfio-amba",
> -		.owner = THIS_MODULE,
>  	},
>  	.driver_managed_dma = true,
>  };
>
>

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric


