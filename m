Return-Path: <kvm+bounces-37304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F315A28470
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 07:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F9973A5959
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 06:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B55E22AE42;
	Wed,  5 Feb 2025 06:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="RhWE+Q9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9A922A81F
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 06:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738736599; cv=none; b=czMAcud7R4JOo/sK0xZbQxlqUeEWIqPGPrsxWzcVIIYU6214HAKaqW49Dn1gXzJOhSlQvgLG8ROMX1dGHNrSYFCNgr0vOyS9QS54hzkGv3XLn+C3o/BhbRALCvuMt/RTFB2C7ouGCByEsNZfoA8U1Zy+LJsurlzSHla+ZN6rMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738736599; c=relaxed/simple;
	bh=a8oH3PNmwIVYj2tKdIrFjYF4Tj+2irxY4kfMh7WOKvo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=lTxruTgQEp5JIybk0ci/FYHj7Oj7wKvqPZXNaFjccjbIlLX+v+xYSdYMx0FOT0PHsvmgFSbpqJhV6Qu1RaQnE5xI9l/OpUnTONC5xyvSYdhnTiXmXb3YZJWOvYpgBphIjphlGfoaRx5wz/QV/20jCcwYYUrkV0+mMk27tb6J3aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=RhWE+Q9Y; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21644aca3a0so149462605ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 22:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738736597; x=1739341397; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M8srIBeyhs4OWM9PodAkxe8Sc4dGj/gPqaYG7YjTXw0=;
        b=RhWE+Q9YEROWBWGUSsYw4nh41epxfN9ekdl/kBLgKyRwQ/XWMNxfvCWGeJBidggLOG
         twM0vPMHhK1Y8DeiC38RTqjBea6wvvmOJVW3RlkMBPs/u9tKbv5WfMExqbKBftGbyKg5
         er7LClnJskywKV3zwzNZpCkak5i8VF3KY2vlGOtEkEAQ9qtWBcRqVpYw/IVcq+ZcqiEx
         gtW1Iqi2IcPmtNBPB3Bs9Wi5QwCAf2IAiIvFgiJV3ns4SCSXOKZPYz9/SexaKIc9UC1Q
         OpLpLGkuyz6RNuxUg0iHOcQBDTz9i6KEfHZOoLCmb+l+FcInIRKEmK2hKERtEE53Es1I
         NsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738736597; x=1739341397;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M8srIBeyhs4OWM9PodAkxe8Sc4dGj/gPqaYG7YjTXw0=;
        b=JsJfmG4HL15TCq9cpHsDSE/23HL2mXiKTW3WweW+FpiwFenLPrSZZC6QXceUyFqq3D
         6frotXegiUTzD+60RJTeX1nZlTZ5qlEtY8HkfgunK6eENQpEgx0eZtNBsn92qq/zIgjz
         IucdeoKndTbvM6U5qi0ce7jtrffwYDQm87msGyGrvL1paHUSFTXsNIeypRdum0JrBYxi
         1LbXTz5z9mZNamduYYkDWqHdKkbCDhnXAzsswc4I7pwhJt7en+dqQF+y4fbL2KTG+dK0
         /S9DTTKwUfAGTwcRh6GUHrGYfPCMTfnB+dOKWCThNIeJwVDWL5TRSzIf4feBOMZj8dgC
         aiAw==
X-Forwarded-Encrypted: i=1; AJvYcCWQdDalizbb0r1WiVHBeCrv4gmE0WOP/C/63NHD85IRyP1RYcEAKUbiIO//s5dMu5mnHDI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb6nH89f5uzS1B2x7DUMytJJoqXIQaElxdcpSAQqsE75Cc+xkb
	uIAOV64gSocIc8Go3jRXSeWagdqRNljbr8+YUEF+wrXjzm4KoeLMuUl8lJ8/uhc=
X-Gm-Gg: ASbGncs1hsUSvNp+IeR71qLFnwjV2xoIOqQu6ZyAo9D5wYgbFqlxB2h2c2fkfHppshg
	7sZ3LvS6wCJxDsi/HhdGXIAU92tyEVyrQGcR1Rm2XZcoNOuTspRWL5DqojJxdvdAA+JXZyWwAhQ
	n7+XUC7zVW2di6FlHjEQB0AJss/ZX6ovQcnhfISAXW9Nr+Xv9W9j0MvzeSbN93Bje/OgqhR0i67
	ksvpM97AYsX6sQ7ZntKNuOXTSK+n92BmWk5RLGHST+NgtDzL5gnsVwMhXOBZDOvzACqoTnCfjdu
	EXxT8jmugrIBnH3hQS4=
X-Google-Smtp-Source: AGHT+IHg1+FvFT5HDL6SfSKULAJ1AqWAEtxmHva7Bnl4TG97CsA76lSGxTRKSfzGYdWpbEr3lj3N/w==
X-Received: by 2002:a05:6a00:2e14:b0:725:ffe:4dae with SMTP id d2e1a72fcca58-73035122ac9mr1991170b3a.10.1738736596777;
        Tue, 04 Feb 2025 22:23:16 -0800 (PST)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-72fe631be56sm11600664b3a.4.2025.02.04.22.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 22:23:16 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 05 Feb 2025 15:22:28 +0900
Subject: [PATCH net-next v5 6/7] tap: Keep hdr_len in tap_get_user()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-tun-v5-6-15d0b32e87fa@daynix.com>
References: <20250205-tun-v5-0-15d0b32e87fa@daynix.com>
In-Reply-To: <20250205-tun-v5-0-15d0b32e87fa@daynix.com>
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

hdr_len is repeatedly used so keep it in a local variable.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 5aa41d5f7765a6dcf185bccd3cba2299bad89398..c55c432bac48d395aebc9ceeaa74f7d07e25af4c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -645,6 +645,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int err;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int vnet_hdr_len = 0;
+	int hdr_len = 0;
 	int copylen = 0;
 	int depth;
 	bool zerocopy = false;
@@ -663,13 +664,13 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		if (!copy_from_iter_full(&vnet_hdr, sizeof(vnet_hdr), from))
 			goto err;
 		iov_iter_advance(from, vnet_hdr_len - sizeof(vnet_hdr));
-		if ((vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		     tap16_to_cpu(q, vnet_hdr.csum_start) +
-		     tap16_to_cpu(q, vnet_hdr.csum_offset) + 2 >
-			     tap16_to_cpu(q, vnet_hdr.hdr_len))
-			vnet_hdr.hdr_len = cpu_to_tap16(q,
-				 tap16_to_cpu(q, vnet_hdr.csum_start) +
-				 tap16_to_cpu(q, vnet_hdr.csum_offset) + 2);
+		hdr_len = tap16_to_cpu(q, vnet_hdr.hdr_len);
+		if (vnet_hdr.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
+			hdr_len = max(tap16_to_cpu(q, vnet_hdr.csum_start) +
+				      tap16_to_cpu(q, vnet_hdr.csum_offset) + 2,
+				      hdr_len);
+			vnet_hdr.hdr_len = cpu_to_tap16(q, hdr_len);
+		}
 		err = -EINVAL;
 		if (tap16_to_cpu(q, vnet_hdr.hdr_len) > len)
 			goto err;
@@ -682,11 +683,8 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
 		struct iov_iter i;
 
-		copylen = vnet_hdr.hdr_len ?
-			tap16_to_cpu(q, vnet_hdr.hdr_len) : GOODCOPY_LEN;
-		if (copylen > good_linear)
-			copylen = good_linear;
-		else if (copylen < ETH_HLEN)
+		copylen = min(hdr_len ? hdr_len : GOODCOPY_LEN, good_linear);
+		if (copylen < ETH_HLEN)
 			copylen = ETH_HLEN;
 		linear = copylen;
 		i = *from;
@@ -697,11 +695,9 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = tap16_to_cpu(q, vnet_hdr.hdr_len);
-		if (linear > good_linear)
-			linear = good_linear;
-		else if (linear < ETH_HLEN)
-			linear = ETH_HLEN;
+		linear = min(hdr_len, good_linear);
+		if (copylen < ETH_HLEN)
+			copylen = ETH_HLEN;
 	}
 
 	skb = tap_alloc_skb(&q->sk, TAP_RESERVE, copylen,

-- 
2.48.1


