Return-Path: <kvm+bounces-68392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F3FD386E4
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:16:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 17BDE3020748
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256D33A4AD0;
	Fri, 16 Jan 2026 20:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKdvN5X6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MX0+RiMV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5B22F3624
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594540; cv=none; b=UeenJmi6zpmwv6JsSOghsd+J2YMzAMYH1vi2GRXAmAhWob5LK0szFIcQPc+GQIntv8awt871yaoJr8LPeKA7+cSSzPKp9ApxfWRq+8gvzrnX3UGh61/6PU1Pseuh74F1UEvN4FCgE9731cg5Bml/M9p3lUMDAwtj18Q3fnsfvJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594540; c=relaxed/simple;
	bh=vfLaZ/x6PhPiKKL/eiQKsaUIp8fH+OSFlnq0nAGw7+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ2D2wHkO+zPTYxSfos57/+qabVJLFn9M28ikOcLo7LI6Uqg5DCb71PiMJWIPX6aeFzZ62hNsMEjoj+kquTKtWWCXw2Wor5tcGF2iJsxox+V6xrsQIOgwp00x+AM4o7+ZALXRYGdfvhY/Pci1Lj4/M3mMZx5zUbgKPnXDX1LXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FKdvN5X6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MX0+RiMV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOY0EgIBRqk7jAnNyMBWfVkbAAKnvpv7/putmSk3IKk=;
	b=FKdvN5X6JALI3qPkIgigYETVV/jE+sYl4ml1p0drV0QKppN2ONI5g0je14M4EBibvCpdGi
	+I+VWyt0PJGvZcAt8GoiZbmoG93vogw0+WjClYC/TWOPBQFygGXbKNvJxaL4ukP5KYsBQZ
	ayVMrL1GxvBRPJFWr0LVGRbqJ05Sh6g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-LlO39o0IN8eOH47aa9qTiA-1; Fri, 16 Jan 2026 15:15:36 -0500
X-MC-Unique: LlO39o0IN8eOH47aa9qTiA-1
X-Mimecast-MFC-AGG-ID: LlO39o0IN8eOH47aa9qTiA_1768594536
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso25492945e9.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594535; x=1769199335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JOY0EgIBRqk7jAnNyMBWfVkbAAKnvpv7/putmSk3IKk=;
        b=MX0+RiMVWg27Bgm69M7zcZdiqUI345cUEZpynDYy48eN8FCFeuEqvuR4zez0LPEbZc
         KV3wfa/mgdJRBU4cpqJzFfEc94teWpTEF0xOpgv5dQiaSnf3E3H8BX3CHNJMtw0WGAIQ
         uAL2VW097WD9vP5g4McGmoVR9YjAM8aUp9VtMbjnibtrUxKjmThENZAncB9XvX1+Lup/
         ZxpU2MKyjRVh60KJYvvFLSSRhCFqWB52VHrpFPcFpytDCdEnS8cBQhyRN+RTjqtCN0Xm
         SYeamlds4eDHDgVp/sHCl23c6GoL385BbortQhFmNYUWMdtyEvS71dQE3EO7+cRokP11
         CBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594535; x=1769199335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JOY0EgIBRqk7jAnNyMBWfVkbAAKnvpv7/putmSk3IKk=;
        b=whb8ADNwEHnutPQFF67hQMFHctpbgQZI/tcwE5SqF7CqYtsO0ncfKpOjL8WHj/g20D
         cqvNdg7uivgRAN7HM79KUY5q+ca9AJGRqb9edHaoluFSYEE2x99LnQZl6mOyudfa7TLl
         IKuzNPShz1eJ28rzoPHe6OakDL/qgPjOJvg5KiAOa1HG/X9HcVHn0SVYcZA+vutj5mbS
         31XhKnKe26n5nyTu9XaEkpYLYXUxWFabBDPr5WjsOXh4daj7GL/CO/n/fpe8TTG6QLt9
         +rIvpLZao5oPKK3PdC9x922o54LiGMLBcqKvcHgpBNcWpyDCwE9nci7lRSCDqsNqyxha
         lLew==
X-Forwarded-Encrypted: i=1; AJvYcCVWZkrlycY0Yi963o1n6lKWbox32d51rfJtWOIMdmrV1cC9U9yN0qCmCVl/95alW1PZTjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxARkmi+2PC25HiIAdYbezaiJh+xwNMSeNVJYtToIj61evN+cHm
	MrjX9/DG9QvX6rvx5/L9FGcUq8DwDwujKqK1scOOg2w5hp8mWpnV/gSa38IDqErl36RetDbnxba
	OwYsJEncupJvbIb3lPYSugHLIYdJ+CH8XscNyGlrBgz3Jp9ynmuOrkA==
X-Gm-Gg: AY/fxX6+5qlqTKLXvZWNoVQMPo6YjRPLuQVc45UyqQBM088vhDcx7dhvjUP+YOsuglp
	fLMNHaWziZhtCKK1oOvkYfmh/hU0JILQ1zfM8kn9K84QokGlEo0ZrD4pLs7G1FepL+cnAJwO3Fy
	4EtazcZH+IPpDjviasU1XmneS/GPWOUKw3STTTGvG1pqFA3RjsakEKoHX0B9glF9a3vaj0RYlvC
	MHHfT27kUu/W8L/gjQ4sZqjsXYvaBI03VMyBUQ5glDPROqCp7phI4gCmGHV+bomvnYbZvjmLkOt
	rlZbSRHznNU9a4jofXIT+wuHAJIj5b+qMVdljU98QWtnQYy1XjnIyt/KUhnNLmN58kx7ubxAfxR
	4ZrrRP7NzR3aM5d6cr9AHIYEqoXCIIsMoQgbww8udfro8wU86ijAgl6Uk+RUP
X-Received: by 2002:a05:600c:3495:b0:477:7975:30ea with SMTP id 5b1f17b1804b1-4801e343a9fmr50017475e9.29.1768594535500;
        Fri, 16 Jan 2026 12:15:35 -0800 (PST)
X-Received: by 2002:a05:600c:3495:b0:477:7975:30ea with SMTP id 5b1f17b1804b1-4801e343a9fmr50017195e9.29.1768594535065;
        Fri, 16 Jan 2026 12:15:35 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801fe65883sm22287425e9.15.2026.01.16.12.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:15:34 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: virtualization@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	kvm@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Asias He <asias@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH RESEND net v5 3/4] vsock/virtio: cap TX credit to local buffer size
Date: Fri, 16 Jan 2026 21:15:16 +0100
Message-ID: <20260116201517.273302-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116201517.273302-1-sgarzare@redhat.com>
References: <20260116201517.273302-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Melbin K Mathew <mlbnkm1@gmail.com>

The virtio transports derives its TX credit directly from peer_buf_alloc,
which is set from the remote endpoint's SO_VM_SOCKETS_BUFFER_SIZE value.

On the host side this means that the amount of data we are willing to
queue for a connection is scaled by a guest-chosen buffer size, rather
than the host's own vsock configuration. A malicious guest can advertise
a large buffer and read slowly, causing the host to allocate a
correspondingly large amount of sk_buff memory.
The same thing would happen in the guest with a malicious host, since
virtio transports share the same code base.

Introduce a small helper, virtio_transport_tx_buf_size(), that
returns min(peer_buf_alloc, buf_alloc), and use it wherever we consume
peer_buf_alloc.

This ensures the effective TX window is bounded by both the peer's
advertised buffer and our own buf_alloc (already clamped to
buffer_max_size via SO_VM_SOCKETS_BUFFER_MAX_SIZE), so a remote peer
cannot force the other to queue more data than allowed by its own
vsock settings.

On an unpatched Ubuntu 22.04 host (~64 GiB RAM), running a PoC with
32 guest vsock connections advertising 2 GiB each and reading slowly
drove Slab/SUnreclaim from ~0.5 GiB to ~57 GiB; the system only
recovered after killing the QEMU process. That said, if QEMU memory is
limited with cgroups, the maximum memory used will be limited.

With this patch applied:

  Before:
    MemFree:        ~61.6 GiB
    Slab:           ~142 MiB
    SUnreclaim:     ~117 MiB

  After 32 high-credit connections:
    MemFree:        ~61.5 GiB
    Slab:           ~178 MiB
    SUnreclaim:     ~152 MiB

Only ~35 MiB increase in Slab/SUnreclaim, no host OOM, and the guest
remains responsive.

Compatibility with non-virtio transports:

  - VMCI uses the AF_VSOCK buffer knobs to size its queue pairs per
    socket based on the local vsk->buffer_* values; the remote side
    cannot enlarge those queues beyond what the local endpoint
    configured.

  - Hyper-V's vsock transport uses fixed-size VMBus ring buffers and
    an MTU bound; there is no peer-controlled credit field comparable
    to peer_buf_alloc, and the remote endpoint cannot drive in-flight
    kernel memory above those ring sizes.

  - The loopback path reuses virtio_transport_common.c, so it
    naturally follows the same semantics as the virtio transport.

This change is limited to virtio_transport_common.c and thus affects
virtio-vsock, vhost-vsock, and loopback, bringing them in line with the
"remote window intersected with local policy" behaviour that VMCI and
Hyper-V already effectively have.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: small adjustments after changing the previous patch]
[Stefano: tweak the commit message]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 2fe341be6ce2..00f4cf86beac 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -821,6 +821,15 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+static u32 virtio_transport_tx_buf_size(struct virtio_vsock_sock *vvs)
+{
+	/* The peer advertises its receive buffer via peer_buf_alloc, but we
+	 * cap it to our local buf_alloc so a remote peer cannot force us to
+	 * queue more data than our own buffer configuration allows.
+	 */
+	return min(vvs->peer_buf_alloc, vvs->buf_alloc);
+}
+
 int
 virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
@@ -830,7 +839,7 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 
 	spin_lock_bh(&vvs->tx_lock);
 
-	if (len > vvs->peer_buf_alloc) {
+	if (len > virtio_transport_tx_buf_size(vvs)) {
 		spin_unlock_bh(&vvs->tx_lock);
 		return -EMSGSIZE;
 	}
@@ -884,7 +893,8 @@ static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
 	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
 	 * does not underflow.
 	 */
-	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
+	bytes = (s64)virtio_transport_tx_buf_size(vvs) -
+		(vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
 
-- 
2.52.0


