Return-Path: <kvm+bounces-14009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6337A89E1E5
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90F601C21A48
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FA515699A;
	Tue,  9 Apr 2024 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1JU6vVC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A27156862;
	Tue,  9 Apr 2024 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685322; cv=none; b=FHwQE0Y/mAV2UYRmCgCxsuSKYtqE10FEkolDDwXcVmWR0o5gN4kBKMmRyKfkjt38wAXSHFz2MofL1KD+qADtaEyJ2D3t0lKXQKjI00NSFR0hYGJ0TElVgoCg5ef+MBoNFdbZieUpsZJ8R4RFS/pEV7QPRFk9J4wWLhhIqtDOYik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685322; c=relaxed/simple;
	bh=HiPI0zICqTXskNQRPdZZg9jSvoMGVkNmobN4r2vLjJw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XEex++lF9gu/YP8T/hH3tM8SDdFCPOKGB1aiAMaZdD2Agnb3N7fpx73LjCcXdGpcDkxbK5aeMMswxtxHNn3bhk0GK2QdjB6EpFMdA8VgVAoULsQ2VBNS4ZY4fYf4MJ1DtI0/goXBP/77K1o2oJDrpfuz5D5MIY5EJG6RjRkd+Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1JU6vVC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5364C433C7;
	Tue,  9 Apr 2024 17:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685321;
	bh=HiPI0zICqTXskNQRPdZZg9jSvoMGVkNmobN4r2vLjJw=;
	h=From:To:Cc:Subject:Date:From;
	b=i1JU6vVCXTHZJxhU6f7rwfipguTAL21syy3MQ4uE3nxO4/AEp4TCgsoUPu//WCaBP
	 UIl3cDqJ2bQtxG3U1cjh9Y9urK9h0UcTaWiMR0uxlzRcA3W/+yCY0Ks9jssgAJxhPO
	 Ty63HVnABzUIgUykkgVsJV7+1Ayc0msfekwRfaq78kBfG7evSrMnulk1O/ixb26B6q
	 tfGeqCFNVEm45XNcCDbmBm1aoWN8zau6vzSkDZJYVkKOEUZe0a77knQFcd2PnR0asB
	 pfn2HgdtoB41QLNjgz/nL6sOhYArqr4LK8Vy88b763ev3gONGHEdn7/LKjFLN9nkBS
	 yKCZbs5lv6roA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgl-002szC-LF;
	Tue, 09 Apr 2024 18:55:19 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 00/16] KVM: arm64: nv: Shadow stage-2 page table handling
Date: Tue,  9 Apr 2024 18:54:32 +0100
Message-Id: <20240409175448.3507472-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's another instalment of everyone's favourite "arm64 nested virt,
one headache at a time". This time, we deal with the shadowing of the
guest's S2 page tables.

So here's the 10000m (approximately 30000ft for those of you stuck
with the wrong units) view of what this is doing:

- for each {VMID,VTTBR,VTCR} tuple the guest uses, we use a separate
  shadow s2_mmu context. This context has its own "real" VMID and a
  set of page tables that are the combination of the guest's S2 and
  the host S2, built dynamically one fault at a time.

- these shadow S2 contexts are ephemeral, and behave exactly as
  TLBs. For all intent and purposes, they *are* TLBs, and we discard
  them pretty often.

- TLB invalidation takes three possible paths:

  * either this is an EL2 S1 invalidation, and we directly emulate it
    as early as possible

  * or this is an EL1 S1 invalidation, and we need to apply it to the
    shadow S2s (plural!) that match the VMID set by the L1 guest

  * or finally, this is affecting S2, and we need to teardown the
    corresponding part of the shadow S2s, which invalidates the TLBs

From a quality of implementation, this series does the absolute
minimum. In a lot of cases, we blow away all the shadow S2s without
any discrimination. That's because we don't have a reverse mapping
yet, so if something gets unmapped from the canonical S2 through a MMU
notifier, things slow down significantly. At this stage, nobody should
care.

We also make some implementation choices:

- no overhead for non-NV guests -- this is our #1 requirement

- all the TLBIs are implemented as Inner-Shareable, no matter what the
  guest says

- we don't try to optimise for leaf invalidation at S2

- we use a TTL-like mechanism to limit the over-invalidation when no
  TTL is provided, but this is only a best effort process

- range invalidation is supported

- NXS operations are supported as well, and implemented as XS. Nobody
  cares about them anyway

Note that some of the patches used to carry review tags, but the
series has had so many changes that they are not making sense anymore.
This is based on 6.9-rc3, and has been tested on my usual M2 with the
rest of the NV series.

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
 arch/arm64/include/asm/kvm_host.h    |  41 ++
 arch/arm64/include/asm/kvm_mmu.h     |  12 +
 arch/arm64/include/asm/kvm_nested.h  | 127 +++++
 arch/arm64/include/asm/sysreg.h      |  17 +
 arch/arm64/kvm/arm.c                 |  11 +
 arch/arm64/kvm/hyp/vhe/switch.c      |  51 +-
 arch/arm64/kvm/hyp/vhe/tlb.c         | 147 +++++
 arch/arm64/kvm/mmu.c                 | 219 ++++++--
 arch/arm64/kvm/nested.c              | 767 ++++++++++++++++++++++++++-
 arch/arm64/kvm/reset.c               |   6 +
 arch/arm64/kvm/sys_regs.c            | 398 ++++++++++++++
 14 files changed, 1759 insertions(+), 41 deletions(-)

-- 
2.39.2


