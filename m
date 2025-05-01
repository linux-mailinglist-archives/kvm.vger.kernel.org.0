Return-Path: <kvm+bounces-45064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 112BFAA5BDD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACF9F17A802
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBAC270EA6;
	Thu,  1 May 2025 08:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="RbZPxq11"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C1025B1CE;
	Thu,  1 May 2025 08:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746086754; cv=none; b=topK097sonl+jpEmEONVxbuA1DqNyDGOGb8NI4VAdpqX1dwGITlpVUkyqpjnL70dYfMZN8SupnALIQwACJTLZUPhN/z/3/E/OHEAMKwO0sPa8iL68xvlGu78h5rJokZkvPO2oW1tevlkAhplVY8s9y3j5Qjo5e1leuOx5Yxw6Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746086754; c=relaxed/simple;
	bh=Mu6prwauj7B3bCqGpqGc0KCidlcsB8GchOCM8+2XE5s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uOT/U+zBKKB40kWneCErWTyXS26eH9dLQVQbe5OLgxuhZ5h1TonUwpDKGMYhzbIIr5gPkGyLT5ps3BGf0IiOn3ULZqqntid1lvUGvIUCqS53q/WAQkt6Q3vhaTY40qy4RA66JElfldJabf75x0Wc/uHuY/kZFWJFPw6IiQbCFko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=RbZPxq11; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uAOvR-00BnGm-N6; Thu, 01 May 2025 10:05:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=ryPcbNb/7eJcu1W3+cY8RMwSBA+GuC6dYVOgjIg/Z2w=; b=RbZPxq11clJsd+Hu6q6D9NWLN4
	awvLEpO2WJUUZTNQRLYsFwxQuPeY24AIQHeDMm/NVuKxufBIZ10sGoGBDBoI1gxhKFq3MuGcK6NCk
	YVWXlhDYlrHZ9gIUh+qabyZf6ztjZ4DbDINDpbhQ928Wv7/5u5Gk/itzOGUftBsjgew1+chJt1ijN
	3Tc/mdJtsfCRtDUOm04j5BgRPH7vigAlV0a1ylPldY8QYhVbhKqeAxcPxP4nuQEfNnnDvVqX6yhQx
	NSqoRsSnlMprYCkRiP4CKA4NcYgURw0hFfSxVQMQqhRNRb3+UecIV1LaD3gOYwedS9BiYs7JySQP3
	ld+yE2RA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uAOvQ-0007we-Cv; Thu, 01 May 2025 10:05:44 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uAOvI-005lsv-QR; Thu, 01 May 2025 10:05:36 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Thu, 01 May 2025 10:05:22 +0200
Subject: [PATCH net-next v4 1/3] vsock/virtio: Linger on unsent data
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250501-vsock-linger-v4-1-beabbd8a0847@rbox.co>
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
In-Reply-To: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
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

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7f7de6d8809655fe522749fbbc9025df71f071bd..045ac53f69735e1979162aea8c9ab5961407640c 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1196,12 +1196,14 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
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


