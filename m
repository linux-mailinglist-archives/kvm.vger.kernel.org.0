Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E9B4F6061
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiDFNfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbiDFNfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 09:35:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD64144DCE7;
        Tue,  5 Apr 2022 21:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220586; x=1680756586;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sGo7d12v2k3Q7y3rHHt5kkOidiqNI+CWYyie9UKnLhs=;
  b=NhNnAw5Fa3enQgpHGNwn3fdwK8Ce76ma3lTgXCgREhEy2zXinCGpY1Zm
   pUOSekAFroW3fUFDeM6+m/AtWQeyRM1JHzexMTn4j3bNMs9tyZlLS4oME
   XKB6zbYTmmvBGFkMZmsQmKtFy953qVcFmDt82FVyxz8g8zK9EjuieVFQY
   t94pVyL+3BKv7DyFv4xlE7kizGLwb+RLy8v+A5UqauhsEwR+ifFbZ37ho
   4Ee718Mw9YD/TdTZDbxxqlDtR2d787rsrZaksExK5XaDFPy3iX4Igh+0I
   qs4GRq54H/lEl1tUegwIQFgKs7lj3CM+P4HMrleqjpASJtIEzTHjYYo0P
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089757"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089757"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302081"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:49:41 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 00/21] TDX host kernel support
Date:   Wed,  6 Apr 2022 16:49:12 +1200
Message-Id: <cover.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  This series provides support for
initializing the TDX module in the host kernel.  KVM support for TDX is
being developed separately[1].

The code has been tested on couple of TDX-capable machines.  I would
consider it as ready for review. I highly appreciate if anyone can help
to review this series (from high level design to detail implementations).
For Intel reviewers (CC'ed), please help to review, and I would
appreciate Reviewed-by or Acked-by tags if the patches look good to you.

Thanks in advance.

This series is based on Kirill's TDX guest series[2]. The reason is host
side SEAMCALL implementation can share TDCALL's implementation which is
implemented in TDX guest series.

You can find TDX related specs here:
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

You can also find this series in below repo in github:
https://github.com/intel/tdx/tree/host-upstream

Changelog history:

- V2 -> v3:

 - Rebased to latest TDX guest code, which is based on 5.18-rc1.
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

- RFC (v1) -> v2:
  - Rebased to Kirill's latest TDX guest code.
  - Fixed two issues that are related to finding all RAM memory regions
    based on e820.
  - Minor improvement on comments and commit messages.

V2:
https://lore.kernel.org/lkml/cover.1647167475.git.kai.huang@intel.com/T/
RFC (v1):
https://lore.kernel.org/all/e0ff030a49b252d91c789a89c303bb4206f85e3d.1646007267.git.kai.huang@intel.com/T/

== Background ==

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  To support TDX, a new CPU mode called
Secure Arbitration Mode (SEAM) is added to Intel processors.

SEAM is an extension to the existing VMX architecture.  It defines a new
VMX root operation (SEAM VMX root) and a new VMX non-root operation (SEAM
VMX non-root).

SEAM VMX root operation is designed to host a CPU-attested, software
module called the 'TDX module' which implements functions to manage
crypto protected VMs called Trust Domains (TD).  SEAM VMX root is also
designed to host a CPU-attested, software module called the 'Intel
Persistent SEAMLDR (Intel P-SEAMLDR)' to load and update the TDX module.

Host kernel transits to either the P-SEAMLDR or the TDX module via a new
SEAMCALL instruction.  SEAMCALLs are host-side interface functions
defined by the P-SEAMLDR and the TDX module around the new SEAMCALL
instruction.  They are similar to a hypercall, except they are made by
host kernel to the SEAM software modules.

TDX leverages Intel Multi-Key Total Memory Encryption (MKTME) to crypto
protect TD guests.  TDX reserves part of MKTME KeyID space as TDX private
KeyIDs, which can only be used by software runs in SEAM.  The physical
address bits for encoding TDX private KeyID are treated as reserved bits
when not in SEAM operation.  The partitioning of MKTME KeyIDs and TDX
private KeyIDs is configured by BIOS.

Before being able to manage TD guests, the TDX module must be loaded
and properly initialized using SEAMCALLs defined by TDX architecture.
This series assumes both the P-SEAMLDR and the TDX module are loaded by
BIOS before the kernel boots.

There's no CPUID or MSR to detect either the P-SEAMLDR or the TDX module.
Instead, detecting them can be done by using P-SEAMLDR's SEAMLDR.INFO
SEAMCALL to detect P-SEAMLDR.  The success of this SEAMCALL means the
P-SEAMLDR is loaded.  The P-SEAMLDR information returned by this
SEAMCALL further tells whether TDX module is loaded.

The TDX module is initialized in multiple steps:

        1) Global initialization;
        2) Logical-CPU scope initialization;
        3) Enumerate the TDX module capabilities;
        4) Configure the TDX module about usable memory ranges and
           global KeyID information;
        5) Package-scope configuration for the global KeyID;
        6) Initialize TDX metadata for usable memory ranges based on 4).

Step 2) requires calling some SEAMCALL on all "BIOS-enabled" (in MADT
table) logical cpus, otherwise step 4) will fail.  Step 5) requires
calling SEAMCALL on at least one cpu on all packages.

TDX module can also be shut down at any time during module's lifetime, by
calling SEAMCALL on all "BIOS-enabled" logical cpus.

== Design Considerations ==

1. Lazy TDX module initialization on-demand by caller

None of the steps in the TDX module initialization process must be done
during kernel boot.  This series doesn't initialize TDX at boot time, but
instead, provides two functions to allow caller to detect and initialize
TDX on demand:

        if (tdx_detect())
                goto no_tdx;
        if (tdx_init())
                goto no_tdx;

This approach has below pros:

1) Initializing the TDX module requires to reserve ~1/256th system RAM as
metadata.  Enabling TDX on demand allows only to consume this memory when
TDX is truly needed (i.e. when KVM wants to create TD guests).

2) Both detecting and initializing the TDX module require calling
SEAMCALL.  However, SEAMCALL requires CPU being already in VMX operation
(VMXON has been done).  So far, KVM is the only user of TDX, and it
already handles VMXON/VMXOFF.  Therefore, letting KVM to initialize TDX
on-demand avoids handling VMXON/VMXOFF (which is not that trivial) in
core-kernel.  Also, in long term, likely a reference based VMXON/VMXOFF
approach is needed since more kernel components will need to handle
VMXON/VMXONFF.

3) It is more flexible to support "TDX module runtime update" (not in
this series).  After updating to the new module at runtime, kernel needs
to go through the initialization process again.  For the new module,
it's possible the metadata allocated for the old module cannot be reused
for the new module, and needs to be re-allocated again.

2. Kernel policy on TDX memory

Host kernel is responsible for choosing which memory regions can be used
as TDX memory, and configuring those memory regions to the TDX module by
using an array of "TD Memory Regions" (TDMR), which is a data structure
defined by TDX architecture.

The first generation of TDX essentially guarantees that all system RAM
memory regions (excluding the memory below 1MB) can be used as TDX
memory.  To avoid having to modify the page allocator to distinguish TDX
and non-TDX allocation, this series chooses to use all system RAM as TDX
memory.

E820 table is used to find all system RAM entries.  Following
e820__memblock_setup(), both E820_TYPE_RAM and E820_TYPE_RESERVED_KERN
types are treated as TDX memory, and contiguous ranges in the same NUMA
node are merged together (similar to memblock_add()) before trimming the
non-page-aligned part.

X86 Legacy PMEMs (E820_TYPE_PRAM) also unconditionally treated as TDX
memory as underneath they are RAM and can be potentially used as TD guest
memory.

Memblock is not used to find all RAM regions as: 1) it is gone after
kernel boots; 2) it doesn't have legacy PMEM.

3. Memory hotplug

The first generation of TDX architecturally doesn't support memory
hotplug.  And the first generation of TDX-capable platforms don't support
physical memory hotplug.  Since it physically cannot happen, this series
doesn't add any check in ACPI memory hotplug code path to disable it.

A special case of memory hotplug is adding NVDIMM as system RAM using
kmem driver.  However the first generation of TDX-capable platforms
cannot enable TDX and NVDIMM simultaneously, so in practice this cannot
happen either.

Another case is admin can use 'memmap' kernel command line to create
legacy PMEMs and use them as TD guest memory, or theoretically, can use
kmem driver to add them as system RAM.  To avoid having to change memory
hotplug code to prevent this from happening, this series always include
legacy PMEMs when constructing TDMRs so they are also TDX memory.

4. CPU hotplug

The first generation of TDX architecturally doesn't support ACPI CPU
hotplug.  All logical cpus are enabled by BIOS in MADT table.  Also, the
first generation of TDX-capable platforms don't support ACPI CPU hotplug
either.  Since this physically cannot happen, this series doesn't add any
check in ACPI CPU hotplug code path to disable it.

Also, only TDX module initialization requires all BIOS-enabled cpus are
online.  After the initialization, any logical cpu can be brought down
and brought up to online again later.  Therefore this series doesn't
change logical CPU hotplug either.

5. TDX interaction with kexec()

If TDX is ever enabled and/or used to run any TD guests, the cachelines
of TDX private memory, including PAMTs, used by TDX module need to be
flushed before transiting to the new kernel otherwise they may silently
corrupt the new kernel.  Similar to SME, this series flushes cache in
stop_this_cpu().

The TDX module can be initialized only once during its lifetime.  The
first generation of TDX doesn't have interface to reset TDX module to
uninitialized state so it can be initialized again.

This implies:

  - If the old kernel fails to initialize TDX, the new kernel cannot
    use TDX too unless the new kernel fixes the bug which leads to
    initialization failure in the old kernel and can resume from where
    the old kernel stops. This requires certain coordination between
    the two kernels.

  - If the old kernel has initialized TDX successfully, the new kernel
    may be able to use TDX if the two kernels have the exactly same
    configurations on the TDX module. It further requires the new kernel
    to reserve the TDX metadata pages (allocated by the old kernel) in
    its page allocator. It also requires coordination between the two
    kernels.  Furthermore, if kexec() is done when there are active TD
    guests running, the new kernel cannot use TDX because it's extremely
    hard for the old kernel to pass all TDX private pages to the new
    kernel.

Given that, this series doesn't support TDX after kexec() (except the
old kernel doesn't attempt to initialize TDX at all).

And this series doesn't shut down TDX module but leaves it open during
kexec().  It is because shutting down TDX module requires CPU being in
VMX operation but there's no guarantee of this during kexec().  Leaving
the TDX module open is not the best case, but it is OK since the new
kernel won't be able to use TDX anyway (therefore TDX module won't run
at all).

[1] https://lore.kernel.org/lkml/772b20e270b3451aea9714260f2c40ddcc4afe80.1646422845.git.isaku.yamahata@intel.com/T/
[2] https://github.com/intel/tdx/tree/guest-upstream


Kai Huang (21):
  x86/virt/tdx: Detect SEAM
  x86/virt/tdx: Detect TDX private KeyIDs
  x86/virt/tdx: Implement the SEAMCALL base function
  x86/virt/tdx: Add skeleton for detecting and initializing TDX on
    demand
  x86/virt/tdx: Detect P-SEAMLDR and TDX module
  x86/virt/tdx: Shut down TDX module in case of error
  x86/virt/tdx: Do TDX module global initialization
  x86/virt/tdx: Do logical-cpu scope TDX module initialization
  x86/virt/tdx: Get information about TDX module and convertible memory
  x86/virt/tdx: Add placeholder to coveret all system RAM as TDX memory
  x86/virt/tdx: Choose to use all system RAM as TDX memory
  x86/virt/tdx: Create TDMRs to cover all system RAM
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Set up reserved areas for all TDMRs
  x86/virt/tdx: Reserve TDX module global KeyID
  x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86: Flush cache of TDX private memory during kexec()
  x86/virt/tdx: Add kernel command line to opt-in TDX host support
  Documentation/x86: Add documentation for TDX host support

 .../admin-guide/kernel-parameters.txt         |    6 +
 Documentation/x86/tdx.rst                     |  326 +++-
 arch/x86/Kconfig                              |   14 +
 arch/x86/Makefile                             |    2 +
 arch/x86/include/asm/tdx.h                    |   15 +
 arch/x86/kernel/cpu/intel.c                   |    3 +
 arch/x86/kernel/process.c                     |   15 +-
 arch/x86/virt/Makefile                        |    2 +
 arch/x86/virt/vmx/Makefile                    |    2 +
 arch/x86/virt/vmx/tdx/Makefile                |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S              |   52 +
 arch/x86/virt/vmx/tdx/tdx.c                   | 1717 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                   |  137 ++
 13 files changed, 2279 insertions(+), 14 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h

-- 
2.35.1

