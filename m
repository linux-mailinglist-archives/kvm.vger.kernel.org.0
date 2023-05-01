Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4C66F309D
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjEAMKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjEAMKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:10:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE5819B
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682942983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bTR4qmPC5jiGnWXmXgq6yKiRVCe+WmrIqwmx0autYgo=;
        b=bsluVUObqxT1zKjvG130tFnWVAK6tqEMUD1kKHGRhB1J9BkT3S4fhx52G0q6qUGWpPomaw
        k461r8yxHnrgce/01RiGr5TFUjB4s08etJF7+ci0SdVWgGjc4ZBwvLqdOCQSjr7Cv158HY
        xLc7ubLd6/9M+C8MZWJpMkxqeJR3LIA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-a1PEub0WOYuM8AoPGcx2sw-1; Mon, 01 May 2023 08:09:42 -0400
X-MC-Unique: a1PEub0WOYuM8AoPGcx2sw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1a6963bbb3dso2674405ad.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:09:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682942981; x=1685534981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bTR4qmPC5jiGnWXmXgq6yKiRVCe+WmrIqwmx0autYgo=;
        b=edeKMkH69g51JKygA6sfX2f6X5XKjS+Ivd5lIFIEHWtlRON74hwnb8z/lQH3a7avim
         tPwZ8kM8d8RfzBRd+7hvHwNNuscLIa7+QhDQoiFsKP+TNKZjPx0q95ZCVA2+Fz1kzqg3
         CaUlQSbcTBBAdU41CZ9T494FaYv8FTfX+pFcURzh4XysXX2pLltHEIzahX+MnEUIsDoB
         NqmIZK7xw35p5EkQQop2h0c6ZPY2+MIeazlrlBn0I/oRu1Wjf0rcEReUTFUmJFBjsvy4
         jjnIrHj58Czl95ykkPM08q6F+UluaB3vCjTkGDh2xHAaQVX1750oLY/vqg1CcNKv0J/7
         yFdQ==
X-Gm-Message-State: AC+VfDzIKej6v71hvvScKAhvF9ETGvMF8x5ohXG6kYfYG0X91kb+OqcT
        EezQxxeTc8pi9oj2VJdPb/8QSCX0eFlMY5SlojiVjFwOV7oc37VhdXqa+u/v1iuTGGqoOW5WihY
        T1iJj4pITpr2j
X-Received: by 2002:a17:902:f688:b0:1a6:e00b:c3e5 with SMTP id l8-20020a170902f68800b001a6e00bc3e5mr16641231plg.4.1682942981481;
        Mon, 01 May 2023 05:09:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5lgXligMC/Sba2Qe5cV0d9gKgs5mH8kzYP8On4TjijSdIh8F+VMP7gbuBz3HG8fzYT5hgL6Q==
X-Received: by 2002:a17:902:f688:b0:1a6:e00b:c3e5 with SMTP id l8-20020a170902f68800b001a6e00bc3e5mr16641200plg.4.1682942981065;
        Mon, 01 May 2023 05:09:41 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902e80d00b0019719f752c5sm7487498plg.59.2023.05.01.05.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:09:40 -0700 (PDT)
Message-ID: <b6e3bc3f-d409-00ae-df0f-4bcea9ec0330@redhat.com>
Date:   Mon, 1 May 2023 20:09:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Content-Language: en-US
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

When I test this series by simply run ./run_tests.sh, some migration 
test will hang up forever, like the `its-migration` test.

After have a quick look, when do the migration test, the guest can't be 
migrated due to:

{"return": {"blocked-reasons": ["The qcow format used by node 
'#block389' does not support live migration", "The vvfat (rw) format 
used by node '#block085' does not support live migration"]}}

Although the guest will be timeout, but the script itself will not be 
timeout. The infinite loop happened at here:

// script/arch-run.bash
   151         # Wait for the migration to complete
   152         migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
   153         while ! grep -q '"completed"' <<<"$migstatus" ; do
   154                 sleep 1
   155                 migstatus=`qmp ${qmp1} '"query-migrate"' | grep 
return`
   156                 if grep -q '"failed"' <<<"$migstatus" ; then
   157                         echo "ERROR: Migration failed." >&2
   158                         qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
   159                         qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
   160                         return 2
   161                 fi
   162         done

Since the "query-migrate" here will never get "completed" or "failed", 
so it will never exit.

Have you ever meet this problem?

Thanks,
Shaoqin

On 4/28/23 20:03, Nikos Nikoleris wrote:
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
>   - Support for booting the system from EL2. Currently, we assume that a
>     test starts EL1. This will be required to run EFI tests on sytems
>     that implement EL2.
>   - Support for reading environment variables and populating __envp.
>   - Support for discovering the PCI subsystem using ACPI.
>   - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>     real HW.
>   - Various fixes related to cache maintaince to better support turn the
>     MMU off.
>   - Switch to a new stack and avoid relying on the one provided by EFI.
> 
> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
> 
> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> 
> Changes in v5:
>   - Minor style changes (thanks Shaoqin).
>   - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>   - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>     we run out of space (thanks Shaoqin).
> 
> Changes in v4:
>   - Removed patch that reworks cache maintenance when turning the MMU
>     off. This is not strictly required for EFI tests running with tcg and
>     will be addressed in a separate series by Alex.
>   - Fix compilation for arm (Alex).
>   - Convert ACPI tables to Linux style (Alex).
> 
> Changes in v3:
>   - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>   - Added support for discovering the GIC through ACPI
>   - Added a missing header file (<elf.h>)
>   - Added support for correctly parsing the outcome of tests (./run_tests)
> 
> Thanks,
> 
> Nikos
> 
> Alexandru Elisei (2):
>    lib/acpi: Convert table names to Linux style
>    lib: arm: Print test exit status
> 
> Andrew Jones (2):
>    arm/arm64: Rename etext to _etext
>    arm64: Add a new type of memory type flag MR_F_RESERVED
> 
> Nikos Nikoleris (25):
>    lib: Move acpi header and implementation to lib
>    x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>    lib: Apply Lindent to acpi.{c,h}
>    lib: Fix style for acpi.{c,h}
>    x86: Avoid references to fields of ACPI tables
>    lib/acpi: Ensure all struct definition for ACPI tables are packed
>    lib/acpi: Add support for the XSDT table
>    lib/acpi: Extend the definition of the FADT table
>    devicetree: Check that fdt is not NULL in dt_available()
>    arm64: Add support for setting up the PSCI conduit through ACPI
>    arm64: Add support for discovering the UART through ACPI
>    arm64: Add support for timer initialization through ACPI
>    arm64: Add support for cpu initialization through ACPI
>    arm64: Add support for gic initialization through ACPI
>    lib/printf: Support for precision modifier in printf
>    lib/printf: Add support for printing wide strings
>    lib/efi: Add support for getting the cmdline
>    lib: Avoid ms_abi for calls related to EFI on arm64
>    arm64: Add a setup sequence for systems that boot through EFI
>    arm64: Copy code from GNU-EFI
>    arm64: Change GNU-EFI imported code to use defined types
>    arm64: Use code from the gnu-efi when booting with EFI
>    lib: Avoid external dependency in libelf
>    arm64: Add support for efi in Makefile
>    arm64: Add an efi/run script
> 
>   scripts/runtime.bash        |  13 +-
>   arm/efi/run                 |  61 ++++++++
>   arm/run                     |  14 +-
>   configure                   |  17 +-
>   Makefile                    |   4 -
>   arm/Makefile.arm            |   6 +
>   arm/Makefile.arm64          |  22 ++-
>   arm/Makefile.common         |  47 ++++--
>   x86/Makefile.common         |   2 +-
>   x86/Makefile.x86_64         |   4 +
>   lib/linux/efi.h             |  25 +++
>   lib/arm/asm/setup.h         |   9 ++
>   lib/arm/asm/timer.h         |   2 +
>   lib/x86/asm/setup.h         |   2 +-
>   lib/acpi.h                  | 301 ++++++++++++++++++++++++++++++++++++
>   lib/argv.h                  |   1 +
>   lib/elf.h                   |  57 +++++++
>   lib/libcflat.h              |   1 +
>   lib/x86/acpi.h              | 112 --------------
>   lib/acpi.c                  | 129 ++++++++++++++++
>   lib/argv.c                  |   2 +-
>   lib/arm/gic.c               | 139 ++++++++++++++++-
>   lib/arm/io.c                |  41 ++++-
>   lib/arm/mmu.c               |   4 +
>   lib/arm/psci.c              |  37 ++++-
>   lib/arm/setup.c             | 269 ++++++++++++++++++++++++++------
>   lib/arm/timer.c             |  92 +++++++++++
>   lib/devicetree.c            |   2 +-
>   lib/efi.c                   | 102 ++++++++++++
>   lib/printf.c                | 194 +++++++++++++++++++++--
>   lib/x86/acpi.c              |  82 ----------
>   lib/x86/setup.c             |   2 +-
>   arm/efi/elf_aarch64_efi.lds |  63 ++++++++
>   arm/flat.lds                |   2 +-
>   arm/cstart.S                |   1 +
>   arm/cstart64.S              |   7 +
>   arm/efi/crt0-efi-aarch64.S  | 141 +++++++++++++++++
>   arm/dummy.c                 |  12 ++
>   arm/efi/reloc_aarch64.c     |  94 +++++++++++
>   arm/micro-bench.c           |   4 +-
>   arm/timer.c                 |  10 +-
>   x86/s3.c                    |  21 +--
>   x86/vmexit.c                |   4 +-
>   43 files changed, 1831 insertions(+), 323 deletions(-)
>   create mode 100755 arm/efi/run
>   create mode 100644 lib/acpi.h
>   create mode 100644 lib/elf.h
>   delete mode 100644 lib/x86/acpi.h
>   create mode 100644 lib/acpi.c
>   create mode 100644 lib/arm/timer.c
>   delete mode 100644 lib/x86/acpi.c
>   create mode 100644 arm/efi/elf_aarch64_efi.lds
>   create mode 100644 arm/efi/crt0-efi-aarch64.S
>   create mode 100644 arm/dummy.c
>   create mode 100644 arm/efi/reloc_aarch64.c
> 

-- 
Shaoqin

