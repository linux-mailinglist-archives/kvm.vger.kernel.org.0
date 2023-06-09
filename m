Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C907872A015
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbjFIQWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbjFIQWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276722D5F
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B11460FA6
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 16:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DF7C433D2;
        Fri,  9 Jun 2023 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686327730;
        bh=zMmxvGzDXTNMjhw5dTDc3LorMJo7C5rGh8NutswreXI=;
        h=From:To:Cc:Subject:Date:From;
        b=JthpAM9RM3WbmCm5mBXeS9o+6djxmNtljc2rBgGtPtzX8y8ec3/s1Sa9e43dq3NUJ
         ML8Wm5P15g61rQW7/O3Ezqh6xIRgWJTIsJ0stU6qpnVhOUf0/R0tL+HmwG/B4kVlWr
         zqnXiGZbiHvbVfWUszyMZRhtsdIFytO4WBpuEDorQ1+z9/qveeM98kIVStF1uCJTKx
         CmCV1/6TUBhKdxvxWpr6M7akm/6aGRXy7ZyBHD/6UnezwDVSmbTQ4+elt6jkWP2vIi
         G2EpL+6HsdrMNs6e5mRpHJAxXUNrhLZ1S3FLq2RT/uR5nwz8APHZqN0zRF2wI2ElQT
         V7F+H6Ez+qvCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q7esK-0048L7-AD;
        Fri, 09 Jun 2023 17:22:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH v3 00/17] KVM: arm64: Allow using VHE in the nVHE hypervisor
Date:   Fri,  9 Jun 2023 17:21:43 +0100
Message-Id: <20230609162200.2024064-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, qperret@google.com, will@kernel.org, tabba@google.com
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

KVM (on ARMv8.0) and pKVM (on all revisions of the architecture) use
the split hypervisor model that makes the EL2 code more or less
standalone. In the later case, we totally ignore the VHE mode and
stick with the good old v8.0 EL2 setup.

This is all good, but means that the EL2 code is limited in what it
can do with its own address space. This series proposes to remove this
limitation and to allow VHE to be used even with the split hypervisor
model. This has some potential isolation benefits[1], and eventually
allow systems that do not support HCR_EL2.E2H==0 to run pKVM.

We introduce a new "mode" for KVM called hVHE, in reference to the
nVHE mode, and indicating that only the hypervisor is using VHE. Note
that this is all this series does. No effort is made to improve the VA
space management, which will be the subject of another series if this
one ever makes it.

This has been tested on a M1 box (bare metal) as well as as a nested
guest on M2, both with the standard nVHE and protected modes, with no
measurable change in performance.

Note: the last patch of this series is not a merge candidate.

Thanks,

        M.

[1] https://www.youtube.com/watch?v=1F_Mf2j9eIo&list=PLbzoR-pLrL6qWL3v2KOcvwZ54-w0z5uXV&index=11

* From v2:
  - Use BUILD_BUG_ON() to prevent the use of is_kernel_in_hyp_mode()
    form hypervisor context
  - Validate that all CPUs are VHE-capable before flipping the
    capability

* From v1:
  - Fixed CNTHCTL_EL2 setup when switching from E2H=0 to E2H=1
    Amusingly, this was found on NV...
  - Rebased on 6.4-rc2

Marc Zyngier (17):
  KVM: arm64: Drop is_kernel_in_hyp_mode() from
    __invalidate_icache_guest_page()
  arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
  arm64: Turn kaslr_feature_override into a generic SW feature override
  arm64: Add KVM_HVHE capability and has_hvhe() predicate
  arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
  arm64: Allow EL1 physical timer access when running VHE
  arm64: Use CPACR_EL1 format to set CPTR_EL2 when E2H is set
  KVM: arm64: Remove alternatives from sysreg accessors in VHE
    hypervisor context
  KVM: arm64: Key use of VHE instructions in nVHE code off
    ARM64_KVM_HVHE
  KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
  KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
  KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
  KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration
  KVM: arm64: Program the timer traps with VHE layout in hVHE mode
  KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set
  arm64: Allow arm64_sw.hvhe on command line
  KVM: arm64: Terrible timer hack for M1 with hVHE

 arch/arm64/include/asm/arch_timer.h     |  8 ++++
 arch/arm64/include/asm/cpufeature.h     |  5 +++
 arch/arm64/include/asm/el2_setup.h      | 26 ++++++++++++-
 arch/arm64/include/asm/kvm_arm.h        |  4 +-
 arch/arm64/include/asm/kvm_asm.h        |  1 +
 arch/arm64/include/asm/kvm_emulate.h    | 33 +++++++++++++++-
 arch/arm64/include/asm/kvm_hyp.h        | 37 +++++++++++++-----
 arch/arm64/include/asm/kvm_mmu.h        |  3 +-
 arch/arm64/include/asm/virt.h           | 12 +++++-
 arch/arm64/kernel/cpufeature.c          | 21 +++++++++++
 arch/arm64/kernel/hyp-stub.S            | 10 ++++-
 arch/arm64/kernel/idreg-override.c      | 25 ++++++++-----
 arch/arm64/kernel/image-vars.h          |  3 ++
 arch/arm64/kernel/kaslr.c               |  6 +--
 arch/arm64/kvm/arch_timer.c             |  5 +++
 arch/arm64/kvm/arm.c                    | 12 +++++-
 arch/arm64/kvm/fpsimd.c                 |  4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  9 +++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 17 ++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 27 ++++++++++---
 arch/arm64/kvm/hyp/nvhe/switch.c        | 28 ++++++++------
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 25 +++++++++++--
 arch/arm64/kvm/hyp/pgtable.c            |  6 ++-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/sys_regs.c               |  2 +-
 arch/arm64/tools/cpucaps                |  1 +
 drivers/irqchip/irq-apple-aic.c         | 50 ++++++++++++++++++++++++-
 28 files changed, 320 insertions(+), 64 deletions(-)

-- 
2.34.1

