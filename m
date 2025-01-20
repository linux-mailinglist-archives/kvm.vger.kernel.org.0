Return-Path: <kvm+bounces-35961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DAEA168C6
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:04:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C51A1889FE2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 09:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45C51DF743;
	Mon, 20 Jan 2025 09:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="1YqH7BNd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0E61AF0AF
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737363704; cv=none; b=dvjofDMpi5tpsX/fW+okn18UgFBhSu5vtVpTulEOQmvw8wUq7CwJJpmaDM5s0xtTyztT71lpCr/j9P3bVcEgeX7KUDflHOC4W3JjhNXOqoBnkjIxW2E6Z6O2YU0U6MkudoyeG5xgco25WfDnB633cFvvOjTm7NsUPL7Efolff4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737363704; c=relaxed/simple;
	bh=HCC1TB2JnsejBIhQXiuHZ87jAkzuIxmozdRWSI4CgLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=Dv8f2glU+bIU6AMB+zJekqafncVCVfOhimhhySPONefIt4XTofpDD0ce5De09XPiZtAclISRPbz1c+3mYq0uH/XfJi+iT6rekTF9GyArHeKfZnH5qNzcCTmPgh7FXVhlv9q6E/HttO+nnowbqguuYXEZ6CZmAdqS38gn2+xwJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=1YqH7BNd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2166f1e589cso103452725ad.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 01:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737363702; x=1737968502; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=87auSTBirOR9mtDtSjr+Anr6dOurfYcbwGKWr12CzKY=;
        b=1YqH7BNdoGUdCnSOoOvGBxGfCJtE0qiYMq7HeDw+IeIAkGseIQc2uHXL5rFBPuAUc+
         3pFR/tOFg2NPEvoLkDfaZ5fuqTVqHyTHmw/8mjV0rOQUEgMh1yrOA6toPYvC3qoXdLLo
         lURp90f6W5L/wF+a8SJ1MALD7iTWBWcoXsWSJl+grYsB/201wkMLXEtG3PtatEOxKmle
         3reu/tVnEvyq7sFjpASk2cJieI6uarTc66ZMOn4cmyLNHOIyCeoNBu9cUuD+Hqcq+iWN
         Sc1BrFMS3QFA4hvwJpXy1e+d2WlqVanHdDPGvIzP9O6gAIEjT+PooNvTrZk2ndozkAAZ
         4OKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737363702; x=1737968502;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87auSTBirOR9mtDtSjr+Anr6dOurfYcbwGKWr12CzKY=;
        b=iGrFqJX1NliME7kOZkKFGDCzF7jsM7DeNUbtxqEO/LOwWOiv8+p5YIrKgbNtrpsTdN
         HBQcc5LE9oxGup7vxvFfupqXA5kPsRy/vlbSDBuZHQHV1F7VU7ThjUt+tXAkS6hlu2VI
         8KNEmADO4hHRcvdmsM4k/Oq9/w1RTS9M1WebEtPJ8ANVRQnDeaks0cEnwpryx7Ar5gEz
         41kGSdF0pwdkn/NIUFwgmC0yo1uR9+KD1jL1W4fiF3NAfaouj79D3F9E9Jro2+sZwOWu
         /4/B96C1qbtDApzsdZ8pY60vXnOsmOHIpCfNsddknEIFmP7vc8XASBvqxoVpcnREnTn4
         IEiQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/doM+GVKTs8V7ASfTSE8gKb3A/axWCMvsXhx2/13az7NjNnm4+yDc0oz7KOAcXGYmthg=@vger.kernel.org
X-Gm-Message-State: AOJu0YycyuAv/mnBviNH2I7m6BhYrcLT7poG3zRdp+g3cEOclbIF/w1J
	lZ827Nz3Q0aJgDKZQLB6u/gml1kTNedsYfvYcg/L1Wn57KihYYqe4TumPDCeaKhkruNF0f3OiF9
	0iBU=
X-Gm-Gg: ASbGnctbT1yePDXVeUWXKuPDH59Y2WscmphddXPHqdRJaq18y+tjKh7Aqe63B2bHDV6
	mfNgfjZ6BX0d4NP15ze4DQ0kKk2z1C4bsdShtUfzh1rojrCWaVY99Ys5bWQhAjekjQZraY4cpOh
	XFZrGyQ9ZJsKoReM/9VItOZsi6sHaHSqHWzv+wLRdePXsrC2cQC6P3VDKDC0J/vjrMIHDKpXtFV
	YgaZg2Rl6yKDXEuDqXZ3XEVourdiy9fN8AzMtvWVFR0/OFbVJRrbPOLthyEPQRXLw8Xjn+Y
X-Google-Smtp-Source: AGHT+IGLR93WqsCZ053+MjqXMxSgfHfX9VZsicHSXVEe1/bIQZebS5wSQUjIqaTjuz4uKaG0GOmcHA==
X-Received: by 2002:a17:902:e948:b0:215:6f9b:e447 with SMTP id d9443c01a7336-21c35621db7mr180247815ad.30.1737363701892;
        Mon, 20 Jan 2025 01:01:41 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21c2d40278dsm55514515ad.223.2025.01.20.01.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 01:01:41 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 20 Jan 2025 18:00:17 +0900
Subject: [PATCH net-next v4 8/9] tap: Keep hdr_len in tap_get_user()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-tun-v4-8-ee81dda03d7f@daynix.com>
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

hdr_len is repeatedly used so keep it in a local variable.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tap.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 061c2f27dfc83f5e6d0bea4da0e845cc429b1fd8..7ee2e9ee2a89fd539b087496b92d2f6198266f44 100644
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
@@ -672,6 +673,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		err = -EINVAL;
 		if (tap16_to_cpu(q, vnet_hdr.hdr_len) > iov_iter_count(from))
 			goto err;
+		hdr_len = tap16_to_cpu(q, vnet_hdr.hdr_len);
 	}
 
 	len = iov_iter_count(from);
@@ -683,11 +685,8 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
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
@@ -698,11 +697,9 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 
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
2.47.1


