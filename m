Return-Path: <kvm+bounces-38692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D06EA3DBA5
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 14:49:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F850173FBD
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 13:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DA71FAC54;
	Thu, 20 Feb 2025 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgxh1cra"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F135942;
	Thu, 20 Feb 2025 13:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059354; cv=none; b=ETQnPq/TPF3DSqgEGVyrkAlr65FY36RzZ9t7PEZc3khM7dz2Kyen/jpb+oesUXWNo8Dh6wCVrXP0HCxHjeKVIK0v2PJrKPYv07VJh3a1kVA/HhnK7Z/WpnbdCq0kNsoZ24JDXb8/kqjUelbbXMn0/FLuO24rc4gBMIteCv4zfa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059354; c=relaxed/simple;
	bh=N/EBcfocF2jAgM4+X74I03y0WoHjhT/GxBKRJNbjoSs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KD+BgXFSa+vYzRlSFXnk2GueOctq/VE9QyAeFGAZ3VFSzt71eGP+S25TRgLZsUp5gMu7s6IXdOwKtiLEMrVWiGQ5AY6fwKb59k3vpm6n88Ltm4hUD3h/7jVO6r4fYR0h4vxVNhCkVF2osgsLkb7dd88bEW/B3Px/sciUAgVYxeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgxh1cra; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E85C4CED1;
	Thu, 20 Feb 2025 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740059353;
	bh=N/EBcfocF2jAgM4+X74I03y0WoHjhT/GxBKRJNbjoSs=;
	h=From:To:Cc:Subject:Date:From;
	b=jgxh1cra+QS4uqhA65BA/gGRjhEHqQndwlTa3KAD89C3k8U24BlOlU8cQZU6aJeFR
	 1HQqN2xn8uXJsn3+RvryeQ7fdtqWzaCZ13y8eWl/RiwRPgWjU6ESSh6dzJWlWT85fP
	 WuzEZNAWimYZTHTixldeSYw3mOur8kiROa+904F5Qk5kR3PLEH6QtIi1GmMidGLDDm
	 oE+OP40Fxsx06zrJCCB0BYCaalaaCy4SMuj3r6Y9lP9c/S0kFxJwpXaP2VXrQek8Xs
	 SoOYygGYhEF27zezsTu9uLGq/49ZSZvlpjUTRqf5rQpqMdBaeQf6/Q+/tYJXjOlbYu
	 g2yGNZys6ZvJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tl6vP-006DXp-Hp;
	Thu, 20 Feb 2025 13:49:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: [PATCH v2 00/14] KVM: arm64: NV userspace ABI
Date: Thu, 20 Feb 2025 13:48:53 +0000
Message-Id: <20250220134907.554085-1-maz@kernel.org>
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

Since the previous incarnation of the ABI was proved to be subtly
wrong, I have reworked it to be more in line with the current way KVM
operates.

No more late NV-specific adjustment nor writable ID_AA64MMFR0_EL1.VH.
The NV configuration is now entirely selected from the vcpu flags.
I've preserved the KVM_ARM_VCPU_EL2 flag which enables NV with VHE,
and added KVM_ARM_VCPU_EL2_E2H0 which alters the NV behaviour to only
allow nVHE guests without recursive NV support.

This series is actually very little new code. The bulk of it is
converting the feature downgrade to be per-idreg, essentially going
back to the state before 44241f34fac96 ("KVM: arm64: nv: Use accessors
for modifying ID registers"), only slightly modernised. This then
becomes part of the reset value computing.

The rest is simply what you'd expect in terms of being able to write
the ID_AA64MMFR4_EL1.NV_frac field, making the correct bits RES0 when
needed, probing for capabilities and handling the init flags.

Patches on top of -rc3, with the integration branch at the usual
location.

* From v1 [1]

  - Fixed mishandling of ID_UNALLOCATED(), resulting in extra
    consolidation and simplify the macro maze a bit

  - Picked up Oliver's RBs (thanks!)

  - Rebased on top of -rc3

[1] https://lore.kernel.org/r/20250215173816.3767330-1-maz@kernel.org

Marc Zyngier (14):
  arm64: cpufeature: Handle NV_frac as a synonym of NV2
  KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
  KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
  KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac
    is 0
  KVM: arm64: Advertise NV2 in the boot messages
  KVM: arm64: Consolidate idreg callbacks
  KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
  KVM: arm64: Enforce NV limits on a per-idregs basis
  KVM: arm64: Move NV-specific capping to idreg sanitisation
  KVM: arm64: Allow userspace to limit NV support to nVHE
  KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
  KVM: arm64: Advertise FEAT_ECV when possible
  KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*
  KVM: arm64: Document NV caps and vcpu flags

 Documentation/virt/kvm/api.rst      |  14 +-
 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/arm64/include/asm/kvm_nested.h |   1 +
 arch/arm64/include/uapi/asm/kvm.h   |   1 +
 arch/arm64/kernel/cpufeature.c      |  15 +-
 arch/arm64/kvm/arm.c                |  11 +-
 arch/arm64/kvm/nested.c             | 285 +++++++++++++++-------------
 arch/arm64/kvm/sys_regs.c           |  44 ++---
 arch/arm64/kvm/sys_regs.h           |  10 +
 include/uapi/linux/kvm.h            |   2 +
 10 files changed, 217 insertions(+), 168 deletions(-)

-- 
2.39.2


