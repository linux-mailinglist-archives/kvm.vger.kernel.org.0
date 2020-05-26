Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD43A1C10A8
	for <lists+kvm@lfdr.de>; Fri,  1 May 2020 12:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgEAKMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 May 2020 06:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgEAKMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 May 2020 06:12:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC8272071C;
        Fri,  1 May 2020 10:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588327932;
        bh=MklRYqz2k5cgg9fDxl/d5X5Bx725+ZQ/Ik6viwGxla4=;
        h=From:To:Cc:Subject:Date:From;
        b=X1YhUQCCR6e8QRgIEHrOJrY2OLaP82i20DIb+Jk+ZKCeEwwvw3Zpb0ro3VcUTEhw4
         gaaZNfih7lrLfPOWi2d/T3xjcde6aAizPmXuK+c1j7yME1SY2dNkQt0+ZatzQuPJ+W
         LFZ0qpF5NDxuEBSFW5mNfRKLlY02LLeFJT5i58ac=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jUSeR-008J3K-7D; Fri, 01 May 2020 11:12:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm fixes for 5.7, take #2
Date:   Fri,  1 May 2020 11:12:00 +0100
Message-Id: <20200501101204.364798-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, maskray@google.com, mark.rutland@arm.com, ndesaulniers@google.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

This is the second batch of KVM/arm fixes for 5.7. A compilation fix,
a GICv4.1 fix, plus a couple of sanity checks (SP_EL0 save/restore,
and the sanitising of AArch32 registers).

Note that the pull request I sent a week ago[1] is still valid, and
that this new series is built on top of the previous one.

Please pull,

	M.

[1] https://lore.kernel.org/kvm/20200423154009.4113562-1-maz@kernel.org/

The following changes since commit 446c0768f5509793a0e527a439d4866b24707b0e:

  Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master (2020-04-23 16:27:33 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.7-2

for you to fetch changes up to 0225fd5e0a6a32af7af0aefac45c8ebf19dc5183:

  KVM: arm64: Fix 32bit PC wrap-around (2020-05-01 09:51:08 +0100)

----------------------------------------------------------------
KVM/arm fixes for Linux 5.7, take #2

- Fix compilation with Clang
- Correctly initialize GICv4.1 in the absence of a virtual ITS
- Move SP_EL0 save/restore to the guest entry/exit code
- Handle PC wrap around on 32bit guests, and narrow all 32bit
  registers on userspace access

----------------------------------------------------------------
Fangrui Song (1):
      KVM: arm64: Delete duplicated label in invalid_vector

Marc Zyngier (3):
      KVM: arm64: Save/restore sp_el0 as part of __guest_enter
      KVM: arm64: vgic-v4: Initialize GICv4.1 even in the absence of a virtual ITS
      KVM: arm64: Fix 32bit PC wrap-around

 arch/arm64/kvm/guest.c           |  7 +++++++
 arch/arm64/kvm/hyp/entry.S       | 23 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/hyp-entry.S   |  1 -
 arch/arm64/kvm/hyp/sysreg-sr.c   | 17 +++--------------
 virt/kvm/arm/hyp/aarch32.c       |  8 ++++++--
 virt/kvm/arm/vgic/vgic-init.c    |  9 ++++++++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 ++-
 7 files changed, 49 insertions(+), 19 deletions(-)
