Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF358D6BA
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbiHIJs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiHIJs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:48:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C8101EADD
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:48:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0801B23A;
        Tue,  9 Aug 2022 02:48:56 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 270AD3F67D;
        Tue,  9 Aug 2022 02:48:54 -0700 (PDT)
Date:   Tue, 9 Aug 2022 10:49:39 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 00/19] arm/arm64: Rework cache
 maintenance at boot
Message-ID: <YvItLoy20gj+WWGk@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Forgot to add a link to the gitlab branch with the series [1].

[1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-ae/-/tree/arm-arm64-rework-cache-maintenance-at-boot-v1

Thanks,
Alex

On Tue, Aug 09, 2022 at 10:15:39AM +0100, Alexandru Elisei wrote:
> I got the idea for this series as I was looking at the UEFI support series
> [1]. More specifically, I realized that the cache maintenance performed by
> asm_mmu_disable is insuficient. Patch #19 ("arm/arm64: Rework the cache
> maintenance in asm_mmu_disable") describes what is wrong with
> asm_mmu_disable. A detailed explanation of what cache maintenance is needed
> and why is needed can be found in patch #18 ("arm/arm64: Perform dcache
> maintenance at boot").
> 
> Then I realized that I couldn't fix only asm_mmu_disable, and leave the
> rest of kvm-unit-tests without the needed cache maintenance, so here it is,
> my attempt at adding the cache maintenace operations (from now on, CMOs)
> required by the architecture.
> 
> My approach is to try to enable the MMU and build the translation tables as
> soon as possible, to avoid as much of cache maintenance as possible. I
> didn't want to do it in the early assembly code, like Linux, because I like
> the fact that kvm-unit-tests keeps the assembly code to a minimum, and I
> wanted to preserve that. So I made the physical allocator simpler (patches
> #2-#6) so it can be used to create the translation tables immediately after
> the memory regions are populated.
> 
> After moving some code around, especially how the secondaries are brought
> online, the dcache maintenance is implemented in patch #18 ("arm/arm64:
> Perform dcache maintenance at boot").
> 
> The series is an RFC, and I open to suggestions about how to do things
> better; I'm happy to rework the entire series if a better approach is
> proposed.
> 
> Why is this needed? Nobody complained about test failing because of missing
> CMOs before, so why add them now? I see two reasons for the series:
> 
> 1. For architectural correctness. The emphasis has been so far on the test
> themselves to be architectural compliant, but I believe that the boot code
> should get the same treatment. kvm-unit-tests has started to be used in
> different ways than before, and I don't think that we should limit
> ourselves to running under one hypervisor, or running under a hypervisor at
> all. Which brings me to point number 2.
> 
> 2. If nothing else, this can serve as a showcase for the UEFI support
> series for the required cache maintenance. Although I hope that UEFI
> support will end up sharing at least some of the boot code with the
> non-UEFI boot path.
> 
> This is an RFC and has some rough edges, probably also bugs, but I believe
> the concept to be sound. If/when the series stabilizes, I'll probably split
> it into separate series (for example, the __ASSEMBLY__ define patch could
> probably be separate from the others). Tested by running all the arm and
> arm64 tests on a rockpro64 with qemu.
> 
> [1] https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> 
> Alexandru Elisei (19):
>   Makefile: Define __ASSEMBLY__ for assembly files
>   lib/alloc_phys: Initialize align_min
>   lib/alloc_phys: Use phys_alloc_aligned_safe and rename it to
>     memalign_early
>   powerpc: Use the page allocator
>   lib/alloc_phys: Remove locking
>   lib/alloc_phys: Remove allocation accounting
>   arm/arm64: Mark the phys_end parameter as unused in setup_mmu()
>   arm/arm64: Use pgd_alloc() to allocate mmu_idmap
>   arm/arm64: Zero secondary CPUs' stack
>   arm/arm64: Enable the MMU early
>   arm/arm64: Map the UART when creating the translation tables
>   arm/arm64: assembler.h: Replace size with end address for
>     dcache_by_line_op
>   arm: page.h: Add missing libcflat.h include
>   arm/arm64: Add C functions for doing cache maintenance
>   lib/alloc_phys: Add callback to perform cache maintenance
>   arm/arm64: Allocate secondaries' stack using the page allocator
>   arm/arm64: Configure secondaries' stack before enabling the MMU
>   arm/arm64: Perform dcache maintenance at boot
>   arm/arm64: Rework the cache maintenance in asm_mmu_disable
> 
>  Makefile                   |   5 +-
>  arm/Makefile.arm           |   4 +-
>  arm/Makefile.arm64         |   4 +-
>  arm/Makefile.common        |   4 +-
>  arm/cstart.S               |  59 ++++++++++++------
>  arm/cstart64.S             |  56 +++++++++++++----
>  lib/alloc_phys.c           | 122 ++++++++++++-------------------------
>  lib/alloc_phys.h           |  13 +++-
>  lib/arm/asm/assembler.h    |  15 ++---
>  lib/arm/asm/cacheflush.h   |   1 +
>  lib/arm/asm/mmu-api.h      |   1 +
>  lib/arm/asm/mmu.h          |   6 --
>  lib/arm/asm/page.h         |   2 +
>  lib/arm/asm/pgtable.h      |  52 ++++++++++++++--
>  lib/arm/asm/thread_info.h  |   3 +-
>  lib/arm/cache.S            |  89 +++++++++++++++++++++++++++
>  lib/arm/io.c               |   5 ++
>  lib/arm/io.h               |   3 +
>  lib/arm/mmu.c              |  60 +++++++++++-------
>  lib/arm/processor.c        |   6 +-
>  lib/arm/setup.c            |  66 ++++++++++++++++----
>  lib/arm/smp.c              |   9 ++-
>  lib/arm64/asm/assembler.h  |  11 ++--
>  lib/arm64/asm/cacheflush.h |  32 ++++++++++
>  lib/arm64/asm/mmu.h        |   5 --
>  lib/arm64/asm/pgtable.h    |  67 ++++++++++++++++++--
>  lib/arm64/cache.S          |  85 ++++++++++++++++++++++++++
>  lib/arm64/processor.c      |   5 +-
>  lib/devicetree.c           |   2 +-
>  lib/powerpc/setup.c        |   8 +++
>  powerpc/Makefile.common    |   1 +
>  powerpc/cstart64.S         |   1 -
>  powerpc/spapr_hcall.c      |   5 +-
>  33 files changed, 608 insertions(+), 199 deletions(-)
>  create mode 100644 lib/arm/asm/cacheflush.h
>  create mode 100644 lib/arm/cache.S
>  create mode 100644 lib/arm64/asm/cacheflush.h
>  create mode 100644 lib/arm64/cache.S
> 
> -- 
> 2.37.1
> 
