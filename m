Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA54610F0A
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 12:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiJ1Kxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 06:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJ1Kxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 06:53:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164D4CD5EE
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 03:53:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A79A46279F
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 10:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD32C433D6;
        Fri, 28 Oct 2022 10:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666954429;
        bh=53rg7TIHwfEpfmUyy4QvY3u8DYtBH+msqMaPikufBpw=;
        h=From:To:Cc:Subject:Date:From;
        b=sJlNGceAnd9VE8KgnvPrUjB2fMiOOPV5+2NAfECtDZ1o8LaK2WQ/92R97MTVjb+Jh
         zvqG552MgKXqNDsnMwCNsDBDJ5Hw+B2OWjPTfxhbTORM+GXP7WdgEodV/OrdG+mL02
         2vubFo8qO30ye7ofAYghVjyXmgIwTwttaYg/339ZoxL64Hei34MV4+/vlZ8HuN03G6
         UX3vBHWgE7ZdzfDVT09G/yv8dFiI7cI78Vj75m1gZTETX5sphtf4fQjtSGkgmKrcuV
         U0Iex6/dgv/RrQlTcpmKzPEN+i15o+GKCMv+eYFyz43MPMpdGSPpaUPpx5d0D95hYK
         N+pOCWFg5rQqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ooMzi-002E3J-PG;
        Fri, 28 Oct 2022 11:53:46 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v2 00/14] KVM: arm64: PMU: Fixing chained events, and PMUv3p5 support
Date:   Fri, 28 Oct 2022 11:53:22 +0100
Message-Id: <20221028105322.2030167-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo reported[0] that our PMU emulation was busted when it comes to
chained events, as we cannot expose the overflow on a 32bit boundary
(which the architecture requires).

This series aims at fixing this (by deleting a lot of code), and as a
bonus adds support for PMUv3p5, as this requires us to fix a few more
things.

Tested on A53 (PMUv3) and QEMU (PMUv3p5).

* From v1 [1]:
  - Rebased on 6.1-rc2
  - New patch advertising that we always support the CHAIN event
  - Plenty of bug fixes (idreg handling, AArch32, overflow narrowing)
  - Tons of cleanups
  - All kudos to Oliver and Reiji for spending the time to review this
    mess, and Ricardo for finding more bugs!

[0] https://lore.kernel.org/r/20220805004139.990531-1-ricarkol@google.com
[1] https://lore.kernel.org/r/20220805135813.2102034-1-maz@kernel.org

Marc Zyngier (14):
  arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
  KVM: arm64: PMU: Align chained counter implementation with
    architecture pseudocode
  KVM: arm64: PMU: Always advertise the CHAIN event
  KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
  KVM: arm64: PMU: Narrow the overflow checking when required
  KVM: arm64: PMU: Only narrow counters that are not 64bit wide
  KVM: arm64: PMU: Add counter_index_to_*reg() helpers
  KVM: arm64: PMU: Simplify setting a counter to a specific value
  KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits
  KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
  KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be set from userspace
  KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be set from userspace
  KVM: arm64: PMU: Implement PMUv3p5 long counter support
  KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest

 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/include/asm/sysreg.h   |   2 +
 arch/arm64/kvm/arm.c              |   6 +
 arch/arm64/kvm/pmu-emul.c         | 408 ++++++++++++------------------
 arch/arm64/kvm/sys_regs.c         | 135 +++++++++-
 include/kvm/arm_pmu.h             |  15 +-
 6 files changed, 307 insertions(+), 260 deletions(-)

-- 
2.34.1

