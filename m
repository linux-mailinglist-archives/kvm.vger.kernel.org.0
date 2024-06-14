Return-Path: <kvm+bounces-19681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 398B1908DBB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99B5DB28DA5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A283D182B2;
	Fri, 14 Jun 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e64ZmcbP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73817BA9;
	Fri, 14 Jun 2024 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376375; cv=none; b=OolhDto/ssMwZx7cN689U3xjVGcEpCbDfu+eoE65diiJhJof0NabQKgOd8ww5LaS5iAeHhouTtoZoCCBYngimEXhDgPBysGdMVkfjPePkM9eYbdrsUbkp4OvIV3usj8vEgH1ghddqfLAYd4sevSPKV16eoixjw0bHi7eXNww20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376375; c=relaxed/simple;
	bh=xsQtZpEJDOrdnBJYSovlHe1ZmVqfDD6Gyi/ImZOHD20=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aUB7647sZRL6FX0JYJ/rA8lWk24KaLr16thdP7k2+JpBpYQC78T2VdAbWj7qSDCiJXhwJnb9nO08e5CN2c+12szxkANSl/PhZ5BhY/9Xo/Vp736MNwnqiVGLeQd5zj7kq5sG38zuQegyNNasQJelTyU6UNNzZe8aDKv3x80QS6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e64ZmcbP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F1AC3277B;
	Fri, 14 Jun 2024 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718376375;
	bh=xsQtZpEJDOrdnBJYSovlHe1ZmVqfDD6Gyi/ImZOHD20=;
	h=From:To:Cc:Subject:Date:From;
	b=e64ZmcbPRiWGq5dZFHfjnqmZ+BZioQz3KH6FzSLQua8M3NgX8rugnxCWxrwcUGaF3
	 hjG3/56JxF7Mk3iLhh93E1S/ZPp1Ubi8Wi1nBtDPaER06Q8LSx3nHMJj6l3D7z1lo7
	 fjeYmlEO/S2LtBPteRK3rO2wmOysYypWGVgMYS9Ec7m7eLPWF2Ubq+waw/TV/kjEfV
	 rVyFFwC/ZbhBMaSoo8NIcr27UCKX0DcotO1n5fIavBBMJz9oqdVxhWdFwLOJ68HYf1
	 MQtudKTk5RmtipyE6yk8K5EhpwJmXQs9C47iT8JextNFCsg5wxUIYeQeIurJDeL8mP
	 5WbxKHVYS79oQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sI8Bx-003wb4-MV;
	Fri, 14 Jun 2024 15:46:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 00/16] KVM: arm64: nv: Shadow stage-2 page table handling
Date: Fri, 14 Jun 2024 15:45:36 +0100
Message-Id: <20240614144552.2773592-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's the thurd version of the shadow stage-2 handling for NV
support on arm64.

* From v2 [2]

  - Simplified the S2 walker by dropping a bunch of redundant
    fields from the walker info structure

  - Added some more lockdep assertions (Oliver)

  - Added more precise comments for the TTL-like annotations
    in the shadow S2 (Oliver)

* From v1 [1]

  - Reworked the allocation of shadow S2 structures at init time to be
    slightly clearer

  - Lots of small cleanups

  - Rebased on v6.10-rc1

[1] https://lore.kernel.org/r/20240409175448.3507472-1-maz@kernel.org

Christoffer Dall (2):
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables

Marc Zyngier (14):
  KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Add Stage-1 EL2 invalidation primitives
  KVM: arm64: nv: Handle EL2 Stage-1 TLB invalidation
  KVM: arm64: nv: Handle TLB invalidation targeting L2 stage-1
  KVM: arm64: nv: Handle TLBI VMALLS12E1{,IS} operations
  KVM: arm64: nv: Handle TLBI ALLE1{,IS} operations
  KVM: arm64: nv: Handle TLBI IPAS2E1{,IS} operations
  KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
  KVM: arm64: nv: Tag shadow S2 entries with guest's leaf S2 level
  KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
    information
  KVM: arm64: nv: Add handling of outer-shareable TLBI operations
  KVM: arm64: nv: Add handling of range-based TLBI operations
  KVM: arm64: nv: Add handling of NXS-flavoured TLBI operations

 arch/arm64/include/asm/esr.h        |   1 +
 arch/arm64/include/asm/kvm_asm.h    |   2 +
 arch/arm64/include/asm/kvm_host.h   |  36 ++
 arch/arm64/include/asm/kvm_mmu.h    |  26 +
 arch/arm64/include/asm/kvm_nested.h | 127 +++++
 arch/arm64/include/asm/sysreg.h     |  17 +
 arch/arm64/kvm/arm.c                |  11 +
 arch/arm64/kvm/hyp/vhe/switch.c     |  51 +-
 arch/arm64/kvm/hyp/vhe/tlb.c        | 147 ++++++
 arch/arm64/kvm/mmu.c                | 213 ++++++--
 arch/arm64/kvm/nested.c             | 781 +++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c              |   6 +
 arch/arm64/kvm/sys_regs.c           | 398 ++++++++++++++
 13 files changed, 1775 insertions(+), 41 deletions(-)

-- 
2.39.2


