Return-Path: <kvm+bounces-29056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D0479A1DDC
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 11:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52E7F1C21C65
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 09:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9793D1D88CA;
	Thu, 17 Oct 2024 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFL2iYUw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E41D88B4;
	Thu, 17 Oct 2024 09:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729156216; cv=none; b=CZaH86k7vYr5Tzk1oMhdqTu7wesdFXIdUyM2D96Ck4sTQ1lI6VK2itfLSoEh7qfVMqAMcNR0366/dOm2moMpRDLOLOF+0FCbKWEDicohvDAuLCqbS5SPCUno7EYoBpYph3IL9czPquIfSCt41Zq5y5FKN8DmEl0Kl7pFYWP89i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729156216; c=relaxed/simple;
	bh=gStZKPspN8Fxoe/I4rGMFgtoAkrG2i+KdpQDR/2Cc94=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fouWsZ3H4KBmWrbAdmo727WW3Snhc5aE9JGazFjFNACq0s9+wLhEnMLbCLxSy4ZoShAuzxvopHdXenPBrMIy5vkbrwPnIxT07jaME/NGBpaSPoi3JCQb0xT8SCGYxK3/Mp2h0ODboz8hg3cCa1WCIyDxUxKg5fSxcIxRPN72vF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFL2iYUw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3379EC4CEC3;
	Thu, 17 Oct 2024 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729156216;
	bh=gStZKPspN8Fxoe/I4rGMFgtoAkrG2i+KdpQDR/2Cc94=;
	h=From:To:Cc:Subject:Date:From;
	b=jFL2iYUw8wTAe8KGzTbJNvjVT9muBruubr2l0pvkK3IQbhlz4kXwFL9lqp9wbsTtX
	 /5Yim3fYLHp8HTV5gGF2I4303DMO7Q+yJqxPKhVEbdQmn55qA2LnBoPY5Gp/UFBifQ
	 NBaP8bktTbFUelSSAuFo3qJ06nwpwEgn3QaxiA1qygLMqs8tml8xODmc/DUarzs/tg
	 cdbPplIH4sglD5GvuM0U4GsHAA+BDlscqdFkptG495cRHGU9uFnUbcFVRL4iXtsjs4
	 TV174P3QfYE4fU+S8KNZyhtEDKG0TkpXYpioUPlkJ/LjP5odkvzFlJAIkik0uD0Evn
	 MRp3tDXGltYzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t1MWM-004O9M-4g;
	Thu, 17 Oct 2024 10:10:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Ilkka Koskinen <ilkka@os.amperecomputing.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.12, take #3
Date: Thu, 17 Oct 2024 10:09:56 +0100
Message-Id: <20241017090956.954040-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, anshuman.khandual@arm.com, gshan@redhat.com, ilkka@os.amperecomputing.com, nathan@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's another set of fixes for KVM/arm64, addressing another vgic
init race as well as a build error (full details in the tag below).

I notice that you haven't pulled [1] yet, so hopefully this will also
serve as a gentle reminder.

Please pull,

	M.

[1] https://lore.kernel.org/r/20241011132756.3793137-1-maz@kernel.org

The following changes since commit df5fd75ee305cb5927e0b1a0b46cc988ad8db2b1:

  KVM: arm64: Don't eagerly teardown the vgic on init error (2024-10-11 13:40:25 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.12-3

for you to fetch changes up to 78a00555550042ed77b33ace7423aced228b3b4e:

  KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration (2024-10-17 09:20:48 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.12, take #3

- Stop wasting space in the HYP idmap, as we are dangerously close
  to the 4kB limit, and this has already exploded in -next

- Fix another race in vgic_init()

- Fix a UBSAN error when faking the cache topology with MTE
  enabled

----------------------------------------------------------------
Ilkka Koskinen (1):
      KVM: arm64: Fix shift-out-of-bounds bug

Marc Zyngier (1):
      KVM: arm64: Shave a few bytes from the EL2 idmap code

Oliver Upton (2):
      KVM: arm64: vgic: Don't check for vgic_ready() when setting NR_IRQS
      KVM: arm64: Ensure vgic_ready() is ordered against MMIO registration

 arch/arm64/include/asm/kvm_asm.h      |  1 +
 arch/arm64/kernel/asm-offsets.c       |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S    | 52 +++++++++++++++++++----------------
 arch/arm64/kvm/sys_regs.c             |  2 +-
 arch/arm64/kvm/vgic/vgic-init.c       | 13 +++++++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  7 ++++-
 6 files changed, 49 insertions(+), 27 deletions(-)

