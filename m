Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E2B76AAA7
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 10:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjHAIP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 04:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjHAIPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 04:15:24 -0400
Received: from out-98.mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FBDA0
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 01:15:23 -0700 (PDT)
Date:   Tue, 1 Aug 2023 01:15:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690877721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NJXyz71UWN5dEwNYPmqB5WKFGNITeZh3IOXfm4I58G8=;
        b=LKm9NtDDL7/mKj+tI/Q7boBV8oKLR2SJK+3i/cYV17JrtOSZxLDRVSIytuqRGkt05Qo22D
        dawkO6zHH5lLzJ0sfdxIh90ctEexT1l2Ho84xGlyUhYKOIB/OrIVO9p52tAdaFm/duJdC4
        TOHnvPQA+oZCwtRzYaZ6nknghqN5tA8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, rananta@google.com, tabba@google.com,
        arnd@arndb.de, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.5, part #2
Message-ID: <ZMi/EkSLgRymQZzN@thinky-boi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Second batch of fixes for 6.5 here. As usual, details are in the tag but
of particular interest is the fix for AmpereOne systems, as VMs fail to
boot when setting up the MMU (yikes).

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 9d2a55b403eea26cab7c831d8e1c00ef1e6a6850:

  KVM: arm64: Fix the name of sys_reg_desc related to PMU (2023-07-14 23:34:05 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.5-2

for you to fetch changes up to 74158a8cad79d2f5dcf71508993664c5cfcbfa3c:

  KVM: arm64: Skip instruction after emulating write to TCR_EL1 (2023-07-28 17:11:23 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.5, part #2

 - Fixes for the configuration of SVE/SME traps when hVHE mode is in use

 - Allow use of pKVM on systems with FF-A implementations that are v1.0
   compatible

 - Request/release percpu IRQs (arch timer, vGIC maintenance) correctly
   when pKVM is in use

 - Fix function prototype after __kvm_host_psci_cpu_entry() rename

 - Skip to the next instruction when emulating writes to TCR_EL1 on
   AmpereOne systems

----------------------------------------------------------------
Arnd Bergmann (1):
      KVM: arm64: fix __kvm_host_psci_cpu_entry() prototype

Fuad Tabba (7):
      KVM: arm64: Factor out code for checking (h)VHE mode into a macro
      KVM: arm64: Use the appropriate feature trap register for SVE at EL2 setup
      KVM: arm64: Disable SME traps for (h)VHE at setup
      KVM: arm64: Helper to write to appropriate feature trap register based on mode
      KVM: arm64: Use the appropriate feature trap register when activating traps
      KVM: arm64: Fix resetting SVE trap values on reset for hVHE
      KVM: arm64: Fix resetting SME trap values on reset for (h)VHE

Oliver Upton (3):
      KVM: arm64: Allow pKVM on v1.0 compatible FF-A implementations
      KVM: arm64: Rephrase percpu enable/disable tracking in terms of hyp
      KVM: arm64: Skip instruction after emulating write to TCR_EL1

Raghavendra Rao Ananta (1):
      KVM: arm64: Fix hardware enable/disable flows for pKVM

 arch/arm64/include/asm/el2_setup.h      | 44 ++++++++++++++++--------
 arch/arm64/include/asm/kvm_asm.h        |  2 +-
 arch/arm64/include/asm/kvm_emulate.h    | 21 +++++++++---
 arch/arm64/kvm/arm.c                    | 61 +++++++++++++++------------------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  1 +
 arch/arm64/kvm/hyp/nvhe/ffa.c           | 15 +++++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 7 files changed, 90 insertions(+), 56 deletions(-)
