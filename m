Return-Path: <kvm+bounces-8893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBCA858579
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 19:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6F4A1F21AEB
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 18:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288C3136640;
	Fri, 16 Feb 2024 18:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bShf0MgS"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3492C1353E9
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708108930; cv=none; b=KRSBztxNefebsXUicW9dBBV5GoEiR+AQF4lppLLg04dhXMha7gtUOfGsXyBJi2Q6Cfw9v0ZY+kpm10kGuLzxwA8u1zLfSt8NB20EBVvJ1D16SZ3Q9QP+RsnjGuPNTBCVeMUghm2orw8Q6tl8Pnn9RjZr2fcGceRxgitXrxHAZ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708108930; c=relaxed/simple;
	bh=QxChEtUBGhZVQmcitgUSn661JjnUAOsMvF/MSmXznAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FgyVlaUNHzUTC6q6a+7IBblXfvwV6W0mDyGfZifHCkLADPKHG2MYNvR/GG1REkOoF6dIU0ieyDtA88Dvkth+yH3B1LtXVIpt5TeWl8BJ7zYER88sRoT8VDgyjS1ns/1s/ehwT3KkfnDkyFV5eKFxWUcHZeH0I2DHE0qIxFsH7I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bShf0MgS; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708108925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dy9uGuDewCRmPkjUp3zVJbGMujkAY9qYVaz8IFv8Bxg=;
	b=bShf0MgSqhuWrIL+S1qXovTFCfPLEhtIccDFfHBNEfhfP5OtCcTJr+ei8OFQ2UFIe50OQW
	32WQuJTz/ZgYEbAy6Hf3Hhxp2YrhqtIWgNgStHoKgVgQ1DRYMx8JH7oKcQRUFSkFrv436F
	WqvzO/QKMfXA7oylFbU9dCdjvrsqasU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 00/10] KVM: arm64: Avoid serializing LPI get() / put()
Date: Fri, 16 Feb 2024 18:41:43 +0000
Message-ID: <20240216184153.2714504-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As discussed, here is a slimmed-down series for addressing lock
serialization in the vgic_get_irq() / vgic_put_irq() path for LPIs. The
bulk of it is using an xarray to represent LPIs and leveraging RCU to
avoid serializing readers of the LPI configuration state.

There's a lot of potential for clean-up, but this is intentionally
deferred until after we fix up the LPI translation cache.

v2: https://lore.kernel.org/kvmarm/20240213093250.3960069-1-oliver.upton@linux.dev/

v2 -> v3:
 - Fix the stupid lock imbalance once and for all (Dan)
 - Drop the tracepoints / stats I used for debugging my own crap (Marc)

Oliver Upton (10):
  KVM: arm64: vgic: Store LPIs in an xarray
  KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
  KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
  KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
  KVM: arm64: vgic: Get rid of the LPI linked-list
  KVM: arm64: vgic: Use atomics to count LPIs
  KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
  KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
  KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
  KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()

 arch/arm64/kvm/vgic/vgic-debug.c |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c  |  4 ++-
 arch/arm64/kvm/vgic/vgic-its.c   | 53 +++++++++++++++++++-----------
 arch/arm64/kvm/vgic/vgic-v3.c    |  3 +-
 arch/arm64/kvm/vgic/vgic.c       | 56 ++++++++++----------------------
 arch/arm64/kvm/vgic/vgic.h       | 15 ++++++---
 include/kvm/arm_vgic.h           |  9 ++---
 7 files changed, 73 insertions(+), 69 deletions(-)


base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
2.44.0.rc0.258.g7320e95886-goog


