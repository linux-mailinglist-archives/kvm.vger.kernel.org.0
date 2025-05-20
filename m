Return-Path: <kvm+bounces-47189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 814FEABE7B6
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:57:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105854A7495
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FA22609EE;
	Tue, 20 May 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="EbqaShv5"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9AC256C7D;
	Tue, 20 May 2025 22:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781791; cv=none; b=fJaO+K1kycKv6TYaItTCqfI7huiFqCFeVZf+tqI6IfFP4+vsYOKzpvuBolEWx4mVnb4Q3X6iTkZuBsfnW2egyOhdAmOG4k4rNgqUjpY/vSt3TWAgFBYcV/CarK5p6fpJsVl+I0/M5ifKup+lv2i/SnTNbfIZPIw0Gcyfv3F0NXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781791; c=relaxed/simple;
	bh=Bisvp9WXtx0uaSzm4IId2G0NuCg21iZTRlMs7KZj3Zs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i4kyjRzdjiTgGkzg94cBC1VEuzOrZ5bYnPTiL3mCT6tyR4aD6yF/+qoRxS1OcfN8/bnVPVWmGPKKcCLnAu85T7B47JCOb5qIJJZKz+xP3eF8qz/w9tf8wmk69045+Uvu8t5Sj3MoAQ1bZ4GPEUyqLGPbxV0qZqtTM4BY8Kb3iPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=EbqaShv5; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsg-001X4u-TC; Wed, 21 May 2025 00:56:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=bJE5agG6suW5EMhVSS9xIoPl9te7wqkSo/E38GSN3wQ=; b=EbqaShv58TyWcztpNBCjVoxyeK
	mLkk6jGtgmElvKvh5rmBeLXsR/cHk+9iT9ZSDpYanrpEEG1v3/eIz0ZM/19k41HArDYPBTEuCkwM2
	mxk25tr5bAtCy+OtlHRUI8tFXZuhHH7WeElIkKGpqdMsNliC7f+cS+cbp9wmokN6blQ7HJFXgnjSI
	g/ZV2kuUlWsZ6kK96Tpre3NE0BwP6xxjc77kAZLRBLMfrscYbAtl/w8SaoFhTcEhNIh208qbR1gQl
	qQOP8AZi7KdB4GowGiX5P8uyz2YTXzA9ICkDSBDUpLPUkLc02XS3W1D2x54AOOMenqBhPVrGGZlty
	J9qx78BQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsf-0007mr-Ni; Wed, 21 May 2025 00:56:17 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsW-00CxGf-QH; Wed, 21 May 2025 00:56:08 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 21 May 2025 00:55:19 +0200
Subject: [PATCH net-next v5 1/5] vsock/virtio: Linger on unsent data
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250521-vsock-linger-v5-1-94827860d1d6@rbox.co>
References: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
In-Reply-To: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
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

Note that (some interpretation of) lingering was always limited to
transports that called virtio_transport_wait_close() on transport release.
This does not change, i.e. under Hyper-V and VMCI no lingering would be
observed.

The implementation does not adhere strictly to man page's interpretation of
SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6e7b727c781c88674c147b7b75f49f4f1c670d38..f2f1b166731b1bf2baa3db2854de19aa331128ea 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1195,12 +1195,14 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
 	if (timeout) {
 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
+		struct vsock_sock *vsk = vsock_sk(sk);
 
 		add_wait_queue(sk_sleep(sk), &wait);
 
 		do {
 			if (sk_wait_event(sk, &timeout,
-					  sock_flag(sk, SOCK_DONE), &wait))
+					  virtio_transport_unsent_bytes(vsk) == 0,
+					  &wait))
 				break;
 		} while (!signal_pending(current) && timeout);
 

-- 
2.49.0


