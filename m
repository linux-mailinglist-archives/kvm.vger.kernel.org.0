Return-Path: <kvm+bounces-40349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13BDA56D69
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 17:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEE217A9587
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC9E23A995;
	Fri,  7 Mar 2025 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lJeSkNOa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C760238173;
	Fri,  7 Mar 2025 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364310; cv=none; b=mL6kTsRUtrhJ14n/s+UKhJT/sBua9OrLux9yWx2Vr02uw2PkYjORHrzCl0+nFCNeXiwbawF0ZxWNDeBM/nbi53rQjvlvBmf2iKzz5hc7XS8h/i+yO/dPB2Zhf6v2BdyrE5fj9zhEsiEmsFfu0GJo7kDckDpusnHiXg+SCKltLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364310; c=relaxed/simple;
	bh=dou9LxTbjCg/TK9bz3v6nlT4kc6yvpg0t7FYG2dWH3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lzt/d0pbqhRLGn8bcr1SNuUFBjJPfsnu8mAyLIzG2H6d8U6in/BK/1P3EnkPwLLNdtl12Gj4/tFDro660hLFb+hOKQG1LXE6csA8ih76Qrr9NqC390MQmroqzjGIAPFwlKucocd5iA4p+e75b6ZupuzGOB2++PwtLUOyCMIFTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lJeSkNOa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624BBC4CED1;
	Fri,  7 Mar 2025 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741364309;
	bh=dou9LxTbjCg/TK9bz3v6nlT4kc6yvpg0t7FYG2dWH3o=;
	h=From:To:Cc:Subject:Date:From;
	b=lJeSkNOaWizpe65670I85HU9y6eg0HmOUp4LJ+c5Y05gNDJQFLl++Ag1xmLpkkdIo
	 xefmR/NR+AJyD58NKDuyPZxLOj8QSjmrwavVFdSIXQMpIVT/sKylb3tO2zh5p6g6uI
	 SGuIHVc+gQQVC7skzekT+0WroizhwoPhZrDFh3F2XU1dyCcdoIMAue2FPWCY5isglZ
	 JASfYBN8YpD71Ny9frSiw5P7qToxQQ6ZkV96iWFwZxjm1k08O8YESkUT8d+2CiJ29F
	 4kEhpHAuELMF3O/FI5zPsjubMBxFAIh0yzgawNFAtjaBvzrcVq1Yo/e6nSUkaFkuIk
	 MOnzUIn91yKUQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tqaP4-00BT9x-Uf;
	Fri, 07 Mar 2025 16:18:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ahmed Genidi <ahmed.genidi@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.14, take #4
Date: Fri,  7 Mar 2025 16:18:24 +0000
Message-Id: <20250307161824.2373079-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, ahmed.genidi@arm.com, ben.horgan@arm.com, catalin.marinas@arm.com, leo.yan@arm.com, mark.rutland@arm.com, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's what I hope to be the last set of 6.14 fixes for
KVM/arm64. This time, two patches addressing the two side of the same
bug, where pKVM's PSCI relay wasn't correctly setting up the CPUs when
in the hVHE mode. Thanks to Ahmed and Mark for fixing it.

Please pull,

	M.

The following changes since commit fa808ed4e199ed17d878eb75b110bda30dd52434:

  KVM: arm64: Ensure a VMID is allocated before programming VTTBR_EL2 (2025-02-20 16:29:28 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.14-4

for you to fetch changes up to 3855a7b91d42ebf3513b7ccffc44807274978b3d:

  KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu() (2025-03-02 08:36:52 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.14, take #4

- Fix a couple of bugs affecting pKVM's PSCI relay implementation
  when running in the hVHE mode, resulting in the host being entered
  with the MMU in an unknown state, and EL2 being in the wrong mode.

----------------------------------------------------------------
Ahmed Genidi (1):
      KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()

Mark Rutland (1):
      KVM: arm64: Initialize HCR_EL2.E2H early

 arch/arm64/include/asm/el2_setup.h   | 31 ++++++++++++++++++++++++++-----
 arch/arm64/kernel/head.S             | 22 +++-------------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 10 +++++++---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  3 +++
 4 files changed, 39 insertions(+), 27 deletions(-)

