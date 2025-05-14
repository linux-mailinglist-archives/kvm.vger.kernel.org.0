Return-Path: <kvm+bounces-46473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 230A4AB68DF
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F3D4463EC6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC95270ED1;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJvI1Z+h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF936200B99;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218906; cv=none; b=r7U8yu1fjCOyo01oUHj1p4dmHEUN4dH8VyurpzPl/lcClW3TgQq6q0nVSU8QhoTjE1SZ7B/x7WL2JrRzdLhee8s8jOyHswOuI/YrenCnVGd8McmJAjRHBTX5zTbfeB7HJxzKsy5VWXRtfmdR9pDYSiwN+mFk5XFqIo6UxjQ2ISI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218906; c=relaxed/simple;
	bh=E358mMfAnCsPzCuNa5BrQ0CoZMIt4W4gmPNK4Mp1xy8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fOkyPtc3f74x4/IJwMsx0FWXSm87ldii475C+Ek5VeuFLxv6JgZMOMsohuE19pNHkae5tVtwmloCbuZFt3k9Tm69oCvhT/q1I4B91tDieIZD9aWMCrFuYIVPU1lffkUedDZ9nex0WKrIIxrXqpaq0Zg+tiGiKaQJaJQ+fwA9Z4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJvI1Z+h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4878CC4CEEB;
	Wed, 14 May 2025 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218906;
	bh=E358mMfAnCsPzCuNa5BrQ0CoZMIt4W4gmPNK4Mp1xy8=;
	h=From:To:Cc:Subject:Date:From;
	b=fJvI1Z+hQ2i8N0+6JnDFvtWLvlpPGpJK0IrG3Wuh0HVgDMcE4YCGrQqTa94QAV4uB
	 zYxteqoyO1zq587ItSd6DyDWexxAdRio11rnRIsWlRaxaDM9fiLWsquDBgJJpKLXmo
	 bZjezCnkEjaPsbWpVRuXoerOVwMi2cpVWaFcUPZlIEvWy4hpKdbuCWBgAEzW3BuXZW
	 o58WNW34nWLVSNeVw79e9FOV+KkwBmwrWn+lYndsY7VvDYB0lTxotLcZNVTZcqczHE
	 jApV+3fPHHPIstdgXxdwl6Z9j57kNSBWVj4NWToMRTjtLxf5w0WHb4v0syXAUCGKPc
	 wvdmovhlIjC+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S3-00Eos3-Vt;
	Wed, 14 May 2025 11:35:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 00/17] KVM: arm64: Recursive NV support
Date: Wed, 14 May 2025 11:34:43 +0100
Message-Id: <20250514103501.2225951-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This is probably the most interesting bit of the whole NV adventure.
So far, everything else has been a walk in the park, but this one is
where the real fun takes place.

With FEAT_NV2, most of the NV support revolves around tricking a guest
into accessing memory while it tries to access system registers. The
hypervisor's job is to handle the context switch of the actual
registers with the state in memory as needed.

This memory (which we shall call the VNCR page henceforth) lives at an
EL2 VA, and is therefore accessed out of context by the EL1 guest
hypervisor.

So far, so good. But what does it mean to virtualise VNCR itself?

It means that when L1 has a prepared a VNCR page for L2, we must map
it in the L0 EL2, and allow L2 to magically access it. Isn't that fun?
To some extent. But there's more!

Having that L0 mapping on behalf of L1 comes with strings attached. It
means that we must be prepared for this page to become inaccessible,
which can happen for a variety of reasons:

- paged out from the host (MMU notifiers)

- unmapped from L1 EL2 stage-1

- permission changes in L1 EL2 stage-1

And in case you're wondering, yes, all of these have TLB invalidation
in common. That's because performing this mapping is akin to
allocating a "SW managed" TLB for L1's VNCR page.

This is what the bulk of this series is about: TLB management for VNCR
pages, and making sure we have the correct page at the right time.

From an implementation perspective, it isn't that complicated, as it
plugs into the existing NV artillery (TLBI, AT, MMU notifiers). Of
course, nothing is optimised, because we're not at this stage yet. I
have plans to make this better (i.e. fewer TLBIs, which implies fewer
traps when nesting), but that's all future work.

But this is functional enough that I can run an L4 guest on my QC
box. Slowly.

As an added bonus, this series now includes the last two patches that
switch the damned thing on. Does it mean this is bug-free? Of course
not. But we're at a point where NV is no longer a third-rate citizen.
Only a second-rate one.

Patches on top of my kvm-arm64/at-fixes-6.16 branch posted at [4],
itself based on 6.15-rc3. The full integration is, as always, in my
kvm-arm64/nv-next branch.

* From v3 [3]:

  - Added GFP_KERNEL_ACCOUNT on VNCR page allocation

* From v2 [2]:

  - Handle access fault on translating the guest S1 to populate the
    VNCR TLB

  - Added RBs by Ganapatrao on a couple of patches

* From v1 [1]:

  - Rebased on 6.15-rc1

  - Picked up the last two patches to enable the full NV shebang

[1] https://lore.kernel.org/r/20250215150134.3765791-1-maz@kernel.org
[2] https://lore.kernel.org/r/20250408105225.4002637-1-maz@kernel.org
[3] https://lore.kernel.org/r/20250423151508.2961768-1-maz@kernel.org
[4] https://lore.kernel.org/r/20250422122612.2675672-1-maz@kernel.org

Marc Zyngier (17):
  arm64: sysreg: Add layout for VNCR_EL2
  KVM: arm64: nv: Allocate VNCR page when required
  KVM: arm64: nv: Extract translation helper from the AT code
  KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
  KVM: arm64: nv: Move TLBI range decoding to a helper
  KVM: arm64: nv: Don't adjust PSTATE.M when L2 is nesting
  KVM: arm64: nv: Add pseudo-TLB backing VNCR_EL2
  KVM: arm64: nv: Add userspace and guest handling of VNCR_EL2
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults
  KVM: arm64: nv: Handle mapping of VNCR_EL2 at EL2
  KVM: arm64: nv: Handle VNCR_EL2 invalidation from MMU notifiers
  KVM: arm64: nv: Program host's VNCR_EL2 to the fixmap address
  KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2
  KVM: arm64: nv: Plumb TLBI S1E2 into system instruction dispatch
  KVM: arm64: nv: Remove dead code from ERET handling
  KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
  KVM: arm64: Document NV caps and vcpu flags

 Documentation/virt/kvm/api.rst      |  14 +-
 arch/arm64/include/asm/esr.h        |   2 +
 arch/arm64/include/asm/fixmap.h     |   6 +
 arch/arm64/include/asm/kvm_host.h   |  15 +-
 arch/arm64/include/asm/kvm_nested.h | 100 +++++
 arch/arm64/include/asm/sysreg.h     |   1 -
 arch/arm64/kvm/arm.c                |  10 +
 arch/arm64/kvm/at.c                 | 123 +++---
 arch/arm64/kvm/emulate-nested.c     |   7 -
 arch/arm64/kvm/handle_exit.c        |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c     |  46 ++-
 arch/arm64/kvm/nested.c             | 610 +++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c              |   2 +
 arch/arm64/kvm/sys_regs.c           | 135 +++---
 arch/arm64/tools/sysreg             |   6 +
 include/uapi/linux/kvm.h            |   2 +
 16 files changed, 942 insertions(+), 138 deletions(-)

-- 
2.39.2


