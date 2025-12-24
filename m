Return-Path: <kvm+bounces-66647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C51ECDAEC2
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 574E73052214
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5E2241CA2;
	Wed, 24 Dec 2025 00:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnXzcWtl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19AD1F7580
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536142; cv=none; b=XOSFhgS8X9QcsQ1FFCcfo4y5O6X0cXNUSfMxUjqc8j2N9B2gmu9o1oa0G0oG+MLjrwNAL0LP5S4nY/zA0skQcn/AnKmrSdU/ZmsZx21R+DwnwHY1G9k3O+cAAQArVltQ4usSSUHxq2yzLYM/YAFJp9oy8+NZwg0A6RvIQ150LQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536142; c=relaxed/simple;
	bh=vD964Lj1wPSOw/16ssWykcRPX0KDwrhlz4wvw7+NTyw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NX8LoN7bxTf2MDx16UC8p2KWuu7kLxHK4RRhO3eFVvbDKJ2QELMA1a1t0sKOwG+cEnudvBwyLR+hI5xWPeigY90Ch8LD6++DdRIB8dCtEY17XSEeXPNM5bcChbN9h+k3eUOQUzPysrAL/9+t8/UTjZTEKKaqyt2vHamhoEWOQhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YnXzcWtl; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso8610402b3a.2
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766536138; x=1767140938; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=YnXzcWtl9Pl43vI8tnxEnoOGUMS7QaGspcRV0eAgN4pw2e7MarPyYCeaJ+/ndqjgoX
         vBSYXsiZeJHpmA5X0HGHHWpjdHSSTETBvBpGhGS1k39K5KZNeZJr0EkuvUv/iTJKF2ng
         tRxFjZxVLqgCeOZ1xHPJeVLetUq23uBhvl0idV01SaMqUYLW9u1S5t67wLm92I9P5KzH
         3eV3brW09Yh1fbTuoy+KxkCXGNO8cLVFBNGE78yhP/rJbsmGwUJ34xeikHlMwDZq//Gx
         81FFhA8/jmLRDVZsyVT/oqBnul/mBUh2pFZBzxxcQstS4aXR4fWLcMsUxT72tprT3YQk
         W9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536138; x=1767140938;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=Yp6UhzkTCVN7HWiozjClaZdGB3RqzVc4ladVnQqi4jHQD/UdkWlj3+a6S5o6vjrA1V
         KnjjT4H3Z+xeKrFdlyYqvFt7fU/wWdFeNKy1bPhS42JP6l3InqCvMSaVXHYyo2f2DTuv
         cgmm9vCKnvDl2Kuz3UXpNKMoWiG/D6qa/NqJoczQb1Wb3UxpBQiE8SXZ8A4EGhsq3CLX
         oDFNtgSKV6ami2VYlmtX0QE9wdLZior6370IgcNZQqcEuWtWB/YVjqO9Dg17FioZBkWi
         VFogNP6uLYhWhT4QZf3nOw16eAjsAS9ZRE1vDwY+yg/0GYsoAWDOAafFvcAF6AUfGD7x
         +qHg==
X-Forwarded-Encrypted: i=1; AJvYcCXyC9vEw45fuPw/Hc24kf8dQQTd2yAPsDfjU+5OGvSWTtb8fC5SgwT1NLROqMN+PXJ1Oj0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Xv2peO86GXSfgxXPanZMh1WctO1TOED0k0/sFa00Q65SfXio
	RhQrCp8LdGSW3nmWrwLnLFapsejQ3eOS7uS+N3kFIjQIRe4cKFJoEPH3
X-Gm-Gg: AY/fxX5U1RpCFibhffe3DWD7USg912Jeegc8MzPMhadQDl7Ds3jl+D5KMR9TtTVnXuD
	K/KH+uFgYOvpXJPOLPOuRCi6/s+QPYIo0AccBcubm/CYB2wghVtn3kUP2R6OhEeX7739r838vjN
	ok7MhinetHMaMV15yQnm6TmSyzrSi87z4+6kWuHL/zTx5/gqckKPeRE6UXgPrdh6lKDUoCICsIu
	qG2VuMHkl3AFZn7m5jWEYjD32nXtWg9KMLZTJckm5NCjNobbvevS/pIXUeU3WS5YJQHIfljqcyO
	+HZKIZEn2KTWpHCnXsJgpqwIQUHSR6mabOnLq2mL5k/nBF8H3WPB4jq6awMgNt1ha8FV+pMGo1h
	RmsW6c7smXxs8BHvr4N8vbEJKTOg1aXTW4vkhLlDrB3e7gDZoKZQdXur6NCgroepUYkkPBSdLrV
	ii+cRw0ZZ4MsLjFtl1kTg=
X-Google-Smtp-Source: AGHT+IFdIc/UDuq+YWFWwYE+rGSg4T/7sFob5YN3Yow0dtG/wPBVPu2NKHMvyvYhCHAoi2nwyYlnEw==
X-Received: by 2002:a05:6a00:418a:b0:7e8:450c:619b with SMTP id d2e1a72fcca58-7ff66a6d701mr13217930b3a.50.1766536138262;
        Tue, 23 Dec 2025 16:28:58 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm14729340b3a.7.2025.12.23.16.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:28:57 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 23 Dec 2025 16:28:37 -0800
Subject: [PATCH RFC net-next v13 03/13] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-vsock-vmtest-v13-3-9d6db8e7c80b@meta.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
In-Reply-To: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
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
index fdb8f5b3fa60..718be9f33274 100644
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


