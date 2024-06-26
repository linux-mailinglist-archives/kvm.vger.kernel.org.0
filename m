Return-Path: <kvm+bounces-20547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC81C91809E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 14:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7785D289FDD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 12:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3147F1822FA;
	Wed, 26 Jun 2024 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDlzKdLF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF40180A7C;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719403719; cv=none; b=ep/Lv6xW3+Ifu5K2YHzMBwhssksKa7EV+mXj5NaVm2qkz5D9DNn3V+WtTEawsxW9pL5UO3KOjN4qmw99Zp+3HETuE4z5Sh33nN1p07zHhvGSTOloUlbRCE8O5frlTjtF8EGe5e8PlO6OwYKI4Wz9ZmlG/E0CfySwqmuyIHKAP3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719403719; c=relaxed/simple;
	bh=6+8bqp4cDtpRaRrmfUU+dpvgtMMlgSZQodg1El7MI5E=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=k2DlSWfeEXhn2yQTDjFN/eSqZBoPkQCleYJYKmzZaGt5mQyaY8pIRtl0U8FctXISC8DtOj+lURv8d8oai01Dm0zZe5hLI5wEmIA9jnqVN4jm04TGjIJQQ3R93mfhrNCU5005NxlxxeUJjvJ2N6asyuGAGr/yILPq/aOEzBkuw5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDlzKdLF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5371C32789;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719403718;
	bh=6+8bqp4cDtpRaRrmfUU+dpvgtMMlgSZQodg1El7MI5E=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=UDlzKdLFC0mXugOqHR4s+aAKbkIRyvmyNRi4Obm1D6H9lD9rFhoPX2TddF2txIWHp
	 1F8jIIo/JVw/CIRdEZVYaFgYfefE6u1e8cxaL8VGVPlR9hI/p7L2ppqIXKr0H3e80U
	 ErV9Eycea64kjjP2ZqrEJCpZzzJgjyRsqYIURm4OMYGjdYJyny08bEoBZoFbvhKaUF
	 GU+WdaHsT0tN6l3CR9PC7j52pXC1O4Ak/jqCjh6CfbKfSCgvXImDPBuA43P8sAS6Tr
	 Pz0P/XO+BIXUJfNY/ndQFAx3tgsMm/DANQ8FOWzW6A3kcDJYo0vZVRp13xqb905Cx3
	 3YPebud5/dkQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D31C30653;
	Wed, 26 Jun 2024 12:08:38 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Subject: [PATCH net-next v3 0/3] ioctl support for AF_VSOCK and
 virtio-based transports
Date: Wed, 26 Jun 2024 14:08:34 +0200
Message-Id: <20240626-ioctl_next-v3-0-63be5bf19a40@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMIEfGYC/x2MQQqAIBAAvyJ7ThArob4SEaVrLYSGSgjS37OOA
 zNTIGIgjDCyAgFviuRdhbZhoI/V7cjJVAYpZCeUVJy8TufiMCdut00b0w9KqBZqcAW0lP/ZBA4
 T/yyYn+cFLWo0gGYAAAA=
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
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719403717; l=2183;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=6+8bqp4cDtpRaRrmfUU+dpvgtMMlgSZQodg1El7MI5E=;
 b=IWWqvzJ+wnZA9iJ5U6GbU25eUB91GRaT6iBrG0OwHjrkK+izvBFFcKxzBLy8WlPe7dE9aaGNU
 f+xPdDS3YU4CVbMfqX62lWk26eorcsZcbT4gx0vnmd7AdJG1Jz277m3
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
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
      vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
      vsock/virtio: add SIOCOUTQ support for all virtio based transports
      test/vsock: add ioctl unsent bytes test

 drivers/vhost/vsock.c                   |  4 +-
 include/linux/virtio_vsock.h            |  7 +++
 include/net/af_vsock.h                  |  3 ++
 net/vmw_vsock/af_vsock.c                | 60 +++++++++++++++++++++--
 net/vmw_vsock/virtio_transport.c        |  4 +-
 net/vmw_vsock/virtio_transport_common.c | 35 ++++++++++++++
 net/vmw_vsock/vsock_loopback.c          |  7 +++
 tools/testing/vsock/util.c              |  6 +--
 tools/testing/vsock/util.h              |  3 ++
 tools/testing/vsock/vsock_test.c        | 85 +++++++++++++++++++++++++++++++++
 10 files changed, 206 insertions(+), 8 deletions(-)
---
base-commit: 50b70845fc5c22cf7e7d25b57d57b3dca1725aa5
change-id: 20240626-ioctl_next-fbbcdd596063

Best regards,
-- 
Luigi Leonardi <luigi.leonardi@outlook.com>



