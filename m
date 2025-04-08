Return-Path: <kvm+bounces-42902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D94CCA7FD22
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC34416A55E
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D538426E17F;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbAIpUR4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25172686A8;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109560; cv=none; b=KoDIIsMVY9HY8IlFk7WhL8vE0rnJbAFxKdvBT5eljunRzAzZUe05mECTCnpJZK7294E23/O/GVOvPxxWUaxfPuwRZHs6tE+9azh4vG8AsDQheuOpUrtqwHZwEjoIq5Aor+Rg/GU5C1pXk+TY88BqH+vObb8CqOP0w+hUBIyt350=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109560; c=relaxed/simple;
	bh=eXvgI10mmaf2ewAwZAKZgJKFqhyv5yx9FJwjuwqxvPg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E7xo1KlU7AWyKzqraweAQgN7WGs28u9SOSdK29t3CpJ8/dtdWt5V9OGawbuIKi8gFKw2rRx22Wq3U+WiUFVHKgOj97mJu48rInE67nplmHdlUEnHOHoM5aFQubsguCh95amUUgE7UgGAKUOFYfXora4HhvxK6Z0LJSvo6DVmAYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbAIpUR4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805B7C4CEEA;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109559;
	bh=eXvgI10mmaf2ewAwZAKZgJKFqhyv5yx9FJwjuwqxvPg=;
	h=From:To:Cc:Subject:Date:From;
	b=WbAIpUR461uXt15y6Vqak43pYY0clt6qZLJEOR4etB4z2i2NhRS0iUhLso+uZjVTa
	 Xr7jBHxFyIZOm4p9h6QCPBebxRNOZfQa2+5e87UuxEQt6puIjNlZ0yuZVR5SGi/Qt1
	 3lNOznMk9n76riyAuzmKBthSlP6XmMI2wHTmmAv8n9deC5rFCuRhCV5j7gMkF5hxQl
	 +8YySSI1fAOPw6PPXWjIfffCX+iiauueRrGPuuNYA9yVsRLSuk7CYzP6Bvj4sKKMpV
	 bv/KAD7i/sCPZY7L6P+hLsJ2wS8GFqegwt93Sf9GbqWA4IxgDRMHm5wFU5c7eN5fEF
	 MrV1YNTnyEkvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZI-003QX2-UY;
	Tue, 08 Apr 2025 11:52:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 00/17] KVM: arm64: Recursive NV support
Date: Tue,  8 Apr 2025 11:52:08 +0100
Message-Id: <20250408105225.4002637-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

KVM: arm64: Recursive NV support

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

Patches on top of v6.15-rc1. The full integration is, as always, in my
kvm-arm64/nv-next branch.

* From v1:

  - Rebased on 6.15-rc1

  - Picked up the last two patches to enable the full NV shebang

[1] https://lore.kernel.org/r/20250215150134.3765791-10-maz@kernel.org

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
 arch/arm64/kvm/nested.c             | 608 +++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c              |   2 +
 arch/arm64/kvm/sys_regs.c           | 135 +++---
 arch/arm64/tools/sysreg             |   6 +
 include/uapi/linux/kvm.h            |   2 +
 16 files changed, 940 insertions(+), 138 deletions(-)

-- 
2.39.2


