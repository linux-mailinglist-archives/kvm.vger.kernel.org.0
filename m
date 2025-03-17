Return-Path: <kvm+bounces-41211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EAC7A64B61
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC85173CB5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F5E21A436;
	Mon, 17 Mar 2025 10:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="M45Cs1Ep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20FE235BF3
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742209116; cv=none; b=MGgL4OSdhzJf26J4KveANLHaLXmPtdEscRs5FeywYmJWT29tUwfVOzcL7BpQ4GqAlnyVsUUIIGjxoukXORy2rhTq9FaN9YYcycdF2002VwNa2binz/R17nnlw1uPP7vll35LkxvXPwCAkcZQlteSQY9mw2AwkKg08ds8/mrXdM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742209116; c=relaxed/simple;
	bh=nFlZruyUGC1SefIAzclzdj2tkbf6BBZOp0YpRTkvlMg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=DRsFnJOTp8Xl3aoHd5JIH0spcrBfRTLkeMSA7KCp5cQeYaHUxslnMsvmJWFLQ1OFNOGOSW1ImI5NC9HkG5m87IajlNfeYMk502OL7/ckUMSZApyOim86fGL4rbQfGS2+wVIhvqQMdfSqBuUmMZm+81NtisZxH4xTNfp2DumuWxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=M45Cs1Ep; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2243803b776so30744715ad.0
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742209113; x=1742813913; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DF+oAfxAaVuIF8loqeGyU6Uzr2digKuwKsJalo4eV8o=;
        b=M45Cs1EpGrLKJa5+NYMCDbql5+InxZk/+T+NqAuEdCreKGhkCpbPfQi8hX0Gl6CGx5
         HT4SWbIWs9/dLnQBeuHcDHgd9DmkorlPatkgjEW3GU85kMvjxWcX2OJTVccVzBSLX2n4
         cfBbPFk9FbP8xch9yIpexiwESOoFlb/oQnuFTzC4NdObtqiMuZZy+qync69eqzddj1oS
         1KEmwdgjzPiF1BjPh2H1JyFHq6XaR0QAAZQ2u7nUQkOBgO0u+vO1cgYYeE5gnuxvoYyR
         yZPCxEBdJgOQxtC9acYySGBo2dCGVSB1dkAsLAzv/+7KTv8dsit1Xb178EUaUgpUy4Mw
         CUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742209113; x=1742813913;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DF+oAfxAaVuIF8loqeGyU6Uzr2digKuwKsJalo4eV8o=;
        b=BEN8Ov/Jp4jLHcPdALVnnmDizjlXmbC2RgmyEjDb2vBnQL3Chulai1xSlZcWofiSsx
         5fbmmoDBnopDowHO1usNuzV5fzj+HTTlNPOeYn53y6SeHsfUHFhTPMP/wkrQdLSbWu72
         smViZKi9mvDjXPVuZWQTpkwLWHh7EEzzJeZsaLjyGebHv0f1rnSVpcET7JPajAX3P/Wx
         b2mKNRD4mVsljAEU/rqYcOAAUmQUpy0daHfZ+JRfI+ozIP8n4ffqV8Ns9TJ82qVW3np/
         dfmGoOyp+X+D5OqZrrsbQ+CFVc3YXB2AuQmsnP6Z+ObHw7QTyunpHt+++iQMiV3g92Zv
         IlKg==
X-Forwarded-Encrypted: i=1; AJvYcCWYi6YKQ+wkdv+eGWVOJEGeLpbqynbZQZsQ5Tx3k9/ybhFKKS2KxxElw9EsfnJVjP9lIhk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOYehd5VfkJmMx76FTW2vGCWOfZG+VoJAoYWEyhVnnN4lyR6Dr
	mU89xv474hOntbbhjoChBKT9JCoqaeSy1zLAfvPoNLI/Di3cIoNWTbiPf5y1RdA=
X-Gm-Gg: ASbGncuvmM4RVfdYqcQ31nS5vzww4F6T8x76fVLVJzvUkmg5lQMuD/ruYEJ/UNIyX5A
	qt4/vjuuPAJwFnSAOxr6LE7dFdJxIASgx+t0+zJqVhatnH4A5cxprhXJfJsQ3di1bVg38sqB59B
	O6n+QZj5CDvQXcURCM5pn5NOsTSyrlNH0Cngo3eFQLOTKZghXm7cjSadKp6sOJ0Ez7xFEe8zc64
	gdPgNewhsBTwxxPOD0HJ3AwDHz9eAdDhcV9eh6+8aCBd6lkVX445RxnPebFsve75V4jh8Ehdml+
	fRFxixBX+VokaXdMaOPv9N6eaRn4NmL6+RKrcj19k7odu6fG
X-Google-Smtp-Source: AGHT+IFXupmuGmu6gHP1FkeYwrRwPZhFLo2ew2wOdmTTzj5IIHUL/pIizUJC+QYtkF4syjlrofB0Tg==
X-Received: by 2002:a17:902:ce0b:b0:224:10a2:cad5 with SMTP id d9443c01a7336-225e0a1d661mr148593695ad.10.1742209113022;
        Mon, 17 Mar 2025 03:58:33 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6ba6d5dsm72426865ad.153.2025.03.17.03.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:58:32 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 17 Mar 2025 19:57:54 +0900
Subject: [PATCH net-next v11 04/10] tun: Add common virtio-net hash feature
 code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250317-rss-v11-4-4cacca92f31f@daynix.com>
References: <20250317-rss-v11-0-4cacca92f31f@daynix.com>
In-Reply-To: <20250317-rss-v11-0-4cacca92f31f@daynix.com>
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

Add common code required for the features being added to TUN and TAP.
They will be enabled for each of them in following patches.

Added Features
==============

Hash reporting
--------------

Allow the guest to reuse the hash value to make receive steering
consistent between the host and guest, and to save hash computation.

Receive Side Scaling (RSS)
--------------------------

RSS is a receive steering algorithm that can be negotiated to use with
virtio_net. Conventionally the hash calculation was done by the VMM.
However, computing the hash after the queue was chosen defeats the
purpose of RSS.

Another approach is to use eBPF steering program. This approach has
another downside: it cannot report the calculated hash due to the
restrictive nature of eBPF steering program.

Introduce the code to perform RSS to the kernel in order to overcome
thse challenges. An alternative solution is to extend the eBPF steering
program so that it will be able to report to the userspace, but I didn't
opt for it because extending the current mechanism of eBPF steering
program as is because it relies on legacy context rewriting, and
introducing kfunc-based eBPF will result in non-UAPI dependency while
the other relevant virtualization APIs such as KVM and vhost_net are
UAPIs.

Added ioctls
============

They are designed to make extensibility and VM migration compatible.
This change only adds the implementation and does not expose them to
the userspace.

TUNGETVNETHASHCAP
-----------------

This ioctl tells supported features and hash types. It is useful to
check if a VM can be migrated to the current host.

TUNSETVNETHASH
--------------

This ioctl allows setting features and hash types to be enabled. It
limits the features exposed to the guest to ensure proper migration. It
also sets RSS parameters, depending on the enabled features and hash
types.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Lei Yang <leiyang@redhat.com>
---
 drivers/net/tap.c           |  10 ++-
 drivers/net/tun.c           |  12 +++-
 drivers/net/tun_vnet.h      | 155 +++++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/if_tun.h |  73 +++++++++++++++++++++
 4 files changed, 236 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index d4ece538f1b2..25c60ff2d3f2 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -179,6 +179,11 @@ static void tap_put_queue(struct tap_queue *q)
 	sock_put(&q->sk);
 }
 
+static const struct virtio_net_hash *tap_find_hash(const struct sk_buff *skb)
+{
+	return NULL;
+}
+
 /*
  * Select a queue based on the rxq of the device on which this packet
  * arrived. If the incoming device is not mq, calculate a flow hash
@@ -711,11 +716,12 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	int total;
 
 	if (q->flags & IFF_VNET_HDR) {
-		struct virtio_net_hdr vnet_hdr;
+		struct virtio_net_hdr_v1_hash vnet_hdr;
 
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
 
-		ret = tun_vnet_hdr_from_skb(q->flags, NULL, skb, &vnet_hdr);
+		ret = tun_vnet_hdr_from_skb(vnet_hdr_len, q->flags, NULL, skb,
+					    tap_find_hash, &vnet_hdr);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9133ab9ed3f5..03d47799e9bd 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -451,6 +451,11 @@ static inline void tun_flow_save_rps_rxhash(struct tun_flow_entry *e, u32 hash)
 		e->rps_rxhash = hash;
 }
 
+static const struct virtio_net_hash *tun_find_hash(const struct sk_buff *skb)
+{
+	return NULL;
+}
+
 /* We try to identify a flow through its rxhash. The reason that
  * we do not check rxq no. is because some cards(e.g 82599), chooses
  * the rxq based on the txq where the last packet of the flow comes. As
@@ -1993,7 +1998,7 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 	ssize_t ret;
 
 	if (tun->flags & IFF_VNET_HDR) {
-		struct virtio_net_hdr gso = { 0 };
+		struct virtio_net_hdr_v1_hash gso = { 0 };
 
 		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
 		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
@@ -2046,9 +2051,10 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	}
 
 	if (vnet_hdr_sz) {
-		struct virtio_net_hdr gso;
+		struct virtio_net_hdr_v1_hash gso;
 
-		ret = tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, &gso);
+		ret = tun_vnet_hdr_from_skb(vnet_hdr_sz, tun->flags, tun->dev,
+					    skb, tun_find_hash, &gso);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
index 58b9ac7a5fc4..578adaac0671 100644
--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -6,6 +6,16 @@
 #define TUN_VNET_LE     0x80000000
 #define TUN_VNET_BE     0x40000000
 
+typedef struct virtio_net_hash *(*tun_vnet_hash_add)(struct sk_buff *);
+typedef const struct virtio_net_hash *(*tun_vnet_hash_find)(const struct sk_buff *);
+
+struct tun_vnet_hash_container {
+	struct tun_vnet_hash common;
+	struct tun_vnet_hash_rss rss;
+	u32 rss_key[VIRTIO_NET_RSS_MAX_KEY_SIZE];
+	u16 rss_indirection_table[];
+};
+
 static inline bool tun_vnet_legacy_is_little_endian(unsigned int flags)
 {
 	bool be = IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
@@ -107,6 +117,119 @@ static inline long tun_vnet_ioctl(int *vnet_hdr_sz, unsigned int *flags,
 	}
 }
 
+static inline long tun_vnet_ioctl_gethashcap(void __user *argp)
+{
+	static const struct tun_vnet_hash cap = {
+		.flags = TUN_VNET_HASH_REPORT | TUN_VNET_HASH_RSS,
+		.types = VIRTIO_NET_SUPPORTED_HASH_TYPES
+	};
+
+	return copy_to_user(argp, &cap, sizeof(cap)) ? -EFAULT : 0;
+}
+
+static inline long tun_vnet_ioctl_sethash(struct tun_vnet_hash_container __rcu **hashp,
+					  void __user *argp)
+{
+	struct tun_vnet_hash hash_buf;
+	struct tun_vnet_hash_container *hash;
+
+	if (copy_from_user(&hash_buf, argp, sizeof(hash_buf)))
+		return -EFAULT;
+	argp = (struct tun_vnet_hash __user *)argp + 1;
+
+	if (hash_buf.flags & TUN_VNET_HASH_RSS) {
+		struct tun_vnet_hash_rss rss;
+		size_t indirection_table_size;
+		size_t key_size;
+		size_t size;
+
+		if (copy_from_user(&rss, argp, sizeof(rss)))
+			return -EFAULT;
+		argp = (struct tun_vnet_hash_rss __user *)argp + 1;
+
+		indirection_table_size = ((size_t)rss.indirection_table_mask + 1) * 2;
+		key_size = virtio_net_hash_key_length(hash_buf.types);
+		size = struct_size(hash, rss_indirection_table,
+				   (size_t)rss.indirection_table_mask + 1);
+
+		hash = kmalloc(size, GFP_KERNEL);
+		if (!hash)
+			return -ENOMEM;
+
+		if (copy_from_user(hash->rss_indirection_table,
+				   argp, indirection_table_size)) {
+			kfree(hash);
+			return -EFAULT;
+		}
+		argp = (u16 __user *)argp + rss.indirection_table_mask + 1;
+
+		if (copy_from_user(hash->rss_key, argp, key_size)) {
+			kfree(hash);
+			return -EFAULT;
+		}
+
+		virtio_net_toeplitz_convert_key(hash->rss_key, key_size);
+		hash->rss = rss;
+	} else {
+		hash = kmalloc(sizeof(hash->common), GFP_KERNEL);
+		if (!hash)
+			return -ENOMEM;
+	}
+
+	hash->common = hash_buf;
+	kfree_rcu_mightsleep(rcu_replace_pointer_rtnl(*hashp, hash));
+	return 0;
+}
+
+static inline void tun_vnet_hash_report(const struct tun_vnet_hash_container *hash,
+					struct sk_buff *skb,
+					const struct flow_keys_basic *keys,
+					u32 value,
+					tun_vnet_hash_add vnet_hash_add)
+{
+	struct virtio_net_hash *report;
+
+	if (!hash || !(hash->common.flags & TUN_VNET_HASH_REPORT))
+		return;
+
+	report = vnet_hash_add(skb);
+	if (!report)
+		return;
+
+	*report = (struct virtio_net_hash) {
+		.report = virtio_net_hash_report(hash->common.types, keys),
+		.value = value
+	};
+}
+
+static inline u16 tun_vnet_rss_select_queue(u32 numqueues,
+					    const struct tun_vnet_hash_container *hash,
+					    struct sk_buff *skb,
+					    tun_vnet_hash_add vnet_hash_add)
+{
+	struct virtio_net_hash *report;
+	struct virtio_net_hash ret;
+	u16 index;
+
+	if (!numqueues)
+		return 0;
+
+	virtio_net_hash_rss(skb, hash->common.types, hash->rss_key, &ret);
+
+	if (!ret.report)
+		return hash->rss.unclassified_queue % numqueues;
+
+	if (hash->common.flags & TUN_VNET_HASH_REPORT) {
+		report = vnet_hash_add(skb);
+		if (report)
+			*report = ret;
+	}
+
+	index = ret.value & hash->rss.indirection_table_mask;
+
+	return hash->rss_indirection_table[index] % numqueues;
+}
+
 static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
 				   struct iov_iter *from,
 				   struct virtio_net_hdr *hdr)
@@ -135,15 +258,17 @@ static inline int tun_vnet_hdr_get(int sz, unsigned int flags,
 }
 
 static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
-				   const struct virtio_net_hdr *hdr)
+				   const struct virtio_net_hdr_v1_hash *hdr)
 {
+	int content_sz = MIN(sizeof(*hdr), sz);
+
 	if (unlikely(iov_iter_count(iter) < sz))
 		return -EINVAL;
 
-	if (unlikely(copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr)))
+	if (unlikely(copy_to_iter(hdr, content_sz, iter) != content_sz))
 		return -EFAULT;
 
-	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
+	if (iov_iter_zero(sz - content_sz, iter) != sz - content_sz)
 		return -EFAULT;
 
 	return 0;
@@ -155,26 +280,38 @@ static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
 	return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
 }
 
-static inline int tun_vnet_hdr_from_skb(unsigned int flags,
+static inline int tun_vnet_hdr_from_skb(int sz, unsigned int flags,
 					const struct net_device *dev,
 					const struct sk_buff *skb,
-					struct virtio_net_hdr *hdr)
+					tun_vnet_hash_find vnet_hash_find,
+					struct virtio_net_hdr_v1_hash *hdr)
 {
 	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
+	const struct virtio_net_hash *report = sz < sizeof(struct virtio_net_hdr_v1_hash) ?
+					       NULL : vnet_hash_find(skb);
+
+	*hdr = (struct virtio_net_hdr_v1_hash) {
+		.hash_report = VIRTIO_NET_HASH_REPORT_NONE
+	};
+
+	if (report) {
+		hdr->hash_value = cpu_to_le32(report->value);
+		hdr->hash_report = cpu_to_le16(report->report);
+	}
 
-	if (virtio_net_hdr_from_skb(skb, hdr,
+	if (virtio_net_hdr_from_skb(skb, (struct virtio_net_hdr *)hdr,
 				    tun_vnet_is_little_endian(flags), true,
 				    vlan_hlen)) {
 		struct skb_shared_info *sinfo = skb_shinfo(skb);
 
 		if (net_ratelimit()) {
 			netdev_err(dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
-				   sinfo->gso_type, tun_vnet16_to_cpu(flags, hdr->gso_size),
-				   tun_vnet16_to_cpu(flags, hdr->hdr_len));
+				   sinfo->gso_type, tun_vnet16_to_cpu(flags, hdr->hdr.gso_size),
+				   tun_vnet16_to_cpu(flags, hdr->hdr.hdr_len));
 			print_hex_dump(KERN_ERR, "tun: ",
 				       DUMP_PREFIX_NONE,
 				       16, 1, skb->head,
-				       min(tun_vnet16_to_cpu(flags, hdr->hdr_len), 64), true);
+				       min(tun_vnet16_to_cpu(flags, hdr->hdr.hdr_len), 64), true);
 		}
 		WARN_ON_ONCE(1);
 		return -EINVAL;
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 980de74724fc..b7b0fe69a652 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -62,6 +62,42 @@
 #define TUNSETCARRIER _IOW('T', 226, int)
 #define TUNGETDEVNETNS _IO('T', 227)
 
+/**
+ * define TUNGETVNETHASHCAP - ioctl to get virtio_net hashing capability
+ *
+ * The argument is a pointer to &struct tun_vnet_hash which will store the
+ * maximal virtio_net hashing configuration.
+ */
+#define TUNGETVNETHASHCAP _IOR('T', 228, struct tun_vnet_hash)
+
+/**
+ * define TUNSETVNETHASH - ioctl to configure virtio_net hashing
+ *
+ * The argument is a pointer to &struct tun_vnet_hash.
+ *
+ * The argument is a pointer to the compound of the following in order if
+ * %TUN_VNET_HASH_RSS is set:
+ *
+ * 1. &struct tun_vnet_hash
+ * 2. &struct tun_vnet_hash_rss
+ * 3. Indirection table
+ * 4. Key
+ *
+ * The %TUN_VNET_HASH_REPORT flag set with this ioctl will be effective only
+ * after calling the %TUNSETVNETHDRSZ ioctl with a number greater than or equal
+ * to the size of &struct virtio_net_hdr_v1_hash.
+ *
+ * The members added to the legacy header by %TUN_VNET_HASH_REPORT flag will
+ * always be little-endian.
+ *
+ * This ioctl results in %EBADFD if the underlying device is deleted. It affects
+ * all queues attached to the same device.
+ *
+ * This ioctl currently has no effect on XDP packets and packets with
+ * queue_mapping set by TC.
+ */
+#define TUNSETVNETHASH _IOW('T', 229, struct tun_vnet_hash)
+
 /* TUNSETIFF ifr flags */
 #define IFF_TUN		0x0001
 #define IFF_TAP		0x0002
@@ -124,4 +160,41 @@ struct tun_filter {
  */
 #define TUN_STEERINGEBPF_FALLBACK -1
 
+/**
+ * define TUN_VNET_HASH_REPORT - Request virtio_net hash reporting for vhost
+ */
+#define TUN_VNET_HASH_REPORT	0x0001
+
+/**
+ * define TUN_VNET_HASH_RSS - Request virtio_net RSS
+ */
+#define TUN_VNET_HASH_RSS	0x0002
+
+/**
+ * struct tun_vnet_hash - virtio_net hashing configuration
+ * @flags:
+ *		Bitmask consists of %TUN_VNET_HASH_REPORT and %TUN_VNET_HASH_RSS
+ * @pad:
+ *		Should be filled with zero before passing to %TUNSETVNETHASH
+ * @types:
+ *		Bitmask of allowed hash types
+ */
+struct tun_vnet_hash {
+	__u16 flags;
+	__u8 pad[2];
+	__u32 types;
+};
+
+/**
+ * struct tun_vnet_hash_rss - virtio_net RSS configuration
+ * @indirection_table_mask:
+ *		Bitmask to be applied to the indirection table index
+ * @unclassified_queue:
+ *		The index of the queue to place unclassified packets in
+ */
+struct tun_vnet_hash_rss {
+	__u16 indirection_table_mask;
+	__u16 unclassified_queue;
+};
+
 #endif /* _UAPI__IF_TUN_H */

-- 
2.48.1


