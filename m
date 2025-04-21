Return-Path: <kvm+bounces-43730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60E0A95873
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C776D3B692D
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81EE221268;
	Mon, 21 Apr 2025 21:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="RSdtqQhT"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38A4219312;
	Mon, 21 Apr 2025 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272286; cv=none; b=i/t5K5FH49FJyWmsv9otkWy8Hq2GtV4FYxX7VpWM2iC5FCVloIKv8QCgOe2+4e52ZDexQMoJTVJSymKcF6p3Iar45ExhDo5nhEmNiCizGVZSHcqzksHQC7OeXl1ZuV8Z8++ETkSY5oD0ONfCARTvyzTGtrmLfMhiure5iNjls+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272286; c=relaxed/simple;
	bh=Wse4yBBOfc213KZWiON8OPL4gZVnS7c31xlmnDvSO4w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Sgcn/uOH8XNudSmlwbK2++UQjekH6rj4rXuGwtY+S9CghiODXor34ptmLGHmdmnQzFrUHznra5v1ufiLCagj4CpdPk8ki4AY8tvrlivk0Txxsysp457Z7vmE4ZxbrY0PLWnQSsJ2ntFIo/zEHm7Myw+ZVtKTG02pcPGefp2WmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=RSdtqQhT; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2p-000P7q-PG; Mon, 21 Apr 2025 23:51:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=HCx4RfOmQ7VpHQRdKJQtChL1M92T4VsEIiHTk68PCLs=; b=RSdtqQhT5mo1V22DKp3equpyJt
	Mayi316SPCexBiAXkHGbYFOQlZaS/ULxVa2zhjE3lIKE01owkliV06slWarjezc2PU6IQOEdb6Hb2
	w7uDdWqkyk+/Qtf/8KrhtMZwOBHU1udcQWrBURdx0PfR3bn5qsHxgT0liEC8C+Y7krgrw3JUDUuA4
	GB9mY5dxEGgfGP5PLpEyN4SzgVsb40rh1oPGgfWH8+yZRBvJrbD9a553bdjtHf8OPU+qzjdOSfCz6
	L9PZJ0vExh74jPCHeK2w6FxM8Pd3Pd0/79BYPqVJwkppO3IhJ653uNYR4lXW4N/HaolCS/PDBo9nD
	qSNlYSYA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2p-0000Nl-F6; Mon, 21 Apr 2025 23:51:15 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u6z2h-0056xd-H6; Mon, 21 Apr 2025 23:51:07 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Mon, 21 Apr 2025 23:50:41 +0200
Subject: [PATCH net-next v2 1/3] vsock: Linger on unsent data
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
In-Reply-To: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Currently vsock's lingering effectively boils down to waiting (or timing
out) until packets are consumed or dropped by the peer; be it by receiving
the data, closing or shutting down the connection.

To align with the semantics described in the SO_LINGER section of man
socket(7) and to mimic AF_INET's behaviour more closely, change the logic
of a lingering close(): instead of waiting for all data to be handled,
block until data is considered sent from the vsock's transport point of
view. That is until worker picks the packets for processing and decrements
virtio_vsock_sock::bytes_unsent down to 0.

Note that such lingering is limited to transports that actually implement
vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
under which no lingering would be observed.

The implementation does not adhere strictly to man page's interpretation of
SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
 	if (timeout) {
 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
+		ssize_t (*unsent)(struct vsock_sock *vsk);
+		struct vsock_sock *vsk = vsock_sk(sk);
+
+		/* Some transports (Hyper-V, VMCI) do not implement
+		 * unsent_bytes. For those, no lingering on close().
+		 */
+		unsent = vsk->transport->unsent_bytes;
+		if (!unsent)
+			return;
 
 		add_wait_queue(sk_sleep(sk), &wait);
 
 		do {
-			if (sk_wait_event(sk, &timeout,
-					  sock_flag(sk, SOCK_DONE), &wait))
+			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
+					  &wait))
 				break;
 		} while (!signal_pending(current) && timeout);
 

-- 
2.49.0


