Return-Path: <kvm+bounces-39107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1B7EA44021
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D95B188A137
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 13:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4776A2690EC;
	Tue, 25 Feb 2025 13:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaTud2c5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDF9268FE9
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 13:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740488689; cv=none; b=awDiVOI8BQXEr83vwR2Hr1DpRQFXe6z0rFT291mHrHXStJK0tVYRdxoWATeku8lwv5LaBwvn7zothhUQA53YO8I1HhkNEW1etCWPdDUbZ51+cJH8RIVfc1fIPK6JFOF3wdMsDflXntZ+cwUk7rknv7C4tvc7gPqCRCX+DVWIYGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740488689; c=relaxed/simple;
	bh=PoqjAs48+8ee6d8AS/JvwD5Eq5M+o52O3KMWUPpMR28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RkWS9jAU/6mD5KE+IqZ2pgn8S8Mh5BIgY3spl4iAsydDdf2GWI0Lj+5RQLYDsO/pc4m1GBK68V+mSs4YGlaYBh4tDQQl2j2BkC5inXnrmwZaothSWXkINskpr+zxtubd1oU1xchmrkKJCpoaQKDeiWDQkqbdP8lzMEEINOLibqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GaTud2c5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740488686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NEjZiA0tpgBSlB/iySqtUo2D0VDFNUAgdeGczXOHVDE=;
	b=GaTud2c5HIHMmftprbtdT0xJ1fLU8YLuxXPXiJ8M2CRN67uJmbnS71Dry9JNNpBuaG7cgF
	+Y10xwcG+sEt9MOjD44Rs12RQcfGcFAgmMjnsuOmJg2K6ohhJO3hyFiLCP5DwoNMGUqxSK
	RVpFYfMW81yJSF7ttDSWbS5eb4TSsK4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-Q_arqqpBP9Oii06nqHkcSQ-1; Tue, 25 Feb 2025 08:04:45 -0500
X-MC-Unique: Q_arqqpBP9Oii06nqHkcSQ-1
X-Mimecast-MFC-AGG-ID: Q_arqqpBP9Oii06nqHkcSQ_1740488684
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38f51a3a833so2210179f8f.2
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 05:04:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740488684; x=1741093484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEjZiA0tpgBSlB/iySqtUo2D0VDFNUAgdeGczXOHVDE=;
        b=ehEr8+tlR+RgNWF8eC+A6xiR+kE7Vt4DYke6PgcYDfEOtp+hVnjy5mlPw7ojm/UGKa
         TxOniINaavEKxVr7V8eO0UfJ2OeHYUIRry8Q6OgeiFjESCh/i9OGv9uR4WjCaPWHKx3X
         ov60IudEioZMiTOUUxlfvUH98fFA19qTdWW+MWIDxJUls4XwM8/c44ZXl5myDD1KOfiK
         s0ZC42L6upjRUI+BeiakKypSw8ensaDNw1X2l+6XpJwg2kJ9MDjpZTOnW/W/jl+2h2ns
         CjW+X1JFjmDido/wmIIlHPSwZPf+1IW08d9dc2FDBAgCem04B3GZFrCucZd/jQ2DvaGc
         QG2w==
X-Forwarded-Encrypted: i=1; AJvYcCUm7I1x0dbQQZ6qMzQwx5NnrIuMrox24RNYAlrTFGPWbSZVfKoSUeXXmUFGAwojHJHqeUc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7wgH7ktJq0F3zHDZXDe4nDwJ76mtZW4hkxdL93W6rN6+XT8Iz
	DklNe5fwTLq7IEm9ajkXbEbuUX1ZbY//xjvkVVtRLCttPwF01IAU769rq7WCZhaKKrh6KckHmI8
	lQ0/9yOmqp541f0K5HtMi/AjfHVptTmgXUTwGyMQ4FKHbV5MV3A==
X-Gm-Gg: ASbGncsORxQuL6NQHdYyAENXsPRjJuuGGdqXNOU7a4avhKKFBQ50cgFiQG64aN1jBbS
	SN5+RUl+HUWYwVA2BiVLLQ8qdA3As7grdmrQ4lOi3APHWlW5R6iGqxGXRAmCT57iaqPzwWQM313
	E3+K7sRaBtXq41milz51h75Tpmhl9/3VT6zpdBvBBT2SXoR4NYUEWk6aSaa7pHhCsAHBPKJu31o
	6SJN9ghSWAp6EQBvk/PIIlIY/XTC9N+AEd678Bgh4xHP1WbEBQzo2hRpB5igrwEiL5vlq4kuhSn
	5mhsnI6evSGAzLz5SR8wFirH+gl1P1Z7RN1R1EfciGU=
X-Received: by 2002:a05:6000:1a87:b0:38f:3344:361e with SMTP id ffacd0b85a97d-38f7079ec17mr15303948f8f.23.1740488684039;
        Tue, 25 Feb 2025 05:04:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzXYHaIMYF6GMizRa4fNCOG8+4IpljILlUq8KxSNpA12i9exQXViaMTl+bM5c0ACpAig5+BQ==
X-Received: by 2002:a05:6000:1a87:b0:38f:3344:361e with SMTP id ffacd0b85a97d-38f7079ec17mr15303910f8f.23.1740488683687;
        Tue, 25 Feb 2025 05:04:43 -0800 (PST)
Received: from [192.168.88.253] (146-241-59-53.dyn.eolo.it. [146.241.59.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab37403cfsm15578055e9.1.2025.02.25.05.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:04:43 -0800 (PST)
Message-ID: <a814c41a-40f9-4632-a5bb-ad3da5911fb6@redhat.com>
Date: Tue, 25 Feb 2025 14:04:40 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v5 3/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
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
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>,
 Kaiyuan Zhang <kaiyuanz@google.com>
References: <20250222191517.743530-1-almasrymina@google.com>
 <20250222191517.743530-4-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250222191517.743530-4-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/22/25 8:15 PM, Mina Almasry wrote:
[...]
> @@ -119,6 +122,13 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>  	unsigned long xa_idx;
>  	unsigned int rxq_idx;
>  
> +	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
> +
> +	/* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
> +	 * erase.
> +	 */
> +	synchronize_net();

Is the above statement always true? can the dmabuf being stuck in some
qdisc? or even some local socket due to redirect?

> @@ -252,13 +261,23 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  	 * binding can be much more flexible than that. We may be able to
>  	 * allocate MTU sized chunks here. Leave that for future work...
>  	 */
> -	binding->chunk_pool =
> -		gen_pool_create(PAGE_SHIFT, dev_to_node(&dev->dev));
> +	binding->chunk_pool = gen_pool_create(PAGE_SHIFT,
> +					      dev_to_node(&dev->dev));
>  	if (!binding->chunk_pool) {
>  		err = -ENOMEM;
>  		goto err_unmap;
>  	}
>  
> +	if (direction == DMA_TO_DEVICE) {
> +		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
> +						 sizeof(struct net_iov *),
> +						 GFP_KERNEL);
> +		if (!binding->tx_vec) {
> +			err = -ENOMEM;
> +			goto err_free_chunks;

Possibly my comment on v3 has been lost:

"""
It looks like the later error paths (in the for_each_sgtable_dma_sg()
loop) could happen even for 'direction == DMA_TO_DEVICE', so I guess an
additional error label is needed to clean tx_vec on such paths.
"""

[...]
> @@ -1071,6 +1072,16 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  
>  	flags = msg->msg_flags;
>  
> +	sockc = (struct sockcm_cookie){ .tsflags = READ_ONCE(sk->sk_tsflags),
> +					.dmabuf_id = 0 };
> +	if (msg->msg_controllen) {
> +		err = sock_cmsg_send(sk, msg, &sockc);
> +		if (unlikely(err)) {
> +			err = -EINVAL;
> +			goto out_err;
> +		}
> +	}

I'm unsure how much that would be a problem, but it looks like that
unblocking sendmsg(MSG_FASTOPEN) with bad msg argument will start to
fail on top of this patch, while they should be successful (EINPROGRESS)
before.

/P


