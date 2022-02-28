Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827474C60D6
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiB1COX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiB1COT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:14:19 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637B44B43F;
        Sun, 27 Feb 2022 18:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014421; x=1677550421;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vrKQ1UA6y2OMC9LmxbJM11Dzbe0Blzj1oFa3U4wd5Gk=;
  b=eZrifrwwmxIUwjJIpYE52jKiL4Vx0dhoRy2GFpjL+PXpjX420UGMF+MJ
   xxQj6W1gL2I+sfoTGBsEA3jymX+rDt3FNusdtsnwvB+3Ex+bUrZaDD9MS
   ubiDwdXHWDIe1gYI36zAywrjL9/jKntATMSmcfDdoLU/xCYUL8OCO5dRm
   Co5hcH+wYxCVrzLxoO4pGEPSgPzUbvV8gxk57282CYVsvJgXqiA6EAHXb
   68vAxnF+gXMKlgTi90RuoVgZhhpOt4tfuEWCJzxvzI8+eLn7bC2LvbwvQ
   B1jQAqqHeR59ra3DIXL8qFTHPG/j+LksO0UmFWR2DS2fc7VMHhPKuoAp8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="233402439"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="233402439"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:41 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936787"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:13:36 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 00/21] TDX host kernel support
Date:   Mon, 28 Feb 2022 15:12:48 +1300
Message-Id: <cover.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series provides support for initializing TDX in the host kernel.

The goal of sending this series is to request feedback on the overall
design and implementation to see whether they are in the right direction.
It will be highly appreciated if anyone can help on this.  If maintainers
can kindly help to provide feedback, it would be even greater.

This series is rebased to Kirill's TDX guest series:

https://github.com/intel/tdx/tree/guest-upstream

The reason is Thomas suggested TDX host side SEAMCALL and TDX guest side
TDCALL share the same ABI and can share the assembly code, and Kirill
implemented the common code in this series.

https://lore.kernel.org/lkml/87a6faz7cs.ffs@tglx/

Thanks in advance.

== Background ==

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  This series provides support for
initializing TDX in the host kernel.  KVM support for TDX [1] is being
developed separately.

To support TDX, a new CPU mode called Secure Arbitration Mode (SEAM) is
added to Intel processors.  SEAM is an extension to the existing VMX
architecture.  It defines a new VMX root operation (SEAM VMX root) and a
new VMX non-root operation (SEAM VMX non-root).

SEAM VMX root operation is designed to host a CPU-attested, software
module called 'Intel TDX module' which implements functions to manage
crypto protected VMs called Trust Domains (TD).  SEAM VMX root is also
designed to host a CPU-attested, software module called the 'Intel
Persistent SEAMLDR (Intel P-SEAMLDR)' to load and update the TDX module.

Host kernel transits to either P-SEAMLDR or TDX module via a new SEAMCALL
instruction.  SEAMCALLs are host-side interface functions defined by
P-SEAMLDR and TDX module around the new SEAMCALL instruction.  They are
similar to a hypercall, except they are made by host kernel to the SEAM
software modules.  SEAMCALLs share the same ABI with TDCALL's.

TDX leverages Intel Multi-Key Total Memory Encryption (MKTME) to crypto
protect TD guests.  TDX reserves part of MKTME KeyID space as TDX private
KeyIDs, which can only be used by software runs in SEAM.  The physical
address bits for encoding TDX private KeyID are treated as reserved bits
when not in SEAM operation.  The partitioning of MKTME KeyIDs and TDX
private KeyIDs is configured by BIOS.

Before being able to manage TD guests, the TDX module must be loaded
and properly initialized using SEAMCALLs defined by TDX architecture.
This series assumes both P-SEAMLDR and TDX module are loaded by BIOS
before the kernel boots.

There's no CPUID or MSR to detect either P-SEAMLDR or TDX module.
Instead, detecting them can be done by using P-SEAMLDR's SEAMLDR.INFO
SEAMCALL to detect P-SEAMLDR.  Success of this SEAMCALL means the
P-SEAMLDR is loaded.  The P-SEAMLDR information returned by this
SEAMCALL further tells whether TDX module is loaded and ready for
initialization.

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

1) Initializing TDX module requires to reserve ~1/256th system RAM as TDX
metadata.  Enabling TDX on demand allows only to consume this memory when
TDX is truly needed (i.e. when KVM wants to create TD guests).

2) Both detecting and initializing TDX module require calling SEAMCALL.
However, SEAMCALL requires CPU being already in VMX operation (VMXON has
been done) as it is essentially a VMExit from VMX root to SEAM VMX root.
Currently, VMXON is only handed in KVM, and adding VMXON to core-kernel
isn't trivial.  So far only KVM is the user of TDX, and KVM already
handles VMXON.  Letting KVM enable TDX on demand avoids handling VMXON
in core-kernel.

3) It is more flexible to support "TDX module runtime update" (not in
this series).  After updating to the new module at runtime, kernel needs
to go through the initialization process again to be able to use TDX
again.  For the new module, theoretically it's possible that the metadata
allocated for the old module cannot be reused again for the new module,
and needs to be re-allocated again.

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

E820 table is used to find all system RAM entries.  Besides E820_TYPE_RAM,
X86 Legacy PMEMs (E820_TYPE_PRAM) also unconditionally treated as TDX
memory as underneath they are RAM and can be potentially used as TD guest
memory.  Memblock is not used as: 1) it is gone after kernel boots; 2) it
doesn't have legacy PMEM (which could result in needing to handle memory
hotplug -- see below).

3. Memory hotplug

The first generation of TDX architecturally doesn't support memory
hotplug.  And the first generation of TDX-capable platforms don't support
ACPI memory hotplug.  Since it physically cannot happen, this series
doesn't add any check in ACPI memory hotplug code path to disable it.

A special case of memory hotplug is adding NVDIMM as system RAM using
kmem driver.  However the first generation of TDX-capable platforms
cannot turn on TDX and NVDIMM simultaneously, so in practice this cannot
happen either.

Another case is admin can use 'memmap' kernel command line to create
legacy PMEMs and use them as TD guest memory, or theoretically, can use
kmem driver to add them as system RAM.  To avoid having to change memory
hotplug code to prevent this from happening, this series always include
legacy PMEMs when constructing TDMRs so they are also TDX memory.  In
this case, legacy PMEMs can either be used as TD guest memory directly
or can be converted to system RAM via kmem driver.

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

[1] https://lore.kernel.org/all/cover.1637799475.git.isaku.yamahata@intel.com/

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
 Documentation/x86/index.rst                   |    1 +
 Documentation/x86/tdx_host.rst                |  300 +++
 arch/x86/Kconfig                              |   14 +
 arch/x86/Makefile                             |    2 +
 arch/x86/include/asm/tdx.h                    |   15 +
 arch/x86/kernel/cpu/intel.c                   |    3 +
 arch/x86/kernel/process.c                     |   26 +-
 arch/x86/virt/Makefile                        |    2 +
 arch/x86/virt/vmx/Makefile                    |    2 +
 arch/x86/virt/vmx/seamcall.S                  |   53 +
 arch/x86/virt/vmx/tdx.c                       | 1632 +++++++++++++++++
 arch/x86/virt/vmx/tdx.h                       |  137 ++
 13 files changed, 2192 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/x86/tdx_host.rst
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx.h

-- 
2.33.1

