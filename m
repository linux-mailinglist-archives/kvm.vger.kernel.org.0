Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2184B2DC7EF
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgLPUub convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 16 Dec 2020 15:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgLPUua (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 15:50:30 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Wed, 16 Dec 2020 20:49:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210695-28872-EwxlIyQfIA@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210695-28872@https.bugzilla.kernel.org/>
References: <bug-210695-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210695

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
Aha!  I haven't reproduce the bug (mostly because I'm pretty sure my guests
aren't doing emulated MMIO accesses with paging disabled), but I'm pretty sure
I know what's going on, and why -rc4 may have worked.

Your guest has paging disabled, in which case mmu->root_level will be '0' and
mmu->shadow_root_level will be '3'.  If the shadow walk in get_walk() bails
without ever entering the loop (due to an invalid PAE root), the returned leaf
will be '0' because get_walk() uses mmu->root level instead of mmu->shadow_root
level.  In get_mmio_spte(), this causes the check for reserved bits to check
uninitialized/stale stack memory and return a bogus SPTE.

Pre rc6, both get_mmio_spte() and get_walk() used the bad mmu->root_level,
which meant that the reserved bits check would get skipped in the above
scenario.  But, get_mmio_spte() would still return a stale/bogus SPTE, so it's
not at all surprising that things failed.  Actually, it's surprising that any
5.10-rc* work.  Best guess is that there is a mostly unrelated change that
cause things to work by sheer dumb luck.

In rc6, the get_mmio_spte() half of the bug was fixed by commit 9a2a0d3ca163
("kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting 5-level PT").  This
cause get_mmio_spte() to resume the reserved bits check, which all but
guaranteed an explosion, i.e. ensured a 100% failure rate on your end.

TL;DR: Can you try this patch?  I'll also try to reproduce the original bug on
my end now that I have a smoking gun.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a6ae9e90bd7..6880119840c1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3488,7 +3488,7 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64
addr, bool direct)
 static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
        struct kvm_shadow_walk_iterator iterator;
-       int leaf = vcpu->arch.mmu->root_level;
+       int leaf = vcpu->arch.mmu->shadow_root_level;
        u64 spte;

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
