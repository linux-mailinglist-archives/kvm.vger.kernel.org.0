Return-Path: <kvm+bounces-68397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BA0D3885E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 87A4830250B5
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F14831355A;
	Fri, 16 Jan 2026 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqwvUnlN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97673081BD
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598948; cv=none; b=PzHmmfg+vNB36UMQZl9G7DzxbhaN7i+rIfsxXpSO72oQ4XhyUvP3x1Iy43tlr4SwzAxUg9t6Xzklcw0BjMFBSqXGFwjfLVk2AEiqyFWfZgGhIRcdIwh10WEBP/djO/GObylJHagbeYDvElRaPDDd0eWlK+F2ETmhKqgoPKP6Aj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598948; c=relaxed/simple;
	bh=vD964Lj1wPSOw/16ssWykcRPX0KDwrhlz4wvw7+NTyw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uPXc+ZH7XjvLVBMtwpLJAYBMJOP52VTB1/+vTaH+UebhAQy5dn/xR4xXYBfF2t7KO2LrLekjveJGdHfohc6LkGnYXugsiPmUwOPktk3e1NxpE/22ihIcAyRpEtJ9qbIlp2UBcScWobSVur3VN/A0AWYfGaBvq6abVEYURnv1bLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BqwvUnlN; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-78c6a53187dso26082667b3.2
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598944; x=1769203744; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=BqwvUnlNPCKikTxYdL+5w8XOT82LgQ0+ssDXjKCFsQOiOEKeiqpdAFz8/CE93RQl5v
         /GVKF15nii0G6eKA5oQ8s22PMA7hztwgG5qgQDLIW3i5knksl747rL2nTy6hhVXHGHFy
         vQNhM17LwHRwZEtAqwkm6d5i5P1xIbrGPD8eDjNZCCEMNSMK8p6XUwSj1NxI0l7Ym5ZV
         S3Lxo/tw3O96guydkObG3nLyxKn7r9U0oaRjAvCLmJ8qQ1uCYYurSraB70Sj03AnAvXI
         WkOkTK0q3z508sBiWTyQ8VqmEyUTD1pndtwVGYmkBN5icbbVkvQOfNR9KCBiKYMzS1wK
         NxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598944; x=1769203744;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N0yb8kb1LkqAc5YpKYa8ha5gJygHDPK65XDs8oEX3qw=;
        b=j5AFaZkfPCfo6mLSZC6pginRXZVAzSluSi+OWGcvmOQCZyjWykFKzachvrPeom8rw6
         v2XsMPFyedZbd+Mr5Rui41YTSLlAPRfiG8WTK0v9LoMfc7isEcNlJta96nm9sj4KaiNb
         qqeJ/fmmEh9TdVabnMIl9nj4TnG3a3Y+AXuG3ieKN6ueVEvO8MGVT+Z18eRwq7lLZRil
         /U5/oQWFKSkpCZxmBice8z4k06vmQAscy6fUGxfcGyLewrPXEm/NfS8KhOba4map/2io
         sqmSyWW5zEtVstrLQgyj6E+RSaynPD8tjtAEg6P4fBltxPthT3U3k5k8Atg2GayWXTWc
         R34A==
X-Forwarded-Encrypted: i=1; AJvYcCX1wWE4zq364MmNWOUUTCEypfukDEycJHzTkdMrRhsS44PRCU5KPpfmJ2z0cWJWmdTbVxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiXH/lUTSSOmWCqVvlKM5/EB+Zz6pCSj6XQ7VYdKgBKZgjHEo/
	CHNo+IVKhkLU1jUeV6UcNvpuY2Gbzzrqj0KOnZ8OEULf/QUyEIApJvTs6WEKVg==
X-Gm-Gg: AY/fxX55qg37xlwll92+rbkCiI6zBiuSPkQiyrNl5Aou/PDYbIGBn+lXKFbdsmuZg8Z
	0FGuXblBiZhwxnbkRlkubPcgd8x1R8BJrVVfsUL3h2CIu4Qi1/27o9YMwu+1CNI2DVGTCz/0UrH
	2DuGqGfL+InUSDXNVWcQBOB5oXFr5PWcOXeKukxZi/gpfEyl+LmSsnuy4xRpS22Il+YawfpJSYR
	RCn8xdOTI08RQ6xkCLlfguyLlXFLrSpR1TnIa6dCGDWFVkYAUxItGTQ8cdyhw99DIdg4AtKPdzO
	0/tDIanTVBdn+oMqfigUZafRen3YWtzqxdKZDVRoxPhBUDkgKPcUe0DJAWdw2ffmqJkBi+u1IY7
	MDSK/wwQk6EvnPgzhDAprswbEfMdgVNEUTcD57u+Mz/3+xUoMq8IPe7POgNMGB4SkbPOFpu0Q1k
	jDQTaRX2n07g==
X-Received: by 2002:a05:690c:39d:b0:78c:2916:3f0a with SMTP id 00721157ae682-793c66b8eb1mr33268517b3.7.1768598944439;
        Fri, 16 Jan 2026 13:29:04 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66c729fsm13186297b3.12.2026.01.16.13.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:04 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:42 -0800
Subject: [PATCH net-next v15 02/12] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-2-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
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


