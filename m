Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7402AC302
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 18:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730027AbgKIR7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 12:59:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIR7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 12:59:30 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E8920665;
        Mon,  9 Nov 2020 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944769;
        bh=VB4W1R6Xidy63HPldBkvYgNymeTHvz90LHtlTza6wcQ=;
        h=From:To:Cc:Subject:Date:From;
        b=1WyyWxd6omZIqHS646zTRLqZpPKC0zBMKlpQ++0dgOSQlhLk+b4uq2Q45g3bt7jFP
         oWSo3EUsYmCs6w/muSDYPFB5Kmg2A1XuCLYVpmszzmdd08s+bMofK656RIoxq+7/VC
         mvacaEITP9Jz8ni9pNyFrBepc5qQ6ujtFysiCDvM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcBRv-009BQs-17; Mon, 09 Nov 2020 17:59:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, ndesaulniers@google.com,
        dbrazdil@google.com, kernel-team@android.com
Subject: [PATCH v2 0/5] KVM: arm64: Host EL2 entry improvements
Date:   Mon,  9 Nov 2020 17:59:18 +0000
Message-Id: <20201109175923.445945-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, ndesaulniers@google.com, dbrazdil@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series reworks various bits of the host EL2 entry after
Andrew's extensive rework to move from direct function calls to a
SMCCC implementation.

The first 2 patches allow the use of direct function pointers at EL2,
something that we can't do at the moment (other than PC-relative
addressing). This requires a helper to translate pointers at runtime,
but the result is neat enough. This allows the rewrite of the host HVC
handling in a more maintainable way.

Note that this version now includes the result of a discussion with
Nick, providing some funky pointer mangling in order to make the use
of these pointers vaguely safer (no, they are not safe at all).

Another patch removes the direct use of kimage_voffset, which we won't
be able to trust for much longer.

The last two patches are just cleanups and optimisations.

* From v1 [1]:
  - Merged the 3 first patches as fixes
  - Added pointer mangling for function calls
  - Moved EL2 entry ldp a couple of instructions later (as suggested
    by Alex)
  - Rebased on top of -rc3

[1] https://lore.kernel.org/r/20201026095116.72051-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Add kimg_hyp_va() helper
  KVM: arm64: Turn host HVC handling into a dispatch table
  KVM: arm64: Patch kimage_voffset instead of loading the EL1 value
  KVM: arm64: Simplify __kvm_enable_ssbs()
  KVM: arm64: Avoid repetitive stack access on host EL1 to EL2 exception

 arch/arm64/include/asm/kvm_asm.h    |   2 -
 arch/arm64/include/asm/kvm_mmu.h    |  40 +++++
 arch/arm64/include/asm/sysreg.h     |   1 +
 arch/arm64/kernel/image-vars.h      |   5 +-
 arch/arm64/kvm/hyp/nvhe/host.S      |  11 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  | 232 +++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c |  11 --
 arch/arm64/kvm/va_layout.c          |  56 +++++++
 8 files changed, 241 insertions(+), 117 deletions(-)

-- 
2.28.0

