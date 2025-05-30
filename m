Return-Path: <kvm+bounces-48072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6D2AC8785
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 06:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E3533A853C
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 04:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E128721ABB9;
	Fri, 30 May 2025 04:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="CV3TSHii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34A621578D
	for <kvm@vger.kernel.org>; Fri, 30 May 2025 04:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748580651; cv=none; b=qcFe7nMNkTQ+JumhA7w+vT0PcfdqssvltHPjKCDBeOkTJq+iHpnIQSAj3vxEz7iokPnXJYuQv9ZMQWi0ooTWeV67SbI92RnoYJmEyIU54janbc0EwJC/aTTSwN5x2Cyb1p1cxEeHuhenarmCEds2Df7/AUh4IS67deBNtnWqgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748580651; c=relaxed/simple;
	bh=vXBLYAWx+KT8NixkiW+nmAmAP6uEmWPDiyypcFhaZWY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=aDLOjgEUfoHc/ZG8IDdFwTNsoMWlJOHe53XbPgPmlZlacK8HBq9WN4twrGNX1EbgXT6uw44zJ8PTGhybGO4GZvIVi0nNKDcU7OJ9rCxZvSIL3Aa07lc89gWHcw77SCjhyKawXrsWWoDOapGh8NMZJDLndAbtrZCqN5GfL6BW6H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=CV3TSHii; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2350fc2591dso9572515ad.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 21:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1748580648; x=1749185448; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bke5K22c3HD9w23wmyNQv3eteVxt8661CPm0yQIUlGQ=;
        b=CV3TSHiiy/PAYpWIwEH4fxABUSk2ozOglgsCzJ5B+QhWFdPkhbXu8pvJ47F+fvzf6e
         faa3uU2PqLAUudehmtn25v+SsRFuCqhOI7jz5RAjVc+ntgtFvIqtCqN4yg4OARgOqgYa
         7J7rjdrNgmBiuXmseqFZmhjDetvjuSna7G4TE/NCRaEU5Eiaw01Qgh8xe7HN89W7U4Ek
         8q8kQBTiT2fbUKeXV0w9EYJ0NgsUeZqSOC8msWP5S2glVfVgU51WQRSOV0K19BwrJeKg
         VMc1UxRBdSbqvVAF6SlxFcnOBJL0+d6OR7CIgS1DiIJbVkUigDlF15RoYjbm3sxaChTT
         zx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748580648; x=1749185448;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bke5K22c3HD9w23wmyNQv3eteVxt8661CPm0yQIUlGQ=;
        b=Tz2GRnJMjI6SOurp9d1xH52d7Vi/nyWf2fFfDVm3hPDrulSS/Tr24Jas03ouiHkjkc
         pWgWbGXkBk8Hx1nX0YkJp1W3siwXDeAPpswGxg086n75SWjKoBe/uZ3pSEWsh+5kIOr2
         vp9K5EE4Fx10OrPxc/C0uGFKzFU4Dtbe19+zc7kSO9xRAfzcN4cPfBnWMpICW745EZU5
         WtBDi5XOQ+BqGkffYLY3CW1Z81oSPwsaNWL52h8by3D0pzOGJu4MPGoCjbA7TyUCGbzH
         7lpKyGBAUcBK3+XfJKRtvtBWhRQD+rn4G7puz0vZzoqQVodvCA+GQumx9bj7uBEG5XEw
         OqiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwsKHoY1Pcj2OHCKrBKhZLw0FeRTJkWzuGLcrqSXZSTer+vjtTnocDmPuQGD/KUj87IeU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRpcM4ZC4nJE9TnZ3pPe1Sr/ClaWl9GMdeTJXXyfSetKhJwPpw
	m2kpDJntB7dWurxodT75/wulA4TiuFDjSFW2D/fL918V7TF4idajUCrlHQ3Ck/oSi7s=
X-Gm-Gg: ASbGncuau5jCZIH2vDNppYiOTvr1V07IwuzJtFEHcqpi2v3IaO17cNBGaNYZkIoSKJ+
	hrrl9i+5HEldHZFu8BPasrwqFNWDge0Sjplh27i3daz5BiNZ8gYZLUc4B5p/2nf0/o9kbSwH3A8
	BHvJ9SQ+MVzr79Pi0ijlz5C9wRTSm/7XxGY1/748yD5Ncet/Si1CGI5kCYBe7TWuOZ7rYrq75Z7
	ypSD/LzEAl3C3TZv5IGqDbN3A2ap/RHLX2Ax2j2rKkTZTTMQEa/CQSVTCNognTr9osntvNtCtN+
	fqO13ohOjN/uka3IWaELngCUDGGogyHr/D83vDJMLAfs6qTL6r02cKyZn5jHgEA=
X-Google-Smtp-Source: AGHT+IGSd69oFRRuK4lTduVM0ZF5zNmM4jyAvZgQPgB6jq6cdPe4LXym+7JQTROU4ygX8AexHC9tJQ==
X-Received: by 2002:a17:902:e84a:b0:215:58be:3349 with SMTP id d9443c01a7336-2352b06d218mr31860065ad.14.1748580648014;
        Thu, 29 May 2025 21:50:48 -0700 (PDT)
Received: from localhost ([157.82.128.1])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-23506bc889csm20244645ad.15.2025.05.29.21.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 May 2025 21:50:47 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 30 May 2025 13:50:09 +0900
Subject: [PATCH net-next v12 05/10] tun: Introduce virtio-net hash feature
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250530-rss-v12-5-95d8b348de91@daynix.com>
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

Add ioctls and storage required for the virtio-net hash feature to TUN.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/Kconfig    |  1 +
 drivers/net/tun.c      | 56 ++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/skbuff.h |  3 +++
 net/core/skbuff.c      |  4 ++++
 4 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1fd5acdc73c6..aecfd244dd83 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -395,6 +395,7 @@ config TUN
 	tristate "Universal TUN/TAP device driver support"
 	depends on INET
 	select CRC32
+	select SKB_EXTENSIONS
 	help
 	  TUN/TAP provides packet reception and transmission for user space
 	  programs.  It can be viewed as a simple Point-to-Point or Ethernet
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 03d47799e9bd..0a34db248e03 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -209,6 +209,7 @@ struct tun_struct {
 	struct bpf_prog __rcu *xdp_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
+	struct tun_vnet_hash __rcu *vnet_hash;
 	struct ethtool_link_ksettings link_ksettings;
 	/* init args */
 	struct file *file;
@@ -451,9 +452,14 @@ static inline void tun_flow_save_rps_rxhash(struct tun_flow_entry *e, u32 hash)
 		e->rps_rxhash = hash;
 }
 
+static struct virtio_net_hash *tun_add_hash(struct sk_buff *skb)
+{
+	return skb_ext_add(skb, SKB_EXT_TUN_VNET_HASH);
+}
+
 static const struct virtio_net_hash *tun_find_hash(const struct sk_buff *skb)
 {
-	return NULL;
+	return skb_ext_find(skb, SKB_EXT_TUN_VNET_HASH);
 }
 
 /* We try to identify a flow through its rxhash. The reason that
@@ -462,14 +468,21 @@ static const struct virtio_net_hash *tun_find_hash(const struct sk_buff *skb)
  * the userspace application move between processors, we may get a
  * different rxq no. here.
  */
-static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
+static u16 tun_automq_select_queue(struct tun_struct *tun,
+				   const struct tun_vnet_hash *vnet_hash,
+				   struct sk_buff *skb)
 {
+	struct flow_keys keys;
+	struct flow_keys_basic keys_basic;
 	struct tun_flow_entry *e;
 	u32 txq, numqueues;
 
 	numqueues = READ_ONCE(tun->numqueues);
 
-	txq = __skb_get_hash_symmetric(skb);
+	memset(&keys, 0, sizeof(keys));
+	skb_flow_dissect(skb, &flow_keys_dissector_symmetric, &keys, 0);
+
+	txq = flow_hash_from_keys(&keys);
 	e = tun_flow_find(&tun->flows[tun_hashfn(txq)], txq);
 	if (e) {
 		tun_flow_save_rps_rxhash(e, txq);
@@ -478,6 +491,13 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 		txq = reciprocal_scale(txq, numqueues);
 	}
 
+	keys_basic = (struct flow_keys_basic) {
+		.control = keys.control,
+		.basic = keys.basic
+	};
+	tun_vnet_hash_report(vnet_hash, skb, &keys_basic, skb->l4_hash ? skb->hash : txq,
+			     tun_add_hash);
+
 	return txq;
 }
 
@@ -513,8 +533,15 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 	u16 ret;
 
 	rcu_read_lock();
-	if (!tun_ebpf_select_queue(tun, skb, &ret))
-		ret = tun_automq_select_queue(tun, skb);
+	if (!tun_ebpf_select_queue(tun, skb, &ret)) {
+		struct tun_vnet_hash *vnet_hash = rcu_dereference(tun->vnet_hash);
+
+		if (vnet_hash && vnet_hash->rss)
+			ret = tun_vnet_rss_select_queue(READ_ONCE(tun->numqueues), vnet_hash,
+							skb, tun_add_hash);
+		else
+			ret = tun_automq_select_queue(tun, vnet_hash, skb);
+	}
 	rcu_read_unlock();
 
 	return ret;
@@ -2235,6 +2262,7 @@ static void tun_free_netdev(struct net_device *dev)
 	security_tun_dev_free_security(tun->security);
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
 	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
+	kfree_rcu_mightsleep(rcu_access_pointer(tun->vnet_hash));
 }
 
 static void tun_setup(struct net_device *dev)
@@ -3014,16 +3042,22 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	} else {
 		memset(&ifr, 0, sizeof(ifr));
 	}
-	if (cmd == TUNGETFEATURES) {
+	switch (cmd) {
+	case TUNGETFEATURES:
 		/* Currently this just means: "what IFF flags are valid?".
 		 * This is needed because we never checked for invalid flags on
 		 * TUNSETIFF.
 		 */
 		return put_user(IFF_TUN | IFF_TAP | IFF_NO_CARRIER |
 				TUN_FEATURES, (unsigned int __user*)argp);
-	} else if (cmd == TUNSETQUEUE) {
+
+	case TUNSETQUEUE:
 		return tun_set_queue(file, &ifr);
-	} else if (cmd == SIOCGSKNS) {
+
+	case TUNGETVNETHASHTYPES:
+		return tun_vnet_ioctl_gethashtypes(argp);
+
+	case SIOCGSKNS:
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 		return open_related_ns(&net->ns, get_net_ns);
@@ -3264,6 +3298,12 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		ret = open_related_ns(&net->ns, get_net_ns);
 		break;
 
+	case TUNSETVNETREPORTINGAUTOMQ:
+	case TUNSETVNETREPORTINGRSS:
+	case TUNSETVNETRSS:
+		ret = tun_vnet_ioctl_sethash(&tun->vnet_hash, cmd, argp);
+		break;
+
 	default:
 		ret = tun_vnet_ioctl(&tun->vnet_hdr_sz, &tun->flags, cmd, argp);
 		break;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bb2b751d274a..cdd793f1c360 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4842,6 +4842,9 @@ enum skb_ext_id {
 #endif
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	SKB_EXT_MCTP,
+#endif
+#if IS_ENABLED(CONFIG_TUN)
+	SKB_EXT_TUN_VNET_HASH,
 #endif
 	SKB_EXT_NUM, /* must be last */
 };
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b1c81687e9d8..75d48217a20f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -64,6 +64,7 @@
 #include <linux/mpls.h>
 #include <linux/kcov.h>
 #include <linux/iov_iter.h>
+#include <linux/virtio_net.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -4969,6 +4970,9 @@ static const u8 skb_ext_type_len[] = {
 #if IS_ENABLED(CONFIG_MCTP_FLOWS)
 	[SKB_EXT_MCTP] = SKB_EXT_CHUNKSIZEOF(struct mctp_flow),
 #endif
+#if IS_ENABLED(CONFIG_TUN)
+	[SKB_EXT_TUN_VNET_HASH] = SKB_EXT_CHUNKSIZEOF(struct virtio_net_hash),
+#endif
 };
 
 static __always_inline unsigned int skb_ext_total_length(void)

-- 
2.49.0


