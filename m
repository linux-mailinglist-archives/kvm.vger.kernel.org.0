Return-Path: <kvm+bounces-842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FEA27E3718
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0CFF1C20C24
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB97125BE;
	Tue,  7 Nov 2023 09:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F3E1118B
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:01:07 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id E995E106
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:01:03 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC938FEC;
	Tue,  7 Nov 2023 01:01:47 -0800 (PST)
Received: from monolith (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 213893F703;
	Tue,  7 Nov 2023 01:01:02 -0800 (PST)
Date: Tue, 7 Nov 2023 09:01:45 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
	kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
	nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 00/19] arm/arm64: Rework cache
 maintenance at boot
Message-ID: <ZUn8-R34rIiHjQK7@monolith>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <ZUdrku2u6OGc43wv@monolith>
 <678f0bd1-1232-f785-45ac-45a8f4404347@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <678f0bd1-1232-f785-45ac-45a8f4404347@redhat.com>

Hi Shaoqin,

On Mon, Nov 06, 2023 at 05:37:01PM +0800, Shaoqin Huang wrote:
> Hi Alexandru,
> 
> On 11/5/23 18:16, Alexandru Elisei wrote:
> > Hi,
> > 
> > I had a v2 almost finished a few months ago (maybe a year), but I parked
> > the patches when we decided that the best thing to do was to have UEFI
> > support in first, then rework the cache maintenance - that way, the changes
> > can be tested on baremetal, which is much more unforgiving than KVM.
> > 
> > Unfortunately I've been busy with other things and I don't know when I'll
> > be able to come back to this. So I've pushed the work-in-progress here [1],
> > with what I hope is a helpful changelog since v1.
> > 
> > If my memory serves me right, even though it is marked as wip, it was
> > running just fine under KVM and I was waiting for UEFI to test it on
> > baremetal before posting.
> > 
> > I don't know when I'll have the time to get back to the series, so if
> > anyone is still interested, feel free to pick it up. If someone does pick
> > up the series, they can drop/rework patches as they see fit, and I'll try
> > to do my best to review whatever is posted on the list (but no promises).
> > 
> > [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/arm-arm64-rework-cache-maintenance-at-boot-v2-wip2
> 
> I'm willing to take your work. But I can't open your link posted in [1]. I
> don't have permission to access it. Could you please posted it on a public
> place?

That's good news, thanks!

The link should be working now.

Thanks,
Alex

> 
> Thanks,
> Shaoqin
> 
> > 
> > Thanks,
> > Alex
> > 
> > On Tue, Aug 09, 2022 at 10:15:39AM +0100, Alexandru Elisei wrote:
> > > I got the idea for this series as I was looking at the UEFI support series
> > > [1]. More specifically, I realized that the cache maintenance performed by
> > > asm_mmu_disable is insuficient. Patch #19 ("arm/arm64: Rework the cache
> > > maintenance in asm_mmu_disable") describes what is wrong with
> > > asm_mmu_disable. A detailed explanation of what cache maintenance is needed
> > > and why is needed can be found in patch #18 ("arm/arm64: Perform dcache
> > > maintenance at boot").
> > > 
> > > Then I realized that I couldn't fix only asm_mmu_disable, and leave the
> > > rest of kvm-unit-tests without the needed cache maintenance, so here it is,
> > > my attempt at adding the cache maintenace operations (from now on, CMOs)
> > > required by the architecture.
> > > 
> > > My approach is to try to enable the MMU and build the translation tables as
> > > soon as possible, to avoid as much of cache maintenance as possible. I
> > > didn't want to do it in the early assembly code, like Linux, because I like
> > > the fact that kvm-unit-tests keeps the assembly code to a minimum, and I
> > > wanted to preserve that. So I made the physical allocator simpler (patches
> > > #2-#6) so it can be used to create the translation tables immediately after
> > > the memory regions are populated.
> > > 
> > > After moving some code around, especially how the secondaries are brought
> > > online, the dcache maintenance is implemented in patch #18 ("arm/arm64:
> > > Perform dcache maintenance at boot").
> > > 
> > > The series is an RFC, and I open to suggestions about how to do things
> > > better; I'm happy to rework the entire series if a better approach is
> > > proposed.
> > > 
> > > Why is this needed? Nobody complained about test failing because of missing
> > > CMOs before, so why add them now? I see two reasons for the series:
> > > 
> > > 1. For architectural correctness. The emphasis has been so far on the test
> > > themselves to be architectural compliant, but I believe that the boot code
> > > should get the same treatment. kvm-unit-tests has started to be used in
> > > different ways than before, and I don't think that we should limit
> > > ourselves to running under one hypervisor, or running under a hypervisor at
> > > all. Which brings me to point number 2.
> > > 
> > > 2. If nothing else, this can serve as a showcase for the UEFI support
> > > series for the required cache maintenance. Although I hope that UEFI
> > > support will end up sharing at least some of the boot code with the
> > > non-UEFI boot path.
> > > 
> > > This is an RFC and has some rough edges, probably also bugs, but I believe
> > > the concept to be sound. If/when the series stabilizes, I'll probably split
> > > it into separate series (for example, the __ASSEMBLY__ define patch could
> > > probably be separate from the others). Tested by running all the arm and
> > > arm64 tests on a rockpro64 with qemu.
> > > 
> > > [1] https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> > > 
> > > Alexandru Elisei (19):
> > >    Makefile: Define __ASSEMBLY__ for assembly files
> > >    lib/alloc_phys: Initialize align_min
> > >    lib/alloc_phys: Use phys_alloc_aligned_safe and rename it to
> > >      memalign_early
> > >    powerpc: Use the page allocator
> > >    lib/alloc_phys: Remove locking
> > >    lib/alloc_phys: Remove allocation accounting
> > >    arm/arm64: Mark the phys_end parameter as unused in setup_mmu()
> > >    arm/arm64: Use pgd_alloc() to allocate mmu_idmap
> > >    arm/arm64: Zero secondary CPUs' stack
> > >    arm/arm64: Enable the MMU early
> > >    arm/arm64: Map the UART when creating the translation tables
> > >    arm/arm64: assembler.h: Replace size with end address for
> > >      dcache_by_line_op
> > >    arm: page.h: Add missing libcflat.h include
> > >    arm/arm64: Add C functions for doing cache maintenance
> > >    lib/alloc_phys: Add callback to perform cache maintenance
> > >    arm/arm64: Allocate secondaries' stack using the page allocator
> > >    arm/arm64: Configure secondaries' stack before enabling the MMU
> > >    arm/arm64: Perform dcache maintenance at boot
> > >    arm/arm64: Rework the cache maintenance in asm_mmu_disable
> > > 
> > >   Makefile                   |   5 +-
> > >   arm/Makefile.arm           |   4 +-
> > >   arm/Makefile.arm64         |   4 +-
> > >   arm/Makefile.common        |   4 +-
> > >   arm/cstart.S               |  59 ++++++++++++------
> > >   arm/cstart64.S             |  56 +++++++++++++----
> > >   lib/alloc_phys.c           | 122 ++++++++++++-------------------------
> > >   lib/alloc_phys.h           |  13 +++-
> > >   lib/arm/asm/assembler.h    |  15 ++---
> > >   lib/arm/asm/cacheflush.h   |   1 +
> > >   lib/arm/asm/mmu-api.h      |   1 +
> > >   lib/arm/asm/mmu.h          |   6 --
> > >   lib/arm/asm/page.h         |   2 +
> > >   lib/arm/asm/pgtable.h      |  52 ++++++++++++++--
> > >   lib/arm/asm/thread_info.h  |   3 +-
> > >   lib/arm/cache.S            |  89 +++++++++++++++++++++++++++
> > >   lib/arm/io.c               |   5 ++
> > >   lib/arm/io.h               |   3 +
> > >   lib/arm/mmu.c              |  60 +++++++++++-------
> > >   lib/arm/processor.c        |   6 +-
> > >   lib/arm/setup.c            |  66 ++++++++++++++++----
> > >   lib/arm/smp.c              |   9 ++-
> > >   lib/arm64/asm/assembler.h  |  11 ++--
> > >   lib/arm64/asm/cacheflush.h |  32 ++++++++++
> > >   lib/arm64/asm/mmu.h        |   5 --
> > >   lib/arm64/asm/pgtable.h    |  67 ++++++++++++++++++--
> > >   lib/arm64/cache.S          |  85 ++++++++++++++++++++++++++
> > >   lib/arm64/processor.c      |   5 +-
> > >   lib/devicetree.c           |   2 +-
> > >   lib/powerpc/setup.c        |   8 +++
> > >   powerpc/Makefile.common    |   1 +
> > >   powerpc/cstart64.S         |   1 -
> > >   powerpc/spapr_hcall.c      |   5 +-
> > >   33 files changed, 608 insertions(+), 199 deletions(-)
> > >   create mode 100644 lib/arm/asm/cacheflush.h
> > >   create mode 100644 lib/arm/cache.S
> > >   create mode 100644 lib/arm64/asm/cacheflush.h
> > >   create mode 100644 lib/arm64/cache.S
> > > 
> > > -- 
> > > 2.37.1
> > > 
> > 
> 
> -- 
> Shaoqin
> 

