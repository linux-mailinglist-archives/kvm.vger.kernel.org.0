Return-Path: <kvm+bounces-22696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBA779420DB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 147241C22994
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BBBE18DF83;
	Tue, 30 Jul 2024 19:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBQamUAb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585731AA3C1;
	Tue, 30 Jul 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368604; cv=none; b=XRo8pQbi3GhI6WW7vrXkeZn5nuWpBQilua+HJ4MbsEpR8wUUrl6HohML6kdTXzpCQbCC4FwvwTZQBFv6NwVZsmF65fu6BpeVNGxVQ6Prt1tzOojE1KAJuvLVSCCG8FWkf0ZuLKhDUlC6ZXQMhIkE4LJPltFOH/150dLJ5vfOJWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368604; c=relaxed/simple;
	bh=jStHrVvNAMto3VMCwoFU19s4xerZyWvjOXpxzysnaOY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=i0ymdk4MVKGiasuu3dvkbsIcJyMLcsvxk6GCPy9Baz7MZmFJnoUXmHX0A7+X49OXMFcITBYg0wQApODJS3d/3jWGa2aQoUz8SMnGDgaPIJHF22sdYhiYqZh1B7DUVT3xGpSaeZ8ku6q0OW9azPqzTb6OuqsBbxCkQQsBxI7eBxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBQamUAb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB8BEC32782;
	Tue, 30 Jul 2024 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368603;
	bh=jStHrVvNAMto3VMCwoFU19s4xerZyWvjOXpxzysnaOY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=UBQamUAbjkVbje/654hbxXutOTWGhQ9pIzDhQpgNGZYbFVJxo+9AFn7loTeFZfHDN
	 Qa8R/rcJVL2rhRdJF7IC56fFtRBHUv1l4frjfDfqvLgNW2NhmF27rwqbanIRHzVA6/
	 zyVMofk03ANG4UEwbY54eeYUb/XBBOza7qyCKXkph/7P0S3TSDT5vEf/0riXSbXV0f
	 m+/DxEdsSsF/4Na3IuCneEgf9W5cXPOhNyf66Lkyr5pz10Q9kdrr0zMIZ6q2sKnKZw
	 KSkhLxmKU5ifrun4C4c79uDxqaqMf4ODWWjYTfpEDbmqNh+6WCUqMR9yYWZUHFtoGK
	 jWAfa9oWfervQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EC3C3DA70;
	Tue, 30 Jul 2024 19:43:23 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Subject: [PATCH net-next v4 0/3] ioctl support for AF_VSOCK and
 virtio-based transports
Date: Tue, 30 Jul 2024 21:43:05 +0200
Message-Id: <20240730-ioctl-v4-0-16d89286a8f0@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAElCqWYC/x3MQQqAIBRF0a3IHyeYGUJbiQaVr/oQGiohRHtPG
 h643IcSIiPRIB6KuDlx8BWmEbQes98h2VWTVtoo2ynJYc2nVG62DmgXq3uq7RWxcfk/I3lk6VE
 yTe/7AVk6YbthAAAA
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>, 
 Daan De Meyer <daan.j.demeyer@gmail.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368602; l=2445;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=jStHrVvNAMto3VMCwoFU19s4xerZyWvjOXpxzysnaOY=;
 b=eqym0Ppsx5dpCzMQoiM/1cKMD/+ebz8mGeFylVwkxwL8mGlRCHqBIg/k3R70eCQDn2G/A9Yti
 R9Ku7AXyrOjDW5U1DxugU3XXRsqwD8EB/UJ6+9Z++WCr/FQh6ESD5LA
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

This patch series introduce the support for ioctl(s) in AF_VSOCK.
The only ioctl currently available is SIOCOUTQ, which returns
the number of unsent or unacked packets. It is available for
SOCK_STREAM, SOCK_SEQPACKET and SOCK_DGRAM.

As this information is transport-dependent, a new optional callback
is introduced: unsent_bytes.

The first patch add ioctl support in AF_VSOCK, while the second
patch introduce support for SOCK_STREAM and SOCK_SEQPACKET
in all virtio-based transports: virtio_transport (G2H),
vhost-vsock (H2G) and vsock-loopback.

The latest patch introduce two tests for this new feature.
More details can be found in each patch changelog.

v3->v4
- Fixed warnings produced by kernel test robots
- Functions are now *_unsent_bytes
- Minor style changes pointed out by Stefano
- Using opts->peer_port in tests
- Rebased to latest net-next
- Link to v3: https://lore.kernel.org/r/20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com

v2->v3
Applied all reviewers' suggetions:
    - Minor style and code changes
    - atomic_int replaced with an existing spin_lock.
Introduced lock_sock on ioctl call.
Rebased to latest net-next

v1->v2
Applied all Stefano's suggestions:
    - vsock_do_ioctl has been rewritten
    - ioctl(SIOCOUTQ) test is skipped when it is not supported
    - Minor variable/function name changes
    - rebased to latest net-next

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
Luigi Leonardi (3):
      vsock: add support for SIOCOUTQ ioctl
      vsock/virtio: add SIOCOUTQ support for all virtio based transports
      test/vsock: add ioctl unsent bytes test

 drivers/vhost/vsock.c                   |  4 +-
 include/linux/virtio_vsock.h            |  6 +++
 include/net/af_vsock.h                  |  3 ++
 net/vmw_vsock/af_vsock.c                | 58 ++++++++++++++++++++--
 net/vmw_vsock/virtio_transport.c        |  4 +-
 net/vmw_vsock/virtio_transport_common.c | 35 ++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  6 +++
 tools/testing/vsock/util.c              |  6 +--
 tools/testing/vsock/util.h              |  3 ++
 tools/testing/vsock/vsock_test.c        | 85 +++++++++++++++++++++++++++++++++
 10 files changed, 202 insertions(+), 8 deletions(-)
---
base-commit: 1722389b0d863056d78287a120a1d6cadb8d4f7b
change-id: 20240730-ioctl-0da7dee1b725

Best regards,
-- 
Luigi Leonardi <luigi.leonardi@outlook.com>



