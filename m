Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A051B8B0
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfEMOji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730144AbfEMOje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DESlR7182654;
        Mon, 13 May 2019 14:38:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=ifMnSLMpPWbgJn6YEl+7RVCx3XHk6F0JJYnRIh9GBh0=;
 b=tdbGd1yQvHkyjTMFuK6wI5Ue4qt+LydLnEpefsOEuKdFqRq2LdsItTl/KbdLv+S7hbhS
 ulYB/K/LXyUeE5ratgp+dTXWLygfGRss5HDsoxCIj/q7YkZKQxux7Fuey0v5dS2CWsqv
 hX4STOZNgSeQSWKhNZhMVldF5ghxJowWtWLEo0ZcvFdEgnX+/WaWFDHBw58vaBzb+fAm
 ngdYgKLaAne2EA57L4ckGaTlxl8dmhn5LBBR2OmjC3s5HKKO53JMFneOJrQFSPAov5gA
 r/8VgZZEGfrB+ci9xUw4EQYoIcbLzVW2GsjwXiR3GbhYOrch/pEC0tLSsVOnUVhraxje pQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfkrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:38:42 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ3022780;
        Mon, 13 May 2019 14:38:36 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 00/27] KVM Address Space Isolation
Date:   Mon, 13 May 2019 16:38:08 +0200
Message-Id: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series aims to introduce the concept of KVM address space isolation.
This is done as part of the upstream community effort to have exploit
mitigations for CPU info-leaks vulnerabilities such as L1TF. 

These patches are based on an original patches from Liran Alon, completed
with additional patches to effectively create KVM address space different
from the full kernel address space.

The current code is just an early POC, and it is not fully stable at the
moment (unfortunately you can expect crashes/hangs, see the "Issues"
section below). However I would like to start a discussion get feedback
and opinions about this approach.

Context
=======

The most naive approach to handle L1TF SMT-variant exploit is to just disable
hyper-threading. But that is not practical for public cloud providers. As a
second next best alternative, there is an approach to combine coscheduling
together with flushing L1D cache on every VMEntry. By coscheduling I refer
to some mechanism which on every VMExit from guest, kicks all sibling
hyperthreads from guest aswell.

However, this approach have some open issues:

1. Kicking all sibling hyperthreads for every VMExit have significant
   performance hit for some compute shapes (e.g. Emulated and PV).

2. It assumes only CPU core resource which could be leaked by some
   vulnerability is L1D cache. But future vulnerabilities may also be able
   to leak other CPU core resources. Therefore, we would prefer to have a
   mechanism which prevents these resources to be able to be loaded with
   sensitive data to begin with.

To better address (2), upstream community has discussed some mechanisms
related to reducing data that is mapped on kernel virtual address space.
Specifically:

a. XPFO: Removes from physmap pages that currently should only be accessed
   by userspace.

b. Process-local memory allocations: Allows having a memory area in kernel
   virtual address space that maps different content per-process. Then,
   allocations made on this memory area can be hidden from other tasks in
   the system running in kernel space. Most obvious use it to allocate
   there per-vCPU and per-VM KVM structures.

However, both (a)+(b) work in a black-list approach (where we decide which
data is considered dangerous and remove it from kernel virtual address
space) and don't address performance hit described at (1).


Proposal
========

To handle both these points, this series introduce the mechanism of KVM
address space isolation. Note that this mechanism completes (a)+(b) and
don't contradict. In case this mechanism is also applied, (a)+(b) should
still be applied to the full virtual address space as a defence-in-depth).

The idea is that most of KVM #VMExit handlers code will run in a special
KVM isolated address space which maps only KVM required code and per-VM
information. Only once KVM needs to architectually access other (sensitive)
data, it will switch from KVM isolated address space to full standard
host address space. At this point, KVM will also need to kick all sibling
hyperthreads to get out of guest (note that kicking all sibling hyperthreads
is not implemented in this serie).

Basically, we will have the following flow:

  - qemu issues KVM_RUN ioctl
  - KVM handles the ioctl and calls vcpu_run():
    . KVM switches from the kernel address to the KVM address space
    . KVM transfers control to VM (VMLAUNCH/VMRESUME)
    . VM returns to KVM
    . KVM handles VM-Exit:
      . if handling need full kernel then switch to kernel address space
      . else continues with KVM address space
    . KVM loops in vcpu_run() or return
  - KVM_RUN ioctl returns

So, the KVM_RUN core function will mainly be executed using the KVM address
space. The handling of a VM-Exit can require access to the kernel space
and, in that case, we will switch back to the kernel address space.

The high-level idea of how this is implemented is to create a separate
struct_mm for KVM such that a vCPU thread will switch active_mm between
it's original active_mm and kvm_mm when needed as described above. The
idea is very similar to how kernel switches between task active_mm and
efi_mm when calling EFI Runtime Services.

Note that because we use the kernel TLB Manager to switch between kvm_mm
and host_mm, we will effectively use TLB with PCID if enabled to make
these switches fast. As all of this is managed internally in TLB Manager's
switch_mm().


Patches
=======

The proposed patches implement the necessary framework for creating kvm_mm
and switching between host_mm and kvm_mm at appropriate times. They also
provide functions for populating the KVM address space, and implement an
actual KVM address space much smaller than the full kernel address space.

- 01-08: add framework for switching between the kernel address space and
  the KVM address space at appropriate times. Note that these patches do
  not create or switch the address space yet. Address space switching is
  implemented in patch 25.

- 09-18: add a framework for populating and managing the KVM page table;
  this also include mechanisms to ensure changes are effectively limited
  to the KVM page table and no change is mistakenly propagated to the
  kernel page table.

- 19-23: populate the KVM page table.

- 24: add page fault handler to handle and report missing mappings when
  running with the KVM address space. This is based on an original idea
  from Paul Turner.

- 25: implement the actual switch between the kernel address space and
  the KVM address space.

- 26-27: populate the KVM page table with more data.


If a fault occurs while running with the KVM address space, it will be
reported on the console like this:

[ 4840.727476] KVM isolation: page fault #0 (0) at fast_page_fault+0x13e/0x3e0 [kvm] on ffffea00005331f0 (0xffffea00005331f0)

If the KVM page_fault_stack module parameter is set to non-zero (that's
the default) then the stack of the fault will also be reported:

[ 5025.630374] KVM isolation: page fault #0 (0) at fast_page_fault+0x100/0x3e0 [kvm] on ffff88003c718000 (0xffff88003c718000)
[ 5025.631918] Call Trace:
[ 5025.632782]  tdp_page_fault+0xec/0x260 [kvm]
[ 5025.633395]  kvm_mmu_page_fault+0x74/0x5f0 [kvm]
[ 5025.644467]  handle_ept_violation+0xc3/0x1a0 [kvm_intel]
[ 5025.645218]  vmx_handle_exit+0xb9/0x600 [kvm_intel]
[ 5025.645917]  vcpu_enter_guest+0xb88/0x1580 [kvm]
[ 5025.646577]  kvm_arch_vcpu_ioctl_run+0x403/0x610 [kvm]
[ 5025.647313]  kvm_vcpu_ioctl+0x3d5/0x650 [kvm]
[ 5025.648538]  do_vfs_ioctl+0xaa/0x602
[ 5025.650502]  SyS_ioctl+0x79/0x84
[ 5025.650966]  do_syscall_64+0x79/0x1ae
[ 5025.651487]  entry_SYSCALL_64_after_hwframe+0x151/0x0
[ 5025.652200] RIP: 0033:0x7f74a2f1d997
[ 5025.652710] RSP: 002b:00007f749f3ec998 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 5025.653769] RAX: ffffffffffffffda RBX: 0000562caa83e110 RCX: 00007f74a2f1d997
[ 5025.654769] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
[ 5025.655769] RBP: 0000562caa83e1b3 R08: 0000562ca9b6fa50 R09: 0000000000000006
[ 5025.656766] R10: 0000000000000000 R11: 0000000000000246 R12: 0000562ca9b552c0
[ 5025.657764] R13: 0000000000801000 R14: 00007f74a59d4000 R15: 0000562caa83e110

This allows to find out what is missing in the KVM address space.


Issues
======

Limited tests have been done so far, and mostly with an empty single-vcpu
VM (i.e. qemu-system-i386 -enable-kvm -smp 1). Single-vcpu VM is able to
start and run a full OS but the system will eventually crash/hang at some
point. Multiple vcpus will crash/hang much faster.


Performance Impact
==================

As this is a RFC, the effective performance impact hasn't been measured
yet. Current patches introduce two additional context switches (kernel to
KVM, and KVM to kernel) on each KVM_RUN ioctl. Also additional context
switches are added if a VM-Exit has to be handled using the full kernel
address space.

I expect that the KVM address space can eventually be expanded to include
the ioctl syscall entries. By doing so, and also adding the KVM page table
to the process userland page table (which should be safe to do because the
KVM address space doesn't have any secret), we could potentially handle the
KVM ioctl without having to switch to the kernel pagetable (thus effectively
eliminating KPTI for KVM). Then the only overhead would be if a VM-Exit has
to be handled using the full kernel address space.


Thanks,

alex.

---

Alexandre Chartre (18):
  kvm/isolation: function to track buffers allocated for the KVM page
    table
  kvm/isolation: add KVM page table entry free functions
  kvm/isolation: add KVM page table entry offset functions
  kvm/isolation: add KVM page table entry allocation functions
  kvm/isolation: add KVM page table entry set functions
  kvm/isolation: functions to copy page table entries for a VA range
  kvm/isolation: keep track of VA range mapped in KVM address space
  kvm/isolation: functions to clear page table entries for a VA range
  kvm/isolation: improve mapping copy when mapping is already present
  kvm/isolation: function to copy page table entries for percpu buffer
  kvm/isolation: initialize the KVM page table with core mappings
  kvm/isolation: initialize the KVM page table with vmx specific data
  kvm/isolation: initialize the KVM page table with vmx VM data
  kvm/isolation: initialize the KVM page table with vmx cpu data
  kvm/isolation: initialize the KVM page table with the vcpu tasks
  kvm/isolation: KVM page fault handler
  kvm/isolation: initialize the KVM page table with KVM memslots
  kvm/isolation: initialize the KVM page table with KVM buses

Liran Alon (9):
  kernel: Export memory-management symbols required for KVM address
    space isolation
  KVM: x86: Introduce address_space_isolation module parameter
  KVM: x86: Introduce KVM separate virtual address space
  KVM: x86: Switch to KVM address space on entry to guest
  KVM: x86: Add handler to exit kvm isolation
  KVM: x86: Exit KVM isolation on IRQ entry
  KVM: x86: Switch to host address space when may access sensitive data
  KVM: x86: Optimize branches which checks if address space isolation
    enabled
  kvm/isolation: implement actual KVM isolation enter/exit

 arch/x86/include/asm/apic.h    |    4 +-
 arch/x86/include/asm/hardirq.h |   10 +
 arch/x86/include/asm/irq.h     |    1 +
 arch/x86/kernel/cpu/common.c   |    2 +
 arch/x86/kernel/dumpstack.c    |    1 +
 arch/x86/kernel/irq.c          |   11 +
 arch/x86/kernel/ldt.c          |    1 +
 arch/x86/kernel/smp.c          |    2 +-
 arch/x86/kvm/Makefile          |    2 +-
 arch/x86/kvm/isolation.c       | 1773 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h       |   40 +
 arch/x86/kvm/mmu.c             |    3 +-
 arch/x86/kvm/vmx/vmx.c         |  123 +++-
 arch/x86/kvm/x86.c             |   44 +-
 arch/x86/mm/fault.c            |   12 +
 arch/x86/mm/tlb.c              |    4 +-
 arch/x86/platform/uv/tlb_uv.c  |    2 +-
 include/linux/kvm_host.h       |    2 +
 include/linux/percpu.h         |    2 +
 include/linux/sched.h          |    6 +
 mm/memory.c                    |    5 +
 mm/percpu.c                    |    6 +-
 virt/kvm/arm/arm.c             |    4 +
 virt/kvm/kvm_main.c            |    4 +-
 24 files changed, 2051 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/kvm/isolation.c
 create mode 100644 arch/x86/kvm/isolation.h

