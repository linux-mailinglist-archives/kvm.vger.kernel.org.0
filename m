Return-Path: <kvm+bounces-51401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF6EAF6FB3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D29D1C80298
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBAAC2E1742;
	Thu,  3 Jul 2025 10:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDh6RQ+G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D631D299A85;
	Thu,  3 Jul 2025 10:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751537274; cv=none; b=swqyKp94LPu/nqSrYQecGZSB3jzu6EGJG68/khicFIgNokv/F6EwQVjFRGKNuBkemF/c53ZUfejumCQVjsiRh6HwR8A/g88VzdYrUBSaJs+EckaFgjEDlfTHwwWhg0ZTE72Axmm1mYLWsfs9b02jCv/Sba2cGDcZ3k/YHqVuG64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751537274; c=relaxed/simple;
	bh=F/OkyKp+J6DRlUl/QwnUYqH016WngjOoTrYbS5ddsoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IR/cSXpuL5iFmiiTyWva7XNanXXkA9rvtkaBJqBQgCvJMgFLfYA+afp+sg6DyftRrN32paW6wsPBJxWFQRRqDDrUNtfuX8gvVOSXQ1ip+b8w1S5f7V+j0wKkbSu9J0IXf+wKNZ8d5nc3er9uYgcVj1WIDf/Kk2624AC7kJRttks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDh6RQ+G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C768C4CEE3;
	Thu,  3 Jul 2025 10:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751537274;
	bh=F/OkyKp+J6DRlUl/QwnUYqH016WngjOoTrYbS5ddsoQ=;
	h=From:To:Cc:Subject:Date:From;
	b=tDh6RQ+GnEb9Sr0A2319xxm6TfoOJdpr7LZSry7gSyoC0W4p6dWv4Zm4BENSOuXFi
	 KQ4Tx+ww3cqm3iQ164Hn2fgEBYpUCCEGPxCtxCDXRO7/6nWoSbcWnu6y2f9Rt83vkR
	 k+lw27QX1lE+Xkne73cGPepo5yIkj6feNwBM3OMmAIs/gE18xQdOPZzOwmLqfwH3Jr
	 nyu24tIUiltzyHMAflxlkQpwFMGGTgokSh2nN1YWmoRxZWaaF5y4+AHNyijIPqfZCF
	 lsxHJ5+mA2ab5XkG0WgNxstfx4qhxUzt0y7etKXi9nyR9921sjcqUDUcO686EgdBwJ
	 toQFGmfiWRxSA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uXGpD-00CG4L-Q0;
	Thu, 03 Jul 2025 11:07:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.16, take #5
Date: Thu,  3 Jul 2025 11:05:44 +0100
Message-Id: <20250703100544.947908-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com, tabba@google.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

The one-fixes-PR-per-week trend continues, with ever decreasing levels
of severity.

This time, we drop some leftovers from past fixes, removing the EL1 S1
mapping of the host FPSIMD state, and stop advertising bogus S2 base
granule sizes to the guest.

I expect you will bundle this with the kvmarm-fixes-6.16-4 PR from
last week.

Please pull,

	M.

Marc Zyngier (1):
  KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes

Mark Rutland (1):
  KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()

 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  4 ----
 arch/arm64/kvm/fpsimd.c           | 26 --------------------------
 arch/arm64/kvm/nested.c           | 26 +++++++++++++++++++++++---
 4 files changed, 23 insertions(+), 34 deletions(-)

-- 
2.39.2

The following changes since commit 0e02219f9cf4f0c0aa3dbf3c820e6612bf3f0c8c:

  KVM: arm64: Don't free hyp pages with pKVM on GICv2 (2025-06-26 11:39:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.16-5

for you to fetch changes up to 42ce432522a17685f5a84529de49e555477c0a1f:

  KVM: arm64: Remove kvm_arch_vcpu_run_map_fp() (2025-07-03 10:39:24 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.16, take #

- Remove the last leftovers from the ill-fated FPSIMD host state
  mapping at EL2 stage-1

- Fix unexpected advertisement to the guest of unimplemented S2 base
  granule sizes

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Fix handling of FEAT_GTG for unimplemented granule sizes

Mark Rutland (1):
      KVM: arm64: Remove kvm_arch_vcpu_run_map_fp()

 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  4 ----
 arch/arm64/kvm/fpsimd.c           | 26 --------------------------
 arch/arm64/kvm/nested.c           | 26 +++++++++++++++++++++++---
 4 files changed, 23 insertions(+), 34 deletions(-)

