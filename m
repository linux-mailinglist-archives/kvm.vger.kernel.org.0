Return-Path: <kvm+bounces-60761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BE95BF94C6
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 815AC18C8591
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2542D2D6E64;
	Tue, 21 Oct 2025 23:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpaFAJxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3AD136349
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090424; cv=none; b=BHjhNvD6ci4sBRLXUXGRBM7mP3RPP7/D8odA2UnlYJlcZJYxm2zJWOrbSlVOgo43FPyK7zcBlrNN1P+F/MzKUkyGIcOWwxmBBQMI04FxVuTJ6jERur5oX7NhLsKsssrp1p5aLzGyHPjkDYpAkZFwNeojFdWORWchgw+Vzt3y/WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090424; c=relaxed/simple;
	bh=5lT5a275Jig/x0y4MU1RBKKAqav6WdTww5TZeVBwOjY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C3StSxRXbavI6072VElWwGb/hGUlARxMeWZt17OzrcN2ed6Ic1LBXTltV/psq55/9cD7OwlDrPNgJV3V3Vr3LKqj/WnFArQ9ByglHh47tNsn2s7EZhAAof3FPs+75bj+5TNpgwRUQWA6FLjW5FNCptTre3HGSVRajLjvEL0+EsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpaFAJxZ; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-339d53f4960so6369998a91.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090421; x=1761695221; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z8QAc03+caTvAAzxQiYsQ8xN61QvIP62Vy0HUa32Vyw=;
        b=fpaFAJxZILo96dTdXQYE9qtnCzZGvnNfx9C1TGKWaKTTtCljcSQWt7cq0lbPn8L5bK
         Dj14By71004rbyJLs+BpOdTQorjgq9zF9T9YkNu3J0odu5r4T36DNJbYR1hEL0zPPbNN
         0oXkB2kqaZqO8isDfoMDnyPf/yljTJ3uhuG69qgxGIH4A+VcvSCYILTCT9IyUmygzPZ/
         ZUH2QGJxbMZzApyTPtVKqn0F6pkU244es9W+haffDeiwLa5Cntuh6xxVrX3WeclGNPd6
         E0MiDd2O3g0jFRaH0jzBhlFW/o9GH6EeOWqCsaIQSzMnz3CzFw4Rb0Pdojr3/+wrzTs3
         I8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090421; x=1761695221;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8QAc03+caTvAAzxQiYsQ8xN61QvIP62Vy0HUa32Vyw=;
        b=wzhLl+FpfWSpl1iyPzuOjdJoPQfoAeaKMR0eYQZxoVElx1Qx+28VPpEuP9EcVFp2Wi
         VIujPOaGB+dcrg4kguxYgb8MQGFJSkIo0WIp7N/uVZeH3crsPDKQtBTkXqY0TmrW1xGm
         xue3ih7oT4PaFSixZPVdWfuc9byEgYyqUJvC0QiBRqQPeBUKPlCQ716FOyQwufWVSmOU
         7MDLqx3Js1YQiRcMyruvYv/TwGWVnQ/AmqNUVSdp+np+NOE2mFoWU0FnnPcX6tEuMhh3
         H1hB2X0CyypNX2KspbbqLG184JAXAhaelSL7NBeHNek/2cE2BB//53LaaRhwqIYOlGOb
         8LMg==
X-Forwarded-Encrypted: i=1; AJvYcCXc0OwiVz94aGlUcy6f851ohYkruZSPxISU+ahRvLyYjVCjM4BYtP7NOvc0VF2QgVF/rak=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQHbpXfFL7X7gqgijVMCwrRlYREIgxy0xuk7Km+1/8c76zc/Zc
	2RqOWV3lxi4+MqDZI2y9rKKsmnd6kJPuKBmnxc1hg0Pi2sLLS1t7hvOq
X-Gm-Gg: ASbGnctvWFTSpBoSf0E63jAOGVwBTXHVADhINu96HOiRRMO+r+aSfcFYhymr1qJAymf
	JF+r4jz4yULE6EtZ/V5Pd1HWgmL2q18IbbvTp978ne0tU0aO+s5rZ/lRMF/grsA+NmSxWsF1Eve
	+Xe1SEFewJD/zsRpRcX4b9w3NfRpQkle9dT2fGXGKA3N4y7Cp8peLeIctEB1q2+Ohdqu+HQHheo
	T/qAZFMa4xopcTWFL8jcbg3YGLlF6gH1GoE/l1D397ov31pX6DIt9VifSHR3TAZwkBFX0ci5MPx
	ScC5ES7Q8Vjx4HX2t39xsUyXSpOhPoDBixAMMkSs8/H/usEzvb2o/YsJlDPPlR42pzhjpYDg+U4
	73Sy3GcY3MIlmFai6ZMZPmAxRTrQLgO62zEDS+uS5qO9eB9GtxTGHBVrMsM5ZtzKVaUr+dANgR5
	v6D2e+00Y=
X-Google-Smtp-Source: AGHT+IFnLd8MEBHJWDP/6T0bT9CF6tUU40IwqT7WMWTgte724ObVfh7g7Y965ujhPSVyLp4smF4h2g==
X-Received: by 2002:a17:90b:3942:b0:336:bfce:3b48 with SMTP id 98e67ed59e1d1-33bcf87f431mr27158450a91.9.1761090421527;
        Tue, 21 Oct 2025 16:47:01 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:9::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33e22428b1esm708138a91.22.2025.10.21.16.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:47:01 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:46 -0700
Subject: [PATCH net-next v7 03/26] vsock: add netns to vsock skb cb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-3-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
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
X-Mailer: b4 0.13.0

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


