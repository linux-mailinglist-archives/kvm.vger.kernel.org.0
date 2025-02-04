Return-Path: <kvm+bounces-37240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7322BA27698
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 16:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C10263A3FDE
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 15:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378022147FA;
	Tue,  4 Feb 2025 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1p8T9UG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C4720C46D;
	Tue,  4 Feb 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738684644; cv=none; b=R7f9GRVjBO6vceraN4p7CiHW2TcYV3aw7Ud4gR7X4RX8eDWQYE15k0KpdSoeVBsIn8EsRPgfK3jUqWNuoeaC+DXdMx3Ge2hShjgqLZYSqdl42+o7WBuWi1SWD84soeE46tHmYavWVbC7MBIvuE16MwQjCzfPPHR0tV7Ly36pba0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738684644; c=relaxed/simple;
	bh=7uLPLkv/rRUvTQqmbKnITADQnn/mB3pVaCmFUVO5FDM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LT2W+InKiQ45S9sznfwbvOIYpJeYR+IW1G3qtDKmZKO3y9uj46WFQCk2ldupNy6DmlJ6/IAQK9wDUzuvwCeN1/jnfgtK2voO6payJtrhha3KDQnDaPOSTuCFR+j4xYdtRlH10mZZ/546iOaRQ9F+kKPH9v4PfwRHmGY5EBTGsJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1p8T9UG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3D4C4CEDF;
	Tue,  4 Feb 2025 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738684643;
	bh=7uLPLkv/rRUvTQqmbKnITADQnn/mB3pVaCmFUVO5FDM=;
	h=From:To:Cc:Subject:Date:From;
	b=s1p8T9UGTcbP/kXq8edjVeaZHp1tIIwnu1WuADL2T35DF3lfME8nV3nDzfdY8dCW+
	 c3aTjhTOfdauijgrdMbmpezc1jb9n1/AVkG+M7SqwKk6rFVuTs3Jji/wfxDebQA0+m
	 qHe5nnvy1fwS0R08exexp1+GBwdIPSQsqVSvxIB+08+XIePqMOOZ2BPOjsJFL3yWxd
	 VYsYuQN8axQrYdz9db2NyEYOlIFLlnsjfVwIFjZxiO2+ko8JKqun0UUxsvVT8gzTSL
	 VBzJ873rAFPnTy0avAKTKZgKiYUbZZCEMnuXpVUnJ91tOx3B7OMWN0ypOVUNJHEqMD
	 hoxQQCuPDWGFA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfLIf-000Tr7-6r;
	Tue, 04 Feb 2025 15:57:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Potapenko <glider@google.com>,
	Dmytro Terletskyi <dmytro_terletskyi@epam.com>,
	Fuad Tabba <tabba@google.com>,
	Lokesh Vutla <lokeshvutla@google.com>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.14, take #1
Date: Tue,  4 Feb 2025 15:56:56 +0000
Message-Id: <20250204155656.775615-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, glider@google.com, dmytro_terletskyi@epam.com, tabba@google.com, lokeshvutla@google.com, broonie@kernel.org, oliver.upton@linux.dev, Volodymyr_Babchuk@epam.com, r09922117@csie.ntu.edu.tw, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

This is the first set of KVM/arm64 fixes for 6.14, most of them
addressing issues exposed by code introduced in the merge window
(timers, debug, protected mode...). Details in the tag, as usual.

Please pull,

	M.

The following changes since commit 01009b06a6b52d8439c55b530633a971c13b6cb2:

  arm64/sysreg: Get rid of TRFCR_ELx SysregFields (2025-01-17 11:07:55 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.14-1

for you to fetch changes up to 0e459810285503fb354537e84049e212c5917c33:

  KVM: arm64: timer: Don't adjust the EL2 virtual timer offset (2025-02-04 15:10:38 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.14, take #1

- Correctly clean the BSS to the PoC before allowing EL2 to access it
  on nVHE/hVHE/protected configurations

- Propagate ownership of debug registers in protected mode after
  the rework that landed in 6.14-rc1

- Stop pretending that we can run the protected mode without a GICv3
  being present on the host

- Fix a use-after-free situation that can occur if a vcpu fails to
  initialise the NV shadow S2 MMU contexts

- Always evaluate the need to arm a background timer for fully emulated
  guest timers

- Fix the emulation of EL1 timers in the absence of FEAT_ECV

- Correctly handle the EL2 virtual timer, specially when HCR_EL2.E2H==0

----------------------------------------------------------------
Lokesh Vutla (1):
      KVM: arm64: Flush hyp bss section after initialization of variables in bss

Marc Zyngier (4):
      KVM: arm64: Fix nested S2 MMU structures reallocation
      KVM: arm64: timer: Always evaluate the need for a soft timer
      KVM: arm64: timer: Correctly handle EL1 timer emulation when !FEAT_ECV
      KVM: arm64: timer: Don't adjust the EL2 virtual timer offset

Oliver Upton (2):
      KVM: arm64: Flush/sync debug state in protected mode
      KVM: arm64: Fail protected mode init if no vgic hardware is present

 arch/arm64/kvm/arch_timer.c        | 49 +++++++++-----------------------------
 arch/arm64/kvm/arm.c               | 20 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 +++++++++++++++++++
 arch/arm64/kvm/nested.c            |  9 +++----
 arch/arm64/kvm/sys_regs.c          | 16 ++++++++++---
 5 files changed, 73 insertions(+), 45 deletions(-)

