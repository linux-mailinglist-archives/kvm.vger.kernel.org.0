Return-Path: <kvm+bounces-40496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 00BA6A57EED
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 22:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A84357A79CF
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 21:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C94215042;
	Sat,  8 Mar 2025 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yfozbKL7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C602163A6
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741470062; cv=none; b=N+LsoAdZZhcxUY1uoSbIJJULTmAn+Vex285m0FXB18xP1pHdaO7R71AhTzanaE6fkVxna5++2ka1Itv9ldWI4zjWEb168/dcMWy3NrStpSrbIiMPzVQB4OH3sjnuGwX+NY6/012eM+/GC+LK2qxBDy9poFuVNIVlkqj6l914/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741470062; c=relaxed/simple;
	bh=gHHNZtQlI1ho4RJZpoBeZXSIeWU2nyDxuNd9wfJYYzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R2+ebpmU8xbyNlY9pWYiZB+eWf8x7pl8/yGg7jebQaaVplSJTwcvrf5vrAfXyVgy7GymeKAUJkgDqGNGAymwJ1MleawDHr3UK+SEW0nsO/K78yzafSvn6MEMYTezSFB+/+CE04qdz00chSbxDtZV73WUWg1ySfKAsRms88e/KBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yfozbKL7; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-5fea43da180so2985963eaf.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 13:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741470059; x=1742074859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8MBZgO9/mMLxEqMacEbQemluc92d4gH7fDKPm4qz0ro=;
        b=yfozbKL7eN1ZxKNLGVCZ0T8OnLZQnN5qpz0YtFGm6BBF4limlekcg8TdoWS+IYQJmJ
         XhNaGhCeaj40GcgIktp9kdpoc4UwghS5Bqk0CznleyFcn28dTHtLg63cd24IdPyV/8Kg
         v/YuBQa2Ng6tPyIcj9kPjoMujaDPWQM28Y4zXGRcmMgZC5oLgvgG12ZgdxRh7kXK/XUk
         BXCXJV+tf5KztXhcv6ieDzodhZ606wMcqzCHcocOXvWogRbh6NTIDXDIyrJawvHYouiV
         vIDMA5FNeC7mHEizaClb5moqFYQ81vDcHE5BQi+Nv17hAcm1XYNrgrSt8wvXNzd/otjh
         gVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741470059; x=1742074859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8MBZgO9/mMLxEqMacEbQemluc92d4gH7fDKPm4qz0ro=;
        b=f+DOZ4rJH+9UqBv4gs5HGhu3jgIj/Ep6AQYxvu7uFH7cUkcNI+wCSTXy07xPJ3EVPN
         b40pFG5oZAA4ytzOrmKE0Bt7neJ65KdiNmhHP4rewHmt9pYVwdDRKkhtVVCc+9spA9ws
         0jE79T73zchYcoDL4mGMaI9PWnXU22C5lGN0hGrEYb0ErTkBqBXUfHUsPFA/PbIOQVXE
         OO8VVxXCNWnc0qTnClIrDuW273dSRiKJPiT1a7Jw1ALyd4S+rqAo6XCV4k0H8OYMWmpH
         mnDXHbLVE9UsBbO5s5LuEOua2zXPzSpHt2zxCuxPdS5cVH7z3rMxI0SnHkdxnnvtQKho
         wLlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHDBx1jm9ksQaJ26f/98Ve8C1busnswcIWw3SMom/NT6tgA6G7123z2eoQqpSS6FCkTiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxB1d7VFgXS+AXgpu5Y08Pnw96cFOwcoMub4Z3Dkf1RE3aPxDyJ
	rwEujTbgNQT1mjiiE3iy4vthz+mrZzxVF2cDZyyHmWE4t4ykMoWNOr8QbItts6REP5gQVv7Huxy
	qop5kaj5TGRPIG4YlpakSTA==
X-Google-Smtp-Source: AGHT+IGTSt/plByX/+92dhEDUet8TI73ntJDZTnO/NP8eEfo8nhvCGID+mTdHpAuMZUG8Bn86E6QbOxlIYhAKteIYA==
X-Received: from oablw17.prod.google.com ([2002:a05:6870:8e11:b0:2c1:64e4:adb9])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:4d12:b0:2bc:66cc:1507 with SMTP id 586e51a60fabf-2c2610714b7mr4380461fac.12.1741470058886;
 Sat, 08 Mar 2025 13:40:58 -0800 (PST)
Date: Sat,  8 Mar 2025 21:40:43 +0000
In-Reply-To: <20250308214045.1160445-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250308214045.1160445-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.rc0.332.g42c0ae87b1-goog
Message-ID: <20250308214045.1160445-8-almasrymina@google.com>
Subject: [PATCH net-next v7 7/9] gve: add netmem TX support to GVE DQO-RDA mode
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, 
	asml.silence@gmail.com, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
enable netmem TX support in that mode.

Declare support for netmem TX in GVE DQO-RDA mode.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v4:
- New patch
---
 drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 6dcdcaf518f4..4e95aee1bb4c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2817,6 +2817,10 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
 	dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_format);
+
+	if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
+		dev->netmem_tx = true;
+
 	gve_clear_probe_in_progress(priv);
 	queue_work(priv->gve_wq, &priv->service_task);
 	return 0;
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 394debc62268..e74580dc7ebe 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -667,7 +667,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 			goto err;
 
 		dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
-		dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
+		netmem_dma_unmap_addr_set(skb_frag_netmem(frag), pkt,
+					  dma[pkt->num_bufs], addr);
 		++pkt->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, desc_idx, skb, len, addr,
@@ -1045,8 +1046,9 @@ static void gve_unmap_packet(struct device *dev,
 	dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
 			 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
 	for (i = 1; i < pkt->num_bufs; i++) {
-		dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
-			       dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE);
+		netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[i]),
+					    dma_unmap_len(pkt, len[i]),
+					    DMA_TO_DEVICE, 0);
 	}
 	pkt->num_bufs = 0;
 }
-- 
2.49.0.rc0.332.g42c0ae87b1-goog


