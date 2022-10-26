Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061FE60EC12
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiJZXRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJZXRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10CB9DF9B;
        Wed, 26 Oct 2022 16:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826220; x=1698362220;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wmnvxXDOqwSTogmfCnn1f381d719MQgjSt3gBrJiHZ8=;
  b=AIhnHBFDOXub0MM+EYvv6phKTSczWs1kukSCNqBwr9tD9fUtqxr4GP4Q
   FR47Qn3p5QD2N6UtYEbb8slZNsVmM2huAGE32iKKHoLtU5FDO36quVQkQ
   0wXZX/aJc2NAi6kla5j8tgNRZ6n86fTn1T6TWyQta9RnYTCZw72og3C0h
   697fSj36fgdrF4QyqiTBBSM/HNAVDMJ0MhdJmlGZl0QdUYvWrzjF0iuDw
   MgYnsOr2Bor2br6ZuY/KIj6WHeYN+TGG8YI5jhTLe1IME4yIiqkaFnPD5
   l7AoB4L/vz9tyrlhgv89AfGocowRnM+GOUz4zrOMcaWfC7d2uHBigrcef
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306814170"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="306814170"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446174"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446174"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:16:56 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 00/21] TDX host kernel support
Date:   Thu, 27 Oct 2022 12:15:59 +1300
Message-Id: <cover.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  TDX specs are available in [1].

This series provides the initial support to enable TDX in the host kernel
with minimal code.  More patch series will follow up as next steps.
Specifically, below is our plan for the TDX host kernel support:

 1) This initial version to enable TDX with minimal code, allowing KVM
    to use TDX to create and run TDX guests.  It doesn't support all
    functionalities (i.e. exposing TDX module via /sysfs), and doesn't
    aim to resolve all things perfectly (i.e. some optimizations are
    not done).  Especially, memory hotplug is not handled (please see
    "Design Considerations" section below).
 2) Additional patch series to handle memory hotplug or per-node TDX
    capability flag.
 3) More patch series to add additional functions (/sysfs, etc) and
    optimizations (i.e. initializing the TDMRs).

(For memory hotplug, sorry for broadcasting widely but I cc'ed the
linux-mm@kvack.org following Kirill's suggestion so MM experts can also
help to provide comments.)

KVM support for TDX is being developed separately[2].  A new "userspace
inaccessible memfd" approach to support TDX private memory is also being
developed[3].  The KVM will only support the new "userspace inaccessible
memfd" as TDX guest memory backend.

I highly appreciate if anyone can help to review this series.

Hi Dave, Dan (and Intel reviewers),
   
Please kindly help to review, and I would appreciate reviewed-by or
acked-by tags if the patches look good to you.

This series has been reviewed by Isaku who is developing KVM TDX patches.
The first 4 patches have been reviewed by Kirill as well.

----- Changelog history: ------

- v5 -> v6:

  - Removed ACPI CPU/memory hotplug patches. (Intel internal discussion)
  - Removed patch to disable driver-managed memory hotplug (Intel
    internal discussion).
  - Added one patch to introduce enum type for TDX supported page size
    level to replace the hard-coded values in TDX guest code (Dave).
  - Added one patch to make TDX depends on X2APIC being enabled (Dave).
  - Added one patch to build all boot-time present memory regions as TDX
    memory during kernel boot.
  - Added Reviewed-by from others to some patches.
  - For all others please see individual patch changelog history.

- v4 -> v5:

  This is essentially a resent of v4.  Sorry I forgot to consult
  get_maintainer.pl when sending out v4, so I forgot to add linux-acpi
  and linux-mm mailing list and the relevant people for 4 new patches.

  There are also very minor code and commit message update from v4:

  - Rebased to latest tip/x86/tdx.
  - Fixed a checkpatch issue that I missed in v4.
  - Removed an obsoleted comment that I missed in patch 6.
  - Very minor update to the commit message of patch 12.

  For other changes to individual patches since v3, please refer to the
  changelog histroy of individual patches (I just used v3 -> v5 since
  there's basically no code change to v4).

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

v5:
https://lore.kernel.org/lkml/cover.1655894131.git.kai.huang@intel.com/T/

v3:
https://lore.kernel.org/lkml/68484e168226037c3a25b6fb983b052b26ab3ec1.camel@intel.com/T/

V2:
https://lore.kernel.org/lkml/cover.1647167475.git.kai.huang@intel.com/T/

RFC (v1):
https://lore.kernel.org/all/e0ff030a49b252d91c789a89c303bb4206f85e3d.1646007267.git.kai.huang@intel.com/T/

== Background ==

TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM)
and a new isolated range pointed by the SEAM Ranger Register (SEAMRR).
A CPU-attested software module called 'the TDX module' runs in the new
isolated region as a trusted hypervisor to create/run protected VMs.

TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
as TDX private KeyIDs, which are only accessible within the SEAM mode.

TDX is different from AMD SEV/SEV-ES/SEV-SNP, which uses a dedicated
secure processor to provide crypto-protection.  The firmware runs on the
secure processor acts a similar role as the TDX module.

The host kernel communicates with SEAM software via a new SEAMCALL
instruction.  This is conceptually similar to a guest->host hypercall,
except it is made from the host to SEAM software instead.

Before being able to manage TD guests, the TDX module must be loaded
and properly initialized.  This series assumes the TDX module is loaded
by BIOS before the kernel boots.

How to initialize the TDX module is described at TDX module 1.0
specification, chapter "13.Intel TDX Module Lifecycle: Enumeration,
Initialization and Shutdown".

== Design Considerations ==

1. Initialize the TDX module at runtime

There are basically two ways the TDX module could be initialized: either
in early boot, or at runtime before the first TDX guest is run.  This
series implements the runtime initialization.

This series adds a function tdx_enable() to allow the caller to initialize
TDX at runtime:

        if (tdx_enable())
                goto no_tdx;
	// TDX is ready to create TD guests.

This approach has below pros:

1) Initializing the TDX module requires to reserve ~1/256th system RAM as
metadata.  Enabling TDX on demand allows only to consume this memory when
TDX is truly needed (i.e. when KVM wants to create TD guests).

2) SEAMCALL requires CPU being already in VMX operation (VMXON has been
done).  So far, KVM is the only user of TDX, and it already handles VMXON.
Letting KVM to initialize TDX avoids handling VMXON in the core kernel.

3) It is more flexible to support "TDX module runtime update" (not in
this series).  After updating to the new module at runtime, kernel needs
to go through the initialization process again.

2. CPU hotplug

TDX doesn't support physical (ACPI) CPU hotplug.  A non-buggy BIOS should
never support hotpluggable CPU devicee and/or deliver ACPI CPU hotplug
event to the kernel.  This series doesn't handle physical (ACPI) CPU
hotplug at all but depends on the BIOS to behave correctly.

Note TDX works with CPU logical online/offline, thus this series still
allows to do logical CPU online/offline.

3. Kernel policy on TDX memory

The TDX architecture allows the VMM to designate specific memory as
usable for TDX private memory.  This series chooses to designate _all_
boot-time system RAM as TDX to avoid having to modify the page allocator
to distinguish TDX and non-TDX-capable memory.

4. Memory Hotplug

The TDX module reports a list of "Convertible Memory Region" (CMR) to
indicate which memory regions are TDX-capable.  TDX convertible memory
must be physically present during machine boot.  TDX also assumes
convertible memory won't be hot-removed.  A non-buggy BIOS should never
support physical hot-removal of any TDX convertible memory.  This series
doesn't handle physical hot-removal of convertible memory but depends on
the BIOS to behave correctly.

It's possible that one machine can have both TDX and non-TDX memory.
Specifically, runtime hot-added physical memory is not TDX convertible
memory.  Also, for now NVDIMM and CXL memory are not TDX convertible
memory, no matter whether they are physically present during boot or not.

Plugging non-TDX memory to the page allocator could result in failing to
create a TDX guest, or killing a running TDX guest.

To keep things simple, this series doesn't handle memory hotplug at all,
but depends on the machine owner to not do any memory hotplug operation.
For exmaple, the machine owner should not plug any NVDIMM and CXL memory
into the machine, or use kmem driver to plug NVDIMM or CXL memory to the
core-mm.

This will be enhanced in the future after first submission.  We are also
looking into options on how to handle:

- One solution is to enforce the kernel to always guarantee all pages in
the page allocator are TDX memory (i.e. via rejecting non-TDX memory in
memory hotplug).
- Another solution is to manage TDX and non-TDX memory in different NUMA
nodes, and use per-node TDX memory capability flag to show which nodes
are TDX-capable.  Userspace needs to explicitly bind TDX guests to those
TDX-capable NUMA nodes.

The second option is similar to the per-node memory encryption flag
support in below sereies:

https://lore.kernel.org/linux-mm/20221007155323.ue4cdthkilfy4lbd@box.shutemov.name/t/

5. Kexec()

Just like SME, TDX hosts require special cache flushing before kexec().
Similar to SME handling, the kernel uses wbinvd() to flush cache in
stop_this_cpu() when TDX is enabled.

===== Reference ======
[1]: TDX specs:
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

[2]: KVM TDX basic feature support
https://lore.kernel.org/lkml/CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com/T/

[3]: KVM: mm: fd-based approach for supporting KVM
https://lore.kernel.org/lkml/20220915142913.2213336-1-chao.p.peng@linux.intel.com/T/


Kai Huang (21):
  x86/tdx: Use enum to define page level of TDX supported page sizes
  x86/virt/tdx: Detect TDX during kernel boot
  x86/virt/tdx: Disable TDX if X2APIC is not enabled
  x86/virt/tdx: Use all boot-time system memory as TDX memory
  x86/virt/tdx: Add skeleton to initialize TDX on demand
  x86/virt/tdx: Implement functions to make SEAMCALL
  x86/virt/tdx: Shut down TDX module in case of error
  x86/virt/tdx: Do TDX module global initialization
  x86/virt/tdx: Do logical-cpu scope TDX module initialization
  x86/virt/tdx: Get information about TDX module and TDX-capable memory
  x86/virt/tdx: Sanity check all TDX memory ranges are convertible
    memory
  x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX
    memory regions
  x86/virt/tdx: Create TDMRs to cover all TDX memory regions
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Set up reserved areas for all TDMRs
  x86/virt/tdx: Reserve TDX module global KeyID
  x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86/virt/tdx: Flush cache in kexec() when TDX is enabled
  Documentation/x86: Add documentation for TDX host support

 Documentation/x86/tdx.rst        |  209 ++++-
 arch/x86/Kconfig                 |   14 +
 arch/x86/Makefile                |    2 +
 arch/x86/coco/tdx/tdx.c          |   20 +-
 arch/x86/include/asm/tdx.h       |   51 ++
 arch/x86/kernel/process.c        |    9 +-
 arch/x86/virt/Makefile           |    2 +
 arch/x86/virt/vmx/Makefile       |    2 +
 arch/x86/virt/vmx/tdx/Makefile   |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S |   52 ++
 arch/x86/virt/vmx/tdx/tdx.c      | 1441 ++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |  118 +++
 arch/x86/virt/vmx/tdx/tdxcall.S  |   19 +-
 13 files changed, 1911 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 5eb443db589a4526b2bef750a998ce7f0dc9c87b
-- 
2.37.3

