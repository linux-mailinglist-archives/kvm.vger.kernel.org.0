Return-Path: <kvm+bounces-18305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 854098D3A01
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3559B1F232D5
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA9B17BB15;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cj1FZJEQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFD7158201;
	Wed, 29 May 2024 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994594; cv=none; b=rH+c2rGA8ORBCUHWQUSixu651LA3hWmQWWYAqdd4yxQ/ziMZfxsssvUVKup7mtoWT402SShyW38l9Rf+yO+ZMN9xLfWAkx0ypZ5ZhBPhh3vCr8OHVVYwcl+7Eq1ZfyZEaT/VuP/P4zQk9rprxwEb6hpr0NDG/vIwGvnqi2LelWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994594; c=relaxed/simple;
	bh=mzzpY2WDUEdT5O0hM4sNQHoxuJb2hV42TrdHN6NeMXM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ut7n1qGhCUyZvhaaGQyvyafobKRbSvn6PxXQP6S8/jl3N65peDeYTVp6y4MFWK7E/zxsNXeUhLnJquP3WdDBSscBVRimGPApAwgRj8H0gSWIhsUXSAMYXyKs3Hhsc9ECmtN/+vUhv/EAejb7wzxXHG4xfrt6nQtpzDr+ISovOzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cj1FZJEQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E946DC113CC;
	Wed, 29 May 2024 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994594;
	bh=mzzpY2WDUEdT5O0hM4sNQHoxuJb2hV42TrdHN6NeMXM=;
	h=From:To:Cc:Subject:Date:From;
	b=cj1FZJEQCC7h2MvPAh0vgcPUDiPEg28hhIEp/P+508Cl4T2uxTVu+ZN/QJGe5wx2I
	 LM2AONmqpdCvXDL6+5sTrilCRW7+iAh10/RssIaVoX/LJUXvfQXqGnGBzO+yckyIej
	 9hNvjUfhzu5//KU1cTwXODJ4TwI1kQpKohDYuVoPeZZjjksQaw9/VPbTzUjT1tQkQh
	 w3/BEuesJGKJk4/UEYZdMfpnoKZWeh1y1e1TNOSSkc8REAcYFAMHMEkT29iJhHDqjW
	 eYULaxh/M/getvzZL/2aKAkk17rubV6DyFOQeHyVY12YxIn5F3gboKyx+09bncplov
	 i6Mfqfj7V10kA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKj9-00GekF-UL;
	Wed, 29 May 2024 15:56:32 +0100
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
Subject: [PATCH v2 00/16] KVM: arm64: nv: Shadow stage-2 page table handling
Date: Wed, 29 May 2024 15:56:12 +0100
Message-Id: <20240529145628.3272630-1-maz@kernel.org>
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

Here's the second version of the shadow stage-2 handling for NV
support on arm64.

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

 arch/arm64/include/asm/esr.h         |   1 +
 arch/arm64/include/asm/kvm_asm.h     |   2 +
 arch/arm64/include/asm/kvm_emulate.h |   1 +
 arch/arm64/include/asm/kvm_host.h    |  36 ++
 arch/arm64/include/asm/kvm_mmu.h     |  26 +
 arch/arm64/include/asm/kvm_nested.h  | 127 +++++
 arch/arm64/include/asm/sysreg.h      |  17 +
 arch/arm64/kvm/arm.c                 |  11 +
 arch/arm64/kvm/hyp/vhe/switch.c      |  51 +-
 arch/arm64/kvm/hyp/vhe/tlb.c         | 147 +++++
 arch/arm64/kvm/mmu.c                 | 211 ++++++--
 arch/arm64/kvm/nested.c              | 780 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c               |   6 +
 arch/arm64/kvm/sys_regs.c            | 398 ++++++++++++++
 14 files changed, 1773 insertions(+), 41 deletions(-)

-- 
2.39.2


