Return-Path: <kvm+bounces-40857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D985DA5E61E
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A90D17CCAD
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 21:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738CC1F30CC;
	Wed, 12 Mar 2025 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k67LCi76"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F1B1F17E5;
	Wed, 12 Mar 2025 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741813184; cv=none; b=CvXWNvfcO2b4R+dI6cwWQQelCQvbZzy124jkTtOu9g/0jfQKcgY3KHzBAZjVqZ2ITLhGK6YaC9G5ZSajpBNSaevQYv2ZT5NDiKR/Xz0Mk8TFA6RgvU8+2lnrhQovXUosTI+nCVf++1E+MVpRC7DmewT1Jo5YexwTf5i3E8mwuck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741813184; c=relaxed/simple;
	bh=jSOiqzU7LgYk7s3hBpAEWXR6XXPObJfDqvsKHjg2btI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XyAQEwIhkSNHD6RxcwY7wdUeKSBQNnuEk3fCfC0RYT8qVxJDAw8Nnq3UQrPNSoVtnSz/RKzA+QDWX8kLd9YdP5StDpIvVFcXMIdXLbyC8nnktwo/6PE1sa3qsvz/x9BMqYm65zWM5h11kwcCGBBQHfghn+ePJUo3gHYTh1gPQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k67LCi76; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22334203781so25732505ad.0;
        Wed, 12 Mar 2025 13:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741813182; x=1742417982; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NkAj1CKS6gC9G4Byz4nHeWNr5VsXbnbcZlq4lVa0Tbo=;
        b=k67LCi76KuEvdq8CPBWis56Zh9KBzZXEziXk8PF1bWK3taGeU+93QrJwchjqNa1f7V
         sl+JqPZs5aWKhpOJuEhyhxdrZ0hqVU1sCgr3ir2gnrpLNVX3gCMrZ3UhYDbaJON50tRc
         RNSKsnj0sQHj7EKkAB9dG1SUQxSYVczl8JxKKP71msz6a6d0pfJSPEvEMltA6TMbwUqT
         Pim4Cia5ahuhsb6unMWRljojTbQx8UuY/M3byshIZNiLBdfY1BqpaRoHLWIDfYd180rl
         SKYOPxwDX6UsqQGEJOavIks0Di+ZArtYv/uYtbLViiR34dz/zoMg1mk0PI4cWfiZBe+e
         MV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741813182; x=1742417982;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkAj1CKS6gC9G4Byz4nHeWNr5VsXbnbcZlq4lVa0Tbo=;
        b=fsGiB7YQh1swOCjUY9GOLb7OlW3qs6Twjpk7AqJnIoFhkcSYeLci+FNVrQj/zGJS8c
         KU+oHeJBXvvVFjsOAvtOFeRVakzpLYUdZX7N2//QiE1OzF2GEhfx9Kdf2BtlOJ6jb4nb
         UvKQjAA+AFA961HWPQdC7K4ozGMStjg39VBjp8PpONl3SQh/lLb6a1is2BCG8eD7bVej
         CC7m7+2tBZGbsA6uG6muQS1D7fZ0ymrUDY8BKHNK3x4g7S6dxJXetYCDEWMK92Gwcac+
         2GifUi6ZUXmQRtXuCYWXka8na52QRUHN0aUWe3+WZLvHXo+EpmyA0kRPzvk3jdOo/2f4
         yrYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/pQVhkTui5q8bJqe9m45dcYodN+6i4OZUolXhSPTDbEmPS/fbcWrbI0ZMt0A/RnsmdEGDds/e39hgBKzi@vger.kernel.org, AJvYcCXTb1ShawLouX23OB6KKNa9k/iZGmzU1yyC8Zn6J2O+Nr/RShbaAv/vCHaCZOf2cjtBCCg=@vger.kernel.org, AJvYcCXY7IpYY3JvS+1hsJIwFfydLcWlfHyISY7bkFzUc3C0Qz+jKavb5QB831cMp9evVxJ02LUtn2Se@vger.kernel.org, AJvYcCXwuxFhZVYeBJVu1BQ061HFQRDAmuwgm2ANiEguNHxFb5Ef4H/uZRtb6uVzzlOaC9qteeRrIk8/QDOoR+zM@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0OB9WqMP/orIz6M9C/M22erUVS59nZL6F1+qTYPt+NK1Uh8b3
	I0G3lwykPq7Ghe/4HZG91rZVpzeUnXbgZ1oHGQHsKomAf/V0WdoW
X-Gm-Gg: ASbGnct/iloSWvK4le99Z2mjK0Y+76GZcgxg0YY9xlN2vnGMUNUmchkotjm+2wkbSGV
	sISRQXRCKgezVFMYpbV6+O4Q+rArPZEo85FMCFAvlfLsCKqbwPTH63AnXHS/ylSS/4h5a8wRQtV
	hstNNx8C4SU1B9WV/5GIh0qoIxV6bCMdf10XCLEToWqR8FsrjK6F2tsR1c5dVGvGluOyqT1PLSM
	IXBentwoLXLh89FD/1Eu4/R8NZ+MWp2Jq4agTvZiS43MtKjf+kmxJ/9xnbNqgjHhaVue64Zirzb
	B/PvicWL3DuGRtgWb2bdt8mGmFo/X5O1/TR+FCM0sA==
X-Google-Smtp-Source: AGHT+IG2WeNoJMTPTLJVZix48mNFgtFi81bCQiANCHHziaLLADPcNI7nV831oKin4G0DythBHW6eVg==
X-Received: by 2002:a05:6a00:3c96:b0:736:3ea8:4813 with SMTP id d2e1a72fcca58-737106ec2fbmr40172b3a.2.1741813182223;
        Wed, 12 Mar 2025 13:59:42 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:6::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736b9fe8655sm9773862b3a.2.2025.03.12.13.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 13:59:41 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 12 Mar 2025 13:59:36 -0700
Subject: [PATCH v2 2/3] vsock/virtio_transport_common: handle netns of
 received packets
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-vsock-netns-v2-2-84bffa1aa97a@gmail.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
In-Reply-To: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 Jakub Kicinski <kuba@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
X-Mailer: b4 0.14.2

From: Stefano Garzarella <sgarzare@redhat.com>

This patch allows transports that use virtio_transport_common
to specify the network namespace where a received packet is to
be delivered.

virtio_transport and vhost_transport, for now, still do not use this
capability and preserve old behavior.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
---
V1 -> V2
 * use vsock_global_net()
 * add net to skb->cb
 * forward port for skb
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  2 ++
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 11 ++++++++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 802153e230730bdbfbbb6f4ae263ae99502ef532..02e2a3551205a4398a74a167a82802d950c962f6 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -525,6 +525,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			continue;
 		}
 
+		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();
 		total_len += sizeof(*hdr) + skb->len;
 
 		/* Deliver to monitoring devices all received packets */
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0387d64e2c66c69dd7ab0cad58db5cf0682ad424..e51f89559a1d92685027bf83a62c7b05dd9e566d 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,7 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	struct net *net;
 	u32 offset;
 };
 
@@ -148,6 +149,7 @@ struct virtio_vsock_pkt_info {
 	u32 remote_cid, remote_port;
 	struct vsock_sock *vsk;
 	struct msghdr *msg;
+	struct net *net;
 	u32 pkt_len;
 	u16 type;
 	u16 op;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc46cba87f7dafeb8dbc21421df254..163ddfc0808529ad6dda7992f9ec48837dd7337c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -650,6 +650,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 
 			virtio_vsock_skb_rx_put(skb);
 			virtio_transport_deliver_tap_pkt(skb);
+			VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();
 			virtio_transport_recv_pkt(&virtio_transport, skb);
 		}
 	} while (!virtqueue_enable_cb(vq));
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 256d2a4fe482b3cb938a681b6924be69b2065616..028591a5863b84059b8e8bbafd499cb997a0c863 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -314,6 +314,8 @@ static struct sk_buff *virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *
 					 info->flags,
 					 zcopy);
 
+	VIRTIO_VSOCK_SKB_CB(skb)->net = info->net;
+
 	return skb;
 out:
 	kfree_skb(skb);
@@ -523,6 +525,7 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_CREDIT_UPDATE,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1061,6 +1064,7 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1076,6 +1080,7 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 			 (mode & SEND_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_SEND : 0),
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1102,6 +1107,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1139,6 +1145,7 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.reply = !!skb,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	/* Send RST only if the original pkt is not a RST pkt */
@@ -1159,6 +1166,7 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
+		.net = VIRTIO_VSOCK_SKB_CB(skb)->net,
 	};
 	struct sk_buff *reply;
 
@@ -1476,6 +1484,7 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 		.remote_port = le32_to_cpu(hdr->src_port),
 		.reply = true,
 		.vsk = vsk,
+		.net = sock_net(sk_vsock(vsk)),
 	};
 
 	return virtio_transport_send_pkt_info(vsk, &info);
@@ -1590,7 +1599,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 			       struct sk_buff *skb)
 {
 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
-	struct net *net = vsock_global_net();
+	struct net *net = VIRTIO_VSOCK_SKB_CB(skb)->net;
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
 	struct sock *sk;

-- 
2.47.1


