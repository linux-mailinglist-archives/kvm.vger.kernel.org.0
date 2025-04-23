Return-Path: <kvm+bounces-43870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03406A97D70
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 05:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 797CC188DB07
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 03:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF26B26A1DE;
	Wed, 23 Apr 2025 03:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGaqsG5v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9632690CF
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 03:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745377897; cv=none; b=tQKRddUiZ1vOi6NN9QGSS/UDOpj8kOVK7AhLPJ0sOnmpu55hYn0koanl6yQBx8q/1v3UI5gsCZS0MZ/8IdVpI+qKCU6+FKVr0tE98R9MvGRQtMKE54hTvgG0YTBt71AM/Bxw+m23+0uQO9eVaRdfckcB725CelAC/OfwgrvfIFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745377897; c=relaxed/simple;
	bh=7NgBY2/M7RX3ZWIExGTnoM9nMea+0yUh7UHHWuhJ4Bk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qmTkQc+S9eyLSxRf87BsDK56U4hA4+gXGPX+6nedLgdaCgplNO0xz2SDXGb3w0x+jAhhUZxdi/mw3O3ci9Neuo5Lh9EHkqZBHfMIHf/NpVJkd8Qg8zoXK63MxqeSADt6ETYpa+6GbIrdebbBpvJp1w3Qm/kY6+lpo1I02PYyKPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGaqsG5v; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so5254638a91.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 20:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745377895; x=1745982695; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm+KUe9Ww/e6Vyl6aeeJ+DObwsjW8ys4qGoTcP5xOok=;
        b=EGaqsG5vWidGv4rsXVCHRSZbHizRtNQAFDxvniO4rf0BluOWPsVw2tvXL9+c2D5KHK
         b4CzxFtZlMXG0Grf1BAwjGerI2cRbog6C6QJ1X7P5psJM1ZfNeqFv9Ida6+a35uhUjtH
         h4doUAaeSH5FcKApej4T+G9cdxVnfas6edNnbgy9XxKQyCriJJZNU0+Xb0r5KEzgESgv
         gni5r/6YOQFwVRqd2w/FKUcnfjCY3hehwU7uVLObLpl/y+O69ngddZa0OlZeqX3fldG3
         5smzlzdnHMemY/GsuHfIW2yHeqbsLpH3vPMX9WDfSDDRVWjeCma2EyD5gz6iX5TTfdXM
         lwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745377895; x=1745982695;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dm+KUe9Ww/e6Vyl6aeeJ+DObwsjW8ys4qGoTcP5xOok=;
        b=F3kh1uLR2emZdN9YX5Dywe0Q0O6MvnSNL5A00DUHx5lYglWb7Qb09PlZYQaQp0nEVh
         raZRX83SsjJtw5QLR2EiRQzzVH1nnVd2ecQDRI8Oe6UrCDdkiU9y/qwpLsoKxVbWJQLv
         07ucZBonh+B0sC5djGW32zx/H7HqDddyXqtLTeFTzGbT+KUXas0u/QDzPa6KN9X2h/p7
         7gfMk7H9t0nmIDr69Lf6/5Qy0hrzgD0supgBHpMFsvXUsr4FxQO0zCr6dULspvUTUOcn
         e9LD8MYQGL5UEqQ1Msv+AGbMBveQTzmaKoafM0SAjfqiUnFFRBun6QXjd08z0kNpNfbn
         yW8g==
X-Forwarded-Encrypted: i=1; AJvYcCWS0BWSVDID9qvpn9fTF7Q0uVa6lNROfJ5+PtpHM1zYOTe+q+tVNWhfic4MkVw04Ux48PY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRMhDmwsphMzVLJYciDWoUvHamXuJ/xUAube3OyWPARMqw9vmT
	jszLe2uRwVyX7/VCTyAiPawqu53BNfFdHKQ7uGVn6Y/hVp0/DCvTn35gDsF6TnBgKsCJUpWYJNj
	vh8uuVVvuw5eMO8dRTuD2Cw==
X-Google-Smtp-Source: AGHT+IHcL6V0wyIgxVPnSh9oujNfZm6xJMeeDAKJGJjxgwUzV9Gxqtp5X/qnGnjnB3+ge4ifRPfAJCgtsn2xzhI6TA==
X-Received: from pjvv13.prod.google.com ([2002:a17:90b:588d:b0:2fc:aac:e580])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2411:b0:2f9:d9fe:e72e with SMTP id 98e67ed59e1d1-3087bb6ba95mr25794082a91.16.1745377894793;
 Tue, 22 Apr 2025 20:11:34 -0700 (PDT)
Date: Wed, 23 Apr 2025 03:11:15 +0000
In-Reply-To: <20250423031117.907681-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250423031117.907681-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250423031117.907681-9-almasrymina@google.com>
Subject: [PATCH net-next v10 8/9] net: check for driver support in netmem TX
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

We should not enable netmem TX for drivers that don't declare support.

Check for driver netmem TX support during devmem TX binding and fail if
the driver does not have the functionality.

Check for driver support in validate_xmit_skb as well.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>

---

v8:
- Rebase on latest net-next and resolve conflict.
- Remove likely (Paolo)

v5: https://lore.kernel.org/netdev/20250227041209.2031104-8-almasrymina@google.com/
- Check that the dmabuf mappings belongs to the specific device the TX
  is being sent from (Jakub)

v4:
- New patch

---
 net/core/dev.c         | 34 ++++++++++++++++++++++++++++++++--
 net/core/devmem.h      |  6 ++++++
 net/core/netdev-genl.c |  7 +++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d1a8cad0c99c4..66f0c122de80e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3896,12 +3896,42 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
+static struct sk_buff *validate_xmit_unreadable_skb(struct sk_buff *skb,
+						    struct net_device *dev)
+{
+	struct skb_shared_info *shinfo;
+	struct net_iov *niov;
+
+	if (likely(skb_frags_readable(skb)))
+		goto out;
+
+	if (!dev->netmem_tx)
+		goto out_free;
+
+	shinfo = skb_shinfo(skb);
+
+	if (shinfo->nr_frags > 0) {
+		niov = netmem_to_net_iov(skb_frag_netmem(&shinfo->frags[0]));
+		if (net_is_devmem_iov(niov) &&
+		    net_devmem_iov_binding(niov)->dev != dev)
+			goto out_free;
+	}
+
+out:
+	return skb;
+
+out_free:
+	kfree_skb(skb);
+	return NULL;
+}
+
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
 	netdev_features_t features;
 
-	if (!skb_frags_readable(skb))
-		goto out_kfree_skb;
+	skb = validate_xmit_unreadable_skb(skb, dev);
+	if (unlikely(!skb))
+		goto out_null;
 
 	features = netif_skb_features(skb);
 	skb = validate_xmit_vlan(skb, features);
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 67168aae5e5b3..919e6ed28fdcd 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -229,6 +229,12 @@ net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
 {
 	return NULL;
 }
+
+static inline struct net_devmem_dmabuf_binding *
+net_devmem_iov_binding(const struct net_iov *niov)
+{
+	return NULL;
+}
 #endif
 
 #endif /* _NET_DEVMEM_H */
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 292606df834de..84c033574eb16 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -979,6 +979,13 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock_netdev;
 	}
 
+	if (!netdev->netmem_tx) {
+		err = -EOPNOTSUPP;
+		NL_SET_ERR_MSG(info->extack,
+			       "Driver does not support netmem TX");
+		goto err_unlock_netdev;
+	}
+
 	binding = net_devmem_bind_dmabuf(netdev, DMA_TO_DEVICE, dmabuf_fd,
 					 info->extack);
 	if (IS_ERR(binding)) {
-- 
2.49.0.805.g082f7c87e0-goog


