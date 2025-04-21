Return-Path: <kvm+bounces-43728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E052EA95869
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C79107AA90D
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C896421CA07;
	Mon, 21 Apr 2025 21:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="jukvpE8S"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C641C6FE1;
	Mon, 21 Apr 2025 21:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272285; cv=none; b=kwhnDyHM9VMOAyRdc4O3mdMjtuw3ZLBDCH5Wfk+dnVo/YmIMT1j1CkHbqP4Bb0pULdVsGlf7Ntz1T/4JxHUwyemsA2kxHhk876hAp9R2YjNoN1VqvGCJZAtmmrt17h78nyaj+4+oMcjeUhNRFWTfPotNpIxhoobVi6o9LDznZVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272285; c=relaxed/simple;
	bh=HyT++7V1AOZvPoNvFoFoo1SlvVznay6EHuHNjPxCZQs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AEe31WSgGP4NCeg3gB5QA5ERvUOrQKFWvdUovoNGHbQvZSD3kx2JR/zs51zVwh2PvVuelSVCkwxMgb1uyNVqOwkroxvJtvySgEi+7Oscb84goggWl7lLqEH/QbcD3Mh8cTvNhcnwjTCSmv8/yUi+9xj/23OWZVvgNmqXBMql33Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=jukvpE8S; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2l-001iAh-UK; Mon, 21 Apr 2025 23:51:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=cJG1o1PAVMfo65c2jak5MnoP2Klf8L19W0RX+/R9Jmo=
	; b=jukvpE8Sn/PdpMalM4f8Sbjno2EmwvkP2RH/PBEWtTjE1qswKf9//9whYCvfVbuDA6NLKKQfu
	Z05GR6tVp5/dTSDoa8L7It7xpmQ4HlEN0hBOLXLXCpXX+BlploSIPWk23KD/KaHjkEWb+mP4bm2Cv
	nC4nAClKHGs5y5LBp5ySinYjuT2hPhOWmJF+pbBlmODODuA39IG0/wiy9Xgy88+lzeCcqX8ndVeyx
	HwtVyYgoWSAk0Q6j9vstWgq1nfQDfxDyazAXHe2g6/nslmoQJcORZGTYC7qIYisAV6E47UAo4yB0h
	aBwZuaP+1yNiEinAd6VH4lpOZrbjfnUAZ6HROQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u6z2k-0000NU-T9; Mon, 21 Apr 2025 23:51:11 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u6z2g-0056xd-NB; Mon, 21 Apr 2025 23:51:06 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net-next v2 0/3] vsock: SOCK_LINGER rework
Date: Mon, 21 Apr 2025 23:50:40 +0200
Message-Id: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALC9BmgC/1WNQQrCMBBFr1Jm7cg0SWvjyntIFxqndlASSUqol
 N7dkJ3Lx+O/v0HiKJzg3GwQOUuS4AuoQwNuvvknozwKgyLVkSaDOQX3wrcUFdGS6rmbrB16B2X
 yiTzJWnNX8Lyg53WBsZhZ0hLit/7ktvqaNHT6T+YWCVvTDaQH1saqS7yH9egCjPu+/wA1KxxGs
 AAAAA==
X-Change-ID: 20250304-vsock-linger-9026e5f9986c
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Change vsock's lingerning to wait on close() until all data is sent, i.e.
until workers picked all the packets for processing.

Changes in v2:
- Comment that some transports do not implement unsent_bytes [Stefano]
- Reduce the indentation of virtio_transport_wait_close() [Stefano] 
- Do not linger on shutdown(), expand the commit messages [Paolo]
- Link to v1: https://lore.kernel.org/r/20250407-vsock-linger-v1-0-1458038e3492@rbox.co

Changes in v1:
- Do not assume `unsent_bytes()` is implemented by all transports [Stefano]
- Link to v0: https://lore.kernel.org/netdev/df2d51fd-03e7-477f-8aea-938446f47864@rbox.co/

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Michal Luczaj (3):
      vsock: Linger on unsent data
      vsock: Reduce indentation in virtio_transport_wait_close()
      vsock/test: Expand linger test to ensure close() does not misbehave

 net/vmw_vsock/virtio_transport_common.c | 29 +++++++++++++++++++----------
 tools/testing/vsock/vsock_test.c        | 30 +++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 13 deletions(-)
---
base-commit: 8066e388be48f1ad62b0449dc1d31a25489fa12a
change-id: 20250304-vsock-linger-9026e5f9986c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


