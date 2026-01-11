Return-Path: <kvm+bounces-67663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6563BD0E70C
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 10:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54D1C3014ACC
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 09:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DEF1330657;
	Sun, 11 Jan 2026 09:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HbM6d8JG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eK2GgtJY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8C432FA29
	for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768122971; cv=none; b=UCsn0Cybsq/dxu7M5wCC8Mf7uQpf67CqQpMo+tRsdTzunb32Tz+lgh/L+sdHy18sXA5p64gMEn0ow3Og2YfatBwmd2iMq/EGqWBg1nZCVheeFQ2HgSs2uEwaatI8bvJuEPC5kIfayoCRK+SYr6WbYfcsDs13knDU5ZZgWgrlZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768122971; c=relaxed/simple;
	bh=BZOccm4XxVdjIcV5Tne5ceXK0NuuvIGdkFXUs4hhCZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o5A5DvkequBV5ZF+SUskEdFaVL/w9frnYvm/1NTj+Ncxq/hjn7H6T42J0zE7xFinGc7Tyei/1bOKCwm9ldsVjZgNptxXoGRo9XU3YwF28oYYMAhVZTOxm4lHYSJ5nxbV3Qd3XhMd/YUouO3JX991pnXRE4TUdGBRg4t3hjWnCxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HbM6d8JG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eK2GgtJY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768122969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WS2+XzdVc7BsmtGzyRzQokn3ZRi3QBRYwnL4Qo9AS50=;
	b=HbM6d8JGo14VIT0oghY8CjW/kDzJ0BdRuB+VL9HBN05BdZtoFJEt68tjdWb8UsyhWGcOHr
	ZEv2sdSC1dK9iglmWXPOduJIhUQOU7B6pkicWrtIKsmLa9zkRrLvcMc+g2GkOBLEUCWaQq
	cL6nZR2NWcD1hGAVh/Lootta1QdIE40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-Ac5IRUtPMumc6mgd25MlnA-1; Sun, 11 Jan 2026 04:16:07 -0500
X-MC-Unique: Ac5IRUtPMumc6mgd25MlnA-1
X-Mimecast-MFC-AGG-ID: Ac5IRUtPMumc6mgd25MlnA_1768122966
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso23058305e9.1
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 01:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768122966; x=1768727766; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WS2+XzdVc7BsmtGzyRzQokn3ZRi3QBRYwnL4Qo9AS50=;
        b=eK2GgtJYRxTqI9k6TKmJPoD82wmLnI3rqB9NyUoDEHY8KJF4aliV39nsigBXoY6pUc
         vfaIyZguYN/6Kmh1oOQy7KHuj6ENMBb1EAShoq3EoukQtBH/MXgyrEnreUym8eIxjWCo
         xF9GiWFSnFmg4kXQt/R18sW3cgt8j11Xw8Kp6YiRxJH6Am4vrIUPnbIx816QBvksQohP
         P7lzmgiGh8o3mc4GpTKNTmnSfikQKqbhm1Us3YgzGH1nTiCE5qiVwlOOtsKsOKNeU/OU
         piBfJu66XJMjh56ZyzqntcvWURH6B4MmPNu8hr6mkykiN74eGI3u5oi5SeKa5mIj+a9V
         C3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768122966; x=1768727766;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WS2+XzdVc7BsmtGzyRzQokn3ZRi3QBRYwnL4Qo9AS50=;
        b=THqLEUsc4Y9CcqLYSnCgqldf1B1rIK3WaJ1u09oZRy6Bd/TbPcErQ50cnYkeLle1eW
         PoUPafGU5FQaSu+ChmTVUv0p/glacafeNqXYsaXNE3vnVknAOfG9KkrZLheysiYs4pdp
         v3TcJ3+JYTxVZAGaPBRjS7zJm/yjyeQF9YG9nCabSfkPGr87Oe6EWgQxFDHnUA4BNosM
         Gvqjo9K4/a27ONEZHQF2hdzR5yX5S+Q7rkXiVC+2LIA2QZ6uqFg2h28LcKX+n2Tw9TQU
         ix8J0ZCLXexwGqIuX+KW8QE5m8jDn04GLOxWwmePayr1yZlT+0i1IJiNNMXLoI5Dj9h6
         j1tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcDYsbD0QPuN/wENIpKqrQyDkfD7RPZpYzGsr4tsQ+DimJuVdT9mYHcIqsfpQuT4TEtLE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymyb/5oGMjoQLx65rbwDEss60+xXcp+ucpGM/AIHHbdT7YE3D8
	6rFmB2PT1u5tQQr5LdgDzCyc9xCg9uOiC1mJn9+HiwexQXPuP2/aBjoeOPJxCU4839NDzvpmHja
	XWnkvWMYl/cypE6bfPNccrXfDGman4s2PNuY7V6CGXqGJDVvsHVtkwQ==
X-Gm-Gg: AY/fxX6XMNjpVno5o4zl3oEkPMfVQFBx3gC1Mx0m66/GBMkGTTSx8YKe/m3EnmUYRyZ
	tO3kzVN3IZNs1NbE1Z9cPmjjagehla29sOLrqhygHLD/ZHR3MP4grnGJSIJfZikbwU+7ZFPef51
	zIDYBX4/6iHIerrhofgHz1L2yliGL5PdXeVeZSx8Nz0m6bH/Li6nRmfiMLTcmqvdDJLt0EQ6hGV
	xnkzjexZ/ZtJp5LBiRNZpUo88RtDNj0RX+qtpq8Tc+OZ72fUk1p6z+xwieAHicDgxZ0OZ1dee0z
	HKBUECsMR/oUBC3OtwUd1IXRPjzEtH69SkxiLO2qUj+YczGEfiOppqRv6OSMRpE871+GLWrsQDi
	09lHQS2GlUmGZp3Tn1/ITS3RmhrNVvNU=
X-Received: by 2002:a05:600c:3ba9:b0:477:9d88:2da6 with SMTP id 5b1f17b1804b1-47d847d0f30mr193215565e9.0.1768122966075;
        Sun, 11 Jan 2026 01:16:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1T4RKFHLydRXZSk4hv5pRkHtZL1MUAZhZsWSp+woZTG55Ip7dDXQ0exZCHM77fG+sLNTHpQ==
X-Received: by 2002:a05:600c:3ba9:b0:477:9d88:2da6 with SMTP id 5b1f17b1804b1-47d847d0f30mr193214965e9.0.1768122965611;
        Sun, 11 Jan 2026 01:16:05 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f69e13bsm296398485e9.7.2026.01.11.01.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 01:16:05 -0800 (PST)
Date: Sun, 11 Jan 2026 04:16:01 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v12 02/12] vsock: add netns to vsock core
Message-ID: <20260111030617-mutt-send-email-mst@kernel.org>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-2-257ee21cd5de@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vsock-vmtest-v12-2-257ee21cd5de@meta.com>

On Wed, Nov 26, 2025 at 11:47:31PM -0800, Bobby Eshleman wrote:
> From: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> Add netns logic to vsock core. Additionally, modify transport hook
> prototypes to be used by later transport-specific patches (e.g.,
> *_seqpacket_allow()).
> 
> Namespaces are supported primarily by changing socket lookup functions
> (e.g., vsock_find_connected_socket()) to take into account the socket
> namespace and the namespace mode before considering a candidate socket a
> "match".
> 
> This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode that
> accepts the "global" or "local" mode strings.
> 
> Add netns functionality (initialization, passing to transports, procfs,
> etc...) to the af_vsock socket layer. Later patches that add netns
> support to transports depend on this patch.
> 
> dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> modified to take a vsk in order to perform logic on namespace modes. In
> future patches, the net and net_mode will also be used for socket
> lookups in these functions.
> 
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> ---

...

> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index adcba1b7bf74..6113c22db8dc 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c

...

> @@ -2658,6 +2745,142 @@ static struct miscdevice vsock_device = {
>  	.fops		= &vsock_device_ops,
>  };
>  
> +static int vsock_net_mode_string(const struct ctl_table *table, int write,
> +				 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	char data[VSOCK_NET_MODE_STR_MAX] = {0};
> +	enum vsock_net_mode mode;
> +	struct ctl_table tmp;

nit: this file should now include linux/sysctl.h for this struct definition I
think?


