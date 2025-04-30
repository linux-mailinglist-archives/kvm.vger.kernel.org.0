Return-Path: <kvm+bounces-44875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 317FCAA4691
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15C691C033CD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E442C22259B;
	Wed, 30 Apr 2025 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="TNkYwI16"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED921B9CD;
	Wed, 30 Apr 2025 09:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004293; cv=none; b=NQHAQmiAptleFKYyJ8yPySqYjBodYa5L5qf9Dqcp11lA8Z0Cu0qWuRG+1c/kosPefvEwb75lhg7EpXCmW6Z8pyZ+GmXKXjFKIMKWNkdpa+U8HDrIRepo37YYPfcO1ZtE4Lk1MU5hqJBE0RFz5qOqlCtbvSRnIIFmb7D2vWyDuxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004293; c=relaxed/simple;
	bh=2Jcil456/vkVmqs9PlRkfDTruM95zMbUA78V93iIUK4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=tDBXw3eccd81HXUO067soDGVzCZ/PRTjaj01YhxaEl7pxwhlAuxJS378YaWgNOAFtuxzy72ki8+Dcgzks6yE2Y+6Py8DsdmeL34hJbjgdV367JIiGqKt7SBKTIF+hNfUWNhIse2opWnJWFRqvl/o7Q1SgBKBNF5kixjWBrqLDmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=TNkYwI16; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TP-008kiY-8o; Wed, 30 Apr 2025 11:11:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=maeyGrzLu/j7Ycws3ZsioeLXYsO9lrFZTaYjTyP+Ulg=
	; b=TNkYwI16P2pn67L0Dm56IzR+/SmuE7pqAsSKuYiLAWJhx+RF5+LF2LDkprLiUbfgpHjcTqEKy
	RwCM0s0LgGEvnCe7qzDmUKlcS5c/n/cdDjc4bKa9r6N12i51TG+wZbhWkZ6yRICk2pcE+BEx+H6Xr
	SK3YyKJjPGPqFB+6CRZzZfIkFGSGGVvrAyasjhvALT5p+jrqCALmvgFsf/7/QM4hLBb/QVMT7dX85
	vGD9IIW2r5rShjO0zlLxDyEupmAE5xxsa0KtqaVLr3ZKAgIUF4/Y4gITDKte4MWKltlAIMZrin5RV
	pdTzoGcl1rfvkcoMIApuYH500sR7Sv9Pf2dGTQ==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TO-0006B4-Nh; Wed, 30 Apr 2025 11:11:23 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA3TF-00CDEV-W6; Wed, 30 Apr 2025 11:11:14 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net-next v3 0/4] vsock: SOCK_LINGER rework
Date: Wed, 30 Apr 2025 11:10:26 +0200
Message-Id: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAPpEWgC/12Nyw7CIBQFf6W5azG8iuDK/zAuLL1YogEDDalp+
 u8SNj6WJ5OZs0LG5DHDsVshYfHZx1CH2HVgp2u4IfFj3cAp76mgkpQc7Z08fEWJGMoV9s4YrSx
 U5ZnQ+aXlzhBwJgGXGS6VTD7PMb3aT2GNt6Skh99kYYQSJntNhUYhDT+lIS57G1um8C+Vsz+VV
 9WhcTiMSiqlP+q2bW9N8LYa6wAAAA==
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
Michal Luczaj (4):
      vsock/virtio: Linger on unsent data
      vsock/virtio: Reduce indentation in virtio_transport_wait_close()
      vsock: Move lingering logic to af_vsock core
      vsock/test: Expand linger test to ensure close() does not misbehave

 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 19 +------------------
 tools/testing/vsock/vsock_test.c        | 30 +++++++++++++++++++++++++++---
 4 files changed, 54 insertions(+), 21 deletions(-)
---
base-commit: eed848871c96d4b5a7b06307755b75abd0cc7a06
change-id: 20250304-vsock-linger-9026e5f9986c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


