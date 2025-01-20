Return-Path: <kvm+bounces-35959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DE5A168B8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A8891661A0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224EE1DEFD4;
	Mon, 20 Jan 2025 09:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="cI5GTNov"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DD919CCFC
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737363689; cv=none; b=B414q8QsjvUYIbOUHoTk2QEwolmWzmkZF5yRPQ1mpmZqAc8bx8cFJC4rUoap7ecn8ZqaDgEHAVtj2Nux4/30HA9x+nvLkDPSSwgilHafu35TikIavQ5CYyYrV1py2ajgja+RrqIzmkbsYMju9jTERIU7UM1s6gjeYSfvKZf/QXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737363689; c=relaxed/simple;
	bh=7mA4gfMvzArS4IG8MFqc/ahemu7D0z/iLFDLfYSFZ+U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=FyRQLikuihWFHKdzDSa5o030tF2z7f2xyT5gT8mO7rXtuj6aep7lgBVcf6u6Z9KbhzlaKz7xs2sIqB5T3do/9jj14y/PIZe7dYKx7V0302QMBdI9u7JkoT8T2ajrR24Xjx4rAx4IxunCde1/xs+5LasOCTQOrWjLmkW/9nquCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=cI5GTNov; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2167141dfa1so73195745ad.1
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737363687; x=1737968487; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8USUvoI12CIeFX+LVCf+UnuA4wR6+UU7kZn+bkA/aMo=;
        b=cI5GTNovVKtD7k+51myvDvqMnpXo/uQYNwkj5oQLuGClfCcsVvEvVtStlhkFYOhqly
         WWCkJFKE0OqP1e4LzmfyyO0jCfYbyZe1UuZGIqj/+DmyF0IOV7rA8iQW+zHR+Fp2cvV5
         g9BzsGxLWJbKynHwKPXwhk+apjPCZNV6e/B88aiNfs34qwiRtaKupzfqBvqS+P9Lf6ga
         A2CrPWqfi9aHiarYk7A/sBCt650c1zA5eiW4Tod/14Vm3op3e15op1CKz8caHrn3kMWO
         8PkfcE9KlkRFTXm+ie9xx8ZOW6HUPXa+WOUGno+jurGnkOuWc0j1tYvQvdL/EcOpjy6s
         93UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737363687; x=1737968487;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8USUvoI12CIeFX+LVCf+UnuA4wR6+UU7kZn+bkA/aMo=;
        b=l5kNmLKg6azLWCf2kdibTeysqIdgEKU+IK+U2IxyiJDIOBhAvTlM4bBqmIoP+zEh1k
         Y5jFAzqbvhAfjfb6sbKpm5TWxLalZOc7NH5Ti6qIKJM9b7O7E+Dp14gPeXl3n7VuPjKU
         rlJLZ+v9jKl8e6MbmGA9EA2FEbzBsjr0PQ1dhR0UcVeum8Zt2MQ1RdNecHVahKfns1TP
         +la9cIYFx9slyVQ37ILJrmYZeLnoL3x+XgmmluLrKKdeDba/s1Omh0Q5LZsZW9E1LFr+
         qiK7jXYSp9irw3wx09N8QLzr1Qqcx88jgzAhuipCnGgsG3eGoYdZYlsifW8ZzP4JTdbw
         eSPQ==
X-Forwarded-Encrypted: i=1; AJvYcCURp6OoP8ofT5vTTwkhumKluBTQX6oKjHoRF8LjeUJaq0WmikLKtT93uhUs4drgScVpAg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSFnHlC4Y86z7t7uiHAuK9Vj/czRAZ8EwfcDHUX8oPB8GhyRS8
	vDYfZsPnq//L8+uLaKSVGurmuvjhiqCm9IZEQDlebtJIrKYwEYdfu63ndKNmBrM=
X-Gm-Gg: ASbGncvRxlZTWnxlA2wNEtVE541rlz62uiu1nURwRuRTnPYvorBhN7ARS0VeFyKSJvL
	W+pVj8cWKilWB6gkQiOyqjbYcvhNIkeURDIUDPzwmew0RlYDvj7ZSCv1mAGIm5l2RYI1FViiWRb
	wxGwfsyDEXJGdmT8EYN2bR/RNrgTT2ibYf/9BCvA3pR6j7Wwd+4jYnb+mO1LoVwLW9/HOwkQdsv
	tDtCimRW2xwFWBZvSaZbdbR9jS2n2CaBjRgasd86/D/9RnDrgrelLv5A6dYQ+HAM+MMWLE1
X-Google-Smtp-Source: AGHT+IGF14rXg8HdQYLwlVI836+//3eKw3OOQKSknO8LwogQQu2QUNJXh2p/aSB+4Zq3wpJ/xZT6VQ==
X-Received: by 2002:a17:903:2352:b0:215:58be:334e with SMTP id d9443c01a7336-21c35c9af72mr180149405ad.10.1737363685424;
        Mon, 20 Jan 2025 01:01:25 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21c2ceb733dsm56478245ad.65.2025.01.20.01.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:01:24 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 20 Jan 2025 18:00:15 +0900
Subject: [PATCH net-next v4 6/9] tun: Extract the vnet handling code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-tun-v4-6-ee81dda03d7f@daynix.com>
References: <20250120-tun-v4-0-ee81dda03d7f@daynix.com>
In-Reply-To: <20250120-tun-v4-0-ee81dda03d7f@daynix.com>
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
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14.2

The vnet handling code will be reused by tap.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 MAINTAINERS            |   2 +-
 drivers/net/Kconfig    |   4 ++
 drivers/net/Makefile   |   1 +
 drivers/net/tun.c      | 174 +---------------------------------------------
 drivers/net/tun_vnet.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun_vnet.h |  25 +++++++
 6 files changed, 217 insertions(+), 173 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 910305c11e8a882da5b49ce5bd55011b93f28c32..bc32b7e23c79ab80b19c8207f14c5e51a47ec89f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23902,7 +23902,7 @@ W:	http://vtun.sourceforge.net/tun
 F:	Documentation/networking/tuntap.rst
 F:	arch/um/os-Linux/drivers/
 F:	drivers/net/tap.c
-F:	drivers/net/tun.c
+F:	drivers/net/tun*
 
 TURBOCHANNEL SUBSYSTEM
 M:	"Maciej W. Rozycki" <macro@orcam.me.uk>
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 1fd5acdc73c6af0e1a861867039c3624fc618e25..924bf61f12a49566b26a78f42cea5ca1c48537c5 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -391,10 +391,14 @@ config RIONET_RX_SIZE
 	depends on RIONET
 	default "128"
 
+config TUN_VNET
+	tristate
+
 config TUN
 	tristate "Universal TUN/TAP device driver support"
 	depends on INET
 	select CRC32
+	select TUN_VNET
 	help
 	  TUN/TAP provides packet reception and transmission for user space
 	  programs.  It can be viewed as a simple Point-to-Point or Ethernet
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 13743d0e83b5fde479e9b30ad736be402d880dee..f6590f2795cf742ab15047d8f1b2d2d8661954a3 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -29,6 +29,7 @@ obj-y += mdio/
 obj-y += pcs/
 obj-$(CONFIG_RIONET) += rionet.o
 obj-$(CONFIG_NET_TEAM) += team/
+obj-$(CONFIG_TUN_VNET) += tun_vnet.o
 obj-$(CONFIG_TUN) += tun.o
 obj-$(CONFIG_TAP) += tap.o
 obj-$(CONFIG_VETH) += veth.o
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 20659a62bb51d2a497a9d3e9e3b3ee7e9fad4f35..21abd3613cacda175d4f469f580a2994b2f836e8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -83,6 +83,8 @@
 #include <linux/uaccess.h>
 #include <linux/proc_fs.h>
 
+#include "tun_vnet.h"
+
 static void tun_default_link_ksettings(struct net_device *dev,
 				       struct ethtool_link_ksettings *cmd);
 
@@ -94,9 +96,6 @@ static void tun_default_link_ksettings(struct net_device *dev,
  * overload it to mean fasync when stored there.
  */
 #define TUN_FASYNC	IFF_ATTACH_QUEUE
-/* High bits in flags field are unused. */
-#define TUN_VNET_LE     0x80000000
-#define TUN_VNET_BE     0x40000000
 
 #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
 		      IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
@@ -298,175 +297,6 @@ static bool tun_napi_frags_enabled(const struct tun_file *tfile)
 	return tfile->napi_frags_enabled;
 }
 
-static inline bool tun_legacy_is_little_endian(unsigned int flags)
-{
-	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
-		 (flags & TUN_VNET_BE)) &&
-		virtio_legacy_is_little_endian();
-}
-
-static long tun_get_vnet_be(unsigned int flags, int __user *argp)
-{
-	int be = !!(flags & TUN_VNET_BE);
-
-	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
-		return -EINVAL;
-
-	if (put_user(be, argp))
-		return -EFAULT;
-
-	return 0;
-}
-
-static long tun_set_vnet_be(unsigned int *flags, int __user *argp)
-{
-	int be;
-
-	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
-		return -EINVAL;
-
-	if (get_user(be, argp))
-		return -EFAULT;
-
-	if (be)
-		*flags |= TUN_VNET_BE;
-	else
-		*flags &= ~TUN_VNET_BE;
-
-	return 0;
-}
-
-static inline bool tun_is_little_endian(unsigned int flags)
-{
-	return flags & TUN_VNET_LE || tun_legacy_is_little_endian(flags);
-}
-
-static inline u16 tun16_to_cpu(unsigned int flags, __virtio16 val)
-{
-	return __virtio16_to_cpu(tun_is_little_endian(flags), val);
-}
-
-static inline __virtio16 cpu_to_tun16(unsigned int flags, u16 val)
-{
-	return __cpu_to_virtio16(tun_is_little_endian(flags), val);
-}
-
-static long tun_vnet_ioctl(int *vnet_hdr_len_sz, unsigned int *flags,
-			   unsigned int cmd, int __user *sp)
-{
-	int s;
-
-	switch (cmd) {
-	case TUNGETVNETHDRSZ:
-		s = *vnet_hdr_len_sz;
-		if (put_user(s, sp))
-			return -EFAULT;
-		return 0;
-
-	case TUNSETVNETHDRSZ:
-		if (get_user(s, sp))
-			return -EFAULT;
-		if (s < (int)sizeof(struct virtio_net_hdr))
-			return -EINVAL;
-
-		*vnet_hdr_len_sz = s;
-		return 0;
-
-	case TUNGETVNETLE:
-		s = !!(*flags & TUN_VNET_LE);
-		if (put_user(s, sp))
-			return -EFAULT;
-		return 0;
-
-	case TUNSETVNETLE:
-		if (get_user(s, sp))
-			return -EFAULT;
-		if (s)
-			*flags |= TUN_VNET_LE;
-		else
-			*flags &= ~TUN_VNET_LE;
-		return 0;
-
-	case TUNGETVNETBE:
-		return tun_get_vnet_be(*flags, sp);
-
-	case TUNSETVNETBE:
-		return tun_set_vnet_be(flags, sp);
-
-	default:
-		return -EINVAL;
-	}
-}
-
-static int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
-			    struct virtio_net_hdr *hdr)
-{
-	if (iov_iter_count(from) < sz)
-		return -EINVAL;
-
-	if (!copy_from_iter_full(hdr, sizeof(*hdr), from))
-		return -EFAULT;
-
-	if ((hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-	    tun16_to_cpu(flags, hdr->csum_start) + tun16_to_cpu(flags, hdr->csum_offset) + 2 > tun16_to_cpu(flags, hdr->hdr_len))
-		hdr->hdr_len = cpu_to_tun16(flags, tun16_to_cpu(flags, hdr->csum_start) + tun16_to_cpu(flags, hdr->csum_offset) + 2);
-
-	if (tun16_to_cpu(flags, hdr->hdr_len) > iov_iter_count(from))
-		return -EINVAL;
-
-	iov_iter_advance(from, sz - sizeof(*hdr));
-
-	return tun16_to_cpu(flags, hdr->hdr_len);
-}
-
-static int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
-			    const struct virtio_net_hdr *hdr)
-{
-	if (unlikely(iov_iter_count(iter) < sz))
-		return -EINVAL;
-
-	if (unlikely(copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr)))
-		return -EFAULT;
-
-	iov_iter_advance(iter, sz - sizeof(*hdr));
-
-	return 0;
-}
-
-static int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
-			       const struct virtio_net_hdr *hdr)
-{
-	return virtio_net_hdr_to_skb(skb, hdr, tun_is_little_endian(flags));
-}
-
-static int tun_vnet_hdr_from_skb(unsigned int flags,
-				 const struct net_device *dev,
-				 const struct sk_buff *skb,
-				 struct virtio_net_hdr *hdr)
-{
-	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
-
-	if (virtio_net_hdr_from_skb(skb, hdr,
-				    tun_is_little_endian(flags), true,
-				    vlan_hlen)) {
-		struct skb_shared_info *sinfo = skb_shinfo(skb);
-
-		if (net_ratelimit()) {
-			netdev_err(dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
-				   sinfo->gso_type, tun16_to_cpu(flags, hdr->gso_size),
-				   tun16_to_cpu(flags, hdr->hdr_len));
-			print_hex_dump(KERN_ERR, "tun: ",
-				       DUMP_PREFIX_NONE,
-				       16, 1, skb->head,
-				       min(tun16_to_cpu(flags, hdr->hdr_len), 64), true);
-		}
-		WARN_ON_ONCE(1);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static inline u32 tun_hashfn(u32 rxhash)
 {
 	return rxhash & TUN_MASK_FLOW_ENTRIES;
diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
new file mode 100644
index 0000000000000000000000000000000000000000..5e5dd9c6aa38323914f714ba82d9848c29fba484
--- /dev/null
+++ b/drivers/net/tun_vnet.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "tun_vnet.h"
+
+/* High bits in flags field are unused. */
+#define TUN_VNET_LE     0x80000000
+#define TUN_VNET_BE     0x40000000
+
+static inline bool tun_legacy_is_little_endian(unsigned int flags)
+{
+	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
+		 (flags & TUN_VNET_BE)) &&
+		virtio_legacy_is_little_endian();
+}
+
+static long tun_get_vnet_be(unsigned int flags, int __user *argp)
+{
+	int be = !!(flags & TUN_VNET_BE);
+
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
+	if (put_user(be, argp))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long tun_set_vnet_be(unsigned int *flags, int __user *argp)
+{
+	int be;
+
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
+	if (get_user(be, argp))
+		return -EFAULT;
+
+	if (be)
+		*flags |= TUN_VNET_BE;
+	else
+		*flags &= ~TUN_VNET_BE;
+
+	return 0;
+}
+
+static inline bool tun_is_little_endian(unsigned int flags)
+{
+	return flags & TUN_VNET_LE || tun_legacy_is_little_endian(flags);
+}
+
+static inline u16 tun16_to_cpu(unsigned int flags, __virtio16 val)
+{
+	return __virtio16_to_cpu(tun_is_little_endian(flags), val);
+}
+
+static inline __virtio16 cpu_to_tun16(unsigned int flags, u16 val)
+{
+	return __cpu_to_virtio16(tun_is_little_endian(flags), val);
+}
+
+long tun_vnet_ioctl(int *vnet_hdr_len_sz, unsigned int *flags,
+		    unsigned int cmd, int __user *sp)
+{
+	int s;
+
+	switch (cmd) {
+	case TUNGETVNETHDRSZ:
+		s = *vnet_hdr_len_sz;
+		if (put_user(s, sp))
+			return -EFAULT;
+		return 0;
+
+	case TUNSETVNETHDRSZ:
+		if (get_user(s, sp))
+			return -EFAULT;
+		if (s < (int)sizeof(struct virtio_net_hdr))
+			return -EINVAL;
+
+		*vnet_hdr_len_sz = s;
+		return 0;
+
+	case TUNGETVNETLE:
+		s = !!(*flags & TUN_VNET_LE);
+		if (put_user(s, sp))
+			return -EFAULT;
+		return 0;
+
+	case TUNSETVNETLE:
+		if (get_user(s, sp))
+			return -EFAULT;
+		if (s)
+			*flags |= TUN_VNET_LE;
+		else
+			*flags &= ~TUN_VNET_LE;
+		return 0;
+
+	case TUNGETVNETBE:
+		return tun_get_vnet_be(*flags, sp);
+
+	case TUNSETVNETBE:
+		return tun_set_vnet_be(flags, sp);
+
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(tun_vnet_ioctl);
+
+int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
+		     struct virtio_net_hdr *hdr)
+{
+	if (iov_iter_count(from) < sz)
+		return -EINVAL;
+
+	if (!copy_from_iter_full(hdr, sizeof(*hdr), from))
+		return -EFAULT;
+
+	if ((hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+	    tun16_to_cpu(flags, hdr->csum_start) + tun16_to_cpu(flags, hdr->csum_offset) + 2 > tun16_to_cpu(flags, hdr->hdr_len))
+		hdr->hdr_len = cpu_to_tun16(flags, tun16_to_cpu(flags, hdr->csum_start) + tun16_to_cpu(flags, hdr->csum_offset) + 2);
+
+	if (tun16_to_cpu(flags, hdr->hdr_len) > iov_iter_count(from))
+		return -EINVAL;
+
+	iov_iter_advance(from, sz - sizeof(*hdr));
+
+	return tun16_to_cpu(flags, hdr->hdr_len);
+}
+EXPORT_SYMBOL_GPL(tun_vnet_hdr_get);
+
+int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
+		     const struct virtio_net_hdr *hdr)
+{
+	if (unlikely(iov_iter_count(iter) < sz))
+		return -EINVAL;
+
+	if (unlikely(copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr)))
+		return -EFAULT;
+
+	iov_iter_advance(iter, sz - sizeof(*hdr));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tun_vnet_hdr_put);
+
+int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
+			const struct virtio_net_hdr *hdr)
+{
+	return virtio_net_hdr_to_skb(skb, hdr, tun_is_little_endian(flags));
+}
+EXPORT_SYMBOL_GPL(tun_vnet_hdr_to_skb);
+
+int tun_vnet_hdr_from_skb(unsigned int flags,
+			  const struct net_device *dev,
+			  const struct sk_buff *skb,
+			  struct virtio_net_hdr *hdr)
+{
+	int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
+
+	if (virtio_net_hdr_from_skb(skb, hdr,
+				    tun_is_little_endian(flags), true,
+				    vlan_hlen)) {
+		struct skb_shared_info *sinfo = skb_shinfo(skb);
+
+		if (net_ratelimit()) {
+			netdev_err(dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
+				   sinfo->gso_type, tun16_to_cpu(flags, hdr->gso_size),
+				   tun16_to_cpu(flags, hdr->hdr_len));
+			print_hex_dump(KERN_ERR, "tun: ",
+				       DUMP_PREFIX_NONE,
+				       16, 1, skb->head,
+				       min(tun16_to_cpu(flags, hdr->hdr_len), 64), true);
+		}
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tun_vnet_hdr_from_skb);
+
+MODULE_DESCRIPTION("Common library for drivers implementing TUN/TAP's virtio-related features");
+MODULE_AUTHOR("Max Krasnyansky <maxk@qualcomm.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
new file mode 100644
index 0000000000000000000000000000000000000000..a8d6e474933399d9c6161bef31e385f5c538da1c
--- /dev/null
+++ b/drivers/net/tun_vnet.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef TUN_VNET_H
+#define TUN_VNET_H
+
+#include <linux/if_tun.h>
+#include <linux/virtio_net.h>
+
+long tun_vnet_ioctl(int *sz, unsigned int *flags,
+		    unsigned int cmd, int __user *sp);
+
+int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
+		     struct virtio_net_hdr *hdr);
+
+int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
+		     const struct virtio_net_hdr *hdr);
+
+int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
+			const struct virtio_net_hdr *hdr);
+
+int tun_vnet_hdr_from_skb(unsigned int flags,
+			  const struct net_device *dev,
+			  const struct sk_buff *skb,
+			  struct virtio_net_hdr *hdr);
+
+#endif /* TUN_VNET_H */

-- 
2.47.1


