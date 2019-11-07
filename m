Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFCF3753
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 19:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfKGSfd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 7 Nov 2019 13:35:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfKGSfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 13:35:33 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205441] Enabling KVM causes any Linux VM reboot on kernel boot
Date:   Thu, 07 Nov 2019 18:35:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: t.lamprecht@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-205441-28872-sXzQULF0jR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205441-28872@https.bugzilla.kernel.org/>
References: <bug-205441-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205441

Thomas Lamprecht (t.lamprecht@proxmox.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |t.lamprecht@proxmox.com

--- Comment #1 from Thomas Lamprecht (t.lamprecht@proxmox.com) ---
We had some similar issues reported from our users (Proxmox VE), they had all
older Intel CPUs like you, and had issues with booting most types of Linux VMs.

I bisected this here, with following result:
git bisect log 
# bad: [3b931173c97b0d73f80ea55b72bb2966a246167f] UBUNTU: Ubuntu-5.0.0-33.35
# good: [5d5a6b36e94909962297fae609bff487de3cc43a] UBUNTU: Ubuntu-5.0.0-30.32
git bisect start '3b931173c97b0d73f80ea55b72bb2966a246167f'
'5d5a6b36e94909962297fae609bff487de3cc43a'
# good: [7b4f844b33969ab166800f8936beef153fab736e] net/ibmvnic: free reset work
of removed device from queue
git bisect good 7b4f844b33969ab166800f8936beef153fab736e
# bad: [6c1fc88702a4f33886b44ce5b6f374893b95e369] arm64: tlb: Ensure we execute
an ISB following walk cache invalidation
git bisect bad 6c1fc88702a4f33886b44ce5b6f374893b95e369
# good: [e627a027b54eccc95f9e374d69aead7f1498877b] loop: Add LOOP_SET_DIRECT_IO
to compat ioctl
git bisect good e627a027b54eccc95f9e374d69aead7f1498877b
# good: [29919eff6333bc67ec580b454afdd8b49883df2f] libata/ahci: Drop PCS quirk
for Denverton and beyond
git bisect good 29919eff6333bc67ec580b454afdd8b49883df2f
# good: [cb44193f94af73928f8df049ffbb6b4a0be136ae] PM / devfreq: passive: fix
compiler warning
git bisect good cb44193f94af73928f8df049ffbb6b4a0be136ae
# good: [b1d479b27b26966aea931094b31864979d7f8102] scsi: implement .cleanup_rq
callback
git bisect good b1d479b27b26966aea931094b31864979d7f8102
# bad: [ec15813844b05d8cbd4352c65a20e57d16f9f936] media: sn9c20x: Add MSI
MS-1039 laptop to flip_dmi_table
git bisect bad ec15813844b05d8cbd4352c65a20e57d16f9f936
# good: [e83601f51a90d9739ced9ff42b6f202f8f802c72] parisc: Disable HP HSC-PCI
Cards to prevent kernel crash
git bisect good e83601f51a90d9739ced9ff42b6f202f8f802c72
# good: [6d393bdf3b3f4b629070329488d3c6a3e142602b] KVM: x86: set
ctxt->have_exception in x86_decode_insn()
git bisect good 6d393bdf3b3f4b629070329488d3c6a3e142602b
# bad: [208007519a7385a57b0c0a3c180142a521594876] KVM: x86: Manually calculate
reserved bits when loading PDPTRS
git bisect bad 208007519a7385a57b0c0a3c180142a521594876
# first bad commit: [208007519a7385a57b0c0a3c180142a521594876] KVM: x86:
Manually calculate reserved bits when loading PDPTRS

Which is:

   KVM: x86: Manually calculate reserved bits when loading PDPTRS

    BugLink: https://bugs.launchpad.net/bugs/1848367

    commit 16cfacc8085782dab8e365979356ce1ca87fd6cc upstream.

    Manually generate the PDPTR reserved bit mask when explicitly loading
    PDPTRs.  The reserved bits that are being tracked by the MMU reflect the
    current paging mode, which is unlikely to be PAE paging in the vast
    majority of flows that use load_pdptrs(), e.g. CR0 and CR4 emulation,
    __set_sregs(), etc...  This can cause KVM to incorrectly signal a bad
    PDPTR, or more likely, miss a reserved bit check and subsequently fail
    a VM-Enter due to a bad VMCS.GUEST_PDPTR.

    Add a one off helper to generate the reserved bits instead of sharing
    code across the MMU's calculations and the PDPTR emulation.  The PDPTR
    reserved bits are basically set in stone, and pushing a helper into
    the MMU's calculation adds unnecessary complexity without improving
    readability.

    Oppurtunistically fix/update the comment for load_pdptrs().

    Note, the buggy commit also introduced a deliberate functional change,
    "Also remove bit 5-6 from rsvd_bits_mask per latest SDM.", which was
    effectively (and correctly) reverted by commit cd9ae5fe47df ("KVM: x86:
    Fix page-tables reserved bits").  A bit of SDM archaeology shows that
    the SDM from late 2008 had a bug (likely a copy+paste error) where it
    listed bits 6:5 as AVL and A for PDPTEs used for 4k entries but reserved
    for 2mb entries.  I.e. the SDM contradicted itself, and bits 6:5 are and
    always have been reserved.

    Fixes: 20c466b56168d ("KVM: Use rsvd_bits_mask in load_pdptrs()")
    Cc: stable@vger.kernel.org
    Cc: Nadav Amit <nadav.amit@gmail.com>
    Reported-by: Doug Reiland <doug.reiland@intel.com>
    Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
    Reviewed-by: Peter Xu <peterx@redhat.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Kamal Mostafa <kamal@canonical.com>
    Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>


This one is also included in the 4.19.81 (or more correctly, it's there since 
v4.19.77) with commit 496cf984a60edb5534118a596613cc9971e406e8 [0] or
upstream commit 16cfacc8085782dab8e365979356ce1ca87fd6cc [1].

[0]:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=v4.19.82&id=496cf984a60edb5534118a596613cc9971e406e8
[1]: https://git.kernel.org/torvalds/c/16cfacc8085782dab8e365979356ce1ca87fd6cc

Funny thing is: I cannot reproduce this with a 5.3.7 kernel, which _also_
includes above commit. So possible another patch is missing in the backport,
did not find anything obvious though...

So summary for reproducer:
* dust of an host with old Intel CPU, e.g.: Intel Core2Duo CPU E8500 @3.16GHz
  (something else westmer, conroe or the like should work too, or if it's
released
   over 10 years ago. 
* Install a Linux Distro or just boot the installer of that in a VM, I used
Debian 9,
  as our users had issues with that but not with an ubuntu 19.10 VM.
* see how it boot loops once a stable-kernel with above[0] backported
  is used on the host

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
