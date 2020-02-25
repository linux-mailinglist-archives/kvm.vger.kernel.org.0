Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC4F16BCA3
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgBYIx1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Feb 2020 03:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:51104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgBYIx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:53:26 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Tue, 25 Feb 2020 08:53:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: suravee.suthikulpanit@amd.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-7NrRNMltXC@https.bugzilla.kernel.org/>
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

--- Comment #21 from Suravee Suthikulpanit (suravee.suthikulpanit@amd.com) ---
Paolo/Muncrief,

I have also finally reproduce the issue (w/ -machine kernel_irqchip=off). The
the recommended changes (w/ if (!avic || !irqchip_in_kernel(svm->vcpu.kvm))
fixes the issue. Thanks for catching this.

Paolo, If the NULL pointer is due to:

    if (!svm->vcpu.arch.apic->regs)
        return -EINVAL;

Shouldn't we be checking the following instead:

    if (!avic || !lapic_in_kernel(&svm->vcpu))
        return 0;

This also works in my test.

Muncrief,

Besides enabling AVIC (modprobe kvm_amd avic=1), you can check to see if AVIC
is activated for the VM by running "perf kvm stat live" while running the VM
and see if there are any AVIC-related #vmexits (instead of vintr).

Thanks,
Suravee

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
