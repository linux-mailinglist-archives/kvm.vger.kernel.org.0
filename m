Return-Path: <kvm+bounces-47191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 741A2ABE7C5
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34C774A76CE
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634E4264F9C;
	Tue, 20 May 2025 22:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="dXrhyDZO"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6E525FA0B;
	Tue, 20 May 2025 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781794; cv=none; b=Wivld0QKmF/tuLJzDC1YzqGpFIIsUv6ywibvI7elYCyhSw3GUkPKdsvGffboPnfLIMU+/2h6BQkV0hD9iKW5CIcfC8EHsk6wO7/vE9/xO7nXmhbrATnk92ELa+mmSA0fMMbzjdfJj5agmK/q4txQ5mjpuhwoEIuAeLFCEQgI0tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781794; c=relaxed/simple;
	bh=+9/o4prQpeZc0AmfoSpveY11MqEyfGKVbpQfFFqt900=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=K/PbjNTM2pwLR2Lcl3wHCeL/iH9Q/IktyE1hotb+J/lMK7GU3u2w0/ee9lSBciGZ2pUNc+GQu6SIVR0RCwDaeWJZewQ0PZf0PWTLY0SLPo1TcdN+8oTax2r6ABgP6LoLY3D53SW1dzYAy0q8ygm1YobAl/vKAR7pKpjdBYFBUSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=dXrhyDZO; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsh-001Mh2-CL; Wed, 21 May 2025 00:56:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=knfvcN2cjAGG2Tfr0KwPblV7ImwR2xWBY5X7KR10gL4=
	; b=dXrhyDZO2nlEw4eqddXYOWApIZNmg2mrwscfo81kjw7h6WeLCuuXe/+RGh38/uzMekx46J5k9
	TTBFS3P3Le31D6PKstfvgFvSLCCHDAdD7DlW5+nTIYECvJW8d0S8Ej7qHvUcwTIW/KByhBwKsjgEX
	5kTpCVzfaZagJLJJpYQIBjupoabXAxss1RWLheFGAVq1BxGY0YPdjMk9ByLUX7V9ndszQ18dJ4is7
	CHin3YqDG9wsaYI2cOlXbJbEALG6Pdht6e+4fBlokFwZb5442n7MjFke5Oy6WG+NFQ7YGgzJaDiUP
	FTFInce+KYQpOJU+q8KeXTuXszZG6S+NWJeutg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uHVsg-0007mv-Om; Wed, 21 May 2025 00:56:19 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uHVsW-00CxGf-4H; Wed, 21 May 2025 00:56:08 +0200
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net-next v5 0/5] vsock: SOCK_LINGER rework
Date: Wed, 21 May 2025 00:55:18 +0200
Message-Id: <20250521-vsock-linger-v5-0-94827860d1d6@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFYILWgC/13NwW7DIBAE0F+JOIdqDQuGnPIfVQ/GrBvUyERgI
 VeR/72IS20fR6M382aZUqDMbpc3S1RCDnGuQV0vbHwM8zfx4GtmAoQCCchLjuMPf4ZaJW5BaFK
 TtUaPrJJXoimsbe6TzbTwmdaFfdXmEfIS02/7KV3r2yRCf5wsHQfeoTIgDUm04p5cXD/G2GaK2
 FHRnaiodCI7kfMatTZHKndUwonKSr131EunJKr+SPGfKji/YqWOBue8GcDgjm7b9geVTS4ZYQE
 AAA==
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
 net/vmw_vsock/af_vsock.c                | 33 ++++++++++++++
 net/vmw_vsock/virtio_transport_common.c | 21 +--------
 tools/testing/vsock/util.c              | 38 ++++++++++++++++
 tools/testing/vsock/util.h              |  5 +++
 tools/testing/vsock/vsock_test.c        | 80 ++++++++++++++++++++++-----------
 6 files changed, 134 insertions(+), 44 deletions(-)
---
base-commit: 9ab0ac0e532afd167b3bec39b2eb25c53486dcb5
change-id: 20250304-vsock-linger-9026e5f9986c

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


