Return-Path: <kvm+bounces-20803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FCC91E26C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 16:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DDB52845E2
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5B5168496;
	Mon,  1 Jul 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMHZp7Ao"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07DE15FA94;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719844086; cv=none; b=MlRoggHvesiR6CkG6dL1sJIyu0kLIaZZhnn7poA3ARW/xs0t0ccdc/rBgyMmZ34wiLGjwvlNp0UNOYk4j6Gzku/qekQLokCCXTql/Cs3YHM5foGDqHfehT6xgrzc90ub2KKq0TPH7xe2I/mmtWjRzRIj13WJJZC9xVLaoZL9ZGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719844086; c=relaxed/simple;
	bh=U2qxBsfXII2keV16dyH70ENv6wOvqN2WYE0+zRxOMF0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=qPa6OA+v9mXLzw1o3ssHZ5/CSOwX3BPkmbWhWpaUhjLed3hej66b/rKkjKOunr6kPlu7O/g/5CEmQ1Q0Ey9jmrjMbi18V/8WEuadSqMhoYj4P66Ao9Qqh7hhBij4dKIbQM/AT/C/zfAyUzujUxNFN5q134cvtQYFlr8o7SgMKag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMHZp7Ao; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C519C2BD10;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719844086;
	bh=U2qxBsfXII2keV16dyH70ENv6wOvqN2WYE0+zRxOMF0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=jMHZp7AomwtWebSdCVJuYyC8YLCsKVlMo1trczl3QyvZssdw7/zMTa53c99pYiTH4
	 D0fCSZuwAgGhbjKFIEyNmKniRjKcIzCqesrwaJ5gXMTNGNHTb7BIgE9PNSm1GSLj7U
	 nl5Z8Xlje1GOTcjvBqeT+EEqtk0x73CZwJ+85/duFbQnh9myeAs1NBTutczXajhBeU
	 qK1pdtly+UEAmUi0iM135jd1nXwCMqXllcJuJupI4pAHY86wdcPYBsD9YbY4VgInWc
	 x0KDiYawitZl/MgSJEaMsSqYd8ZTCnrh13gKRn3hFjlkpTrcK4RuyZQxfQJNV/vmSO
	 2nQq3XfoHJZVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216AFC2BD09;
	Mon,  1 Jul 2024 14:28:06 +0000 (UTC)
From: Luigi Leonardi via B4 Relay <devnull+luigi.leonardi.outlook.com@kernel.org>
Subject: [PATCH net-next v2 0/2] vsock: avoid queuing on workqueue if
 possible
Date: Mon, 01 Jul 2024 16:28:01 +0200
Message-Id: <20240701-pinna-v2-0-ac396d181f59@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPG8gmYC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIxMDcwND3YLMvLxEXTNDw1SLJLPklJREAyWg2oKi1LTMCrA50UoBjiHOHgp
 5qSW6eakVJUqxtbUAcKrvi2cAAAA=
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Luigi Leonardi <luigi.leonardi@outlook.com>, 
 Marco Pinna <marco.pinn95@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1719844084; l=1421;
 i=luigi.leonardi@outlook.com; s=20240626; h=from:subject:message-id;
 bh=U2qxBsfXII2keV16dyH70ENv6wOvqN2WYE0+zRxOMF0=;
 b=esDzwhcl7yJuEVfUWxslORjydGrepc2F2GuDVExEB8Nakxvmi/MOSRBrVWHlWsGJIu8pPkZ/n
 w4JKJyQ4CbFApgzN4ddfo9bd/Qa4DXkDUPY6EnpQUF4z6hZ1mm30WMt
X-Developer-Key: i=luigi.leonardi@outlook.com; a=ed25519;
 pk=RYXD8JyCxGnx/izNc/6b3g3pgpohJMAI0LJ7ynxXzi8=
X-Endpoint-Received: by B4 Relay for luigi.leonardi@outlook.com/20240626
 with auth_id=177
X-Original-From: Luigi Leonardi <luigi.leonardi@outlook.com>
Reply-To: luigi.leonardi@outlook.com

This series introduces an optimization for vsock/virtio to reduce latency:
When the guest sends a packet to the host, and the workqueue is empty,
if there is enough space, the packet is put directly in the virtqueue.

In this v2 I replaced a mutex_lock with a mutex_trylock because it was inside
a RCU critical section. I also added a check on tx_run, so if the
module is being removed the packet is not queued. I'd like to thank Stefano
for reporting the tx_run issue.

v1->v2
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

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
Marco Pinna (2):
      vsock/virtio: refactor virtio_transport_send_pkt_work
      vsock/virtio: avoid enqueue packets when work queue is empty

 net/vmw_vsock/virtio_transport.c | 171 +++++++++++++++++++++++++--------------
 1 file changed, 109 insertions(+), 62 deletions(-)
---
base-commit: 2e7b471121b09e7fa8ffb437bfa0e59d13f96053
change-id: 20240701-pinna-611e8b6cdda0

Best regards,
-- 
Luigi Leonardi <luigi.leonardi@outlook.com>



