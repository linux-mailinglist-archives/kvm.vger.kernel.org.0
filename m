Return-Path: <kvm+bounces-40893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E02A5EC66
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FF34189E568
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF27202F6D;
	Thu, 13 Mar 2025 07:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="F/CrAVk8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6393202961
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849324; cv=none; b=EMTw4tjCqTrFIUY39cTWjXSg9AH/1xcqwmQBCL38yzt6q823Kk1KDgEnTdpKoY1pynnivrYD0DgOzyMI2H/r896Di9Q9+G8LkQxOjI2BwiKBD/2+oOn4hiE+hNB0VvNyHCcKSsm7KCSVATb3wucrhh99ZchfZKN2Rk4ZUlwoYGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849324; c=relaxed/simple;
	bh=HCjJw4xyhEzQ6zT8qCsmgUzt1olFBpZX2ZwL4amUYp0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=EEENYOfqiiL4l6HsNlzZKdx9yR9h2/olkK3i/L+kov6jg+uM7pASCbwuf9o/qk1/RpjSMo1pCZl5o7NhQ9q/eL10Q3nV1QKOFQViWemlwU8XFnWWnt0vnoPeOGU9WeM//IrrrBsfmXhH/TVNdMmSWa0Q6wrUtqzNG2JsXjM3ssI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=F/CrAVk8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2feb91a25bdso1135671a91.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 00:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849322; x=1742454122; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UkGikd/Ad/tPfmKfWOKmNpfe6xZfSLW8Y3eIuF8D5nY=;
        b=F/CrAVk8xN1b3CJ5BbtJjJjQzf3qL7RZFEAOgHE/oeNDFmHTkBAgzgjNq66Lc2ipyo
         96xPRPjxeNqbMs38Cv/Ej96T9Hd6j9GaZnyhfYqTvorYdTDlhGVdaLg20ei7gMAZULOM
         b4aMpNDDSnrJTk9CfFHEqhDCVeoxKczcCX5oqZcClXKr3V+eHEzvYSrPYGCYMFvj3Tf+
         EyXgxBslmcdTn8cbfFyjAW5GkkwgWyfNK3CP7fhkKBkCFx0n45OA6MeLYtSXZ+Uy9Hwc
         4H9U7tWy24yClf5VxOyxDKW/sJW61jN6BD8gtKe3XGTjtd7nEARaSX+SY9+By/fHdbSY
         2FnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849322; x=1742454122;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UkGikd/Ad/tPfmKfWOKmNpfe6xZfSLW8Y3eIuF8D5nY=;
        b=Jr2P3rHSfoW3/WpH3LgJrvSxMjDP2wwfFOoZoVSBN1kG0H044hMHBIiuR3BqslYJyw
         F7UulQtvZPa1T08bha1Vq/ga48tqDRsZO/uFZRgAtMWvWTF7E+0uATcDFNmKpYyTPnTn
         3trBmXgOoFjaLdLomNZfeuh6MTTWfNWiijN5yr57rVzQCPNsf49Gu+JLAyI6GL8ZCkH8
         8512us1qFUfxpHVuVGCXprinC/67LTlEjovmfqebaMUfMQNYeGB0DdbrM3Y8zpNRZu6c
         L/nTcb3efP6gxcxX1Qdo8Klxot1WG58EF0lkaJGNVFTJ6vrJsvNJAN/GWdA8OrPK5keu
         jmEw==
X-Forwarded-Encrypted: i=1; AJvYcCVqasDtuR+ZJ6gBMj/b1xWZ2qUbpVtz5MKFE8j2ln7SYmWGw9iNau9RZzBENoq4REmKmNw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyMt+0F6RUckHfvf1BzWspQPVt6h0LB8LVMpsfzr2acIlA1N4+
	30bj8/0gmOSmB/RrlX0cPDzidoW7sGQoY1GDGE03ZELzFkLkCR4G+NkUNIzk/fg=
X-Gm-Gg: ASbGncsq4FOhkP6hQbsWVw5vFNEGWaasYTn+a/SYeWh5WrA4eDczk8KlP0ftZHORijW
	6H5ylFCs3yJzqhBd62XY1TyY58TG7b3LDBptjWGkUuLeIuCIGd1+VCRInwiLPkE01s44fPojLJz
	C7+URhIaiBi0koK9stn6PVbSIDuVn/ERCOsa2gMXqKEJVIG3I85rkyG53G0hJiGtDVxGQu3vpPU
	vateyS/DtXCTt0usNVQxcvjR9uexCS7JZYpZKxV4AdkAyca7iwMkm83yidjM/twTtp2YEvAWD3K
	v1LKuofO2mRZv5Q4vSnvplXpDt+oaRaegxIRFJvpwZAfqqtP
X-Google-Smtp-Source: AGHT+IHTpYDPSLT5yc7d72SDsCx1rUk7tGT6u0RLi/zmklDJcrhUC3W1KPTvb1y0wV1IhmZnoguH1A==
X-Received: by 2002:a17:90b:1c83:b0:2fe:a77b:d97e with SMTP id 98e67ed59e1d1-300ff0cadb2mr14806388a91.11.1741849321996;
        Thu, 13 Mar 2025 00:02:01 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3010342f135sm3173081a91.1.2025.03.13.00.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 00:02:01 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 16:01:09 +0900
Subject: [PATCH net-next v10 06/10] tap: Introduce virtio-net hash feature
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-rss-v10-6-3185d73a9af0@daynix.com>
References: <20250313-rss-v10-0-3185d73a9af0@daynix.com>
In-Reply-To: <20250313-rss-v10-0-3185d73a9af0@daynix.com>
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

Add ioctls and storage required for the virtio-net hash feature to TAP.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tap.c      | 60 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/if_tap.h |  2 ++
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 25c60ff2d3f2..86b5e7b88614 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -49,6 +49,10 @@ struct major_info {
 	struct list_head next;
 };
 
+struct tap_skb_cb {
+	struct virtio_net_hash hash;
+};
+
 #define GOODCOPY_LEN 128
 
 static const struct proto_ops tap_socket_ops;
@@ -179,9 +183,20 @@ static void tap_put_queue(struct tap_queue *q)
 	sock_put(&q->sk);
 }
 
+static struct tap_skb_cb *tap_skb_cb(const struct sk_buff *skb)
+{
+	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(struct tap_skb_cb));
+	return (struct tap_skb_cb *)skb->cb;
+}
+
+static struct virtio_net_hash *tap_add_hash(struct sk_buff *skb)
+{
+	return &tap_skb_cb(skb)->hash;
+}
+
 static const struct virtio_net_hash *tap_find_hash(const struct sk_buff *skb)
 {
-	return NULL;
+	return &tap_skb_cb(skb)->hash;
 }
 
 /*
@@ -194,6 +209,7 @@ static const struct virtio_net_hash *tap_find_hash(const struct sk_buff *skb)
 static struct tap_queue *tap_get_queue(struct tap_dev *tap,
 				       struct sk_buff *skb)
 {
+	struct flow_keys_basic keys_basic;
 	struct tap_queue *queue = NULL;
 	/* Access to taps array is protected by rcu, but access to numvtaps
 	 * isn't. Below we use it to lookup a queue, but treat it as a hint
@@ -201,17 +217,47 @@ static struct tap_queue *tap_get_queue(struct tap_dev *tap,
 	 * racing against queue removal.
 	 */
 	int numvtaps = READ_ONCE(tap->numvtaps);
+	struct tun_vnet_hash_container *vnet_hash = rcu_dereference(tap->vnet_hash);
 	__u32 rxq;
 
+	*tap_skb_cb(skb) = (struct tap_skb_cb) {
+		.hash = { .report = VIRTIO_NET_HASH_REPORT_NONE }
+	};
+
 	if (!numvtaps)
 		goto out;
 
 	if (numvtaps == 1)
 		goto single;
 
+	if (vnet_hash) {
+		if ((vnet_hash->common.flags & TUN_VNET_HASH_RSS)) {
+			rxq = tun_vnet_rss_select_queue(numvtaps, vnet_hash, skb, tap_add_hash);
+			queue = rcu_dereference(tap->taps[rxq]);
+			goto out;
+		}
+
+		if (!skb->l4_hash && !skb->sw_hash) {
+			struct flow_keys keys;
+
+			skb_flow_dissect_flow_keys(skb, &keys, FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+			rxq = flow_hash_from_keys(&keys);
+			keys_basic = (struct flow_keys_basic) {
+				.control = keys.control,
+				.basic = keys.basic
+			};
+		} else {
+			skb_flow_dissect_flow_keys_basic(NULL, skb, &keys_basic, NULL, 0, 0, 0,
+							 FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+			rxq = skb->hash;
+		}
+	} else {
+		rxq = skb_get_hash(skb);
+	}
+
 	/* Check if we can use flow to select a queue */
-	rxq = skb_get_hash(skb);
 	if (rxq) {
+		tun_vnet_hash_report(vnet_hash, skb, &keys_basic, rxq, tap_add_hash);
 		queue = rcu_dereference(tap->taps[rxq % numvtaps]);
 		goto out;
 	}
@@ -998,6 +1044,16 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 		rtnl_unlock();
 		return ret;
 
+	case TUNGETVNETHASHCAP:
+		return tun_vnet_ioctl_gethashcap(argp);
+
+	case TUNSETVNETHASH:
+		rtnl_lock();
+		tap = rtnl_dereference(q->tap);
+		ret = tap ? tun_vnet_ioctl_sethash(&tap->vnet_hash, argp) : -EBADFD;
+		rtnl_unlock();
+		return ret;
+
 	case SIOCGIFHWADDR:
 		rtnl_lock();
 		tap = tap_get_tap_dev(q);
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 553552fa635c..7334c46a3f10 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -31,6 +31,7 @@ static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
 #define MAX_TAP_QUEUES 256
 
 struct tap_queue;
+struct tun_vnet_hash_container;
 
 struct tap_dev {
 	struct net_device	*dev;
@@ -43,6 +44,7 @@ struct tap_dev {
 	int			numqueues;
 	netdev_features_t	tap_features;
 	int			minor;
+	struct tun_vnet_hash_container __rcu *vnet_hash;
 
 	void (*update_features)(struct tap_dev *tap, netdev_features_t features);
 	void (*count_tx_dropped)(struct tap_dev *tap);

-- 
2.48.1


