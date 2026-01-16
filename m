Return-Path: <kvm+bounces-68390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A06CDD386DC
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:15:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D850E3017FB6
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 20:15:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1ED3A4F24;
	Fri, 16 Jan 2026 20:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqIlU4e8";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="iu9kQ+IS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246D3A4ACE
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 20:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768594529; cv=none; b=Ds3ayPUvSsembHm1cesWV9sMQtUp8lknZ/oaBEHYbiJ9+qvVkI9Z7ZbUbVZJS1M0T8fSBtmrWN2rbQlkJrmrifyp99HIQn8P6gfBPph+yiEcML7JxV2hQqHdFnaQXzjXcdnLO0soKCvkV0LKbgXKK65kUl4qcVqdCC7f6n+UIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768594529; c=relaxed/simple;
	bh=A/Z6X724OpOjH0JR1tZITqCXaxlg20lb95ngLUoUj2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE3V5QXOhT0fWX1tnShr+it1OZAKbH3hBJm+1sebQUzNb7ZnUaqVB2V6X8mb/LSpuO8wdO+uIpodkac94dwm4v8vubIE7NfWnLMQ3rNLE7zwakZGkK2Nq75td47lgTJNoazGuGi/jOcYbmEidGUWTBHqAWHLb3ZILtULnCggPkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BqIlU4e8; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=iu9kQ+IS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768594527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArUbsQ+kNBjAUv+ApSXUG5Hd0kEcrS3qPgkd0OoiEwI=;
	b=BqIlU4e82bIfs0nNr/FeiPY7FvXZwJ8uf55JDQFM6xAKqp65X3cR3uJMOh5jBcH0Rliype
	Z1umZ0W060pizUpuFFEU76OhEwgauRkTQig9D52IWdupjymbeKJAwyvW4BKoPrRig0JQur
	F6yPvoPb9JHjuk62QPY0YCeM1VraKTs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-Bk43sNWzMGOY1VsjczxwcA-1; Fri, 16 Jan 2026 15:15:26 -0500
X-MC-Unique: Bk43sNWzMGOY1VsjczxwcA-1
X-Mimecast-MFC-AGG-ID: Bk43sNWzMGOY1VsjczxwcA_1768594525
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d5c7a2f54so25854375e9.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 12:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768594525; x=1769199325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArUbsQ+kNBjAUv+ApSXUG5Hd0kEcrS3qPgkd0OoiEwI=;
        b=iu9kQ+ISQWJqsK5FtvBvvLkJHqRuxrbRBbDMK9HHXNpRKYVDbZqDkGT/pgvbQWDgp0
         VtxfTWp5E3P5F+tGuFQMQIXUKWPx1SYqD2HH1FwNUmGYGfADPc/rzgPcxEGolpoq9DUD
         rOBrtOaRMDRt2Pm7igYdm2L92CAcg+A9Xij6Lu5e1GYjAsUJKnbSIiJ/mqSKv2F2cv4s
         xeUDIiWvgoc87MhPgd5WFaNrM2VcXgh/QiFi5+R4hbZXFKyPcOSh4b5MD+Qo+MkHGaxA
         qzEdokb5DfEzSg6x8D66yielR38HC05Kw6UevKqJmsR4K1Wr6em5Rv0IYBOxlxVxiRRD
         d7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768594525; x=1769199325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ArUbsQ+kNBjAUv+ApSXUG5Hd0kEcrS3qPgkd0OoiEwI=;
        b=V9BFYP0vZ71JlOzKUPtnVD3z9IyCY/amtGNFoY4GbJ/BVcafDXZ3KBftvuIUzkmCvs
         9xzrEs1RGgkBKGripbUuhDx3QCtnXv5zZ95bfAq3P0rK8G0T5gldSkHOU/h3BKJA7dIw
         HPjyr1Oq85XtwJ9Z5Ez9jrr5u3IIvKBXuXAMCFfe6+grZBqfm8Qqj9jMfuaCPQPpz+Xk
         iNq4PGOj2Oh1j6LAUVBzoiCJJtV4VA7uCUEodyZ1vHwT7qGFnjeDvOjnbykyshjc2VQk
         Mik053LgPQHhH6WZKZTdSQfRtH6EEFnjpOLIEhjzblsYeob4WHyGhRMYQBELRWjTvBEu
         4U7g==
X-Forwarded-Encrypted: i=1; AJvYcCWgBMGNcgkhJbMkJT7eDe5Bbug8T5NVlVGXHaoT1IpwG8eSXHVzRkf2r6VcrPKvELxc7BU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEIFv8m0oZsU/Fd9yrfNpezMBUvakVZAEolhVFJWPla+f4aTWe
	O2P6Ry3obLTo6ecyiMc3Fb9oSafppmIMZUp4+HwQmn3+AslsNwO5uaA3MvrBeLVCEPT1pc7xpGO
	v4Q9g/CVmFlbc9yc5fV4jnN4j3Fdsyy9nyYViZUsnJsK51ue5reaMoA==
X-Gm-Gg: AY/fxX7eUg0CwASPQ3cdOohTAmkS2WfibU9Oa8m7IrfgVSS1Q2H2eSdxXxXDbdnGiH7
	Qul0n/urT+VGhiiJgJy5s+El/2XhkNYC1M/fXi4w1tfPBAxN5Ofdp/EK2kMwEANB+91e+HxHC/d
	EzJpWH0qvM5vO+SZnVhvXBEuLxOx12TEGn0xkOB60hEvkFIUiG40qQWS2/Yl+BAcE3fhGKaKRKz
	nwNRVF5rqEQtrd0Ldr7OdFMzpqHCekHmDc6H3oSJR30OBCdumR+KbRbD4lyGrX5INaEvv1l65+X
	H/YLEf2o+7Y2bcSoxeucANLpQ5p5eT+pyKWpiYtx3ont54QKF8tBXfaGeKeL/uPFmf+IgEXOx0j
	qjCQGeJWaibxkUo9RMH3gAGSI7HHm1bDGTyAUrM7tISqg8rxSRlu83sd707nX
X-Received: by 2002:a05:600c:1f86:b0:477:a289:d854 with SMTP id 5b1f17b1804b1-4801e53ca36mr57538715e9.5.1768594524930;
        Fri, 16 Jan 2026 12:15:24 -0800 (PST)
X-Received: by 2002:a05:600c:1f86:b0:477:a289:d854 with SMTP id 5b1f17b1804b1-4801e53ca36mr57538465e9.5.1768594524424;
        Fri, 16 Jan 2026 12:15:24 -0800 (PST)
Received: from stex1.redhat.com (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e879537sm57802005e9.5.2026.01.16.12.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:15:23 -0800 (PST)
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
Subject: [PATCH RESEND net v5 1/4] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Date: Fri, 16 Jan 2026 21:15:14 +0100
Message-ID: <20260116201517.273302-2-sgarzare@redhat.com>
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

The credit calculation in virtio_transport_get_credit() uses unsigned
arithmetic:

  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);

If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
are in flight, the subtraction can underflow and produce a large
positive value, potentially allowing more data to be queued than the
peer can handle.

Reuse virtio_transport_has_space() which already handles this case and
add a comment to make it clear why we are doing that.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: use virtio_transport_has_space() instead of duplicating the code]
[Stefano: tweak the commit message]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e..2fe341be6ce2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -28,6 +28,7 @@
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout);
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs);
 
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
@@ -499,9 +500,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 		return 0;
 
 	spin_lock_bh(&vvs->tx_lock);
-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
-	if (ret > credit)
-		ret = credit;
+	ret = min_t(u32, credit, virtio_transport_has_space(vvs));
 	vvs->tx_cnt += ret;
 	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
@@ -877,11 +876,14 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
 
-static s64 virtio_transport_has_space(struct vsock_sock *vsk)
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
 	s64 bytes;
 
+	/* Use s64 arithmetic so if the peer shrinks peer_buf_alloc while
+	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
+	 * does not underflow.
+	 */
 	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
@@ -895,7 +897,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
 	s64 bytes;
 
 	spin_lock_bh(&vvs->tx_lock);
-	bytes = virtio_transport_has_space(vsk);
+	bytes = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 
 	return bytes;
@@ -1490,7 +1492,7 @@ static bool virtio_transport_space_update(struct sock *sk,
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->peer_buf_alloc = le32_to_cpu(hdr->buf_alloc);
 	vvs->peer_fwd_cnt = le32_to_cpu(hdr->fwd_cnt);
-	space_available = virtio_transport_has_space(vsk);
+	space_available = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 	return space_available;
 }
-- 
2.52.0


