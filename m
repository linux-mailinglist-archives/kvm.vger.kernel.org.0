Return-Path: <kvm+bounces-31015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6739BF4A4
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 18:52:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 980F01C21530
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E37207A19;
	Wed,  6 Nov 2024 17:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="Hg2S8iU/"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF3420408D;
	Wed,  6 Nov 2024 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730915547; cv=none; b=kAVc4Yb6w/g3+0IjYFgQvBA8vDNCXY4fmAMQwtjpRzCWW7wklQwdEIfPJGyO9mOhv6JM9PUONzveG32UbQqSySZ2YBz7GqNwcDO4pqcuYF7zyeZFFZ0FmQsWG7mqPflfxRNrbiZr2GMa6d9vtBWYJi/WlBYedYv8fjLE/vZnTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730915547; c=relaxed/simple;
	bh=KtPMXe1Kaoi+D+0zuVsHi/7XVFuHe7pLT3yUgBvsPWA=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EL8hdsuglkZRwNifAAzMXMPDQqbrukWIaTVTCxSDcGOjuaow+q6QfvQ8i0FDaQQrRrromBAKAbcHvQnP9eLdpp6mUEgTbO3cFAMhm6XuKSzIBBEbsW3jcRuT7ZM7WGJSMTDn8cSigBHPFrL7bmQcPhRO3faqwpg7FkOYKALARbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=Hg2S8iU/; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCZ-00GBfK-Fk; Wed, 06 Nov 2024 18:52:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=wAYzmgNEdIPQcm7RdwInLHDyAgTWgXzUWExQ3LJunH4=
	; b=Hg2S8iU/9HTIGKTP6qhlMJhACuhDz3iPyAC2mhkLZGzyyuzkLnylkxU1m0pz+rs06mPL7D2hq
	9kaMKgwIpd4bQ90GDA3CUg7ZiCZM4vBqhZ2ofCNpsCkvAxQLhNivSEbgIUvaVVYI0oBIQo7ig4vvB
	jIBJDy43PJXGh547KK9Fz/q+i2+mn4YnkL/EBc2tMmrFe/M4qYE2CR7YZo7Ajte46dF7kzB1n3zrL
	GfJW9mKA0hgyX5qSPduC7wG6NBizoYPgzE+QuMNrQRxeUNyeU8OtvyiXO1AVjQ6Ja8XOvKCamZ3TC
	saDK4FfLzCdVfBUzWKLEsoR5AO5P1AELM1jBqQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t8kCT-0001ra-VZ; Wed, 06 Nov 2024 18:52:14 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t8kCH-002ver-47; Wed, 06 Nov 2024 18:52:01 +0100
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net 0/4] virtio/vsock: Fix memory leaks
Date: Wed, 06 Nov 2024 18:51:17 +0100
Message-Id: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJWsK2cC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDQwMz3bLi/ORs3dzUXN2c1MTsYl3LJDPjVEtDI1Mzg0QloK6CotS0zAq
 widFKeaklSrG1tQDW+Q+8ZgAAAA==
X-Change-ID: 20241106-vsock-mem-leaks-9b63e912560a
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jia He <justin.he@arm.com>, 
 Arseniy Krasnov <avkrasnov@salutedevices.com>, 
 Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
 George Zhang <georgezhang@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Short series fixing some memory leaks that I've stumbled upon while toying
with the selftests.

The last patch is a refactoring.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Michal Luczaj (4):
      virtio/vsock: Fix accept_queue memory leak
      virtio/vsock: Fix sk_error_queue memory leak
      virtio/vsock: Improve MSG_ZEROCOPY error handling
      virtio/vsock: Put vsock_connected_sockets_vsk() to use

 net/vmw_vsock/af_vsock.c                | 6 ++++--
 net/vmw_vsock/virtio_transport_common.c | 9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)
---
base-commit: 372ea06d6187810351ed778faf683e93f16a5de4
change-id: 20241106-vsock-mem-leaks-9b63e912560a

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


