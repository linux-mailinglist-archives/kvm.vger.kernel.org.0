Return-Path: <kvm+bounces-35955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE5EA168A0
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:01:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65C9D1636E4
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358141AF0C2;
	Mon, 20 Jan 2025 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="D1FLXg7w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043ED19D881
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737363656; cv=none; b=May5xUspet06hMtDUMZaRlVvAgFMBVVe4nxxzJinbyFMKlD/qcghnHK5LCCueftr2tmnuVNKSRXdij1BQTt7SWwaoh9omoDXFKajF0/e1r+321rv8cLnmGe4iqxmQSkcDcQMEZ68gMKvIaMbz8EGkVcTtyoblYWgut/GBR6ZEc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737363656; c=relaxed/simple;
	bh=zHg9Cy8I4qWXw+IxBd6zljTvx2oEOGkHWlUMuk6vkYk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qNpjjA2eJBeGn2VlZJRg+WO6T3ztCofTzD59yyzPGaWP6N9a6JEn75nwXksiKP/Dh2dWfrdMHBkfWza5myjC07z6IOJ8Ad0lRfFr518sgLOiZZRSQnuUHp3n3VEqjCWBHMylyYE4GX8papo1dWmdU5TICWEHCrnc28BPKbjsQ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=D1FLXg7w; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so7293304a91.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737363654; x=1737968454; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VePH2j532nDqTqhBPliR5apz+cKR0EPoqHmjo/gIw7o=;
        b=D1FLXg7wlcDIKoTyWpjk/Lo9u1zZLocCvpWk+usisN5eG10kGnQ/rli4UzStQIGY41
         zAQnlR1rZF+U18HmgstTX9V/CidbEIxA1FNoLcUvDDtB/1sgo3SiTmOR3lcgAH8C41wv
         ZM+CxE5/Q9+HevKiWwszIeCTfunOwkw+UEmsUXs4HNgCtp07wVgcsZJrzQ1ecCZGc4q1
         5Z0P8SQ4ME2GpnFEL2SfLr3/DUwpHdoq7uNrGjGQ1mc5+D9cCG8/tsLReAXGFmuLLZWZ
         ZIcTdEOl8MZCNZIxrO4Ls2QgZIXrLPKH4aGELzQTvUlkFZQ/KC4rwospzBJlwp+83+N2
         ZX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737363654; x=1737968454;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VePH2j532nDqTqhBPliR5apz+cKR0EPoqHmjo/gIw7o=;
        b=sUSqEbVERfkEbfYx6zW5XwuDSQx67w0SKwmPxXCyxheuWnpFNy1aYaHpOXxVBDi06+
         C0bQgXCfGzUNkpEjoOGsZILwG/GQn/nNY1yARp6znQSQDh8NG19f9HWSLtIh4K+gsEyn
         6PN34Rpe+vHXOzQ2Y3wh/7Sv4ZtNLna5ZCfQAWhz9D1rKD9d4JpluR6EYdRaeblc+n6l
         EamZpEM/FrPZX28lzbUup9vacZ33OdAsJgTK5l2K7ZPCLzdVRVGVGMlQsRab14+Rl7si
         jVvmpmSPy2BodbOn6WUnrTMHGWZuRdN6P+d+zH3BS8VSyZEa4WPOVInZ9HMzkNEYIEMH
         1gNA==
X-Forwarded-Encrypted: i=1; AJvYcCVDu/q8dTQWmkn2O+wr0MmcKd1mh8EkwKapUMe8kAKyfPW+hz+WdiF1l6rydtLHkh/mwZs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDxoQpY0vdZjXRNDdDSjmTVPj390nAJfZwUrBUKEACrovQa9m2
	el+ASPLl85u8aoxasVdd9q44iAM82efmYWlrp+xpxPyxnHPWjpOPCff+LDuwEiQ=
X-Gm-Gg: ASbGnctWoodjRne1EkXls88yGdcKiEBxPEb8Rdok+tBIF4KxpsCPQcJioCkjpmOtFh3
	0KSnKEErW6/BNG2kvNJ4gWplYHxDAgm1rnXuLo0mE1yURODYfsFzTlgi+9acUL/huT3eH8oLTjx
	Sj/QASvHe3MtswVZbJQ152Zhk6w4EVc1yuzsAJ8cfC8EYDFLxdju7BCSFDj3AbJvmXEc9uLZLRi
	QHGXsAYgKdj9d52C5l8oHjH9bB+UTiyxg9OPy7VeOToy5H/niqjYDIsNjoRDwF5eXTE3/Rl
X-Google-Smtp-Source: AGHT+IF9xy+qbBUCxeeJNWw0q1iQeKpxfAGNhBsUiRjFFk20hQvN5icVdaETT9eWWpl4WoKAAydh6Q==
X-Received: by 2002:a05:6a00:a95:b0:72d:8fa2:9998 with SMTP id d2e1a72fcca58-72dafa44feamr19326150b3a.14.1737363654076;
        Mon, 20 Jan 2025 01:00:54 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-a9bdf0b50c6sm5386971a12.68.2025.01.20.01.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:00:53 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 20 Jan 2025 18:00:11 +0900
Subject: [PATCH net-next v4 2/9] tun: Avoid double-tracking iov_iter length
 changes
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-tun-v4-2-ee81dda03d7f@daynix.com>
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
Cc: Willem de Bruijn <willemb@google.com>
X-Mailer: b4 0.14.2

tun_get_user() used to track the length of iov_iter with another
variable. We can use iov_iter_count() to determine the current length
to avoid such chores.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/tun.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 452fc5104260fe7ff5fdd5cedc5d2647cbe35c79..bd272b4736fb7e9004f7d91dc83c69af5239bfe0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1742,7 +1742,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	struct tun_pi pi = { 0, cpu_to_be16(ETH_P_IP) };
 	struct sk_buff *skb;
 	size_t total_len = iov_iter_count(from);
-	size_t len = total_len, align = tun->align, linear;
+	size_t len, align = tun->align, linear;
 	struct virtio_net_hdr gso = { 0 };
 	int good_linear;
 	int copylen;
@@ -1754,9 +1754,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (!(tun->flags & IFF_NO_PI)) {
-		if (len < sizeof(pi))
+		if (iov_iter_count(from) < sizeof(pi))
 			return -EINVAL;
-		len -= sizeof(pi);
 
 		if (!copy_from_iter_full(&pi, sizeof(pi), from))
 			return -EFAULT;
@@ -1765,9 +1764,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if (tun->flags & IFF_VNET_HDR) {
 		int vnet_hdr_sz = READ_ONCE(tun->vnet_hdr_sz);
 
-		if (len < vnet_hdr_sz)
+		if (iov_iter_count(from) < vnet_hdr_sz)
 			return -EINVAL;
-		len -= vnet_hdr_sz;
 
 		if (!copy_from_iter_full(&gso, sizeof(gso), from))
 			return -EFAULT;
@@ -1776,11 +1774,13 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		    tun16_to_cpu(tun, gso.csum_start) + tun16_to_cpu(tun, gso.csum_offset) + 2 > tun16_to_cpu(tun, gso.hdr_len))
 			gso.hdr_len = cpu_to_tun16(tun, tun16_to_cpu(tun, gso.csum_start) + tun16_to_cpu(tun, gso.csum_offset) + 2);
 
-		if (tun16_to_cpu(tun, gso.hdr_len) > len)
+		if (tun16_to_cpu(tun, gso.hdr_len) > iov_iter_count(from))
 			return -EINVAL;
 		iov_iter_advance(from, vnet_hdr_sz - sizeof(gso));
 	}
 
+	len = iov_iter_count(from);
+
 	if ((tun->flags & TUN_TYPE_MASK) == IFF_TAP) {
 		align += NET_IP_ALIGN;
 		if (unlikely(len < ETH_HLEN ||

-- 
2.47.1


