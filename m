Return-Path: <kvm+bounces-41375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2B3A66EB7
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 09:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67DA23B25AA
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 08:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9932054F7;
	Tue, 18 Mar 2025 08:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ggciNRoX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7034204C35
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 08:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287382; cv=none; b=u1yqeTRx8WXy/bxh6OeOCSEYt4ZSYKndBqf+RPuWwraVsopZEqqttSfpnblDBZscWpVb6kLcdLqElk35nfypF1Os2rkuzVFtbHlQYh1ar3mAJCcWy2NDv2DK6n4GkWAY5va8K5OW5TRQcsZ6OFfKVAgexaCSLhxP4PeqxUBIrNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287382; c=relaxed/simple;
	bh=aVuqaNznx/5mZdLJC0vjrOwYEAxdll74BF6plXLxd1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTe8qATHdMwzw6NcPLGTgg9iGSo2iEcUEMgnjcfbTvWVE4eJlynGUsRL1ukdxTFeSjMVq/sf0DxLS76e6dMU7vqYTYQ3LYV+0lpPxfQUOkK4xJmYXUa4ratxwV8dW6aQwMzZbUSwBmtgKZAjfA32+lIIvPVH3bR31s9mxkMj1U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ggciNRoX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742287379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6+9EOSMwZ0yperbosZq+EsQ8tvp7eSF9vKmD44NR3ec=;
	b=ggciNRoXh9lb4aSa+u7ArfLUUqz7KSPX7mYxFEhOE+thPR/sgUxj0W/jhO3sejlmO4iHme
	BLBuMYpvDYvgu0s4oIJfHPfLBfo2koI7ZttaCp8MPigUR1ZIRatoBi5m1hb6smpmregrVK
	craizNVKGx39bKp+IFx69DFlI4nCUsc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-Pv3k1JoRNtW0U00TGr9HdQ-1; Tue, 18 Mar 2025 04:42:58 -0400
X-MC-Unique: Pv3k1JoRNtW0U00TGr9HdQ-1
X-Mimecast-MFC-AGG-ID: Pv3k1JoRNtW0U00TGr9HdQ_1742287377
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so18777125e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 01:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742287377; x=1742892177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+9EOSMwZ0yperbosZq+EsQ8tvp7eSF9vKmD44NR3ec=;
        b=dQeTw/rq7OCZESpEPFK8ds03LEaxW5HVh8aF/iLXHJL9rk3rHTQfn3G606kzZH7x06
         bvWOILYiQ0KFZj0OrZpXGNWQg31dBfOFACZb014vlF4PofAN4lqLX4wIAtih8UWvz33I
         0isFZwrvoqj7bq1yhAEvM5/tdY4egvlM+pcMW0z52O32Y9LFe89rCME9ifdMmeijnNc8
         qFWy/uF3qQxooe5vLPiUc8jdV8IIFVEZQfnJnOdrELX1nr6aPC5T++zw5zhldIpQjGua
         gZRjkOGVPxZcAdWf5bkiTzeFYhR387HecL2zmheE72gItA4yOGO2XtM6aHuSO3RhNCMC
         k3Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUdeQ6J2fRwIB/NkuC2Q56aRyl9isl2MDHd3lGAbU0uYMz2gaMMy9dxCi2bi17ELtBD9PU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ9WSa/ONspqGHaNMntpPuSSLL8sWhWEZt0uMXppgQJvVpfTpm
	YnzN3bjZFRMNeDBgpMf8sBT1jAAwvKFpxq7Op37raQ7qd79LpVabrFA1KXybzGgCKd1rBU+6jDV
	bbQZOpq1CL6DvYu74tYGXJLgSrAPoSokpOrelXU9zSgKoDWa+UA==
X-Gm-Gg: ASbGnctAS/j6d++HTsO4ET5eMMAgsVZywCdj5xwYzPgLTFLS3c9a3Wkx1ExunH2D5ms
	JxDmu9/+aVLJzqTlEjzQsGySuXAhxHFAT5XQErucaqDP62XEpfJ6wt7XRQTssDU8E8Zrnavcty/
	ofPYiEPt62RweIj6DBAlf+nIQOlOyYJ2ffyQhp0Vw46KqnmapS0Fwz/NrLkziCT81yCk9OP1SDr
	lqA7niSrzTNSLBO1AzwsAI/AvYRApC4pLp6OSQBPVU1bcO6FGeNQLEiPmznenohMPLVafoD9hGr
	TFe0um3HhEOol22mEWqQFT6hmIFzV4s1ReNnpLyu1l1otA==
X-Received: by 2002:a05:600c:1d84:b0:43d:82c:2b11 with SMTP id 5b1f17b1804b1-43d3b9d2769mr10024315e9.23.1742287376847;
        Tue, 18 Mar 2025 01:42:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHILQIoNqyHItwOTFUtVNmBDSJea3jYt34PUTdt08Ok/vxBredo4KmYrx3e6SVCEbItbB4gdw==
X-Received: by 2002:a05:600c:1d84:b0:43d:82c:2b11 with SMTP id 5b1f17b1804b1-43d3b9d2769mr10023915e9.23.1742287376480;
        Tue, 18 Mar 2025 01:42:56 -0700 (PDT)
Received: from [192.168.88.253] (146-241-10-172.dyn.eolo.it. [146.241.10.172])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1ffb62ccsm128436605e9.7.2025.03.18.01.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 01:42:55 -0700 (PDT)
Message-ID: <cb9294c1-1d3c-4fe0-bf84-63a2fed1e96e@redhat.com>
Date: Tue, 18 Mar 2025 09:42:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 6/9] net: enable driver support for netmem TX
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kselftest@vger.kernel.org
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me,
 asml.silence@gmail.com, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
References: <20250308214045.1160445-1-almasrymina@google.com>
 <20250308214045.1160445-7-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250308214045.1160445-7-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/25 10:40 PM, Mina Almasry wrote:
> diff --git a/Documentation/networking/net_cachelines/net_device.rst b/Documentation/networking/net_cachelines/net_device.rst
> index 6327e689e8a8..8c0334851b45 100644
> --- a/Documentation/networking/net_cachelines/net_device.rst
> +++ b/Documentation/networking/net_cachelines/net_device.rst
> @@ -10,6 +10,7 @@ Type                                Name                        fastpath_tx_acce
>  =================================== =========================== =================== =================== ===================================================================================
>  unsigned_long:32                    priv_flags                  read_mostly                             __dev_queue_xmit(tx)
>  unsigned_long:1                     lltx                        read_mostly                             HARD_TX_LOCK,HARD_TX_TRYLOCK,HARD_TX_UNLOCK(tx)
> +unsigned long:1			    netmem_tx:1;	        read_mostly

Minor nit, but since a rebase is needed... pleas use only spaces to
indent/align the above fields.

Thanks!

Paolo


