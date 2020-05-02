Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEF31C2450
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 11:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgEBJXW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 2 May 2020 05:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726745AbgEBJXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 05:23:22 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 207541] New: "BUG: stack guard page was hit" when starting a
 KVM-based VM
Date:   Sat, 02 May 2020 09:23:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: harn-solo@gmx.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207541-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207541

            Bug ID: 207541
           Summary: "BUG: stack guard page was hit" when starting a
                    KVM-based VM
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6.x, 5.7-rc3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: harn-solo@gmx.de
        Regression: No

Created attachment 288869
  --> https://bugzilla.kernel.org/attachment.cgi?id=288869&action=edit
dmesg part including call trace

Hi,

after upgrading the Kernel from 5.4.x to any 5.6.x or even a current RC-kernel
of the 5.7 series, I'm unable to start a KVM-based virtual machine. Shortly
after passing the ed2k-firmware boot stage the VM hangs and the kernel outputs
(see attached file for extended log output):

[   85.108980] BUG: stack guard page was hit at 0000000058db6ab1 (stack is
0000000033777485..00000000bcf1c827)
[   85.118710] kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
[   85.125141] CPU: 0 PID: 1843 Comm: qemu-system-x86 Not tainted 5.6.8 #1
[   85.131745] Hardware name: ASUS All Series/X99-E WS/USB 3.1, BIOS 3803
06/26/2018
[   85.139238] RIP: 0010:pic_update_irq+0x5/0x70 [kvm]
[   85.144111] Code: e2 fb 48 83 c2 18 48 39 d7 45 0f 44 c2 eb ae 31 f6 eb 9f
31 d2 eb cf 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 <53> 48 89
fb 48 83 c7 38 e8 2e ff ff ff 85 c0 79 29 48 8d 7b 18 e8
[   85.162848] RSP: 0018:ffffc90001dd8000 EFLAGS: 00010246
[   85.168066] RAX: 0000000000000020 RBX: 0000000000000000 RCX:
0000000000000020
[   85.175188] RDX: 00000000000000ff RSI: 0000000000000020 RDI:
ffff88881a0bf300
[   85.182313] RBP: 0000000000000005 R08: ffffc90001bad000 R09:
ffff88883927e000
[   85.189437] R10: 0000000000000000 R11: ffff888815f50000 R12:
00000000ffffffff
[   85.196561] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff88881a0bf300
[   85.203688] FS:  00007ffa9582bc40(0000) GS:ffff88884fa00000(0000)
knlGS:0000000000000000
[   85.211762] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   85.217501] CR2: ffffc90001dd7ff8 CR3: 0000000805b1e002 CR4:
00000000001626f0

This issue is reproducible. I've skipped kernel 5.5 entirely.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
