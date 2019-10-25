Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A723E50CA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504191AbfJYQHC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 25 Oct 2019 12:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfJYQHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 12:07:02 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205313] New: Machine check exception 90000040000f0005 and
 kernel panic
Date:   Fri, 25 Oct 2019 16:07:00 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: fintelia@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-205313-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205313

            Bug ID: 205313
           Summary: Machine check exception 90000040000f0005 and kernel
                    panic
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.15.0-generic and 5.3.7-arch1-1-ARCH
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: fintelia@gmail.com
        Regression: No

When trying to run certain builds of the sv6 research OS as a guest kernel
inside QEMU/KVM, the Linux *host* system reports some machine check exceptions
and then kernel panics. The same behavior happens on both a Skylake Laptop
running Arch (kernel 5.3.7-arch1-1-ARCH) and a Broadwell server running Ubuntu
18.04 (kernel 4.15.0-generic).

# Steps to reproduce

1) Download kernel.elf from
https://github.com/fintelia/sv6/releases/tag/mce-bug-2

2) Run `qemu-system-x86_64 -nographic -enable-kvm -cpu qemu64,+fsgsbase -kernel
kernel.elf`

3) Once the guest boots, execute "ls" 5-10 times in rapid succession.

4) Observe that the entire system stops responding, perhaps printing some error
messages about MCEs or kernel panics in the process.

# Example output

Running on a 4th Generation Lenovo X1 Carbon Laptop (with a i7-6600U) the
following errors are recorded in the system log:

Oct 24 10:42:14 jonathan-ThinkPad-X1-Carbon kernel: L1TF CPU bug present and
SMT on, data leak possible. See CVE-2018-3646 and
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for
details.
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon rasdaemon[614]: rasdaemon:
mce_record store: 0x56538e929050
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon kernel: mce_notify_irq: 1 callbacks
suppressed
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]:
Machine check events logged
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]: CPU
1: Machine Check: 0 Bank 0: 90000040000f0005
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]: TSC
a5db750d4d 
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]:
PROCESSOR 0:406e3 TIME 1571928139 SOCKET 0 APIC 2 microcode cc
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon rasdaemon[614]: rasdaemon: register
inserted at db
Oct 24 10:42:19 jonathan-ThinkPad-X1-Carbon rasdaemon[614]:            <...>-24
   [001]     0.000023: mce_record:           2019-10-24 10:42:19 -0400 bank=0,
status= 90000040000f0005, Internal parity error, mci=Corrected_error
Error_enabled, mca=Internal parity error, cpu_type= Intel generic architectural
MCA, cpu= 1, socketid= 0, mcgstatus=0, mcgcap= c08, apicid= 2
Oct 24 10:42:32 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]:
Machine check events logged
Oct 24 10:42:32 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]: CPU
1: Machine Check: 0 Bank 0: d0000040000f0005
Oct 24 10:42:32 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]: TSC
ae60fc6c1a 
Oct 24 10:42:32 jonathan-ThinkPad-X1-Carbon kernel: mce: [Hardware Error]:
PROCESSOR 0:406e3 TIME 1571928152 SOCKET 0 APIC 2 microcode cc


And afterwards there is a kernel panic that is printed to the screen but
doesn't seem to be recorded anywhere:

Kernel panic - not syncing: Timeout: Not all CPUs entered broadcast exception
handler
Shutting down cpus with NMI
Kernel Offset: 0x2bc00000 from 0xffffffff81000000 (relocation range:
0xffffffff80000000-0xffffffffbfffffff)
Rebooting in 30 seconds...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
