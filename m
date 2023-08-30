Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF7978D0F3
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 02:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbjH3AHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 20:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbjH3AGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 20:06:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB34ECC5
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b88decb2a9so4211425ad.0
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 17:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693354003; x=1693958803; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=m/iKMejfRl4CNs6mEKzijY4+ni0PyrhqvSi8dlfiRSA=;
        b=2XGtF+E4j7GdqiKMJABY8owChNTbGoTspgNJ8hdIK4OV/ZO2Bv8/fjKWFXEvyTtZAe
         mKb73q38zYqxv8eBM1u3IeeaKvAM2vR35PcI/SDI29pJcUK1MA9UwTMHu1UmrDNZ0V+6
         9GdtAnxduqRDvS6ow2E/xuTwerWWdYzjHGA2XTUzg1R8vi2/X+/Okl9C8cA68brbSyp5
         Ev+uCoWY1EXMI45JzK/lmqER1wrKcuct3ifelQt4GKKfA1gq84TKjz4DfR2PGsfTut8/
         jGFArSkWWCrJCMBCTE/jbij6V3vRvuMCPFB+m77SDmrM+XiHd1GfkIjXYy0t16iFb/JO
         ykOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693354003; x=1693958803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m/iKMejfRl4CNs6mEKzijY4+ni0PyrhqvSi8dlfiRSA=;
        b=IhsQ9KN4drIhymK/Uu1y/MVDwDSY9/T+lPY3EtI9s/jWWnxkQXfTrAtF+zOz49rmOf
         k8L6cGgSX77tIRT0KT+26tZthl6NCTSpadHsP/UhB+dPA7gsJiegkR7/vEbjPQGkJYk0
         TpMB1MUqB33fZ8l0eSefUh46ShehtvWAcjd28VssJdgmdNhs2SAPOeNSU/CXGGLPl4af
         JSwiGRp1MqNq+HAmKYn03zWH9jiobYIrb3mo78htUkweSGnN6Sy9nhkI93aVu11+d+jw
         oTQvgfMOUXXyaCUBBdTwfuYioWVwK6eA9kRuhRUWmyu9MEI+eIJ6u0En24qHYThGZArv
         YduA==
X-Gm-Message-State: AOJu0YzP7jlybu94mZVNQI9d1cqx44tq+yVwqDkAHvPm7PFKVrvyAwLa
        MfpsSKTM7wgnG0/Zhp+CEa1spOQmYKM=
X-Google-Smtp-Source: AGHT+IGn3h0MCH+5KOkSZZJqOD6n2T3JEDSmVzeBj6tadyC7eaeyBZ+pMV8NYhHx7myGoeuZ4NQWGxWN510=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f686:b0:1b7:f55e:4ab0 with SMTP id
 l6-20020a170902f68600b001b7f55e4ab0mr315966plg.0.1693354003339; Tue, 29 Aug
 2023 17:06:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 29 Aug 2023 17:06:29 -0700
In-Reply-To: <20230830000633.3158416-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230830000633.3158416-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230830000633.3158416-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.6
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull MMU changes for 6.6, with a healthy dose of KVMGT cleanups mixed in.
The other highlight is finally purging the old MMU_DEBUG code and replacing it
with CONFIG_KVM_PROVE_MMU.

All KVMGT patches have been reviewed/acked and tested by KVMGT folks.  A *huge*
thanks to them for all the reviews and testing, and to Yan in particular.

If you have time, please take a closer look at commit a328a359d99b ("KVM:
x86/mmu: Use dummy root, backed by zero page, for !visible guest roots"), it's
held up in (limited) testing, but I'd love more eyeballs on it.

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

  Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.6

for you to fetch changes up to bfd926291c585600ace63ea3b6eb1458aa067f4f:

  KVM: x86/mmu: Include mmu.h in spte.h (2023-08-25 09:03:51 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.6:

 - Rip out the ancient MMU_DEBUG crud and replace the useful bits with
   CONFIG_KVM_PROVE_MMU

 - Overhaul KVM's page-track APIs, and KVMGT's usage, to reduce the API surface
   that is needed by external users (currently only KVMGT), and fix a variety
   of issues in the process

 - Fix KVM's handling of !visible guest roots to avoid premature triple fault
   injection by loading a dummy root backed by the zero page

----------------------------------------------------------------
Like Xu (1):
      KVM: x86/mmu: Move the lockdep_assert of mmu_lock to inside clear_dirty_pt_masked()

Mingwei Zhang (1):
      KVM: x86/mmu: Plumb "struct kvm" all the way to pte_list_remove()

Sean Christopherson (42):
      KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
      KVM: x86/mmu: Delete pgprintk() and all its usage
      KVM: x86/mmu: Delete rmap_printk() and all its usage
      KVM: x86/mmu: Delete the "dbg" module param
      KVM: x86/mmu: Avoid pointer arithmetic when iterating over SPTEs
      KVM: x86/mmu: Cleanup sanity check of SPTEs at SP free
      KVM: x86/mmu: Rename MMU_WARN_ON() to KVM_MMU_WARN_ON()
      KVM: x86/mmu: Convert "runtime" WARN_ON() assertions to WARN_ON_ONCE()
      KVM: x86/mmu: Bug the VM if a vCPU ends up in long mode without PAE enabled
      KVM: x86/mmu: Replace MMU_DEBUG with proper KVM_PROVE_MMU Kconfig
      KVM: x86/mmu: Use BUILD_BUG_ON_INVALID() for KVM_MMU_WARN_ON() stub
      KVM: x86/mmu: BUG() in rmap helpers iff CONFIG_BUG_ON_DATA_CORRUPTION=y
      drm/i915/gvt: Verify pfn is "valid" before dereferencing "struct page"
      drm/i915/gvt: Verify hugepages are contiguous in physical address space
      drm/i915/gvt: Put the page reference obtained by KVM's gfn_to_pfn()
      drm/i915/gvt: Explicitly check that vGPU is attached before shadowing
      drm/i915/gvt: Error out on an attempt to shadowing an unknown GTT entry type
      drm/i915/gvt: Don't rely on KVM's gfn_to_pfn() to query possible 2M GTT
      drm/i915/gvt: Use an "unsigned long" to iterate over memslot gfns
      drm/i915/gvt: Drop unused helper intel_vgpu_reset_gtt()
      drm/i915/gvt: Protect gfn hash table with vgpu_lock
      KVM: x86/mmu: Move kvm_arch_flush_shadow_{all,memslot}() to mmu.c
      KVM: x86/mmu: Don't rely on page-track mechanism to flush on memslot change
      KVM: x86/mmu: Don't bounce through page-track mechanism for guest PTEs
      KVM: drm/i915/gvt: Drop @vcpu from KVM's ->track_write() hook
      KVM: x86: Reject memslot MOVE operations if KVMGT is attached
      drm/i915/gvt: Don't bother removing write-protection on to-be-deleted slot
      KVM: x86/mmu: Move KVM-only page-track declarations to internal header
      KVM: x86/mmu: Use page-track notifiers iff there are external users
      KVM: x86/mmu: Drop infrastructure for multiple page-track modes
      KVM: x86/mmu: Rename page-track APIs to reflect the new reality
      KVM: x86/mmu: Assert that correct locks are held for page write-tracking
      KVM: x86/mmu: Bug the VM if write-tracking is used but not enabled
      KVM: x86/mmu: Drop @slot param from exported/external page-track APIs
      KVM: x86/mmu: Handle KVM bookkeeping in page-track APIs, not callers
      drm/i915/gvt: Drop final dependencies on KVM internal details
      KVM: x86/mmu: Add helper to convert root hpa to shadow page
      KVM: x86/mmu: Harden new PGD against roots without shadow pages
      KVM: x86/mmu: Harden TDP MMU iteration against root w/o shadow page
      KVM: x86/mmu: Disallow guest from using !visible slots for page tables
      KVM: x86/mmu: Use dummy root, backed by zero page, for !visible guest roots
      KVM: x86/mmu: Include mmu.h in spte.h

Yan Zhao (5):
      drm/i915/gvt: remove interface intel_gvt_is_valid_gfn
      drm/i915/gvt: Don't try to unpin an empty page range
      KVM: x86: Add a new page-track hook to handle memslot deletion
      drm/i915/gvt: switch from ->track_flush_slot() to ->track_remove_region()
      KVM: x86: Remove the unused page-track hook track_flush_slot()

 arch/x86/include/asm/kvm_host.h       |  16 +-
 arch/x86/include/asm/kvm_page_track.h |  73 +++-----
 arch/x86/kvm/Kconfig                  |  13 ++
 arch/x86/kvm/mmu.h                    |   2 +
 arch/x86/kvm/mmu/mmu.c                | 319 ++++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h       |  24 +--
 arch/x86/kvm/mmu/page_track.c         | 258 +++++++++++++--------------
 arch/x86/kvm/mmu/page_track.h         |  58 +++++++
 arch/x86/kvm/mmu/paging_tmpl.h        |  41 +++--
 arch/x86/kvm/mmu/spte.c               |   6 +-
 arch/x86/kvm/mmu/spte.h               |  21 ++-
 arch/x86/kvm/mmu/tdp_iter.c           |  11 +-
 arch/x86/kvm/mmu/tdp_mmu.c            |  33 ++--
 arch/x86/kvm/x86.c                    |  22 +--
 drivers/gpu/drm/i915/gvt/gtt.c        | 102 ++---------
 drivers/gpu/drm/i915/gvt/gtt.h        |   1 -
 drivers/gpu/drm/i915/gvt/gvt.h        |   3 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 120 +++++--------
 drivers/gpu/drm/i915/gvt/page_track.c |  10 +-
 include/linux/kvm_host.h              |  19 ++
 20 files changed, 568 insertions(+), 584 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/page_track.h
