Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304ED2AD7A5
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgKJNgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 08:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbgKJNga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 08:36:30 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C630206B6;
        Tue, 10 Nov 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605015389;
        bh=lkIGiFv1b4/nNPUJbCd5QdY105G4U0sOjAEfhYSdOOg=;
        h=From:To:Cc:Subject:Date:From;
        b=HyF962h6OGyVJupnay/O799NbeCbLjWLLerrcTm01Bq3Ed3G1mELngwKqPdT/rzmi
         7s36TYAhcC7CMPWPKJR4tCOoiwt3fxA5pHxQXUzkKRuTL2bMD6hTInN861ZCJsfwfK
         ym6lKaCPjED6+ITuU66O4anrwC4m6gVRhYb5FrCs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kcTox-009SZy-Cm; Tue, 10 Nov 2020 13:36:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 0/9] KVM: arm64: Kill the copro array
Date:   Tue, 10 Nov 2020 13:36:10 +0000
Message-Id: <20201110133619.451157-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the very beginning of KVM/arm64, we represented the system
register file using a dual view: on one side the AArch64 state, on the
other a bizarre mapping of the AArch32 state onto the Aarch64
registers.

It was nice at the time as it allowed us to share some code with the
32bit port, and to come up with some creative bugs. But is was always
a hack, and we are now in a position to simplify the whole thing.

This series goes through the whole of the AArch32 cp14/15 register
file, and point each of them directly at their 64bit equivalent. For
the few cases where two 32bit registers share a 64bit counterpart, we
define which half of the register they map.

Finally, we drop a large number of definitions and state that have
become useless.

This series applies on top of the exception injection rework
previously posted [2].

* From v1 [1]:
  - Added initial patch to deal with TTBCR2
  - Fixed TCR_EL1 handling in inject_abt32()
  - Optimise for 64bit handling of sysreg access
  - Make most 32bit cp14 registers access the full 64bit register

[1] https://lore.kernel.org/r/20201102191609.265711-1-maz@kernel.org
[2] https://lore.kernel.org/r/20201102164045.264512-1-maz@kernel.org

Marc Zyngier (9):
  KVM: arm64: Introduce handling of AArch32 TTBCR2 traps
  KVM: arm64: Move AArch32 exceptions over to AArch64 sysregs
  KVM: arm64: Add AArch32 mapping annotation
  KVM: arm64: Map AArch32 cp15 register to AArch64 sysregs
  KVM: arm64: Map AArch32 cp14 register to AArch64 sysregs
  KVM: arm64: Drop is_32bit trap attribute
  KVM: arm64: Drop is_aarch32 trap attribute
  KVM: arm64: Drop legacy copro shadow register
  KVM: arm64: Drop kvm_coproc.h

 arch/arm64/include/asm/kvm_coproc.h |  38 -----
 arch/arm64/include/asm/kvm_host.h   |  73 +++------
 arch/arm64/kvm/arm.c                |   3 +-
 arch/arm64/kvm/guest.c              |   1 -
 arch/arm64/kvm/handle_exit.c        |   1 -
 arch/arm64/kvm/inject_fault.c       |  62 +++-----
 arch/arm64/kvm/reset.c              |   1 -
 arch/arm64/kvm/sys_regs.c           | 233 +++++++++++++---------------
 arch/arm64/kvm/sys_regs.h           |   9 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c    |   4 -
 10 files changed, 151 insertions(+), 274 deletions(-)
 delete mode 100644 arch/arm64/include/asm/kvm_coproc.h

-- 
2.28.0

