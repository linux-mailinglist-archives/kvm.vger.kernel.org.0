Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB03D600E23
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiJQLwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJQLwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AD52AF6
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D53761059
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67715C433D6;
        Mon, 17 Oct 2022 11:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007542;
        bh=Agj2ydyGb7Qw6DHm3okfH7eFFMNUSbdiqhNp1y5awkk=;
        h=From:To:Cc:Subject:Date:From;
        b=IlLqhrzCc89+oU47Thh5Ldinei61r0KRjREeJH1vovec2TsHvZYk5GHAiSnpExOnG
         MQkTXmxX8MvB9C+UZSF/MsRNFQpYPI3UCYp9rHACATnysPhvCyADu2ZcO/eN5jHcAp
         4/tByLpRnO8riY26KQOmQge0ZLA2phOcPIIOVOMwRmxTcaXWkjNQaEZJ28ZDFd7tV5
         1vmApOOGPCDPrxyV9Ayvwey0Vu88gG3oemr/YbVViEk9yoBzL0RL1w4PYpxZDyatnl
         bp5jkYVr02L48UXqMveF5goIS5KpsKk5BdMu/Of1ed3y/E4cCYLeOQOYp2ol6172Y1
         zyu2VqFx4QG/Q==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 00/25] KVM: arm64: Introduce pKVM hyp VM and vCPU state at EL2
Date:   Mon, 17 Oct 2022 12:51:44 +0100
Message-Id: <20221017115209.2099-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

This is version four of the patches previously posted at:

  Mega-patch: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
  v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
  v3: https://lore.kernel.org/kvmarm/20220914083500.5118-1-will@kernel.org/

This series extends the pKVM EL2 code so that it can dynamically
instantiate and manage VM data structures without the host being able to
access them directly. These structures consist of a hyp VM, a set of hyp
vCPUs and the stage-2 page-table for the MMU. The pages used to hold the
hypervisor structures are returned to the host when the VM is destroyed.

There are only a few small changes for v4:

  * Fixed missing cache maintenance when reclaiming guest pages on a system
    with the FWB ("Force WriteBack") CPU feature
  * Added a comment about locking requirements for refcount manipulation
  * Fixed a kbuild robot complaint when using 52-bit physical addresses
  * Added Vincent's Tested-by for the series
  * Added Oliver's Reviewed-by for the first patch
  * Rebased onto 6.1-rc1

One big change since v3 is that Quentin's pKVM "technical deep dive" talk
from this year's KVM forum is now online and hopefully provides an
enjoyable narrative to this series:

  https://www.youtube.com/watch?v=9npebeVFbFw

There are still a bunch of extra patches needed to achieve guest/host
isolation, but that follow-up work is largely stalled pending resolution
of the guest private memory API (although KVM forum provided an
excellent venue to iron some of those details out!):

  https://lore.kernel.org/kvm/20220915142913.2213336-1-chao.p.peng@linux.intel.com/T/#t

The last patch remains "RFC" as it's primarily intended for testing and
I couldn't think of a better way to flag it.

Cheers,

Will, Quentin, Fuad and Marc

Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>

Cc: kernel-team@android.com
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org

--->8

Fuad Tabba (3):
  KVM: arm64: Add hyp_spinlock_t static initializer
  KVM: arm64: Add infrastructure to create and track pKVM instances at
    EL2
  KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from
    EL1

Quentin Perret (15):
  KVM: arm64: Move hyp refcount manipulation helpers to common header
    file
  KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
  KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
  KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Prevent the donation of no-map pages
  KVM: arm64: Add helpers to pin memory shared with the hypervisor at
    EL2
  KVM: arm64: Add per-cpu fixmap infrastructure at EL2
  KVM: arm64: Add generic hyp_memcache helpers
  KVM: arm64: Consolidate stage-2 initialisation into a single function
  KVM: arm64: Instantiate guest stage-2 page-tables at EL2
  KVM: arm64: Return guest memory from EL2 via dedicated teardown
    memcache
  KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
  KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
  KVM: arm64: Don't unnecessarily map host kernel sections at EL2

Will Deacon (7):
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Rename 'host_kvm' to 'host_mmu'
  KVM: arm64: Initialise hypervisor copies of host symbols
    unconditionally
  KVM: arm64: Provide I-cache invalidation by virtual address at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_asm.h              |   7 +-
 arch/arm64/include/asm/kvm_host.h             |  73 ++-
 arch/arm64/include/asm/kvm_hyp.h              |   3 +
 arch/arm64/include/asm/kvm_mmu.h              |   2 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  22 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  61 ++-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  27 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  74 +++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 110 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 502 ++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 158 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  28 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 444 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/mmu.c                          |  55 +-
 arch/arm64/kvm/pkvm.c                         | 138 ++++-
 arch/arm64/kvm/reset.c                        |  29 -
 27 files changed, 1758 insertions(+), 216 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.38.0.413.g74048e4d9e-goog

