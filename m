Return-Path: <kvm+bounces-46963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCA1ABB592
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 09:07:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08AA416F824
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 07:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF02A2673B9;
	Mon, 19 May 2025 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flZg9Klw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A38E266565;
	Mon, 19 May 2025 07:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747638437; cv=none; b=c9eFrjYz3nAKn22tXVvdWnvf/kiaWAxuyy0vzvFjoUx3cmpyffExLVRJ6F61RBxY7sNpz8HH8jP5BtOTDWG4FslnTeVk26FrMzaKBO8B/6NKj38JUU5Qhw0Q7IeNQutx/We6ksUIQI8qDl+ZCuUQbieeSUrtXe0hBo/kOdkXo8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747638437; c=relaxed/simple;
	bh=o4+xCFenhmp96OI75UNoIQhOcjTBx0Ax3r1tXJ88EXg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fvEAaGSRpuddFzGZfkhIfcYNoXforjyy/jE14ktBMk8ePhM2jF5HqlEzadpDxjwXSas+lvBmshpvmqcH0hPqhW9IaqkiBAbq/s1ehVAHBmOb+hkAPZ0ZAlo431Yyce7ECLfpvN2vujESUyG7E5HKO04MGI8/510G/Wr0fxKOMrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=flZg9Klw; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-30e57a37294so3585836a91.2;
        Mon, 19 May 2025 00:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747638434; x=1748243234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWPdfKtT2OXZLeQL6cLLp0+NSNfqA1Oi993as69qazA=;
        b=flZg9KlwllrTjV104sD42F2EwapOmoHiY5p455thg3WsMnT97TzpUuDpxFimsbVW8k
         CszzPG6EDiPTYO0I+InLqXpnmnfFDh1dZMlNP+30W+FwDQwMkx1lGVWqkrU6ZIwEKndv
         oN6ujoT1MTSFZwqb2GUEsYACAXL8DEkVQCVI6V5fB50WVpHDfqHQ3w/SAQq9RcKvIYie
         8oKRGcg2Qd8X1/u/kvMKn9tIRKDgk50kOfKQI3obk1UH61N2crRFBhOKkQITCYmh47FO
         xYy7jC2u2J2E4oooU8OFd5nx72DQI9kM7a14jvS+bN07XxFIXa/smY1BE31C9I0yxqzz
         kHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747638434; x=1748243234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWPdfKtT2OXZLeQL6cLLp0+NSNfqA1Oi993as69qazA=;
        b=roHIf8qyKVW9z0nt3y9Lz4OpaJAUgKpru91xPakhSWU0cLtN+yIt+Ez3P3EqkSc3nO
         nRTxuBhUMgLR/tNimUHyh2YMTufvLuSMQkbqlScLBlHWI2gRcg7nqciO1oaCH12CsKIh
         LkWhXru7Ts0bYTtQT9aJr/LvFtZVWujmW1lcHy9jaRIK5WR3K36HjsBrfmJPfR8aRMMF
         flw9ZLzhFJ3XGxEoeKayKsIzcHF6fhtLXY/F/+hQgQa1cyTqgnGrZTTD9D4gxnR9i8Pz
         gnGu1lS7R1C1ZPOnoMATTo7Z0HcRUpgOP9x7E5rOXL4SB80wq5Y2kDWIMUF2Y5x2y/7s
         cUTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB4eiw2Nzq9HX6xVtLviT15fDUn3PxQwA1+zLM5rc3tk+ukk4zJVVV8uzeT6CUfbfiu3/80zDnwXpp6vjA@vger.kernel.org, AJvYcCXPk75+0bPZAJI2VeQXewHztsgs9SwteZPwpQMfbyx4iF72vKu+XLo1jGziDRmt3r4/nsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtJpwybiI2Yd25+TRdqdDWhOkJ6ckmAAXeC8066opjYAh+XPNp
	b4tsdrOF2CE4tnP7V22QLwrQM0soLgRoGWHUi6c19/TZJQSlpeU7EmKG
X-Gm-Gg: ASbGncuG2jgMfNKgEYkEm9OMtV6IwOQJ841nkuF1ubffmJ1RecjeoSEPEx98Mu2Cr5+
	p/ZqjS14zotz8+vlH82sA2fI0DABvy16GUalbcu3EHCHrv1O/1gIPeCwKQSHfKe+rLrwoq+wtV2
	OvItMWwTmJEvZTbC+U9WRKilBLQwSrPvc66k/4dcdZSEMsI77XKw5DNKgmU0/wqf7kIYCSx4kjB
	dB3QiAXl0GYiMyMjtoC41lJI8FzefQOMNivrwfaHOJXgNBVFzLmldIRE58MvgpInOZKwCucX1l9
	YWYs+PhFF5l+V/fIPqpWLnnvUheArOvAdstMmTApMJo15n1ylvOMFaOlpZLA12FROqotcUDa6g=
	=
X-Google-Smtp-Source: AGHT+IGAGsvIArGOURC6jETHsXCGSSkCUmd1tqdQbpGNwcsLQuYAUGuTL9uAfECQEQuYsai0/RRvNA==
X-Received: by 2002:a17:90b:55cc:b0:2ee:d63f:d73 with SMTP id 98e67ed59e1d1-30e830ebe05mr20262447a91.11.1747638434394;
        Mon, 19 May 2025 00:07:14 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a0120sm5574336a12.63.2025.05.19.00.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 00:07:13 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	fupan.lfp@antgroup.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH 2/3] vsock/virtio: Add SIOCINQ support for all virtio based transports
Date: Mon, 19 May 2025 15:06:48 +0800
Message-Id: <20250519070649.3063874-3-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
References: <20250519070649.3063874-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The virtio_vsock_sock has a new field called bytes_unread as the return
value of the SIOCINQ ioctl.

Though the rx_bytes exists, we introduce a bytes_unread field to the
virtio_vsock_sock struct. The reason is that it will not be updated
until the skbuff is fully consumed, which causes inconsistency.

The byte_unread is increased by the length of the skbuff when skbuff is
enqueued, and it is decreased when dequeued.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  2 ++
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 17 +++++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  1 +
 5 files changed, 22 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 802153e23073..0f20af6e5036 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0387d64e2c66..0a7bd240113a 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -142,6 +142,7 @@ struct virtio_vsock_sock {
 	u32 buf_alloc;
 	struct sk_buff_head rx_queue;
 	u32 msg_count;
+	size_t bytes_unread;
 };
 
 struct virtio_vsock_pkt_info {
@@ -195,6 +196,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
 ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk);
 
 void virtio_transport_consume_skb_sent(struct sk_buff *skb,
 				       bool consume);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..917881537b63 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -585,6 +585,7 @@ static struct virtio_transport virtio_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d88096..11eae88c60fc 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -632,6 +632,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	free_space = vvs->buf_alloc - fwd_cnt_delta;
 	low_rx_bytes = (vvs->rx_bytes <
 			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
+	vvs->bytes_unread -= total;
 
 	spin_unlock_bh(&vvs->rx_lock);
 
@@ -782,6 +783,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 		}
 
 		virtio_transport_dec_rx_pkt(vvs, pkt_len);
+		vvs->bytes_unread -= pkt_len;
 		kfree_skb(skb);
 	}
 
@@ -1132,6 +1134,19 @@ ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
 
+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	size_t ret;
+
+	spin_lock_bh(&vvs->rx_lock);
+	ret = vvs->bytes_unread;
+	spin_unlock_bh(&vvs->rx_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_unread_bytes);
+
 static int virtio_transport_reset(struct vsock_sock *vsk,
 				  struct sk_buff *skb)
 {
@@ -1365,6 +1380,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		goto out;
 	}
 
+	vvs->bytes_unread += len;
+
 	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count++;
 
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6e78927a598e..13a77db2a76f 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -99,6 +99,7 @@ static struct virtio_transport loopback_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
-- 
2.34.1


