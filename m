Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34EE01A39D9
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 20:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDISdq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 9 Apr 2020 14:33:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgDISdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 14:33:45 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207177] New: KVM nested VMM direct MTF event injection fails
Date:   Thu, 09 Apr 2020 18:33:45 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dpreed@deepplum.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-207177-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207177

            Bug ID: 207177
           Summary: KVM nested VMM direct MTF event injection fails
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.5.11
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: dpreed@deepplum.com
        Regression: No

I'm writing a specialized VMM and debugging it under KVM (that is, a KVM
guest).
Both L0 host and its guest are running Fedora 31 kernel 5.5.11-200, FYI.

The VMM creates a VMCS and vmlaunch's it. If bit 27 of primary processor
controls is set, the first VMEXIT is indeed Exit Reason 37 (monitor trap
fault), as would be expected. No problem here.

However, in the Intel SDM volume 3C, Chapter 26.6.2,  there is another
documented way to *inject* a "one-time" MTF exit. To wit, "If the interruption
type in the VM-entry interruption-information field is 7 (other event) and the
vector field is 0, VM entry cases an MTF VM exit to be pending on the
instruction boundary following VM entry. See section 25.5.2 for the treatment
of pending MTF exits."

So repeat the experiment, but with the VMCS having bit 27 of the primary
processor controls clear, but with the entry interruption information field set
to 0x80000700, per the manual.
No VMEXIT happens, though other VMEXITS subsequent do happen. In other words,
the "injection method" fails.

I have tried the same identical binary on the same system as the guest Fedora
31, running on bare metal on the same hardware. The behavior is precisely as
documented in the Intel SDM section above.

So clearly the nested KVM mechanics do not properly handle the injection of an
MTF via the VM-entry interruption information field.

This is a useful feature, so I hope the bug will be fixed, allowing me to debug
my code under KVM.
Thanks.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
