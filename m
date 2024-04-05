Return-Path: <kvm+bounces-13753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 585BD89A723
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E16171F21C7B
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B1C176FC4;
	Fri,  5 Apr 2024 22:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KpAMN+af"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECFD1E4BE;
	Fri,  5 Apr 2024 22:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356009; cv=none; b=u15WzgdL0GERbo7lkyl81HsbFXCt3WJH6ZJTWIDtFfu7rIfKEIOjkYllRuf3KXunlFVzVsXZzVAIsgVGbcShool8LOXxTvDmNMzWAKAxIVRBOYumxfouxEN3wBZcI10MotHWxU8F10VX8hyByqbR2hUgIkCHCxPt+ANWISongIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356009; c=relaxed/simple;
	bh=HBMA8Ear6PZ/X9UeO8E/idiaY+79on5xxLQZ5AwjeI4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=adGrWAF+byFZndqS2SmNi/p91LS8tqfpZWKyg3VUsif9ez6vB4qxR3QVo5s0Izc0guU06eWOckh7+DpZxUhncp5FTLFvBReNZ7t5hnzaqj6OAaRjUGRUGEVJ/k6nBn23NJMRGHCbDV/SHvchhMC041WbCYQ84HLiG7kLFsX16Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KpAMN+af; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712356007; x=1743892007;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HBMA8Ear6PZ/X9UeO8E/idiaY+79on5xxLQZ5AwjeI4=;
  b=KpAMN+afQ/Z15+9S5lzjg2KdW0IYGF1OX7EaY1FkcnVwUA1YpRJyPKZ8
   Z2Q4w94pwDQLL0G/Kemvxr6RQUMOhQWAlXudcpUr82+V8se21ROwQ9/6y
   /gSsEAIct8+tg1gsTSd6BiRiwMP8XttlqF5jecMahhCAJDQEkaM1mjDXN
   OdIrn700YoBb6eA+3XbpB60l4dCNSefxWgS2OPl+WhWJlDxQRnSIQ3m8G
   k0bDNaMTDhOICkKEzGScnVl+Tzzdl5DadBsmS496GjUmGY5mOK/9jv1Wb
   +5zct1NAH8GpFUx9oKd720UKR7ppsNXzYoGE6C1l7FBMhcPJVeRfVuvEg
   g==;
X-CSE-ConnectionGUID: jrXuPbEpQvyuQxTQp7dQag==
X-CSE-MsgGUID: 8m8mz9jiTuqTknwYkjEL4A==
X-IronPort-AV: E=McAfee;i="6600,9927,11035"; a="19062653"
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="19062653"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2024 15:26:45 -0700
X-CSE-ConnectionGUID: ojjwhLfhT3KQKTsFe+aWQw==
X-CSE-MsgGUID: mCQy61CLRCeCqf+6maXeaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,182,1708416000"; 
   d="scan'208";a="23928305"
Received: from jacob-builder.jf.intel.com ([10.54.39.125])
  by fmviesa004.fm.intel.com with ESMTP; 05 Apr 2024 15:26:44 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
	X86 Kernel <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	iommu@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Lu Baolu" <baolu.lu@linux.intel.com>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Ingo Molnar" <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Raj Ashok <ashok.raj@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	maz@kernel.org,
	seanjc@google.com,
	"Robin Murphy" <robin.murphy@arm.com>,
	jim.harris@samsung.com,
	a.manzanares@samsung.com,
	"Bjorn Helgaas" <helgaas@kernel.org>,
	guang.zeng@intel.com,
	robert.hoo.linux@gmail.com,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 00/13] Coalesced Interrupt Delivery with posted MSI
Date: Fri,  5 Apr 2024 15:30:57 -0700
Message-Id: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
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

There is a session at LPC2023 IOMMU/VFIO/PCI MC where I have presented this
topic.

https://lpc.events/event/17/sessions/172/#20231115

Background
==========
On modern x86 server SoCs, interrupt remapping (IR) is required and turned
on by default to support X2APIC. Two interrupt remapping modes can be supported
by IOMMU/VT-d:

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
to the same socket, FIO (libaio engine) 4K block random read performance
per-disk drops quickly.

# of disks  	2  	4  	8
-------------------------------------
IOPS(million)  	1.991	1.136  	0.834
(NVMe Gen 5 Samsung PM174x)

With posted mode enabled in interrupt remapping, the interrupt flow is divided
into two parts: posting (storing pending IRQ vector information in memory) and
CPU notification.

The above remappable IRQ flow becomes the following (1 and 2 unchanged):
3.	Notifies the destination CPU with a notification vector
	- IOMMU suppresses CPU notification
	- IOMMU atomic swap/store IRQ status to memory-resident posted interrupt
	descriptor (PID)
4.	CPU's local APIC accepts the notification interrupt into its IRR/ISR
	registers
5.	Interrupt delivered through IDT (notification vector handler)
	System SW allows new notifications by clearing outstanding notification
	(ON) bit in PID.
(The above flow is not in Linux today since we only use posted mode for VM)

Note that the system software can now suppress CPU notifications at runtime as
needed. This allows the system software to coalesce the expensive CPU
notifications and in turn, improve IRQ throughput and DMA performance.

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

With posted interrupts enabled in this patch set (row titled PI), CPU
notifications are coalesced during IRQ bursts. N's are eliminated in the flow
above. We refer to this mechanism Coalesced Interrupt Delivery (CID).

Post interrupts have existed for a long time, they have been used for
virtualization where MSIs from directly assigned devices can be delivered to
the guest kernel without VMM intervention. On x86 Intel platforms, posted
interrupts can be used on the host as well. Only host physical address of
Posted interrupt descriptor (PID) is used.

This patch set enables a new usage of posted interrupts on existing (and
new hardware) for host kernel device MSIs. It is referred to as Posted MSIs
throughout this patch set.

Performance (with this patch set):
==================================
Test #1. NVMe FIO

FIO libaio (million IOPS/sec/disk) Gen 5 NVMe Samsung PM174x disks on a single
socket, Intel Xeon Sapphire Rapids. Random read with 4k block size. NVMe IRQ
affinity is managed by the kernel with one vector per CPU.

#disks	Before		After		%Gain
---------------------------------------------
8	0.834		1.943		132%
4	1.136		2.023		78%

Other observations:
- Increased block sizes shows diminishing benefits, e.g. with 4 NVME disks on
one x16 PCIe slot, the combined IOPS looks like:

    Block Size	Baseline	PostedMSI
    -------------------------------------
    4K		6475		8778
    8K		5727		5896
    16k		2864		2900
    32k		1546		1520
    128k	397		398

- Submission/Completion latency (usec) also improved at 4K block size only
  FIO report SLAT
  ---------------------------------------
  Block Size	Baseline	postedMSI
  4k		2177		2282
  8k		4416		3967
  16k		2950		3053
  32k		3453		3505
  128k		5911		5801

  FIO report CLAT
  ---------------------------------------
  Block Size	Baseline	postedMSI
  4k		313		230
  8k		352		343
  16k		711		702
  32k		1320		1343
  128k		5146		5137


Test #2. Intel Data Streaming Accelerator

Two dedicated workqueues from two PCI root complex integrated endpoint
(RCIEP) devices, pin IRQ affinity of the two interrupts to a single CPU.

				Before		After		%Gain
				-------------------------------------
DSA memfill (mil IRQs/sec)	5.157		8.987		74%

DMA throughput has similar improvements.

At lower IRQ rate (< 1 million/second), no performance benefits nor regression
observed so far.

No harm tests also performed to ensure no performance regression on workloads
that do not have high interrupt rate. These tests include:
- kernel compile time
- file copy
- FIO NVME random writes

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
comparison for 3 MSIs of different vectors arriving in a burst on the same CPU.
A system vector interrupt (e.g. timer) arrives randomly.

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
- VM device assignment via VFIO
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


Changelogs:

V2:
- Code change logs are in individual patches.
- Use "Originally-by" and "Suggested-by" tags to clarify
  credits/responsibilities.
- More performance evaluation done on FIO
4K rand read test. Four Samsung PM174x NVMe drives on a single x16 PCIe gen5
lane. Fixed CPU frequency at 2.7GHz (p1, highest non-turbo).

      	    	IOPS*	CPU%	sys%	 user%	Ints/sec	IOPS/CPU	LAT**
AIO (before)	6231	55.5	39.7	 15.8	5714721		112.2702703	328
AIO (after)	8936	71.5	51.5	 20	7397543		124.979021	229

IOURING(before)	6880	43.7	30.3	13.4	6512402		157.4370709	149
IOURING(after)	8688	58.3	41.3	17	7625158		149.0222985	118

IOURING POLLEDQ	13100	100	85.1	14.9	8000		131		156

* x1000 4 drives combined
** 95% usec.

This patchset improves IOPS, IRQ throughput, and reduces latency for non-polled
queues.

V1 (since RFC)
   - Removed mentioning of wishful features, IRQ preemption, separate and
     full MSI vector space
   - Refined MSI handler de-multiplexing loop based on suggestions from
     Peter and Thomas. Reduced xchg() usage and code duplication
   - Assign the new posted IR irq_chip only to device MSI/x, avoid changing
     IO-APIC code
   - Extract and use common code for preventing lost interrupt during
     affinity change
   - Added more test results to the cover letter



Thanks,

Jacob



Jacob Pan (13):
  x86/irq: Move posted interrupt descriptor out of vmx code
  x86/irq: Unionize PID.PIR for 64bit access w/o casting
  x86/irq: Remove bitfields in posted interrupt descriptor
  x86/irq: Add a Kconfig option for posted MSI
  x86/irq: Reserve a per CPU IDT vector for posted MSIs
  x86/irq: Set up per host CPU posted interrupt descriptors
  x86/irq: Factor out calling ISR from common_interrupt
  x86/irq: Install posted MSI notification handler
  x86/irq: Factor out common code for checking pending interrupts
  x86/irq: Extend checks for pending vectors to posted interrupts
  iommu/vt-d: Make posted MSI an opt-in cmdline option
  iommu/vt-d: Add an irq_chip for posted MSIs
  iommu/vt-d: Enable posted mode for device MSIs

 .../admin-guide/kernel-parameters.txt         |   1 +
 arch/x86/Kconfig                              |  11 ++
 arch/x86/include/asm/apic.h                   |  12 ++
 arch/x86/include/asm/hardirq.h                |   6 +
 arch/x86/include/asm/idtentry.h               |   3 +
 arch/x86/include/asm/irq_remapping.h          |  11 ++
 arch/x86/include/asm/irq_vectors.h            |   9 +-
 arch/x86/include/asm/posted_intr.h            | 108 ++++++++++++
 arch/x86/kernel/apic/vector.c                 |   5 +-
 arch/x86/kernel/cpu/common.c                  |   3 +
 arch/x86/kernel/idt.c                         |   3 +
 arch/x86/kernel/irq.c                         | 164 ++++++++++++++++--
 arch/x86/kvm/vmx/posted_intr.c                |   4 +-
 arch/x86/kvm/vmx/posted_intr.h                |  93 +---------
 arch/x86/kvm/vmx/vmx.c                        |   3 +-
 arch/x86/kvm/vmx/vmx.h                        |   2 +-
 drivers/iommu/intel/irq_remapping.c           | 115 +++++++++++-
 drivers/iommu/irq_remapping.c                 |  13 +-
 tools/arch/x86/include/asm/irq_vectors.h      |   9 +-
 19 files changed, 457 insertions(+), 118 deletions(-)
 create mode 100644 arch/x86/include/asm/posted_intr.h

-- 
2.25.1


