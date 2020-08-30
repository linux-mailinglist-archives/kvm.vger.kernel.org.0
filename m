Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6DC256EFE
	for <lists+kvm@lfdr.de>; Sun, 30 Aug 2020 17:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgH3PWK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 30 Aug 2020 11:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgH3PWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Aug 2020 11:22:07 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] New: CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Sun, 30 Aug 2020 15:22:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@martin.schrodt.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-209079-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209079

            Bug ID: 209079
           Summary: CPU 0/KVM: page allocation failure on 5.8 kernel
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.8.5-arch1-1
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: kernel@martin.schrodt.org
        Regression: No

When starting my KVM-VM in the current 5.8 kernel, it won't start, complaining:

> internal error: qemu unexpectedly closed the monitor:
> 2020-08-30T15:16:10.389012Z qemu-system-x86_64: kvm_init_vcpu failed: Cannot
> allocate memory

The same VM works fine in a 5.7 kernel. I tried an earlier 5.8 kernel too, same
outcome.

dmesg shows the following:

[Sun Aug 30 17:16:09 2020] CPU 0/KVM: page allocation failure: order:0,
mode:0x400cc4(GFP_KERNEL_ACCOUNT|GFP_DMA32),
nodemask=(null),cpuset=emulator,mems_allowed=1
[Sun Aug 30 17:16:09 2020] CPU: 11 PID: 16473 Comm: CPU 0/KVM Tainted: P       
   OE     5.8.5-arch1-1 #1
[Sun Aug 30 17:16:09 2020] Hardware name: To Be Filled By O.E.M. To Be Filled
By O.E.M./X399 Phantom Gaming 6, BIOS P1.10 11/15/2018
[Sun Aug 30 17:16:09 2020] Call Trace:
[Sun Aug 30 17:16:09 2020]  dump_stack+0x6b/0x88
[Sun Aug 30 17:16:09 2020]  warn_alloc.cold+0x78/0xdc
[Sun Aug 30 17:16:09 2020]  __alloc_pages_slowpath.constprop.0+0xd14/0xd50
[Sun Aug 30 17:16:09 2020]  __alloc_pages_nodemask+0x2e4/0x310
[Sun Aug 30 17:16:09 2020]  alloc_mmu_pages+0x27/0x90 [kvm]
[Sun Aug 30 17:16:09 2020]  kvm_mmu_create+0x100/0x140 [kvm]
[Sun Aug 30 17:16:09 2020]  kvm_arch_vcpu_create+0x48/0x360 [kvm]
[Sun Aug 30 17:16:09 2020]  kvm_vm_ioctl+0xa2d/0xe60 [kvm]
[Sun Aug 30 17:16:09 2020]  ksys_ioctl+0x82/0xc0
[Sun Aug 30 17:16:09 2020]  __x64_sys_ioctl+0x16/0x20
[Sun Aug 30 17:16:09 2020]  do_syscall_64+0x44/0x70
[Sun Aug 30 17:16:09 2020]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[Sun Aug 30 17:16:09 2020] RIP: 0033:0x7f4e8ba7cf6b
[Sun Aug 30 17:16:09 2020] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8
1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d5 ae 0c 00 f7 d8 64 89 01 48
[Sun Aug 30 17:16:09 2020] RSP: 002b:00007f4e6bffe6b8 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[Sun Aug 30 17:16:09 2020] RAX: ffffffffffffffda RBX: 000000000000ae41 RCX:
00007f4e8ba7cf6b
[Sun Aug 30 17:16:09 2020] RDX: 0000000000000000 RSI: 000000000000ae41 RDI:
0000000000000019
[Sun Aug 30 17:16:09 2020] RBP: 0000563079828020 R08: 0000000000000000 R09:
0000563079844010
[Sun Aug 30 17:16:09 2020] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[Sun Aug 30 17:16:09 2020] R13: 00007fff52f4494f R14: 0000000000000000 R15:
00007f4e6bfff640
[Sun Aug 30 17:16:09 2020] Mem-Info:
[Sun Aug 30 17:16:09 2020] active_anon:414866 inactive_anon:28099
isolated_anon:0
                            active_file:31776 inactive_file:88136
isolated_file:0
                            unevictable:32 dirty:521 writeback:0
                            slab_reclaimable:19827 slab_unreclaimable:137048
                            mapped:142120 shmem:28302 pagetables:6905 bounce:0
                            free:6992691 free_pcp:4628 free_cma:0

System is a Threadripper 1920x, on ASRock Phantom Gaming 6 X399 board with 32GB
RAM, which is a NUMA architecture, having 2 nodes

➜  numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 12 13 14 15 16 17
node 0 size: 15966 MB
node 0 free: 12860 MB
node 1 cpus: 6 7 8 9 10 11 18 19 20 21 22 23
node 1 size: 16112 MB
node 1 free: 14559 MB
node distances:
node   0   1 
  0:  10  16 
  1:  16  10 

The VM is configured to only allocate memory on node 1.

Happy to provide more information!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
