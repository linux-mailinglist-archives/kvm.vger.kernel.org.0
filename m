Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4E55B82EE
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiINIfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiINIfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E7319C3C
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2582BB8163C
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90887C433D6;
        Wed, 14 Sep 2022 08:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144509;
        bh=L+kprm4Q9rYkn3m6ysBnadSuKGcDhyyXkJgXLlOpf88=;
        h=From:To:Cc:Subject:Date:From;
        b=jMwmOaZh+d+C3vCF9cOQsps6vb/1uF5qnI292JuOO2zuSzC0ULnFLWtGoW8siDYQS
         Q+95NdGQt4uxN9YnwA5VJRDfKw0ci7sLN/Vs8R5EurZXjHsseotvcpKZL5zDDEVacW
         0FahD7MwRSflzCwTvbsamwrEDkIZBy+d17mwP8oEd2zusvwlLmGHhXH1Hc8BEanqrX
         78jqaTGo5oeP77xWdgu86+dLpZSgM0yjKDMax3NfCF/88iXEhRdoDrIQyN3kDro11F
         SSRJBeta1CqfFAzt6Q3fEetJiaNwt+clilowyS6vVzVAJwafQmkt+BvkRogzI3MLXJ
         kDJwmkpLNrovw==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
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
Subject: [PATCH v3 00/25] KVM: arm64: Introduce pKVM hyp VM and vCPU state at EL2
Date:   Wed, 14 Sep 2022 09:34:35 +0100
Message-Id: <20220914083500.5118-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

This is v3 of the series previously posted here:

  Mega-series: https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/
  v2: https://lore.kernel.org/all/20220630135747.26983-1-will@kernel.org/

There have been some significant changes since v2, including:

- Removal of unnecessary backpointer linking a hyp vCPU to its hyp VM in
  favour of container_of()

- Removing confusing use of 'shadow' at EL2 in favour of 'pkvm_hyp'
  (although this was much more work than a simple sed expression!)

- Simplified vm table lookup and removal of redundant table traversal

- Rework of the hypervisor fixmap to avoid redundant page-table walks

- Splitting of memory donations required to create a guest so that the
  requirement for physically-contiguous pages is reduced

- Fixed a memory leak when the stage-2 pgd is configured with an
  unsupported size

- Dropped rework of 'struct hyp_page' as it is not required by this
  series

- Improved commit messages

- Rebased onto v6.0-rc1

Oliver -- as discussed in person, I've left the owner ID enumeration
where it is for now since we will need to track the guest *instance* in
future and so consolidating this into the pgtable code is unlikely to be
beneficial.

As with the previous posting, the last patch is marked as RFC because,
although it plumbs in the shadow state, it is woefully inefficient and
copies to/from the host state on every vCPU run. Without the last patch,
the new structures are unused but we move considerably closer to
isolating guests from the host.

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
Cc: kvmarm@lists.cs.columbia.edu
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
 arch/arm64/include/asm/kvm_pgtable.h          |  20 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  61 ++-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  23 +
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
 27 files changed, 1752 insertions(+), 216 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.37.2.789.g6183377224-goog

