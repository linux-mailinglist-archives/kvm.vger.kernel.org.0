Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7187340571
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 13:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhCRM0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 08:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhCRMZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 08:25:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0741D64F41;
        Thu, 18 Mar 2021 12:25:45 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMrig-002OZW-QY; Thu, 18 Mar 2021 12:25:42 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, ascull@google.com, qperret@google.com,
        kernel-team@android.com
Subject: [PATCH v2 00/11] KVM: arm64: Enable SVE support on nVHE systems
Date:   Thu, 18 Mar 2021 12:25:21 +0000
Message-Id: <20210318122532.505263-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, broonie@kernel.org, ascull@google.com, qperret@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series enables SVE support for KVM on nVHE hardware (or more
likely, software models), and is an alternative to Daniel's patch[1]
which has gone through 3 versions, but still has a number of issues.

Instead of waiting for things to happen, I decided to try and see what
I could come up with.

The SVE save/restore is modelled after the SVE VHE flow, itself
closely following the FPSIMD flow:

- the guest traps to EL2 on first SVE access, and will not trap
  anymore until vcpu_put()

- ZCR_EL2 stays constant as long as the guest has SVE enabled

- once back on the host side, ZCR_EL2 is restored to its default value
  on first SVE access

Most of this series only repaints things so that VHE and nVHE look as
similar as possible, the ZCR_EL2 management being the most visible
exception. This results in a bunch of preparatory patches that aim at
making the code slightly more readable.

This has been tested on a FVP model with both VHE/nVHE configurations
using the string tests included with the "optimized-routines"
library[2].

Patches against 5.12-rc2.

* From v1 [3]:
  - Fixed __sve_save_state SYM_FUNC_END label
  - Turned the ZCR_EL2 reset hypercall into a host trap
  - Fixed SVE state mapping size
  - Correctly mask RES0 bits from ZCR_ELx
  - Introduced sve_cond_update_zcr_vq() as a ZCR_ELx update helper
  - Renamed vcpu_sve_vq() to vcpu_sve_max_vq()
  - Collected Acks from Will

[1] https://lore.kernel.org/r/20210302164850.3553701-1-daniel.kiss@arm.com
[2] https://github.com/ARM-software/optimized-routines
[3] https://lore.kernel.org/r/20210316101312.102925-1-maz@kernel.org

Daniel Kiss (1):
  KVM: arm64: Enable SVE support for nVHE

Marc Zyngier (10):
  KVM: arm64: Provide KVM's own save/restore SVE primitives
  KVM: arm64: Use {read,write}_sysreg_el1 to access ZCR_EL1
  KVM: arm64: Let vcpu_sve_pffr() handle HYP VAs
  KVM: arm64: Introduce vcpu_sve_vq() helper
  arm64: sve: Provide a conditional update accessor for ZCR_ELx
  KVM: arm64: Rework SVE host-save/guest-restore
  KVM: arm64: Map SVE context at EL2 when available
  KVM: arm64: Save guest's ZCR_EL1 before saving the FPSIMD state
  KVM: arm64: Trap host SVE accesses when the FPSIMD state is dirty
  KVM: arm64: Save/restore SVE state for nVHE

 arch/arm64/Kconfig                      |  7 ---
 arch/arm64/include/asm/fpsimd.h         |  9 +++
 arch/arm64/include/asm/fpsimdmacros.h   | 10 +++-
 arch/arm64/include/asm/kvm_host.h       | 21 ++-----
 arch/arm64/include/asm/kvm_hyp.h        |  2 +
 arch/arm64/kvm/arm.c                    |  5 --
 arch/arm64/kvm/fpsimd.c                 | 26 +++++++--
 arch/arm64/kvm/guest.c                  |  6 +-
 arch/arm64/kvm/hyp/fpsimd.S             | 10 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 77 ++++++++++++-------------
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 ++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 13 +++--
 arch/arm64/kvm/reset.c                  |  4 --
 13 files changed, 109 insertions(+), 85 deletions(-)

-- 
2.29.2

