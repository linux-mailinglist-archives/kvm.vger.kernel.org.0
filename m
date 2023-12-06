Return-Path: <kvm+bounces-3748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5C328077FF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:48:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A4B3282115
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6050A45BFA;
	Wed,  6 Dec 2023 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbtxOnAl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD554198D
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 10:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701888460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jnuem6msgUvZR/qtC3Ankzp7FYXj3vJHjUZIQQCp0oc=;
	b=MbtxOnAlKaLeke+auMhKSkSMe85e57YIoeJC4OfhtIgQ7LW1WnPTyFDiMHQ3zbNvNTgFJE
	SKQQYnJdgEdz9mUGuG2LWooAxdnVodM9roIxZUSCWooxNS2v0dNgPCPoDg8UR+0G8TzAOr
	J2dGFXBJoAPY0C2N9SaltoHGNF4J0jc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-Tuw3EEFdPnKmyZPDo_6gdA-1; Wed, 06 Dec 2023 13:28:32 -0500
X-MC-Unique: Tuw3EEFdPnKmyZPDo_6gdA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3334b1055fbso69185f8f.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 10:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701887304; x=1702492104;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnuem6msgUvZR/qtC3Ankzp7FYXj3vJHjUZIQQCp0oc=;
        b=BKEgnY7GNAOE4UjT+TU6jR8gYyBu+UjNqDy044QGk0VsDWXlvrOYIXMJO67P0oyiFJ
         /NYtTjCsBfczo/cMLmVf1Mq9Rd2qrtV/5WQo7l7a8f03LC/JTsLk/M9zzYExo3Ym2MHc
         XEgNhs9Q5RSObwC7N9IblejyAb+7meUhuUVAIApzhKBWH456jd/uKLsEDK3GVrt2FYXR
         G8rytzZENFuPk+0aDXOWMRXAGNviGPGtxIQuCd70SeNWS7jn6/1xDvAgsIKcSMsandOM
         K+SNjd1ByFRvVEvo8HZ5fiSUYY/ELmL2/43ATJOb91ElnCZY7DiX5mkWpXz+RRcP5WmB
         pN9Q==
X-Gm-Message-State: AOJu0Yyzk7P26wsTlX+SxCCHiQU1sA1wnc5+TWs+yqmmeiS/IZr1IgfA
	Ud1zLQ78HKh18Nu/ls2gntxqWv2x+iDCOwYsiVRS8QI5J8IEDiwW04hUi65uwfgzBH9ixtERtHr
	I8PNUE/+nWFP0
X-Received: by 2002:adf:f752:0:b0:333:2fd2:3be2 with SMTP id z18-20020adff752000000b003332fd23be2mr563990wrp.155.1701887303892;
        Wed, 06 Dec 2023 10:28:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGPfF7salzTJo8Tl0XEOHa4Kq1FjBjVSq+If3zpML0Un6nfo5ZCrIh/61l68acpETq59NVYPA==
X-Received: by 2002:adf:f752:0:b0:333:2fd2:3be2 with SMTP id z18-20020adff752000000b003332fd23be2mr563984wrp.155.1701887303527;
        Wed, 06 Dec 2023 10:28:23 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id lg18-20020a170906f89200b00a1b7f4c22a7sm267591ejb.82.2023.12.06.10.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:28:22 -0800 (PST)
Date: Wed, 6 Dec 2023 13:28:18 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: fix "comparison of distinct pointer
 types lacks a cast" warning
Message-ID: <20231206132803-mutt-send-email-mst@kernel.org>
References: <20231206164143.281107-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206164143.281107-1-sgarzare@redhat.com>

On Wed, Dec 06, 2023 at 05:41:43PM +0100, Stefano Garzarella wrote:
> After backporting commit 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY
> flag support") in CentOS Stream 9, CI reported the following error:
> 
>     In file included from ./include/linux/kernel.h:17,
>                      from ./include/linux/list.h:9,
>                      from ./include/linux/preempt.h:11,
>                      from ./include/linux/spinlock.h:56,
>                      from net/vmw_vsock/virtio_transport_common.c:9:
>     net/vmw_vsock/virtio_transport_common.c: In function ???virtio_transport_can_zcopy???:
>     ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>        20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>           |                                   ^~
>     ./include/linux/minmax.h:26:18: note: in expansion of macro ???__typecheck???
>        26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>           |                  ^~~~~~~~~~~
>     ./include/linux/minmax.h:36:31: note: in expansion of macro ???__safe_cmp???
>        36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>           |                               ^~~~~~~~~~
>     ./include/linux/minmax.h:45:25: note: in expansion of macro ???__careful_cmp???
>        45 | #define min(x, y)       __careful_cmp(x, y, <)
>           |                         ^~~~~~~~~~~~~
>     net/vmw_vsock/virtio_transport_common.c:63:37: note: in expansion of macro ???min???
>        63 |                 int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
> 
> We could solve it by using min_t(), but this operation seems entirely
> unnecessary, because we also pass MAX_SKB_FRAGS to iov_iter_npages(),
> which performs almost the same check, returning at most MAX_SKB_FRAGS
> elements. So, let's eliminate this unnecessary comparison.
> 
> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
> Cc: avkrasnov@salutedevices.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---


Acked-by: Michael S. Tsirkin <mst@redhat.com>

>  net/vmw_vsock/virtio_transport_common.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index f6dc896bf44c..c8e162c9d1df 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -59,8 +59,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
>  	t_ops = virtio_transport_get_ops(info->vsk);
>  
>  	if (t_ops->can_msgzerocopy) {
> -		int pages_in_iov = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
> -		int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
> +		int pages_to_send = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
>  
>  		/* +1 is for packet header. */
>  		return t_ops->can_msgzerocopy(pages_to_send + 1);
> -- 
> 2.43.0


