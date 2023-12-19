Return-Path: <kvm+bounces-4769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 628458181EC
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F35CD1F26ACA
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 07:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C318B1A5B1;
	Tue, 19 Dec 2023 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X7oDQMZy"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B6E1A27E
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 06:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702969161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LjcmumhqTGUBjhe7jkzqE6hIQWP5E4kPtz1kDXqg31g=;
	b=X7oDQMZyILGua/oDx5bn2UIdJlSH9yYHs3JyN6PT+yFXCkrij4XvK1MKjhJBo3QfPlbvAb
	zM8EwvRUPEp6OWZbndBbmU49q7BbXO1BNrJVL+vsFK5hBfc641hT3pgVlDPRM34huc433R
	NQUW5JffRh9GK1ndO9AIAqYbyNDT2yY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/3] KVM: arm64: Fix + cleanup for GICv3 ISPENDR
Date: Tue, 19 Dec 2023 06:58:52 +0000
Message-ID: <20231219065855.1019608-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Here's the alternative approach I had suggested in response to Kunkun's
bug report, building the GICv3 ISPENDR accessor on top of the existing
ISPENDR / ICPENDR accessors. With these changes userspace should
consistently read / configure the hardware pending state for GICv4.1
vSGIs.

Oliver Upton (3):
  KVM: arm64: vgic: Use common accessor for writes to ISPENDR
  KVM: arm64: vgic: Use common accessor for writes to ICPENDR
  KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR

 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  29 ++-------
 arch/arm64/kvm/vgic/vgic-mmio.c    | 101 ++++++++++++-----------------
 2 files changed, 49 insertions(+), 81 deletions(-)


base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
-- 
2.43.0.472.g3155946c3a-goog


