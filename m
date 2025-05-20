Return-Path: <kvm+bounces-47086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D65ABD242
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:46:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEE5A1B646DB
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 08:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F0264A9F;
	Tue, 20 May 2025 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/I3lHaq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECD7213E66
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747730776; cv=none; b=FAYtycLHdynAsdr71YA26HF1wUGbodwHq3Jw4/qaZLboCHvpsErY/AWkPEPL4/JnaMOAyxEqIb6+x872nOnugpq06R2KwPj5+8FpYDfeHuOq/F59ig3OMTkmOw9QEHKNd1+7xNy4P2TItAawtZDWPaNNIEG0H4hDgkpF6JZRX88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747730776; c=relaxed/simple;
	bh=8xTFfl67wIQOufxQ/XTxHmawmYTtXy92FH7wmrqBR60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWA1CYV8bnJnUG4HzYbvwhnnehDljAXQ2/AB7d2v/TjMUqvwWmsbZlT+A1oN14clcLLYJ0yq7v19tSM6tVpx0Bn2EBmmJXiQgGDhaiXt3+tByYH/cbRs1SK7vDMUBRB5dvpvLHHeZtlAQMDM+Bnubo7463BBHCt85ZrU3xaMjRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/I3lHaq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747730772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UOPxyI8xvsODmW2CXsEeAiOYmTmUpftyoQUfAgolB4o=;
	b=g/I3lHaqgMkL95SxwMON+Yb930f53bDS3ZSrZYvwNKTlrCFzdHtTf7BXzJRVPl/eRUFIWp
	gkUP1tFS7muVSY21D5+8ZzzICYlpQgLPwxfjmNxoRn54wWwmKWihOWW1WczX6o1GCD05eW
	vK8tyxgRX8rrmWkhKyP9PzaAqeI8AHo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-s3s8DA1-OoWboaQ-tShwpg-1; Tue, 20 May 2025 04:46:11 -0400
X-MC-Unique: s3s8DA1-OoWboaQ-tShwpg-1
X-Mimecast-MFC-AGG-ID: s3s8DA1-OoWboaQ-tShwpg_1747730770
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-acbbb0009aeso95896166b.1
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 01:46:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747730770; x=1748335570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UOPxyI8xvsODmW2CXsEeAiOYmTmUpftyoQUfAgolB4o=;
        b=NTj9nTGij6+Qzknc1QQSNYJZgJKUN1LmfPlS0EZz2VShNsPtZm6aA6rxLpEHTcDrVi
         8M3YaXrEd4LP4/BPw59c6kJnxl3FPBKTRuEmMgHUyEPYn+bN7W62NV7KCxCsQIujTQrt
         YaHNEllrOpzhLCEADIKM9v6yVhgHUuYk+iIUnAsRwyLc66wtM1etfdXKjw4gTgv47xSa
         1GvnG1Te46DbWIaH1/nCtLbyDzKUatKZEBDjJV3kUYtWRopfGxG3huPR8aMSIfmX2/X/
         uQlyU2647uadc9c/f2sc5CY1lHUcpV7jiMoOFQu2YWLWldckk6hFT1y0CHNjr4g1lyCq
         7eAA==
X-Forwarded-Encrypted: i=1; AJvYcCUFQqDWTDwtmf4ICTZ7mQiKgWB3shDIlb9ad4o6amdK6/gqz8ZSafgY7Za4DVvtMTm6q84=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1NcblQyPYHfzY0pxXpJX2u8h/Ds1v+/l4l+SC8bQSC8hBBDDB
	XG0iaPef/8heHAUjX8PHAmsCCjDWXc2NShPlv2gVteEEjMCoBI62qMZUH7wqda5gibdu7vse/41
	vrrV3Qk8nSLq5n1L6C8Nod6E1gNY50Il2+IhZ+2KzhyWPOk8aKp+Nqg==
X-Gm-Gg: ASbGncvQ5QkfOfhQ2yBimfmdefNSTUkQQ6rr4sbHP8hDG8OgDS04fFljS6Z7Ry1EXVJ
	v9TOpfm8TLcXnhlPtfDAQej0UkMo30U3SIEUCipl466iRQN40XcgT7gIyo8/rPwkwKP7d5jwsKu
	BfXSAv6mKe1B1VJG+SRTEIFxUlZhfxGlV/vE1YaYu8+j2eB+Dohy8PDE6Mm3tyKz7aER7EgI3Kn
	Gh/q4XvUeMrQZgrK7bg4//b9HYeghLJVLqhdOiBKgrajjUDy4rehJxYOUkt1rB9042xSfjajGh2
	87v2IyodmTLGipDNGqFUoejSKl0zVWJk6L9AKO7xE/hDVrr6iOqythxtxNnb
X-Received: by 2002:a17:907:d8b:b0:ad5:719d:3e88 with SMTP id a640c23a62f3a-ad5719d5958mr608963866b.44.1747730770008;
        Tue, 20 May 2025 01:46:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhQGUr9rfzMJHGnlV8hllI6xbhRlkYFydEwrW3ZoqExjBDhlLpqKETdyFe+3K/njihrbep/Q==
X-Received: by 2002:a17:907:d8b:b0:ad5:719d:3e88 with SMTP id a640c23a62f3a-ad5719d5958mr608959666b.44.1747730769386;
        Tue, 20 May 2025 01:46:09 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d06dc99sm702438566b.62.2025.05.20.01.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 01:46:08 -0700 (PDT)
Date: Tue, 20 May 2025 10:46:03 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: mst@redhat.com, fupan.lfp@antgroup.com, pabeni@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, davem@davemloft.net, 
	stefanha@redhat.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio
 based transports
Message-ID: <ca3jkuttkt3yfdgcevp7s3ejrxx3ngkoyuopqw2k2dtgsqox7w@fhicoics2kiv>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
 <20250519070649.3063874-3-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250519070649.3063874-3-niuxuewei.nxw@antgroup.com>

On Mon, May 19, 2025 at 03:06:48PM +0800, Xuewei Niu wrote:
>The virtio_vsock_sock has a new field called bytes_unread as the return
>value of the SIOCINQ ioctl.
>
>Though the rx_bytes exists, we introduce a bytes_unread field to the
>virtio_vsock_sock struct. The reason is that it will not be updated
>until the skbuff is fully consumed, which causes inconsistency.
>
>The byte_unread is increased by the length of the skbuff when skbuff is
>enqueued, and it is decreased when dequeued.
>
>Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
>---
> drivers/vhost/vsock.c                   |  1 +
> include/linux/virtio_vsock.h            |  2 ++
> net/vmw_vsock/virtio_transport.c        |  1 +
> net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |  1 +
> 5 files changed, 22 insertions(+)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 802153e23073..0f20af6e5036 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
> 		.unsent_bytes             = virtio_transport_unsent_bytes,
>+		.unread_bytes             = virtio_transport_unread_bytes,
>
> 		.read_skb = virtio_transport_read_skb,
> 	},
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 0387d64e2c66..0a7bd240113a 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
> 	u32 buf_alloc;
> 	struct sk_buff_head rx_queue;
> 	u32 msg_count;
>+	size_t bytes_unread;

Can we just use `rx_bytes` field we already have?

Thanks,
Stefano

> };
>
> struct virtio_vsock_pkt_info {
>@@ -195,6 +196,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
> u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
>
> ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
>+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk);
>
> void virtio_transport_consume_skb_sent(struct sk_buff *skb,
> 				       bool consume);
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index f0e48e6911fc..917881537b63 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -585,6 +585,7 @@ static struct virtio_transport virtio_transport = {
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
> 		.unsent_bytes             = virtio_transport_unsent_bytes,
>+		.unread_bytes             = virtio_transport_unread_bytes,
>
> 		.read_skb = virtio_transport_read_skb,
> 	},
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d88096..11eae88c60fc 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -632,6 +632,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	free_space = vvs->buf_alloc - fwd_cnt_delta;
> 	low_rx_bytes = (vvs->rx_bytes <
> 			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>+	vvs->bytes_unread -= total;
>
> 	spin_unlock_bh(&vvs->rx_lock);
>
>@@ -782,6 +783,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 		}
>
> 		virtio_transport_dec_rx_pkt(vvs, pkt_len);
>+		vvs->bytes_unread -= pkt_len;
> 		kfree_skb(skb);
> 	}
>
>@@ -1132,6 +1134,19 @@ ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
>
>+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	size_t ret;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+	ret = vvs->bytes_unread;
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(virtio_transport_unread_bytes);
>+
> static int virtio_transport_reset(struct vsock_sock *vsk,
> 				  struct sk_buff *skb)
> {
>@@ -1365,6 +1380,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		goto out;
> 	}
>
>+	vvs->bytes_unread += len;
>+
> 	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
> 		vvs->msg_count++;
>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 6e78927a598e..13a77db2a76f 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -99,6 +99,7 @@ static struct virtio_transport loopback_transport = {
> 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>
> 		.unsent_bytes             = virtio_transport_unsent_bytes,
>+		.unread_bytes             = virtio_transport_unread_bytes,
>
> 		.read_skb = virtio_transport_read_skb,
> 	},
>-- 
>2.34.1
>


