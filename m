Return-Path: <kvm+bounces-21412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9F392EB26
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 16:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24A9BB21846
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 14:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B8C16C852;
	Thu, 11 Jul 2024 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQt3hj46"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C347516A934;
	Thu, 11 Jul 2024 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720709937; cv=none; b=q7juwat867hdMb2oM0VQHE7pGmPrCt3LtCRPccRjEZvrbVS+fyalPfOZKenDp0iWUVLxyzomsBVwI69yIXGaNG3+/bX6/WyhxuAAiNgEGg7PMNMfM6PhD+mgkMBT+xXGZSZ3mRuPfVGPeSZtuPVK0NEnwr8zSggDDNphmg+QFAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720709937; c=relaxed/simple;
	bh=4GyMZnbR7RiPhK1S6uAJ8PduAHpuNhc35bIXtjWWqbQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=jA/sdPRoKZcvnSHI1EpU+741+peBOqfhOf92BP1RzKvAuHCZOtZpbAsZxxrSbjipyGW2/nYyBgkPCwE0/1slNTJh0oK3iOFjZCSNqXPSZ/hrjtsgal+91223SYKXs96eQ2+89jWNMoO3lSBnLsApoeraECsqi7HbAZwnmGQZ7dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQt3hj46; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F79CC116B1;
	Thu, 11 Jul 2024 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720709937;
	bh=4GyMZnbR7RiPhK1S6uAJ8PduAHpuNhc35bIXtjWWqbQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=EQt3hj462HVtv8t7gwaJVzRsId2xhPA5K1Iq4x6shc7r70N+2E0N4CUI8kpgcRPfY
	 Xw54ltVGnoOTRawhBxtsPlusVHUBxMGJgSZqb47+3c/n6sdDmBl7jLGlwViklznptw
	 YXpL8gqEaJ6gAbBpGAnveiXiWVuVfmDXFBGZwTPUKLCr42rI6boEFit0PjEU+VP7DH
	 V0sFYEvfGqL3SDQVIkqb5z8Z5BmF34QB0383GnF+9JfIZAsYPGt8d6VqoppvUJ0jWS
	 0Wb4oEOq05KxLPtDjLLDsER/G2ojB4ZP4DAO0t6zhQLo2UePctiOgeo5gEVzokMEms
	 MOnE0PPonKoDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44310C3DA49;
	Thu, 11 Jul 2024 14:58:57 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Subject: [PATCH net-next v3 0/2] vsock: avoid queuing on workqueue if
 possible
Date: Thu, 11 Jul 2024 16:58:45 +0200
Message-Id: <20240711-pinna-v3-0-697d4164fe80@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACXzj2YC/x3MQQqAIBBA0avErBPGEsKuEi20xprNJBoRiHdPW
 j74/AKZElOGuSuQ6OHMlzSMfQfb6eQgxXszDDgYnLRWkUWcMtYHdB6tRQutjYkCv/9nAaFbCb0
 3rLV+RekMaGEAAAA=
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>, 
 Marco Pinna <marco.pinn95@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1720709936; l=2312;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=4GyMZnbR7RiPhK1S6uAJ8PduAHpuNhc35bIXtjWWqbQ=;
 b=OKe8ArgWw5s3u221y8cYuzl/lSRKwV/KLQr+zKG2+UoJkwwYco3/h7ze8TQ2g7Tou2mH9sYna
 ymMojPaSHiSBhA1oKQ0WLMtDg4CnXUz90W6JcWVVr7GBamNlm0wr8C3
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

This series introduces an optimization for vsock/virtio to reduce latency
and increase the throughput: When the guest sends a packet to the host, 
and the workqueue is empty, if there is enough space, the packet is put
directly in the virtqueue.

v2->v3
- Performed more experiments using iperf3 using multiple streams
- Handling of reply packets removed from virtio_transport_send_skb,
  as is needed just by the worker. 
- Removed atomic_inc/atomic_sub when queuing directly to the vq.
- Introduced virtio_transport_send_skb_fast_path that handles the
  steps for sending on the vq. 
- Fixed a missing mutex_unlock in error path.
- Changed authorship of the second commit
- Rebased on latest net-next

v1->v2
In this v2 I replaced a mutex_lock with a mutex_trylock because it was
insidea RCU critical section. I also added a check on tx_run, so if the
module is being removed the packet is not queued. I'd like to thank Stefano
for reporting the tx_run issue.

Applied all Stefano's suggestions:
    - Minor code style changes
    - Minor commit text rewrite
Performed more experiments:
     - Check if all the packets go directly to the vq (Matias' suggestion)
     - Used iperf3 to see if there is any improvement in overall throughput
      from guest to host
     - Pinned the vhost process to a pCPU.
     - Run fio using 512B payload
Rebased on latest net-next

To: Stefan Hajnoczi <stefanha@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
To: David S. Miller <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
Luigi Leonardi (1):
      vsock/virtio: avoid queuing packets when work queue is empty

Marco Pinna (1):
      vsock/virtio: refactor virtio_transport_send_pkt_work

 net/vmw_vsock/virtio_transport.c | 143 +++++++++++++++++++++++++--------------
 1 file changed, 93 insertions(+), 50 deletions(-)
---
base-commit: 58f9416d413aa2c20b2515233ce450a1607ef843
change-id: 20240711-pinna-49bf0ab09909

Best regards,
-- 
Luigi Leonardi <luigi.leonardi@outlook.com>



