Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A1726164F
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgIHRIn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 8 Sep 2020 13:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbgIHRIQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 13:08:16 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209155] KVM Linux guest with more than 1 CPU panics after
 commit 404d5d7bff0d419fe11c7eaebca9ec8f25258f95 on old CPU (Phenom x4)
Date:   Tue, 08 Sep 2020 17:08:14 +0000
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
Message-ID: <bug-209155-28872-1ZSa3F4n9U@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209155-28872@https.bugzilla.kernel.org/>
References: <bug-209155-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209155

Sean Christopherson (sean.j.christopherson@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sean.j.christopherson@intel
                   |                            |.com

--- Comment #8 from Sean Christopherson (sean.j.christopherson@intel.com) ---
From code inspection, I'm 99% confident the immediate bug is that svm->next_rip
is reset in svm_vcpu_run() only after calling svm_exit_handlers_fastpath(),
which will cause SVM's skip_emulated_instruction() to write a stale RIP.  I
don't have AMD hardware to confirm, but this should be reproducible on modern
CPUs by loading kvm_amd with nrips=0.

That issue is easy enough to resolve, e.g. simply hoist "svm->next_rip = 0;" up
above the fastpath handling.  But, there are additional complications with
advancing rip in the fastpath as svm_complete_interrupts() consumes rip, e.g.
for NMI unmasking logic and event reinjection.  Odds are that NMI unmasking
will never "fail" as it would require the new rip to match the last IRET rip,
which would be very bizarre.  Similarly, event reinjection should also be a
non-issue in practice as the WRMSR fastpath shouldn't be reachable if KVM was
injecting an event.

All the being said, IMO, the safest play would be to first yank out the call to
handle_fastpath_set_msr_irqoff() in svm_exit_handlers_fastpath() to ensure a
clean base and to provide a safe backport patch, then move
svm_complete_interrupts() into svm_vcpu_run(), and finally move the call to
svm_exit_handlers_fastpath() down a ways and reenable
handle_fastpath_set_msr_irqoff().  Aside from resolving weirdness with rip and
fastpath, it would also align VMX and SVM with respect to completing
interrupts.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
