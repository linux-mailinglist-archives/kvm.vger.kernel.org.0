Return-Path: <kvm+bounces-63004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58CC9C5730B
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 12:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D62E33B4BC3
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 11:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE4E33B97E;
	Thu, 13 Nov 2025 11:23:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315B02E3AF1
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763033028; cv=none; b=t59u0VEp9nX5nFW4TwEbC1ClURjxuIOgG5wjwmJBThtkL7n0w69UQ5PPB3stkE9a27jJFnyuVcYbOoFFNuObz8URLzA1lbPkSOr21XA8q/aTuKzlmGP0Zl+ttyoMG+ab3SiaIddvjlEuGYIvGWL4qKBEgB8MGSc6ZLe/bTbV2gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763033028; c=relaxed/simple;
	bh=zYbGPzfRLGFk6vpXITebB7XEDaNkLSyOIiM6+8uAnZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B69l5mAaNFwpl9O8TUbRNASZgvaVjXdSJAPKl20pDL95qIxDpA4MReOcCjZ/RpILiOwtL2vGln8TBDyu5A29igzW5IM2KY+0+AfI5BCt/YC0lyKGZ3L0+PgtwWf4lkVCL6BLv8q3SVkZaVrycg87jcRCEGScpgIiS225z8o13Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB9D212FC;
	Thu, 13 Nov 2025 03:23:38 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A57DB3F66E;
	Thu, 13 Nov 2025 03:23:44 -0800 (PST)
Date: Thu, 13 Nov 2025 11:23:33 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 04/45] KVM: arm64: Turn vgic-v3 errata traps into a
 patched-in constant
Message-ID: <20251113112333.GA1434041@e124191.cambridge.arm.com>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-5-maz@kernel.org>
 <CGME20251113095225eucas1p261508e40d5b802f6e5be58600bb4a02c@eucas1p2.samsung.com>
 <b618732b-fd26-49e0-84c5-bfd54be09cd2@samsung.com>
 <86seeitd3f.wl-maz@kernel.org>
 <5a0aac14-6d1f-4941-b0d1-bb60572e7a6e@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a0aac14-6d1f-4941-b0d1-bb60572e7a6e@samsung.com>

On Thu, Nov 13, 2025 at 12:04:46PM +0100, Marek Szyprowski wrote:
> On 13.11.2025 11:56, Marc Zyngier wrote:
> > Hi Marek,
> >
> > On Thu, 13 Nov 2025 09:52:23 +0000,
> > Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >> On 09.11.2025 18:15, Marc Zyngier wrote:
> >>> The trap bits are currently only set to manage CPU errata. However,
> >>> we are about to make use of them for purposes beyond beating broken
> >>> CPUs into submission.
> >>>
> >>> For this purpose, turn these errata-driven bits into a patched-in
> >>> constant that is merged with the KVM-driven value at the point of
> >>> programming the ICH_HCR_EL2 register, rather than being directly
> >>> stored with with the shadow value..
> >>>
> >>> This allows the KVM code to distinguish between a trap being handled
> >>> for the purpose of an erratum workaround, or for KVM's own need.
> >>>
> >>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> >> This patch landed in today's linux-next as commit ca30799f7c2d ("KVM:
> >> arm64: Turn vgic-v3 errata traps into a patched-in constant"). In my
> >> tests I found that it triggers oops and breaks booting on Raspberry Pi5
> >> and Amlogic SM1 based boards: Odroid-C4 and Khadas VIM3l. Here is the
> >> failure log:
> >>
> >> alternatives: applying system-wide alternatives
> >> Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
> >> Modules linked in:
> >> CPU: 0 UID: 0 PID: 18 Comm: migration/0 Not tainted 6.18.0-rc3+ #11665
> >> PREEMPT
> >> Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
> >> Stopper: multi_cpu_stop+0x0/0x178 <- __stop_cpus.constprop.0+0x7c/0xc8
> >> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >> pc : vgic_v3_broken_seis+0x14/0x44
> >> lr : kvm_compute_ich_hcr_trap_bits+0x48/0xd8
> >> ...
> >> Call trace:
> >>    vgic_v3_broken_seis+0x14/0x44 (P)
> >>    __apply_alternatives+0x1b4/0x200
> >>    __apply_alternatives_multi_stop+0xac/0xc8
> >>    multi_cpu_stop+0x90/0x178
> >>    cpu_stopper_thread+0x8c/0x11c
> >>    smpboot_thread_fn+0x160/0x32c
> >>    kthread+0x150/0x228
> >>    ret_from_fork+0x10/0x20
> >> Code: 52800000 f100203f 54000040 d65f03c0 (d53ccb21)
> >> ---[ end trace 0000000000000000 ]---
> >> note: migration/0[18] exited with irqs disabled
> >> note: migration/0[18] exited with preempt_count 1
> >> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> >> rcu:     1-...0: (7 ticks this GP) idle=0124/1/0x4000000000000000
> >> softirq=9/10 fqs=3250
> >> rcu:     2-...0: (7 ticks this GP) idle=0154/1/0x4000000000000000
> >> softirq=9/10 fqs=3250
> >> rcu:     3-...0: (7 ticks this GP) idle=018c/1/0x4000000000000000
> >> softirq=9/10 fqs=3250
> >> rcu:     (detected by 0, t=6502 jiffies, g=-1179, q=2 ncpus=4)
> >> Sending NMI from CPU 0 to CPUs 1:
> >> Sending NMI from CPU 0 to CPUs 2:
> >> Sending NMI from CPU 0 to CPUs 3:
> >>
> >> Let me know how I can help in debugging this issue.
> > I think the common thing between these machines is that although they
> > run VHE, they are stuck with a GICv2, and should never get to this
> > code path.
> >
> > Can you dump the kernel log until this point? Something must be
> > screwed in the detection logic.
> 
> Here is a complete boot log:
> 
> Booting Linux on physical CPU 0x0000000000 [0x414fd0b1]
> Linux version 6.18.0-rc3+ (m.szyprowski@AMDC4653) (aarch64-linux-gnu-gcc 
> (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils for Ubuntu) 
> 2.38) #11666 SMP PREEMPT Thu Nov 13 11:58:18 CET 2025
> KASLR enabled
> Machine model: Raspberry Pi 5 Model B Rev 1.0
> earlycon: pl11 at MMIO 0x000000107d001000 (options '115200n8')
> printk: legacy bootconsole [pl11] enabled
> printk: debug: ignoring loglevel setting.
> Reserved memory: created CMA memory pool at 0x000000003bc00000, size 64 MiB
> OF: reserved mem: initialized node linux,cma, compatible id shared-dma-pool
> OF: reserved mem: 0x000000003bc00000..0x000000003fbfffff (65536 KiB) map 
> reusable linux,cma
> OF: reserved mem: 0x0000000000000000..0x000000000007ffff (512 KiB) nomap 
> non-reusable atf@0
> NUMA: Faking a node at [mem 0x0000000000000000-0x00000001ffffffff]
> NODE_DATA(0) allocated [mem 0x1fefe4a00-0x1fefe763f]
> Zone ranges:
>    DMA      [mem 0x0000000000000000-0x00000000ffffffff]
>    DMA32    empty
>    Normal   [mem 0x0000000100000000-0x00000001ffffffff]
> Movable zone start for each node
> Early memory node ranges
>    node   0: [mem 0x0000000000000000-0x000000000007ffff]
>    node   0: [mem 0x0000000000080000-0x000000003fbfffff]
>    node   0: [mem 0x0000000040000000-0x00000001ffffffff]
> Initmem setup node 0 [mem 0x0000000000000000-0x00000001ffffffff]
> On node 0, zone DMA: 1024 pages in unavailable ranges
> psci: probing for conduit method from DT.
> psci: PSCIv1.1 detected in firmware.
> psci: Using standard PSCI v0.2 function IDs
> psci: MIGRATE_INFO_TYPE not supported.
> psci: SMC Calling Convention v1.2
> percpu: Embedded 35 pages/cpu s104336 r8192 d30832 u143360
> pcpu-alloc: s104336 r8192 d30832 u143360 alloc=35*4096
> pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
> Detected PIPT I-cache on CPU0
> CPU features: detected: Virtualization Host Extensions
> CPU features: detected: Spectre-v4
> CPU features: detected: Spectre-BHB
> CPU features: kernel page table isolation forced ON by KASLR
> CPU features: detected: Kernel page table isolation (KPTI)
> CPU features: detected: SSBS not fully self-synchronizing
> alternatives: applying boot alternatives
> Kernel command line: console=ttyAMA10,115200n8 earlycon 
> root=PARTUUID=11111111-03 rw clk_ignore_unused rootdelay=2 
> ignore_loglevel earlycon
> printk: log buffer data + meta data: 131072 + 458752 = 589824 bytes
> Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, linear)
> Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, linear)
> software IO TLB: area num 4.
> software IO TLB: mapped [mem 0x00000000fbfff000-0x00000000fffff000] (64MB)
> Fallback order for Node 0: 0
> Built 1 zonelists, mobility grouping on.  Total pages: 2096128
> Policy zone: Normal
> mem auto-init: stack:off, heap alloc:off, heap free:off
> SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> Running RCU self tests
> Running RCU synchronous self tests
> rcu: Preemptible hierarchical RCU implementation.
> rcu:     RCU event tracing is enabled.
> rcu:     RCU lockdep checking is enabled.
> rcu:     RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
>   Trampoline variant of Tasks RCU enabled.
>   Tracing variant of Tasks RCU enabled.
> rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
> rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> Running RCU synchronous self tests
> RCU Tasks: Setting shift to 2 and lim to 1 rcu_task_cb_adjust=1 
> rcu_task_cpu_ids=4.
> RCU Tasks Trace: Setting shift to 2 and lim to 1 rcu_task_cb_adjust=1 
> rcu_task_cpu_ids=4.
> NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> Root IRQ handler: gic_handle_irq
> GIC: Using split EOI/Deactivate mode
> rcu: srcu_init: Setting srcu_struct sizes based on contention.
> arch_timer: cp15 timer running at 54.00MHz (phys).
> clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 
> 0xc743ce346, max_idle_ns: 440795203123 ns
> sched_clock: 56 bits at 54MHz, resolution 18ns, wraps every 4398046511102ns
> Console: colour dummy device 80x25
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8192
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     32768
> ... MAX_LOCKDEP_CHAINS:      65536
> ... CHAINHASH_SIZE:          32768
>   memory used by lock dependency info: 6429 kB
>   memory used for stack traces: 4224 kB
>   per task-struct memory footprint: 1920 bytes
> Calibrating delay loop (skipped), value calculated using timer 
> frequency.. 108.00 BogoMIPS (lpj=216000)
> pid_max: default: 32768 minimum: 301
> LSM: initializing lsm=capability
> Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
> Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, linear)
> Running RCU synchronous self tests
> Running RCU synchronous self tests
> rcu: Hierarchical SRCU implementation.
> rcu:     Max phase no-delay instances is 1000.
> Timer migration: 1 hierarchy levels; 8 children per group; 1 crossnode level
> smp: Bringing up secondary CPUs ...
> Detected PIPT I-cache on CPU1
> CPU1: Booted secondary processor 0x0000000100 [0x414fd0b1]
> Detected PIPT I-cache on CPU2
> CPU2: Booted secondary processor 0x0000000200 [0x414fd0b1]
> Detected PIPT I-cache on CPU3
> CPU3: Booted secondary processor 0x0000000300 [0x414fd0b1]
> smp: Brought up 1 node, 4 CPUs
> SMP: Total of 4 processors activated.
> CPU: All CPU(s) started at EL2
> CPU features: detected: 32-bit EL0 Support
> CPU features: detected: Data cache clean to the PoU not required for I/D 
> coherence
> CPU features: detected: Common not Private translations
> CPU features: detected: CRC32 instructions
> CPU features: detected: RCpc load-acquire (LDAPR)
> CPU features: detected: LSE atomic instructions
> CPU features: detected: Privileged Access Never
> CPU features: detected: PMUv3
> CPU features: detected: RAS Extension Support
> CPU features: detected: Speculative Store Bypassing Safe (SSBS)
> alternatives: applying system-wide alternatives
> Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
> Modules linked in:
> CPU: 0 UID: 0 PID: 18 Comm: migration/0 Not tainted 6.18.0-rc3+ #11666 
> PREEMPT
> Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
> Stopper: multi_cpu_stop+0x0/0x178 <- __stop_cpus.constprop.0+0x7c/0xc8
> pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : vgic_v3_broken_seis+0x14/0x44
> lr : kvm_compute_ich_hcr_trap_bits+0x48/0xd8
> sp : ffff8000800b3c90
> x29: ffff8000800b3c90 x28: ffff8000800b3d58 x27: ffffa07c4e48dd28
> x26: 0000000000000001 x25: ffffa07c50461000 x24: ffffa07c50460000
> x23: ffffa07c51864000 x22: ffffa07c4e48dd28 x21: ffff00000028dd28
> x20: ffffa07c51864598 x19: ffffa07c505b2e10 x18: 00000000ffffffff
> x17: 6465726975716572 x16: 20746f6e20556f50 x15: 0000000000000001
> x14: 0000000000000000 x13: 0000000000000000 x12: ffff000100292520
> x11: ffffa07c51f7e620 x10: 0000000000000000 x9 : 0000000000000001
> x8 : ffff8000800b3c98 x7 : ffff8000800b3d60 x6 : ffffa07c5060dc28
> x5 : 0000000000000001 x4 : ffffa07c4f7645cc x3 : 0000000000000001
> x2 : ffff00000028dd28 x1 : 0000000000000008 x0 : 0000000000000000
> Call trace:
>   vgic_v3_broken_seis+0x14/0x44 (P)
>   __apply_alternatives+0x1b4/0x200
>   __apply_alternatives_multi_stop+0xac/0xc8
>   multi_cpu_stop+0x90/0x178
>   cpu_stopper_thread+0x8c/0x11c
>   smpboot_thread_fn+0x160/0x32c
>   kthread+0x150/0x228
>   ret_from_fork+0x10/0x20
> Code: 52800000 f100203f 54000040 d65f03c0 (d53ccb21)
> ---[ end trace 0000000000000000 ]---
> note: migration/0[18] exited with irqs disabled
> note: migration/0[18] exited with preempt_count 1
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu:     1-...0: (7 ticks this GP) idle=0194/1/0x4000000000000000 
> softirq=9/10 fqs=3250
> rcu:     2-...0: (7 ticks this GP) idle=00c4/1/0x4000000000000000 
> softirq=9/10 fqs=3250
> rcu:     3-...0: (7 ticks this GP) idle=01bc/1/0x4000000000000000 
> softirq=9/10 fqs=3250
> rcu:     (detected by 0, t=6502 jiffies, g=-1179, q=2 ncpus=4)
> Sending NMI from CPU 0 to CPUs 1:
> Sending NMI from CPU 0 to CPUs 2:
> Sending NMI from CPU 0 to CPUs 3:

I suppose the issue is that the alternatives in vgic_ich_hcr_trap_bits() are
always calculated, even if that function is only used from the gic-v3 code.
Calculating the trap bits reads ICH_VTR_EL2, which needs FEAT_GICv3.

Thanks,
Joey

> 
> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
> 

