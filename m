Return-Path: <kvm+bounces-41488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24359A68DC9
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65E3588051E
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 13:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4202571D2;
	Wed, 19 Mar 2025 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/jTHkpf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41797256C6E
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742390780; cv=none; b=kIVksPJ4B8ql7IU9EqKJ/QImptYMS77RLz+CUmqBJu1ZTYQcKwKUwg8kNuU3XNRkNfaL3/fCfZUP8YvLSO/a4lH9MN0UcMOAiHBj7x0EPxsGMLivAsAjQgmEM9z+tFSWP4L0kc4ULkMbpAIADLD6WP0ZZjpfw+qLBcKYgZr9uoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742390780; c=relaxed/simple;
	bh=ld5eJNWi/v1i0gmIRHdZaRFv9fDwhRMDqEbIo4PLTEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rx8kmmnuqyqoTOTWjGYthl/5na+Q12LIjwSUBlLuB9aG0SWkAK/ft8rHzHp7Fv8r9GVcfH8C6zw1KZyFGGYnszk4N0Feq7xgJ35AHTqxgSrCU4xgSNxTKLwUlD1JaaciCx+PK6hOUGt8NJdLxF0HHTBEapUys6svvaYvBMj2HsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/jTHkpf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742390777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jaUUXRh1EbOiBGq2k3FaF6z5tXEmrMKUqLsPsZxaMf4=;
	b=Q/jTHkpfBCZoKa2KR2uxteMWMdChbnFQk+41hnWSn3JIPIZW6Kq6/Lw7hAhsbNTOXFPvEc
	n9UZFNGC41zh1tc9QSo5PoJDU4sAfYrz1rG1+jjDgF2aNCQgH1kIo1j4bR8nyg2SeVOnTc
	rabcnqaciwBJ96Qg6YXa9Q+HESOi6cA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-M-bS7qaBOta2FMj5CmU-TQ-1; Wed, 19 Mar 2025 09:26:15 -0400
X-MC-Unique: M-bS7qaBOta2FMj5CmU-TQ-1
X-Mimecast-MFC-AGG-ID: M-bS7qaBOta2FMj5CmU-TQ_1742390774
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5da14484978so7108538a12.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 06:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742390774; x=1742995574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaUUXRh1EbOiBGq2k3FaF6z5tXEmrMKUqLsPsZxaMf4=;
        b=rq0DepnTOu/IIxaCah8yvN5wIwiD9pwnG8ofcR7mbMvgBdsKJVo4KahgpPmdj03tKt
         G3ALPImKD7sBkUbgLqX8IliMDXJXFs8cRyCQA8qj4eY35oJfSCiDo/d9IchvN7GW7hgS
         zMZDLT+Afva7qGPmosSHF2Ze4PfZXF9wj/esQhKPp0DbvejA5fkmDjWzPkweyA3dRMCK
         mV4472QUBuwZqvnOxBEwGqNhU9WFea13q+/U8Kp66bQVOO/ABmsowIguytT5bTs5Qz4/
         pzAfOhZ3FY1lKRMd7d+MfPcnsOwY1FtUQ/pbJ1w/Ph7I7jVs8UrxZbASXmjiNUn4L5xW
         9HLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa/odQUCBQoUt1remx7kWzHoWPqD0whYINBpD5elUxDb8Ln+kUYElTFTeqHfZKBoe+nwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTafMq0YFELI2evgDahvTs7CnjV2c1VG6h3O2bKJiNOgkco41m
	jnYrziHZd2skhOcpegWd4FVxRO37O3sBywsxn6ahWE7FmF2v82J6aqtVgjzXPchat2FWcZh9nSv
	7aY2en5UTw1RxE9pwMY+BflUWGt2vrvEVMMNtOcmLj6elp9iN0g==
X-Gm-Gg: ASbGncvvcRb/wFs4301QqqstkNHMZkiMV/KIEV06v9C+ZK/nR0DDSDlGqMW0qjQTlyN
	FxOwpeBBUXBvYBNWomaThbaOmKohB4wQRRv0DDhqA13DCxmxtCs+zJgTR46oEf1Avf0k9i5riy9
	QrbZAoi0cfE3TY/+I8IDqb+OQpUWHbu/2BhsTjC5ETNBXwfk9QyRmZpv1moTaRWEL7urGFI+dPZ
	/oCFwYgRaSEElMlC+ajVPJaQcO+NRYBXLTY2ccH7tEhQKIePFBIYAEHCyed+klhiSzjXhBYuh2g
	+7ROJ5ZNZqqh4YlZ79PBQDsat8DYIASShwIXA5aSZLOOxBvpHlxV23Ciu4dMUQ==
X-Received: by 2002:a05:6402:4302:b0:5e5:827d:bb1c with SMTP id 4fb4d7f45d1cf-5eb80fa41c6mr2675999a12.25.1742390774224;
        Wed, 19 Mar 2025 06:26:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUtpdb4r2CtbTyHsr8WLwRcIUuXEpJ1mxKBLWGBT+tn/rPN0UQLhFx+xPQA07eNa19/oKOAQ==
X-Received: by 2002:a05:6402:4302:b0:5e5:827d:bb1c with SMTP id 4fb4d7f45d1cf-5eb80fa41c6mr2675817a12.25.1742390772409;
        Wed, 19 Mar 2025 06:26:12 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-53.retail.telecomitalia.it. [79.53.30.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e81692e583sm9064993a12.16.2025.03.19.06.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 06:26:11 -0700 (PDT)
Date: Wed, 19 Mar 2025 14:26:04 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] vsock/virtio_transport_common: handle netns of
 received packets
Message-ID: <6iepaq4rqd65lhpqfpplzurwkezdyrjolijrz4feqakh3ghbjy@fxoiw5yiyzp3>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-2-84bffa1aa97a@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250312-vsock-netns-v2-2-84bffa1aa97a@gmail.com>

On Wed, Mar 12, 2025 at 01:59:36PM -0700, Bobby Eshleman wrote:
>From: Stefano Garzarella <sgarzare@redhat.com>
>
>This patch allows transports that use virtio_transport_common
>to specify the network namespace where a received packet is to
>be delivered.
>
>virtio_transport and vhost_transport, for now, still do not use this
>capability and preserve old behavior.

What about vsock_loopback?

>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
>V1 -> V2
> * use vsock_global_net()
> * add net to skb->cb
> * forward port for skb
>---
> drivers/vhost/vsock.c                   |  1 +
> include/linux/virtio_vsock.h            |  2 ++
> net/vmw_vsock/virtio_transport.c        |  1 +
> net/vmw_vsock/virtio_transport_common.c | 11 ++++++++++-
> 4 files changed, 14 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 802153e230730bdbfbbb6f4ae263ae99502ef532..02e2a3551205a4398a74a167a82802d950c962f6 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -525,6 +525,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> 			continue;
> 		}
>
>+		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();

I'd add an helper for that.

Or, can we avoid that and pass the net parameter to 
virtio_transport_recv_pkt()?

> 		total_len += sizeof(*hdr) + skb->len;
>
> 		/* Deliver to monitoring devices all received packets */
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 0387d64e2c66c69dd7ab0cad58db5cf0682ad424..e51f89559a1d92685027bf83a62c7b05dd9e566d 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -12,6 +12,7 @@
> struct virtio_vsock_skb_cb {
> 	bool reply;
> 	bool tap_delivered;
>+	struct net *net;
> 	u32 offset;
> };
>
>@@ -148,6 +149,7 @@ struct virtio_vsock_pkt_info {
> 	u32 remote_cid, remote_port;
> 	struct vsock_sock *vsk;
> 	struct msghdr *msg;
>+	struct net *net;
> 	u32 pkt_len;
> 	u16 type;
> 	u16 op;
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f0e48e6911fc46cba87f7dafeb8dbc21421df254..163ddfc0808529ad6dda7992f9ec48837dd7337c 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -650,6 +650,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
>
> 			virtio_vsock_skb_rx_put(skb);
> 			virtio_transport_deliver_tap_pkt(skb);
>+			VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();
> 			virtio_transport_recv_pkt(&virtio_transport, skb);
> 		}
> 	} while (!virtqueue_enable_cb(vq));
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 256d2a4fe482b3cb938a681b6924be69b2065616..028591a5863b84059b8e8bbafd499cb997a0c863 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -314,6 +314,8 @@ static struct sk_buff *virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *
> 					 info->flags,
> 					 zcopy);
>
>+	VIRTIO_VSOCK_SKB_CB(skb)->net = info->net;
>+
> 	return skb;
> out:
> 	kfree_skb(skb);
>@@ -523,6 +525,7 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -1061,6 +1064,7 @@ int virtio_transport_connect(struct vsock_sock *vsk)
> 	struct virtio_vsock_pkt_info info = {
> 		.op = VIRTIO_VSOCK_OP_REQUEST,
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -1076,6 +1080,7 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
> 			 (mode & SEND_SHUTDOWN ?
> 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -1102,6 +1107,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
> 		.msg = msg,
> 		.pkt_len = len,
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -1139,6 +1145,7 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
> 		.op = VIRTIO_VSOCK_OP_RST,
> 		.reply = !!skb,
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	/* Send RST only if the original pkt is not a RST pkt */
>@@ -1159,6 +1166,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 		.op = VIRTIO_VSOCK_OP_RST,
> 		.type = le16_to_cpu(hdr->type),
> 		.reply = true,
>+		.net = VIRTIO_VSOCK_SKB_CB(skb)->net,
> 	};
> 	struct sk_buff *reply;
>
>@@ -1476,6 +1484,7 @@ virtio_transport_send_response(struct vsock_sock *vsk,
> 		.remote_port = le32_to_cpu(hdr->src_port),
> 		.reply = true,
> 		.vsk = vsk,
>+		.net = sock_net(sk_vsock(vsk)),
> 	};
>
> 	return virtio_transport_send_pkt_info(vsk, &info);
>@@ -1590,7 +1599,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 			       struct sk_buff *skb)
> {
> 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>-	struct net *net = vsock_global_net();
>+	struct net *net = VIRTIO_VSOCK_SKB_CB(skb)->net;
> 	struct sockaddr_vm src, dst;
> 	struct vsock_sock *vsk;
> 	struct sock *sk;
>
>-- 
>2.47.1
>


