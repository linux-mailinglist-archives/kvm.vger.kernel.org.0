Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17BE428223
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJJPLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 11:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhJJPLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 11:11:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD94760ED4;
        Sun, 10 Oct 2021 15:09:24 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mZaS2-00FrmD-Eu; Sun, 10 Oct 2021 16:09:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 0/5] KVM: arm64: Assorted vgic-v3 fixes
Date:   Sun, 10 Oct 2021 16:09:05 +0100
Message-Id: <20211010150910.2911495-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's a bunch of vgic-v3 fixes I have been sitting on for some
time. None of them are critical, though some are rather entertaining.

The first one is a leftover from the initial Apple-M1 enablement,
which doesn't advertise the GIC support via ID_AA64PFR0_EL1 (which is
expected, as it only has half a GIC...). We address it by forcefully
advertising the feature if the guest has a GICv3.

The second patch is really fun, and shows how things can go wrong when
they are badly specified. The gist of it is that on systems that
advertise ICH_VTR_EL2.SEIS, we need to fallback to the full GICv3
cpuif emulation. The third patch is an good optimisation on the
previous one, and the fourth a direct consequence of the whole thing.

The last patch are more of a harmless oddity: virtual LPIs happen to
have an active state buried into the pseudocode (and only there). Fun!
Nothing goes wrong with that, but we need to align the emulation to
match the pseudocode.

All of this is only targeting 5.16, and I don't plan to backport any
of it.

* From v1 [1]:

  - Dropped the patch that tried to optimise what to do with an active
    LPI. There is unfortunately a bad corner case in the pseudocode
    that prevents it. Oh well.
    
  - Added an extra patch to help in the case where ICH_HCR_EL2.TDS is
    supported, and that we can use that instead of ICH_HCR_EL2.TC to
    trap only ICC_DIR_EL1. Given the performance improvement, it was
    too hard to ignore it.

[1] https://lore.kernel.org/r/20210924082542.2766170-1-maz@kernel.org

Marc Zyngier (5):
  KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
  KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
  KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when
    possible
  KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
  KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the
    pseudocode

 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 22 ++++++++--------------
 arch/arm64/kvm/sys_regs.c       |  5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c   | 21 ++++++++++++++++++---
 4 files changed, 34 insertions(+), 17 deletions(-)

-- 
2.30.2

