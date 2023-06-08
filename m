Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A546D728445
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 17:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbjFHPxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 11:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjFHPxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 11:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888351702
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 08:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67CB361864
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 15:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC887C433EF;
        Thu,  8 Jun 2023 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686239587;
        bh=eM0r7LYZ4B4QPeMwyPpJr5eyhDkivEWbzbqklj2jVoY=;
        h=From:To:Cc:Subject:Date:From;
        b=R3qgBH2Yr4nTEIq4BcMwCHY14gD1SdwiSYB3GWouB0FG1t1/qLlvMFEbHAoQwL0xm
         R7GeVeRb9mmTaGFCsHU8zErJDofuWe2HYa7HKN78H1UJBsCKtCd3MrB6SdiGEsUEF8
         lhAESqDwYtPzRlyqAZDmE+53i1LxibM6hubEaZ9V4CaTTt2AIDPncvrEx8HIh2jwWo
         Ui8CBvTKCMM/6ZZKPNlIsvCk+Aj6tyUFmVEoetcALcWRVS+UAAdaKux2upPTVWrgF6
         SuvqDUhMU1IcGaLj/OL3C7kCpmD/iIIPFxMevyc+gyvYt0IiSOgZAMQg1Vl4VcqTC4
         yJAlKLGKvBZwA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7Hwf-003pzj-GO;
        Thu, 08 Jun 2023 16:53:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Sebastian Ott <sebott@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM/arm64 fixes for 6.4, take #4
Date:   Thu,  8 Jun 2023 16:52:55 +0100
Message-Id: <20230608155255.1850620-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, mark.rutland@arm.com, nathan@kernel.org, oliver.upton@linux.dev, reijiw@google.com, sebott@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Here's yet another batch of fixes, two of them addressing pretty
recent regressions: GICv2 emulation on GICv3 was accidently killed,
and the PMU rework needed some tweaking.

The last two patches address an annoying PMU (again) problem where
the KVM requirements were never factored in when PMU counters were
directly exposed to userspace. Reiji has been working on a fix, which
is now readdy to be merged.

Please pull,

        M.

The following changes since commit 40e54cad454076172cc3e2bca60aa924650a3e4b:

  KVM: arm64: Document default vPMU behavior on heterogeneous systems (2023-05-31 10:29:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.4-4

for you to fetch changes up to 30c60dda219ddda0bc6ff6ac55d493d9db8be4fa:

  KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu() (2023-06-07 16:48:34 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.4, take #4

- Correctly save/restore PMUSERNR_EL0 when host userspace is using
  PMU counters directly

- Fix GICv2 emulation on GICv3 after the locking rework

- Don't use smp_processor_id() in kvm_pmu_probe_armpmu(), and
  document why...

----------------------------------------------------------------
Marc Zyngier (1):
      KVM: arm64: Restore GICv2-on-GICv3 functionality

Oliver Upton (1):
      KVM: arm64: Use raw_smp_processor_id() in kvm_pmu_probe_armpmu()

Reiji Watanabe (2):
      KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
      KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm/include/asm/arm_pmuv3.h        |  5 +++++
 arch/arm64/include/asm/kvm_host.h       |  7 +++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++++++++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 ++++++++++++++
 arch/arm64/kvm/pmu-emul.c               | 20 +++++++++++++++++++-
 arch/arm64/kvm/pmu.c                    | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c         | 11 +++++++----
 drivers/perf/arm_pmuv3.c                | 21 ++++++++++++++++++---
 8 files changed, 110 insertions(+), 10 deletions(-)
