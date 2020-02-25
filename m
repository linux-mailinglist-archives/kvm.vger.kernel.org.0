Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F38B16F3DA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBYXwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 18:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgBYXwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 18:52:43 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2A972176D;
        Tue, 25 Feb 2020 23:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582674762;
        bh=JAt+10w4pTyb4WokWSXrkj9e3fSa/lhHsi0hfJmHzm4=;
        h=From:To:Cc:Subject:Date:From;
        b=NjnL35vslyxSCJUxthm5XL7N4rxz1Bcbz4GG7ueerJlpLMMVellcTFHHVM9CYy4UF
         FezQFKCvMqN6Gko5oGLbxDnPFk4AVuLnRq85o05SS1Kwb+fhs1poi8wIVFf5ORUAPg
         FR36RKugApWByKPyix1o4ozVHaRYxW7iVpTBWm8I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j6k0G-007xuY-S4; Tue, 25 Feb 2020 23:52:41 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Jeremy Cline <jcline@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm fixes for 5.6
Date:   Tue, 25 Feb 2020 23:52:18 +0000
Message-Id: <20200225235223.12839-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, jcline@redhat.com, mark.rutland@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

This is a small update containing a number of fixes, the most important ones
making sure we force the inlining of any helper that gets used by the EL2 code
(James identified that some bad things happen with CLang and the Shadow Call
Stack extention).

Please pull,

	M.

The following changes since commit 4a267aa707953a9a73d1f5dc7f894dd9024a92be:

  KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer (2020-01-28 13:09:31 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.6-1

for you to fetch changes up to e43f1331e2ef913b8c566920c9af75e0ccdd1d3f:

  arm64: Ask the compiler to __always_inline functions used by KVM at HYP (2020-02-22 11:01:47 +0000)

----------------------------------------------------------------
KVM/arm fixes for 5.6, take #1

- Fix compilation on 32bit
- Move  VHE guest entry/exit into the VHE-specific entry code
- Make sure all functions called by the non-VHE HYP code is tagged as __always_inline

----------------------------------------------------------------
James Morse (3):
      KVM: arm64: Ask the compiler to __always_inline functions used at HYP
      KVM: arm64: Define our own swab32() to avoid a uapi static inline
      arm64: Ask the compiler to __always_inline functions used by KVM at HYP

Jeremy Cline (1):
      KVM: arm/arm64: Fix up includes for trace.h

Mark Rutland (1):
      kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()

 arch/arm/include/asm/kvm_host.h          |  3 --
 arch/arm64/include/asm/arch_gicv3.h      |  2 +-
 arch/arm64/include/asm/cache.h           |  2 +-
 arch/arm64/include/asm/cacheflush.h      |  2 +-
 arch/arm64/include/asm/cpufeature.h      | 10 +++----
 arch/arm64/include/asm/io.h              |  4 +--
 arch/arm64/include/asm/kvm_emulate.h     | 48 ++++++++++++++++----------------
 arch/arm64/include/asm/kvm_host.h        | 32 ---------------------
 arch/arm64/include/asm/kvm_hyp.h         |  7 +++++
 arch/arm64/include/asm/kvm_mmu.h         |  3 +-
 arch/arm64/include/asm/virt.h            |  2 +-
 arch/arm64/kvm/hyp/switch.c              | 39 ++++++++++++++++++++++++--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  4 +--
 virt/kvm/arm/arm.c                       |  2 --
 virt/kvm/arm/trace.h                     |  1 +
 15 files changed, 84 insertions(+), 77 deletions(-)
