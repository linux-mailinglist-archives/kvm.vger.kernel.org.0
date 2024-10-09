Return-Path: <kvm+bounces-28311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BA5997531
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DE331F24FDD
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7871E1A3F;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyvG5v/X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7D21E04BF;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=r0soxFwJ/HJAN87m81VQmbtOruxs5YRrC2wyauspPIt9O9T73fMwPyck8rjWjPQWlcrO7UccTtA7RCL0QQv4ZdEvkznkug8XRAsjEZVD+gwzrG+Zd29ZNla9HIJggIVQe3OMCj5/d/VJaH4CDk3Pi6KZ8+yBTf676xmyFSmbZ0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=M4QYVLtutG3Mmpkmx1IWwfT8GCi4U5JB3CwqdkHxglo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mSzeJZnU76hpLDS3TmAZmJrv4+5TVKxO4Isl6cjn0T3CDiwp+wZz+aXg2v+qx2mo9ZKeGNJt4Qcg1GoMlhw1P58/fkiWmKWeqHXDBpi/Avj28lx/h5YZ/SQ1G84ayEThYJtkZIt0NQyD+ky/K/2BECd7uCk0ZSh9Olg3n8SjTUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyvG5v/X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A51C4CEC3;
	Wed,  9 Oct 2024 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=M4QYVLtutG3Mmpkmx1IWwfT8GCi4U5JB3CwqdkHxglo=;
	h=From:To:Cc:Subject:Date:From;
	b=LyvG5v/XbDqDHTg+oO/3V7QNdjdLUOupqOtvjTaPidCE6+TKSgPSwq2OZamEe9GXI
	 jDmPFhFO4OGG7JLp4ZNF9mlPoPY96UtJ1KZLxqd+6tNnYL4uX4IUNlvtphSc9rpxnN
	 yZbmylvc+G8GLHJV23Llu6kWfPG/6+ymuHMiYYNU4yCfK1vBnNfxk7KBqGaeySIq94
	 njNC7YDzYTOYT8i0rE1jdoMs9FEdkvNQCMRDgNJycPKg2ItcQZSeoiABMAAPYZHQ74
	 vcMKpaS1oqBzBHxXY01K4emYuw0MqtFGHGg+YzPNNUYGndfp4c0X15beuNaRlSj40a
	 k2Di2YiDEP2uA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvM-001wcY-I9;
	Wed, 09 Oct 2024 20:00:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 00/36] KVM: arm64: Add EL2 support to FEAT_S1PIE/S1POE
Date: Wed,  9 Oct 2024 19:59:43 +0100
Message-Id: <20241009190019.3222687-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This series serves a few purposes:

- Complete the S1PIE/S1POE support to include EL2
- Sneak in the EL2 system register world switch

As mentioned in few of the patches, this implementation relies on a
very recent fix to the architecture (D22677 in [0]).

Patches on top of v6.12-rc1.

* From v3 [3]:

  - Added a few extra patches to deal with S1POE at EL2, including AT

  - Fix CPTR_EL2.E0POE non-sensical trap entry

  - Make sure that TVM and TRVM are handling the EL1 PIE/POE traps

  - Simplify some of the visibility cruft

  - Rebased on v6.12-rc1

* From v2 [2]:

  - Correctly reprogram the context for AT in the fast path when S1PIE
    is in use

  - Generalised sysreg RES0/RES1 masking, and added TCR2_EL2 RES0/RES1
    bit handling

  - Fix TCR2_EL1, PIR_EL1, PIRE0_EL1 access with VHE

  - Add a bunch of missing registers to get_el2_to_el1_mapping()

  - Correctly map {TCR2,PIR,PIRE0}_EL2 to their EL1 equivalent on NV

  - Disable hierarchical permissions when S1PIE is enabled

  - Make EL2 world switch directly act on the vcpu rather than an
    arbitrary context

  - Remove SKL{0,1} from the TCR2_EL2 description

* From the initial posting [1]:

- Rebased on top of the AT support branch, which is currently sitting
  in kvmarm/next

- Add handling for S1 indirect permission in AT, which I'm sure will
  give Alexandru another king-sized headache

- Picked Mark Brown's series dealing with TCRX and S1PIE
  visibility, and slapped an extra fix on top for good measure

- Picked up RBs from Joey, with thanks.

[0] https://developer.arm.com/documentation/102105/ka-04/
[1] https://lore.kernel.org/r/20240813144738.2048302-1-maz@kernel.org
[2] https://lore.kernel.org/r/20240903153834.1909472-1-maz@kernel.org
[3] https://lore.kernel.org/r/20240911135151.401193-1-maz@kernel.org

Marc Zyngier (33):
  arm64: Drop SKL0/SKL1 from TCR2_EL2
  arm64: Remove VNCR definition for PIRE0_EL2
  arm64: Add encoding for PIRE0_EL2
  KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
  KVM: arm64: nv: Add missing EL2->EL1 mappings in
    get_el2_to_el1_mapping()
  KVM: arm64: nv: Handle CNTHCTL_EL2 specially
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
  KVM: arm64: Extend masking facility to arbitrary registers
  arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
  KVM: arm64: Add TCR2_EL2 to the sysreg arrays
  KVM: arm64: Sanitise TCR2_EL2
  KVM: arm64: Add save/restore for TCR2_EL2
  KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
  KVM: arm64: Add save/restore for PIR{,E0}_EL2
  KVM: arm64: Handle PIR{,E0}_EL2 traps
  KVM: arm64: Sanitise ID_AA64MMFR3_EL1
  KVM: arm64: Add AT fast-path support for S1PIE
  KVM: arm64: Split S1 permission evaluation into direct and
    hierarchical parts
  KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
  KVM: arm64: Implement AT S1PIE support
  KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
  arm64: Add encoding for POR_EL2
  KVM: arm64: Add a composite EL2 visibility helper
  KVM: arm64: Drop bogus CPTR_EL2.E0POE trap routing
  KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
  KVM: arm64: Add basic support for POR_EL2
  KVM: arm64: Add save/retore support for POR_EL2
  KVM: arm64: Add POE save/restore for AT emulation fast-path
  KVM: arm64: Disable hierarchical permissions when POE is enabled
  KVM: arm64: Make PAN conditions part of the S1 walk context
  KVM: arm64: Handle stage-1 permission overlays
  KVM: arm64: Handle WXN attribute

Mark Brown (3):
  KVM: arm64: Define helper for EL2 registers with custom visibility
  KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
  KVM: arm64: Hide S1PIE registers from userspace when disabled for
    guests

 arch/arm64/include/asm/kvm_host.h          |  37 +-
 arch/arm64/include/asm/vncr_mapping.h      |   1 -
 arch/arm64/kvm/at.c                        | 470 ++++++++++++++++++---
 arch/arm64/kvm/emulate-nested.c            |  12 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   5 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 161 ++++++-
 arch/arm64/kvm/nested.c                    |  34 +-
 arch/arm64/kvm/sys_regs.c                  | 141 ++++++-
 arch/arm64/tools/sysreg                    |  12 +-
 include/kvm/arm_arch_timer.h               |   3 +
 11 files changed, 766 insertions(+), 112 deletions(-)

-- 
2.39.2


