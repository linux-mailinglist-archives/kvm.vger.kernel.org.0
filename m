Return-Path: <kvm+bounces-24923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A6D495D068
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 16:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F43B1F22D22
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 14:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E326188918;
	Fri, 23 Aug 2024 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="JresqEmc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD541885AB
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424689; cv=none; b=mqySwH3n9wYCUPkLL4sQD4tgFZXU8PHlFlnxehnA+Z/HCVt1EyhWxKSG52rMrkr22qiHTxK88RB6Vy8ntE57qrlTjugGw9I9ce7+aN4CUj6jED/6yaximrXEy7CpT4vxs6APUJJuzg9AKjE9uzXPvOWezgQL5QtY02h7YRKlA2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424689; c=relaxed/simple;
	bh=b4C+Oy37DV2Kzj7Jrf0dTC698njLjd23JNwPJG1/FcU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=fW4vSJBoZF3LDkREASkopishJAtAl0pxojYiDsNKQcwkdtoZpnS4b6PyLcmh8KkTUO6V71/BByUFvgFX+0dF38V2gM7od2JEG/CGyOmQFMnywqqLfhI1eR6Y5Kfo9iNthHyBR3sYjYY9C1/bRHtHW10vPOgzzu1Rq4iSQbyp0rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=JresqEmc; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e116a5c3922so2027655276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724424687; x=1725029487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b4C+Oy37DV2Kzj7Jrf0dTC698njLjd23JNwPJG1/FcU=;
        b=JresqEmchm4QsXu/uyAZnt1107TGahPZDwlpVIfE/KV+eifVwEf5tOJ+0/Fm90ncEx
         vpbFABNXjFN0A2sRpDkqymTkGccw7Cs7f9ai34NBnaJXtC6n1uHjT9vdoHFIcEkpGVJV
         CnUsjWycyOffaA+2uhL0NAvA8nhO3aUrncIpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424687; x=1725029487;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4C+Oy37DV2Kzj7Jrf0dTC698njLjd23JNwPJG1/FcU=;
        b=lfP/GZRodt5BWNz4Mo65RxqVLpJH+DA5d5iUipQFyiy6dtz2Q8hR0R8oRTm+FK8tAw
         lWSNiY9lQWNUWmfJL9Rsa9zbEIHpko9InA1t/BbxOqDBcLedYb8Es4v19RguwA0cJU+L
         4c5JbP8Io/bY1VyiNf2UOe9lr44ghIepQwCpvimfDAn0G8upTywJNSoYB1ZlPRP3Gqc2
         uxlFseMj9pAgIm66rKjsyeKenLUGouTxxqgcTlqTpSc9PdkOIsUJ5NblOblb2B1SHB7n
         WPePVo+21LNUA8NfrLKGUzhkcEUv/xDHxw5DHIihCWvQdw8nnDSs2/UpSEbT/1Bf5SRV
         9KQw==
X-Gm-Message-State: AOJu0YyecytguS9Upb6cmTX45KFUnQFboPS6H/fVQWbl9+HfVqpQsq1R
	A6TZTwA2A4+vMTJPKx5U2oOx006PKZ5z8BZGPmCXJzlemrTJZ10CRNeRlaxk4sk=
X-Google-Smtp-Source: AGHT+IG6JLoQwXGBZb5kz/05HTW1+oRlGRg0Y8dCBjJ8Cxj2vuoaOWbYxxL+QDFhLPXt07y77oLlWw==
X-Received: by 2002:a05:6902:1109:b0:e16:6b7e:94b5 with SMTP id 3f1490d57ef6-e17a86a517emr3398358276.48.1724424686570;
        Fri, 23 Aug 2024 07:51:26 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:45f:f211:3a7c:9377? ([2603:8080:7400:36da:45f:f211:3a7c:9377])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e178e46361csm707782276.19.2024.08.23.07.51.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 07:51:26 -0700 (PDT)
Message-ID: <e7ba91a7-2ba6-4532-a59a-03c2023309c6@digitalocean.com>
Date: Fri, 23 Aug 2024 09:51:24 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] vDPA: Trying to make sense of config data
From: Carlos Bilbao <cbilbao@digitalocean.com>
To: virtualization@lists.linux-foundation.org, mst@redhat.com,
 jasowang@redhat.com
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4f4572c8-1d8c-4ec6-96a1-fb74848475af@digitalocean.com>
Content-Language: en-US
In-Reply-To: <4f4572c8-1d8c-4ec6-96a1-fb74848475af@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello again, 

Answering my own question:

https://elixir.bootlin.com/linux/v6.10.2/source/include/uapi/linux/virtio_net.h#L92

Thanks, Carlos

On 8/22/24 1:21 PM, Carlos Bilbao wrote:
> Hello folks,
>
> I'm using the code below to retrieve configuration data for my vDPA file
> via ioctl. I get as output:
>
> Configuration data (24 bytes):
> 5a c3 5f 68 48 a9 01 00 08 00 dc 05 00 00 00 00
> 00 00 00 00 00 00 00 00
> ASCII representation:
> Z._hH...................
>
> Could a good Samaritan point me in the right direction for the docs I need
> to understand these values and convert them to a human-readable format?
> hank you in advance!
>
> Regards,
> Carlos
>
> ---
>
> void check_config(int fd) {
>
>     uint32_t size;
>     struct vhost_vdpa_config *config;
>     uint8_t *buf;
>
>     if (ioctl(fd, VHOST_VDPA_GET_CONFIG_SIZE, &size) < 0) {
>         perror("ioctl failed");
>         return;
>     }
>
>     config = malloc(sizeof(struct vhost_vdpa_config) + size);
>     if (!config) {
>         perror("malloc failed");
>         return;
>     }
>
>     memset(config, 0, sizeof(struct vhost_vdpa_config) + size);
>     config->len = size;
>     config->off = 0;
>
>     buf = config->buf;
>
>     if (ioctl(fd, VHOST_VDPA_GET_CONFIG, config) < 0) {
>         perror("ioctl failed");
>     } else {
>         printf("Configuration data (%u bytes):\n", size);
>
>         /* Print the data in a human-readable format */
>         for (unsigned int i = 0; i < size; i++) {
>             if (i % 16 == 0 && i != 0) printf("\n");
>             printf("%02x ", buf[i]);
>         }
>         printf("\n");
>
>         printf("ASCII representation:\n");
>         for (unsigned int i = 0; i < size; i++) {
>             if (buf[i] >= 32 && buf[i] <= 126) {
>                 printf("%c", buf[i]);
>             } else {
>                 printf(".");
>             }
>         }
>         printf("\n");
>     }
>
>     free(config);
> }

