Return-Path: <kvm+bounces-47323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 40696AC009C
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 01:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34C117080A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 23:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658A1242D8F;
	Wed, 21 May 2025 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="CD0Wk8Sx"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E0123D2B1;
	Wed, 21 May 2025 23:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747869535; cv=none; b=bsPgLLPyjtWlMdpdm5e0P8xn9zaxzQAp3ZnweyaeYUzTxaXH3tE77aduGbYz9LNKXfQ7U8KT3CNkVVHfZq/25ot+g1i8LHHZwnFR2ZLh73j/JwgPNX7c/qp6v4IghD/qQaEHAkc6MtAk3VpaoYoiV7vMWUuA3Tm4AXusuMb9Bh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747869535; c=relaxed/simple;
	bh=4LdaDkfu2jy5/kU3mWx49wYFOvvJvoIpK2Qq4T20KK8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=abIZnrVczMpepuGX/p4+AyFOzVY8ld2HXVDB69POv/hufwRSUnixQLTm8i/g8bFoR4kaSBUf/w0XeO492mFkdtyzgW98UHN1BpcrcgW4I9I9EVzo5ujq2u22w5NhaZsbidZiM9gcGouuCnAH//ixbrymGmPgp1MFLzkbl4AyEpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=CD0Wk8Sx; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi3-004Io2-Nm; Thu, 22 May 2025 01:18:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=fn9yhZT2l/8janItukUSTDYCPTAabfFAewfozngMcrw=
	; b=CD0Wk8SxzlZBWt6uvblq5pzQDuk84bbNiUDkSEzBAD0IvHFt1oLG/jWIeYx2dndXsgYs+T+KJ
	EqVl4DUWvkC1gsPp8C+HQqA7JaLKh5DNCAEpj1sQhFtfbcUp7z+oK1wbw6FCpVXw2v302/gyhV+EU
	ZXrfopMURGz8CqiJn8tUGAZd8vY27kbQmW7qcr2z4cbvwCI3eKzYEZAGhf7PkJREQNclOe0pRe1ln
	GqPR9EuPE/3YKl746LcLVknSVI70L3es1ik4PSpWEatUSycb0YJMfewKWr7pT7rJPeu0jwNlSvX6Z
	uL5BY5x4W7AnSrsskDPbnOH4UF4xOC48eg/r7g==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHsi3-0000kJ-CA; Thu, 22 May 2025 01:18:51 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHshq-002oFI-94; Thu, 22 May 2025 01:18:38 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net-next v6 0/5] vsock: SOCK_LINGER rework
Date: Thu, 22 May 2025 01:18:20 +0200
Message-Id: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADxfLmgC/2XOQW7DIBAF0KtErEs1hgFDV71HlYUx4wa1MhFYy
 FXkuwexie0uR1/v/3mwTClQZh+XB0tUQg5xrod+u7DxNszfxIOvNxMgFEhAXnIcf/hvqFHiFoQ
 mNVlr9MgquSeawtrqvthMC59pXdi1JreQl5j+2k7pWt4qEfpjZek48A6VAWlIohWfycX1fYytp
 ogdFd2JikonshM5r1Frc6RyRyWcqKzUe0e9dEqi6o8UX1TBeRUrdTQ4580ABk9U7ei/h1WlFo3
 ojQbfef2i27Y9AZWgUPecAQAA
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

Changes in v6:
- Make vsock_wait_sent() return bool, parametrize enable_so_linger() with
  timeout, don't open code DIV_ROUND_UP [Stefano]
- Link to v5: https://lore.kernel.org/r/20250521-vsock-linger-v5-0-94827860d1d6@rbox.co

Changes in v5:
- Move unsent_bytes fetching logic to utils.c
- Add a helper for enabling SO_LINGER
- Accommodate for close() taking a long time for reasons unrelated to
  lingering
- Separate and redo the testcase [Stefano]
- Enrich the comment [Stefano]
- Link to v4: https://lore.kernel.org/r/20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co

Changes in v4:
- While in virtio, stick to virtio_transport_unsent_bytes() [Stefano]
- Squash the indentation reduction [Stefano]
- Pull SOCK_LINGER check into vsock_linger() [Stefano]
- Don't explicitly pass sk->sk_lingertime [Stefano]
- Link to v3: https://lore.kernel.org/r/20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co

Changes in v3:
- Set "vsock/virtio" topic where appropriate
- Do not claim that Hyper-V and VMCI ever lingered [Stefano]
- Move lingering to af_vsock core [Stefano] 
- Link to v2: https://lore.kernel.org/r/20250421-vsock-linger-v2-0-fe9febd64668@rbox.co

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
Michal Luczaj (5):
      vsock/virtio: Linger on unsent data
      vsock: Move lingering logic to af_vsock core
      vsock/test: Introduce vsock_wait_sent() helper
      vsock/test: Introduce enable_so_linger() helper
      vsock/test: Add test for an unexpectedly lingering close()

 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 33 +++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 21 +--------
 tools/testing/vsock/util.c              | 38 +++++++++++++++
 tools/testing/vsock/util.h              |  2 +
 tools/testing/vsock/vsock_test.c        | 83 +++++++++++++++++++++++----------
 6 files changed, 134 insertions(+), 44 deletions(-)
---
base-commit: f44092606a3f153bb7e6b277006b1f4a5b914cfc
change-id: 20250304-vsock-linger-9026e5f9986c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


