Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7EF539715
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347313AbiEaTkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242211AbiEaTj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:39:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962E24BFCC;
        Tue, 31 May 2022 12:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654025997; x=1685561997;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gF0nyP8PXBvEaOQLcanlipcyPiLef9ZSAOk8jToLceM=;
  b=FiDKgOac5IbXlxDMVo1756gv+sES4RLZ423oRMQe1uHfdQBg9iL7/EW/
   hTcYD0Q8qq4tAo9XMGxI2cgiwJtfQMrSDk6N4Ft9cqAG7YkVgnscMroAJ
   m2Pr23mI/xcYM47zNo6c/6LyL6N3yRHIcwAT85pLA0h1evFQyz8bzJ6Hh
   NFr6fNLjjiI4+BAiCTxMnj2pTcGOxDZ7ZBYZlvPFYtX5Q0G7d4UMqrSiU
   XHAG1TIQW9qdvkPseIQmwWeUy6yQoULvsWPKdBmuj//RVsKaF0VoISlQ5
   rUdGWCP5KPonsruo4tMEJ6K20NQQoJmMVJGmuN3NjRVd42UrcjSR9rPhs
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272934989"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272934989"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:39:56 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164096"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:39:53 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 00/22] TDX host kernel support
Date:   Wed,  1 Jun 2022 07:39:23 +1200
Message-Id: <cover.1654025430.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  This series provides support for
initializing TDX in the host kernel.

KVM support for TDX is being developed separately[1].  A new fd-based
approach to supporting TDX private memory is also being developed[2].
The KVM will only support the new fd-based approach as TD guest backend.

You can find TDX related specs here:
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

You can also find this series in below repo in github:
https://github.com/intel/tdx/tree/host-upstream

This series is rebased to latest tip/x86/tdx.

I highly appreciate if anyone can help to review this series.  For Intel
reviewers, please help to review, and I would appreciate reviewed-by or
acked-by tags if the patches look good to you.

Changelog history:

- v3 -> v4 (addressed Dave's comments, and other comments from others):

 - Simplified SEAMRR and TDX keyID detection.
 - Added patches to handle ACPI CPU hotplug.
 - Added patches to handle ACPI memory hotplug and driver managed memory
   hotplug.
 - Removed tdx_detect() but only use single tdx_init().
 - Removed detecting TDX module via P-SEAMLDR.
 - Changed from using e820 to using memblock to convert system RAM to TDX
   memory.
 - Excluded legacy PMEM from TDX memory.
 - Removed the boot-time command line to disable TDX patch.
 - Addressed comments for other individual patches (please see individual
   patches).
 - Improved the documentation patch based on the new implementation.

- V2 -> v3:

 - Addressed comments from Isaku.
  - Fixed memory leak and unnecessary function argument in the patch to
    configure the key for the global keyid (patch 17).
  - Enhanced a little bit to the patch to get TDX module and CMR
    information (patch 09).
  - Fixed an unintended change in the patch to allocate PAMT (patch 13).
 - Addressed comments from Kevin:
  - Slightly improvement on commit message to patch 03.
 - Removed WARN_ON_ONCE() in the check of cpus_booted_once_mask in
   seamrr_enabled() (patch 04).
 - Changed documentation patch to add TDX host kernel support materials
   to Documentation/x86/tdx.rst together with TDX guest staff, instead
   of a standalone file (patch 21)
 - Very minor improvement in commit messages.

- RFC (v1) -> v2:
  - Rebased to Kirill's latest TDX guest code.
  - Fixed two issues that are related to finding all RAM memory regions
    based on e820.
  - Minor improvement on comments and commit messages.

v3:
https://lore.kernel.org/lkml/68484e168226037c3a25b6fb983b052b26ab3ec1.camel@intel.com/T/

V2:
https://lore.kernel.org/lkml/cover.1647167475.git.kai.huang@intel.com/T/

RFC (v1):
https://lore.kernel.org/all/e0ff030a49b252d91c789a89c303bb4206f85e3d.1646007267.git.kai.huang@intel.com/T/

== Background ==

Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  TDX introduces a new CPU mode called
Secure Arbitration Mode (SEAM) and a new isolated range pointed by the
SEAM Ranger Register (SEAMRR).  A CPU-attested software module called
'the TDX module' implements the functionalities to manage and run
protected VMs.  The TDX module (and it's loader called the 'P-SEAMLDR')
runs inside the new isolated range and is protected from the untrusted
host VMM.

TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
as TDX private KeyIDs, which are only accessible within the SEAM mode.
BIOS is responsible for partitioning legacy MKTME KeyIDs and TDX KeyIDs.

TDX is different from AMD SEV/SEV-ES/SEV-SNP, which uses a dedicated
secure processor to provide crypto-protection.  The firmware runs on the
secure processor acts a similar role as the TDX module.

The host kernel communicates with SEAM software via a new SEAMCALL
instruction.  This is conceptually similar to a guest->host hypercall,
except it is made from the host to SEAM software instead.

Before being able to manage TD guests, the TDX module must be loaded
and properly initialized using SEAMCALLs defined by TDX architecture.
This series assumes the TDX module are loaded by BIOS before the kernel
boots.

There's no CPUID or MSR to detect whether the TDX module has been loaded.
The SEAMCALL instruction fails with VMfailInvalid if the target SEAM
software (either the P-SEAMLDR or the TDX module) is not loaded.  It can
be used to directly detect the TDX module.

The TDX module is initialized in multiple steps:

  1) Global initialization;
  2) Logical-CPU scope initialization;
  3) Enumerate information of the TDX module and TDX capable memory.
  4) Configure the TDX module about TDX-usable memory ranges and a global
     TDX KeyID which protects the TDX module metadata.
  5) Package-scope configuration for the global TDX KeyID;
  6) Initialize TDX metadata for usable memory ranges based on 4).

Step 2) requires calling some SEAMCALL on all "BIOS-enabled" (in MADT
table) logical cpus, otherwise step 4) will fail.  Step 5) requires
calling SEAMCALL on at least one cpu on all packages.

Also, the TDX module could already have been initialized or in shutdown
mode for a kexec()-ed kernel (see below kexec() section).  In this case,
the first step of above process will fail immediately.

TDX module can also be shut down at any time during module's lifetime, by
calling SEAMCALL on all "BIOS-enabled" logical cpus.

== Design Considerations ==

1. Initialize the TDX module at runtime

There are basically two ways the TDX module could be initialized: either
in early boot, or at runtime before the first TDX guest is run.  This
series implements the runtime initialization.

This series adds a function tdx_init() to allow the caller to initialize
TDX at runtime:

        if (tdx_init())
                goto no_tdx;
	// TDX is ready to create TD guests.

This approach has below pros:

1) Initializing the TDX module requires to reserve ~1/256th system RAM as
metadata.  Enabling TDX on demand allows only to consume this memory when
TDX is truly needed (i.e. when KVM wants to create TD guests).

2) SEAMCALL requires CPU being already in VMX operation (VMXON has been
done) otherwise it causes #UD.  So far, KVM is the only user of TDX, and
it guarantees all online CPUs are in VMX operation when there's any VM.
Letting KVM to initialize TDX at runtime avoids handling VMXON/VMXOFF in
the core kernel.  Also, in the long term, more kernel components will
need to use TDX thus likely a reference-based approach to do VMXON/VMXOFF
is needed in the core kernel.

3) It is more flexible to support "TDX module runtime update" (not in
this series).  After updating to the new module at runtime, kernel needs
to go through the initialization process again.  For the new module,
it's possible the metadata allocated for the old module cannot be reused
for the new module, and needs to be re-allocated again.

2. Kernel policy on TDX memory

The TDX architecture allows the VMM to designate specific memory as
usable for TDX private memory.  This series chooses to designate _all_
system RAM as TDX to avoid having to modify the page allocator to
distinguish TDX and non-TDX-capable memory.

3. CPU hotplug

TDX doesn't work with ACPI CPU hotplug.  To guarantee the security MCHECK
verifies all logical CPUs for all packages during platform boot.  Any
hot-added CPU is not verified thus cannot support TDX.  A non-buggy BIOS
should never deliver ACPI CPU hot-add event to the kernel.  Such event is
reported as BIOS bug and the hot-added CPU is rejected.

TDX requires all boot-time verified logical CPUs being present until
machine reset.  If kernel receives ACPI CPU hot-removal event, assume
kernel cannot continue to work normally and just BUG().

Note TDX works with CPU logical online/offline, thus the kernel still
allows to offline logical CPU and online it again.

4. Memory Hotplug
~~~~~~~~~~~~~~

The TDX module reports a list of "Convertible Memory Region" (CMR) to
indicate which memory regions are TDX-capable.  Those regions are
generated by BIOS and verified by the MCHECK so that they are truly
present during platform boot and can meet security guarantee.

This means TDX doesn't work with ACPI memory hot-add.  A non-buggy BIOS
should never deliver ACPI memory hot-add event to the kernel.  Such event
is reported as BIOS bug and the hot-added memory is rejected.

TDX also doesn't work with ACPI memory hot-removal.  If kernel receives
ACPI memory hot-removal event, assume the kernel cannot continue to work
normally so just BUG().

Also, the kernel needs to choose which TDX-capable regions to use as TDX
memory and pass those regions to the TDX module when it gets initialized.
Once they are passed to the TDX module, the TDX-usable memory regions are
fixed during module's lifetime.

This series guarantees all pages managed by the page allocator are TDX
memory.  This means any hot-added memory to the page allocator will break
such guarantee thus should be prevented.

There are basically two memory hot-add cases that need to be prevented:
ACPI memory hot-add and driver managed memory hot-add.  This series
rejectes the driver managed memory hot-add too when TDX is enabled by
BIOS.

However, adding new memory to ZONE_DEVICE should not be prevented as
those pages are not managed by the page allocator.  Therefore,
memremap_pages() variants are still allowed although they internally
also uses memory hotplug functions.

Kexec()
~~~~~~~

TDX (and MKTME) doesn't guarantee cache coherency among different KeyIDs.
If the TDX module is ever initialized, the kernel needs to flush dirty
cachelines associated with any TDX private KeyID, otherwise they may
slightly corrupt the new kernel.

Similar to SME support, the kernel uses wbinvd() to flush cache in
stop_this_cpu().

The current TDX module architecture doesn't play nicely with kexec().
The TDX module can only be initialized once during its lifetime, and
there is no SEAMCALL to reset the module to give a new clean slate to
the new kernel.  Therefore, ideally, if the module is ever initialized,
it's better to shut down the module.  The new kernel won't be able to
use TDX anyway (as it needs to go through the TDX module initialization
process which will fail immediately at the first step).

However, there's no guarantee CPU is in VMX operation during kexec(), so
it's impractical to shut down the module.  This series just leaves the
module in open state.

Reference:
[1]: https://lore.kernel.org/lkml/cover.1651774250.git.isaku.yamahata@intel.com/T/
[2]: https://lore.kernel.org/linux-mm/YofeZps9YXgtP3f1@google.com/t/

Kai Huang (22):
  x86/virt/tdx: Detect TDX during kernel boot
  cc_platform: Add new attribute to prevent ACPI CPU hotplug
  cc_platform: Add new attribute to prevent ACPI memory hotplug
  x86/virt/tdx: Prevent ACPI CPU hotplug and ACPI memory hotplug
  x86/virt/tdx: Prevent hot-add driver managed memory
  x86/virt/tdx: Add skeleton to initialize TDX on demand
  x86/virt/tdx: Implement SEAMCALL function
  x86/virt/tdx: Shut down TDX module in case of error
  x86/virt/tdx: Detect TDX module by doing module global initialization
  x86/virt/tdx: Do logical-cpu scope TDX module initialization
  x86/virt/tdx: Get information about TDX module and TDX-capable memory
  x86/virt/tdx: Convert all memory regions in memblock to TDX memory
  x86/virt/tdx: Add placeholder to construct TDMRs based on memblock
  x86/virt/tdx: Create TDMRs to cover all memblock memory regions
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Set up reserved areas for all TDMRs
  x86/virt/tdx: Reserve TDX module global KeyID
  x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86/virt/tdx: Support kexec()
  Documentation/x86: Add documentation for TDX host support

 Documentation/x86/tdx.rst        |  190 ++++-
 arch/x86/Kconfig                 |   16 +
 arch/x86/Makefile                |    2 +
 arch/x86/coco/core.c             |   34 +-
 arch/x86/include/asm/tdx.h       |    9 +
 arch/x86/kernel/process.c        |    9 +-
 arch/x86/mm/init_64.c            |   21 +
 arch/x86/virt/Makefile           |    2 +
 arch/x86/virt/vmx/Makefile       |    2 +
 arch/x86/virt/vmx/tdx/Makefile   |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S |   52 ++
 arch/x86/virt/vmx/tdx/tdx.c      | 1343 ++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |  153 ++++
 drivers/acpi/acpi_memhotplug.c   |   23 +
 drivers/acpi/acpi_processor.c    |   23 +
 include/linux/cc_platform.h      |   26 +-
 include/linux/memory_hotplug.h   |    2 +
 kernel/cpu.c                     |    2 +-
 mm/memory_hotplug.c              |   15 +
 19 files changed, 1909 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

-- 
2.35.3

