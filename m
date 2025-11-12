Return-Path: <kvm+bounces-62850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81133C50CDB
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDE3118898B6
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D8A2F60DA;
	Wed, 12 Nov 2025 06:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKxvZ3+e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FFB2E62D1
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930544; cv=none; b=X1/IHCSc8L0omG9852Zx81efzz6tI+94dfK2g3NTWVK5KpinVAf+aJ2xYIxyDipgLwIvd21L/ZxA86/YttSmnhpAuWfacRuL9FWqnSAyclzJjlP5OpRHEM3Vglb49eW0b3a6EWJMhGhDvAF2JuGmbG7xNZT9yv/S6xAUbFm2VEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930544; c=relaxed/simple;
	bh=veSnw3IGQ71cxIlqHypTONN3gf5WNTEJruTN4Lb14qA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=K/D/0DVjtpp5JOndSXvuGU6CHb9AkPiMLkx/SkEyYJH2vB7Y0jDsqUfHNwo1nmV03u1csTvsiUT6aK/i2ylFOItR9WV+y/aheIAz8CvWXI5bWcBB5Tagt/v/GVUJ3JvHmxdcaA7IijvmzOCaMO4yZmlR8chsY2XyhPez2n4zAjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKxvZ3+e; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-79af647cef2so445596b3a.3
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930539; x=1763535339; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3POWcPl845f0o8duse0G0nccbWINBqqIKArZonruJ3I=;
        b=AKxvZ3+emhexl6EvJ0PznWdaDfGlMXSNlezSMQGEMSl83uWyDoc2tC+ZqjdEZjhPpy
         0XkRNl9pxZdRDCJOdp2n6SFIY/w+Kit7uM7ngC+9LQWRfRvE9PHvsyGbk6wx9qbU8WyE
         XBZlie25BFi5m/w9cOLEQ2R2uzQoIL1aRlaChiqOapuB9lcWtDgdWTen3DhUcSXR1UrX
         fxY+BaLFyqz6WzOZMOmlU469bFtemFP2KGhBDYXTgK6ltBD1XBeaFPry1zL8oshGgYaB
         YsbsEl+QwtkbiStp9bPp9dWcl21kWvyl4Xz6Yn0RsKBAq+e3KbWj9QRZkpwAaEbN2v9G
         g2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930539; x=1763535339;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3POWcPl845f0o8duse0G0nccbWINBqqIKArZonruJ3I=;
        b=Wfz1/Qv1OzapGlrKOGE7i5o8b8+ATWjzXSDaUncGIGoN7LqVVftZgmbzBpcHk3Tdbp
         7dNk7dA/t9z/PtEqROH44LdtSsmyybnD9m3En6Y9X9VEn9Vll/LUnMa5Osgq22sAyLFC
         KvyqLk2Q7wy7+y66o8uJerOFaoynD6gsOxwe1B1GondFdHr1YkBiABUVORv5N+HRr2j4
         cMnCfuyWXfEzrPMbPycAooRLRLeYkwRQqeTrEhAnCEYyHmh3iXUWgt3bgsUajwA4UUtz
         BJwFRpfo75lcEtGWNenBM0wJn/LX1+VFhh2T6qzyBCZEMZGJz3mSEk0VwWJsxj32m2T/
         cw0A==
X-Forwarded-Encrypted: i=1; AJvYcCVJcKfSaF4zcPu9JJQ+MtwSSnC2ulDRsgj8s7f7VxGxHfEzGOu7F+6boaLXPnXsMGT7zGE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIGXXv87zXkVWyx0WYB01FRMfnYQryWX4R35xbV4p1XJVOUoW6
	V9jms1OQdaoyN+9yFQrYxJD5r6sRArJIKJdmdX+FxQB4dnP2pvptJFli
X-Gm-Gg: ASbGncuQlSyQlWLL5xoI0vc0k3RU3XvYH8m42F6SqEa2eVvx4EXV33VEj4p4AQFLn41
	EwzMsJcUqezjSUxVeC3GACzRJQo2EGeVYOm6PFm0fe86ONBu+/m4rClqtR4hIfZjJR9cJqIfV8E
	a8Yt6vRc8bh90pYk6Obm+vMgfxwjEgdr/UABLvhTj6eTyi6/W6pxK5kVXre4LJSWcvZGJighcdV
	GMVRuWTKGJRfqhBmHBqxACdwScePf9zEE8qUs7YEnHgpJPxImjJ2J/5h79VcXoAuriMFcXQ7FGw
	stFT6l7ZL7R7od1p3KvOczmiPmhpeSvHABz7P6m83xMH02xktku5AXyT6cQCFfoxJJ7bAdZN0Fr
	PpjVGe64hOtqzOCwmBjS4JLtquev4u7Paq1d26rModqekxmx2rCM7UXNay78VnBwqDCLUl1a4
X-Google-Smtp-Source: AGHT+IHHvidQKHevYduW37onhvCFlT+u0IEMiGDYOLRIvORJFfiefLF1h5W5O7IoFAvmqwigA4o2NQ==
X-Received: by 2002:a05:6a20:12cb:b0:334:8239:56dc with SMTP id adf61e73a8af0-3590b820767mr2885613637.56.1762930539480;
        Tue, 11 Nov 2025 22:55:39 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e07d2e5esm1357244a91.17.2025.11.11.22.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:39 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:47 -0800
Subject: [PATCH net-next v9 05/14] vsock: add netns and netns_tracker to
 vsock skb cb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-5-852787a37bed@meta.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
In-Reply-To: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
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
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add a net pointer, netns_tracker, and net_mode to the vsock skb and
helpers for getting/setting them. These fields are only used by
vsock_loopback in order to avoid net-related race conditions (more info
in the loopback patch).

This extends virtio_vsock_skb_cb to 32 bytes (with
CONFIG_NET_DEV_REFCNT_TRACKER=y):

struct virtio_vsock_skb_cb {
	struct net *               net;                  /*     0     8 */
	netns_tracker              ns_tracker;           /*     8     8 */
	enum vsock_net_mode        net_mode;             /*    16     4 */
	u32                        offset;               /*    20     4 */
	bool                       reply;                /*    24     1 */
	bool                       tap_delivered;        /*    25     1 */

	/* size: 32, cachelines: 1, members: 6 */
	/* padding: 6 */
	/* last cacheline: 32 bytes */
};

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v9:
- update commit message to specify usage by loopback only
- add comment in virtio_vsock_skb_cb mentioning usage by vsock_loopback
- add ns_tracker to skb->cb
- removed Stefano's Reviewed-by trailer due to ns_tracker addition (not
  sure if this is the right process thing to do)

Changes in v7:
- rename `orig_net_mode` to `net_mode`
- update commit message with a more complete explanation of changes

Changes in v5:
- some diff context change due to rebase to current net-next
---
 include/linux/virtio_vsock.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 18deb3c8dab3..a3ef752cdb95 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -10,6 +10,10 @@
 #define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
 
 struct virtio_vsock_skb_cb {
+	/* net, net_mode, and ns_tracker are only used by vsock_loopback. */
+	struct net *net;
+	netns_tracker ns_tracker;
+	enum vsock_net_mode net_mode;
 	u32 offset;
 	bool reply;
 	bool tap_delivered;
@@ -130,6 +134,35 @@ static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
 	return (size_t)(skb_end_pointer(skb) - skb->head);
 }
 
+static inline struct net *virtio_vsock_skb_net(struct sk_buff *skb)
+{
+	return VIRTIO_VSOCK_SKB_CB(skb)->net;
+}
+
+static inline void virtio_vsock_skb_set_net(struct sk_buff *skb, struct net *net)
+{
+	get_net_track(net, &VIRTIO_VSOCK_SKB_CB(skb)->ns_tracker, GFP_KERNEL);
+	VIRTIO_VSOCK_SKB_CB(skb)->net = net;
+}
+
+static inline void virtio_vsock_skb_clear_net(struct sk_buff *skb)
+{
+	put_net_track(VIRTIO_VSOCK_SKB_CB(skb)->net,
+		      &VIRTIO_VSOCK_SKB_CB(skb)->ns_tracker);
+	VIRTIO_VSOCK_SKB_CB(skb)->net = NULL;
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


