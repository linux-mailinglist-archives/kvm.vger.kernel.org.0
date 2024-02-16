Return-Path: <kvm+bounces-8879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 309648581AD
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 16:48:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC27028A62D
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 15:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BCC12FB20;
	Fri, 16 Feb 2024 15:47:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F02512F373
	for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708098476; cv=none; b=ARqRx2Ei+T7F5KxckV0dD2j1LvwdD+tNTg7fWY/kv3uyePdNo1uO4e7sMDQdyJdRzt2G4WylrBhHBzbsgKhuUkfAwSenpd3jxvnB+n7o0xCCcw37qoJylILX2v/X0Gp41AOnF3ad4wg1lYOfaidoN7lg7AX439/+AKD6I9IDOaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708098476; c=relaxed/simple;
	bh=ePAM1xu/hzDpmCmPX992sRfMOfQHjbkEuROYc3V3MVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQibzk8HCfwhVdV/0ygmnZuWzyLUn5vAYqXxUdUKGbOdAIqZE7GySMOlaF6oVaAczaJgT6iEGtwyz1Xz7WBqVdqfQ3OLpPuDF6wKt2w3UObHN1MiibhW0wvm+7HvnggSCxKnGTiYrX6XTuvja6dlbhwd5QrGo9dTlEo7KULF3Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3050DA7;
	Fri, 16 Feb 2024 07:48:27 -0800 (PST)
Received: from raptor (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC7BE3F694;
	Fri, 16 Feb 2024 07:47:44 -0800 (PST)
Date: Fri, 16 Feb 2024 15:47:41 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>, linuxppc-dev@lists.ozlabs.org,
	Nadav Amit <namit@vmware.com>, Nico Boehr <nrb@linux.ibm.com>,
	Nikos Nikoleris <nikos.nikoleris@arm.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 00/18] arm/arm64: Rework cache
 maintenance at boot
Message-ID: <Zc-DnSvmJbT4Lk73@raptor>
References: <20231130090722.2897974-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130090722.2897974-1-shahuang@redhat.com>

Hi,

On Thu, Nov 30, 2023 at 04:07:02AM -0500, Shaoqin Huang wrote:
> Hi,
> 
> I'm posting Alexandru's patch set[1] rebased on the latest branch with the
> conflicts being resolved. No big changes compare to its original code.
> 
> As this version 1 of this series was posted one years ago, I would first let you
> recall it, what's the intention of this series and what this series do. You can
> view it by click the link[2] and view the cover-letter.
> 
> Since when writing the series[1], the efi support for arm64[3] hasn't been
> merged into the kvm-unit-tests, but now the efi support for arm64 has been
> merged. Directly rebase the series[1] onto the latest branch will break the efi
> tests. This is mainly because the Patch #15 ("arm/arm64: Enable the MMU early")
> moves the mmu_enable() out of the setup_mmu(), which causes the efi test will
> not enable the mmu. So I do a small change in the efi_mem_init() which makes the
> efi test also enable the MMU early, and make it works.
> 
> And another change should be noticed is in the Patch #17 ("arm/arm64: Perform
> dcache maintenance"). In the efi_mem_init(), it will disable the mmu, and build
> a new pagetable and re-enable the mmu, if the asm_mmu_disable clean and
> invalidate the data caches for entire memory, we don't need to care the dcache
> and after mmu disabled, we use the mmu_setup_early() to re-enable the mmu, which
> takes care all the cache maintenance. But the situation changes since the Patch
> #18 ("arm/arm64: Rework the cache maintenance in asm_mmu_disable") only clean
> and invalidate the data caches for the stack memory area. So we need to clean
> and invalidate the data caches manually before disable the mmu, I'm not
> confident about current cache maintenance at the efi setup patch, so I ask for
> your help to review it if it's right or not.
> 
> And I also drop one patch ("s390: Do not use the physical allocator") from[1]
> since this cause s390 test to fail.

This is unfortunate. What tests do you see failing?

I wrote the s390x patch so I can justify dropping the locking in the
physical allocator. And I wanted to drop the locking so I wouldn't have to
do maintenance operation on the spinlock.

Because of how kvm-unit-tests implements spinlocks for arm/arm64, they
don't protect against concurrent accesses when the MMU is turned off. And
because arm and arm64 use the physical allocator during the test boot
sequence, not during a test, using a spin lock is also useless since there
will be no concurrent accesses (the boot phase is done on a single CPU).

But since replacing the physical allocator causes test failures for s390x,
looks like the physical will still be needed to tests, and that requires
having the spinlock.

I guess the best approach would be to teach the physical allocator to do
cache maintenance on the spinlock. We might as well, since the UART needs
it too, and I don't think this series addresses that.

Thanks,
Alex

> 
> This series may include bug, so I really appreciate your review to improve this
> series together.
> 
> You can get the code from:
> 
> $ git clone https://gitlab.com/shahuang/kvm-unit-tests.git \
> 	-b arm-arm64-rework-cache-maintenance-at-boot-v1
> 
> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/arm-arm64-rework-cache-maintenance-at-boot-v2-wip2
> [2] https://lore.kernel.org/all/20220809091558.14379-1-alexandru.elisei@arm.com/
> [3] https://patchwork.kernel.org/project/kvm/cover/20230530160924.82158-1-nikos.nikoleris@arm.com/
> 
> Changelog:
> ----------
> RFC->v1:
>   - Gathered Reviewed-by tags.
>   - Various changes to commit messages and comments to hopefully make the code
>     easier to understand.
>   - Patches #8 ("lib/alloc_phys: Expand documentation with usage and limitations")
>     are new.
>   - Folded patch "arm: page.h: Add missing libcflat.h include" into #17
>     ("arm/arm64: Perform dcache maintenance at boot").
>   - Reordered the series to group patches that touch aproximately the same code
>     together - the patches that change the physical allocator are now first,
>     followed come the patches that change how the secondaries are brought online.
>   - Fixed several nasty bugs where the r4 register was being clobbered in the arm
>     assembly.
>   - Unmap the early UART address if the DTB address does not match the early
>     address.
>   - Added dcache maintenance when a page table is modified with the MMU disabled.
>   - Moved the cache maintenance when disabling the MMU to be executed before the
>     MMU is disabled.
>   - Rebase it on lasted branch which efi support has been merged.
>   - Make the efi test also enable MMU early.
>   - Add cache maintenance on efi setup path especially before mmu_disable.
> 
> RFC: https://lore.kernel.org/all/20220809091558.14379-1-alexandru.elisei@arm.com/
> 
> Alexandru Elisei (18):
>   Makefile: Define __ASSEMBLY__ for assembly files
>   powerpc: Replace the physical allocator with the page allocator
>   lib/alloc_phys: Initialize align_min
>   lib/alloc_phys: Consolidate allocate functions into memalign_early()
>   lib/alloc_phys: Remove locking
>   lib/alloc_phys: Remove allocation accounting
>   lib/alloc_phys: Add callback to perform cache maintenance
>   lib/alloc_phys: Expand documentation with usage and limitations
>   arm/arm64: Zero secondary CPUs' stack
>   arm/arm64: Allocate secondaries' stack using the page allocator
>   arm/arm64: assembler.h: Replace size with end address for
>     dcache_by_line_op
>   arm/arm64: Add C functions for doing cache maintenance
>   arm/arm64: Configure secondaries' stack before enabling the MMU
>   arm/arm64: Use pgd_alloc() to allocate mmu_idmap
>   arm/arm64: Enable the MMU early
>   arm/arm64: Map the UART when creating the translation tables
>   arm/arm64: Perform dcache maintenance at boot
>   arm/arm64: Rework the cache maintenance in asm_mmu_disable
> 
>  Makefile                   |   5 +-
>  arm/Makefile.arm           |   4 +-
>  arm/Makefile.arm64         |   4 +-
>  arm/Makefile.common        |   6 +-
>  arm/cstart.S               |  71 +++++++++++++++------
>  arm/cstart64.S             |  76 +++++++++++++++++------
>  lib/alloc_phys.c           | 122 ++++++++++++-------------------------
>  lib/alloc_phys.h           |  28 ++++++---
>  lib/arm/asm/assembler.h    |  15 ++---
>  lib/arm/asm/cacheflush.h   |   1 +
>  lib/arm/asm/mmu-api.h      |   1 +
>  lib/arm/asm/mmu.h          |   6 --
>  lib/arm/asm/page.h         |   2 +
>  lib/arm/asm/pgtable.h      |  39 ++++++++++--
>  lib/arm/asm/thread_info.h  |   3 +-
>  lib/arm/cache.S            |  89 +++++++++++++++++++++++++++
>  lib/arm/io.c               |  31 ++++++++++
>  lib/arm/io.h               |   3 +
>  lib/arm/mmu.c              |  37 ++++++++---
>  lib/arm/processor.c        |   1 -
>  lib/arm/setup.c            |  82 +++++++++++++++++++++----
>  lib/arm/smp.c              |   5 ++
>  lib/arm64/asm/assembler.h  |  11 ++--
>  lib/arm64/asm/cacheflush.h |  37 +++++++++++
>  lib/arm64/asm/mmu.h        |   5 --
>  lib/arm64/asm/pgtable.h    |  50 +++++++++++++--
>  lib/arm64/cache.S          |  85 ++++++++++++++++++++++++++
>  lib/arm64/processor.c      |   1 -
>  lib/devicetree.c           |   2 +-
>  lib/powerpc/setup.c        |   9 ++-
>  powerpc/Makefile.common    |   1 +
>  powerpc/cstart64.S         |   1 -
>  powerpc/spapr_hcall.c      |   5 +-
>  33 files changed, 642 insertions(+), 196 deletions(-)
>  create mode 100644 lib/arm/asm/cacheflush.h
>  create mode 100644 lib/arm/cache.S
>  create mode 100644 lib/arm64/asm/cacheflush.h
>  create mode 100644 lib/arm64/cache.S
> 
> -- 
> 2.40.1
> 

