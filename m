Return-Path: <kvm+bounces-31088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D479C021E
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:19:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37BD91C21D52
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D881EC01C;
	Thu,  7 Nov 2024 10:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTTvOKnu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B152C1CC8A3
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974766; cv=none; b=Jty2npxtCn2zKlxCelu5b3At/UvaRubryJEHwk7zSqmU8AZc7Sjv8+NgBm++IvNo8bugy6etBOcHhe/Y8yGWwKflb+e9/9QkOmbonYT9pKmYAYcNfkyqEAN2YQ2pW5ZvIOLYjg8SGhOoWreLAg/aCC92Maj6bM9tARGL+xp1PMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974766; c=relaxed/simple;
	bh=MuNWhYrw8F/gSr00QNLIh4DtWvDQaY0ROHYlSaTNVt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQssaGYvhsJhB1ozsZL5mG2h2KynMootsJ9nVFtGu4X3BNpMsIVQzd1Uf3kdtC1+5S+pTi4q7vosUcSUFbCJseF1e/ujELvZmOnKAmcTtvjxKniMrOBCsEd/TZ0SG4D7YpM6PzN5WVptpZkErC3UothsT4Yhl21+WJzUIs9+3L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTTvOKnu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730974763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eUPJBtFS5dfBIUKGBSTul1nLycqN5459o9xMHL54qwM=;
	b=aTTvOKnuLxtFBIWnmn6mKojLTflhAwwG59qtbDHY9Z/F4em60HFarbLxWgyIbdg7x7Do+e
	3pmyyGYL1HqFvsEuS3NNPDgGPKkJVPdp43ZZoFGVUkZ+UDHjoawAV7K6IY0tb3O4nlgFBH
	HUFJsMH3UGPUlt/t+/3A5aiy41dA+vo=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510--CiisEwgM6WSFA4u44IhXg-1; Thu, 07 Nov 2024 05:19:22 -0500
X-MC-Unique: -CiisEwgM6WSFA4u44IhXg-1
X-Mimecast-MFC-AGG-ID: -CiisEwgM6WSFA4u44IhXg
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5eb8b4b3eeaso584276eaf.2
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 02:19:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730974762; x=1731579562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUPJBtFS5dfBIUKGBSTul1nLycqN5459o9xMHL54qwM=;
        b=dwQbtUDqKNWXy5g5FIDyMP/+1tbFv61cIoRUPLGPPyHr3JhRPaNIBuA4OQX5grtRIP
         4+CFITPcv+eXhPGi+9np8qDgXdmt0ZdYGS6vSRC8G47d4cHd7oh/Z2DJoFz1Al0Ycxp4
         /3TxV5J8yxye76x0sCLQbPZPV6WpLLfezmZkjHmYHqgvXHllv3SglVYk5SffOozp4Zz2
         zyrrjet3Sk3cv4kPk0j4SvmioMVy54lcrLjxpJ1UiPh/okLWuoDxzT7jtBfSZVDg7FGX
         1BEAk7VjXgwxE4HlZm/KYTJxmTymMBDmk6b7rZXYoFpFkuOXdlOf3OQzt87VsBuN2xRE
         R4kQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7KrxpPQDPRQk6UwbqNpSHmjXOOUpKRjwsjjTYxwDToU4HPHxz/GYS7liUSO/C3LpVtI4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5HFwi7ZqMtX9JiwEEWY5Fe8GFfWC9EKE0glN0J+ujUk8k1oZF
	IfxVJSujzD2R6VOO3b8VYSGX/6MqxLUpoC1pzbPiredFTksm8qXkJoIP1wxfaqrqvyd9VjG9Obv
	m40sArjVLJ2bWC3t6GR/MUPCdILti0UHU6hfn/aghfmv7YvJKkA==
X-Received: by 2002:a05:6358:d595:b0:1c3:878d:286e with SMTP id e5c5f4694b2df-1c5f99f6192mr1267418955d.22.1730974761854;
        Thu, 07 Nov 2024 02:19:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGb0h9WGNnQfHK+osDGOMOYjYkH7je/1Uc03OD4ourSiBQ1DFDDlBICtkFFZrGGHTcwY75ndw==
X-Received: by 2002:a05:6358:d595:b0:1c3:878d:286e with SMTP id e5c5f4694b2df-1c5f99f6192mr1267417255d.22.1730974761369;
        Thu, 07 Nov 2024 02:19:21 -0800 (PST)
Received: from sgarzare-redhat ([5.77.70.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d3961df2desm5996176d6.21.2024.11.07.02.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:19:20 -0800 (PST)
Date: Thu, 7 Nov 2024 11:19:11 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>, 
	Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
	George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH net 3/4] virtio/vsock: Improve MSG_ZEROCOPY error handling
Message-ID: <5zv6gmfg45gu3km6srpjlby2z7th7pnosfeorixhgivb3cgfvw@to6bkzdjvkob>
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-3-8f4ffc3099e6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20241106-vsock-mem-leaks-v1-3-8f4ffc3099e6@rbox.co>

On Wed, Nov 06, 2024 at 06:51:20PM +0100, Michal Luczaj wrote:
>Add a missing kfree_skb() to prevent memory leaks.
>
>Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 1 +
> 1 file changed, 1 insertion(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index cd075f608d4f6f48f894543e5e9c966d3e5f22df..e2e6a30b759bdc6371bb0d63ee2e77c0ba148fd2 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -400,6 +400,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 			if (virtio_transport_init_zcopy_skb(vsk, skb,
> 							    info->msg,
> 							    can_zcopy)) {
>+				kfree_skb(skb);
> 				ret = -ENOMEM;
> 				break;
> 			}
>
>-- 
>2.46.2
>


