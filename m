Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF47652E983
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 11:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiETJ6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 05:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbiETJ6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 05:58:14 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6201DBA570
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 02:58:13 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3EB11477;
        Fri, 20 May 2022 02:58:12 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3D3A3F66F;
        Fri, 20 May 2022 02:58:11 -0700 (PDT)
Date:   Fri, 20 May 2022 10:58:21 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 00/23] EFI and ACPI support for arm64
Message-ID: <YodmLAum0h6qJ11Z@monolith.localdoman>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <Yn5mkl9iW/GfkU4G@monolith.localdoman>
 <2813ff66-0bb2-d7df-646f-833fc813e721@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2813ff66-0bb2-d7df-646f-833fc813e721@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 10:00:46AM +0100, Nikos Nikoleris wrote:
> Hi Alex,
> 
> On 13/05/2022 15:09, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Fri, May 06, 2022 at 09:55:42PM +0100, Nikos Nikoleris wrote:
> > > Hello,
> > > 
> > > This patch series adds initial support for building arm64 tests as EFI
> > > tests and running them under QEMU. Much like x86_64 we import external
> > 
> > I would like to see kvm-unit-tests run as an EFI app on real hardware.
> > QEMU's implementation of the architecture might be different than real
> > hardware, where considerations like power consumption, performance or die
> > area dictate how a particular feature is implementated. For example, I
> > don't know how out-of-order TCG is, and bugs like missing barriers are more
> > easily detected on highly out-of-order implementations.
> > 
> > On the other hand, I'm not opposed to this series if the purpose is just to
> > add the skeleton code needed to boot under EFI and hardware support comes
> > later.
> 
> I fully agree with you. This series is just the first step in getting EFI
> apps to run on real hardware. Hopefully, it's in the right direction and
> helps further development and testing for some of the functionality that we
> will need anyway.
> 
> If I understand correctly, we can run EFI tests with KVM too, at least for
> as long as we're fine with starting from EL1 so we should be exposed to some
> of the timing issues already.
> 
> > 
> > > dependencies from gnu-efi and adopt them to work with types and other
> > > assumptions from kvm-unit-tests. In addition, this series adds support
> > > for discovering parts of the machine using ACPI.
> > > 
> > > The first set of patches moves the existing ACPI code to the common
> > > lib path. Then, it extends definitions and functions to allow for more
> > > robust discovery of ACPI tables. In arm64, we add support for setting
> > > up the PSCI conduit, discovering the UART, timers and cpus via
> > > ACPI. The code retains existing behavior and gives priority to
> > > discovery through DT when one has been provided.
> > > 
> > > In the second set of patches, we add support for getting the command
> > > line from the EFI shell. This is a requirement for many of the
> > > existing arm64 tests.
> > > 
> > > In the third set of patches, we import code from gnu-efi, make minor
> > > changes and add an alternative setup sequence from arm64 systems that
> > > boot through EFI. Finally, we add support in the build system and a
> > > run script which is used to run an EFI app.
> > > 
> > > After this set of patches one can build arm64 EFI tests:
> > > 
> > > $> ./configure --enable-efi
> > > $> make
> > > 
> > > And use the run script to run an EFI tests:
> > > 
> > > $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> > > 
> > > Or all tests:
> > > 
> > > $> ./run_tests.sh
> > > 
> > > There are a few items that this series does not address but they would
> > > be useful to have:
> > > 
> > > * Support for booting the system from EL2. Currently, we assume that a
> > > tests starts running at EL1. This the case when we run with EFI, it's
> > > not always the case in hardware.
> > 
> > I would add to that the fact that the vmalloc area is between 3 and 4 GB.
> > What happens if real hardware has main memory there? For this point at
> > least, for testing you can use my kvmtool series that allows the user to
> > set the memory base address [1].
> 
> I am not sure, I fully understand the problem with this. In 13/26, we use

setup_efi() calls setup_vm() -> .. -> setup_mmu(). In setup_mmu(), the
vmalloc area is initialized as starting from 4GB, and
malloc/calloc/memalign will allocate memory down from it.

This means that memory allocations made by a test have the potential to
overwrite the test image if enough memory is allocated:

vree_top - size <= image_base_address && RAM size >= size

The second condition is needed because otherwise the assert in
virt_to_phys() -> __virt_to_phys() triggers when the allocator tries to
allocate more memory than the total RAM size.

This also can happen with mainline. Launch a test with at least 3GB of
memory on qemu/2GB of memory on kvmtool (so RAM top is at least 4GB) and
allocate 3GB on qemu/2GB on kvmtool with malloc and you will see the VM
hang because vm_memalign() will write metadata to the text section of the
test image.

I believe this is more likely to happen on baremetal as real machines have
a lot more memory than tests, which use the default memory size for qemu,
128MB (except selftest-setup, which configures 256MB).

One idea would be to reserve a region for vmalloc that doesn't overlap with
any of the detected memory regions. That would involve adding a limit on
the addresses that allocations can return. It would be nice to take into
account the memory layout for kvmtool (kvm-unit-tests adds IO regions only
for the qemu memory layout, not for kvmtool). There might be other/better
ways to solve this.

Just FYI, kvmtool can also run UEFI in a VM, so you can use that too for
testing.

Thanks,
Alex

> the efi memory map to avoid making many assumption about the physical memory
> map, but I will have a look at the functionality we implement in vmalloc.c
> to understand this. On a high level, I agree with you. The goal should to
> have tests discover as much about the underlying system as possible.
> 
> FWIW, this TODO list is missing many points that I've already discovered and
> I am sure there will be a few more on top of that.
> 
> > 
> > I think there might be other assumptions that kvm-unit-tests makes which
> > are not true when running on baremetal. That's why I would prefer that EFI
> > support is also tested on baremetal.
> > 
> > [1] https://lore.kernel.org/all/20220428155602.29445-1-alexandru.elisei@arm.com/
> > 
> 
> I agree, hopefully testing with KVM and TCG is helpful but I wouldn't expect
> it to be sufficient.
> 
> Thanks,
> 
> Nikos
> 
> > Thanks,
> > Alex
> > 
> > > 
> > > * Support for reading environment variables and populating __envp.
> > > 
> > > * Support for discovering the chr-testdev through ACPI.
> > > 
> > > PS: Apologies for the mess with v1. Due to a mistake in my git
> > > send-email configuration some patches didn't make it to the list and
> > > the right recipients.
> > > 
> > > Thanks,
> > > 
> > > Nikos
> > > 
> > > Andrew Jones (3):
> > >    arm/arm64: mmu_disable: Clean and invalidate before disabling
> > >    arm/arm64: Rename etext to _etext
> > >    arm64: Add a new type of memory type flag MR_F_RESERVED
> > > 
> > > Nikos Nikoleris (20):
> > >    lib: Move acpi header and implementation to lib
> > >    lib: Ensure all struct definition for ACPI tables are packed
> > >    lib: Add support for the XSDT ACPI table
> > >    lib: Extend the definition of the ACPI table FADT
> > >    arm/arm64: Add support for setting up the PSCI conduit through ACPI
> > >    arm/arm64: Add support for discovering the UART through ACPI
> > >    arm/arm64: Add support for timer initialization through ACPI
> > >    arm/arm64: Add support for cpu initialization through ACPI
> > >    lib/printf: Support for precision modifier in printing strings
> > >    lib/printf: Add support for printing wide strings
> > >    lib/efi: Add support for getting the cmdline
> > >    lib: Avoid ms_abi for calls related to EFI on arm64
> > >    arm/arm64: Add a setup sequence for systems that boot through EFI
> > >    arm64: Copy code from GNU-EFI
> > >    arm64: Change GNU-EFI imported file to use defined types
> > >    arm64: Use code from the gnu-efi when booting with EFI
> > >    lib: Avoid external dependency in libelf
> > >    x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
> > >    arm64: Add support for efi in Makefile
> > >    arm64: Add an efi/run script
> > > 
> > >   scripts/runtime.bash        |  14 +-
> > >   arm/efi/run                 |  61 +++++++++
> > >   arm/run                     |   8 +-
> > >   configure                   |  15 ++-
> > >   Makefile                    |   4 -
> > >   arm/Makefile.arm            |   6 +
> > >   arm/Makefile.arm64          |  18 ++-
> > >   arm/Makefile.common         |  48 +++++--
> > >   x86/Makefile.common         |   2 +-
> > >   x86/Makefile.x86_64         |   4 +
> > >   lib/linux/efi.h             |  44 ++++++
> > >   lib/arm/asm/setup.h         |   3 +
> > >   lib/arm/asm/timer.h         |   2 +
> > >   lib/x86/asm/setup.h         |   2 +-
> > >   lib/acpi.h                  | 260 ++++++++++++++++++++++++++++++++++++
> > >   lib/stdlib.h                |   1 +
> > >   lib/x86/acpi.h              | 112 ----------------
> > >   lib/acpi.c                  | 124 +++++++++++++++++
> > >   lib/arm/io.c                |  21 ++-
> > >   lib/arm/mmu.c               |   4 +
> > >   lib/arm/psci.c              |  25 +++-
> > >   lib/arm/setup.c             | 247 +++++++++++++++++++++++++++-------
> > >   lib/arm/timer.c             |  73 ++++++++++
> > >   lib/devicetree.c            |   2 +-
> > >   lib/efi.c                   | 123 +++++++++++++++++
> > >   lib/printf.c                | 183 +++++++++++++++++++++++--
> > >   lib/string.c                |   2 +-
> > >   lib/x86/acpi.c              |  82 ------------
> > >   arm/efi/elf_aarch64_efi.lds |  63 +++++++++
> > >   arm/flat.lds                |   2 +-
> > >   arm/cstart.S                |  29 +++-
> > >   arm/cstart64.S              |  28 +++-
> > >   arm/efi/crt0-efi-aarch64.S  | 143 ++++++++++++++++++++
> > >   arm/dummy.c                 |   4 +
> > >   arm/efi/reloc_aarch64.c     |  93 +++++++++++++
> > >   x86/s3.c                    |  20 +--
> > >   x86/vmexit.c                |   4 +-
> > >   37 files changed, 1556 insertions(+), 320 deletions(-)
> > >   create mode 100755 arm/efi/run
> > >   create mode 100644 lib/acpi.h
> > >   delete mode 100644 lib/x86/acpi.h
> > >   create mode 100644 lib/acpi.c
> > >   create mode 100644 lib/arm/timer.c
> > >   delete mode 100644 lib/x86/acpi.c
> > >   create mode 100644 arm/efi/elf_aarch64_efi.lds
> > >   create mode 100644 arm/efi/crt0-efi-aarch64.S
> > >   create mode 100644 arm/dummy.c
> > >   create mode 100644 arm/efi/reloc_aarch64.c
> > > 
> > > -- 
> > > 2.25.1
> > > 
