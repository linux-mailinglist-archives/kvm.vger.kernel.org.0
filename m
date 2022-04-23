Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D00250C700
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 05:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiDWDvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDWDvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83D1BD5C2
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:10 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so5810903plh.11
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=2/2IDHF+UQ6jtMwpPgf1EieaHKtX5K2WHMKeO5lYUGI=;
        b=DvXnKwIoXWz6M3dlxBDz90XEu6kkeG9Poa/DdzCukU8eLQg9ELHonSW/iSn0E4JdyB
         Vzki0sPVVNWPFUQMMJERlCaMbuBZpsroI6gX2DdUvwQgWTH8IL3N99rXFZCwkJ4Y+4S7
         GQz3wUz6o85hvT4qlvK8goOKRcKEjvTs9ZvWvKioKNSPZNrIkXWCOGP3XH9Ll4SxcPkA
         JX3IrF8n6freQhLljnVSyYC5whoLmm8eX4KguXzMHlMJrQ7fqwOGHB4DV2S6Do2oTZE+
         da7ftAY3+yE5RDqFSx+RX2L17+PDoDfhf/c4DYKfGefz9Lqz4B1s2TdueoOdPvnY2xzJ
         tABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=2/2IDHF+UQ6jtMwpPgf1EieaHKtX5K2WHMKeO5lYUGI=;
        b=ES58txGAt71ysztnF3E5OuqwueZXG9+oHZzBOKVwLwYLX/s+cVWMUREekFE/TY86aO
         7bZjiGPtc8DuMZUWUc1nDTXVh3ySp4yxYdOU5X0Dkqjme9PbeyKoKK+Wksi7P7fbsXru
         wQeqtFlTNMswXcrpEq9MloLbHljQmoQPkAb36AuYIA2W5ib5mdWHGBGGk7om9yE6p4Yx
         7dwRckDv/fDSOJcIVXUnyrfWrQIUxYykd9+hNyqcTOO5oREXaFkKQ+U0IfM75Z/YD7MI
         4BlqkebQJcaHjkRY/aLgpdBgI+Q7e1xz5en5kwAHaNPCYcJ9GE/BQ9Ju+9sOZiifFl7F
         oCTA==
X-Gm-Message-State: AOAM533QtLlHpB77YbG9upUpbcCAOUEUDkHx764PGbgj+noBqvvZye/C
        bvBpSC6yxFdS89oLRs2Cj9Og5uwX0gI=
X-Google-Smtp-Source: ABdhPJzPtbSgi0VvU/ry8YwZHeilStJR6BLJJsV0qncfT7FKVm86KwKHyoMdam99HekVC13FGk4zzC2hpMI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:1215:0:b0:39c:fa33:9427 with SMTP id
 h21-20020a631215000000b0039cfa339427mr6578042pgl.296.1650685690254; Fri, 22
 Apr 2022 20:48:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:40 +0000
Message-Id: <20220423034752.1161007-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 00/12] KVM: x86/mmu: Bug fixes and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This all started from an offhand comment wondering if we might be dropping
A/D bits.  Turns out, yes, we are dropping A/D bits (and W bits) in the
TDP MMU.

Attempting to prove that bug exposed two other notable goofs, the first of
which has been lurking for a decade, give or take:

  Patch 1 - KVM treats _all_ MMU-writable SPTEs as volatile, even though
            KVM never clears WRITABLE outside of MMU lock.  As a result,
            the legacy MMU (and the TDP MMU if not fixed) uses XCHG to
            update writable SPTEs.

  Patch 4 - KVM sends literally all EPT violations down the fast page
            fault handler.  The bug was introduced when KVM started
            honoring EPTP12's A/D enabling, circa 2016.

Neither fix seems to have an easily-measurable affect on performance;
page faults are so slow that wasting even a few hundred cycles is dwarfed
by the base cost.

The rest of the series is cleanups, including a v2 of my RET_PF_CONTINUE,
which would conflict in mildly annoying ways.

The first two "DO NOT MERGE" patches are effectively a PoC showing that
sending indirect MMUs down the fast page fault handler can work, it's
just ineffective.  I went down this rabbit hole after I saw a massive
performance drop in the legacy MMU from patch 3 and thought it might be due
to detecting spurious faults out of mmu_lock.  The TDP MMU didn't exhibit
the same problem, so it just _had_ to be write-contention on mmu_lock.
Right!?!?

Wrong. Turns out that spurious faults are a non-issue, but inverting the
"ad_disabled" flag in the shadow page role and preventing reuse?  Yep,
that's a wee bit of an issue.  I included the patches here to publicly
document that this has been tried, it works, it's just likely not a win.

The "DO NOT MERGE" selftest is my attempt to prove that the TDP MMU can
drop W/A/D bits.  It does work in the sense that it can trigger dropped
bits, but it's fairly worthless as a selftest because it requires an
explicit WARN in KVM :-/  Posted mostly as a reminder to myself that
the primary MMU write-protects on writeback (this isn't the first time
I've gone spelunking in that code...).

E.g. it can trigger the WARN on WRITABLE and DIRTY bits this patch on
top of the series:

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index f0af385c56e0..4f1ec56460ad 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -32,6 +32,8 @@ static inline void __kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 new_spte)
 static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
                                         u64 new_spte, int level)
 {
+       u64 current_spte;
+
        /*
         * Atomically write the SPTE if it is a shadow-present, leaf SPTE with
         * volatile bits, i.e. has bits that can be set outside of mmu_lock.
@@ -46,7 +48,13 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
         */
        if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
            spte_has_volatile_bits(old_spte))
-               return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
+               ;
+
+       current_spte = kvm_tdp_mmu_read_spte(sptep);
+       WARN_ONCE((old_spte ^ current_spte) & current_spte &
+                 (PT_WRITABLE_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK),
+                 "KVM: Dropped SPTE W/A/D bits: 0x%llx\n",
+                 (old_spte ^ current_spte) & current_spte);
 
        __kvm_tdp_mmu_write_spte(sptep, new_spte);
        return old_spte;

  ------------[ cut here ]------------
  KVM: Dropped SPTE W/A/D bits: 0x2
  WARNING: CPU: 5 PID: 874 at arch/x86/kvm/mmu/tdp_iter.h:56 __tdp_mmu_set_spte+0x18b/0x1a0 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 5 PID: 874 Comm: volatile_spte_t Not tainted 5.18.0-rc1+ #830
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__tdp_mmu_set_spte+0x18b/0x1a0 [kvm]
  Call Trace:
   <TASK>
   tdp_mmu_zap_leafs+0xbc/0x180 [kvm]
   kvm_tdp_mmu_zap_leafs+0x74/0x90 [kvm]
   kvm_unmap_gfn_range+0xe8/0x100 [kvm]
   kvm_mmu_notifier_invalidate_range_start+0x11c/0x2c0 [kvm]
   __mmu_notifier_invalidate_range_start+0x7e/0x190
   change_protection+0x657/0xb30
   mprotect_fixup+0x1a1/0x310
   do_mprotect_pkey+0x1f9/0x3a0
   __x64_sys_mprotect+0x1b/0x20
   do_syscall_64+0x31/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  ---[ end trace 0000000000000000 ]---


Sean Christopherson (12):
  KVM: x86/mmu: Don't treat fully writable SPTEs as volatile (modulo
    A/D)
  KVM: x86/mmu: Move shadow-present check out of
    spte_has_volatile_bits()
  KVM: x86/mmu: Use atomic XCHG to write TDP MMU SPTEs with volatile
    bits
  KVM: x86/mmu: Don't attempt fast page fault just because EPT is in use
  KVM: x86/mmu: Drop exec/NX check from "page fault can be fast"
  KVM: x86/mmu: Add RET_PF_CONTINUE to eliminate bool+int* "returns"
  KVM: x86/mmu: Make all page fault handlers internal to the MMU
  KVM: x86/mmu: Use IS_ENABLED() to avoid RETPOLINE for TDP page faults
  KVM: x86/mmu: Expand and clean up page fault stats
  DO NOT MERGE: KVM: x86/mmu: Always send !PRESENT faults down the fast
    path
  DO NOT MERGE: KVM: x86/mmu: Use fast_page_fault() to detect spurious
    shadow MMU faults
  DO NOT MERGE: KVM: selftests: Attempt to detect lost dirty bits

 arch/x86/include/asm/kvm_host.h               |   5 +
 arch/x86/kvm/mmu.h                            |  87 --------
 arch/x86/kvm/mmu/mmu.c                        | 211 ++++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h               | 123 +++++++++-
 arch/x86/kvm/mmu/mmutrace.h                   |   1 +
 arch/x86/kvm/mmu/paging_tmpl.h                |  15 +-
 arch/x86/kvm/mmu/spte.c                       |  28 +++
 arch/x86/kvm/mmu/spte.h                       |  15 +-
 arch/x86/kvm/mmu/tdp_iter.h                   |  34 ++-
 arch/x86/kvm/mmu/tdp_mmu.c                    |  92 +++++---
 arch/x86/kvm/x86.c                            |  24 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../selftests/kvm/volatile_spte_test.c        | 208 +++++++++++++++++
 14 files changed, 600 insertions(+), 248 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/volatile_spte_test.c


base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

