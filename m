Return-Path: <kvm+bounces-37567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 375A4A2BB37
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 07:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 382EC1889C1E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 06:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF5923908A;
	Fri,  7 Feb 2025 06:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="AYoCJndz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E105A237A2E
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 06:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738908716; cv=none; b=IZG5nNy0leOBZZWsM+y/P0VxYxjplnkQju/OJUTMmSKhoyKk+B86EhSDPVLX/IhnXSDLCk9QpZ0pK2V2cMm5NV0Al2+RbCY33hYyf/kXP2tEPHJ5pF2V37GZppX2ZN8Fvn5MhxfO2zxS4RmZqOPVunE58T7asA9VSdD76pSG/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738908716; c=relaxed/simple;
	bh=HTscNvyC9HJMHKWPJX1Sejy7f+gI0K4OIXa4+ZNvbAw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WSRrLaWcfQBGkvgK3dV5T4uWEPxfnxEv24iHTiPc24uF/J7OvkQgA6+6TROlMaXaeL/9cCgIGmMH3s9x/i4GtnhJcds5knLei/C21Kn1MLOuemjY9O5nOZJFyHucpfvl7bzLepRQQOsfRRRZ3isl44rUht9zradMG3TuK6VZJig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=AYoCJndz; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21f3e2b4eceso25358905ad.2
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 22:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738908714; x=1739513514; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S+R57A+roDGJE2oJSDUQxgir3uIkoZEEbg7sX8hwWCo=;
        b=AYoCJndzxK0AsVqnRxIT8ZCSF0ko1nWeMW2iL8QdIDS3H5F26eZIk18IuZ2RLuArmm
         kdOtqUKzdVqNl1/V2cyNB3UDo8vBL8dWk1EtEYhdDQTUS06YlId1KSMQYweXxoKqcM2E
         GX26Znx17apatzBLvLhAdnSrp1PG3ovkf2IjmW96UtoiDbWDhKAPeONF00O4nj34EzOu
         K/lZATUrdaWDmMor4+oKnOJdFs+oc9i15JNMy6W+XJdQKev6tsVhg7bfSCkT0CNl800l
         7UskWins2NHc83WIMykZwE2fiwDlqFfrxWIaQWu79V3FCrQLh7IrA7ftjkSAMMhJPbDG
         RcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738908714; x=1739513514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+R57A+roDGJE2oJSDUQxgir3uIkoZEEbg7sX8hwWCo=;
        b=NI8Q0PEZwhoFLvO8IguKRD5rIbAJzWfLb324X+MTsQWgc6kbtYsF7adC6ZcM+dfq3E
         PoJo7DGRpE7uvsHcnKaJzU0cRYefpixRyaqbNyNFa0FfJlFja1xjb5rEXq1HTp5Nx5un
         zuIWlpVCnsk+0gBsXENn2JE6IlZPcuIHuy/YmSmC5LU5h1PRUWuCHYWv8PhTnpltqA4e
         c8jJJmd/5vs6AZ1Q4XoCeaPANQ0LWpy/vMX42gt1DDmm8RhOmG34gcw+iZLHLZ3jg0JS
         fKQQUwJ+feJZzn9O0SnBpXeclVOdyxlkCF692ZRd3MN6HC9KEASFMOvs3alzDMhQr3wj
         uV9g==
X-Forwarded-Encrypted: i=1; AJvYcCUkTWBcbQpgEPymeitidLdVU6jUUkLUPPMwxwhkoSdJg4G1OFDxL4Bs3IYdiLNizgxDaxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8L09CFZg/U9TZV3DU08tu57am/obtW0ahqNjrZwNMLBvXLY8G
	t9agN35zTyKPKhNmZYCyHo4BVB+cXs+54mZo9w82SurjrwKr3h7ryZ7Fq5kcDRQ=
X-Gm-Gg: ASbGncuRhl9oQddZepNzjqMSdmu8oksL8Xa1N2w9QytQFwp4Qm2C8Pkj+8j/X0kAtAF
	DXx0sVsq1F0SBXkz8iXvJ7Dn5Sef9zaBpFi69XyJb9piFMwRdCsIOru41lhZdaBt3gVgW45NjDZ
	mGNwEWe37RQsFS5mlXDZzmBGh0EUWCMw6/9IyaOKpBajWBeJZ4vuNltfPY00b65R4HPBnRbj540
	vciYSn9Vpx3+OSW0qQ1ejwaTp23hl/xjRWgv4tpatgXq+YztLIRCxNrQtGyV3E/MNv2NkEQj4yy
	gHVtFvyBIZatzRXZon8=
X-Google-Smtp-Source: AGHT+IHlCc/QLtRw9JwUBPb1D2TfS/bysYZ2EBR/Oh5kx6V1EMQBjR3blXWCBV04Zttp3n8xrEcfHg==
X-Received: by 2002:a17:902:c40e:b0:21f:1549:a55f with SMTP id d9443c01a7336-21f4e6c0f49mr42137015ad.19.1738908714189;
        Thu, 06 Feb 2025 22:11:54 -0800 (PST)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21f368d79a7sm22677855ad.253.2025.02.06.22.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 22:11:53 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Fri, 07 Feb 2025 15:10:57 +0900
Subject: [PATCH net-next v6 7/7] tap: Use tun's vnet-related code
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250207-tun-v6-7-fb49cf8b103e@daynix.com>
References: <20250207-tun-v6-0-fb49cf8b103e@daynix.com>
In-Reply-To: <20250207-tun-v6-0-fb49cf8b103e@daynix.com>
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
Cc: Willem de Bruijn <willemb@google.com>
X-Mailer: b4 0.14.2

tun and tap implements the same vnet-related features so reuse the code.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/tap.c | 152 ++++++------------------------------------------------
 1 file changed, 16 insertions(+), 136 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8cb002616a6143b54258b65b483fed0c3af2c7a0..1287e241f4454fb8ec4975bbaded5fbaa88e3cc8 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -26,74 +26,9 @@
 #include <linux/virtio_net.h>
 #include <linux/skb_array.h>
 
-#define TAP_IFFEATURES (IFF_VNET_HDR | IFF_MULTI_QUEUE)
-
-#define TAP_VNET_LE 0x80000000
-#define TAP_VNET_BE 0x40000000
-
-#ifdef CONFIG_TUN_VNET_CROSS_LE
-static inline bool tap_legacy_is_little_endian(struct tap_queue *q)
-{
-	return q->flags & TAP_VNET_BE ? false :
-		virtio_legacy_is_little_endian();
-}
-
-static long tap_get_vnet_be(struct tap_queue *q, int __user *sp)
-{
-	int s = !!(q->flags & TAP_VNET_BE);
-
-	if (put_user(s, sp))
-		return -EFAULT;
-
-	return 0;
-}
-
-static long tap_set_vnet_be(struct tap_queue *q, int __user *sp)
-{
-	int s;
-
-	if (get_user(s, sp))
-		return -EFAULT;
-
-	if (s)
-		q->flags |= TAP_VNET_BE;
-	else
-		q->flags &= ~TAP_VNET_BE;
-
-	return 0;
-}
-#else
-static inline bool tap_legacy_is_little_endian(struct tap_queue *q)
-{
-	return virtio_legacy_is_little_endian();
-}
-
-static long tap_get_vnet_be(struct tap_queue *q, int __user *argp)
-{
-	return -EINVAL;
-}
-
-static long tap_set_vnet_be(struct tap_queue *q, int __user *argp)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_TUN_VNET_CROSS_LE */
-
-static inline bool tap_is_little_endian(struct tap_queue *q)
-{
-	return q->flags & TAP_VNET_LE ||
-		tap_legacy_is_little_endian(q);
-}
-
-static inline u16 tap16_to_cpu(struct tap_queue *q, __virtio16 val)
-{
-	return __virtio16_to_cpu(tap_is_little_endian(q), val);
-}
+#include "tun_vnet.h"
 
-static inline __virtio16 cpu_to_tap16(struct tap_queue *q, u16 val)
-{
-	return __cpu_to_virtio16(tap_is_little_endian(q), val);
-}
+#define TAP_IFFEATURES (IFF_VNET_HDR | IFF_MULTI_QUEUE)
 
 static struct proto tap_proto = {
 	.name = "tap",
@@ -655,25 +590,13 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
 
-		err = -EINVAL;
-		if (len < vnet_hdr_len)
+		hdr_len = tun_vnet_hdr_get(vnet_hdr_len, q->flags, from, &vnet_hdr);
+		if (hdr_len < 0) {
+			err = hdr_len;
 			goto err;
-		len -= vnet_hdr_len;
-
-		err = -EFAULT;
-		if (!copy_from_iter_full(&vnet_hdr, sizeof(vnet_hdr), from))
-			goto err;
-		iov_iter_advance(from, vnet_hdr_len - sizeof(vnet_hdr));
-		hdr_len = tap16_to_cpu(q, vnet_hdr.hdr_len);
-		if (vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-			hdr_len = max(tap16_to_cpu(q, vnet_hdr.csum_start) +
-				      tap16_to_cpu(q, vnet_hdr.csum_offset) + 2,
-				      hdr_len);
-			vnet_hdr.hdr_len = cpu_to_tap16(q, hdr_len);
 		}
-		err = -EINVAL;
-		if (tap16_to_cpu(q, vnet_hdr.hdr_len) > len)
-			goto err;
+
+		len -= vnet_hdr_len;
 	}
 
 	err = -EINVAL;
@@ -725,8 +648,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb->dev = tap->dev;
 
 	if (vnet_hdr_len) {
-		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
-					    tap_is_little_endian(q));
+		err = tun_vnet_hdr_to_skb(q->flags, skb, &vnet_hdr);
 		if (err) {
 			rcu_read_unlock();
 			drop_reason = SKB_DROP_REASON_DEV_HDR;
@@ -789,23 +711,17 @@ static ssize_t tap_put_user(struct tap_queue *q,
 	int total;
 
 	if (q->flags & IFF_VNET_HDR) {
-		int vlan_hlen = skb_vlan_tag_present(skb) ? VLAN_HLEN : 0;
 		struct virtio_net_hdr vnet_hdr;
 
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
-		if (iov_iter_count(iter) < vnet_hdr_len)
-			return -EINVAL;
-
-		if (virtio_net_hdr_from_skb(skb, &vnet_hdr,
-					    tap_is_little_endian(q), true,
-					    vlan_hlen))
-			BUG();
 
-		if (copy_to_iter(&vnet_hdr, sizeof(vnet_hdr), iter) !=
-		    sizeof(vnet_hdr))
-			return -EFAULT;
+		ret = tun_vnet_hdr_from_skb(q->flags, NULL, skb, &vnet_hdr);
+		if (ret)
+			return ret;
 
-		iov_iter_advance(iter, vnet_hdr_len - sizeof(vnet_hdr));
+		ret = tun_vnet_hdr_put(vnet_hdr_len, iter, &vnet_hdr);
+		if (ret)
+			return ret;
 	}
 	total = vnet_hdr_len;
 	total += skb->len;
@@ -1064,42 +980,6 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 		q->sk.sk_sndbuf = s;
 		return 0;
 
-	case TUNGETVNETHDRSZ:
-		s = q->vnet_hdr_sz;
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
-		q->vnet_hdr_sz = s;
-		return 0;
-
-	case TUNGETVNETLE:
-		s = !!(q->flags & TAP_VNET_LE);
-		if (put_user(s, sp))
-			return -EFAULT;
-		return 0;
-
-	case TUNSETVNETLE:
-		if (get_user(s, sp))
-			return -EFAULT;
-		if (s)
-			q->flags |= TAP_VNET_LE;
-		else
-			q->flags &= ~TAP_VNET_LE;
-		return 0;
-
-	case TUNGETVNETBE:
-		return tap_get_vnet_be(q, sp);
-
-	case TUNSETVNETBE:
-		return tap_set_vnet_be(q, sp);
-
 	case TUNSETOFFLOAD:
 		/* let the user check for future flags */
 		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
@@ -1143,7 +1023,7 @@ static long tap_ioctl(struct file *file, unsigned int cmd,
 		return ret;
 
 	default:
-		return -EINVAL;
+		return tun_vnet_ioctl(&q->vnet_hdr_sz, &q->flags, cmd, sp);
 	}
 }
 
@@ -1190,7 +1070,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	skb->protocol = eth_hdr(skb)->h_proto;
 
 	if (vnet_hdr_len) {
-		err = virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
+		err = tun_vnet_hdr_to_skb(q->flags, skb, gso);
 		if (err)
 			goto err_kfree;
 	}

-- 
2.48.1


