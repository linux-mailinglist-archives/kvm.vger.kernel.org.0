Return-Path: <kvm+bounces-67946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 362A5D19C73
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 847B73087986
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 15:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBDC3904E0;
	Tue, 13 Jan 2026 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="OYq8tdRm"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913203904C0
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316969; cv=none; b=FJmlWVTJpqUVCbdBRKlCuNnt68FCG8UG1PFk4MU8MKgGJp63I40RPXmGnQTVSUkCx0cLTBhB9MgE0i1qhODEuJAZaWWRRsw1TzyFJrvaBVXtet9IDF7WjeA8M68A+4sVkI9QtOnabLbc0WQt9+VnaCncfsjINNG8lxzW4c7pDHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316969; c=relaxed/simple;
	bh=wU8qS8cqfDjx7nAp5iG/hVamv8f7I+sKdRiCrczLjL0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uCeRW2PvBUHkw5vTgEYsWU8g/bi6jKdnEVP3dfBnPwq3q9tkJd3h4drBUhExwPqMYECIcz626/M9zQmrG86VSv0aakyeeuz6gYG9dbjyUzRt8C4P50WDtXfq+pTUFegLAAPbbi81yRo3mlBrjpRiiS1ZyYg4M0Ro7sAkbtS0rtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=OYq8tdRm; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1C-00GIgd-DA; Tue, 13 Jan 2026 16:09:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=htTm+t/o8GPw74fFM1N90567gOu8ehL2M/ELxAg+cbc=; b=OYq8tdRmn8Yk0Kz1I8PsYAFKSH
	sNvHLHGL3F5p1BjBsrz+0aNP/HpiIq16D41Npx1ZedHVN8iZxyAqqhssm/MZsUTpPwM4SoJvipAsg
	2lgMzWsGFAvhn3uWNYURpiWgRobG2tbgZbXSi7YbvTBJtuYyamV2PppzSknoo9P1jC2vetTVLglWv
	6TmWn/o6ZELUJGJQMHFnmXaViyUfoG0C5oC6tgE4w62AdQrxhSuf8Kq5a3MS2B11R97TmSP5Z8Egl
	t8H63bWhJBL+H2h3TV9k0ZGnAh7kF12kC2sFVPTg5STSPwULjgtAUAhDQ5dlLCkWGUfEldfoNSN9W
	O3wzeYlg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1vfg1B-0007w3-TZ; Tue, 13 Jan 2026 16:09:14 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vfg0v-00DMTf-6F; Tue, 13 Jan 2026 16:08:57 +0100
From: Michal Luczaj <mhal@rbox.co>
Date: Tue, 13 Jan 2026 16:08:18 +0100
Subject: [PATCH net v2 1/2] vsock/virtio: Coalesce only linear skb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260113-vsock-recv-coalescence-v2-1-552b17837cf4@rbox.co>
References: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
In-Reply-To: <20260113-vsock-recv-coalescence-v2-0-552b17837cf4@rbox.co>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, 
 Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.3

vsock/virtio common tries to coalesce buffers in rx queue: if a linear skb
(with a spare tail room) is followed by a small skb (length limited by
GOOD_COPY_LEN = 128), an attempt is made to join them.

Since the introduction of MSG_ZEROCOPY support, assumption that a small skb
will always be linear is incorrect. In the zerocopy case, data is lost and
the linear skb is appended with uninitialized kernel memory.

Of all 3 supported virtio-based transports, only loopback-transport is
affected. G2H virtio-transport rx queue operates on explicitly linear skbs;
see virtio_vsock_alloc_linear_skb() in virtio_vsock_rx_fill(). H2G
vhost-transport may allocate non-linear skbs, but only for sizes that are
not considered for coalescence; see PAGE_ALLOC_COSTLY_ORDER in
virtio_vsock_alloc_skb().

Ensure only linear skbs are coalesced. Note that skb_tailroom(last_skb) > 0
guarantees last_skb is linear.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e..26b979ad71f0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1359,9 +1359,11 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 
 	/* Try to copy small packets into the buffer of last packet queued,
 	 * to avoid wasting memory queueing the entire buffer with a small
-	 * payload.
+	 * payload. Skip non-linear (e.g. zerocopy) skbs; these carry payload
+	 * in skb_shinfo.
 	 */
-	if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue)) {
+	if (len <= GOOD_COPY_LEN && !skb_queue_empty(&vvs->rx_queue) &&
+	    !skb_is_nonlinear(skb)) {
 		struct virtio_vsock_hdr *last_hdr;
 		struct sk_buff *last_skb;
 

-- 
2.52.0


