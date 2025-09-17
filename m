Return-Path: <kvm+bounces-57817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A23AB7D889
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 498E4482A1D
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 06:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D53283121;
	Wed, 17 Sep 2025 06:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gL2CdkQl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E362727FC
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758090669; cv=none; b=eoBMeouWDvRaK+o6cyzge8cNYph83XatzSLp8KcWJn8Oi+7ECHIVh5Ecbq7ghJfOVVN4uHUBQlJgNcKVpwofFKSlds65FIwo8ShD4o8IbHM46oOyR0ELA0SrBrj5xKLrEmyOPVPGsSyEvXgDlRGpC86E0bf7e+lg0LpZMbIOHkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758090669; c=relaxed/simple;
	bh=OOFDWJmS/f2uGkz6mS7atM5O/HZ8ia2l4cQssj9gFGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N6nNaC5X4rrFjf7p6ugkSeVzdDinLrN5kvdjOXkAIqkgohVnH2q8Gf5BDZPN/uWBNepQ+DUnIKliHbllyYAgZkHrtqcgv5klH3yXTx1nhHHETj3FgJlcCDRpOiN4cBOdMY6gS3SV/lwK4u1kH5mQLbVF82rQwuPfAMiIxO6wyeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gL2CdkQl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758090665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tXbb4k0WVEIXwl73Se7rsi16GpKXRhgcEypjnLnCxSQ=;
	b=gL2CdkQlIwJyf3e3dHjpRA9fw8MyWy0XceBX2OkH9Lx5qwe9p+2PD04KOkU7m5AIUj5451
	ci35qWofrl9gseDm/XeXX69GwidNA1+GDQhDlHgJmvR5KbFnu7EBgEoZ5NWon2FwQ+X59k
	Ey42a14HVpic0M/JF3AtSxroxqDcOTk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-IO6-9WhSNV-lt3xyHxqemg-1; Wed,
 17 Sep 2025 02:31:02 -0400
X-MC-Unique: IO6-9WhSNV-lt3xyHxqemg-1
X-Mimecast-MFC-AGG-ID: IO6-9WhSNV-lt3xyHxqemg_1758090661
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37C9A19560B1;
	Wed, 17 Sep 2025 06:31:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.239])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D1D2195608E;
	Wed, 17 Sep 2025 06:30:50 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: jonah.palmer@oracle.com,
	kuba@kernel.org,
	jon@nutanix.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH vhost 1/3] vhost-net: unbreak busy polling
Date: Wed, 17 Sep 2025 14:30:43 +0800
Message-ID: <20250917063045.2042-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Commit 67a873df0c41 ("vhost: basic in order support") pass the number
of used elem to vhost_net_rx_peek_head_len() to make sure it can
signal the used correctly before trying to do busy polling. But it
forgets to clear the count, this would cause the count run out of sync
with handle_rx() and break the busy polling.

Fixing this by passing the pointer of the count and clearing it after
the signaling the used.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 67a873df0c41 ("vhost: basic in order support")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index c6508fe0d5c8..16e39f3ab956 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1014,7 +1014,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 }
 
 static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
-				      bool *busyloop_intr, unsigned int count)
+				      bool *busyloop_intr, unsigned int *count)
 {
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
@@ -1024,7 +1024,8 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
 
 	if (!len && rvq->busyloop_timeout) {
 		/* Flush batched heads first */
-		vhost_net_signal_used(rnvq, count);
+		vhost_net_signal_used(rnvq, *count);
+		*count = 0;
 		/* Both tx vq and rx socket were polled here */
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
 
@@ -1180,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
 
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
-						      &busyloop_intr, count);
+						      &busyloop_intr, &count);
 		if (!sock_len)
 			break;
 		sock_len += sock_hlen;
-- 
2.34.1


