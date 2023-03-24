Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811846C8031
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 15:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjCXOrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 10:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbjCXOrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 10:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF01B19C50
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 07:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AF4E62B49
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525F5C4339B;
        Fri, 24 Mar 2023 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669239;
        bh=4vzJyqVj/H07YElh4j3pruZHL47TVlCStjVfQtrNMdE=;
        h=From:To:Cc:Subject:Date:From;
        b=IDvge/7lLxRYtULrvMDW/hnoWgQ1tDHIvgxTbKJNQMKBPT9HqUYvKf7BU6J1eMGqO
         If+qjlJjWk7/Mjx51r6cUYXO9E1OmVYchzsRyA0OaryysYi3T6YDh5HkdfzbSXdJWE
         YOmDgsvamr6Q7XAW+oxmKWyQydRJBkBH/of8Ym2OnXdtzNROJ9Zgp4HJfeksMDu0Ak
         wROSFgMBaXdoyblf6SoEnViRkg+bqbQkfkGaYTLUrkVW+GZUq2IHfYbZRN+B/D0yXa
         MMeF0r6ajjOHaAxBaNhFqGYfWsx+aJyBGXF7KnQpa+z0JYUt4MAjFIYoPVWnwKGH6c
         8HkIesC61ofvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pfihI-002qBP-Un;
        Fri, 24 Mar 2023 14:47:17 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v3 00/18] KVM: arm64: Rework timer offsetting for fun and profit
Date:   Fri, 24 Mar 2023 14:46:46 +0000
Message-Id: <20230324144704.4193635-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series aims at satisfying multiple goals:

- allow a VMM to atomically restore a timer offset for a whole VM
  instead of updating the offset each time a vcpu get its counter
  written

- allow a VMM to save/restore the physical timer context, something
  that we cannot do at the moment due to the lack of offsetting

- provide a framework that is suitable for NV support, where we get
  both global and per timer, per vcpu offsetting, and manage
  interrupts in a less braindead way.

We fix a couple of issues along the way, both from a stylistic and
correctness perspective. This results in a new per VM KVM API that
allows a global offset to be set at any point in time, overriding both
of the timer counter writebacks.

We also take this opportunity to rework the way IRQs are associated
with timers, something that was always a bit dodgy. This relies on a
new lock, which should disappear once Oliver's lock ordering series is
merged (we can reuse the config_lock for this).

This has been tested with nVHE, VHE and NV. I do not have access to
CNTPOFF-aware HW, but Colton managed to give it a go. Note that the
NV patches in this series are here to give a perspective on how this
gets used.

I've updated the arch_timer selftest to allow an offset to be provided
from the command line, and fixed a couple of glaring issues along the
way.

Note that this is at best 6.4 material. I have a branch stashed at [0]
and based on 6.3-rc3, as well as a minimal example of the use of the
API at [3] based on kvmtool.

Simon: I'd appreciate some feedback as whether this change fits your
requirements, given that you brought this up the first place.

Thanks,

	M.

* From v2 [2]:

  - Fixed 32bit handling of the physical counter when the offset is
    non-zero

  - Dropped unused -O option from the selftest

  - Added lockdep_assert_held() to (un)lock_all_vcpus()

  - Reordered the last two patches

  - Added Colton's RBs, with thanks

  - Dropped the initial patch which has been merged

  - Rebased on 6.3-rc3

* From v1 [1]:

  - Switched from a dual offset to a single one which gets applied to
    both virtual and physical counters. Which means that NV doesn't
    behave oddly anymore by ignoring the virtual offset.

  - Some cosmetic repainting of the UAPI symbols

  - Added patches to rework the IRQ mapping to timers

  - Patch #1 on its way to Paolo

  - Rebased on 6.3-rc1

[0] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/timer-vm-offsets
[1] https://lore.kernel.org/r/20230216142123.2638675-1-maz@kernel.org
[2] https://lore.kernel.org/r/20230313124837.2264882-5-maz@kernel.org
[3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/kvmtool.git/commit/?h=zero-offset&id=3b1253073ee57c0d92baf7b214362829b487b8d5

Marc Zyngier (18):
  KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for
    fractional ns
  arm64: Add CNTPOFF_EL2 register definition
  arm64: Add HAS_ECV_CNTPOFF capability
  KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
  KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
  KVM: arm64: Expose {un,}lock_all_vcpus() to the rest of KVM
  KVM: arm64: timers: Allow userspace to set the global counter offset
  KVM: arm64: timers: Allow save/restoring of the physical timer
  KVM: arm64: timers: Rationalise per-vcpu timer init
  KVM: arm64: timers: Abstract per-timer IRQ access
  KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
  KVM: arm64: Abstract the number of valid timers per vcpu
  KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
  KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
  KVM: arm64: nv: timers: Support hyp timer emulation
  KVM: arm64: selftests: Add physical timer registers to the sysreg list
  KVM: arm64: selftests: Deal with spurious timer interrupts
  KVM: arm64: selftests: Augment existing timer test to handle variable
    offset

 Documentation/virt/kvm/api.rst                |  38 ++
 arch/arm64/include/asm/kvm_host.h             |  13 +
 arch/arm64/include/asm/sysreg.h               |   2 +
 arch/arm64/include/uapi/asm/kvm.h             |  11 +
 arch/arm64/kernel/cpufeature.c                |  11 +
 arch/arm64/kvm/arch_timer.c                   | 539 ++++++++++++++----
 arch/arm64/kvm/arm.c                          |  53 ++
 arch/arm64/kvm/guest.c                        |  29 +-
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  18 +-
 arch/arm64/kvm/hypercalls.c                   |   2 +-
 arch/arm64/kvm/sys_regs.c                     |   9 +
 arch/arm64/kvm/trace_arm.h                    |   6 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  38 --
 arch/arm64/kvm/vgic/vgic.c                    |  15 +
 arch/arm64/kvm/vgic/vgic.h                    |   3 -
 arch/arm64/tools/cpucaps                      |   1 +
 arch/arm64/tools/sysreg                       |   4 +
 include/clocksource/arm_arch_timer.h          |   1 +
 include/kvm/arm_arch_timer.h                  |  36 +-
 include/kvm/arm_vgic.h                        |   1 +
 include/uapi/linux/kvm.h                      |   3 +
 .../selftests/kvm/aarch64/arch_timer.c        |  56 +-
 .../selftests/kvm/aarch64/get-reg-list.c      |   5 +-
 23 files changed, 690 insertions(+), 204 deletions(-)

-- 
2.34.1

