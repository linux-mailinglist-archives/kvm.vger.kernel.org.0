Return-Path: <kvm+bounces-45063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6355AA5BD9
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 10:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 646564C50E1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0E325B1E2;
	Thu,  1 May 2025 08:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="X11sVjtD"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706B352F99;
	Thu,  1 May 2025 08:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746086753; cv=none; b=tRQ7qb024DOVZ9S3qhlvR5wbTFm4quKIJ4cOZQaq+IAfRFBDsQOEPi7q9EGE2ZXTcsdI3kNx6EUAMDfhyfC75QIzJ+2cZ0oW8bUowiE5/RNnFKe0iFtw4lI4WcIBpdt7YcE4gwaf8F6sk5prCk1eI4/v9Tsx77+PxTtch5hvcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746086753; c=relaxed/simple;
	bh=ccMcuDXcJUUiFHGfdCsCuXcBJFwK42HgB+FyX3k8HAk=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YLgVZGot43kE+/I+t0AspGj3LJkFmhVmzHlcBG1qnZU+ceBzXXmJsaS8r/idcRygYstB4SCA/KALJbwmT19TeMQxVmC+q8agObIoy1Zgp7wibzDVPe3CX6cnwJccTxXA0GYiPP/HOlvsL/3goHhTi/aj7hkGvUcMIfKRQoYRiZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=X11sVjtD; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uAOvT-00BnGr-0j; Thu, 01 May 2025 10:05:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=sJUhKrCcta0cCKfNjfc+tCMkcd0YHLjBP3lnJByQx5E=
	; b=X11sVjtDFm8yEoNaMhpaLlXQ5Gdp5LwHcvuzebpXnDjfB7AV4Efk7x1QxEy4RRol1i9j0WIT7
	/VvEWY/SZm7IUGiF3ycw6qozv0morKNS//I6HBI/VdAMSoIAkv/CVkIUbvcOmsSxR/rb5ObZv4ks2
	ufbvGcgMnYvYUfYO8Xusgh54BpFsSR+Cb89aJpjz6b1eIvuP3FTRuHepZI65bv2NAuPZNKxOVtCYZ
	6kloxVzc0a9jNrHWX/xn40UIqD3MOAaTfbX6QWC5KI11FwkEsx1ferPNNHYKDQM1TyZJLlZFzEz16
	M1ET2wVBpwgh4Qo/VPWXGgyEUj/7SyuP+Zm5pg==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uAOvS-0007wp-N3; Thu, 01 May 2025 10:05:46 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uAOvH-005lsv-Rc; Thu, 01 May 2025 10:05:36 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net-next v4 0/3] vsock: SOCK_LINGER rework
Date: Thu, 01 May 2025 10:05:21 +0200
Message-Id: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEErE2gC/13NTQ6CMBCG4auQrq0Z+kfrynsYFwJTaTTUtKTBE
 O5u043AcvLleWchEYPDSC7VQgImF50f8yFOFemGx/hE6vp8EwZMAgdBU/Tdi75dngI1wBRKa4x
 WHcnkE9C6ueRuZMSJjjhP5J6XwcXJh2/5k+qyl6SAZp9MNQVaC6mBa+TCsGto/XzufMkktqGsP
 lCWqUVjse2VUErvKd9QDgfKM+37FhveSi5k86fruv4AbNsNOyYBAAA=
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
Michal Luczaj (3):
      vsock/virtio: Linger on unsent data
      vsock: Move lingering logic to af_vsock core
      vsock/test: Expand linger test to ensure close() does not misbehave

 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                | 30 ++++++++++++++++++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 21 ++-------------------
 tools/testing/vsock/vsock_test.c        | 30 +++++++++++++++++++++++++++---
 4 files changed, 60 insertions(+), 22 deletions(-)
---
base-commit: deeed351e982ac4d521598375b34b071304533b0
change-id: 20250304-vsock-linger-9026e5f9986c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


