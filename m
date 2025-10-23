Return-Path: <kvm+bounces-60905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C45C02FCB
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC2AE506BC8
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD97350297;
	Thu, 23 Oct 2025 18:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TPRKKDH8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98B734C15C
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244094; cv=none; b=YQa08IYgp/ihScU5Z8gZoGBtSDOUKi+YCWeMPa1/YBbmqwDRfPdscaqVp2OopyqI5sR5WXlfinzKpJ+TU72mhiyKsdf/+eCQo+/SEB/jLgON46SUevIFIb+LiI4Z1QhZgqnc6clAlHsz47UvwDhvM2huEM3KP5yN4cXLgUP+0oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244094; c=relaxed/simple;
	bh=/NnsC3/kyQkEuJK5iOUFqzrZwSnxBzzrLIV6TJlSX58=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SIMvdqua6fTHL73rfHe4ZA+dpNhAQbpRoS4j7Tg6GvGfO0nMLhBoxPZqSJTUH6aGzgp+9nyraN8B/jr/PJ+jRGUd23llpQLrUwpI99AQG2GEgUnZ3s4GUa6c83ApP1oRP9StjLLNiT2uAsyJfjn5A9akNnUX1gzQ3Mfiu+EVyO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TPRKKDH8; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-290b48e09a7so14308465ad.0
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244087; x=1761848887; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t/1b6yRMCqBZzs7tcE4MzTOrQu/agnNRge7CXTKa+MI=;
        b=TPRKKDH8XrBk5rLrPo62mWYsMVyGUT1Dap05tyaLhbEe8BhVhGFYgWX94whDYZI987
         5sXL8jHFGMqdCUXNCoTIWrgxnSWyYN2tctS/AW53U1pKM+VkR1hl1O38k0UCk+PLd7Ik
         Gg1EQh0C80BhpMx8ST+tiQA4O2UIxt5k3lN+gAB4A5+AvPEcrgMLOyb000M3Kz6fcmGY
         qGpSzUtCOVtP1zxyuBsp2y/ywXm/162dCEUpH1+bgZUWRpEeqjk/iN6ClpCNrCrs2WYH
         jIg6eaVV3v4V0EBZOG8LtOABMzphoh9ZYmDdG0O76yF0pqQWnyEUGk6d4DEENKsHh/w8
         6k7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244087; x=1761848887;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/1b6yRMCqBZzs7tcE4MzTOrQu/agnNRge7CXTKa+MI=;
        b=DJRZOPociQdkRiv47DUiyKeHth1a3g86KiBqHCoFqhcjKOyJTCnqEFkBue85oIwz9X
         dlYRKGAqLwygMMclo1j/btQV5DNrdWGHybj/2WyooBIpb61b+sNBQQ+FRwPTfkaaJ5jK
         zwT9gcqBRKJEofm6XOzMSwOlBFv8DtiYhQN+GPzV0Dn9+hBa3P0nzsvJBiedRbZG9aOU
         QPgTOWB6jbl8RoOzgMdIzn4hSNn2SOxFvMa3k4YYrMcVORvuFGRiKhRs0bL1zZTn9DzW
         h0dFvV5mgD2Sqry4rjD1fVIdd7RP4FUY/wxpUNKMmskapALCrVaLhIiUB5DOyc+7ZS1k
         Naig==
X-Forwarded-Encrypted: i=1; AJvYcCXCUaxpNuhuP/bQ/1nQUSu7xoyHmmVFvuCYLlKaxbzOdR3ar6C3aQaWbuP+YrNF1oWmBJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJBcB0MyJEsr2zsQQMeWd8/Ux+xFj/8Kcs0S+lKGZv81kyM1kb
	xPRfCrdXsX1aRhP9KtN7eJOpewwKerTWTgHNJwUpEOPDPbYg2IyC+cgF
X-Gm-Gg: ASbGncvSFYH8V7gmbSSk0h8ZGkddGUiD626RXOM5yFeqSpnUHK4o2bKPTPDbAwbAivF
	OtfWo1lM84alP1Yvifz9jyixPOpECIDie96nPSvLUVF8GdZPE0F9Chlro3hvTa9+W5lWGwtDdft
	X1jM1XtmvSZQn7djhrLWBYT03Qkg1X2HA7qJznu30ZR2R3GX05yTm6LLqzCaQ0DSjDj8PtGu5V8
	Ls+Wgj+xiu6iFILi06/btyUiK9UL81aJKddPxVz+zDojKsQKHC8mp64BBH1Nq1xciajuID4mErR
	z6/ibk6W7tIWndA+mNDHU+QaqiL2tuIcOaJ5zIuZGnY5474ACk8YeNzkA5eV0PCjEjC3y7BcHrd
	TkbFyD83CorSLy0CovGCTC1J82xwmPhyXBxj+6TKCVKR268/OYyGhUp0Pbfze4GOWNyKq6gXEhU
	zyWCG/eWkH
X-Google-Smtp-Source: AGHT+IGRrKHIe8i2PewhMjRBhP1W+eQCJR1uY99As6NL8XQQmuNG2L450IKTPePeAvu2qClkS7Jbsg==
X-Received: by 2002:a17:902:dad2:b0:293:e5f:85b7 with SMTP id d9443c01a7336-2930e5f9113mr89467435ad.11.1761244086676;
        Thu, 23 Oct 2025 11:28:06 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:73::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e0f06d5sm30959555ad.82.2025.10.23.11.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:28:06 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 23 Oct 2025 11:27:42 -0700
Subject: [PATCH net-next v8 03/14] vsock: add netns to vsock skb cb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-vsock-vmtest-v8-3-dea984d02bb0@meta.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
In-Reply-To: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add a net pointer and net_mode to the vsock skb and helpers for
getting/setting them. When skbs are received the transport needs a way
to tell the vsock layer and/or virtio common layer which namespace and
what namespace mode the packet belongs to. This will be used by those
upper layers for finding the correct socket object. This patch stashes
these fields in the skb control buffer.

This extends virtio_vsock_skb_cb to 24 bytes:

struct virtio_vsock_skb_cb {
	struct net *               net;                  /*     0     8 */
	enum vsock_net_mode        net_mode;        /*     8     4 */
	u32                        offset;               /*    12     4 */
	bool                       reply;                /*    16     1 */
	bool                       tap_delivered;        /*    17     1 */

	/* size: 24, cachelines: 1, members: 5 */
	/* padding: 6 */
	/* last cacheline: 24 bytes */
};

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v7:
- rename `orig_net_mode` to `net_mode`
- update commit message with a more complete explanation of changes

Changes in v5:
- some diff context change due to rebase to current net-next
---
 include/linux/virtio_vsock.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 87cf4dcac78a..7f334a32133c 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -10,6 +10,8 @@
 #define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
 
 struct virtio_vsock_skb_cb {
+	struct net *net;
+	enum vsock_net_mode net_mode;
 	u32 offset;
 	bool reply;
 	bool tap_delivered;
@@ -130,6 +132,27 @@ static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
 	return (size_t)(skb_end_pointer(skb) - skb->head);
 }
 
+static inline struct net *virtio_vsock_skb_net(struct sk_buff *skb)
+{
+	return VIRTIO_VSOCK_SKB_CB(skb)->net;
+}
+
+static inline void virtio_vsock_skb_set_net(struct sk_buff *skb, struct net *net)
+{
+	VIRTIO_VSOCK_SKB_CB(skb)->net = net;
+}
+
+static inline enum vsock_net_mode virtio_vsock_skb_net_mode(struct sk_buff *skb)
+{
+	return VIRTIO_VSOCK_SKB_CB(skb)->net_mode;
+}
+
+static inline void virtio_vsock_skb_set_net_mode(struct sk_buff *skb,
+						      enum vsock_net_mode net_mode)
+{
+	VIRTIO_VSOCK_SKB_CB(skb)->net_mode = net_mode;
+}
+
 /* Dimension the RX SKB so that the entire thing fits exactly into
  * a single 4KiB page. This avoids wasting memory due to alloc_skb()
  * rounding up to the next page order and also means that we

-- 
2.47.3


