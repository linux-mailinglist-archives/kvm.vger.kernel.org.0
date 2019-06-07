Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DA039497
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbfFGSqs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 7 Jun 2019 14:46:48 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:59590 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbfFGSqs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jun 2019 14:46:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2A37428BAB
        for <kvm@vger.kernel.org>; Fri,  7 Jun 2019 18:46:48 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 1E9F028BA8; Fri,  7 Jun 2019 18:46:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203845] Can't run qemu/kvm on 5.0.0 kernel (NULL pointer
 dereference)
Date:   Fri, 07 Jun 2019 18:46:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203845-28872-3CSYX29XoN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203845-28872@https.bugzilla.kernel.org/>
References: <bug-203845-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203845

Sean Christopherson (sean.j.christopherson@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sean.j.christopherson@intel
                   |                            |.com

--- Comment #1 from Sean Christopherson (sean.j.christopherson@intel.com) ---
The EIP and code stream puts this at the following line in
mmu_alloc_direct_roots():

  vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;

The code in question is only encountered on a 32-bit KVM with two-dimensional
paging (TDP) is disabled, i.e. without AMD's Nested Page Tables, which fits
your setup (i686-pae on Athlon).  What I can't figure out is how pae_root would
be NULL in this scenario.  There is one flow that I think could theoretically
result in a NULL pae_root, but it would require using nested virtualization,
which doesn't seem to be the case here.

I tried to test my theory but running a 32-bit KVM without TDP just hangs for
me, i.e. it appears to be broken on Intel VMX at least as far back as v4.20.

What was the last kernel that did work on your system?  That might help narrow
down when things went awry.  In the meantime, I'll try to debug/bisect the
issue I'm seeing as time allows.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
