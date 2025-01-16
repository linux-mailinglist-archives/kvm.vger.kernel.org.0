Return-Path: <kvm+bounces-35624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1DDA134DA
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83FF916705E
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 673081DDA14;
	Thu, 16 Jan 2025 08:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="AEVz/CwQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B281C3BFE
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014945; cv=none; b=UkI3CyOmXx8qlNVoI/klbG+8dmrTwvvY1bVdtlvlLyTALLPCr8tl3o31ajZxv35rMy7AyShQF/M3z9ZS6ZqP1SO5BIgJT4jyFyeRqeNgNTCWAjoC/NK3c/e6rkJXfpw6SLASj8gfA7nOtNNHdXOC4b3oKH+D/h3YHdeQsniR/MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014945; c=relaxed/simple;
	bh=7cwGCecJVUq9NE/wEvVpdMm5GKoB/xKHUIbEj6SpY/A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=XrYDcsptL0nvQBwAoChSar5Wa7VdW5KlOl1uTJr3z4SDKBthrfq0hQqEXug/PdMK7y/9b1UaiHWVHZ6ObU5I2Bs/J66R15Ksz7d5qpQZZql4N0wJUeGBUqk3rnaC0VJDYdbUq0y2Wg3JNeOndxbGkpF7WGWDFlkQa3QkR+Qs9Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=AEVz/CwQ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2161eb95317so9936365ad.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737014943; x=1737619743; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1BI+fjEBdkDu0axEe9mBsEt1Vs/iCkft5MGOxEPQjDo=;
        b=AEVz/CwQM1izB0pEGH6qn6eMPtpX4NrsMmkSEaGkbZm3RAhyAS98ahYewIfl//YtP7
         bnm/PL+6X+Q6K+SvzlC1VaTehZ8lYHMtwrFSX834gmWL+Bs9mjcSGhS0HzgyADX9KOOy
         MGdJ0vB7fGfqD3tBtripL+P1AdBPgdB8OTyG85ih5WvzsqzBK01jRqkE88iBinmEM1Ux
         +KfSwZwfHEOZLGCAQ7if352F9skbayOmS/gmRsBPG1GLlvMLpcoIf1mGRXVQxBLONp/x
         4h5hWtzHm5d5XszRTqG2xUMJ4Zr7NwTgMr3yd9iDNCZDDbDTng9oeJRYFrGoAJhEiG7I
         XrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737014943; x=1737619743;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BI+fjEBdkDu0axEe9mBsEt1Vs/iCkft5MGOxEPQjDo=;
        b=LSGDlig4tt0Z/DI2uwqKRCDL7wUQNeWm2LUEg4/zCW7UHMu3ZRAm9UecEpWfk+bei4
         nsABMJhe4uKejsPtwTbfvN9KqpVPGm480BxwoFljaC3LlEcbhZuXKppq5AMWPHOoNUdk
         DjNeFaxLNuccbfB8M5EZZwqrHg1ii/f/YlI/26cd4kEuOkIAjK/WfI2M8pE5hfAGRdAq
         hKlQzq4xXokZRnF0YF70p8LxJCF8He6xHJHvuE6woSi8m4d9aPLVEeUbP6WPUjx0tz8P
         COYdA0gPzL4zPX852dBJRhO1qwPzoFYH3ke+XceXGAS7OUYc0SiWotTH+5idn1giDcy+
         /9gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWibXgsjinMOpaDUYRLAQaVhswIZ0pIINN//eyBOwBy8VCwIp6L2WRwyT4IJz5JaLHapY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGMfDrWZOLHx+aUXl+IkQxX2gt7iGzdoOYW1TAyntXma+AB54s
	XZJnpbFV5DEyIuGsU0xFiKZxp3FPvibkIT/E93Ammfl5kb1i3O+xVLFDN3nyyrE=
X-Gm-Gg: ASbGnctBw94FYQlIY9GPWI9qoJ5I6XfTJ7WwCGr+rIfmrxOeHYHvP8N5TpZa7qg2Mze
	oTwESEsd9j04IUKlQAYS2XZoU3U8rvRhQ2BiRlGFd66AMN7WzhFIDO9muGNcwvgf262LjXJbOIN
	VnEV2Zed1a5Uei4yORmlJcA60/lQpqryP4Uk7Uqnx+/vsQtXdiy25pLdbaz1rgi88pXBpzvXWBE
	J6JXtOqxqXsgIaM0/W8F6qOXLcwxpuh2LyRZkBVoPoAT2z+qthm1KdeGsc=
X-Google-Smtp-Source: AGHT+IGW8WSgGs2yPkE2cy46mpIsKAMuALM9M++rrp2TlRVQMIKh5cR0l6Hddby7o2+2dD6w//Cn6A==
X-Received: by 2002:a05:6a21:1088:b0:1e0:c3bf:7909 with SMTP id adf61e73a8af0-1e88d0ddc8dmr50984607637.41.1737014943273;
        Thu, 16 Jan 2025 00:09:03 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-72d405943fcsm10371439b3a.78.2025.01.16.00.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 00:09:02 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 16 Jan 2025 17:08:07 +0900
Subject: [PATCH net v3 4/9] tun: Decouple vnet from tun_struct
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-tun-v3-4-c6b2871e97f7@daynix.com>
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

Decouple vnet-related functions from tun_struct so that we can reuse
them for tap in the future.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tun.c | 53 +++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ec56ac865848..add09dfdada5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -298,16 +298,16 @@ static bool tun_napi_frags_enabled(const struct tun_file *tfile)
 	return tfile->napi_frags_enabled;
 }
 
-static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
+static inline bool tun_legacy_is_little_endian(unsigned int flags)
 {
 	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
-		 (tun->flags & TUN_VNET_BE)) &&
+		 (flags & TUN_VNET_BE)) &&
 		virtio_legacy_is_little_endian();
 }
 
-static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
+static long tun_get_vnet_be(unsigned int flags, int __user *argp)
 {
-	int be = !!(tun->flags & TUN_VNET_BE);
+	int be = !!(flags & TUN_VNET_BE);
 
 	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
 		return -EINVAL;
@@ -318,7 +318,7 @@ static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
 	return 0;
 }
 
-static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
+static long tun_set_vnet_be(unsigned int *flags, int __user *argp)
 {
 	int be;
 
@@ -329,27 +329,26 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 		return -EFAULT;
 
 	if (be)
-		tun->flags |= TUN_VNET_BE;
+		*flags |= TUN_VNET_BE;
 	else
-		tun->flags &= ~TUN_VNET_BE;
+		*flags &= ~TUN_VNET_BE;
 
 	return 0;
 }
 
-static inline bool tun_is_little_endian(struct tun_struct *tun)
+static inline bool tun_is_little_endian(unsigned int flags)
 {
-	return tun->flags & TUN_VNET_LE ||
-		tun_legacy_is_little_endian(tun);
+	return flags & TUN_VNET_LE || tun_legacy_is_little_endian(flags);
 }
 
-static inline u16 tun16_to_cpu(struct tun_struct *tun, __virtio16 val)
+static inline u16 tun16_to_cpu(unsigned int flags, __virtio16 val)
 {
-	return __virtio16_to_cpu(tun_is_little_endian(tun), val);
+	return __virtio16_to_cpu(tun_is_little_endian(flags), val);
 }
 
-static inline __virtio16 cpu_to_tun16(struct tun_struct *tun, u16 val)
+static inline __virtio16 cpu_to_tun16(unsigned int flags, u16 val)
 {
-	return __cpu_to_virtio16(tun_is_little_endian(tun), val);
+	return __cpu_to_virtio16(tun_is_little_endian(flags), val);
 }
 
 static inline u32 tun_hashfn(u32 rxhash)
@@ -1764,6 +1763,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	if (tun->flags & IFF_VNET_HDR) {
 		int vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
+		int flags = tun->flags;
 
 		if (iov_iter_count(from) < vnet_hdr_sz)
 			return -EINVAL;
@@ -1772,12 +1772,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			return -EFAULT;
 
 		if ((gso.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		    tun16_to_cpu(tun, gso.csum_start) + tun16_to_cpu(tun, gso.csum_offset) + 2 > tun16_to_cpu(tun, gso.hdr_len))
-			gso.hdr_len = cpu_to_tun16(tun, tun16_to_cpu(tun, gso.csum_start) + tun16_to_cpu(tun, gso.csum_offset) + 2);
+		    tun16_to_cpu(flags, gso.csum_start) + tun16_to_cpu(flags, gso.csum_offset) + 2 > tun16_to_cpu(flags, gso.hdr_len))
+			gso.hdr_len = cpu_to_tun16(flags, tun16_to_cpu(flags, gso.csum_start) + tun16_to_cpu(flags, gso.csum_offset) + 2);
 
-		if (tun16_to_cpu(tun, gso.hdr_len) > iov_iter_count(from))
+		if (tun16_to_cpu(flags, gso.hdr_len) > iov_iter_count(from))
 			return -EINVAL;
-		hdr_len = tun16_to_cpu(tun, gso.hdr_len);
+		hdr_len = tun16_to_cpu(flags, gso.hdr_len);
 		iov_iter_advance(from, vnet_hdr_sz - sizeof(gso));
 	}
 
@@ -1854,7 +1854,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		}
 	}
 
-	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
+	if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun->flags))) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		err = -EINVAL;
 		goto free_skb;
@@ -2108,23 +2108,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 	if (vnet_hdr_sz) {
 		struct virtio_net_hdr gso;
+		int flags = tun->flags;
 
 		if (iov_iter_count(iter) < vnet_hdr_sz)
 			return -EINVAL;
 
 		if (virtio_net_hdr_from_skb(skb, &gso,
-					    tun_is_little_endian(tun), true,
+					    tun_is_little_endian(flags), true,
 					    vlan_hlen)) {
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
 
 			if (net_ratelimit()) {
 				netdev_err(tun->dev, "unexpected GSO type: 0x%x, gso_size %d, hdr_len %d\n",
-					   sinfo->gso_type, tun16_to_cpu(tun, gso.gso_size),
-					   tun16_to_cpu(tun, gso.hdr_len));
+					   sinfo->gso_type, tun16_to_cpu(flags, gso.gso_size),
+					   tun16_to_cpu(flags, gso.hdr_len));
 				print_hex_dump(KERN_ERR, "tun: ",
 					       DUMP_PREFIX_NONE,
 					       16, 1, skb->head,
-					       min((int)tun16_to_cpu(tun, gso.hdr_len), 64), true);
+					       min((int)tun16_to_cpu(flags, gso.hdr_len), 64), true);
 			}
 			WARN_ON_ONCE(1);
 			return -EINVAL;
@@ -2493,7 +2494,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
+	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun->flags))) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		ret = -EINVAL;
@@ -3322,11 +3323,11 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case TUNGETVNETBE:
-		ret = tun_get_vnet_be(tun, argp);
+		ret = tun_get_vnet_be(tun->flags, argp);
 		break;
 
 	case TUNSETVNETBE:
-		ret = tun_set_vnet_be(tun, argp);
+		ret = tun_set_vnet_be(&tun->flags, argp);
 		break;
 
 	case TUNATTACHFILTER:

-- 
2.47.1


