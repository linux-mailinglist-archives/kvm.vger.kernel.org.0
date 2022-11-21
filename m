Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583E063179E
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKUA1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiKUA1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92E2CDD0;
        Sun, 20 Nov 2022 16:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990415; x=1700526415;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=z8KHi5qHLeHg4fpLQ2a4OUyn87poiugSdNDLU7x/06g=;
  b=Ka5WyeiyzCCKgD9ju8uLr3Tpc7TQl47kv2mkOqKZ97D7BMjwSCQ5yaM0
   R6xgXCjMbkqZwlPFg491atG1fraOHoOu1GqieoXrnDMC+/R1Vw+UYwB8L
   uE58cLuB36+nIxDnDHxXOWfkSFvLrrjyLhD2vvUIiEp2CmElZVwIGDAMZ
   qeAo7njyhpUFYHQ509BFL32dVi+xlP7sJjdZcLm9UlROWIq6FxcF3ts7W
   vM47CNTvhPKER6gOgPEWbTcshFuULA//1sDAtHQy0bUFbYJ165BLTPOpO
   R40wKfEPIzHQdDueo6nuClKcdDEq5t9LgjjYU4q5dUZGxiKypwKC2X5lJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732258"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732258"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:26:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825110"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825110"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:26:51 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 00/20] TDX host kernel support
Date:   Mon, 21 Nov 2022 13:26:22 +1300
Message-Id: <cover.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
host and certain physical attacks.  TDX specs are available in [1].

This series is the initial support to enable TDX with minimal code to
allow KVM to create and run TDX guests.  KVM support for TDX is being
developed separately[2].  A new "userspace inaccessible memfd" approach
to support TDX private memory is also being developed[3].  The KVM will
only support the new "userspace inaccessible memfd" as TDX guest memory.

This series doesn't aim to support all functionalities (i.e. exposing TDX
module via /sysfs), and doesn't aim to resolve all things perfectly.
Especially, the implementation to how to choose "TDX-usable" memory and
memory hotplug handling is simple, that this series just makes sure all
pages in the page allocator are TDX memory.

A better solution, suggested by Kirill, is similar to the per-node memory
encryption flag in this series [4].  Similarly, a per-node TDX flag can
be added so both "TDX-capable" and "non-TDX-capable" nodes can co-exist.
With exposing the TDX flag to userspace via /sysfs, the userspace can
then use NUMA APIs to bind TDX guests to those "TDX-capable" nodes.

For more information please refer to "Kernel policy on TDX memory" and
"Memory hotplug" sections below.  Huang, Ying is working on this
"per-node TDX flag" support and will post another series independently.

(For memory hotplug, sorry for broadcasting widely but I cc'ed the
linux-mm@kvack.org following Kirill's suggestion so MM experts can also
help to provide comments.)

Also, other optimizations will be posted as follow-up once this initial
TDX support is upstreamed.

Hi Dave, Dan, Kirill, Ying (and Intel reviewers),
   
Please kindly help to review, and I would appreciate reviewed-by or
acked-by tags if the patches look good to you.

This series has been reviewed by Isaku who is developing KVM TDX patches.
Kirill also has reviewed couple of patches as well.

Also, I highly appreciate if anyone else can help to review this series.

----- Changelog history: ------

- v6 -> v7:

  - Added memory hotplug support.
  - Changed how to choose the list of "TDX-usable" memory regions from at
    kernel boot time to TDX module initialization time.
  - Addressed comments received in previous versions. (Andi/Dave).
  - Improved the commit message and the comments of kexec() support patch,
    and the patch handles returnning PAMTs back to the kernel when TDX
    module initialization fails. Please also see "kexec()" section below.
  - Changed the documentation patch accordingly.
  - For all others please see individual patch changelog history.

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

v6:
https://lore.kernel.org/linux-mm/cover.1666824663.git.kai.huang@intel.com/T/

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

The TDX module reports a list of "Convertible Memory Region" (CMR) to
indicate which memory regions are TDX-capable.  The TDX architecture
allows the VMM to designate specific convertible memory regions as usable
for TDX private memory.

The initial support of TDX guests will only allocate TDX private memory
from the global page allocator.  This series chooses to designate _all_
system RAM in the core-mm at the time of initializing TDX module as TDX
memory to guarantee all pages in the page allocator are TDX pages.

4. Memory Hotplug

After the kernel passes all "TDX-usable" memory regions to the TDX
module, the set of "TDX-usable" memory regions are fixed during module's
runtime.  No more "TDX-usable" memory can be added to the TDX module
after that.

To achieve above "to guarantee all pages in the page allocator are TDX
pages", this series simply choose to reject any non-TDX-usable memory in
memory hotplug.

This _will_ be enhanced in the future after first submission.  The
direction we are heading is to allow adding/onlining non-TDX memory to
separate NUMA nodes so that both "TDX-capable" nodes and "TDX-capable"
nodes can co-exist.  The TDX flag can be exposed to userspace via /sysfs
so userspace can bind TDX guests to "TDX-capable" nodes via NUMA ABIs.

Note TDX assumes convertible memory is always physically present during
machine's runtime.  A non-buggy BIOS should never support hot-removal of
any convertible memory.  This implementation doesn't handle ACPI memory
removal but depends on the BIOS to behave correctly.

5. Kexec()

There are two problems in terms of using kexec() to boot to a new kernel
when the old kernel has enabled TDX: 1) Part of the memory pages are
still TDX private pages (i.e. metadata used by the TDX module, and any
TDX guest memory if kexec() happens when there's any TDX guest alive).
2) There might be dirty cachelines associated with TDX private pages.

Just like SME, TDX hosts require special cache flushing before kexec().
Similar to SME handling, the kernel uses wbinvd() to flush cache in
stop_this_cpu() when TDX is enabled.

This series doesn't convert all TDX private pages back to normal due to
below considerations:

1) The kernel doesn't have existing infrastructure to track which pages
   are TDX private pages.
2) The number of TDX private pages can be large, and converting all of
   them (cache flush + using MOVDIR64B to clear the page) in kexec() can
   be time consuming.
3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
   0 doesn't support integrity-check, so it's OK.
4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
   kernel ever supports MKTME, it should do MOVDIR64B to clear the page
   with the new MKTME KeyID (just like TDX does) before using it.

Also, if the old kernel ever enables TDX, the new kernel cannot use TDX
again.  When the new kernel goes through the TDX module initialization
process it will fail immediately at the first step.

Ideally, it's better to shutdown the TDX module in kexec(), but there's
no guarantee that CPUs are in VMX operation in kexec() so just leave the
module open.

== Reference ==

[1]: TDX specs
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

[2]: KVM TDX basic feature support
https://lore.kernel.org/lkml/CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com/T/

[3]: KVM: mm: fd-based approach for supporting KVM
https://lore.kernel.org/lkml/20220915142913.2213336-1-chao.p.peng@linux.intel.com/T/

[4]: per-node memory encryption flag
https://lore.kernel.org/linux-mm/20221007155323.ue4cdthkilfy4lbd@box.shutemov.name/t/


Kai Huang (20):
  x86/tdx: Define TDX supported page sizes as macros
  x86/virt/tdx: Detect TDX during kernel boot
  x86/virt/tdx: Disable TDX if X2APIC is not enabled
  x86/virt/tdx: Add skeleton to initialize TDX on demand
  x86/virt/tdx: Implement functions to make SEAMCALL
  x86/virt/tdx: Shut down TDX module in case of error
  x86/virt/tdx: Do TDX module global initialization
  x86/virt/tdx: Do logical-cpu scope TDX module initialization
  x86/virt/tdx: Get information about TDX module and TDX-capable memory
  x86/virt/tdx: Use all system memory when initializing TDX module as
    TDX memory
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

 Documentation/x86/tdx.rst        |  181 +++-
 arch/x86/Kconfig                 |   15 +
 arch/x86/Makefile                |    2 +
 arch/x86/coco/tdx/tdx.c          |    6 +-
 arch/x86/include/asm/tdx.h       |   30 +
 arch/x86/kernel/process.c        |    8 +-
 arch/x86/mm/init_64.c            |   10 +
 arch/x86/virt/Makefile           |    2 +
 arch/x86/virt/vmx/Makefile       |    2 +
 arch/x86/virt/vmx/tdx/Makefile   |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S |   52 ++
 arch/x86/virt/vmx/tdx/tdx.c      | 1422 ++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |  118 +++
 arch/x86/virt/vmx/tdx/tdxcall.S  |   19 +-
 14 files changed, 1852 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 00e07cfbdf0b232f7553f0175f8f4e8d792f7e90
-- 
2.38.1

