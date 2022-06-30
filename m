Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2905D561CE7
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbiF3ONq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbiF3ONQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECCA3BF98
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B67C62167
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 13:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27CD8C34115;
        Thu, 30 Jun 2022 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656597477;
        bh=EmIexi1QObKgcY5NSLTUwRxnbbq8QcNM35kJH7r6kog=;
        h=From:To:Cc:Subject:Date:From;
        b=gwD/VFOti3HVCG3sv26GAdib8zxowDim9r5Hsgi8VjGDkqQjM223ZVFiUvIdAm+U8
         emwIv/DXD4n50fKJpc5H7vc9vkDHLIq4gvXoaqLuzt5Bjn563zMkXltiR1z6GuGJNP
         O/InJj9812Or+GtAWsCDoYW5zVna91Mok7MVBSGErs1K5laZvGwm43SsbhGiS/lByy
         RUdbuAmeujfMGm5W1R1fW7GGCyU7in3irEafqxhl7+vRZuX7PlmV9pm9+4qZBBMKkE
         mTxw7IMEyjGKNAwmzNBfFIK27scazKdFkF5V2OhZZYCHNtOLpL6iZqlHDx7+C1IsBg
         Kqxty3W6ToRUA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 00/24] KVM: arm64: Introduce pKVM shadow state at EL2
Date:   Thu, 30 Jun 2022 14:57:23 +0100
Message-Id: <20220630135747.26983-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi everyone,

This series has been extracted from the pKVM base support series (aka
"pKVM mega-patch") previously posted here:

  https://lore.kernel.org/kvmarm/20220519134204.5379-1-will@kernel.org/

Unlike that more comprehensive series, this one is fairly fundamental
and does not introduce any new ABI commitments, leaving questions
involving the management of guest private memory and the creation of
protected VMs for future work. Instead, this series extends the pKVM EL2
code so that it can dynamically instantiate and manage VM shadow
structures without the host being able to access them directly. These
shadow structures consist of a shadow VM, a set of shadow vCPUs and the
stage-2 page-table and the pages used to hold them are returned to the
host when the VM is destroyed.

The last patch is marked as RFC because, although it plumbs in the
shadow state, it is woefully inefficient and copies to/from the host
state on every vCPU run. Without the last patch, the new structures are
unused but we move considerably closer to isolating guests from the
host.

The series is based on Marc's rework of the flags
(kvm-arm64/burn-the-flags).

Feedback welcome.

Cheers,

Will, Quentin, Fuad and Marc

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Michael Roth <michael.roth@amd.com>
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
  KVM: arm64: Introduce shadow VM state at EL2
  KVM: arm64: Instantiate VM shadow data from EL1

Quentin Perret (15):
  KVM: arm64: Move hyp refcount manipulation helpers
  KVM: arm64: Allow non-coalescable pages in a hyp_pool
  KVM: arm64: Add flags to struct hyp_page
  KVM: arm64: Back hyp_vmemmap for all of memory
  KVM: arm64: Make hyp stage-1 refcnt correct on the whole range
  KVM: arm64: Implement do_donate() helper for donating memory
  KVM: arm64: Prevent the donation of no-map pages
  KVM: arm64: Add helpers to pin memory shared with hyp
  KVM: arm64: Add pcpu fixmap infrastructure at EL2
  KVM: arm64: Add generic hyp_memcache helpers
  KVM: arm64: Instantiate guest stage-2 page-tables at EL2
  KVM: arm64: Return guest memory from EL2 via dedicated teardown
    memcache
  KVM: arm64: Unmap kvm_arm_hyp_percpu_base from the host
  KVM: arm64: Explicitly map kvm_vgic_global_state at EL2
  KVM: arm64: Don't map host sections in pkvm

Will Deacon (6):
  KVM: arm64: Unify identifiers used to distinguish host and hypervisor
  KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
  KVM: arm64: Initialise hyp symbols regardless of pKVM
  KVM: arm64: Provide I-cache invalidation by VA at EL2
  KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
  KVM: arm64: Use the shadow vCPU structure in handle___kvm_vcpu_run()

 arch/arm64/include/asm/kvm_asm.h              |   6 +-
 arch/arm64/include/asm/kvm_host.h             |  65 +++
 arch/arm64/include/asm/kvm_hyp.h              |   3 +
 arch/arm64/include/asm/kvm_pgtable.h          |   8 +
 arch/arm64/include/asm/kvm_pkvm.h             |  38 ++
 arch/arm64/kernel/image-vars.h                |  15 -
 arch/arm64/kvm/arm.c                          |  40 +-
 arch/arm64/kvm/hyp/hyp-constants.c            |   3 +
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |   6 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  19 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  26 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  70 +++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h    |  10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S               |  11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 105 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c             |   2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 456 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 136 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          |  42 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 438 +++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  96 ++--
 arch/arm64/kvm/hyp/pgtable.c                  |   9 +
 arch/arm64/kvm/mmu.c                          |  26 +
 arch/arm64/kvm/pkvm.c                         | 121 ++++-
 25 files changed, 1625 insertions(+), 144 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h

-- 
2.37.0.rc0.161.g10f37bed90-goog

