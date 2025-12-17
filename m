Return-Path: <kvm+bounces-66188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8C2CC93D6
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 19:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1DFEB3060A5F
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 18:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E0C33C1BF;
	Wed, 17 Dec 2025 18:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUGTr0S1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2C4274B23
	for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 18:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995159; cv=none; b=rC4+2M7+Kmu8cl+OSoEivB8ScrY4BtXZ3cXoT3oNMAikEPVNb2YCndYGdOsapervWXdplKff/JUzLBCK9n+YmW2RuP+oto3J4+And2FyEyICcprZs922hVIywZckDYYXXgRmWkKmSIDzLdBeyQBc1c2Wn7OROcuMfs2Lmkyb3Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995159; c=relaxed/simple;
	bh=Jmqh+IeYEuPfjt31rwC4R8TE4lp1zQaI90wvXPqlmWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eIHrRrHA0hpO8xXrizDS7aOIAQ8vKVCvdtjw6AsdpNMSKa2YGp+orb1FkwNVDC3ucgzaJMBJLHH9hX5BZbHolRakOpZHTa7fKbkwWEcGyv8NVaym5aWZawUuFrWTj6GYr+F+Pywvb6TJLvuTzbYL/HeboheO1BkmDGjANTT5J/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mUGTr0S1; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-598f59996aaso883195e87.1
        for <kvm@vger.kernel.org>; Wed, 17 Dec 2025 10:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995150; x=1766599950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+qEOT5fYFn8bKw8MykPWrfcTTy8Zhs7SgEc83K5GNw=;
        b=mUGTr0S1hNDy11oFxzMwD6LIKfLNvr29epV5m9bRtT4p3FFDNHk96OuCvO4caJorqU
         CwlVDtic3mu7OYvHghSRdxATFA2aPLkp6yH2XG5H4VAnLRW0RPh2pmMB4fB4i+VYBmyc
         MVSwQIG7oEO8JFc+oT+Aa5ZiGU4rbUubz3zvqT3gscIhbHOEXzMoFj1c2V2wrDzoFzKm
         2JeSratQTkZ/bEVzatEiYo330fqsneTSbf0ME9/gLzhXv3iMAf7xI9dQeRQaiTpjx+Gd
         Jj26DaEmjhBZQsKjJv9z5mLJNrA/ggtruEliL+NZGwpAErA0Hx7u0ZHdp3+z8wwQa8OP
         FpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995150; x=1766599950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F+qEOT5fYFn8bKw8MykPWrfcTTy8Zhs7SgEc83K5GNw=;
        b=tzZYe3LNuoNTYeHCunKSve0/A9Nl0m5ns13mHd94kDsCqlUeGU5ryxSbZGc7xtdHo9
         jXpJ1tAtu9eP1pju0AMrAbsckqDhLqyMhdN+Kt5bjKlDrjUpWaZL2BDvk4PWh2pcYDLK
         LWUuvBkd8Rscf/ycA3ITtXP/s9RYhtAjld9N503LTjHYAgRdl1AwaBJCH/t78ZDQaMNj
         J1+d2N3itf8FEhScvQFWTM5P7aqjz0ZnjXC4mOHlA/hrIevOjAIf6sbEfbmlSwbZQf60
         4jJKqXuhuKZ+Sjz91r14uEbCmvUr+YRIwsv4HvdzPR/rPOdSqVt0BU4G47yVbGsuG++5
         A2Dw==
X-Gm-Message-State: AOJu0YwhqjQ6VT1VNMa0iQJBz8mjtcjIEV86RW1x9RAkoRNN0JWrL+5w
	fEj/wMseGA9Znvk6ErD43zEDrTGJeh7X/ukJhlbxslUqYWNMU8VdyALmitUA+zRmr8g=
X-Gm-Gg: AY/fxX6AEHWjNu3Mwv7GAGjb+99KQqmNNoOHpBdFTh4HbD7C3IdCsJxYWG8NAc2PN6b
	U2wlfn7ckHh4gL6eO1Zxt6FGkrHPogSgoOJMWnyJhCsBTKcPkEZmM0qNmSo1kcJd4Z9CGFGui2F
	sSoEvsA3AKT3zpfs2mBdblMA/kgXxEs0LYMtiRToJhz5uyn+am1Wls6diDuPS2rHLZMvn97asF8
	WoJcD+fDcn31xmxJ7VoMmdjl+qHCC5XyKppIILn0Q5laAL+cX7kyUYIDgKz2LXgh/WpAE14zpTr
	f2a8bhz9wXtZ91SOjDlRSKhvCjGkH+WxgUIP1qQqnJngipmJll94Hyou70LAox7en8eAQtzIUFU
	lDC+34wMVgfGZ9eBv3qXvdRe5K4ug+BWYWJjJeYeTLksR47UNitipQyfaqVz2nIVtdPFiHdaC97
	i2btozN/vwKSY=
X-Google-Smtp-Source: AGHT+IFaImgQ8mUsB8FX9vCVAZe8oyinyLF2HvL8aiazJQVjXwZSAkQ7Y1ZG0/etX5aTcNag1fMWgA==
X-Received: by 2002:a05:6512:3e0e:b0:595:840c:cdd0 with SMTP id 2adb3069b0e04-598faa14759mr5788325e87.2.1765995149770;
        Wed, 17 Dec 2025 10:12:29 -0800 (PST)
Received: from Ubuntu-2204-jammy-amd64-base.. ([2a01:4f9:6a:4e9f::2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5990da790efsm2591419e87.102.2025.12.17.10.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 10:12:29 -0800 (PST)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v4 1/4] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Date: Wed, 17 Dec 2025 19:12:03 +0100
Message-Id: <20251217181206.3681159-2-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251217181206.3681159-1-mlbnkm1@gmail.com>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The credit calculation in virtio_transport_get_credit() uses unsigned
arithmetic:

  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);

If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
are in flight, the subtraction can underflow and produce a large
positive value, potentially allowing more data to be queued than the
peer can handle.

Use s64 arithmetic for the subtraction and clamp negative results to
zero, matching the approach already used in virtio_transport_has_space().

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e..d692b227912d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -494,14 +494,25 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
 	u32 ret;
+	u32 inflight;
+	s64 bytes;
 
 	if (!credit)
 		return 0;
 
 	spin_lock_bh(&vvs->tx_lock);
-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
-	if (ret > credit)
-		ret = credit;
+
+	/*
+	 * Compute available space using s64 to avoid underflow if
+	 * peer_buf_alloc < inflight bytes (can happen if peer shrinks
+	 * its advertised buffer while data is in flight).
+	 */
+	inflight = vvs->tx_cnt - vvs->peer_fwd_cnt;
+	bytes = (s64)vvs->peer_buf_alloc - inflight;
+	if (bytes < 0)
+		bytes = 0;
+
+	ret = (bytes > credit) ? credit : (u32)bytes;
 	vvs->tx_cnt += ret;
 	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
-- 
2.34.1


