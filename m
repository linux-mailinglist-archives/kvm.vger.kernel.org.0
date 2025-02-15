Return-Path: <kvm+bounces-38283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F7AA36EEE
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7845C18946ED
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56621E5B73;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RkPXFrhE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3631AAE1E;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=hjgQV/6imPgEe/1AezIRda08NlnT1SdjQPH1AQealkCHLqL7AteCFpqmPNFuPZSsp1hp6ttBoVrpXvZPHhHBie2hbImAsxoXym2sel6cQ4ky4pzpudoHjZj+9GrUXz1XXf6wpk4R/7AH0x4vuEGi7EuP0L3rb+9hkoP2d1TlBJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=ztYsTcmEp65UD5hR3GQ0KqCG/eVGKXg7wIbh2cUt5FA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IZngH4T2W3yMQoWQcAo/bP2n+DYnp/mJDUmh2ZiixbJT27+bGyXsu471SL90TYCVfBHGQpNhaHJ3h1ONM76oGK0UVT8YfsVPv8xLoAv+mhF/h2GHkT5om2+kmZfHPDJBssPzEzcdwivVJi41W/yhLkB1kEuJNL3UqBI/9vqSRa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RkPXFrhE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746EBC4CEDF;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631722;
	bh=ztYsTcmEp65UD5hR3GQ0KqCG/eVGKXg7wIbh2cUt5FA=;
	h=From:To:Cc:Subject:Date:From;
	b=RkPXFrhECFqLjv3nIdr5MupxnYwBX++dQ6yGvj2bQXoodVHrwUrl9W7bNubgKelEx
	 yzp6sMf4rdPthZMOc3+flf5sa6Wwu2eqYfT0dL7G27hr/4n0BhribMUb49rcIURuis
	 8ddaql3Ykqdc3V4vjmlUIJqzNXC4Iwm+DG9JZf3VU4lTqf4C7mF0UdbUUaUCezXI+u
	 kjvGZLvigbcinpjGJlTDCbUmayDYE9jD+T2ZT6aTHid4e+TQEHcK21nlszJGJIsM9E
	 EoaU+a8mPnOX7RtWfIax9XAfRM0OrDHrT8pWaniwyqB/FQ3mSiuCUkj0CGj9DGILLO
	 TDU+5Dvfn98KQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg8-004Nz6-3b;
	Sat, 15 Feb 2025 15:02:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 00/14] KVM: arm64: Recursive NV support
Date: Sat, 15 Feb 2025 15:01:20 +0000
Message-Id: <20250215150134.3765791-1-maz@kernel.org>
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

This is probably the most interesting bit of the whole NV adventure.
So far, everything else has been a walk in the park, but this one is
where the real fun takes place.

With FEAT_NV2, most of the NV support revolves around tricking a guest
into accessing memory while it tries to access system registers. The
hypervisor's job is to handle the context switch of the actual
registers with the state in memory as needed.

This memory (which we call the VNCR page) lives at an EL2 VA, and is
therefore accessed out of context by the EL1 guest hypervisor.

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
traps when nesting), but that's future work.

But this is functional enough that I can run an L4 guest on my QC
box. Slowly.

Patches on top of -rc2. The full integration is, as always, in my
kvm-arm64/nv-next branch.

Marc Zyngier (14):
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

 arch/arm64/include/asm/esr.h        |   2 +
 arch/arm64/include/asm/fixmap.h     |   6 +
 arch/arm64/include/asm/kvm_host.h   |  13 +
 arch/arm64/include/asm/kvm_nested.h | 100 +++++
 arch/arm64/include/asm/sysreg.h     |   1 -
 arch/arm64/kvm/arm.c                |   6 +
 arch/arm64/kvm/at.c                 | 123 +++---
 arch/arm64/kvm/handle_exit.c        |   1 +
 arch/arm64/kvm/hyp/vhe/switch.c     |  47 ++-
 arch/arm64/kvm/nested.c             | 608 +++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c              |   2 +
 arch/arm64/kvm/sys_regs.c           | 135 +++---
 arch/arm64/tools/sysreg             |   6 +
 13 files changed, 921 insertions(+), 129 deletions(-)

-- 
2.39.2


