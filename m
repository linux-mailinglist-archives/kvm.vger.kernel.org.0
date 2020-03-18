Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE6189931
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 11:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgCRKWa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 18 Mar 2020 06:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgCRKW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 06:22:29 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206877] New: Nested virt on AMD (and probably older Intel)
 doesn't work with ignore_msrs=Y on L0 (fails with UMWAIT error)
Date:   Wed, 18 Mar 2020 10:22:28 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: s.reiter@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-206877-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206877

            Bug ID: 206877
           Summary: Nested virt on AMD (and probably older Intel) doesn't
                    work with ignore_msrs=Y on L0 (fails with UMWAIT
                    error)
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6.0-rc6
          Hardware: i386
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: s.reiter@proxmox.com
        Regression: No

I'm not sure if this is a supported configuration, but since the commit
mentioned below nested virtualization on AMD when the host has 'ignore_msrs=Y'
is broken. QEMU fails with:

kvm: error: failed to set MSR 0xe1 to 0x0
kvm: /qemu/target/i386/kvm.c:2947: kvm_put_msrs: Assertion `ret ==
cpu->kvm_msr_buf->nmsrs' failed.

If this is supposed to work, it's a regression from 6e3ba4abcea5 ("KVM: vmx:
Emulate MSR IA32_UMWAIT_CONTROL"), I can confirm that reverting this commit for
the guest kernel makes everything work again. Ignoring UMWAIT in QEMU
(kvm_get_supported_msrs) does the trick too.

I *think* this happens since MSR_IA32_UMWAIT_CONTROL (in msrs_to_save_all) is
added to the guest CPUID with the only condition being that 'rdmsr_safe' in
'kvm_init_msr_list' succeeds - which it does, since the host ignores it.
However, since the CPU doesn't actually support UMWAIT (in my case since it's
an AMD chip, but I suppose the same happens on older Intel ones) the MSR set
for the L2 guest fails.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
