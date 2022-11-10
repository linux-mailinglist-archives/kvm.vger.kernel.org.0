Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCF2624A13
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 20:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKJTDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 14:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKJTDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 14:03:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E1C32061
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 11:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2010B822E1
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 19:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAFCC433C1;
        Thu, 10 Nov 2022 19:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668106988;
        bh=kCyoC7Owlf6Rzfvz/B9oBU6dzXwkKh/MKTKr2w1oykQ=;
        h=From:To:Cc:Subject:Date:From;
        b=jsuupxlwK3KY/ceOwMtt2hRLQ4+AxO+Rgg8C39EyvKcAz7wOZ5MlAJI1zSxc7zKHD
         BjRIIxnjqEAzU++YCgqcoko092QW9j1p2r3TAhwe2q+xAzzQpNWEZm8mqlzcUjouEP
         iB7MOBnwsZT3RWas0X1IUstTYPFuFxL4BB2RC/nRboL5JrqV5xgdXHdaWoIA+D3MfT
         c420D0Hi6SmDKxv9F39LU1nJRs7nshTNFXnZLEUa2CZCzyN3OP9MUgOGGUS4j2bTz1
         kedIjSTLJpd7YjLhfEZfCJUfvU6kNgJeaLdFpq/SJA+YVwOGECkAO6RSpr2jU/DW2x
         kS1wVgowc7x5A==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 00/26] KVM: arm64: Introduce pKVM hyp VM and vCPU state at EL2
Date:   Thu, 10 Nov 2022 19:02:33 +0000
Message-Id: <20221110190259.26861-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This is version six of the pKVM EL2 state series, extending the pKVM
hypervisor code so that it can dynamically instantiate and manage VM
data structures without the host being able to access them directly.
These structures consist of a hyp VM, a set of hyp vCPUs and the stage-2
page-table for the MMU. The pages used to hold the hypervisor structures
are returned to the host when the VM is destroyed.

Previous versions are archived at:

  Mega-patch: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
  v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/
  v3: https://lore.kernel.org/kvmarm/20220914083500.5118-1-will@kernel.org/
  v4: https://lore.kernel.org/kvm/20221017115209.2099-1-will@kernel.org/
  v5: https://lore.kernel.org/r/20221020133827.5541-1-will@kernel.org

The changes since v5 include:

  * Fix teardown ordering so that the host 'kvm' structure remains pins
    while the memcache is being filled.

  * Fixed a kerneldoc typo.

  * Included a patch from Oliver to rework the 'pkvm_mem_transition'
    structure and it's handling of the completer address.

  * Tweaked some commit messages and added new R-b tags.

As before, the final patch is RFC since it illustrates a very naive use
of the new hypervisor structures and subsequent changes will improve on
this once we have the guest private memory story sorted out.

Oliver: I'm pretty sure we're going to need to revert your completer
address cleanup as soon as we have guest-host sharing. We want to keep
the 'pkvm_mem_transition' structure 'const', but we will only know the
host address (PA) after walking the guest stage-2 and so we're going to
want to track that separately. Anyway, I've included it here at the end
so Marc can decide what he wants to do!

Cheers,

Will, Quentin and Fuad

Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
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

Oliver Upton (1):
  KVM: arm64: Clean out the odd handling of completer_addr

Quentin Perret (14):
  KVM: arm64: Move hyp refcount manipulation helpers to common header
    file
  KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
  KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
  KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
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

Will Deacon (8):
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Rename 'host_kvm' to 'host_mmu'
  KVM: arm64: Initialise hypervisor copies of host symbols
    unconditionally
  KVM: arm64: Provide I-cache invalidation by virtual address at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()

 arch/arm64/include/asm/kvm_arm.h              |   2 +-
 arch/arm64/include/asm/kvm_asm.h              |   7 +-
 arch/arm64/include/asm/kvm_host.h             |  72 ++-
 arch/arm64/include/asm/kvm_hyp.h              |   3 +
 arch/arm64/include/asm/kvm_mmu.h              |   2 +-
 arch/arm64/include/asm/kvm_pgtable.h          |  22 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  61 +-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  27 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  68 +++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 110 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 558 +++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 168 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  29 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 436 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++-
 arch/arm64/kvm/hyp/pgtable.c                  |  21 +-
 arch/arm64/kvm/mmu.c                          |  55 +-
 arch/arm64/kvm/pkvm.c                         | 138 ++++-
 arch/arm64/kvm/reset.c                        |  29 -
 27 files changed, 1765 insertions(+), 261 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.38.1.431.g37b22c650d-goog

