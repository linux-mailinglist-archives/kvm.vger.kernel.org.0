Return-Path: <kvm+bounces-40620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EC4A59436
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2622168A88
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A635227B9A;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVvLaxpp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A8422423E;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609512; cv=none; b=RzX3sqzgBfQAM/jl8kk9Ui/GURkV8Q1KeGPZFf59LiXQdh8I5s5Dhszwswr1tYUMJwQHYhFOS32HRpCyHxpClS9yFWNUoEFgMExWTi2s8yOj6Q4yB4bOtVCQYPec7SbpLGKhFv6vRN5Vw24Ylm+v0x7Sr+se29IJGz0iE8OaXHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609512; c=relaxed/simple;
	bh=pBDyZMeTYijWWERE2PGpvZldblWOM4srKyJV30gv0OY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fsr4zss7u4rIVVh49xkikEy8p4ikowu3BDDx4fZ+22N+nYTLmdPqaUuYBphWDL5kx9MyeTy7UImZYPvMlMX8PuiElIfZPbyQNooh4VCdhUB68rV9u9wjMm9bVuCKqVbqjq4M1S3tVYf1JX4NwM99+UcwgxQg90xJr1nHFxV/3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVvLaxpp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FAFC4CEE5;
	Mon, 10 Mar 2025 12:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609511;
	bh=pBDyZMeTYijWWERE2PGpvZldblWOM4srKyJV30gv0OY=;
	h=From:To:Cc:Subject:Date:From;
	b=ZVvLaxppvCxa/8rfaWcmv/5ayzUsAGWHXuLIqzHvH5mubuheQVaYCOMxPF1e2FfBR
	 k0X0HRNESynHlt5C6ngTLXeQTeDfkM6A22HhLrx85VWEbast3nhUlSUYGLp6jYSgQT
	 5bnHTEJ7ACs+0OA+DFn8C+FXknZXFiiK6qoLCdvcbkPLhpZPIR76c2KYmTH4p0t3jM
	 xnleBOrVGAZcuh+ioSDK8mRfcK7e5moLf48TkTQQpNCuhJZygDVO+MyRCNIdZcRpuo
	 ngDL2iPNAuLwozFiJ4W8M52qnJ7oZrjC12kupJLOspz3JYuMXlAfcxFk86qLFLjj61
	 dUkDLe0RL3hcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBw-00CAea-Bu;
	Mon, 10 Mar 2025 12:25:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 00/23] KVM: arm64: Revamp Fine Grained Trap handling
Date: Mon, 10 Mar 2025 12:24:42 +0000
Message-Id: <20250310122505.2857610-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Mark recently mentioned that the way we handled FGTs, and particularly
their RES0 behaviour was not entirely future-proof.

The main issue is that RES0 bits are extracted from the sysreg file,
which is independently updated, and that the KVM-specific enablement
is not necessarily done at the same time. This means that a bit that
KVM considered RES0 at some point all of a sudden acquires a meaning,
and that this can trigger unexpected behaviours.

One way of fixing that would be to mandate that everything gets
updated synchronously. While this is something I'd really want to see,
it is unlikely to happen within my lifetime.

So the next best option is to reintroduce KVM's own view of RES0
masks, so that it can continue to ignore a given feature in a safe
manner. But instead of going back to what we have a while back in the
form of hand-crafted masks that are likely to be wrong, this series
makes use of the rather exhaustive description of traps that we know
about, and then some more:

- compile the encoding_to_fgt[] array into individual positive,
  negative, and res0 masks

- use these masks in place of anything that is hardcoded

- fix a few bugs along the way (thanks Mark!)

- perform some validation and let users know that KVM may be missing
  some FGT bit definitions

But it would be foolish to stop here. We also use FGTs to implement
the so called "Fine Grained UNDEF" (FGU) bits, and make sure that
system registers that are not exposed to a guest do UNDEF. This means
evaluating the guest configuration and setting up these FGU bits when
said configuration isn't supported.

This series therefore goes one step further and, for the HFG*TR_EL2,
HDFG*TR_EL2, and HAFGRTR_EL2 registers, define which bit is controlled
by which feature. This is done mechanically, with very minimal human
intervention, by extracting the relevant data from the ARM-released
JSON files.

Oh, and one more thing: we now do the same for HCRX_EL2 and HCR_EL2.
Isn't that great?

With that data, we greatly simplify the dependency between FGUs and
features, as no code needs to be written. We also use the same data to
set the RES0 bits for any register that requires sanitisation (the
VNCR-backed registers, for example).

Overall, and while this is a lot of new LoCs, it is IMO a reduction in
complexity and maintenance burden.

This series is atop of 6.14-rc4, and contains bits and pieces of
FEAT_LS64 support thanks to the newly added HFGITR_EL2.PSBCSYNC bit
sharing an EC with LS64.

* From v1 [1]:

  - Renamed the LS64 EC to OTHER (Mark)

  - Simplified the handling of the OTHER EC by folding the relevant
    checks (Fuad)

  - Added HCRX_EL2 and HCR_EL2 conversion to the config scheme, the
    latter requiring some extra infrastructure

  - Rebased on v6.14-rc4

[1] https://lore.kernel.org/r/20250210184150.2145093-1-maz@kernel.org

Marc Zyngier (22):
  arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
  arm64: sysreg: Update ID_AA64MMFR4_EL1 description
  arm64: sysreg: Add layout for HCR_EL2
  arm64: Add syndrome information for trapped LD64B/ST64B{,V,V0}
  KVM: arm64: Handle trapping of FEAT_LS64* instructions
  KVM: arm64: Restrict ACCDATA_EL1 undef to FEAT_ST64_ACCDATA being
    disabled
  KVM: arm64: Don't treat HCRX_EL2 as a FGT register
  KVM: arm64: Plug FEAT_GCS handling
  KVM: arm64: Compute FGT masks from KVM's own FGT tables
  KVM: arm64: Add description of FGT bits leading to EC!=0x18
  KVM: arm64: Use computed masks as sanitisers for FGT registers
  KVM: arm64: Propagate FGT masks to the nVHE hypervisor
  KVM: arm64: Use computed FGT masks to setup FGT registers
  KVM: arm64: Remove most hand-crafted masks for FGT registers
  KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
  KVM: arm64: Handle PSB CSYNC traps
  KVM: arm64: Switch to table-driven FGU configuration
  KVM: arm64: Validate FGT register descriptions against RES0 masks
  KVM: arm64: Use FGT feature maps to drive RES0 bits
  KVM: arm64: Allow kvm_has_feat() to take variable arguments
  KVM: arm64: Use HCRX_EL2 feature map to drive fixed-value bits
  KVM: arm64: Use HCR_EL2 feature map to drive fixed-value bits

Mark Rutland (1):
  KVM: arm64: Unconditionally configure fine-grain traps

 arch/arm64/include/asm/esr.h            |   9 +-
 arch/arm64/include/asm/kvm_arm.h        | 189 +++--
 arch/arm64/include/asm/kvm_host.h       |  33 +-
 arch/arm64/kvm/Makefile                 |   2 +-
 arch/arm64/kvm/arm.c                    |   8 +
 arch/arm64/kvm/config.c                 | 891 ++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c         | 140 +++-
 arch/arm64/kvm/handle_exit.c            |  72 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 110 +--
 arch/arm64/kvm/hyp/nvhe/switch.c        |   7 +
 arch/arm64/kvm/nested.c                 | 204 +-----
 arch/arm64/kvm/sys_regs.c               |  65 +-
 arch/arm64/tools/sysreg                 |  90 ++-
 13 files changed, 1394 insertions(+), 426 deletions(-)
 create mode 100644 arch/arm64/kvm/config.c

-- 
2.39.2


