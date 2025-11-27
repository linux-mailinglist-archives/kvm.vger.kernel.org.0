Return-Path: <kvm+bounces-64841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D8517C8D3AF
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9AF7434CA78
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137D7328B77;
	Thu, 27 Nov 2025 07:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bg2d4qYg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0467C31D39F
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764229671; cv=none; b=pCUcdjzv3K/WVwkBpt1266jCyHkidbwiR7WKmGLnJg7wXL5e/WJYLIVu3ObiClLL+CjcHwoJSDhpIjbrsF8LDU3pIToCCUTSjPQVL9Sd9PdR1sqhjAWjWkDM2FWUMx5nRzBy5+T0mFLk2jyVavMz/7ABCbHsTtNaTaEp9pj+RgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764229671; c=relaxed/simple;
	bh=ngrprkAcK9o71FbUOC3NZ7RyRN7JcMdikXQcWlHlTQ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YFHermBE0ytaY7hrST80AfEaKCqqL/6/yWGM2dw6AUyJsPkuz66MWirQhQKdMztjLDdBiMY05Q3WB9TzRYXdYHV8vd9PjFsPs3ADCcr3gSwjGy9S2SiKXbgsPblVte50d5Uf9VpPUUxjp9pM2Fs/Eqyfzn2qBH5nGpYsaYgkWXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bg2d4qYg; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297dd95ffe4so5165315ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 23:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764229666; x=1764834466; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wdjtlHAU46wbJRJNPh2vrdaHOqMf+PZ2xHKsN6+qWOY=;
        b=Bg2d4qYgk4kfYwNa7AycPQ6XdzG0m+Xy8oyitG4OwTE2NwZagya760K7hY5R5Vjg1/
         hX/n1f2olMhz5cuBDb42gdnShH8CO2PV9XvRebWO9AMBwHzLdjtfcHIorRG0LDAfRCjx
         oU7aX0NG8YyNTjvPot7GzMPNLgRrLkLLOaQ2a8i+dDodGHFfB9OFmwJtLNZUUtFJkX72
         6/NgTYo/cSOgFsHQDlLua0/zQ/6VLsy1K0xV5kk0Ws+YKX0ossqfIoenB5GTiL0j9Oyg
         vL6MATcuUT+gRp5TLbDWx2czYqlNAXYfqCYmRjbMBEBBfkSANgix/QB5VMZdIKK7/dwX
         qhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764229666; x=1764834466;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wdjtlHAU46wbJRJNPh2vrdaHOqMf+PZ2xHKsN6+qWOY=;
        b=r7pk6vj/5fN4qKUI42oIDStcqcFeO0c7b+olbGGuvY/sWU0NT6A6vXSDpCehU5/YJp
         OnDF9qFiNAkSJoGaNoa8a+xcG2DV63uEY6cG8SIw3xN0mr3z5lU6yWKJK+0BaD9rVGwd
         mfDGzkNr9X+CF3mIHFU9p2e4bf61BN//nzfxYGSzN8Hb0y8IAJmpa95uiQkFlYnwNHWv
         5pWoQWUhovG/2035LEbdxBkOT0laVJbiKXbweRHcYc49guHz99LMFfuX+MJNV2DKpSdC
         ivwp9AYZ0Npn9/GifI8pr2nQt3CHbC8zFkzdy9mLfDZQZJJQmjAsXKGSOUquWxqAMW7v
         b+Zw==
X-Forwarded-Encrypted: i=1; AJvYcCWuMspEiC2tpZB631NKkhJkgEDLFFl1X5R8AsQefT2pBYuiFiADuwbYGt0Qs17JkOcc5N0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN4T/rCAS9TEu25wC7MAk3vM1uJvlrxiH0piNNVdJ/Rc+irD1U
	OJ+DZ32UMpGHIPzaUTFFiACCtzPSWN9AHpGdp0NuCFZPL5D1LsbPxYB9
X-Gm-Gg: ASbGnctztdbcOyPUUO4mENJZe/xrpWBwLQbDCUCaipB8PkNI+xTbrbDD4FJZFiInzjU
	O0FZ2ktqfhfv6S6fayhWuzHYDfgCcC8bKZJii3UtXVrwbKdgLL99PliQkv4NkG9hOc1zOzopGN+
	3WA7hafXbwljrMI3ZlTeIyQx7c1NbhLPWtG7FJl8FOmIbxzDJpUB2VjtWFhweI8BS6hF0VvyIy0
	8h5M4iClT3oZjhAvu8lrv4Y2eUCyeD0lSmZWk0W29sLNCZ8+6CbzXui1c+mjYFAOp0oKTsQwtx9
	lCDlNS3iD8ENtx/eBcLgoIXU432sTSdI6a8E+0qNmX061DP8krr1Ns1mPqnrRogPQ0m38AS5YV1
	GnhgHmCotP0IqTUJDvkGyZZq0M2z5rPD3pOYCLpL72LUK6VhmH7Elam/i6+l0ImTwoJjV+0v2d7
	CAeQI3lLxkQ1OUMpv/pxY=
X-Google-Smtp-Source: AGHT+IFYvO1UtpbFl//by/z1SxVW3RV5sMUL/B4xccNDs4++DXCvOjc0LlmnAs3s4Ij/sBDaAEebvg==
X-Received: by 2002:a17:902:da82:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-29bab148972mr111949915ad.29.1764229665894;
        Wed, 26 Nov 2025 23:47:45 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b1cbd8csm965410a91.1.2025.11.26.23.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 23:47:45 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 26 Nov 2025 23:47:32 -0800
Subject: [PATCH net-next v12 03/12] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-vsock-vmtest-v12-3-257ee21cd5de@meta.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
In-Reply-To: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Associate reply packets with the sending socket. When vsock must reply
with an RST packet and there exists a sending socket (e.g., for
loopback), setting the skb owner to the socket correctly handles
reference counting between the skb and sk (i.e., the sk stays alive
until the skb is freed).

This allows the net namespace to be used for socket lookups for the
duration of the reply skb's lifetime, preventing race conditions between
the namespace lifecycle and vsock socket search using the namespace
pointer.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v11:
- move before adding to netns support (Stefano)

Changes in v10:
- break this out into its own patch for easy revert (Stefano)
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e6391eb7cc1b..de71e2b3f77e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1165,6 +1165,12 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.op = VIRTIO_VSOCK_OP_RST,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
+
+		/* Set sk owner to socket we are replying to (may be NULL for
+		 * non-loopback). This keeps a reference to the sock and
+		 * sock_net(sk) until the reply skb is freed.
+		 */
+		.vsk = vsock_sk(skb->sk),
 	};
 	struct sk_buff *reply;
 

-- 
2.47.3


