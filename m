Return-Path: <kvm+bounces-31177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B42779C1002
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF7311C20F40
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87DC194C92;
	Thu,  7 Nov 2024 20:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="JaLsUXbY"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24161D88C3;
	Thu,  7 Nov 2024 20:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012414; cv=none; b=N9fBazJOwQfotYmgTLKb1mVI+swmekgBp8VJIM5L//vBkbffvrWT3NbJjmVfO2m4feoONrKPAg4tHFDLUFCfXldMpkZdIxv+AX6qh+cquUkxvZBrvLk61AxmCdd4vPCpetun27VTjDEMHwuN5EySyWgGvv3z/e831YnWf2j44PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012414; c=relaxed/simple;
	bh=mhU9jxgV9z83Hv+GVH2dKHtzgraCtM5ha8gUXXnGMKc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=nmmULW1KC3T6BlHnO+Bf2wcppYaQXj4CNY8cWhBbZUE588BBovfGM6Y4XaviehsOTpxwGQjgOIOAl8CFuJvqOves89GFM40ijNzYTR5fGrQHOTiRapPBwLWXvzAFCDAiUodq7Ap/UzXzUdgNuEEpoYHlgrcTFzb2A5oldYckhPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=JaLsUXbY; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t99Oo-001cxv-AC; Thu, 07 Nov 2024 21:46:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-Id:Date:Subject:From; bh=Gv34US8GRBXtP87nryXTAC5SJFGYHzg1EnEJGs1AL7c=
	; b=JaLsUXbYo1BLPH5dPn7t3I2nPNXUpR6T63/pWZMSytcC/nf2gecrpBqNWQ0206nGzmGDFbKdd
	0+4YQyR2ykkTOWNc1TGWiujY2QdgiMZQlGijDO2t3fWHg38eJQMbAZPbDfmdSyB2XkKD9A3Cod4XW
	S5Tu6icjDQRfXCKFP68ozbJ7E27qiPbFhMrBrvPz1Bv9qZdc709iazkq5/A4wa0ZV3xRxAZKOc+hV
	guy9eJSCLGcLvUgbnfvR5Gkl+tP/GbIwMcYldXSY3XNTZWnLVQT6LWyQXZLqzq1m9j5p/5SJsViqc
	sMrWTyPjetKYGEbhKP0wE1ecdOzAQTxmtijjOw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t99Oh-0002fi-47; Thu, 07 Nov 2024 21:46:31 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t99Of-00303e-44; Thu, 07 Nov 2024 21:46:29 +0100
From: Michal Luczaj <mhal@rbox.co>
Subject: [PATCH net v2 0/3] virtio/vsock: Fix memory leaks
Date: Thu, 07 Nov 2024 21:46:11 +0100
Message-Id: <20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABMnLWcC/3WNQQ7CIBREr9L8td8ArURceQ/TBcWPJbVgoCE1D
 XeXsHf5ZjJvDkgUHSW4dQdEyi654CuIUwdm1v5F6J6VQTAxcM4k5hTMgiut+Ca9JFST7ElxcZF
 MQ119Ilm3N+MDPG0w1nB2aQvx214yb9VfYebI8GoHa03PlCJ5j1PYzybAWEr5ASJqsVyxAAAA
X-Change-ID: 20241106-vsock-mem-leaks-9b63e912560a
To: Stefan Hajnoczi <stefanha@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jia He <justin.he@arm.com>, 
 Arseniy Krasnov <avkrasnov@salutedevices.com>, 
 Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>, 
 George Zhang <georgezhang@vmware.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Short series fixing some memory leaks that I've stumbled upon while toying
with the selftests.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
Changes in v2:
- Remove the refactoring patch from the series [Stefano]
- PATCH 2: Drop "virtio" from the commit title [Stefano]
- Collect Reviewed-by [Stefano]
- Link to v1: https://lore.kernel.org/r/20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co

---
Michal Luczaj (3):
      virtio/vsock: Fix accept_queue memory leak
      vsock: Fix sk_error_queue memory leak
      virtio/vsock: Improve MSG_ZEROCOPY error handling

 net/vmw_vsock/af_vsock.c                | 3 +++
 net/vmw_vsock/virtio_transport_common.c | 9 +++++++++
 2 files changed, 12 insertions(+)
---
base-commit: 71712cf519faeed529549a79559c06c7fc250a15
change-id: 20241106-vsock-mem-leaks-9b63e912560a

Best regards,
-- 
Michal Luczaj <mhal@rbox.co>


