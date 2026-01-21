Return-Path: <kvm+bounces-68698-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJiHA8ygcGlyYgAAu9opvQ
	(envelope-from <kvm+bounces-68698-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:47:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EDFA654A66
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 10:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 756845C76FA
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FE847ECE5;
	Wed, 21 Jan 2026 09:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YEhQCvTQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FsEW//E2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D483D47ECCC
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 09:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768988212; cv=none; b=NCuqEam4DRV4Dmn2OZn9Aqn052rFqlL1l/PR3rZzWTAiruU0MxkfwupqVKl1pOU7Ev4HEbZy5k1hBTBPZFDA+Zl/tEwJbd9RElm71PjRb6p9Q2sfTymZbA0ATxyb8Epv8DrWNx43ROPHb/E3pHYiqV4RKZ1GVsdN5LQ559lIs2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768988212; c=relaxed/simple;
	bh=8FWDPO7w394Nl7XKsuUojlhzUFs0e7ivz29bXEwBdFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5BtTN9bCXm8/TEbG2r18fbpW1AUhKllc7jgG+MZeEMxg2UrrgYWjrg3KbuqChT0U1SaG0wuj6RnKhUaN4VWVkn62cj2UnQqvC95i7/UYlOVYR6+gdm9LmhPOZD/PQ6d17A2xHDFrmoUy2H9Tr0wlQXcjdY/0Hdq0AqyKe/q12c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YEhQCvTQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FsEW//E2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768988209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGM0zHbdn0V12NgombpaBR+rEA6S/BsSNVQrMd4WoM4=;
	b=YEhQCvTQmPmA7OMMyL7P4pXXBBz1Pli3zugcpBakK00LjlwDDWkIxG9ILLJ8/lxhR2Mgip
	HVkjJctZYdGWH22V7GNzgnh2R8aV75m1ZzdJBSwYV/bcTY9im/FeZOqN84P2u31Ati6+YP
	aIRg3qHkDil/2eQhTTzLxLursa1oQkM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-FoSdVtfmNw2TsG0MDFd6SQ-1; Wed, 21 Jan 2026 04:36:48 -0500
X-MC-Unique: FoSdVtfmNw2TsG0MDFd6SQ-1
X-Mimecast-MFC-AGG-ID: FoSdVtfmNw2TsG0MDFd6SQ_1768988207
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435a2de6ec0so43999f8f.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 01:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768988207; x=1769593007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xGM0zHbdn0V12NgombpaBR+rEA6S/BsSNVQrMd4WoM4=;
        b=FsEW//E2u1CEsxjYG47z7hsFynDqounY7IdwZW24zQaclAiWtsfM5UcxlCFS1JphxT
         AtCTetfCd17QqNt29EWVx9OjGolE1MrPdIbp5O796bG1CSiJU7jSCjDWGnRQuBS5PesS
         oG68+iv8SH7RViyxR5hZC4LM5T81iTB8fZA7ae/rClGahaLTtbyRNDytRt18Wg3AYUbO
         1ytf8O77MIp5OieEl/V5A/TBRRMsVakO1zPFCFtyv2phuSICyfC4W0gA2YDcAJ4e19z+
         SmeDwu7/Tso7TAKQX5HUSKIjR4yjFbyVBVRgi8fi35EkdSyrtIzu29cNY30/wHZr0O3k
         SRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988207; x=1769593007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xGM0zHbdn0V12NgombpaBR+rEA6S/BsSNVQrMd4WoM4=;
        b=cbYsjESfBQaVhQloX4TNXaGPt8iKk287O+SsYzmNGpD2TidnctOTSgzPZ2z1cOc2tc
         rNJf2xcvb/PF3dddcxJlZHfUsLnTqXuLhq+VLBfJlJLnPKRRkdv3XemurKHdY4Bykd/3
         bsjZeL7vEpkSRcyXwiGwHZUAzQqU3Q8dJlc0Rr0K3Mi3J2TsaK7hAIl7JQEKlh+DGXKm
         GfK06mBS9NZqTdBdlJY4l54DtwttwsQGUQxeDDDZzr6uq4WpALWp740l9gs2T9rLG8u1
         9UVjYAVIkSUotGA9js8IgGf+opptBmutUwxtcyoYYtKJHOOfJRO0jwDJ/OTPRq4fHc53
         Qlpw==
X-Forwarded-Encrypted: i=1; AJvYcCVjlQgxMsMLP71PAIlLwsBFzwbz19IF7b9b8MUvc1Koq72K9yM9MG1VstvtyyVY1myx0tM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGx9b+60P8RXT62bPZKTwpk9ZM4dntnFsBPyBJrOJT1FTc2mjJ
	DferdWp4cDFoMZEKqyvUQW9F8V0lKMBFti8aTLE4T+fVfZdEHSDef0mk1udWP9g4KPpACH+xluk
	PCU8JG6I9hUV7XoqGG3dDpBclFEilae48T7Ep1aGGecaxaWDjrA3aEA==
X-Gm-Gg: AZuq6aLgXffirYRtqx6lKrGs1jxoOXnIisxSst1pP4aByB3w9opMDRUr1fpxCKlGHQL
	xBjp7Vc+DRGsC+Ygo2WQq7hk1s8/tcCtGBgG7KH+PO+ohgPL6L5Y2i7pA1jaBllTRsWZ8uREHRF
	PuFj66kneTJtaxlZCabPp9/kHl6lQ8mp0woa6/TFuq3ZW8bIwsWCWV5HrT1DxsU4uFklcERoUd9
	E/oRrPhtxoVxIzOllpyPyaAQ/8nJX4m/J4x0FmVQRk6DauZ+Ko+7OuOVBLANd5me/I/kc/Uw44A
	P3Q80fgG3GRSV+AOQ6S+lk7O5Uq8pHXy6ka+e3izAZKG4nRO9l75nRaXMbrNhwiRpQ6FkMA2DlJ
	wD5hSyz+ZTIWuj+UX8GOaNyVKR+UVdvTqtHylZj00QpqPW5R9PmSY2lUVHeyy
X-Received: by 2002:a05:6000:18b:b0:435:94c4:649c with SMTP id ffacd0b85a97d-43594c4658bmr4628409f8f.30.1768988207202;
        Wed, 21 Jan 2026 01:36:47 -0800 (PST)
X-Received: by 2002:a05:6000:18b:b0:435:94c4:649c with SMTP id ffacd0b85a97d-43594c4658bmr4628374f8f.30.1768988206674;
        Wed, 21 Jan 2026 01:36:46 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921da2sm35389534f8f.1.2026.01.21.01.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:36:45 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	virtualization@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Asias He <asias@redhat.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH net v6 3/4] vsock/virtio: cap TX credit to local buffer size
Date: Wed, 21 Jan 2026 10:36:27 +0100
Message-ID: <20260121093628.9941-4-sgarzare@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121093628.9941-1-sgarzare@redhat.com>
References: <20260121093628.9941-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68698-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,google.com,redhat.com,sberdevices.ru,davemloft.net,lists.linux.dev,vger.kernel.org,linux.vnet.ibm.com,linux.alibaba.com,gmail.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: EDFA654A66
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index 6175124d63d3..d3e26025ef58 100644
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


