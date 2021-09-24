Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B730416DB0
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 10:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbhIXI1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 04:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244731AbhIXI1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 04:27:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3631F61090;
        Fri, 24 Sep 2021 08:25:53 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mTgWl-00ChmL-1s; Fri, 24 Sep 2021 09:25:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        kernel-team@android.com
Subject: [PATCH 0/5] KVM: arm64: Assorted vgic-v3 fixes
Date:   Fri, 24 Sep 2021 09:25:37 +0100
Message-Id: <20210924082542.2766170-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, christoffer.dall@arm.com, kernel-team@android.com
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
cpuif emulation. The third patch is a direct consequence of the
previous one.

The last two patches are more of a harmless oddity: virtual LPIs
happen to have an active state buried into the pseudocode (and only
there). Fun!  Nothing goes wrong with that, but we can perform a minor
optimisation, and we need to align the emulation to match the
pseudocode.

All of this is only targeting 5.16, and I don't plan to backport any
of it.

Marc Zyngier (5):
  KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
  KVM: arm64: Work around GICv3 locally generated SErrors
  KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
  KVM: arm64: vgic-v3: Don't propagate LPI active state from LRs into
    the distributor
  KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the
    pseudocode

 arch/arm64/kvm/hyp/vgic-v3-sr.c | 22 ++++++++--------------
 arch/arm64/kvm/sys_regs.c       |  5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c   | 11 ++++++++++-
 3 files changed, 23 insertions(+), 15 deletions(-)

-- 
2.30.2

