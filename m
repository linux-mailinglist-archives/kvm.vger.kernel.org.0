Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9893E33929E
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 17:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCLQAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 11:00:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhCLQAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 11:00:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1F564FFE;
        Fri, 12 Mar 2021 16:00:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lKkDH-001GDF-Qt; Fri, 12 Mar 2021 16:00:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] KVM/arm64 fixes for 5.12, take #2
Date:   Fri, 12 Mar 2021 16:00:03 +0000
Message-Id: <20210312160003.3920996-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, ardb@kernel.org, catalin.marinas@arm.com, eric.auger@redhat.com, keescook@chromium.org, nathan@kernel.org, samitolvanen@google.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the second batch of KVM/arm64 fixes for 5.12. The most notable
item is the tidying up of the way we deal with the guest physical
space, which had a couple of warts. The other patches address i-cache
isolation between vcpus (they are supposed to be vcpu-private, but can
not being so...), and a fix for a link-time issue that can occur with
LTO.

Note that this time around, this pull request is on top of kvm/next,
right after the patches you applied last week.

Please pull,

	M.

The following changes since commit 357ad203d45c0f9d76a8feadbd5a1c5d460c638b:

  KVM: arm64: Fix range alignment when walking page tables (2021-03-06 04:18:41 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-2

for you to fetch changes up to 262b003d059c6671601a19057e9fe1a5e7f23722:

  KVM: arm64: Fix exclusive limit for IPA size (2021-03-12 15:43:22 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.12, take #2

- Fix a couple of branches that could be impossible to resolve at
  link time when objects are far apart, such as with LTO
- Mandate i-cache invalidation when two vcpus are sharing a physical CPU
- Fail VM creation if the implicit IPA size isn't supported
- Don't reject memslots that reach the IPA limit without breaching it

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
      KVM: arm64: Reject VM creation when the default IPA size is unsupported
      KVM: arm64: Fix exclusive limit for IPA size

Sami Tolvanen (1):
      KVM: arm64: Don't use cbz/adr with external symbols

 Documentation/virt/kvm/api.rst     |  3 +++
 arch/arm64/include/asm/kvm_asm.h   |  4 ++--
 arch/arm64/kvm/arm.c               |  7 ++++++-
 arch/arm64/kvm/hyp/entry.S         |  6 ++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 +++---
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  3 ++-
 arch/arm64/kvm/mmu.c               |  3 +--
 arch/arm64/kvm/reset.c             | 12 ++++++++----
 9 files changed, 31 insertions(+), 16 deletions(-)
