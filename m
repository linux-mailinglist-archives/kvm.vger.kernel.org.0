Return-Path: <kvm+bounces-38634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC42A3CF36
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 03:12:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AB5E189CA25
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084D61E5701;
	Thu, 20 Feb 2025 02:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LYWUIpWO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732DB1E0DB5
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 02:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740017375; cv=none; b=UazhV0lrS9zH4zdS1U5PC80Fg62LgFPhmMIeOCjIyUTkjZY0WxrBQUd2oBfXPTed0a+ICw717Lb9ShjGHoR0XVd5OC2y0JwvrihhwbFkX2HnJnvdDYAvhuesNIY4eEQp6x9JvVvCJeakqWcXb9ImoiTP3n/+2SgvfBwQVZPCIY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740017375; c=relaxed/simple;
	bh=4a9/ASNRGrjKbqFRJBcsMKUl4XJqLT98iBtNZ9Vd0eg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=caSTjvsLvX8ujGooVkFKeXO0FXcNo0avUMaoEF6YxqonyBF7nO4YL+jnihLGliNM+Gx3Ri9NZ6KOn9KmvDlT0wQrwduxa+cWItDE2jdX+Ij9rUxfzngR/9GSQgLVR5bFhRdxrF7aYDRMCSRSIAfontaufa/jKmlfI2ZmUqi/KXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LYWUIpWO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc45101191so905479a91.1
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 18:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740017373; x=1740622173; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LRh16gD1ltrznZeRyUXa85QXYB+P/DDrWPKAZGQNy08=;
        b=LYWUIpWOA+GSjcfhNWosq6YsKO6xn94nUNB2qNY/Bf2MEjcpJqZQalEpBJjP6JTUZz
         /fkD7IcNz8Pz/0L1X7kY96dXmkuAT3sWlQfFd1SFycyQ83huN31iEUh3WD99wVl3WFba
         kI3k6h0W3Jgu7Z8mrUYc6ty493HCVTXz2YE/huK72Rv5oh6Z0J11OwTAeeWXI6suK4DW
         DE95YxZqgHfvSqbEfhNeDN5uImEhYlKh1hVe28G46NDrfky6LiNcQcioZYbC2M7mHJ+0
         E8rAu4xR9d/v9xH3ODM2RL1rAO3OBcpeaRv+0X4cPwKiHE+zb93Kb27+9EHPbQtbZIam
         Q6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740017373; x=1740622173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRh16gD1ltrznZeRyUXa85QXYB+P/DDrWPKAZGQNy08=;
        b=eivi516HuDtKzN/FLTRc9DeD4LlIXkZrLaXrzeepL7ojwbv4c7ls5kciFX1U0vq4Aw
         BqC8vQld61xARFVxlJYzCCpcdieewuiRniaTJjaVlqYH4X61kXCHSoOqagOBWSEmKFqW
         XLYqvaoIkrpW0Sc6vuKtXQi1IHGGXEyl6fb8PpOwPpP+29cawxXik+x/RbET7UUx8ps2
         nFnHqbaXpZYLGDpG8xLJE/ijkxKEFaQ+GttSsyhlaSOrwlobHVITSPY+B1kaGUZ/WJQF
         dpLJhIKPZpv3yNBVZcEPH+cYnoNIGYnX3ZuvAyHjnUljGEi58gBVYUoQcDmWseuKfGIa
         FuPg==
X-Forwarded-Encrypted: i=1; AJvYcCWbEUWJgWrRSdlpnv6AlA+BSUERveenlCUohBWbJ3TzS1SmpgjWcOOGfVWy3+l9S6gjQ6U=@vger.kernel.org
X-Gm-Message-State: AOJu0YztFCUilSHHnpV671185MWgrR4YRJC06lCrZsFzX3enWaA3vWpO
	+vvdmdgZRLnv0Qqm0IWaxAcobe9a1ECQRTTLpZObaPyhMXtyj4VFwMcfUL51x8fClAmGyMspFMf
	VY49JPalixUM12R9309QS1A==
X-Google-Smtp-Source: AGHT+IFv7gdFT+Y+75bNV/cPnBGsSoo+TGhAr3nWoydKdBJ94MrpNFek3G2h7TMlX0xSNhdiJ1pw2YWAResKG+nBaQ==
X-Received: from pjtd9.prod.google.com ([2002:a17:90b:49:b0:2ef:78ff:bc3b])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2710:b0:2ee:d371:3227 with SMTP id 98e67ed59e1d1-2fcd0ca3ad6mr1322765a91.17.1740017372717;
 Wed, 19 Feb 2025 18:09:32 -0800 (PST)
Date: Thu, 20 Feb 2025 02:09:12 +0000
In-Reply-To: <20250220020914.895431-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250220020914.895431-1-almasrymina@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250220020914.895431-8-almasrymina@google.com>
Subject: [PATCH net-next v4 7/9] gve: add netmem TX support to GVE DQO-RDA mode
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, 
	Shailend Chand <shailend@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, 
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
index 533e659b15b3..5047d4e260fb 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2731,6 +2731,10 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
2.48.1.601.g30ceb7b040-goog


