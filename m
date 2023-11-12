Return-Path: <kvm+bounces-1523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F338B7E8E2A
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 05:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A58280D9A
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 04:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C092D5397;
	Sun, 12 Nov 2023 04:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RBNnU8FI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF4A1C08
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 04:12:09 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F4E1718;
	Sat, 11 Nov 2023 20:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699762327; x=1731298327;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iEOr2OrU1YdYpZOVPnD+xp1YPUz1zCEO64hCQ7MYr1Y=;
  b=RBNnU8FItTcInJtsR4YRsM+tBH2WHyBx2AFlDeKOgsJlGgTU36XiPFhU
   Z7oDOFLsYiK3DB8c0n0iOZaI5QToTHhmDv1AwC/LLFM6Rq6cirycMh6MW
   /h/a0VDLB8aI6T9V3qE/TJG/dn6YZII/bsE8l4PN4fmcJn912fZwzIQrb
   Y+GjGR6XTKJ/SVOimREW4toSY8KiABPEjImf6yzSSZ0ICZumFP1XGT+0d
   FgGiH0FP/D5HlhkHIhF8hV6PS7D8mg5o0SnLo062f1MoQRY59iDejQSyL
   U11m/6LELlL6XOz5HFFrDlvhhwUzBknxJfkbpbLVYpvBQ2uD9cLg3S69x
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="476533834"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="476533834"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 20:12:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="713936733"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="713936733"
Received: from srinivas-otcpl-7600.jf.intel.com (HELO jacob-builder.jf.intel.com) ([10.54.39.116])
  by orsmga003.jf.intel.com with ESMTP; 11 Nov 2023 20:12:06 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	peterz@infradead.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH RFC 00/13] Coalesced Interrupt Delivery with posted MSI
Date: Sat, 11 Nov 2023 20:16:30 -0800
Message-Id: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Thomas and all,

This patch set is aimed to improve IRQ throughput on Intel Xeon by making use of
posted interrupts.

There is a session at LPC2023 IOMMU/VFIO/PCI MC where I will present this
topic. I get this RFC code out for review and discussion but some work is still
in progress.

https://lpc.events/event/17/sessions/172/#20231115

Background
==========
On modern x86 server SoCs, interrupt remapping (IR) is required and turned
on by default to support X2APIC. Two interrupt remapping modes can be supported
by IOMMU:

- Remappable 	(host)
- Posted	(guest only so far)

With remappable mode, the device MSI to CPU process is a HW flow without system
software touch points, it roughly goes as follows:

1.	Devices issue interrupt requests with writes to 0xFEEx_xxxx
2.	The system agent accepts and remaps/translates the IRQ
3.	Upon receiving the translation response, the system agent notifies the
destination CPU with the translated MSI
4.	CPU's local APIC accepts interrupts into its IRR/ISR registers
5.	Interrupt delivered through IDT (MSI vector)

The above process can be inefficient under high IRQ rates. The notifications in
step #3 are often unnecessary when the destination CPU is already overwhelmed
with handling bursts of IRQs. On some architectures, such as Intel Xeon, step #3
is also expensive and requires strong ordering w.r.t DMA. As a result, slower
IRQ rates can become a limiting factor for DMA I/O performance.

For example, on Intel Xeon Sapphire Rapids SoC, as more NVMe disks are attached
to the same socket, FIO (libaio engine) performance per disk drops quickly.

# of disks  	2  	4  	8
-------------------------------------
IOPS(million)  	1.991	1.136  	0.834
(NVMe Gen 5 Samsung PM174x)

With posted mode in interrupt remapping, the interrupt flow is divided into two
parts: posting (storing pending IRQ vector information in memory) and CPU
notification.

The above remappable IRQ flow becomes the following (1 and 2 unchanged):
3.	Notifies the destination CPU with a notification vector
	- IOMMU suppresses CPU notification
	- IOMMU atomic swap IRQ status to memory (PID)
4.	CPU's local APIC accepts the notification interrupt into its IRR/ISR
	registers
5.	Interrupt delivered through IDT (notification vector handler)
	System SW allows new notifications.
(The above flow is not in Linux today since we only use posted mode for VM)

Note that the system software can now suppress CPU notifications at runtime as
needed. This allows the system software to coalesce CPU notifications and in
turn, improve IRQ throughput and DMA performance.

Consider the following scenario when MSIs arrive at a CPU in high-frequency
bursts:

Time ----------------------------------------------------------------------->
    	^ ^ ^       	^ ^ ^ ^     	^   	^
MSIs	A B C       	D E F G     	H   	I

RI  	N  N'  N'     	N  N'  N'  N'  	N   	N

PI  	N           	N           	N   	N

RI: remappable interrupt;  PI:  posted interrupt;
N: interrupt notification, N': superfluous interrupt notification

With remappable interrupt (row titled RI), every MSI generates a notification
event to the CPU.

With posted interrupts enabled in this patchset (row titled PI), CPU
notifications are coalesced during IRQ bursts. N' are eliminated in the flow
above. We refer to this mechanism Coalesced Interrupt Delivery (CID).

Post interrupts have existed for a long time, they have been used for
virtualization where MSIs from directly assigned devices can be delivered to
the guest kernel without VMM intervention. On x86 Intel platforms, posted
interrupts can be used on the host as well. Posted interrupt descriptor (PID)
address is in host physical address.

This patchset enables a new usage of posted interrupts on existing (and new
hardware) for host kernel device MSIs. It is referred to as Posted MSIs
throughout this patch set.

Performance (with this patch set):
==================================
Test #1.

FIO libaio (million IOPS/sec/disk) Gen 5 NVMe Samsung PM174x disks on a single
socket, Intel Xeon Sapphire Rapids.

#disks	Before		After		%Gain
---------------------------------------------
8	0.834		1.943		132%
4	1.136		2.023		78%

Test #2.

Two dedicated workqueues from two Intel Data Streaming Accelerator (DSA)
PCI devices, pin IRQ affinity of the two interrupts to a single CPU.

				Before		After		%Gain
DSA memfill (mil IRQs/sec)	5.157		8.987		74%

DMA throughput has similar improvements.

At lower IRQ rate (< 1 million/second), no performance benefits nor regression
observed so far.

Implementation choices:
======================
- Transparent to the device drivers

- System-wide option instead of per-device or per-IRQ opt-in, i.e. once enabled
  all device MSIs are posted. The benefit is that we only need to change IR
  irq_chip and domain layer. No change to PCI MSI.
  Exceptions are: IOAPIC, HPET, and VT-d's own IRQs

- Limit the number of polling/demuxing loops per CPU notification event

- Only change Intel-IR in IRQ domain hierarchy VECTOR->INTEL-IR->PCI-MSI,

- X86 Intel only so far, can be extended to other architectures with posted
  interrupt support (ARM and AMD), RFC.

- Bare metal only, no posted interrupt capable virtual IOMMU.


Changes and implications (moving from remappable to posted mode)
===============================
1. All MSI vectors are multiplexed into a single notification vector for each
CPU MSI vectors are then de-multiplexed by SW, no IDT delivery for MSIs

2. Losing the following features compared to the remappable mode (AFAIK, none of
the below matters for device MSIs)
- Control of delivery mode, e.g. NMI for MSIs
- No logical destinations, posted interrupt destination is x2APIC
  physical APIC ID
- No per vector stack, since all MSI vectors are multiplexed into one


Runtime changes
===============
The IRQ runtime behavior has changed with this patch, here is a pseudo trace
comparison for 3 MSIs of different vectors arriving in a burst. A system vector
interrupt (e.g. timer) arrives randomly.

BEFORE:
interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()

interrupt(timer)

interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()

interrupt(MSI)
    irq_enter()
    handler() /* EOI */
    irq_exit()
        process_softirq()


AFTER:
interrupt /* Posted MSI notification vector */
    irq_enter()
	atomic_xchg(PIR)
	handler()
	handler()
	handler()
	pi_clear_on()
    apic_eoi()
    irq_exit()
interrupt(timer)
        process_softirq()

With posted MSI (as pointed out by Thomas Gleixner), both high-priority
interrupts (system interrupt vectors) and softIRQs are blocked during MSI vector
demux loop. Some can be timing sensitive.

Here are the options I have attempted or still working on:

1. Use self-IPI to invoke MSI vector handler but that took away the majority of
the performance benefits.

2. Limit the # of demuxing loops, this is implemented in this patch. Note that
today, we already allow one low priority MSI to block system interrupts. System
vector can preempt MSI vectors without waiting for EOI but we have IRQ disabled
in the ISR.

Performance data (on DSA with MEMFILL) also shows that coalescing more than 3
loops yields diminishing benefits. Therefore, the max loops for coalescing is
set to 3 in this patch.
	MaxLoop		IRQ/sec		bandwidth Mbps
-------------------------------------------------------------------------
	2		6157107 		25219
	3		6226611 		25504
	4		6557081 		26857
	5		6629683 		27155
	6		6662425 		27289

3. limit the time that system interrupts can be blocked (WIP).

4. Make posted MSI notification vector preemptable (WIP)
Chose notification vector with lower priority class bit[7:4] than other system
vectors such that it can be preempted by the system interrupts without waiting
for EOI.

interrupt
    irq_enter()
	local_irq_enable()
	atomic_xchg(PIR)
	handler()
	handler()
	handler()
	local_irq_disable()
	pi_clear_on()
    apic_eoi()
    irq_exit()
        process_softirq()

This is a more intrusive change, my limited understanding is that we do not
allow nested IRQ due to the concern of overflowing the IRQ stack.

But with posted MSI, all MSI vectors are multiplexed into one vector, stack size
should not be a concern. No device MSIs are delivered to the CPU directly
anymore. Alternatively, post MSI vector can use another IST entry.

I appreciate any suggestion in addressing this issue.

In addition, posted MSI uses atomic xchg from both CPU and IOMMU. Compared to
remappable mode, there may be additional cache line ownership contention over
PID. However, we have not observed performance regression at lower IRQ rates.
At high interrupt rate, posted mode always wins.

Testing:
========

The following tests have been performed and continue to be evaluated.
- IRQ affinity change, migration
- CPU offlining
- Multi vector coalescing
- Low IRQ rate, general no-harm test
- VM device assignment
- General no harm test, performance regressions have not been observed for low
IRQ rate workload.


With the patch, a new entry in /proc/interrupts is added.
cat /proc/interrupts | grep PMN
PMN:         13868907 Posted MSI notification event

No change to the device MSI accounting.

A new INTEL-IR-POST irq_chip is visible at IRQ debugfs, e.g.
domain:  IR-PCI-MSIX-0000:6f:01.0-12
 hwirq:   0x8
 chip:    IR-PCI-MSIX-0000:6f:01.0
  flags:   0x430
             IRQCHIP_SKIP_SET_WAKE
             IRQCHIP_ONESHOT_SAFE
 parent:
    domain:  INTEL-IR-12-13
     hwirq:   0x90000
     chip:    INTEL-IR-POST /* For posted MSIs */
      flags:   0x0
     parent:
        domain:  VECTOR
         hwirq:   0x65
         chip:    APIC


Acknowledgment
==============

- Rajesh Sankaran and Ashok Raj for the original idea

- Thomas Gleixner for reviewing and guiding the upstream direction of PoC
patches. Help correct my many misunderstandings of the IRQ subsystem.

- Jie J Yan(Jeff), Sebastien Lemarie, and Dan Liang for performance evaluation
with NVMe and network workload

- Bernice Zhang and Scott Morris for functional validation

- Michael Prinke helped me understand how VT-d HW works

- Sanjay Kumar for providing the DSA IRQ test suite



Thanks,

Jacob

Jacob Pan (11):
  x86: Move posted interrupt descriptor out of vmx code
  x86: Add a Kconfig option for posted MSI
  x86: Reserved a per CPU IDT vector for posted MSIs
  iommu/vt-d: Add helper and flag to check/disable posted MSI
  x86/irq: Unionize PID.PIR for 64bit access w/o casting
  x86/irq: Add helpers for checking Intel PID
  x86/irq: Factor out calling ISR from common_interrupt
  x86/irq: Install posted MSI notification handler
  x86/irq: Handle potential lost IRQ during migration and CPU offline
  iommu/vt-d: Add an irq_chip for posted MSIs
  iommu/vt-d: Enable posted mode for device MSIs

Thomas Gleixner (2):
  x86/irq: Set up per host CPU posted interrupt descriptors
  iommu/vt-d: Add a helper to retrieve PID address

 arch/x86/Kconfig                     |  10 ++
 arch/x86/include/asm/apic.h          |   1 +
 arch/x86/include/asm/hardirq.h       |   6 ++
 arch/x86/include/asm/idtentry.h      |   3 +
 arch/x86/include/asm/irq_remapping.h |  11 ++
 arch/x86/include/asm/irq_vectors.h   |  15 ++-
 arch/x86/include/asm/posted_intr.h   | 139 +++++++++++++++++++++++++
 arch/x86/kernel/apic/io_apic.c       |   2 +-
 arch/x86/kernel/apic/vector.c        |  13 ++-
 arch/x86/kernel/cpu/common.c         |   3 +
 arch/x86/kernel/idt.c                |   3 +
 arch/x86/kernel/irq.c                | 147 ++++++++++++++++++++++++---
 arch/x86/kvm/vmx/posted_intr.h       |  93 +----------------
 arch/x86/kvm/vmx/vmx.c               |   1 +
 arch/x86/kvm/vmx/vmx.h               |   2 +-
 drivers/iommu/intel/irq_remapping.c  | 103 ++++++++++++++++++-
 drivers/iommu/irq_remapping.c        |  17 ++++
 17 files changed, 456 insertions(+), 113 deletions(-)
 create mode 100644 arch/x86/include/asm/posted_intr.h

-- 
2.25.1


