Return-Path: <kvm+bounces-14214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE568A0952
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16115B2444E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213CD13E3FC;
	Thu, 11 Apr 2024 07:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MiEJlDzG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E5413E408
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712819398; cv=none; b=GfYGghYTnsE+XpxxG3D1wRpnC4HGVdM0JUBiYOU/6fw4If42uZ9NRXxUHvaQ+P51y6tfE1XT0g61kA20YsqQcwvS2gL/Wuan6AFwmzRXLdDZnCgYILnsiOSWI0wIP5g+jVasLBTwhxy4rYoHJ3nxna/b2QP4Q74xQNcN7dqkb9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712819398; c=relaxed/simple;
	bh=QC9h9HAzKjpbS5q5gZwDz57LpAKPQQn94Xz6yBQbh54=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fvn0Kv88WX+DIYdV2q8ZVt7voGekljoot/sf0e128MgKfwNjULTu+E+ejvWN5GFqyxSpfxYTnIDV0GrYBKNVrcqwyPGyu7HnS8HBs2dYyH4sdTdhKJ9muxWjp522t78vSnwg4sdOi+rFWo2UqzebCBIjO3uvlbMnNGSzolhCI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MiEJlDzG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712819395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0gmv1ukviBDC/ktQ/wQsuMi8OWfH8M4G9g5yZPhC96s=;
	b=MiEJlDzGrSsDVf/h9vWVJ3viw7y21iUbSQgKWfaK9f50x9dF4+5kxqg5xQnjuLh599AnIU
	uZ/BZLslvzDpeU8BKyGpuAFZPH5/UXXMtxbAJNyeo6gqBNEUDWumPtVmYOkGSFwjWyYwcO
	5dlfWV45q3Ej1zi37uJBUdlNvEM2CYw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-qVWsMVxvNMutdDOr3e-WHA-1; Thu, 11 Apr 2024 03:09:53 -0400
X-MC-Unique: qVWsMVxvNMutdDOr3e-WHA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-416640b7139so1219225e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712819392; x=1713424192;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0gmv1ukviBDC/ktQ/wQsuMi8OWfH8M4G9g5yZPhC96s=;
        b=OMatDqynZRLoBdXemtMlLcHFRNYTbl7Ydx31Q1qLJCnqck+fUknNw6D8W/gYSfcX/Z
         OItd5Vb3bnV46NwATbkSqTPwtsGUNcKRhXlhLCvbdqz9hb5kDAzuAHSXqC9wX99V/QS/
         lBnhp3rMtptwUWybbLOR0noHuktIlvQ47suOx95vRglm0UuJD67PnNecdi3sXWV15YHq
         b+ozb+EzDj0iRev0+TwaZYm8wxVmvj1+VmqxLbSApjPzLYkmEF7JJ8Q1jzldyUnHIK2b
         xGFk0EeYAJRzFL8WWOz3Xsf9FR/dQqFbH8TtmCq/x+v8EjW7H6EqRNfJrTRxRMBPUlvS
         QUUg==
X-Forwarded-Encrypted: i=1; AJvYcCWx0CjFr6nrvZx6L7TXWaU5GKwcbEqoNBdPaOhl0fgx1ihUz7h5GrMqxiTcYrIx78K/q6smMLQWZmO2LW2gx6RvuCAt
X-Gm-Message-State: AOJu0Yxl3UydqVyj/Q3Q/bxgkmi9e/PsJCFLnxwyKfNNdbA+tE41+P+U
	wr08n5TFDZxzZRUfyRjd3GCQJ2y2VUqy0QUO8P+VwTzWjSmP7TyvpGbYEb1r3ha7lgp6nUD8gkY
	gGucb9KQwER4l2T1N0OJTEoLLTWxHIvTsC/LaoKfXlZg9pjnGAw==
X-Received: by 2002:a05:600c:3b10:b0:416:a71f:6217 with SMTP id m16-20020a05600c3b1000b00416a71f6217mr3347421wms.0.1712819391896;
        Thu, 11 Apr 2024 00:09:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS6Q57FR563armd3KJAllSOx5ku85NAXtbGBdWsroJEtWP61OvPaA5aD2g/mn3CIbW0Nn7vw==
X-Received: by 2002:a05:600c:3b10:b0:416:a71f:6217 with SMTP id m16-20020a05600c3b1000b00416a71f6217mr3347401wms.0.1712819391495;
        Thu, 11 Apr 2024 00:09:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-235-217.dyn.eolo.it. [146.241.235.217])
        by smtp.gmail.com with ESMTPSA id m16-20020a05600c4f5000b00416c160ff88sm1424355wmq.1.2024.04.11.00.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 00:09:50 -0700 (PDT)
Message-ID: <c18d4b9220a85f8087eda15526771dac5f8b4c0a.camel@redhat.com>
Subject: Re: [PATCH net-next v2 2/3] vsock/virtio: add SIOCOUTQ support for
 all virtio based transports
From: Paolo Abeni <pabeni@redhat.com>
To: Luigi Leonardi <luigi.leonardi@outlook.com>, mst@redhat.com, 
 xuanzhuo@linux.alibaba.com, virtualization@lists.linux.dev,
 sgarzare@redhat.com,  netdev@vger.kernel.org, kuba@kernel.org,
 stefanha@redhat.com, davem@davemloft.net,  edumazet@google.com,
 kvm@vger.kernel.org, jasowang@redhat.com
Date: Thu, 11 Apr 2024 09:09:49 +0200
In-Reply-To: <AS2P194MB2170FDCADD288267B874B6AC9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
	 <AS2P194MB2170FDCADD288267B874B6AC9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-04-08 at 15:37 +0200, Luigi Leonardi wrote:
> This patch introduce support for stream_bytes_unsent and
> seqpacket_bytes_unsent ioctl for virtio_transport, vhost_vsock
> and vsock_loopback.
>=20
> For all transports the unsent bytes counter is incremented
> in virtio_transport_send_pkt_info.
>=20
> In the virtio_transport (G2H) the counter is decremented each time the ho=
st
> notifies the guest that it consumed the skbuffs.
> In vhost-vsock (H2G) the counter is decremented after the skbuff is queue=
d
> in the virtqueue.
> In vsock_loopback the counter is decremented after the skbuff is
> dequeued.
>=20
> Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>

I think this deserve an explicit ack from Stefano, and Stefano can't
review patches in the next few weeks. If it's not urgent this will have
to wait a bit.

> ---
>  drivers/vhost/vsock.c                   |  4 ++-
>  include/linux/virtio_vsock.h            |  7 ++++++
>  net/vmw_vsock/virtio_transport.c        |  4 ++-
>  net/vmw_vsock/virtio_transport_common.c | 33 +++++++++++++++++++++++++
>  net/vmw_vsock/vsock_loopback.c          |  7 ++++++
>  5 files changed, 53 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..dba8b3ea37bf 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -244,7 +244,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock=
,
>  					restart_tx =3D true;
>  			}
> =20
> -			consume_skb(skb);
> +			virtio_transport_consume_skb_sent(skb, true);
>  		}
>  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>  	if (added)
> @@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport =3D {
>  		.notify_buffer_size       =3D virtio_transport_notify_buffer_size,
>  		.notify_set_rcvlowat      =3D virtio_transport_notify_set_rcvlowat,
> =20
> +		.unsent_bytes             =3D virtio_transport_bytes_unsent,
> +
>  		.read_skb =3D virtio_transport_read_skb,
>  	},
> =20
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index c82089dee0c8..dbb22d45d203 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -134,6 +134,8 @@ struct virtio_vsock_sock {
>  	u32 peer_fwd_cnt;
>  	u32 peer_buf_alloc;
> =20
> +	atomic_t bytes_unsent;

This will add 2 atomic operations per packet, possibly on contended
cachelines. Have you considered leveraging the existing transport-level
lock to protect the counter updates?


Thanks

Paolo


