Return-Path: <kvm+bounces-49365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E658AD8177
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 05:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 020FF3B1EE6
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 03:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08EE2265CBE;
	Fri, 13 Jun 2025 03:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUZ9fw1O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBAF2638B5;
	Fri, 13 Jun 2025 03:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784336; cv=none; b=ZTLpN+5RfgwTksO1LS+48jRzU45h/CkNCYbgHd+PULy8ozxWLJ0RJy7L7iTv5+3ICgCoPCVAidaOQ/UbhCcfACI8bep8wxkB05uWZ9bk5aIZD37c4IRGPP3EwIyELwy5xxvW2gw7YGLvH8/y8oteRVNSaYt0cDj5c3jWRdibYkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784336; c=relaxed/simple;
	bh=JpimrpV+MtzzCPBuM8z+T+yol8hWsqq4uAYSN7jCxp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wem2nplCOEB6p50zpAvxds8IdJ+yn0T+UNi8Owkow1OdxzyuD0WJhDfm8giYkzayVKkrBjqZamQECpgD/4COZWXFe2L5eaP3es/cnpn5G0gR0BJCNq7O3Ib9vZ05zb2Dyh5zNFVvJF325m/TSy/tlGgGNC8fplgS5MI8meArdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUZ9fw1O; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2353a2bc210so15890955ad.2;
        Thu, 12 Jun 2025 20:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749784334; x=1750389134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5pUMawIHS3ge9aNMrUwuQCI1wFUmsQ8BlgJBs2il1xQ=;
        b=JUZ9fw1OH3kOFYfOQprWEt62/QyKbE+M+QKoRrGtXR+Vv9ry8w/IsUXyPSCqP7Hlf8
         6fINDYpuSCTRGmHpu2nHiYsDZyAGejK0Q15EceX5r0e7r/PaWVK/Rk87KCPSFWKgzO5w
         OLpB8v+FloqMhX+OCs6PPX9EpbOR0bl9F2ELPPwUK2xO66VOOjqOfwEW6/NqrttXsWxe
         60cYralbr+t5wszJ0DkV2BEnBZ2CQkk68J5bcxB1fc+BJxeIz1Hvne0JQWA8CQCQusoM
         rShWgBhXyR0Ognk102gqW0iHsOvH9K2J8kpO2Q059uVne3RvFs9ko/zYh9JG7o25aN1X
         M8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749784334; x=1750389134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5pUMawIHS3ge9aNMrUwuQCI1wFUmsQ8BlgJBs2il1xQ=;
        b=Tar8TPlkW7dF5X7RdTh5vMnHc1vjMXlmTxxdsaCn9DCp4ksIivQz+oLm//+3YS8MaH
         aSalek3ftyPNC7hYiaAD2fcJDBZZcsVa2MN7GxHTJzHppX6jxyL4WiJQBN4KtJF9uK8A
         snFUkMjSaek8jFJmFG3XirrVaZxLZbfcYKVKKmbrMLTpJyJTDhtr1Dgx3atZKSsCr5rx
         jWXfEHmVxd9nDXTg5tGdt2UxFdf8nIFs+GekuPgp8dg2S86rUiv1BcuPNN8PYsp24Gri
         3KbfpT0jr5aKgHX0uE34WJHVPVAxJ/PkcaE1f0gr8/LQRVya4sr375k71xOVD9A+ZA1J
         dG5g==
X-Forwarded-Encrypted: i=1; AJvYcCUfPslA1nTgjxAqH229hn0lHw2yJ/7XILh6OAzb42UoPPipdPtUZqhQ2gHiuJNjor5fdfUGuWXmjPRkLgXJ@vger.kernel.org, AJvYcCXa4ozDpvidCEUGB8l0rAqvjyrPEfrfRHp7nO61pimPx5T8pPhbMU95NqrA+7VYakHBAZWgbAct@vger.kernel.org, AJvYcCXkOIK7wltxjB0lSvS5SxHRTRmkKwoN/3u+8Kfdmnam99vz6He09Ovem1HeOD8ig+YXs1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+T4ZzZ1Lae1CsFnhjEf1NCIAZ9fniBK9eXONiLuo6FCpaAZyH
	6hIwafbOQ5Bj/sadUY1TtEMI5r1IJUcAIodG0GqbdbGwtRwcdwgzAskM
X-Gm-Gg: ASbGncsv7w5CjGABIBiWNLGYLQf/jAxoNZ9yqag3kzwdrE+lVoxK7bAVgg7GOOp2vH2
	vtcl/rVI/+lhsso2SND0vWHdDcb8JT8/Cta3cjJz/0Yg599W2Jh/WZja6YGh74QZY5XxMe28/3y
	pn+DGN6S4M28eIvS62TBRUEEJ/zWvmyhqZ4qEja3rSdRsvD+CVQo4vQoxaLznAz8e3PoWO8XNPk
	A852/+D1Mz3BLpbGuk5fd0cRml8pqPVQT/DA9LmB2Ug4CYLoa7n0e7lIE4HXzUAbXYUgn3sZVfA
	CAW5kCwhrwSop7e1BuTqtwKFxLYL+FRGhpITOkeVBaQscz4nfxbzsjPJPMdtcCuqCrDohyKG3sb
	a3kgHFGZ8v9wZLUQmlTo=
X-Google-Smtp-Source: AGHT+IE/WULKBGn+KiKpo+6kHWGrSlbQfCN38Xb5dm/8MIQWGayir5xKvllT8tXaon8W9A8tUHwuiQ==
X-Received: by 2002:a17:903:1b2c:b0:235:ed02:288b with SMTP id d9443c01a7336-2365da0bb53mr17826825ad.30.1749784333984;
        Thu, 12 Jun 2025 20:12:13 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1bcbb39sm2291801a91.8.2025.06.12.20.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 20:12:13 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v2 2/3] vsock/virtio: Add SIOCINQ support for all virtio based transports
Date: Fri, 13 Jun 2025 11:11:51 +0800
Message-Id: <20250613031152.1076725-3-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
References: <20250613031152.1076725-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The value of the SIOCINQ is obtained by `virtio_transport_unread_bytes()`,
which is generic for all virtio transports. The function acquires the
`rx_lock` and returns the value of `rx_bytes`.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  1 +
 5 files changed, 17 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 802153e23073..0f20af6e5036 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -452,6 +452,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 36fb3edfa403..74c50224431e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -196,6 +196,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
 
 ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk);
+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk);
 
 void virtio_transport_consume_skb_sent(struct sk_buff *skb,
 				       bool consume);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..917881537b63 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -585,6 +585,7 @@ static struct virtio_transport virtio_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 1b5d9896edae..59e72d2dbd85 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1135,6 +1135,19 @@ ssize_t virtio_transport_unsent_bytes(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_unsent_bytes);
 
+ssize_t virtio_transport_unread_bytes(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	size_t ret;
+
+	spin_lock_bh(&vvs->rx_lock);
+	ret = vvs->rx_bytes;
+	spin_unlock_bh(&vvs->rx_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_unread_bytes);
+
 static int virtio_transport_reset(struct vsock_sock *vsk,
 				  struct sk_buff *skb)
 {
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6e78927a598e..13a77db2a76f 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -99,6 +99,7 @@ static struct virtio_transport loopback_transport = {
 		.notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
 
 		.unsent_bytes             = virtio_transport_unsent_bytes,
+		.unread_bytes             = virtio_transport_unread_bytes,
 
 		.read_skb = virtio_transport_read_skb,
 	},
-- 
2.34.1


