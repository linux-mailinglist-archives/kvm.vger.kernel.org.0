Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4B86ED397
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbjDXRft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjDXRfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:35:47 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3886A59
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:40 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-63b3bc3e431so3342820b3a.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682357739; x=1684949739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1ZG7Y8aMesDBQl1dxdm2cyjtH92cjPeWqpAkFL0j0Bs=;
        b=7ZGwPrjlZUNIlmESO+Vb8Vm6sSRNtsMtUPDeRiJKdsypgUtelpBiC7Z1eQxOEmtoDY
         CskLw/ZCMcUN4LTK8BLpDwPBL2gC2Mq/DNSSGNAJH7h2ggyHTro1I52vs7NHlrspxaKW
         2ENSXXA3H4aDCX4Geipr2+GEOdK80TuRX4orI0V+SRUIvbUyExkQZL9Z4zAdTrbPNPt5
         egJwFdvj6wqSKgeuQER9+ApHsuXG7ZXjWZroWYYZvDgSE9RF6JjJVueAo2YMuL4uvbbY
         ea0u9TYltz3gjxs2ht67nZPG04JnF2YZveGrOED6ydqd1CyYL/UF+oSRqmZkqjCPyNS8
         rR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682357739; x=1684949739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ZG7Y8aMesDBQl1dxdm2cyjtH92cjPeWqpAkFL0j0Bs=;
        b=OPZJ29/626VRa1FP0u0HHvGXmV7+yijEszaKPzOqK5C76JVwDlJwqmjM67eXDYIUeq
         PWI9hG+pGWTeX++aHO6hH13oqg5y+6GgSLCjeeaM0lxMqI7tLy9n/8Qsr1AHJPjgj1ti
         Js7rVjSb2f6/izly6lPOcwebb8rNMVD1z1SPvYZmCDbT7ZfVYT/ANxZNHxaYo03kwN34
         kCHhBzQb6JDRmnfbqwg6i8y2bL2VVLqhQIKq0xxfwkz0icNtsbI/V+8IPpg6k/X73Ma3
         neFtGZm84/rcHMh/YEAiR/cC20xsRC8KhF9jZ5my2gg+nXi/KpsXMNar9+QnRpjksRqk
         xxmw==
X-Gm-Message-State: AAQBX9c8PMvz0ks9TaPQ7GwGtGC8esZNFYRj4TDDDz58nqKzKs45i4K4
        iYrewGG2EDFoFB8IoaLzkJhoh1+Cx4M=
X-Google-Smtp-Source: AKy350Z9ltV7beVCXhGkNI+JKhWx701/IlC6N3reid23ei9vO1cvGGEhfRX5gwWpl389LbLjzARNG1dJzZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1913:b0:63d:259b:b5cd with SMTP id
 y19-20020a056a00191300b0063d259bb5cdmr6177731pfi.6.1682357739370; Mon, 24 Apr
 2023 10:35:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 24 Apr 2023 10:35:25 -0700
In-Reply-To: <20230424173529.2648601-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424173529.2648601-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86/mmu changes for 6.4.  The highlights are optimizations from Lai
(.invlpg(), .sync_page(), and rmaps) and Vipin (A/D harvesting).

I am also planning on sending the "persistent TDP MMU roots" patch[*] for
6.4-rc1, just waiting a few more days to give syzbot extra time to beat on
v2, and to settle on whether to guard VM desctruction with mmu_lock or RCU.

[*] https://lore.kernel.org/all/20230421214946.2571580-1-seanjc@google.com


The following changes since commit d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7:

  KVM: Change return type of kvm_arch_vm_ioctl() to "int" (2023-03-16 10:18:07 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.4

for you to fetch changes up to 9ed3bf411226f446a9795f2b49a15b9df98d7cf5:

  KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V code (2023-04-10 15:17:29 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.4:

 - Tweak FNAME(sync_spte) to avoid unnecessary writes+flushes when the
   guest is only adding new PTEs

 - Overhaul .sync_page() and .invlpg() to share the .sync_page()
   implementation, i.e. utilize .sync_page()'s optimizations when emulating
   invalidations

 - Clean up the range-based flushing APIs

 - Revamp the TDP MMU's reaping of Accessed/Dirty bits to clear a single
   A/D bit using a LOCK AND instead of XCHG, and skip all of the "handle
   changed SPTE" overhead associated with writing the entire entry

 - Track the number of "tail" entries in a pte_list_desc to avoid having
   to walk (potentially) all descriptors during insertion and deletion,
   which gets quite expensive if the guest is spamming fork()

 - Misc cleanups

----------------------------------------------------------------
David Matlack (3):
      KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}() together
      KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
      KVM: x86/mmu: Use gfn_t in kvm_flush_remote_tlbs_range()

Lai Jiangshan (14):
      KVM: x86/mmu: Use 64-bit address to invalidate to fix a subtle bug
      KVM: x86/mmu: Move the check in FNAME(sync_page) as kvm_sync_page_check()
      KVM: x86/mmu: Check mmu->sync_page pointer in kvm_sync_page_check()
      KVM: x86/mmu: Set mmu->sync_page as NULL for direct paging
      KVM: x86/mmu: Move the code out of FNAME(sync_page)'s loop body into mmu.c
      KVM: x86/mmu: Reduce the update to the spte in FNAME(sync_spte)
      kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_addr()
      KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in kvm_mmu_invpcid_gva()
      KVM: x86/mmu: Use kvm_mmu_invalidate_addr() in nested_ept_invalidate_addr()
      KVM: x86/mmu: Allow the roots to be invalid in FNAME(invlpg)
      KVM: x86/mmu: Remove FNAME(invlpg) and use FNAME(sync_spte) to update vTLB instead.
      kvm: x86/mmu: Remove @no_dirty_log from FNAME(prefetch_gpte)
      KVM: x86/mmu: Skip calling mmu->sync_spte() when the spte is 0
      KVM: x86/mmu: Track tail count in pte_list_desc to optimize guest fork()

Mathias Krause (1):
      KVM: x86/mmu: Fix comment typo

Paolo Bonzini (1):
      KVM: x86/mmu: Avoid indirect call for get_cr3

Sean Christopherson (6):
      KVM: x86/mmu: Sanity check input to kvm_mmu_free_roots()
      KVM: x86/mmu: Rename slot rmap walkers to add clarity and clean up code
      KVM: x86/mmu: Replace comment with an actual lockdep assertion on mmu_lock
      KVM: x86/mmu: Clean up mmu.c functions that put return type on separate line
      KVM: x86: Rename Hyper-V remote TLB hooks to match established scheme
      KVM: x86/mmu: Move filling of Hyper-V's TLB range struct into Hyper-V code

Vipin Sharma (13):
      KVM: x86/mmu: Add a helper function to check if an SPTE needs atomic write
      KVM: x86/mmu: Use kvm_ad_enabled() to determine if TDP MMU SPTEs need wrprot
      KVM: x86/mmu: Consolidate Dirty vs. Writable clearing logic in TDP MMU
      KVM: x86/mmu: Atomically clear SPTE dirty state in the clear-dirty-log flow
      KVM: x86/mmu: Drop access tracking checks when clearing TDP MMU dirty bits
      KVM: x86/mmu: Bypass __handle_changed_spte() when clearing TDP MMU dirty bits
      KVM: x86/mmu: Remove "record_dirty_log" in __tdp_mmu_set_spte()
      KVM: x86/mmu: Clear only A-bit (if enabled) when aging TDP MMU SPTEs
      KVM: x86/mmu: Drop unnecessary dirty log checks when aging TDP MMU SPTEs
      KVM: x86/mmu: Bypass __handle_changed_spte() when aging TDP MMU SPTEs
      KVM: x86/mmu: Remove "record_acc_track" in __tdp_mmu_set_spte()
      KVM: x86/mmu: Remove handle_changed_spte_dirty_log()
      KVM: x86/mmu: Merge all handle_changed_pte*() functions

 arch/x86/include/asm/kvm-x86-ops.h |   4 +-
 arch/x86/include/asm/kvm_host.h    |  32 +--
 arch/x86/kvm/kvm_onhyperv.c        |  33 ++-
 arch/x86/kvm/kvm_onhyperv.h        |   5 +-
 arch/x86/kvm/mmu/mmu.c             | 506 ++++++++++++++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h    |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h     | 224 +++++-----------
 arch/x86/kvm/mmu/spte.c            |   2 +-
 arch/x86/kvm/mmu/tdp_iter.h        |  48 +++-
 arch/x86/kvm/mmu/tdp_mmu.c         | 215 ++++++----------
 arch/x86/kvm/svm/svm_onhyperv.h    |   5 +-
 arch/x86/kvm/vmx/nested.c          |   5 +-
 arch/x86/kvm/vmx/vmx.c             |   5 +-
 arch/x86/kvm/x86.c                 |   4 +-
 14 files changed, 522 insertions(+), 574 deletions(-)
