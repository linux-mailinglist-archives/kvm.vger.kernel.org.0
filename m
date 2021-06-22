Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63733B0BEE
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhFVSAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVSAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:12 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C58C061574
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:57:56 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id d7-20020ac811870000b02901e65f85117bso42710qtj.18
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=DkA0/jjoZwGMjmbN6Z4o2+YRGAWzKiVbZXoVPGRw3Go=;
        b=j3qgTaBd7ka6QYw6L4nf8svemOY7KqfCNEubLU+sYze3HXT3in6+N0QxU02KdWKC0/
         rW+MgcUwawYwDZSBQqzkEt+OO/EFLDkB6D7U/TZ/WdxkRb7U1GWT1YTKTu3Dhpkx4WpH
         96tEw0Sx4c+8LhMY3L2SpSZJ6Cp8d9saEbG3MV90hSm/oUZ+4D9BFqETnwsXA/SzNJKO
         I0pf9/dxdpXh548MzrxW0KT6IPNCSsoj5mB/349pskeFKJGzwtq0Ik42OXem+ira9ceb
         /to1YFMOLHiWW7Xs1xSFTXGiYI+1OD20yxnhTTZAjYa10cbugSGxPwZWTMMn8Iv386aX
         lQog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=DkA0/jjoZwGMjmbN6Z4o2+YRGAWzKiVbZXoVPGRw3Go=;
        b=nATXG7ytDFTBbIylIg9QbeAZfEqtWlkvctaFd/2M5yEQtetBopg/ZcL7qEKbHKQdor
         jqWScMJU12GD0rhNUZts+vBZ9BNQvzuGSXfOuAq67hj0ghB31CY3NZfGkVYlBAXkxk9b
         5XVm0c1vZG2XzzeFr37pNFt/YBbWA/ZxIqijQs+aQuLnjOrzWiUopCVqTQj0QCn01PGN
         cJhQnAxwniTgZUu6xfL7LT9lrf8+L47vUebBqy7AiosbAJDBfoR0Qlh9CFDy70yZlzSV
         jD44KW4zh0BVE28AuwDQR+HqB2sYEIsPf6+12RUFMXY3aJ/vaMYn8CJBmLwOoAFoRSTB
         kPng==
X-Gm-Message-State: AOAM532IboQWO/MNv9xR4F/AFRxmhfVXv68IjnEm0qHIPwuSCEePNmgt
        /iWskNi+ADvhToddzzQXpJyIa7T7Xyg=
X-Google-Smtp-Source: ABdhPJxWXMMj/yMTy2L31o20RZzUl4OsCCw4V/TvAxiXoaSmSxLKFfl7gIcLnLVDO24zwIUIBDNKMF2JPi0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:7287:: with SMTP id n129mr4835609ybc.99.1624384675786;
 Tue, 22 Jun 2021 10:57:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:45 -0700
Message-Id: <20210622175739.3610207-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I missed spring by a few days...

This gigantic snowball got rolling when I hit the WARN that guards against
setting bits 63:32 in SPTEs on 32-bit builds (patch 01).  The WARN is a
boneheaded mistake on my part as the whole point of EPT is to avoid the
mess that is IA32 paging.

I added a better variant to WARN if KVM attempts to set _any_ reserved bits
in its SPTEs (patch 48).  Unfortunately, the WARN worked too well and fired
on variety of configurations.  The patches in between are a mix of bug fixes,
cleanups, and documentation updates to get KVM to the point where the WARN
can be added without causing explosions, and to fix/document the numerous
issues/gotchas I found along the way.

The meat of this series is big refactoring of the MMU configuration code to
fix nested NPT, which I discovered after writing a test to exercise the
new reserved bit WARN.   With nested NPT, vCPU state is not guaranteed to
reflect vmcb01 state (though in practice the bug is limited to
KVM_SET_NESTED_STATE, i.e. live migration).  KVM passes in the L1 CR0, CR4,
and EFER values, which the MMU takes into consideration for the mmu_role
and then promptly ignores for all other calculations, e.g. reserved bits.

The approach for solving the nested NPT mess, and a variety of other minor
bugs of similar nature, is to take "all" state from the MMU context itself
instead of the vCPU.  None of the refactoring patches are particularly
interesting, there's just a lot of them because so much code uses the vCPU
instead of the correct state.

I have kvm-unit-tests for the SMEP, NX, and LA57 (my personal favorite) bugs
that I'll post separately.  Ditto for a selftest for recomputing the mmu_role
on CPUID updates.

I don't have a standalone test for nested NPT mmu_role changes; adding a
meaningful test mixed with KVM_SET_NESTED_STATE is a bigger lift.  To test
that mess, I randomized vCPU state prior to initializing the nested NPT MMU
and ran kvm-unit-tests.  E.g. Without the mmu_role changes this causes a
number of unit test failures:

	vcpu->arch.cr0 = get_random_long();
	vcpu->arch.cr4 = get_random_long();
	vcpu->arch.efer = get_random_long();

        kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
                                svm->vmcb01.ptr->save.efer,
                                svm->nested.ctl.nested_cr3);


Patch 01 is the only patch that is remotely 5.13 worthy, and even then
only because it's about as safe as a patch can be.  Everything else is far
from urgent as these bugs have existed for quite some time.

I labeled the "sections" of this mess in the shortlog below.

P.S. Does anyone know how PKRU interacts with NPT?  I assume/hope NPT
     accesses, which are always "user", ignore PKRU, but the APM doesn't
     say a thing.  If PKRU is ignored, KVM has some fixing to do.  If PKRU
     isn't ignored, AMD has some fixing to do :-)

P.S.S. This series pulled in one patch from my vCPU RESET/INIT series,
       "Properly reset MMU context at vCPU RESET/INIT", as that was needed
       to fix a root_level bug on VMX.  My goal is to get the RESET/INIT
       series refreshed later this week and thoroughly bombard everyone.


Sean Christopherson (54):

 -- bug fixes --
  KVM: x86/mmu: Remove broken WARN that fires on 32-bit KVM w/ nested
    EPT
  KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
  KVM: x86: Properly reset MMU context at vCPU RESET/INIT
  KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in nested NPT
    walk
  Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"
  KVM: x86: Force all MMUs to reinitialize if guest CPUID is modified
  KVM: x86: Alert userspace that KVM_SET_CPUID{,2} after KVM_RUN is
    broken
  Revert "KVM: MMU: record maximum physical address width in
    kvm_mmu_extended_role"
  KVM: x86/mmu: Unconditionally zap unsync SPs when creating >4k SP at
    GFN

 -- cleanups --
  KVM: x86/mmu: Replace EPT shadow page shenanigans with simpler check
  KVM: x86/mmu: WARN and zap SP when sync'ing if MMU role mismatches
  KVM: x86/mmu: Drop the intermediate "transient" __kvm_sync_page()
  KVM: x86/mmu: Rename unsync helper and update related comments

 -- bug fixes --
  KVM: x86: Fix sizes used to pass around CR0, CR4, and EFER
  KVM: nSVM: Add a comment to document why nNPT uses vmcb01, not vCPU
    state
  KVM: x86/mmu: Drop smep_andnot_wp check from "uses NX" for shadow MMUs
  KVM: x86: Read and pass all CR0/CR4 role bits to shadow MMU helper

 -- nested NPT / mmu_role refactoring --
  KVM: x86/mmu: Move nested NPT reserved bit calculation into MMU proper
  KVM: x86/mmu: Grab shadow root level from mmu_role for shadow MMUs
  KVM: x86/mmu: Add struct and helpers to retrieve MMU role bits from
    regs
  KVM: x86/mmu: Consolidate misc updates into shadow_mmu_init_context()
  KVM: x86/mmu: Ignore CR0 and CR4 bits in nested EPT MMU role
  KVM: x86/mmu: Use MMU's role_regs, not vCPU state, to compute mmu_role
  KVM: x86/mmu: Rename "nxe" role bit to "efer_nx" for macro shenanigans
  KVM: x86/mmu: Add helpers to query mmu_role bits
  KVM: x86/mmu: Do not set paging-related bits in MMU role if CR0.PG=0
  KVM: x86/mmu: Set CR4.PKE/LA57 in MMU role iff long mode is active
  KVM: x86/mmu: Always Set new mmu_role immediately after checking old
    role
  KVM: x86/mmu: Don't grab CR4.PSE for calculating shadow reserved bits
  KVM: x86/mmu: Use MMU's role to get CR4.PSE for computing rsvd bits
  KVM: x86/mmu: Drop vCPU param from reserved bits calculator
  KVM: x86/mmu: Use MMU's role to compute permission bitmask
  KVM: x86/mmu: Use MMU's role to compute PKRU bitmask
  KVM: x86/mmu: Use MMU's roles to compute last non-leaf level
  KVM: x86/mmu: Use MMU's role to detect EFER.NX in guest page walk
  KVM: x86/mmu: Use MMU's role/role_regs to compute context's metadata
  KVM: x86/mmu: Use MMU's role to get EFER.NX during MMU configuration
  KVM: x86/mmu: Drop "nx" from MMU context now that there are no readers
  KVM: x86/mmu: Get nested MMU's root level from the MMU's role
  KVM: x86/mmu: Use MMU role_regs to get LA57, and drop vCPU LA57 helper
  KVM: x86/mmu: Consolidate reset_rsvds_bits_mask() calls
  KVM: x86/mmu: Don't update nested guest's paging bitmasks if CR0.PG=0
  KVM: x86/mmu: Add helper to update paging metadata
  KVM: x86/mmu: Add a helper to calculate root from role_regs
  KVM: x86/mmu: Collapse 32-bit PAE and 64-bit statements for helpers
  KVM: x86/mmu: Use MMU's role to determine PTTYPE

 -- finally, the new WARN!
  KVM: x86/mmu: Add helpers to do full reserved SPTE checks w/ generic
    MMU
  KVM: x86/mmu: WARN on any reserved SPTE value when making a valid SPTE

 -- more cleanups --
  KVM: x86: Enhance comments for MMU roles and nested transition
    trickiness
  KVM: x86/mmu: Optimize and clean up so called "last nonleaf level"
    logic
  KVM: x86/mmu: Drop redundant rsvd bits reset for nested NPT
  KVM: x86/mmu: Get CR0.WP from MMU, not vCPU, in shadow page fault
  KVM: x86/mmu: Get CR4.SMEP from MMU, not vCPU, in shadow page fault

 -- RFC-ish "fix" --
  KVM: x86/mmu: Let guest use GBPAGES if supported in hardware and TDP
    is on


Sean Christopherson (54):
  KVM: x86/mmu: Remove broken WARN that fires on 32-bit KVM w/ nested
    EPT
  KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
  KVM: x86: Properly reset MMU context at vCPU RESET/INIT
  KVM: x86/mmu: Use MMU's role to detect CR4.SMEP value in nested NPT
    walk
  Revert "KVM: x86/mmu: Drop kvm_mmu_extended_role.cr4_la57 hack"
  KVM: x86: Force all MMUs to reinitialize if guest CPUID is modified
  KVM: x86: Alert userspace that KVM_SET_CPUID{,2} after KVM_RUN is
    broken
  Revert "KVM: MMU: record maximum physical address width in
    kvm_mmu_extended_role"
  KVM: x86/mmu: Unconditionally zap unsync SPs when creating >4k SP at
    GFN
  KVM: x86/mmu: Replace EPT shadow page shenanigans with simpler check
  KVM: x86/mmu: WARN and zap SP when sync'ing if MMU role mismatches
  KVM: x86/mmu: Drop the intermediate "transient" __kvm_sync_page()
  KVM: x86/mmu: Rename unsync helper and update related comments
  KVM: x86: Fix sizes used to pass around CR0, CR4, and EFER
  KVM: nSVM: Add a comment to document why nNPT uses vmcb01, not vCPU
    state
  KVM: x86/mmu: Drop smep_andnot_wp check from "uses NX" for shadow MMUs
  KVM: x86: Read and pass all CR0/CR4 role bits to shadow MMU helper
  KVM: x86/mmu: Move nested NPT reserved bit calculation into MMU proper
  KVM: x86/mmu: Grab shadow root level from mmu_role for shadow MMUs
  KVM: x86/mmu: Add struct and helpers to retrieve MMU role bits from
    regs
  KVM: x86/mmu: Consolidate misc updates into shadow_mmu_init_context()
  KVM: x86/mmu: Ignore CR0 and CR4 bits in nested EPT MMU role
  KVM: x86/mmu: Use MMU's role_regs, not vCPU state, to compute mmu_role
  KVM: x86/mmu: Rename "nxe" role bit to "efer_nx" for macro shenanigans
  KVM: x86/mmu: Add helpers to query mmu_role bits
  KVM: x86/mmu: Do not set paging-related bits in MMU role if CR0.PG=0
  KVM: x86/mmu: Set CR4.PKE/LA57 in MMU role iff long mode is active
  KVM: x86/mmu: Always Set new mmu_role immediately after checking old
    role
  KVM: x86/mmu: Don't grab CR4.PSE for calculating shadow reserved bits
  KVM: x86/mmu: Use MMU's role to get CR4.PSE for computing rsvd bits
  KVM: x86/mmu: Drop vCPU param from reserved bits calculator
  KVM: x86/mmu: Use MMU's role to compute permission bitmask
  KVM: x86/mmu: Use MMU's role to compute PKRU bitmask
  KVM: x86/mmu: Use MMU's roles to compute last non-leaf level
  KVM: x86/mmu: Use MMU's role to detect EFER.NX in guest page walk
  KVM: x86/mmu: Use MMU's role/role_regs to compute context's metadata
  KVM: x86/mmu: Use MMU's role to get EFER.NX during MMU configuration
  KVM: x86/mmu: Drop "nx" from MMU context now that there are no readers
  KVM: x86/mmu: Get nested MMU's root level from the MMU's role
  KVM: x86/mmu: Use MMU role_regs to get LA57, and drop vCPU LA57 helper
  KVM: x86/mmu: Consolidate reset_rsvds_bits_mask() calls
  KVM: x86/mmu: Don't update nested guest's paging bitmasks if CR0.PG=0
  KVM: x86/mmu: Add helper to update paging metadata
  KVM: x86/mmu: Add a helper to calculate root from role_regs
  KVM: x86/mmu: Collapse 32-bit PAE and 64-bit statements for helpers
  KVM: x86/mmu: Use MMU's role to determine PTTYPE
  KVM: x86/mmu: Add helpers to do full reserved SPTE checks w/ generic
    MMU
  KVM: x86/mmu: WARN on any reserved SPTE value when making a valid SPTE
  KVM: x86: Enhance comments for MMU roles and nested transition
    trickiness
  KVM: x86/mmu: Optimize and clean up so called "last nonleaf level"
    logic
  KVM: x86/mmu: Drop redundant rsvd bits reset for nested NPT
  KVM: x86/mmu: Get CR0.WP from MMU, not vCPU, in shadow page fault
  KVM: x86/mmu: Get CR4.SMEP from MMU, not vCPU, in shadow page fault
  KVM: x86/mmu: Let guest use GBPAGES if supported in hardware and TDP
    is on

 Documentation/virt/kvm/api.rst            |  11 +-
 Documentation/virt/kvm/mmu.rst            |   7 +-
 arch/x86/include/asm/kvm_host.h           |  71 ++-
 arch/x86/kvm/cpuid.c                      |   6 +-
 arch/x86/kvm/mmu.h                        |  18 +-
 arch/x86/kvm/mmu/mmu.c                    | 648 +++++++++++-----------
 arch/x86/kvm/mmu/mmu_internal.h           |   3 +-
 arch/x86/kvm/mmu/mmutrace.h               |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h            |  68 ++-
 arch/x86/kvm/mmu/spte.c                   |  22 +-
 arch/x86/kvm/mmu/spte.h                   |  32 ++
 arch/x86/kvm/svm/nested.c                 |  10 +-
 arch/x86/kvm/vmx/nested.c                 |   1 +
 arch/x86/kvm/x86.c                        |  26 +-
 arch/x86/kvm/x86.h                        |  10 -
 tools/lib/traceevent/plugins/plugin_kvm.c |   4 +-
 16 files changed, 530 insertions(+), 409 deletions(-)

-- 
2.32.0.288.g62a8d224e6-goog

