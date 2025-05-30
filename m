Return-Path: <kvm+bounces-48077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB21EAC87A3
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AFC116D5F2
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 04:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCF4225A2C;
	Fri, 30 May 2025 04:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="AWkz7vON"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA88F223DE7
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748580671; cv=none; b=GFg6/8DX2nrEMkRtQTmLIjE2YMGmPG+RjzkaYLRCc9o2uXF+1B2yyijQ6mcxzYBqvyfoY3wUEjYlzOqcuyRjz84dYMRZY5CDQkZJ1kl8R5um5n1ohkKuge7HEed+xg/k8sAMeQ+7E2S4V5RVwp62B+9dr0qGFq4rX/j69fU19nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748580671; c=relaxed/simple;
	bh=lWGVKyybSScfvzAgnxZfdPakMV9WV+eXSxEJF4cb1lY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=Ibs397dOjAxr1N7Hxdjby3KdNFboIFNiT+n4NYJdZcjmRCARWglzOBESepD+urtyGXgCz2wwlYv+GgbQnDN7yj1SzlPQfl8et1QSts2wvHq+U2YrF9UM9o7TdJyYOwB8mxBWg6NP6TVWe66EGEhRTtjFqbA2nz6XbvAAsLeaQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=AWkz7vON; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73c17c770a7so1814614b3a.2
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1748580669; x=1749185469; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z15gseFrGsCaLlozqKPcH2zd7I0guJGS0A9lc7pAtL0=;
        b=AWkz7vONAUKHEJ1BTAsIGd6+oLDDkSLczPChdvQu5ORyUjUBYLo06jokq4YNudLMd0
         cZFWXtDlVdc5pzmsSve234WgkjNFvOezh9bjRcCR+paKjqvLBv2m+BgkJ30lu3+0vbJD
         2AMhCM4e8rCFp6xoWniyyggyVCvKBOoO8EOXONeAVfHyP6iJq2aYs4i7gDstIaEK52Cp
         pHfacsIBbZtr2Gqp11V8OXkI40tcMRcs7SF6QMBCJ344XKw6pxNUDD3r/jTNCpV4CKxo
         9lVs9n/6bFHCm81RS8tI+KQzLTk31WH98vmjTi8kDnoCWzPzPGevHa/P8qio4ArxfuuR
         sVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748580669; x=1749185469;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z15gseFrGsCaLlozqKPcH2zd7I0guJGS0A9lc7pAtL0=;
        b=vtVKOWfvWZ+ra0XmAk6ESTeCMJOzuDmH2b6o86Hy8z6YAFGph3fWjJXFWVkGegSLrw
         0efqk4x7WfT6g+Fwe4vtFHEgX3Twjw0TLW0y3dyqqWO7mRfZjX/M6Krd3EPMpKtrgcpB
         1mpyINzs0JaLxIJBzARUtx2+oDc0FXUPmql5k1RQYU3oTOwYKPIX98PfrhPXsgUIFL+a
         rAWrg1EH0Lm6cNFFq18pJaGBcprgRoTWSoKgl4FRMXk1dlHAL2RYxAPvUKqP0DeZqnEV
         bNh2PtBN5iaMSTkuzLpBhgaLla3dPa3mdMW8R7SGo+liqExEePJywcMGB+alsVRGocPL
         sN+A==
X-Forwarded-Encrypted: i=1; AJvYcCUH+be+XFVEVPesS/wxqhG7kC81pBqSnVks4fn6YCkQQQhbJCOvqcjnymNT/E2Xf0Ean8g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE6nXVhlsL36oYUtISohTG9AEAJ/WyF9himVzjSPWGr9Fah0R5
	JW+A7Q/CrDkf+ZCssYI/y7PsXCrSp/xevwSO2oAoV9wpDoRizO/Ii6YvERS91NRtiLo=
X-Gm-Gg: ASbGnctxH50aWbyrjUf1HJUXUhVHQX1MZk89sAah4LuobH1yQOGI5/zs61+HfK8CnTM
	cvFfbdMaRYDZcVQix3kbcokbV9JlSD1Kffl9nI412v6B7uvB+QyykphZCTRcBzMrha/mKU9VKCN
	sToJoVRc2viC2YF8Ba0uDMcwUbyjTObGtcLD7DlFCAE2DTWOt2GEYmEpFanHYxOEqOB+phexLng
	ZFH2OPHqOv3RXunDczgijbJE369SjC/end4jjXoOl5dQYO3EVJNqolKnF33jk9tQLnPuv3Zyov+
	OxBkMK3ZrDaRiFhPm5CLwswN7FyqedfcvhkJ33Le276n5ZXTPhgM
X-Google-Smtp-Source: AGHT+IFEAyvdh+gmFNHHDHekWEQMYLOTZZa1DYZNnrPSAK+MYRW4HLZI96PlWLiwNkqJ19TNscPw2g==
X-Received: by 2002:a05:6a00:805:b0:736:5b85:a911 with SMTP id d2e1a72fcca58-747bd9658a0mr3200511b3a.8.1748580669233;
        Thu, 29 May 2025 21:51:09 -0700 (PDT)
Received: from localhost ([157.82.128.1])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-747affafa42sm2231166b3a.92.2025.05.29.21.51.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 May 2025 21:51:08 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 30 May 2025 13:50:14 +0900
Subject: [PATCH net-next v12 10/10] vhost/net: Support
 VIRTIO_NET_F_HASH_REPORT
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250530-rss-v12-10-95d8b348de91@daynix.com>
References: <20250530-rss-v12-0-95d8b348de91@daynix.com>
In-Reply-To: <20250530-rss-v12-0-95d8b348de91@daynix.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

VIRTIO_NET_F_HASH_REPORT allows to report hash values calculated on the
host. When VHOST_NET_F_VIRTIO_NET_HDR is employed, it will report no
hash values (i.e., the hash_report member is always set to
VIRTIO_NET_HASH_REPORT_NONE). Otherwise, the values reported by the
underlying socket will be reported.

VIRTIO_NET_F_HASH_REPORT requires VIRTIO_F_VERSION_1.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Lei Yang <leiyang@redhat.com>
---
 drivers/vhost/net.c | 68 +++++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b9b9e9d40951..fc5b43e43a06 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -73,6 +73,7 @@ enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+			 (1ULL << VIRTIO_NET_F_HASH_REPORT) |
 			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 			 (1ULL << VIRTIO_F_RING_RESET)
 };
@@ -1097,10 +1098,6 @@ static void handle_rx(struct vhost_net *net)
 		.msg_controllen = 0,
 		.msg_flags = MSG_DONTWAIT,
 	};
-	struct virtio_net_hdr hdr = {
-		.flags = 0,
-		.gso_type = VIRTIO_NET_HDR_GSO_NONE
-	};
 	size_t total_len = 0;
 	int err, mergeable;
 	s16 headcount;
@@ -1174,11 +1171,15 @@ static void handle_rx(struct vhost_net *net)
 		/* We don't need to be notified again. */
 		iov_iter_init(&msg.msg_iter, ITER_DEST, vq->iov, in, vhost_len);
 		fixup = msg.msg_iter;
-		if (unlikely((vhost_hlen))) {
-			/* We will supply the header ourselves
-			 * TODO: support TSO.
-			 */
-			iov_iter_advance(&msg.msg_iter, vhost_hlen);
+		/*
+		 * Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR
+		 * TODO: support TSO.
+		 */
+		if (unlikely(vhost_hlen) &&
+		    iov_iter_zero(vhost_hlen, &msg.msg_iter) != vhost_hlen) {
+			vq_err(vq, "Unable to write vnet_hdr at addr %p\n",
+			       vq->iov->iov_base);
+			goto out;
 		}
 		err = sock->ops->recvmsg(sock, &msg,
 					 sock_len, MSG_DONTWAIT | MSG_TRUNC);
@@ -1191,30 +1192,24 @@ static void handle_rx(struct vhost_net *net)
 			vhost_discard_vq_desc(vq, headcount);
 			continue;
 		}
-		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
-		if (unlikely(vhost_hlen)) {
-			if (copy_to_iter(&hdr, sizeof(hdr),
-					 &fixup) != sizeof(hdr)) {
-				vq_err(vq, "Unable to write vnet_hdr "
-				       "at addr %p\n", vq->iov->iov_base);
-				goto out;
-			}
-		} else {
-			/* Header came from socket; we'll need to patch
-			 * ->num_buffers over if VIRTIO_NET_F_MRG_RXBUF
-			 */
-			iov_iter_advance(&fixup, sizeof(hdr));
-		}
 		/* TODO: Should check and handle checksum. */
 
+		/*
+		 * We'll need to patch ->num_buffers over if
+		 * VIRTIO_NET_F_MRG_RXBUF or VIRTIO_F_VERSION_1
+		 */
 		num_buffers = cpu_to_vhost16(vq, headcount);
-		if (likely(set_num_buffers) &&
-		    copy_to_iter(&num_buffers, sizeof num_buffers,
-				 &fixup) != sizeof num_buffers) {
-			vq_err(vq, "Failed num_buffers write");
-			vhost_discard_vq_desc(vq, headcount);
-			goto out;
+		if (likely(set_num_buffers)) {
+			iov_iter_advance(&fixup, offsetof(struct virtio_net_hdr_v1, num_buffers));
+
+			if (copy_to_iter(&num_buffers, sizeof(num_buffers),
+					 &fixup) != sizeof(num_buffers)) {
+				vq_err(vq, "Failed num_buffers write");
+				vhost_discard_vq_desc(vq, headcount);
+				goto out;
+			}
 		}
+
 		nvq->done_idx += headcount;
 		if (nvq->done_idx > VHOST_NET_BATCH)
 			vhost_net_signal_used(nvq);
@@ -1607,10 +1602,13 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 	size_t vhost_hlen, sock_hlen, hdr_len;
 	int i;
 
-	hdr_len = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			       (1ULL << VIRTIO_F_VERSION_1))) ?
-			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
-			sizeof(struct virtio_net_hdr);
+	if (features & (1ULL << VIRTIO_NET_F_HASH_REPORT))
+		hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
+	else if (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+			     (1ULL << VIRTIO_F_VERSION_1)))
+		hdr_len = sizeof(struct virtio_net_hdr_mrg_rxbuf);
+	else
+		hdr_len = sizeof(struct virtio_net_hdr);
 	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen = hdr_len;
@@ -1691,6 +1689,10 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		if (features & ~VHOST_NET_FEATURES)
 			return -EOPNOTSUPP;
+		if ((features & ((1ULL << VIRTIO_F_VERSION_1) |
+				 (1ULL << VIRTIO_NET_F_HASH_REPORT))) ==
+		    (1ULL << VIRTIO_NET_F_HASH_REPORT))
+			return -EINVAL;
 		return vhost_net_set_features(n, features);
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_NET_BACKEND_FEATURES;

-- 
2.49.0


