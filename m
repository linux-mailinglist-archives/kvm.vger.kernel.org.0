Return-Path: <kvm+bounces-35625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6053AA134E3
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93DD23A3A19
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165DF1D5CD3;
	Thu, 16 Jan 2025 08:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="YswuUOdB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119219CC39
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014955; cv=none; b=bhHLODg5WbUhyzvTazigwm70c0uVMmx40eEqZY3L5ld6YQKXiSNG6F1AEoR39BQfLtI5fntmyd0zbD/fDAXC8L2+5cYrmVbIkJfA/WtBwBWHo3cBD5ym1SF9+JU+jbgkeg0hMnqMUMpUaXmAjcWYaU7Qcdf1nO4SkZidKUkUsho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014955; c=relaxed/simple;
	bh=dlMaXnHmVF0I2Zg/+PIxqJ41UeI7IEme3DeBp0QrHII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=LT5Y/2N9+b8/I7UmyQHyHPCoXl4Fiax0PA2zB3TlJszU2KFPgdZiyxbvm4EmbtX9JPq7oU26++i2R5zCxZ9zk3o9+qM5SFYk9b7XRjO2wd7kRZ2turDKW1ZJX7tIImM43R+oeM6xRclPv3WaX+8a0gQvcpvsN90s0hrjAU2sVJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=YswuUOdB; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21670dce0a7so13196025ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737014952; x=1737619752; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTB21hQ3QbIZ1GVa5XRt1Vyvjby7SpDJyzR3ERjrdhY=;
        b=YswuUOdBiA6KlOkE2kvdBZGT0+JRCmxcB5ZPtBn8DnfoNA3D0StIve12DlPHrdWqs1
         bQXEwAAVyB1JFDX7clMvvb3CoSuIhQqifOH4xC6BP84SAXWjgpy2+doBEfycZQkgIArz
         WlVVhMNZxcfEzrkb20y3mULOx1td7CYd0d0eZjJx9s6oTf3WorlAgesfArUWCbwI9ey+
         wuTTzbVwWs5dmwRVSPHEgV9Bxj+sUHZw8AOr6XMUlVHizi6NltGXDl2J/eCU4npEW1U6
         YDtFrROmIEQd2Gu5ZgA0bCBWm/tmY7UgCq6ikBtMNi5mdKJP22oyhKqCfgyBItV+AbMH
         izSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737014952; x=1737619752;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NTB21hQ3QbIZ1GVa5XRt1Vyvjby7SpDJyzR3ERjrdhY=;
        b=DsJj8Ca6JKtm40f9GDbz8sK711avwgT6oM1Ytfqtz+cT/ekNtUkIuSgIhAOp8vEFfp
         VY23pUwW8gC5pl8+Vd1dBU3vOCdhGYhZAx1eRMXkFH7BJ507JdfU3yZYbptMGDLtYv7I
         gGdzPY6Iq8W9xw03VzMzC1jpwBzMqdR29tlRtUGGbXNYlrOa0akh01ULxz4TgI1ncbl3
         qGV6l1PdEP85vCUhfKvGZvs95GvqhjO8SCLC56xTsnW3Td0QWcZ+9xVdYQ3x+qvAvXYH
         O+21q8sJEFG5KGZ4dF0ycJSkf5/G4GV26TfIcUfRUhkxkLjuADU7WPx/es5regsY2POy
         g9UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP6rOhuEMlKVyd6PVc8NhVnbEFCWcSjdKNlhh2hTcfdChuzmvcft+B7DuZGGL/WVBtgvg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLy8NwMAyvA5R3360d7IsKQ3BKOG5pdoCbneeAZ9pslj+nPlHV
	tmq3Ip3OuDuCPRHtqrpMMfi6tOa7jo9kMkMH1p7PIqAihOiS+b9G3cbCXbXEazQ=
X-Gm-Gg: ASbGncsM259uvAB+Bnm7LcmLGLUS/xPT3+k5rY7NsUICf/td7FXlo0WqKt8oKzv6mVB
	bC7o+bXN6BHIIgCZ3cHBrYVy4Zl25iEwJnqE5SG/EoSjTSIBVG10+0SCtoOISKceNK1ZW9d/Z+r
	ajfDSHcNpI3UTB4HDFHAFeImg9zrJ2cxUim65DkMopqG0jNq4h1idE4fA6AJzm1GLMOTWIbTGH+
	ou+QgOb6YSVHx7pjiLjXEGOX7ucEE8mVw1WOGj2qZdx4+BD94Cv6MbfJ7I=
X-Google-Smtp-Source: AGHT+IGyfHvFQkE+nB1o/CJ0GNwG1fqSgXmY086Vq0Qo1fUXVryET5W7oD5W9XOC903obMvquEVrHw==
X-Received: by 2002:a05:6a00:418e:b0:727:3b77:4174 with SMTP id d2e1a72fcca58-72d22032685mr46595151b3a.23.1737014951264;
        Thu, 16 Jan 2025 00:09:11 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-a31d5da4f97sm10774264a12.55.2025.01.16.00.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 00:09:10 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 16 Jan 2025 17:08:08 +0900
Subject: [PATCH net v3 5/9] tun: Decouple vnet handling
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-tun-v3-5-c6b2871e97f7@daynix.com>
References: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
In-Reply-To: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
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
X-Mailer: b4 0.14-dev-fd6e3

Decouple the vnet handling code so that we can reuse it for tap.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tun.c | 229 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 133 insertions(+), 96 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index add09dfdada5..1f4a066ad2f0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -351,6 +351,122 @@ static inline __virtio16 cpu_to_tun16(unsigned int flags, u16 val)
 	return __cpu_to_virtio16(tun_is_little_endian(flags), val);
 }
 
+static long tun_vnet_ioctl(int *sz, unsigned int *flags,
+			   unsigned int cmd, int __user *sp)
+{
+	int s;
+
+	switch (cmd) {
+	case TUNGETVNETHDRSZ:
+		s = *sz;
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
+		*sz = s;
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
+
+static int tun_vnet_hdr_get(int sz, unsigned int flags, struct iov_iter *from,
+			    struct virtio_net_hdr *hdr)
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
+
+static int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
+			    const struct virtio_net_hdr *hdr)
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
+
+static int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
+			       const struct virtio_net_hdr *hdr)
+{
+	return virtio_net_hdr_to_skb(skb, hdr, tun_is_little_endian(flags));
+}
+
+static int tun_vnet_hdr_from_skb(unsigned int flags,
+				 const struct net_device *dev,
+				 const struct sk_buff *skb,
+				 struct virtio_net_hdr *hdr)
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
+
 static inline u32 tun_hashfn(u32 rxhash)
 {
 	return rxhash & TUN_MASK_FLOW_ENTRIES;
@@ -1763,22 +1879,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	if (tun->flags & IFF_VNET_HDR) {
 		int vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
-		int flags = tun->flags;
-
-		if (iov_iter_count(from) < vnet_hdr_sz)
-			return -EINVAL;
-
-		if (!copy_from_iter_full(&gso, sizeof(gso), from))
-			return -EFAULT;
 
-		if ((gso.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		    tun16_to_cpu(flags, gso.csum_start) + tun16_to_cpu(flags, gso.csum_offset) + 2 > tun16_to_cpu(flags, gso.hdr_len))
-			gso.hdr_len = cpu_to_tun16(flags, tun16_to_cpu(flags, gso.csum_start) + tun16_to_cpu(flags, gso.csum_offset) + 2);
-
-		if (tun16_to_cpu(flags, gso.hdr_len) > iov_iter_count(from))
-			return -EINVAL;
-		hdr_len = tun16_to_cpu(flags, gso.hdr_len);
-		iov_iter_advance(from, vnet_hdr_sz - sizeof(gso));
+		hdr_len = tun_vnet_hdr_get(vnet_hdr_sz, tun->flags, from, &gso);
+		if (hdr_len < 0)
+			return hdr_len;
 	}
 
 	len = iov_iter_count(from);
@@ -1854,7 +1958,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		}
 	}
 
-	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun->flags))) {
+	if (tun_vnet_hdr_to_skb(tun->flags, skb, &gso)) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		err = -EINVAL;
 		goto free_skb;
@@ -2049,18 +2153,15 @@ static ssize_t tun_put_user_xdp(struct tun_struct *tun,
 {
 	int vnet_hdr_sz = 0;
 	size_t size = xdp_frame->len;
-	size_t ret;
+	ssize_t ret;
 
 	if (tun->flags & IFF_VNET_HDR) {
 		struct virtio_net_hdr gso = { 0 };
 
 		vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
-		if (unlikely(iov_iter_count(iter) < vnet_hdr_sz))
-			return -EINVAL;
-		if (unlikely(copy_to_iter(&gso, sizeof(gso), iter) !=
-			     sizeof(gso)))
-			return -EFAULT;
-		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
+		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
+		if (ret)
+			return ret;
 	}
 
 	ret = copy_to_iter(xdp_frame->data, size, iter) + vnet_hdr_sz;
@@ -2083,6 +2184,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 	int vlan_offset = 0;
 	int vlan_hlen = 0;
 	int vnet_hdr_sz = 0;
+	int ret;
 
 	if (skb_vlan_tag_present(skb))
 		vlan_hlen = VLAN_HLEN;
@@ -2108,33 +2210,14 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 	if (vnet_hdr_sz) {
 		struct virtio_net_hdr gso;
-		int flags = tun->flags;
-
-		if (iov_iter_count(iter) < vnet_hdr_sz)
-			return -EINVAL;
-
-		if (virtio_net_hdr_from_skb(skb, &gso,
-					    tun_is_little_endian(flags), true,
-					    vlan_hlen)) {
-			struct skb_shared_info *sinfo = skb_shinfo(skb);
-
-			if (net_ratelimit()) {
-				netdev_err(tun->dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
-					   sinfo->gso_type, tun16_to_cpu(flags, gso.gso_size),
-					   tun16_to_cpu(flags, gso.hdr_len));
-				print_hex_dump(KERN_ERR, "tun: ",
-					       DUMP_PREFIX_NONE,
-					       16, 1, skb->head,
-					       min((int)tun16_to_cpu(flags, gso.hdr_len), 64), true);
-			}
-			WARN_ON_ONCE(1);
-			return -EINVAL;
-		}
 
-		if (copy_to_iter(&gso, sizeof(gso), iter) != sizeof(gso))
-			return -EFAULT;
+		ret = tun_vnet_hdr_from_skb(tun->flags, tun->dev, skb, &gso);
+		if (ret)
+			return ret;
 
-		iov_iter_advance(iter, vnet_hdr_sz - sizeof(gso));
+		ret = tun_vnet_hdr_put(vnet_hdr_sz, iter, &gso);
+		if (ret)
+			return ret;
 	}
 
 	if (vlan_hlen) {
@@ -2494,7 +2577,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun->flags))) {
+	if (tun_vnet_hdr_to_skb(tun->flags, skb, gso)) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		ret = -EINVAL;
@@ -3078,8 +3161,6 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	kgid_t group;
 	int ifindex;
 	int sndbuf;
-	int vnet_hdr_sz;
-	int le;
 	int ret;
 	bool do_notify = false;
 
@@ -3286,50 +3367,6 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		tun_set_sndbuf(tun);
 		break;
 
-	case TUNGETVNETHDRSZ:
-		vnet_hdr_sz = tun->vnet_hdr_sz;
-		if (copy_to_user(argp, &vnet_hdr_sz, sizeof(vnet_hdr_sz)))
-			ret = -EFAULT;
-		break;
-
-	case TUNSETVNETHDRSZ:
-		if (copy_from_user(&vnet_hdr_sz, argp, sizeof(vnet_hdr_sz))) {
-			ret = -EFAULT;
-			break;
-		}
-		if (vnet_hdr_sz < (int)sizeof(struct virtio_net_hdr)) {
-			ret = -EINVAL;
-			break;
-		}
-
-		tun->vnet_hdr_sz = vnet_hdr_sz;
-		break;
-
-	case TUNGETVNETLE:
-		le = !!(tun->flags & TUN_VNET_LE);
-		if (put_user(le, (int __user *)argp))
-			ret = -EFAULT;
-		break;
-
-	case TUNSETVNETLE:
-		if (get_user(le, (int __user *)argp)) {
-			ret = -EFAULT;
-			break;
-		}
-		if (le)
-			tun->flags |= TUN_VNET_LE;
-		else
-			tun->flags &= ~TUN_VNET_LE;
-		break;
-
-	case TUNGETVNETBE:
-		ret = tun_get_vnet_be(tun->flags, argp);
-		break;
-
-	case TUNSETVNETBE:
-		ret = tun_set_vnet_be(&tun->flags, argp);
-		break;
-
 	case TUNATTACHFILTER:
 		/* Can be set only for TAPs */
 		ret = -EINVAL;
@@ -3385,7 +3422,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	default:
-		ret = -EINVAL;
+		ret = tun_vnet_ioctl(&tun->vnet_hdr_sz, &tun->flags, cmd, argp);
 		break;
 	}
 

-- 
2.47.1


