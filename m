Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930FA298A0E
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 11:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769092AbgJZKJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 06:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737064AbgJZJvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 05:51:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612A020704;
        Mon, 26 Oct 2020 09:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603705891;
        bh=/871FOVPW0E/2Dr2XjwHcJP0LUAoYcByZt/uNRRFF80=;
        h=From:To:Cc:Subject:Date:From;
        b=WD43U8rqPf0syvCAvMG/IcVDofcUUOS/TFk/pC+UizH/0Db318ZDt6vTVU2Rcgkv4
         RlXt5wfgwCzqZ/XR+pQ9VcsifQtS4beZLAqrCNp3Z0rYfOSU4iZlofTv3hbplAoCyg
         aEXqP4KK1OlZD/ToX3ZQIuATp44SZNTLU4S1npGQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kWzA1-004HZn-7b; Mon, 26 Oct 2020 09:51:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com
Subject: [PATCH 0/8] KVM: arm64: Host EL2 entry improvements
Date:   Mon, 26 Oct 2020 09:51:08 +0000
Message-Id: <20201026095116.72051-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, ascull@google.com, will@kernel.org, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This small series reworks various bits of the host EL2 entry after
Andrew's extensive rework to move from direct function calls to a
SMCCC implementation.

The first 3 patches are plain bug fixes, and candidates for immediate
merge into 5.10.

The following 2 patches allow the use of direct function pointers at
EL2, something that we can't do at the moment (other than PC-relative
addressing). This requires a helper to translate pointers at runtime,
but the result is neat enough. This allows the rewrite of the host HVC
handling in a more maintainable way.

A similar patch removes the direct use of kimage_voffset, which we
won't be able to trust for much longer.

The last two patches are just cleanups and optimisations.

Patches on top of 5.10-rc1.

Marc Zyngier (8):
  KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
  KVM: arm64: Remove leftover kern_hyp_va() in nVHE TLB invalidation
  KVM: arm64: Drop useless PAN setting on host EL1 to EL2 transition
  KVM: arm64: Add kimg_hyp_va() helper
  KVM: arm64: Turn host HVC handling into a dispatch table
  KVM: arm64: Patch kimage_voffset instead of loading the EL1 value
  KVM: arm64: Simplify __kvm_enable_ssbs()
  KVM: arm64: Avoid repetitive stack access on host EL1 to EL2 exception

 arch/arm64/include/asm/kvm_asm.h    |   2 -
 arch/arm64/include/asm/kvm_mmu.h    |  16 ++
 arch/arm64/include/asm/sysreg.h     |   1 +
 arch/arm64/kernel/image-vars.h      |   5 +-
 arch/arm64/kvm/hyp/nvhe/host.S      |  14 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S  |  23 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c  | 231 +++++++++++++++++-----------
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c |  11 --
 arch/arm64/kvm/hyp/nvhe/tlb.c       |   1 -
 arch/arm64/kvm/va_layout.c          |  56 +++++++
 10 files changed, 236 insertions(+), 124 deletions(-)

-- 
2.28.0

