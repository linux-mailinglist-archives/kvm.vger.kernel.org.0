Return-Path: <kvm+bounces-41376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B916A66F12
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 09:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF3FC1620BE
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 08:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E144205AA5;
	Tue, 18 Mar 2025 08:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cheHwdgJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181A7204C2A
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287987; cv=none; b=qaTzGkD5zQllQXgWqATym3JePtNwgHW8eeKQD7LZx9ak8L0y9770HfzmVDE7e1Cov/SHYoQv41wGGQmEDi+clyPXnutc/32I9/cfcGrw5IEpieOQtQTAQP3L/OdkdLxddLEVlAlDDXAf8WQaomQNJ+IoKehi6WTZizdNI88/z8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287987; c=relaxed/simple;
	bh=nBqnAgBHS2l95Pjj/TfnmDtdp5MvYiOaOhdplM2mhmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t+Yo6PjgytAbiCwHhiTyD+J8MrAvhXuoRR3ZPxWqim+03rCriranFuXi7xxRazmpEJjk2B0/SkOvWlotlmvVEXJP68VF3VS77EZjiJWjL9BZfeSAXdy/1CkfXH3KbrYpnE0QTfHY7BX2dY6oyphtuX9ZIpX0AmSWby8XWyVPtjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cheHwdgJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742287985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tObLTe69QFxvzolejx3T+2gunDSqNceNELAPgsdaeHE=;
	b=cheHwdgJ54e2fxde1jpn1MRCNp96Depd5I7bBOWwpNMa0G7a+wpdQpD8zSVwjccrGTUurG
	OGBVS/isoQ2NWGg4QCxUnGnUkYnGfOAl2GMrgBgVQsaW4fDZxqpRv7/Yf5BaYrGl31S0Z/
	X6VyPhtAg7kWIhY8mF6yRippRC1UG3A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-2zRoy-f9PVGFzXwtuhlO6A-1; Tue, 18 Mar 2025 04:53:03 -0400
X-MC-Unique: 2zRoy-f9PVGFzXwtuhlO6A-1
X-Mimecast-MFC-AGG-ID: 2zRoy-f9PVGFzXwtuhlO6A_1742287983
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so18552145e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 01:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742287982; x=1742892782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tObLTe69QFxvzolejx3T+2gunDSqNceNELAPgsdaeHE=;
        b=tD0q0brUU86wJtSPIOLw6bgKvWYJSpkT3zqp9Z7shX23QN5X7q4nHEjlUQVHY2PBnY
         uFGHh+78Gi1GQEMeTgrZyoaGKDuC8zxMfGGetRSBwh1QT/Xz1h+yffUXW0z9iDhMCOo0
         kqVLsqfGrJQ6oUnHgpQvTPMcT26tE5vEcFaDj5VcAr06AYG5KsRHySu110h3WO9Gnn3g
         Q2PViEICvUYdjCXhgC6zqC+Kv9VGqPbOlK+cBAlVRpAmViT69zHr64tAelXVlcqTGGne
         lB3STcIp+PqUwwxa2nMq0ekbq/XrzPcE9qgvvAeJPNVte/yVwQfbO+fkAmZsxt4smKjE
         CScQ==
X-Forwarded-Encrypted: i=1; AJvYcCV165s0cZAFvU1vPJqrYfV+LoHn5cQjQCTK3p1kTxZDnChFhAVw4PSXWkKAf0BdpwaR7HY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyExL/0S/Qge2v4aBolzmARCbZUSGH/DFC+kI9zERkMlssYhekd
	vAzVwNg7RZ1gslXmPDYOsgifHWNbEuZtLMAcVy9qk0SYaW+S271OoQGe2tTc967FOsy3RD4qg2a
	KrbaLhw6/ZH24RM2UaJxVZQgJ66gVJ51tnU+uCcu/fIx81ZyU9A==
X-Gm-Gg: ASbGncsQMYYophZz4N19N4QEmCxWVZyWT1H09e9Ilj/RD2CRsBsqMmaHKmvWaPijwmx
	2pLJM86OWpdi1mJ9kMPKkIZAGbHAR+Ef3RBw+OfqXf2Ic9U5m95+9TKCrDPGktyX9nMjXH1msDB
	9oj/1EvxlTNxS+a7jc1WWJdjYqyTzYo3FFS/y985t0Pit5kimrpy90PJWPKc2fXVNZeiB0bwB93
	ikqAEB9G+e8qCGBT6m4TcBEtvcXOPmS0ZKLG7gSgQcgVt1enxIBPJJlyo9fBuFEazC93KxTfrYU
	3SYIyg1WHcGRWTSM+DJ6dcleTUEhJF7+S2NL0Pda8xWaEQ==
X-Received: by 2002:a05:600c:1910:b0:43b:cc3c:60bc with SMTP id 5b1f17b1804b1-43d3b98e784mr10214155e9.15.1742287982454;
        Tue, 18 Mar 2025 01:53:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLxkKyNtE11z59H06IZJtl8h4j7bAu1UH3i6QG52S1C4EP04HZjwsPQi3k1NceSqvEw/VDKQ==
X-Received: by 2002:a05:600c:1910:b0:43b:cc3c:60bc with SMTP id 5b1f17b1804b1-43d3b98e784mr10213835e9.15.1742287982025;
        Tue, 18 Mar 2025 01:53:02 -0700 (PDT)
Received: from [192.168.88.253] (146-241-10-172.dyn.eolo.it. [146.241.10.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975d65sm17738818f8f.56.2025.03.18.01.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 01:53:01 -0700 (PDT)
Message-ID: <5de5943b-5527-49f6-a454-b3c7358cff56@redhat.com>
Date: Tue, 18 Mar 2025 09:52:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 4/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-kselftest@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>
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
References: <20250308214045.1160445-1-almasrymina@google.com>
 <20250308214045.1160445-5-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250308214045.1160445-5-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Adding Kuniyuki.

On 3/8/25 10:40 PM, Mina Almasry wrote:
> @@ -931,10 +932,67 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
>  	return err;
>  }
>  
> -/* stub */
>  int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
>  {
> -	return 0;
> +	struct net_devmem_dmabuf_binding *binding;
> +	struct list_head *sock_binding_list;
> +	struct net_device *netdev;
> +	u32 ifindex, dmabuf_fd;
> +	struct sk_buff *rsp;
> +	int err = 0;
> +	void *hdr;
> +
> +	if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_DEV_IFINDEX) ||
> +	    GENL_REQ_ATTR_CHECK(info, NETDEV_A_DMABUF_FD))
> +		return -EINVAL;
> +
> +	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
> +	dmabuf_fd = nla_get_u32(info->attrs[NETDEV_A_DMABUF_FD]);
> +
> +	sock_binding_list = genl_sk_priv_get(&netdev_nl_family,
> +					     NETLINK_CB(skb).sk);
> +	if (IS_ERR(sock_binding_list))
> +		return PTR_ERR(sock_binding_list);
> +
> +	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!rsp)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_iput(rsp, info);
> +	if (!hdr) {
> +		err = -EMSGSIZE;
> +		goto err_genlmsg_free;
> +	}
> +
> +	rtnl_lock();

The above could possibly be a rtnl_net_lock(), right?

(not strictily related to this series) The same for the existing
rtnl_lock() call in netdev-genl.c, right?

/P


