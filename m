Return-Path: <kvm+bounces-63451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F98C66EE0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 03:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 4EC7829DB6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F567329C67;
	Tue, 18 Nov 2025 02:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YvGyitWm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E187732570F
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 02:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763431240; cv=none; b=hgF7BiuoG6iOYCzqloQvNNs40RX5cXFjXXKELoY8m2V14s5XNfDPq+769S4W3c+y+gXeQqqoDTU++/SBZYA3J6aFCXqcWXUVJr6/6dDqoZnGY1sOkqHUEiF9JobN9VogBVIZG5BLUD07eQcIraELId512TBbDhlkoljhVMXqhJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763431240; c=relaxed/simple;
	bh=uOW23oUD888uPdfswggyv7h4B3njoPEFvMHwF6iAAmo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W5KRsGq0Ef1FjxHkZ1R24WXcI20koncAe/n3/Mxxcz7Xth4inAHizkIm/AAkm7p5JyHw0ASyTvjgZXxAF0DY7WFJiC3WsAAhcqS9yzyvYz8OwS2ejkAqW4hmdoNCmfQQJmsLhzb8bZDx8qdtyWrjVbZnOQMgOtk2ArkWHzwptkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YvGyitWm; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34372216275so5389389a91.2
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 18:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763431235; x=1764036035; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mhLUPvGLtyJcQ25GpVmgIbln5JiS+qaXLLDnH3A077U=;
        b=YvGyitWm5HtOLWDkacHtkEzVwBo6bLmw5bjRI5KahdU6vYZpie2LhsE7QRjfFmqpvV
         S1sg5FIzB3hunXYdxg+hCYhSEAgUXsIPtpwJXINmLFPJAPlzURuGMtG+a0TwuueynZtg
         NgPJIs2To4xQ0lc2YFdM5/Q8mC4H3KHf0wcgy5MSkk6oC9EynLVuPp38TwDBx2i1J4ZS
         30Xj+vjwRrDyfDdXluTBYdaZFK6rukvRYbcBdh6aIkVPcAYWOYKrHvrD6XC34IACdZ9d
         Q0kQllovX2O+ohhUwjZj+ldw2jfhzUrMKxBGUwYVoG4jQIeihUvdopAKjJsrsz59WBi7
         izwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763431235; x=1764036035;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mhLUPvGLtyJcQ25GpVmgIbln5JiS+qaXLLDnH3A077U=;
        b=PYPgAMRAbT+I7r4aogr3A0/yCxf1kXmU56NTJU/TZXQ/CowRGU2HJR/XEV/BcMVP2G
         ftfzyKbXuy8TjXgq5MMQSaAdOWk9ySEoULSJpifrZISmUtlkZQ/ejuPVVmOesGyACeNK
         DTFxYbM+6VTcsS41roOJSvWGmAvvqI8aeMIsNaZf2Wi7Nn/1K5OjaTZRxP/Lbcf1fEtI
         ewedTnA/K3NWCRtqE03Q/7uko9rIszBPYJmuj8yNQ1mZieeKG8d91yDOba3uMjxCSHKg
         SI2YsPea7vOqbpXfVq71Kqcsuk46ecqhldpZ9ysFJo3Hgu9ziBsBCZBXiiEsiTF9SKPV
         OIqA==
X-Forwarded-Encrypted: i=1; AJvYcCWOcy+q+VOAC1U1Er4fTMS4xXvLmmdFS6/8rshgi2z/V11JNkIxmHpTcrz9HQ4ufk/dETY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX4bdhnOn5wcd6PB1rtPfKrams2gZIh4+HWwKIPNi8IhYlWDPX
	fAcEasgzCpXuYe9D3sJzb3ToDcNiqOlxYkWrl3KFoGzcFEgQx3WoyiLe
X-Gm-Gg: ASbGncsDgpcWFpFsZD4VoyprRlSZrGhTCzv6LMnjYQUf8AfOwwb9rbB6Mj6UH4vtKpl
	Q2EUqkuJVye4wFvzpiJc4ka4XAvL7T3k/qd6Ykh70w+nnnkg8ggXdrgnLnkeVCrZ1lR7FhsVWFr
	2IC6RDZ433HA9Xf4JKSbWgUGHJfbIt0fYtDmpaxu4Cej4F4Yrm98SnQyhEsIA2pfTqul1cLYu2H
	LvFQ5znbC2J9QyRhKfntvZlWnYnwFn9WwH7k9KZQtloeXOmOYhAsy9noENPPJDxDThGYrrhLvys
	eZiC6uTXvgGKb6AnVWcy044V0SjOPFWdmeqAEE0B1S4QO8eKdlSGZJjt6E44lHf5os1fsJIkZ7+
	49P4gPYM9O7O+tugWQR1rSTZseSUgnALY1Qy/YHueavnR1zJtT8i0urxviRRcR7sDFPdJ1Cjkee
	yB3q5l+IXdcRR9feBb779vDX18kYMi4g==
X-Google-Smtp-Source: AGHT+IHLky6hFd2s4o/LoM/Lst3F8klAMSAkgSuH9Ql0+UHi5g9wFfThPyUZnxKhdSO4j0xQMtxpww==
X-Received: by 2002:a17:90b:2d05:b0:32e:a10b:ce33 with SMTP id 98e67ed59e1d1-343fa6326e0mr15954772a91.21.1763431234714;
        Mon, 17 Nov 2025 18:00:34 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:9::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm20082011a91.1.2025.11.17.18.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:00:34 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 17 Nov 2025 18:00:28 -0800
Subject: [PATCH net-next v10 05/11] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-vsock-vmtest-v10-5-df08f165bf3e@meta.com>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
In-Reply-To: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
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
 linux-kselftest@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com, 
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

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v10:
- break this out into its own patch for easy revert (Stefano)
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 168e7517a3f0..5bb498caa19e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1181,6 +1181,12 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 		.type = le16_to_cpu(hdr->type),
 		.reply = true,
 
+		/* Set sk owner to socket we are replying to (may be NULL for
+		 * non-loopback). This keeps a reference to the sock and
+		 * sock_net(sk) until the reply skb is freed.
+		 */
+		.vsk = vsock_sk(skb->sk),
+
 		/* net or net_mode are not defined here because we pass
 		 * net and net_mode directly to t->send_pkt(), instead of
 		 * relying on virtio_transport_send_pkt_info() to pass them to

-- 
2.47.3


