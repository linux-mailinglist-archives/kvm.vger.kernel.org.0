Return-Path: <kvm+bounces-44349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD539A9D37F
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:52:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3592B9C677A
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 20:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8F727466D;
	Fri, 25 Apr 2025 20:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFB78j7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB8823D2A7
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 20:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745614081; cv=none; b=u3+ac3zcvr44cLUzgOlj7LJgx3+KVpm5WyNoYn2scSvw48NtjFjZ674+so4QeG/QC5aYrDBLwvQRiVOxCLJSDMayTivE54K6sZkmpctHrkUARK99UUIA09NTdMWdf4bBqReXOtPFy3FgVDDoPM/yB/NK7U8KzL7TaxP3JfMXhKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745614081; c=relaxed/simple;
	bh=ybXhKATj7CrisJsV3ztXUW5orezPZDhbn3Vyd8hzv9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X5UhGAGcmzAEzRxEHKN22qSixhLTPQejo3MNnGuvEThR7PCc7brtkpSUVnrcIwdBohR0BTdq+rOUB8sBC4xZU7blogcG2ZYiHNz4sglFle4I33bA5r/Aht0TEx/JdyjkeuZ1mDy0UmulkhFHX5Y3XMeyxh84CfTvtSnZFji+7IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EFB78j7V; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7394792f83cso2010095b3a.3
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 13:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745614078; x=1746218878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxYHTZhe8vYe+8ShSl7Hzn29qooJtmnsSGB2cu4sslo=;
        b=EFB78j7VgwT37IdQo8iBIMZc/ZfiEpmmb3Q09W8bDSIfQlNfhqOTCeszfwEeuI7ZFI
         GY1ba1sGBd1axC59qXu4VDEojxQ632qNdUQ/eKH2GfXSNkMZfWISBL+jCovUyVbojQIh
         AqsQ2yf04waMGAjSE5iNJDKvBqvCG7BtcpOSPgM6SVfBohWdMlvw5poBOz6t1ZK3cwMs
         UzMjKGHF4iUyIRhXSGhfsmm1msPoIE8StO41jkrCERwP+CP5jMsWbru4c+8qgwCytmRY
         /4gMhZXiB+gVOX250bicSttAckcwsfSYCRzAIKhON8uW0ut6SjAxED53yQrV0RzgYu+V
         UBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745614078; x=1746218878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IxYHTZhe8vYe+8ShSl7Hzn29qooJtmnsSGB2cu4sslo=;
        b=XYz9LBHFxtyr/ALn29nJu2SvyF9qQPzBsIofGU56guoxNxzzD0MpyZz8yf7bgpUJb+
         pOsFYlJtjHTmGkVdveWDwMkqK2ZZ4kf0rncNn0cnnvzcVVs2WP6wvGbvjrlJzLRpvxqm
         jA6AWgJdrP39okLLHghfImarfxftxNiQ4ExLqb6uJT/HqRJNWCwMdxdowGdOrUxQer6v
         Px/npmC63643At9Pmb3ENn8FeziLKACYVhf3MTsmW4ALVvsZOWmFbI/5RyNqsDvSJnvZ
         oPtwB7gxXqEUuezOYaYivIsyKttY/t5lJBhidaL4XFalG6FSJILlRa9TdnqqrA1kf7UG
         2YLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyNW2k+LX94CaHzHt3oxCxr5RZ4UaEbK27vWsaY/v/4315lt2fhXkZGSEqksKHiVlVJcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQtziDnjfou9NHrUSJKQvO+ixQMRDYH8yecHOHK+3DopwMYAYK
	5oy3vAofR8Mz+HTFpDtDhUCnQH5VSdmRIHXj9GpsL5G2aeZq1O32dwnd2XgM7kURQSb7JJqebcM
	dq/RvYFhooiYnFUBz0ei7BQ==
X-Google-Smtp-Source: AGHT+IGaTQdBBpN1/zbebbMNIQYAb2oZBmPyA2BS0cZfk4sArdWNYXWT5WQfcjBFVnhVm0ZK4ipk7Cf1QSUSz74FMQ==
X-Received: from pfbci6.prod.google.com ([2002:a05:6a00:28c6:b0:736:3d80:7076])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8c4:b0:739:4a93:a5df with SMTP id d2e1a72fcca58-73fd75c4d62mr4859252b3a.12.1745614078118;
 Fri, 25 Apr 2025 13:47:58 -0700 (PDT)
Date: Fri, 25 Apr 2025 20:47:41 +0000
In-Reply-To: <20250425204743.617260-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250425204743.617260-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <20250425204743.617260-8-almasrymina@google.com>
Subject: [PATCH net-next v12 7/9] gve: add netmem TX support to GVE DQO-RDA mode
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
enable netmem TX support in that mode.

Declare support for netmem TX in GVE DQO-RDA mode.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: Harshitha Ramamurthy <hramamurthy@google.com>

---

v11:
- Fix whitespace (Harshitha)

v10:
- Move setting dev->netmem_tx to right after priv is initialized
  (Harshitha)

v4:
- New patch
---
 drivers/net/ethernet/google/gve/gve_main.c   | 3 +++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 446e4b6fd3f17..e1ffbd561fac6 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2659,6 +2659,9 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto abort_with_wq;
 
+	if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
+		dev->netmem_tx = true;
+
 	err = register_netdev(dev);
 	if (err)
 		goto abort_with_gve_init;
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 2eba868d80370..a27f1574a7337 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -660,7 +660,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 			goto err;
 
 		dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
-		dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
+		netmem_dma_unmap_addr_set(skb_frag_netmem(frag), pkt,
+					  dma[pkt->num_bufs], addr);
 		++pkt->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, desc_idx, skb, len, addr,
@@ -1038,8 +1039,9 @@ static void gve_unmap_packet(struct device *dev,
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
2.49.0.850.g28803427d3-goog


