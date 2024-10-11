Return-Path: <kvm+bounces-28630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A6B99A4FF
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 15:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2813E1F226C4
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC016218D6D;
	Fri, 11 Oct 2024 13:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMYFhmhE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB77321644E;
	Fri, 11 Oct 2024 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728653313; cv=none; b=ldsu7SGPrMn5B7rZeLx7TamZQlTX+W/dF3v7xNfLqr10Dc4kj0gHEdGbe1eY94MXtq+vJ0zYpP7L3/0eZErRq9apt4Ki+iNlZp9e6JQNYR8irbsK5yLKYSWsBbImUYUwEBAXE2ivbnxVNr1el5YrsXV3Kw6hZNL0yEheO+ZcH64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728653313; c=relaxed/simple;
	bh=XnQ3OWZmFFbbEbN0nuRCP99ploKH8REo3FMrNxhzftk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KUq4cTCI+lRje5JkMzIjF0rSCaNACHZ/rwHQ4D97BtKAOgK8klccr+y4FTekRR/vmGC0ue79hh+dl+3GH2f/gyQcqmMs6o9B+6RgpoQIBHqRAInJw5Rz9A5VvG4OD5syb7Asdv9hFAH2a4zbeY+5Q44ux6sXlHlJp+SymOFURWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMYFhmhE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52242C4CEC3;
	Fri, 11 Oct 2024 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728653313;
	bh=XnQ3OWZmFFbbEbN0nuRCP99ploKH8REo3FMrNxhzftk=;
	h=From:To:Cc:Subject:Date:From;
	b=HMYFhmhESzKOcwvBG48mNXHKBp3jSeryZBYdzFM5birAyAQdVuaZ7nqkACztUEiV6
	 7Q40Zqq85bhWldnpkCKsllSU97Vumzk4iL9+uY3ek0lKO29SGdrzHaZlxw7eHaQ/5G
	 2EowimbnmHdyOonqP6U6m160fXtirsrh1JwXBT9C1IZQLe+ftG6N6272/YbsKvoRuG
	 HnyEQfXn6eSTBrtUE1g9nvegSUktEjq9fEocRrp1HQSByM8rGjDx/B0Lce4VOdmMeH
	 gTtOf4NhbO6/Xv7j0CYPPdSEuui2XONFFyUSwroCiWL5T5F5XS+IEOJOvOxRyF+XeH
	 m4IQTxxrYlkow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1szFh1-002Z8g-Dg;
	Fri, 11 Oct 2024 14:28:31 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.12, take #2
Date: Fri, 11 Oct 2024 14:27:56 +0100
Message-Id: <20241011132756.3793137-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, glider@google.com, joey.gouly@arm.com, broonie@kernel.org, oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, shahuang@redhat.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's the second set of fixes for 6.12.

We have a handful of fixes for the ID register configuration (I had
originally queued them for -rc1, and somehow managed to accidentally
drop the branch on the floor), our NV shadow page tables, the vgic,
and a fix for a regression introduced in -rc1.

As usual, details in the tag.

Please pull,

	M.

The following changes since commit a1d402abf8e3ff1d821e88993fc5331784fac0da:

  KVM: arm64: Fix kvm_has_feat*() handling of negative features (2024-10-03 19:35:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.12-2

for you to fetch changes up to df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1:

  KVM: arm64: Don't eagerly teardown the vgic on init error (2024-10-11 13:40:25 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.12, take #2

- Fix the guest view of the ID registers, making the relevant fields
  writable from userspace (affecting ID_AA64DFR0_EL1 and ID_AA64PFR1_EL1)

- Correcly expose S1PIE to guests, fixing a regression introduced
  in 6.12-rc1 with the S1POE support

- Fix the recycling of stage-2 shadow MMUs by tracking the context
  (are we allowed to block or not) as well as the recycling state

- Address a couple of issues with the vgic when userspace misconfigures
  the emulation, resulting in various splats. Headaches courtesy
  of our Syzkaller friends

----------------------------------------------------------------
Marc Zyngier (2):
      Merge branch kvm-arm64/idregs-6.12 into kvmarm/fixes
      KVM: arm64: Don't eagerly teardown the vgic on init error

Mark Brown (1):
      KVM: arm64: Expose S1PIE to guests

Oliver Upton (5):
      KVM: arm64: Unregister redistributor for failed vCPU creation
      KVM: arm64: nv: Keep reference on stage-2 MMU when scheduled out
      KVM: arm64: nv: Do not block when unmapping stage-2 if disallowed
      KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
      KVM: arm64: nv: Clarify safety of allowing TLBI unmaps to reschedule

Shameer Kolothum (1):
      KVM: arm64: Make the exposed feature bits in AA64DFR0_EL1 writable from userspace

Shaoqin Huang (4):
      KVM: arm64: Disable fields that KVM doesn't know how to handle in ID_AA64PFR1_EL1
      KVM: arm64: Use kvm_has_feat() to check if FEAT_SSBS is advertised to the guest
      KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
      KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1

 arch/arm64/include/asm/kvm_host.h                 |  7 +++
 arch/arm64/include/asm/kvm_mmu.h                  |  3 +-
 arch/arm64/include/asm/kvm_nested.h               |  4 +-
 arch/arm64/kvm/arm.c                              |  5 ++
 arch/arm64/kvm/hypercalls.c                       | 12 ++--
 arch/arm64/kvm/mmu.c                              | 15 ++---
 arch/arm64/kvm/nested.c                           | 53 +++++++++++++---
 arch/arm64/kvm/sys_regs.c                         | 75 +++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic-init.c                   | 28 +++++++--
 tools/testing/selftests/kvm/aarch64/set_id_regs.c | 16 ++++-
 10 files changed, 183 insertions(+), 35 deletions(-)

