Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2AF175431
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 08:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCBHBE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 2 Mar 2020 02:01:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:32898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBHBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 02:01:04 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Mon, 02 Mar 2020 07:01:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-0iYAPtVarv@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #44 from muncrief (rmuncrief@humanavance.com) ---
(In reply to Paolo Bonzini from comment #43)
> Hey, this should fix the warning (not sure because it's untested and I'd
> wait for Suravee to confirm it's the intended behavior): ...
> 

Thanks Paolo. I assumed you meant "svm->avic_is_running == 1" because "is_run"
isn't defined, but along the way I could see that functions like
"avic_set_running" actually called "avic_vcpu_load" with "is_true" set to true.

So, being confused about the intended logic, I spent an interesting day trying
to figure out why the stack trace seemed to show "avic_vcpu_load" being called
by "kvm_vcpu_block", which didn't have any obvious calls to "avic_vcpu_load".

I don't know how to setup gdb to debug the kernel, and after doing a quick
search it looked pretty difficult, so I just used an old fashioned technique of
defining a global unsigned integer and setting/clearing tracking bits
throughout "kvm_vcpu_block" to trace the real time flow of the code. I then
output the bits from "avic_vcpu_load" when the error condition occurred so I
could see where "kvm_vcpu_block" was when the warning condition was triggered.

And what I found was that "avic_vcpu_load" is branched to after the
"schedule()" call in "kvm_vcpu_block". There's a for loop that executes
"prepare_to_swait_exclusive" and then "schedule()", and that's when
"avic_vcpu_load" is executed.

When I saw that I realized that tracking bits wouldn't do, as it appears to be
some kind of preemption issue. So I'm seriously thinking about setting up my
system for gdb kernel debugging because it really pissed me off that I couldn't
figure it out! :)

Anyway, yes, I'm crazy like that :) I spent the whole day sprinkling tracking
bits throughout the code and then recompiling the kernel over and over so I
could decipher real time code flow. Hey! Don't laugh! That's the way we used to
do it in the olden days ... :)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
