Return-Path: <kvm+bounces-27836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E2498E829
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 03:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06718288700
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 01:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4217117BA5;
	Thu,  3 Oct 2024 01:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbogR42n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232011185;
	Thu,  3 Oct 2024 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727919266; cv=none; b=nqK1aQmbdIGkKHVbiALk/JZvVa18KyOSXaucJHMxxqK8stUs6pK0Loe9NUJeKn7ieqxT7f9hl43Defjt3f0LPeO0oh7CiUqrh3XgU1JPO1xLlw7VqnOYdrH+8e9JNGazYXnz8pcOlpgASjDhqnaRmAzKD+rn2bGF4KomMrOWK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727919266; c=relaxed/simple;
	bh=mmaUrN4Dm30mlJAYCNKceu7BnMA5aMALOTE+YcITCc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXIb18SWmY3c9IFwlUzZlynXNgfqcX1ARBW5CZVWDX8wQ/GWL6cVx9lku35+8CM1LujA/a+xjA8C2jptNeK237pw5ngm32GUZ7FfIauyiwCiISyt0U7Ag7++obKpRoOJka9cV/QG0n6gkGNDYaXlXEpiEJvRCMc2h84S54R5oP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbogR42n; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso46371866b.3;
        Wed, 02 Oct 2024 18:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727919263; x=1728524063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DV7X6w6WEiEDmMlQq+ioS4yyvRQLrPkx+bFuOa+5sxo=;
        b=dbogR42ndFuz3kjmL4J5kaVw5lo90PZvYYBVy0qeysrzEadAMfePrpKz4i2g028WGJ
         PnHbcox/agn6mlu6V+/zBkwuDrSz3ZWIeIsr4vd8S4et3QHOeJ2HYxCa/HXn//YIxLtB
         74ugJqMFSr5GGzniTjf28LSCWRzoKzeTkxIbHa1rxdn/Hxn6kW2/ksa+l29GpQPSZC12
         ANpZqAyq2fWTfLO383MEDovbQMEP/003n5TmTyYY07EQN2SYDJQOlRB8nbxPr8VjYT+G
         Odap6c1506/Iebb/17b7FQo9ErDF62JMtr2WlT/Vml01qqDOUy9Qs26nvP1NCKRqKxBC
         lePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727919263; x=1728524063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DV7X6w6WEiEDmMlQq+ioS4yyvRQLrPkx+bFuOa+5sxo=;
        b=t9so0iSpJeKtODbDfS0l7S9QY2F9fAKlXUw+H3BPqjW7jIngU5RB1Ah7/E94JLeJil
         qeEERPwOVtVfFynCqbh/BSBtwf2q/FZB98+PImPhvL8pwK9MI6VP8nw7O0G8weLe3Vto
         HRZzqvkLRuhV58LYpQtYHlU7mEi/94/SH7jhQpJik+TT0sKEF0MPgrq+HR0tYUxh0f2h
         xrgCRU0v5EXii986xKx8mXi/qM2bPWvahIPnTGgKel+OXbhVq88JU9LNLeCQ2qnzE/iX
         O7EquSkjAER3wmL2gWoJvN4IMrZEyPwof75iXD73JXrnaGaqm4jtRrNJrEDA/qLc1bVY
         pB2Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1gUQfwrK3rALGRuA9lB1gQw0biVljSrHKDbZcE3H/WI4F983tO+Q6+xwRok+DsEAWm0J9gOsR@vger.kernel.org, AJvYcCVXYZXeOZ/rNQ9xontoHSDmXlmPkLqTKD+PfqemKecY3neOv3ZRicLd7vpxUvJ9klYBn/5DCjaVqQoiPHp6@vger.kernel.org, AJvYcCXfN0Z7DZ8OOhDvjY9Ea2cIXHJh7ezKe0K9nKbHzgavxDp8EZbR9UH0x/ddgH5I3YZOBBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzowji1tjWGtWnGibLRYKcOa6yegKs6YelolCZrJgzCEEqUL/HN
	IlpO45dUvqLN+2FYdyEaMekSrbI95M1utyiltx7gDSPFc3xpugCt
X-Google-Smtp-Source: AGHT+IEKU7TVq9K/bpf9fJy/0UOluYJcI2o5/6s1Yf9hUvaOWNNvq2hKSdZJYqbq5oGEnlxqZMVegQ==
X-Received: by 2002:a17:906:4fd4:b0:a8d:3338:a497 with SMTP id a640c23a62f3a-a98f8216ce5mr439831066b.4.1727919262819;
        Wed, 02 Oct 2024 18:34:22 -0700 (PDT)
Received: from fedora.. ([151.29.146.144])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99104d2863sm5688566b.220.2024.10.02.18.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 18:34:21 -0700 (PDT)
From: Luigi Leonardi <luigix25@gmail.com>
X-Google-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: mst@redhat.com
Cc: brauner@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	eperezma@redhat.com,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luigi.leonardi@outlook.com,
	marco.pinn95@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Date: Thu,  3 Oct 2024 03:33:53 +0200
Message-ID: <20241003013353.116203-1-luigi.leonardi@outlook.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Link: https://lore.kernel.org/all/hfcr2aget2zojmqpr4uhlzvnep4vgskblx5b6xf2ddosbsrke7@nt34bxgp7j2x
> Fixes: efcd71af38be ("vsock/virtio: avoid queuing packets when intermediate queue is empty")
> Reported-by: Christian Brauner <brauner@kernel.org>
> Cc: Stefano Garzarella <sgarzare@redhat.com>
> Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Lightly tested. Christian, could you pls confirm this fixes the problem
> for you? Stefano, it's a holiday here - could you pls help test!
> Thanks!
>
>
>  net/vmw_vsock/virtio_transport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index f992f9a216f0..0cd965f24609 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -96,7 +96,7 @@ static u32 virtio_transport_get_local_cid(void)
>
>  /* Caller need to hold vsock->tx_lock on vq */
>  static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
> -				     struct virtio_vsock *vsock)
> +				     struct virtio_vsock *vsock, gfp_t gfp)
>  {
>  	int ret, in_sg = 0, out_sg = 0;
>  	struct scatterlist **sgs;
> @@ -140,7 +140,7 @@ static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>  		}
>  	}
>
> -	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
> +	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, gfp);
>  	/* Usually this means that there is no more space available in
>  	 * the vq
>  	 */
> @@ -178,7 +178,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
>  		reply = virtio_vsock_skb_reply(skb);
>
> -		ret = virtio_transport_send_skb(skb, vq, vsock);
> +		ret = virtio_transport_send_skb(skb, vq, vsock, GFP_KERNEL);
>  		if (ret < 0) {
>  			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
>  			break;
> @@ -221,7 +221,7 @@ static int virtio_transport_send_skb_fast_path(struct virtio_vsock *vsock, struc
>  	if (unlikely(ret == 0))
>  		return -EBUSY;
>
> -	ret = virtio_transport_send_skb(skb, vq, vsock);
> +	ret = virtio_transport_send_skb(skb, vq, vsock, GFP_ATOMIC);
>  	if (ret == 0)
>  		virtqueue_kick(vq);
>
> --
> MST
>
>

Thanks for fixing this!

I enabled CONFIG_DEBUG_ATOMIC_SLEEP as Stefano suggested and tested with and
without the fix, I can confirm that this fixes the problem.

Reviewed-by: Luigi Leonardi <luigi.leonardi@outlook.com>

