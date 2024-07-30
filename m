Return-Path: <kvm+bounces-22699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C8B942100
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A62411C21621
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE48F18DF6B;
	Tue, 30 Jul 2024 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCMr1Es5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F7A3FE4;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722368856; cv=none; b=blu/NyVPeVuKreasmx7Do8EBp745He4JFx2/gYymuocIZvqHTSnzMGQaKufrXgL31AJmUN3fClaldtfHZBmhmQNqparYEXbNo/MZF5DCBFgueSlqvI7jCjao61K63S803MdHQzRdl91vemu7QUSVlnm0y2u7e9TODDLbXzoilV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722368856; c=relaxed/simple;
	bh=IKREFN+TIgBJvxWjZQPVCllveoHa06J0Ilw0xt1IXRc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hLp6wVMwPrDqY0VCx2fIEk831PaDQYz3qB8LwGEw96gTYnmTnpiDUCCycge+lJ973G7ieIX20MVObE24D3xF/1fps/UgRCG3TL6w9C2bUwfnv75D9BPkbOxRl4gq8addd66s8M+avCPwe8G+Vl0yokryf80l/6p12vI6Yf2us5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCMr1Es5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91087C32782;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722368855;
	bh=IKREFN+TIgBJvxWjZQPVCllveoHa06J0Ilw0xt1IXRc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=SCMr1Es5fObb6B1Aq0WgKs9q2kbhNOUS4dGyNXDnf4KcGpkJf8m9f0TT07AYj21xH
	 7QFCdOafPCN2gnlo+d+b8fdcj6w0tsbc5oEWsgC1/Ozwm6xRH23nfVx1wCJerBkvF7
	 GhOIrBBsGxDF6oced7F1xWAHMulKTDpSlS1Hgx+0M0NH5EYQjGM0L05bH5806gE7Tz
	 SJSlTzv7u2gpoA2zQIiG4l0Hz2MwQYrNcUdOj8yy1HR93Rq96hWSknpqghDOgZ3iDO
	 phc7KjecbzsX/CQdRCHyf83JeKjpNGAxVMg9Y+j500tTFcB8XNBj7HJAwy06uUMeWH
	 CmcRS3jFDmedw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8A1C3DA49;
	Tue, 30 Jul 2024 19:47:35 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Subject: [PATCH net-next v4 0/2] vsock: avoid queuing on intermediate queue
 if possible
Date: Tue, 30 Jul 2024 21:47:30 +0200
Message-Id: <20240730-pinna-v4-0-5c9179164db5@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFNDqWYC/x3MQQqAIBBA0avIrBNMg6KrRAu1qWYziUoI4t2Tl
 g8+v0LCSJhgFRUivpTo4Y5pEOBvyxdKOrpBKz2p2SgZiNnKwy3ej25xyszQ2xDxpPJ/NmDMkrF
 k2Fv7AFfDA9NhAAAA
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Marco Pinna <marco.pinn95@gmail.com>, 
 Luigi Leonardi <luigi.leonardi@outlook.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1722368854; l=2569;
 i=luigi.leonardi@outlook.com; s=20240730; h=from:subject:message-id;
 bh=IKREFN+TIgBJvxWjZQPVCllveoHa06J0Ilw0xt1IXRc=;
 b=JLjB6D8toKe+KFeGH5/NYUNYcRfuWf3KVdRaY3LMIcqogFwa98x6njOM9A/V7AHeLl+y5UqFP
 vaj/3m7yjV8Ctc+o5bhG7weCTO2dUzzEIb20h5xrDH8Ae+lJGJhrr80
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=rejHGgcyJQFeByIJsRIz/gA6pOPZJ1I2fpxoFD/jris=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240730
 with auth_id=192
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

This series introduces an optimization for vsock/virtio to reduce latency
and increase the throughput: When the guest sends a packet to the host,
and the intermediate queue (send_pkt_queue) is empty, if there is enough
space, the packet is put directly in the virtqueue.

v3->v4
While running experiments on fio with 64B payload, I realized that there
was a mistake in my fio configuration, so I re-ran all the experiments
and now the latency numbers are indeed lower with the patch applied.
I also noticed that I was kicking the host without the lock.

- Fixed a configuration mistake on fio and re-ran all experiments.
- Fio latency measurement using 64B payload.
- virtio_transport_send_skb_fast_path sends kick with the tx_lock acquired
- Addressed all minor style changes requested by maintainer.
- Rebased on latest net-next
- Link to v3: https://lore.kernel.org/r/20240711-pinna-v3-0-697d4164fe80@outlook.com

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

---
Luigi Leonardi (1):
      vsock/virtio: avoid queuing packets when intermediate queue is empty

Marco Pinna (1):
      vsock/virtio: refactor virtio_transport_send_pkt_work

 net/vmw_vsock/virtio_transport.c | 144 +++++++++++++++++++++++++--------------
 1 file changed, 94 insertions(+), 50 deletions(-)
---
base-commit: 1722389b0d863056d78287a120a1d6cadb8d4f7b
change-id: 20240730-pinna-db8cc1b8b037

Best regards,
-- 
Luigi Leonardi <luigi.leonardi@outlook.com>



