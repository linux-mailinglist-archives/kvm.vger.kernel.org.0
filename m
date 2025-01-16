Return-Path: <kvm+bounces-35623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C6BA134D5
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCAEE1883940
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6941D95A3;
	Thu, 16 Jan 2025 08:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="olchhKeF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B7F198E63
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014938; cv=none; b=Qea0n0InssFDRKi2tLnjeRfen8BXlNaHmpRh0ylYiaLhBfoflt+QBqFX8tHJPNiOJ3u2wLlSsOBGo7ymvujhhvjrbDrj3sefcdMkcvuUUvpw5AVpganVaJ69Ce1EX4/WNrIV95qs4d/Z9Di0Kk2MoQWUxqiWw5nHgvt8fmkGzxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014938; c=relaxed/simple;
	bh=GaoqUecKAtyQ+qguYmr90B1yeZ/UsTWOKRqkOYcnF54=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=KOs26lptI/XUNp4fL/tf5jXimjACJM/jz7qKTFaY/k+yASf7vZ6794gg4jgWSbILdbxCmRNz0NebyMkvtbu5ssVA4cnyARQLi6Co24TFkYOO7wyrHF20OwZl1KdphdqTBjpUZBXo5qs6j+tzUhzcu1YEyjCk/M2rio8A//R4qiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=olchhKeF; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21644aca3a0so12958305ad.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737014935; x=1737619735; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sr3AZgpAWe/4VnOS/hnlHnXvPWA7Ea0pV5fu0VlMHbQ=;
        b=olchhKeF0ORSjOEUrsFJ32BHlvGzk8IdNKAnnPwSI9mH4RctjOvlvmhReG+Qvk+4GL
         p32aODsHZrmIyHNYs0mOl/nkUyochFQyGffR5PRhucz+Zn69wkTEWUf+DvmrIBlu3Fpm
         oq5vvxOa67jtDN2AYHUO4tgxlkipO5/Gsz4Om7nvFOUyEktuSJVy0S65jopX867KJQXO
         lAw2JN+bCxQTuVmF38hLwz6hjLcq2FdRi/K8lvW69XAeXbGdQBTu9gZRFHHYqttYyqhu
         B5MuV3/zZfA7GT9p3PVW19wxDdqG+e9T4uXShI5eSuTH6MOVNioP210u/G9UlcPY6wqx
         1iAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737014935; x=1737619735;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sr3AZgpAWe/4VnOS/hnlHnXvPWA7Ea0pV5fu0VlMHbQ=;
        b=MHk74O7vawzBIMjP19UCv71d/F/+/SoUK+ryVFNErQ1IeweXDVqBCKgXJaA6bU3jQq
         1ZLs3NCsob8pW7N9QhZ1RTNRBKRvWmLG22XYxTMKIWSEXCQk/0bCVU9tiWfULU8NTTy8
         XfKVOF1VP/tcHRJm6IemEJcT3H1z7DyVMp1ADbb1YBePylIBWDmmdNVxbpCt3RgLC8pY
         vIS6oJTQoJ+vkSOuaXhbzVraNlRQAurdUiWMWNFkBbEIHlEGNkxb8EWvMsVYi7tw8i9N
         nQ7fGZod7knr4JBPkTa4ZCuiijSGz51OqJX7QUdB5HtScJ44N/teyMykxU5Z81FPcrxT
         kwIg==
X-Forwarded-Encrypted: i=1; AJvYcCUdj8YCwKzsIFtLVkC8hIAEKqGHZ4sL56R/NJYgwsPFD1JG21skCWX4ODpWcF4Lpsle+WY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRLW2xWaoQ7oMffnKf/qvL1GMsB+L1cKMfYcpdgB09ljhjoySf
	yrUrf5p21uQgK7qTHu4hM25zHv9XbjWZhIj5gYS9TcxwDfSmcQnBfTSaAyboKNU=
X-Gm-Gg: ASbGncukdlkJ5su7qIJqqX5yHaSzkaIrRslWWTPC3J91YMkZcqTdlgjUqT4wExqHEZJ
	jZHFPvRiqbPnWbyEX9itDOty3eqA991vxR9DjEhv46Ruw/yxBAEmQH7vESkmuIzkwcZKumtDeeb
	i/1NIzivmCSR/Bss9DQnnpdVi5s5X0wCHTybc3Lv6WWsUWIMdVkHBvf9dB4u6Md9hSzfuOze6h9
	k3pqe0Q9Qn8vEZsNZudjq1shsS6dDBHfCyRlSwBuxgQZscHkkEbESc4K24=
X-Google-Smtp-Source: AGHT+IHS/tQI+KZgiPpOBaU0C7Tuw2h4kHEXmyIHIVzfFUu8R974PCCRg9snVdH9CSEC/VT7pq33OQ==
X-Received: by 2002:a17:903:1c8:b0:215:30d1:36fa with SMTP id d9443c01a7336-21a83ffbe2dmr449801035ad.39.1737014935205;
        Thu, 16 Jan 2025 00:08:55 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21a9f13e9e7sm92600955ad.101.2025.01.16.00.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 00:08:54 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 16 Jan 2025 17:08:06 +0900
Subject: [PATCH net v3 3/9] tun: Keep hdr_len in tun_get_user()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-tun-v3-3-c6b2871e97f7@daynix.com>
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

hdr_len is repeatedly used so keep it in a local variable.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tun.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index bd272b4736fb..ec56ac865848 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1746,6 +1746,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	struct virtio_net_hdr gso = { 0 };
 	int good_linear;
 	int copylen;
+	int hdr_len = 0;
 	bool zerocopy = false;
 	int err;
 	u32 rxhash = 0;
@@ -1776,6 +1777,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (tun16_to_cpu(tun, gso.hdr_len) > iov_iter_count(from))
 			return -EINVAL;
+		hdr_len = tun16_to_cpu(tun, gso.hdr_len);
 		iov_iter_advance(from, vnet_hdr_sz - sizeof(gso));
 	}
 
@@ -1783,8 +1785,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	if ((tun->flags & TUN_TYPE_MASK) == IFF_TAP) {
 		align += NET_IP_ALIGN;
-		if (unlikely(len < ETH_HLEN ||
-			     (gso.hdr_len && tun16_to_cpu(tun, gso.hdr_len) < ETH_HLEN)))
+		if (unlikely(len < ETH_HLEN || (hdr_len && hdr_len < ETH_HLEN)))
 			return -EINVAL;
 	}
 
@@ -1797,9 +1798,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 * enough room for skb expand head in case it is used.
 		 * The rest of the buffer is mapped from userspace.
 		 */
-		copylen = gso.hdr_len ? tun16_to_cpu(tun, gso.hdr_len) : GOODCOPY_LEN;
-		if (copylen > good_linear)
-			copylen = good_linear;
+		copylen = min(hdr_len ? hdr_len : GOODCOPY_LEN, good_linear);
 		linear = copylen;
 		iov_iter_advance(&i, copylen);
 		if (iov_iter_npages(&i, INT_MAX) <= MAX_SKB_FRAGS)
@@ -1820,10 +1819,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	} else {
 		if (!zerocopy) {
 			copylen = len;
-			if (tun16_to_cpu(tun, gso.hdr_len) > good_linear)
-				linear = good_linear;
-			else
-				linear = tun16_to_cpu(tun, gso.hdr_len);
+			linear = min(hdr_len, good_linear);
 		}
 
 		if (frags) {

-- 
2.47.1


