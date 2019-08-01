Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0877DADC
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 14:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfHAMEl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 1 Aug 2019 08:04:41 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41850 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfHAMEk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Aug 2019 08:04:40 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BE2F9285AA
        for <kvm@vger.kernel.org>; Thu,  1 Aug 2019 12:04:39 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id B184E2855D; Thu,  1 Aug 2019 12:04:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204401] New: After a VMexit, the guest is re-entring with a
 wrong vcpu PC address which is causing the guest to crash.
Date:   Thu, 01 Aug 2019 12:04:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: denis_roux_@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-204401-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=204401

            Bug ID: 204401
           Summary: After a VMexit, the guest is re-entring with a wrong
                    vcpu PC address which is causing the guest to crash.
           Product: Virtualization
           Version: unspecified
    Kernel Version: 4.19.26
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: denis_roux_@hotmail.com
        Regression: No

Created attachment 284069
  --> https://bugzilla.kernel.org/attachment.cgi?id=284069&action=edit
Fix applied to linux

guest crash:

ESF PC                 : 0x7004b528 ( (0x7004b4a4) + 0x84)
Exception Vec          : 1 (Undefined Instruction)
CPSR                   : 0x20000093
PE Mode             : Supervisor
Instruction         : A32
FIQ                 : Not Masked
IRQ                 : Masked
Async data abort    : Not Masked
Endianness          : little-endian
GE flag             : 0x0
Status flags        : nzCvq
SCTLR                  : 0x20C5183D
MMU                : Enabled
Alignment Check    : Disabled
Cache              : Enabled
CP15 barrier op    : Enabled
IT instr           : Enabled
SETEND instr       : Enabled
Instr cache        : Enabled
Vector address     : In VBAR
PL0 WFI            : Enabled
PL0 WFE            : Enabled
Exec at writable   : Allowed
Exec at unprivileged write: Allowed
Exec endianness    : Little-endian
TEX Remap          : Disabled
Access flag        : Enabled
Exception exc state: A32
TTBR0                  : 0x0000000072C56000
TTBR1                  : 0x0000000000000000
TCB PC                 : 0x7004b528 ( (0x7004b4a4) + 0x84)
TCB LR                 : 0x703f482c ( (0x703f26b4) + 0x2178)
TCB Registers          : r0 = 00000080 r1 = 00000086 r2 = 00000100 r3 =
89DA3500
                       : r4 = 70C085A0 r5 = 703F473C r6 = 001E83D7 r7 =
00000000
                       : r8 = 0F13B46A r9 = 00000000 r10= 703B8484 fp =
7260FCC4
                       : ip = 12200000 sp = 7260FCA0 lr = 703F482C pc =
7004B528


Guest assembly being execute leading to the crash:

0x7004b508 <+0x0064>: bc 00 c3 e1                       strh    r0, [r3, #12]  
                                      /* will cause a MMIO VMexit */
0x7004b50c <+0x0068>: 04 30 94 e5                       ldr    r3, [r4, #4]
0x7004b510 <+0x006c>: bc 10 c3 e1                       strh    r1, [r3, #12]  
                                      /* will cause a MMIO VMexit */
0x7004b514 <+0x0070>: 04 30 94 e5                       ldr    r3, [r4, #4]
0x7004b518 <+0x0074>: bc 20 c3 e1                       strh    r2, [r3, #12]  
                                      /* will cause a MMIO VMexit */
0x7004b51c <+0x0078>: f0 ab 9d e8                       ldm    sp, {r4, r5, r6,
r7, r8, r9, r11, sp, pc}   /* function return */
0x7004b520 <+0x007c>: 88 c7 03 70                       andvc    r12, r3, r8,
lsl #15                             /* Compiler generated data */
0x7004b524 <+0x0080>: 90 c8 03 70                       mulvc    r3, r0, r8    
                                       /* Compiler generated data */
0x7004b528 <+0x0084>: 3c 47 3f 70                       eorsvc    r4, pc, r12,
lsr r7    ; <UNPREDICTABLE> /* Compiler generated data */


Observed scenario on KVM:

    VM exit occured at vcpu PC 0x7004b518 (exit reason KVM_EXIT_MMIO)
    kvm_arch_vcpu_ioctl_run re-entered
    kvm_handle_mmio_return is executed to emulate the instruction at vcpu PC
0x7004b518. This is done successfully and vcpu PC is updated to 0x7004b51c.
    run->immediate_exit is checked and found to be set. It returns.
    kvm_arch_vcpu_ioctl_run re-entered
    kvm_handle_mmio_return is executed to emulate the instruction at vcpu PC
0x7004b518. This is done successfully and vcpu PC is updated to 0x7004b520.
    run->immediate_exit is checked but is not set.
    VM enter occurs with a corrupted vcpu PC which leads to the crash.

System information:
cpu model: ARMv7 Processor rev 4 (v7l)
Linux: 4.19.26
host kernel arch: arm
guest arch: arm
qemu cmd:qemu-system-arm -nographic -M virt -enable-kvm- cpu host ...

I have attached the patch that I have used to fix this issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
