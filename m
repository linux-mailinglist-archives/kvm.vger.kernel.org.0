Return-Path: <kvm+bounces-40896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F583A5EC7E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:09:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17366189E7BE
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D75204C07;
	Thu, 13 Mar 2025 07:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="i9r7FPxF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4445A2046B3
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849342; cv=none; b=rfSAZjsSA7Nc1KJziPa1D9u/19+ycEM842sRLm6JaGX4OjEkDPVoFzfScHHYidPEXWCIZikwTf88h997vDsDpKhV7PjF/jJenK75yci581/T9TN0avXLrmvS6K7xW9M8HoPfgWI7I/kwuzxGXGF3uzuws6+sQ/ayiAtI0+wlDFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849342; c=relaxed/simple;
	bh=ccfXZvxiSAaG5MPb2w/JWrekNXtLfO8PT1kfNykthKs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=kT4+C0HnSIdVH997xm4Mb2XBteIPyUhJSaBxPUjoScGdb7kULUnFmexs4RKcuCnj7VvANs3RXe6JdG8W/iYYSn9F43TUU6zg3nn5t16KqYxyLKur7YXTvS3htL9X5wgtgVmG83GB0NcLu5vslIyodG8Qi2KpW+pqDgTKeflnoZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=i9r7FPxF; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-219f8263ae0so11269255ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 00:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849340; x=1742454140; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e3BkVPEmJoa+6yr2vocUy5kvhLH0cmr2yCWFD5W/C7U=;
        b=i9r7FPxFX/fIVo7ZgYjXUEZDkqOg/OVEQcry6mg+cS+b9Ls4mad/yx0nwZY8CUmkNn
         ZlbDyxDtZw7eX7ZOiYK+Hz2VZUbBj4okO9JeJiqVvbJoXZ1NiWRx9b/PGhF+OGmrkL9i
         pTtMdRoqLo5lgRmN5wbx3JUE5wCmXy8ncvusvdXaFvyVg1cjbl6ZFgjdOA+POkN+hs2P
         EW5xAYjUEJYRplTnVCwTTjx3m66xmvf6RaJwe6bE5ne9GkpFbFVZ26v5bG6C3h9XC6JP
         DNuW1VnjyI1OZj9bFQ0J3KbgKPOUjpQslNlgdVI+f1tSX/appThPc20ZBUyA1AP+9W+X
         9OvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849340; x=1742454140;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e3BkVPEmJoa+6yr2vocUy5kvhLH0cmr2yCWFD5W/C7U=;
        b=stMmyCeJABiFcIPom0CIsW9AZJ44n9z9hjsxZ/XQdYm2/E5j030IKtKc+usF2/wtl8
         ZTf7LzUbeQ6p+PZNCr4BFkKATTCxw/Cyc5otM7eBe74k/Je7TwVMDkzwJQcPRucw4ZCR
         WrYY+lUFF/AiiQbdKMEa7NT+puZq+7ETuETRErhcl03zBVtq7PMYZJ8iBGNM6l8Stgyl
         EREvS+S3sjFiq9zsXUVdj1Z0p5K86+mA0l0ngNhF+LQzp+I3N58rMxx8Ku4Exh5LF6D8
         e5hmRxJZXupSER/pX54OJfdg1W6iMz3LcDdZjCmM4dKxsomqYhyaNKTDSvUIIAdRyU0Z
         T0rA==
X-Forwarded-Encrypted: i=1; AJvYcCWoJfE7vw/fE2IF+XWIg7ai1utT41IYHqbvANimqvSsSkkecRj106eLQFkOi93MlBirOT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKjfBl/lzOM1OXaAttXMTf+Kb/2AURs8z8MrXzq8GyPhjD8AW2
	Nf7UQqz5fslV5UlrBCOzj81s0GQ3mQGZRZU1FvpzBhGbGwNHnOzTdDxqUQvWmAY=
X-Gm-Gg: ASbGncsk/jCC3rDtTESgmUAY+HCd4OItpKiRLpD5lIzFRnBRGhxBy1J8nNZ+Chmjwb+
	7g5xRSOnLbIWTm3GSCmPfiL+peGBQoJiNarROsP3zx3wU5na+VTejgICkOGUj12DgE8q/xX+jJ0
	u316/V4aBXnwI7BdFMX4mSozXgrbeKWHCrhez1M37dqi1TAs8ZpUZXsVtiAAtI8+1IVhXB0PjyB
	qhiPCNe5PtByxfb6LJWRGoEMVqJFRVi5lP4dNhG/HA5//4NK4X1zO8o5PhT1zc4godRJcwcwnvu
	Xabyr3cxqUqqjrSUTrrsxLZQ8Lgo2noK+YaNYgMNNEBG95tH
X-Google-Smtp-Source: AGHT+IFaX1olq5WQi+7fcP4HReHGKVkvSZ9sg15FYUug/XHg7z4NmpOMBbEE1p5tCvq05aXsAHzDQQ==
X-Received: by 2002:a05:6a00:2d83:b0:736:a7ec:a366 with SMTP id d2e1a72fcca58-736eb7d882bmr12600967b3a.9.1741849340468;
        Thu, 13 Mar 2025 00:02:20 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73711695ee8sm632427b3a.154.2025.03.13.00.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 00:02:20 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 16:01:12 +0900
Subject: [PATCH net-next v10 09/10] selftest: tap: Add tests for virtio-net
 ioctls
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-rss-v10-9-3185d73a9af0@daynix.com>
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

They only test the ioctls are wired up to the implementation common with
tun as it is already tested for tun.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 tools/testing/selftests/net/tap.c | 97 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/tap.c b/tools/testing/selftests/net/tap.c
index 247c3b3ac1c9..fbd38b08fdfa 100644
--- a/tools/testing/selftests/net/tap.c
+++ b/tools/testing/selftests/net/tap.c
@@ -363,6 +363,7 @@ size_t build_test_packet_crash_tap_invalid_eth_proto(uint8_t *buf,
 FIXTURE(tap)
 {
 	int fd;
+	bool deleted;
 };
 
 FIXTURE_SETUP(tap)
@@ -387,8 +388,10 @@ FIXTURE_TEARDOWN(tap)
 	if (self->fd != -1)
 		close(self->fd);
 
-	ret = dev_delete(param_dev_tap_name);
-	EXPECT_EQ(ret, 0);
+	if (!self->deleted) {
+		ret = dev_delete(param_dev_tap_name);
+		EXPECT_EQ(ret, 0);
+	}
 
 	ret = dev_delete(param_dev_dummy_name);
 	EXPECT_EQ(ret, 0);
@@ -431,4 +434,94 @@ TEST_F(tap, test_packet_crash_tap_invalid_eth_proto)
 	ASSERT_EQ(errno, EINVAL);
 }
 
+TEST_F(tap, test_vnethdrsz)
+{
+	int sz = sizeof(struct virtio_net_hdr_v1_hash);
+
+	ASSERT_FALSE(dev_delete(param_dev_tap_name));
+	self->deleted = true;
+
+	ASSERT_FALSE(ioctl(self->fd, TUNSETVNETHDRSZ, &sz));
+	sz = 0;
+	ASSERT_FALSE(ioctl(self->fd, TUNGETVNETHDRSZ, &sz));
+	EXPECT_EQ(sizeof(struct virtio_net_hdr_v1_hash), sz);
+}
+
+TEST_F(tap, test_vnetle)
+{
+	int le = 1;
+
+	ASSERT_FALSE(dev_delete(param_dev_tap_name));
+	self->deleted = true;
+
+	ASSERT_FALSE(ioctl(self->fd, TUNSETVNETLE, &le));
+	le = 0;
+	ASSERT_FALSE(ioctl(self->fd, TUNGETVNETLE, &le));
+	EXPECT_EQ(1, le);
+}
+
+TEST_F(tap, test_vnetbe)
+{
+	int be = 1;
+	int ret;
+
+	ASSERT_FALSE(dev_delete(param_dev_tap_name));
+	self->deleted = true;
+
+	ret = ioctl(self->fd, TUNSETVNETBE, &be);
+	if (ret == -1 && errno == EINVAL)
+		SKIP(return, "TUNSETVNETBE not supported");
+
+	ASSERT_FALSE(ret);
+	be = 0;
+	ASSERT_FALSE(ioctl(self->fd, TUNGETVNETBE, &be));
+	EXPECT_EQ(1, be);
+}
+
+TEST_F(tap, test_getvnethashcap)
+{
+	static const struct tun_vnet_hash expected = {
+		.flags = TUN_VNET_HASH_REPORT | TUN_VNET_HASH_RSS,
+		.types = VIRTIO_NET_RSS_HASH_TYPE_IPv4 |
+			 VIRTIO_NET_RSS_HASH_TYPE_TCPv4 |
+			 VIRTIO_NET_RSS_HASH_TYPE_UDPv4 |
+			 VIRTIO_NET_RSS_HASH_TYPE_IPv6 |
+			 VIRTIO_NET_RSS_HASH_TYPE_TCPv6 |
+			 VIRTIO_NET_RSS_HASH_TYPE_UDPv6
+	};
+	struct tun_vnet_hash seen;
+	int ret;
+
+	ASSERT_FALSE(dev_delete(param_dev_tap_name));
+	self->deleted = true;
+
+	ret = ioctl(self->fd, TUNGETVNETHASHCAP, &seen);
+
+	if (ret == -1 && errno == EINVAL)
+		SKIP(return, "TUNGETVNETHASHCAP not supported");
+
+	EXPECT_FALSE(ret);
+	EXPECT_FALSE(memcmp(&expected, &seen, sizeof(expected)));
+}
+
+TEST_F(tap, test_setvnethash_alive)
+{
+	struct tun_vnet_hash hash = { .flags = 0 };
+
+	EXPECT_FALSE(ioctl(self->fd, TUNSETVNETHASH, &hash));
+}
+
+TEST_F(tap, test_setvnethash_deleted)
+{
+	ASSERT_FALSE(dev_delete(param_dev_tap_name));
+	self->deleted = true;
+
+	ASSERT_EQ(-1, ioctl(self->fd, TUNSETVNETHASH));
+
+	if (errno == EINVAL)
+		SKIP(return, "TUNSETVNETHASH not supported");
+
+	EXPECT_EQ(EBADFD, errno);
+}
+
 TEST_HARNESS_MAIN

-- 
2.48.1


