Return-Path: <kvm+bounces-41374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D08B1A66E9B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 09:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7390A18988F4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 08:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E824A204C34;
	Tue, 18 Mar 2025 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fj/Y5uSO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BB31F8758
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 08:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742287171; cv=none; b=jKwsygzuunjoeolYgqyl9Bo8KNq5RIUrUvhQkjtBDPwmfYKNy5IHHaGRWGSWWrs7m+DQkKLBb0N3r9HRG2b5ZSRNf0PIqBRHv+Zx1yEx5eyYnOpqwzY3rbEgn4f6BMlkiEuEAL1qlv31s6RnKmwhgmhhtlAqWjEtc7KxqcHg+E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742287171; c=relaxed/simple;
	bh=FQ4xSX7c3WjFB6LdpO8VQQHptKeGaZvZ79lk7PEmeu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfiYrxQ55Qv//j2YYsW33zYQ6/V4rEzWZxjXvQK8srdMGCxhuzMZ6oBs4w2YKhmwLXPTUhiMLs0uaglBWEqWhyLQPSfkvO/uYrixSkXr0dSekJGvkOehotzwniKPtyCWOQOyAq7gEvmHZ/Js1uYcOhjKqpeYiQLoQoctudRo/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fj/Y5uSO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742287163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJ0VMEseaolIU+CS+bme3Nsh7S58tb1KlcpXTP+Vo3o=;
	b=Fj/Y5uSOPZI52WMg0mfjr313t0wVd8o2mAvwCXVjiAY+ItZi1/Ho4oXivUGIR+2yGjwx/V
	pR2viuhJcWZnfi2hkP/8T9JA5vhx6/4+Z1i5+jBrhX9Zo+zA5nV+SsY+w+RnYdpdWJ6kjv
	YZ5Hxcy7SaM695bQxmJr+zXQYNfkXtY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-Ogqidu21Mt-h-qOmspLGxg-1; Tue, 18 Mar 2025 04:39:22 -0400
X-MC-Unique: Ogqidu21Mt-h-qOmspLGxg-1
X-Mimecast-MFC-AGG-ID: Ogqidu21Mt-h-qOmspLGxg_1742287161
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf172ff63so18447555e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 01:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742287161; x=1742891961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ0VMEseaolIU+CS+bme3Nsh7S58tb1KlcpXTP+Vo3o=;
        b=WZ+DIugiPr48RlKf9i0lxljYyPNX2hqxysDLPDpzRZG6VuFaUzYVCN+f0C4HmXiYcz
         /awX1I4PsWhKAXaO8UtWgWHO1cnp3jdn68qHbxRz/amERuAeAVE4YCTdJ2VDvGMhjlj0
         6evDK6vG4wV4Xrx0MwzvWY6F90Ko1wfELMgBBvbebrDjBb7BW8/mVO9ll3SEW9tE9Mlv
         J5xn3MRlAoL7PHfXKr1xWq7zioJ2309vMofOzdg/9QrrBR5GMsd4O2H1cZ+zWjGXNnCN
         E26o2sePwtIeYQW4mO7PsZlNxu0763gNg2YMbrE2Kl7NIJPjSzsluvu6Kbrg1G6QYaSI
         LI5g==
X-Forwarded-Encrypted: i=1; AJvYcCVIEsAUnxBcoS2786RRalNwhPqlmiAsi6Gxr+eBNOtCZNneYkjcaq65NzYEbg0chQWBnTI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWW/CoufzxEvXz31veztYPXxCvDhaDx5te4xYwWZIMjsxLrNNw
	51JmsD9IBeqxKaI6+StlenjmD/g69JbsjqgSxC/XbAeuGOV9hIA1G3dDtsUZH/V0DPoYC2mf62y
	4HGfRfXi07msuCAHEj4hWTtZekj/BFF3C6dtiya+nlG5euvu6BQ==
X-Gm-Gg: ASbGncsN/wopHyBuUWoF9XIjCNyWwymK/XweVCe3INImn+bBlJKeSN6xAtO7GKKf7Hq
	uu73n8Etqp5v2mu3ztC7BcBE4Z0ZUWHushVdCD8lOGEvsn/oMdDmhElpLN0nfNMZXPqwAnOaPGy
	ReuQKpO+hw6v6bNQ9l3JFYW9jADmX66C6XuLbA+y4RvIqzbRvYz4gh8nTLiZTmsfnn3KZW/1Q20
	+iL7bB5s3wRMnbZcS6r6Z9EGuiscbitiHLY3lw9TB7vsZgP0ql+vMHns7IXt0NADbx4Wgmg50H0
	ibD+vaMbqPjiMZmwCNbNcDlBfqUzg3LWt+rorPo0LfCrMA==
X-Received: by 2002:a5d:6484:0:b0:390:df02:47f0 with SMTP id ffacd0b85a97d-3971ee444e2mr15972243f8f.42.1742287160753;
        Tue, 18 Mar 2025 01:39:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7stufewyuFI6UX+sGIqRr7QTxoyguINXWTrLlPA7lpLF9hM8oFkQrmLLjxUlPq2VCHq/n8Q==
X-Received: by 2002:a5d:6484:0:b0:390:df02:47f0 with SMTP id ffacd0b85a97d-3971ee444e2mr15972216f8f.42.1742287160309;
        Tue, 18 Mar 2025 01:39:20 -0700 (PDT)
Received: from [192.168.88.253] (146-241-10-172.dyn.eolo.it. [146.241.10.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b748bsm17684458f8f.39.2025.03.18.01.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 01:39:19 -0700 (PDT)
Message-ID: <8fb48d36-f5ce-40ce-bb05-b4c342da8b4f@redhat.com>
Date: Tue, 18 Mar 2025 09:39:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 3/9] net: devmem: TCP tx netlink api
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
 <20250308214045.1160445-4-almasrymina@google.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250308214045.1160445-4-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/25 10:40 PM, Mina Almasry wrote:
> From: Stanislav Fomichev <sdf@fomichev.me>
> 
> Add bind-tx netlink call to attach dmabuf for TX; queue is not
> required, only ifindex and dmabuf fd for attachment.
> 
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> v3:
> - Fix ynl-regen.sh error (Simon).
> 
> ---
>  Documentation/netlink/specs/netdev.yaml | 12 ++++++++++++
>  include/uapi/linux/netdev.h             |  1 +
>  net/core/netdev-genl-gen.c              | 13 +++++++++++++
>  net/core/netdev-genl-gen.h              |  1 +
>  net/core/netdev-genl.c                  |  6 ++++++
>  tools/include/uapi/linux/netdev.h       |  1 +
>  6 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
> index 36f1152bfac3..e560b05eb528 100644
> --- a/Documentation/netlink/specs/netdev.yaml
> +++ b/Documentation/netlink/specs/netdev.yaml
> @@ -743,6 +743,18 @@ operations:
>              - defer-hard-irqs
>              - gro-flush-timeout
>              - irq-suspend-timeout
> +    -
> +      name: bind-tx
> +      doc: Bind dmabuf to netdev for TX
> +      attribute-set: dmabuf
> +      do:
> +        request:
> +          attributes:
> +            - ifindex
> +            - fd
> +        reply:
> +          attributes:
> +            - id
>  
>  kernel-family:
>    headers: [ "linux/list.h"]
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 7600bf62dbdf..7eb9571786b8 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -219,6 +219,7 @@ enum {
>  	NETDEV_CMD_QSTATS_GET,
>  	NETDEV_CMD_BIND_RX,
>  	NETDEV_CMD_NAPI_SET,
> +	NETDEV_CMD_BIND_TX,
>  
>  	__NETDEV_CMD_MAX,
>  	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
> diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
> index 996ac6a449eb..f27608d6301c 100644
> --- a/net/core/netdev-genl-gen.c
> +++ b/net/core/netdev-genl-gen.c
> @@ -99,6 +99,12 @@ static const struct nla_policy netdev_napi_set_nl_policy[NETDEV_A_NAPI_IRQ_SUSPE
>  	[NETDEV_A_NAPI_IRQ_SUSPEND_TIMEOUT] = { .type = NLA_UINT, },
>  };
>  
> +/* NETDEV_CMD_BIND_TX - do */
> +static const struct nla_policy netdev_bind_tx_nl_policy[NETDEV_A_DMABUF_FD + 1] = {
> +	[NETDEV_A_DMABUF_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
> +	[NETDEV_A_DMABUF_FD] = { .type = NLA_U32, },
> +};
> +
>  /* Ops table for netdev */
>  static const struct genl_split_ops netdev_nl_ops[] = {
>  	{
> @@ -190,6 +196,13 @@ static const struct genl_split_ops netdev_nl_ops[] = {
>  		.maxattr	= NETDEV_A_NAPI_IRQ_SUSPEND_TIMEOUT,
>  		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>  	},
> +	{
> +		.cmd		= NETDEV_CMD_BIND_TX,
> +		.doit		= netdev_nl_bind_tx_doit,
> +		.policy		= netdev_bind_tx_nl_policy,
> +		.maxattr	= NETDEV_A_DMABUF_FD,
> +		.flags		= GENL_CMD_CAP_DO,
> +	},
>  };
>  
>  static const struct genl_multicast_group netdev_nl_mcgrps[] = {
> diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
> index e09dd7539ff2..c1fed66e92b9 100644
> --- a/net/core/netdev-genl-gen.h
> +++ b/net/core/netdev-genl-gen.h
> @@ -34,6 +34,7 @@ int netdev_nl_qstats_get_dumpit(struct sk_buff *skb,
>  				struct netlink_callback *cb);
>  int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info);
>  int netdev_nl_napi_set_doit(struct sk_buff *skb, struct genl_info *info);
> +int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info);
>  
>  enum {
>  	NETDEV_NLGRP_MGMT,
> diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
> index 2b774183d31c..6e5f2de4d947 100644
> --- a/net/core/netdev-genl.c
> +++ b/net/core/netdev-genl.c
> @@ -931,6 +931,12 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
>  	return err;
>  }
>  
> +/* stub */
> +int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
> +{
> +	return 0;
> +}
> +
>  void netdev_nl_sock_priv_init(struct list_head *priv)
>  {
>  	INIT_LIST_HEAD(priv);

I'm sorry, but this chunck does not apply cleanly anymore.

Please rebase.

Disclaimer: unfortunately I must note that due to the long backlog
pending and the upcoming merge window, I'm unsure I'll be able to
process the next revision before the net-next closing.

Thanks.

Paolo


