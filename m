Return-Path: <kvm+bounces-47208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71129ABE989
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 04:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BE251BC0276
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 02:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875142563;
	Wed, 21 May 2025 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="etw4p+/W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334F322B590;
	Wed, 21 May 2025 02:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793220; cv=none; b=KK6rfJvORs/qYZ4sr4cEqXdXCjdsywa6B62UwZWQ/HTfXNgeiuG8hmyp9Tbt9BaOPnvIW6BvgkJQ2aPxbXJCHLaso035RfT17/IaS3ZYR3wbjaC7Dt45NW2rZoGkbduwJ5vK5ywWMr1cf9LJlOvz5/ERnwmXWfOr3VMDIBmyjR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793220; c=relaxed/simple;
	bh=eDiuI3z+StyXxjxF60mHre1iz/7y2ALZU3Hh8faxdSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mhjI3lj/kxsgat9DJZ2Fovlc5thXhvFzTqAaD2Wk7+5gLalDsnzbzHqYdtkIJYZX4Lweu1fvKaBOkp0EEeJkTrnig+tya7LtF0njHaQfTe9reO5WpsJLjxuQsGb2/eYR/hkYMfnkz+yBxZfSvR6VxPSNgA9R+MsN88724Un//w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=etw4p+/W; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-30e8daea8c6so3818972a91.0;
        Tue, 20 May 2025 19:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747793218; x=1748398018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evybLe1RFldzEa/JWUY1Zsp1A/NYOkUMYIY9syWhpzA=;
        b=etw4p+/WDfbdlOLd6uEMlcl6pemgOF8HwzHzSDbuSzOgF5ONfRp8rhgMMkhbO9kIfI
         wUIKQSWZagSxN2V4Jcbe54ENsHts3yPgz9sCq6OuMn7bsYp1ziVgynZ0r0fjFce+8aDr
         LG23PrlwMTjDtsY74ah54XFZ20WgE2jnyWBiS5FD1kl0qYlZQUJuKvLQLHYGJ0M/+WyZ
         Z34yxCwxLS1wF6ukj33evcIWkzvBBt0MlUUxpxCS5XGNRpF3m+OVTHuNhc4ii8qBwrs+
         3nIF8CSU5+u18XW5auZxVZYHUMuUXThMso8CIUX1PN107DPi7OURSBitS9rBd7dv04QO
         YoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747793218; x=1748398018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=evybLe1RFldzEa/JWUY1Zsp1A/NYOkUMYIY9syWhpzA=;
        b=YgccWV3yzoGzTlXSE8kx0IJgzcIg6XjxUpN35wWRRGu+Li06u5fEOAwKuvlJ0Xr6zl
         Ao4z1hJNjmPC0QLrEIa3+7CWMgAufOngztMa5Eb7zTrHGvbvOH/YUeTt4NgJIBq32KcO
         nec7+Za1uocFnI+ZHNdsvgS/pe0FVK2/wUx2wRIPvPLHmx/YtyOZJ0LtFIaLOF6pYB0Y
         +oiioBovb7jsTf8a/c5CIdaENKvpsjIuzif7tyDsenGffhPlKLgFZIIwJhPAnfOwfkmv
         wKh6OIgsWSm0VvjTBOZrD/kplABRK2CezybGnx/fxoT1aNefWbNBiOac/6fioHgbEC37
         zhEw==
X-Forwarded-Encrypted: i=1; AJvYcCUf519h/4xQvorqwmAaMpUeDg4S9H7vCoLi/w1QcJ4sICYsdzR/+7nbl5LSAPplmspvtOhXSXm0AfnHb896@vger.kernel.org, AJvYcCWabzE/FvSaXD/G5MsybdQa8cGq0/rO0VfAqNUqXNpOVpxO1j6l0SySxunUPJeKhuQiAn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyZJ4DZMErL8N1k7T9v4hIyzSfdCh2AOwUMG9tmqUHi2TzzSZn
	xymh2ShgyKFq3OqEv1Z3HLEauJRt6CJ9b+P24GkFnO+2O2rbb9OKLm+ERyyPLqCfReA=
X-Gm-Gg: ASbGncveWgvgai+eZ9isB4Oiwn2R7D3sZBioYnByXkiJoKeRKqTRWdnnneNIHiU3DcX
	0XOmZdzHaq0/VsMwRmbZEg8+lBl+Vi2ibJ+/VPODDNTFAaAXBtPwj3IglkRV23IU/cVV8uU4lKX
	Rind93Lk2fy+7ZHDHOucJRKxdYLqcbdS6yK316d6B8ViAfHRPHdg0CbYg6YMK80ggZ6AoGn3K37
	cenU5Z1GAZ0urLWp3tvsB+TxT2LdtfXdS5vqJIlY5IGFM8LzafHcmAIiAiWJfTgG/AiSyQh4Nl8
	mHaszNjEXlZ1qJ9QX7u8kHb6gMJsFoaBhEIfknsV1yFSNbO9/Fq/Dt2Ic3uwueGMKH2vYrCu+ti
	XZj67pGbZ
X-Google-Smtp-Source: AGHT+IEtJa+FEy9+iP3DTw3YUCmsDT7guXE169CweQO2aQ3bUVogZ8gEBvRjenMHE2QtOrmzx/hG2g==
X-Received: by 2002:a17:90b:254a:b0:2ef:31a9:95c6 with SMTP id 98e67ed59e1d1-30e7d52b08dmr31528262a91.14.1747793218110;
        Tue, 20 May 2025 19:06:58 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f364fffbdsm2468011a91.34.2025.05.20.19.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 19:06:57 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio based transports
Date: Wed, 21 May 2025 10:06:13 +0800
Message-Id: <20250521020613.3218651-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ca3jkuttkt3yfdgcevp7s3ejrxx3ngkoyuopqw2k2dtgsqox7w@fhicoics2kiv>
References: <ca3jkuttkt3yfdgcevp7s3ejrxx3ngkoyuopqw2k2dtgsqox7w@fhicoics2kiv>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, May 19, 2025 at 03:06:48PM +0800, Xuewei Niu wrote:
> >The virtio_vsock_sock has a new field called bytes_unread as the return
> >value of the SIOCINQ ioctl.
> >
> >Though the rx_bytes exists, we introduce a bytes_unread field to the
> >virtio_vsock_sock struct. The reason is that it will not be updated
> >until the skbuff is fully consumed, which causes inconsistency.
> >
> >The byte_unread is increased by the length of the skbuff when skbuff is
> >enqueued, and it is decreased when dequeued.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > drivers/vhost/vsock.c                   |  1 +
> > include/linux/virtio_vsock.h            |  2 ++
> > net/vmw_vsock/virtio_transport.c        |  1 +
> > net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
> > net/vmw_vsock/vsock_loopback.c          |  1 +
> > 5 files changed, 22 insertions(+)
> >
> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >index 802153e23073..0f20af6e5036 100644
> >--- a/drivers/vhost/vsock.c
> >+++ b/drivers/vhost/vsock.c
> >@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
> > 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> >
> > 		.unsent_bytes             = virtio_transport_unsent_bytes,
> >+		.unread_bytes             = virtio_transport_unread_bytes,
> >
> > 		.read_skb = virtio_transport_read_skb,
> > 	},
> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >index 0387d64e2c66..0a7bd240113a 100644
> >--- a/include/linux/virtio_vsock.h
> >+++ b/include/linux/virtio_vsock.h
> >@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
> > 	u32 buf_alloc;
> > 	struct sk_buff_head rx_queue;
> > 	u32 msg_count;
> >+	size_t bytes_unread;
> 
> Can we just use `rx_bytes` field we already have?
> 
> Thanks,
> Stefano

I perfer not. The `rx_bytes` won't be updated until the skbuff is fully
consumed, causing inconsistency issues. If it is acceptable to you, I'll
reuse the field instead.

Thanks,
Xuewei

> > };
> >
> > struct virtio_vsock_pkt_info {
> >@@ -195,6 +196,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
> > u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
> >
> > ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
> >+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk);
> >
> > void virtio_transport_consume_skb_sent(struct sk_buff *skb,
> > 				       bool consume);
> >diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >index f0e48e6911fc..917881537b63 100644
> >--- a/net/vmw_vsock/virtio_transport.c
> >+++ b/net/vmw_vsock/virtio_transport.c
> >@@ -585,6 +585,7 @@ static struct virtio_transport virtio_transport = {
> > 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> >
> > 		.unsent_bytes             = virtio_transport_unsent_bytes,
> >+		.unread_bytes             = virtio_transport_unread_bytes,
> >
> > 		.read_skb = virtio_transport_read_skb,
> > 	},
> >diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >index 7f7de6d88096..11eae88c60fc 100644
> >--- a/net/vmw_vsock/virtio_transport_common.c
> >+++ b/net/vmw_vsock/virtio_transport_common.c
> >@@ -632,6 +632,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> > 	free_space = vvs->buf_alloc - fwd_cnt_delta;
> > 	low_rx_bytes = (vvs->rx_bytes <
> > 			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
> >+	vvs->bytes_unread -= total;
> >
> > 	spin_unlock_bh(&vvs->rx_lock);
> >
> >@@ -782,6 +783,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> > 		}
> >
> > 		virtio_transport_dec_rx_pkt(vvs, pkt_len);
> >+		vvs->bytes_unread -= pkt_len;
> > 		kfree_skb(skb);
> > 	}
> >
> >@@ -1132,6 +1134,19 @@ ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
> > }
> > EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
> >
> >+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk)
> >+{
> >+	struct virtio_vsock_sock *vvs = vsk->trans;
> >+	size_t ret;
> >+
> >+	spin_lock_bh(&vvs->rx_lock);
> >+	ret = vvs->bytes_unread;
> >+	spin_unlock_bh(&vvs->rx_lock);
> >+
> >+	return ret;
> >+}
> >+EXPORT_SYMBOL_GPL(virtio_transport_unread_bytes);
> >+
> > static int virtio_transport_reset(struct vsock_sock *vsk,
> > 				  struct sk_buff *skb)
> > {
> >@@ -1365,6 +1380,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> > 		goto out;
> > 	}
> >
> >+	vvs->bytes_unread += len;
> >+
> > 	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
> > 		vvs->msg_count++;
> >
> >diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
> >index 6e78927a598e..13a77db2a76f 100644
> >--- a/net/vmw_vsock/vsock_loopback.c
> >+++ b/net/vmw_vsock/vsock_loopback.c
> >@@ -99,6 +99,7 @@ static struct virtio_transport loopback_transport = {
> > 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
> >
> > 		.unsent_bytes             = virtio_transport_unsent_bytes,
> >+		.unread_bytes             = virtio_transport_unread_bytes,
> >
> > 		.read_skb = virtio_transport_read_skb,
> > 	},
> >-- 
> >2.34.1
> >

