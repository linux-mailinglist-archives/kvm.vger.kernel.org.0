Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B296F2558
	for <lists+kvm@lfdr.de>; Sat, 29 Apr 2023 18:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjD2QVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Apr 2023 12:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjD2QVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Apr 2023 12:21:37 -0400
Received: from out-42.mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24CE1BD4
        for <kvm@vger.kernel.org>; Sat, 29 Apr 2023 09:21:35 -0700 (PDT)
Date:   Sat, 29 Apr 2023 18:21:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682785294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgH+dy0m1NLW0tr6V00SP/hJ6pumwX3eW1PTyyT0F/0=;
        b=jO3yIGZfSN7twGwpMq98JbM4GDBm67cqAjYbDXAYyZoNPSeUexGYfHm+cn1UQCOXQaqzkx
        8zm8HUcCe2Xzk77NAglM3nLBN2HOikMWV2YvbsV3GN9ofyfNMhdGKDuYW8PTxVb6u9QhWo
        PYuVi1LyDw6RxqDUpvP7oJwRy9rr9Ig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, seanjc@google.com
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
Message-ID: <20230429-342c8a26e5db45474631a307@orel>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230429-6da987552a8d15281f8444c9@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230429-6da987552a8d15281f8444c9@orel>
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

On Sat, Apr 29, 2023 at 06:18:25PM +0200, Andrew Jones wrote:
> On Fri, Apr 28, 2023 at 01:03:36PM +0100, Nikos Nikoleris wrote:
> > Hello,
> > 
> > This series adds initial support for building arm64 tests as EFI
> > apps and running them under QEMU. Much like x86_64, we import external
> > dependencies from gnu-efi and adapt them to work with types and other
> > assumptions from kvm-unit-tests. In addition, this series adds support
> > for enumerating parts of the system using ACPI.
> > 
> > The first set of patches, moves the existing ACPI code to the common
> > lib path. Then, it extends definitions and functions to allow for more
> > robust discovery of ACPI tables. We add support for setting up the PSCI
> > conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
> > retains existing behavior and gives priority to discovery through DT
> > when one has been provided.
> > 
> > In the second set of patches, we add support for getting the command
> > line from the EFI shell. This is a requirement for many of the
> > existing arm64 tests.
> > 
> > In the third set of patches, we import code from gnu-efi, make minor
> > changes and add an alternative setup sequence from arm64 systems that
> > boot through EFI. Finally, we add support in the build system and a
> > run script which is used to run an EFI app.
> > 
> > After this set of patches one can build arm64 EFI tests:
> > 
> > $> ./configure --enable-efi
> > $> make
> > 
> > And use the run script to run an EFI tests:
> > 
> > $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> > 
> > Or all tests:
> > 
> > $> ./run_tests.sh
> > 
> > There are a few items that this series does not address but they would
> > be useful to have:
> >  - Support for booting the system from EL2. Currently, we assume that a
> >    test starts EL1. This will be required to run EFI tests on sytems
> >    that implement EL2.
> >  - Support for reading environment variables and populating __envp.
> >  - Support for discovering the PCI subsystem using ACPI.
> >  - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
> >    real HW.
> >  - Various fixes related to cache maintaince to better support turn the
> >    MMU off.
> >  - Switch to a new stack and avoid relying on the one provided by EFI.
> > 
> > git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
> > 
> > v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
> > v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> > v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> > 
> > Changes in v5:
> >  - Minor style changes (thanks Shaoqin).
> >  - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
> >  - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
> >    we run out of space (thanks Shaoqin).
> > 
> > Changes in v4:
> >  - Removed patch that reworks cache maintenance when turning the MMU
> >    off. This is not strictly required for EFI tests running with tcg and
> >    will be addressed in a separate series by Alex.
> >  - Fix compilation for arm (Alex).
> >  - Convert ACPI tables to Linux style (Alex).
> > 
> > Changes in v3:
> >  - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
> >  - Added support for discovering the GIC through ACPI
> >  - Added a missing header file (<elf.h>)
> >  - Added support for correctly parsing the outcome of tests (./run_tests)
> >
> 
> Thanks, Nikos!
> 
> I'd like to get an ack from either Paolo or Sean on the changes to ACPI,
> as they're shared with x86, and there are also some x86 code changes.

Actually, there are two build pipeline failures with the new ACPI code.
Please take a look at

https://gitlab.com/jones-drew/kvm-unit-tests/-/pipelines/852864569

Thanks,
drew

> 
> Also,
> 
>   1) It'd be nice if this worked with DT, too. We can use UEFI with DT
>      when adding '-no-acpi' to the QEMU command line. setup_efi() needs
>      to learn how to find the dtb and most the '#ifdef CONFIG_EFI's
>      would need to change to a new CONFIG_ACPI guard.
> 
>   2) The debug bp and ss tests fail with EFI, but not without, for me.
> 
>   3) The timer test runs (and succeeds) when run with
>      './arm/efi/run ./arm/timer.efi', but not when run with
>      './run_tests.sh -g timer'. This is because UEFI takes
>      up all the given timeout time (10s), and then the test times out.
>      The hackyish fix below resolves it for me. I'll consider posting it
>      as a real patch
> 
> Thanks,
> drew
> 
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 51e4b97b27d1..72ce718b1170 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -94,7 +94,17 @@ run_qemu_status ()
>  
>  timeout_cmd ()
>  {
> +	local s
> +
>  	if [ "$TIMEOUT" ] && [ "$TIMEOUT" != "0" ]; then
> +		if [ "$CONFIG_EFI" = 'y' ]; then
> +			s=${TIMEOUT: -1}
> +			if [ "$s" = 's' ]; then
> +				TIMEOUT=${TIMEOUT:0:-1}
> +				((TIMEOUT += 10)) # Add 10 seconds for booting UEFI
> +				TIMEOUT="${TIMEOUT}s"
> +			fi
> +		fi
>  		echo "timeout -k 1s --foreground $TIMEOUT"
>  	fi
>  }
