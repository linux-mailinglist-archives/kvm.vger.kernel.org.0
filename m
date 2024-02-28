Return-Path: <kvm+bounces-10228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B0386AC97
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 12:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 540DA1C21E64
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 11:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DD1130AC8;
	Wed, 28 Feb 2024 11:05:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2942E7EF0E;
	Wed, 28 Feb 2024 11:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709118351; cv=none; b=E9Ew4E1XsbwxLMXpsBa+R8+cZdxEWntMhxHBTK+XStbjFMEMaHKNeuQ0rtuclG8h0MbZ7+G4KyijafekqB4z5MS7NXJT8tnTi93GydXzxhUWYiRI8TnGUc1zswn9lEiM5KQxkaJjC6J8BSR0OkAT98ZEKLp6NoGAkNp15UghnXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709118351; c=relaxed/simple;
	bh=msX24r+zZLtPYPWzWYft9WgCYJqgJtT/IZ+EkDMUjZA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SJYxpwWnVd7r1YgSiXV7lmrnHGTe/dddcT7LrRlH5f+sEd2wVQC21okIRkdx7RREO8nhrC8eMa4Jt5pQ2J8eqHZPjDBRSGIpWAIX6JcaYsaa0ExAB6cV9sc1IuvF+Vf1etIWdPRY1UE6YzvCpQyzY9Jx5pRqf37GOF8iqqxaCQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4TlBLl5qSwz1xpkf;
	Wed, 28 Feb 2024 19:04:15 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id 007071A016C;
	Wed, 28 Feb 2024 19:05:46 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 28 Feb
 2024 19:05:45 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <bjorn@kernel.org>,
	<magnus.karlsson@intel.com>, <maciej.fijalkowski@intel.com>,
	<jonathan.lemon@gmail.com>, <davem@davemloft.net>
CC: <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <xudingke@huawei.com>,
	<liwei395@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v2 2/3] vhost_net: Call peek_len when using xdp
Date: Wed, 28 Feb 2024 19:05:44 +0800
Message-ID: <1709118344-127812-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500008.china.huawei.com (7.185.36.136)

If TUN supports AF_XDP TX zero-copy, the XDP program will enqueue
packets to the XDP ring and wake up the vhost worker. This requires
the vhost worker to call peek_len(), which can be used to consume
XDP descriptors.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/vhost/net.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f2ed7167c848..077e74421558 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -207,6 +207,11 @@ static int vhost_net_buf_peek_len(void *ptr)
 	return __skb_array_len_with_tag(ptr);
 }
 
+static bool vhost_sock_xdp(struct socket *sock)
+{
+	return sock_flag(sock->sk, SOCK_XDP);
+}
+
 static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
 {
 	struct vhost_net_buf *rxq = &nvq->rxq;
@@ -214,6 +219,13 @@ static int vhost_net_buf_peek(struct vhost_net_virtqueue *nvq)
 	if (!vhost_net_buf_is_empty(rxq))
 		goto out;
 
+	if (ptr_ring_empty(nvq->rx_ring)) {
+		struct socket *sock = vhost_vq_get_backend(&nvq->vq);
+		/* Call peek_len to consume XSK descriptors, when using xdp */
+		if (vhost_sock_xdp(sock) && sock->ops->peek_len)
+			sock->ops->peek_len(sock);
+	}
+
 	if (!vhost_net_buf_produce(nvq))
 		return 0;
 
@@ -346,11 +358,6 @@ static bool vhost_sock_zcopy(struct socket *sock)
 		sock_flag(sock->sk, SOCK_ZEROCOPY);
 }
 
-static bool vhost_sock_xdp(struct socket *sock)
-{
-	return sock_flag(sock->sk, SOCK_XDP);
-}
-
 /* In case of DMA done not in order in lower device driver for some reason.
  * upend_idx is used to track end of used idx, done_idx is used to track head
  * of used idx. Once lower device DMA done contiguously, we will signal KVM
-- 
2.41.0


