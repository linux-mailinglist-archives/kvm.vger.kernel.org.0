Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E28B726935
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 20:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjFGSwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 14:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjFGSwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 14:52:37 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [IPv6:2001:41d0:203:375::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1426D1BD0
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 11:52:35 -0700 (PDT)
Date:   Wed, 7 Jun 2023 20:52:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686163953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jvZ6xTwagi2X5T/9lZN7YuM3WLVq29x4N6G6EzrAEN4=;
        b=qRMmCzlQ0168QELnq5OEikMBNJeBD2EW9ugsCoXVkVJfSgM7zEE4WpbRr/+BIXEsFZTFT2
        QyoMb/N4b8grTCdNfdMcvhju9o7Q+QbG5pFcoo4lbHf1/RuiLltqGgq9ZJyerdPT+o5jbc
        tGiQf8mHKIUxn1qysqUL5DhRMLTBtT8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230607-49d0c961801a046da5b39457@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 05:08:52PM +0100, Nikos Nikoleris wrote:
> Hello,
> 
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.
> 
> The first set of patches, moves the existing ACPI code to the common
> lib path. Then, it extends definitions and functions to allow for more
> robust discovery of ACPI tables. We add support for setting up the PSCI
> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
> retains existing behavior and gives priority to discovery through DT
> when one has been provided.
> 
> In the second set of patches, we add support for getting the command
> line from the EFI shell. This is a requirement for many of the
> existing arm64 tests.
> 
> In the third set of patches, we import code from gnu-efi, make minor
> changes and add an alternative setup sequence from arm64 systems that
> boot through EFI. Finally, we add support in the build system and a
> run script which is used to run an EFI app.
> 
> After this set of patches one can build arm64 EFI tests:
> 
> $> ./configure --enable-efi
> $> make
> 
> And use the run script to run an EFI tests:
> 
> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> 
> Or all tests:
> 
> $> ./run_tests.sh
> 
> There are a few items that this series does not address but they would
> be useful to have:
>  - Support for booting the system from EL2. Currently, we assume that a
>    test starts EL1. This will be required to run EFI tests on sytems
>    that implement EL2.
>  - Support for reading environment variables and populating __envp.
>  - Support for discovering the PCI subsystem using ACPI.
>  - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>    real HW.
>  - Various fixes related to cache maintaince to better support turn the
>    MMU off.
>  - Switch to a new stack and avoid relying on the one provided by EFI.
> 
> git branch: https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v6 
> 
> v5: https://lore.kernel.org/kvmarm/20230428120405.3770496-1-nikos.nikoleris@arm.com/
> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> 
> Changes in v6:
>  - Fixed a symbol issue in the debug tests that would cause them to fail
>    when build with fPIC.
>  - Added support for booting with FDT.
> 
> Changes in v5:
>  - Minor style changes (thanks Shaoqin).
>  - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>  - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>    we run out of space (thanks Shaoqin).
> 
> Changes in v4:
>  - Removed patch that reworks cache maintenance when turning the MMU
>    off. This is not strictly required for EFI tests running with tcg and
>    will be addressed in a separate series by Alex.
>  - Fix compilation for arm (Alex).
>  - Convert ACPI tables to Linux style (Alex).
> 
> Changes in v3:
>  - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>  - Added support for discovering the GIC through ACPI
>  - Added a missing header file (<elf.h>)
>  - Added support for correctly parsing the outcome of tests (./run_tests)
> 
> Thanks,
> 
> Nikos
>

Applied to arm/queue. Thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
