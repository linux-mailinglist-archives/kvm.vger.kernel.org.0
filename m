Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2644B2B23B1
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgKMS0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgKMS0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A75F206E0;
        Fri, 13 Nov 2020 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291977;
        bh=jlcEFEJGWUtl3jyEnzWstVetGJnJb4qzKEp/RBIjfR0=;
        h=From:To:Cc:Subject:Date:From;
        b=fTp+FPKBhZbEnNNXp+fFOqY3/7ZOuxtKaaJ++58xIcapq8qTdltfZSFYQFcj8iAbB
         TdTkCIedJoPJUOIhMynCmga2jABe9buSfJJlUf7toPa3a3rd6I5mvWSWX85+hXigQN
         9vttp+qV7K3E30vp8KObdHr5lXgbp2BDfaTw6FBE=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm3-00APrY-AI; Fri, 13 Nov 2020 18:26:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 0/8] KVM: arm64: Disabled PMU handling
Date:   Fri, 13 Nov 2020 18:25:54 +0000
Message-Id: <20201113182602.471776-1-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It recently dawned on me that the way we handle PMU traps when the PMU
is disabled is plain wrong. We consider that handling the registers as
RAZ/WI is a fine thing to do, while the ARMv8 ARM is pretty clear that
that's not OK and that such registers should UNDEF when FEAT_PMUv3
doesn't exist. I went all the way back to the first public version of
the spec, and it turns out we were *always* wrong.

It probably comes from the fact that we used not to trap the ID
registers, and thus were unable to advertise the lack of PMU, but
that's hardly an excuse. So let's fix the damned thing.

This series adds an extra check in the helpers that check for the
validity of the PMU access (most of the registers have to checked
against some enable flags and/or the accessing exception level), and
rids us of the RAZ/WI behaviour.

This enables us to make additional cleanups, to the point where we can
remove the PMU "ready" state that always had very bizarre semantics.
All in all, a negative diffstat, and spec compliant behaviours. What's
not to like?

I've run a few guests with and without PMUs as well as KUT, and
nothing caught fire. The patches are on top of kvmarm/queue.

Marc Zyngier (8):
  KVM: arm64: Add kvm_vcpu_has_pmu() helper
  KVM: arm64: Set ID_AA64DFR0_EL1.PMUVer to 0 when no PMU support
  KVM: arm64: Refuse illegal KVM_ARM_VCPU_PMU_V3 at reset time
  KVM: arm64: Inject UNDEF on PMU access when no PMU configured
  KVM: arm64: Remove PMU RAZ/WI handling
  KVM: arm64: Remove dead PMU sysreg decoding code
  KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
  KVM: arm64: Get rid of the PMU ready state

 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/pmu-emul.c         | 11 +++----
 arch/arm64/kvm/reset.c            |  4 +++
 arch/arm64/kvm/sys_regs.c         | 51 ++++++++-----------------------
 include/kvm/arm_pmu.h             |  3 --
 5 files changed, 24 insertions(+), 48 deletions(-)

-- 
2.28.0

