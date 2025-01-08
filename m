Return-Path: <kvm+bounces-34810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47769A063F5
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:07:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 153153A66E8
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99633201271;
	Wed,  8 Jan 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LxuBkGJG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F7201270
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736359592; cv=none; b=OBLxhCj0OzieSFFv7gYtee/0h2JugX75CAiDYXfZSXosp/DRqMBqhNZHGQQFSON+Qjm7l1eubq0CaVw7TI58ff5XDErS9G2t00Mo1boAFRXl3FObzyBtqHxpY42JLNrBTv1f2BUq4tcOVRFjKNsz2eo9yFeYl1S6uXBKHc9mYeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736359592; c=relaxed/simple;
	bh=XhT2B/XMcI2q+vQQF0C3xrDtTRflQwJMsW4aCd7eL48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhWnEsJZEWP0+tFXSA5+cPcMFRCjLj0RbwQWA07B2iWPaDQoijQml6V8+n37nG5C+oeRa/9p0kIcslUS2ohlkVMYRP4NHG1hjbD+BS6Z2yLnOuzCcmFYHgKnF61Lt/hVLcsPqLCTU6LUjEMxDGl0pehL5O8njE6ZQs5hCYMw2nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LxuBkGJG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736359590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P81z0YmLvdT8m64Ix0hrS5vpO81KiskzyN+gGNFCQNI=;
	b=LxuBkGJGO2dzjgcQsryGFfqvRyWIt+q3CfwpTMt6LqzV6UScCHpE7cI0NXpnY+5BGH2l+T
	9+82CKERC2FkA6/8F/5HYSzOtaYrtiDtmz/yewgCtIkraD6k8AFQx89P60vqgENZvx7NMr
	OvhpyhQ4LYPewvITBoLg5/GOqmySTLc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-MdLpB7FqPfy2sD8EyVIeQg-1; Wed, 08 Jan 2025 13:06:28 -0500
X-MC-Unique: MdLpB7FqPfy2sD8EyVIeQg-1
X-Mimecast-MFC-AGG-ID: MdLpB7FqPfy2sD8EyVIeQg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862b364578so525320f8f.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 10:06:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736359586; x=1736964386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P81z0YmLvdT8m64Ix0hrS5vpO81KiskzyN+gGNFCQNI=;
        b=MoomgCD2CUc5ynQ3ArEJzFs+5bKgtxPKBc1JKlowlT/t/Jt8oZM1JB7vgUy3IqK2z8
         FgOLdVY1IE31UDgJmw+pOlhRbFUXx+3D8ofgb1H45so/AKFrQfNQS0ZzyIp5SUhoodGM
         eEtT9m/RWIVE6JQmGPvE9LqfFq01/j/UJR+Guq4lXHFwZBR6V5715Ov1oXKYNCBG4Z5V
         CYcwqeezoi5JNYXDNHqpvzJhyFehQUdNJIh0wYHRWiJTJ6aU33j0NdGiwT5go5dQmo9e
         Uq4y7ac8TOsmopWhEsjqpxWgB3oVaYnoi5G/Op8ZDJAYSOM20pU2isWQfnAJOxqE7hrW
         xF7A==
X-Forwarded-Encrypted: i=1; AJvYcCXUpVFfjbFWgSBjdX+GIndKuywvNHqPu8HP2xS1WMDOmh/sKVoaO1YFDoOlNMKUDBGaRsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO56LYFwLAn/1MHOITTqP03p+jmAiwOoh6yPH1UWxxgkA7Wfjt
	0AKnSY1mbC96jbhULonBHOBr95sBpQUQiArzKQCH1HHWyPeEhfjdbjbBGUTH5zvi4WDJoEaCyVd
	sNYjWu4PI6j6GtgpEFzxJgY1D2HlP9QmPH+EParQlX+pG6jehvRYqrh5M6q57
X-Gm-Gg: ASbGncsHAikAI6HU/BWnA7/cCCElKGJsw//Ga0Qg/wQUR6CoOLdyj9vS+E6ED3Qjdb8
	+KP9eMmq2ws4XLCMoDuiQQnguxIE7qUFxBnfnuEXepPqf9Acw3b/WJdQnHeX0MAVX/V1U9uouuC
	6qMY5wnUvkBttWtbdPc9YodKf3a0FQhbqpo7TJD+/grvZtgjhObYpU4W6pbb3LHlpwSokdh2l+B
	Kvso4Lefhf5ouy43M5TFGL4i8iUPxc/MfjcDIYmH3bRIzw=
X-Received: by 2002:a5d:64af:0:b0:386:1ab3:11f0 with SMTP id ffacd0b85a97d-38a8b0fa39dmr213699f8f.28.1736359586605;
        Wed, 08 Jan 2025 10:06:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyImssYlGKFMwIIkelKFtn5EBvRpRzebX/KbLVJOoRVPg+AYW6dhCm61RcqZ/eZtr4R9nAwQ==
X-Received: by 2002:a5d:64af:0:b0:386:1ab3:11f0 with SMTP id ffacd0b85a97d-38a8b0fa39dmr213656f8f.28.1736359585987;
        Wed, 08 Jan 2025 10:06:25 -0800 (PST)
Received: from step1.. ([5.77.93.126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c8292f4sm54344839f8f.3.2025.01.08.10.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 10:06:25 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Wongi Lee <qwerty@theori.io>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	virtualization@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	bpf@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Hyunwoo Kim <v4bel@theori.io>,
	Michal Luczaj <mhal@rbox.co>,
	kvm@vger.kernel.org
Subject: [PATCH net 1/2] vsock/virtio: discard packets if the transport changes
Date: Wed,  8 Jan 2025 19:06:16 +0100
Message-ID: <20250108180617.154053-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108180617.154053-1-sgarzare@redhat.com>
References: <20250108180617.154053-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the socket has been de-assigned or assigned to another transport,
we must discard any packets received because they are not expected
and would cause issues when we access vsk->transport.

A possible scenario is described by Hyunwoo Kim in the attached link,
where after a first connect() interrupted by a signal, and a second
connect() failed, we can find `vsk->transport` at NULL, leading to a
NULL pointer dereference.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Reported-by: Wongi Lee <qwerty@theori.io>
Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9acc13ab3f82..51a494b69be8 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 
 	lock_sock(sk);
 
-	/* Check if sk has been closed before lock_sock */
-	if (sock_flag(sk, SOCK_DONE)) {
+	/* Check if sk has been closed or assigned to another transport before
+	 * lock_sock (note: listener sockets are not assigned to any transport)
+	 */
+	if (sock_flag(sk, SOCK_DONE) ||
+	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
 		(void)virtio_transport_reset_no_sock(t, skb);
 		release_sock(sk);
 		sock_put(sk);
-- 
2.47.1


