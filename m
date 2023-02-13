Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643B66944FE
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjBMMAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjBMMAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:00:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B957C18B13;
        Mon, 13 Feb 2023 04:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289611; x=1707825611;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pbTnCYBbI6T7+JEt1Dy9Ogeyac5IOEA7HR7qdy6FB3g=;
  b=RlRm1tZ+bnVytxiXSVxwtUxr8dHGIM+uIbQxYqza5lZzo9o+/KG/8Zft
   3PR9XvSDWl+pMJh1Gj9t3/fPhHQg7yb2Anggj6WjzCmi53Gl3T2qFPJDd
   Ct2OVyhZBF/+z+/RZtn+88664YWyVxj5+NPv2fewYjdHdfhd6Q4TXBoht
   k61v9RWsNkE+ug7p/KfmvBPYWbxCzeHXOjHjTwMIEAiVGEOVnj31z4qD3
   5nU3G+hPdMfwSsruqVShn6r3selE/4PlkwyaKVGOVz+2vUc7JpqobSyVr
   oHGDuFw68iZprqhIZLNAmkPRi0MTOtkwg0FdgpmOhYNcu8fZ8MTFTUVY/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283016"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283016"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243056"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243056"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:05 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v9 00/18] TDX host kernel support
Date:   Tue, 14 Feb 2023 00:59:07 +1300
Message-Id: <cover.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

This series doesn't aim to support all functionalities, and doesn't aim
to resolve all things perfectly.  For example, memory hotplug is handled
in simple way (please refer to "Kernel policy on TDX memory" and "Memory
hotplug" sections below).

(For memory hotplug, sorry for broadcasting widely but I cc'ed the
linux-mm@kvack.org following Kirill's suggestion so MM experts can also
help to provide comments.)

And TDX module metadata allocation just uses alloc_contig_pages() to
allocate large chunk at runtime, thus it can fail.  It is imperfect now
but _will_ be improved in the future.

Also, the patch to add the new kernel comline tdx="force" isn't included
in this initial version, as Dave suggested it isn't mandatory.  But I
_will_ add one once this initial version gets merged.

All other optimizations will be posted as follow-up once this initial
TDX support is upstreamed.

Hi Dave, Peter, Thomas, Dan (and Intel reviewers),

It turns out we won't remove TDH.SYS.LP.INIT (and TDH.SYS.INIT) as did in
v8.  But the TDH.SYS.LP.INIT will be relaxed to be able to called on one
cpu at any time (after TDH.SYS.INIT) before any other SEAMCALL can be
made on that cpu.  This new version (v9) is written based on this new
behaviour.

But I haven't tested the new behaviour because the TDX module isn't
ready.  Instead, I tested with all cpus are online when initializing the
TDX module.  CPU hotplug path isn't really tested although I did some
basic test that I can offline some cpus after module initialization,
online them again and the LP.INIT was skipped successfully for them.

However I believe there should be no issue when the new module is ready.
I will test and report back when the new module is ready.

I would appreciate if folks could review this presumptive series anyway.
   
And I would appreciate reviewed-by or acked-by tags if the patches look
good to you.

----- Changelog history: ------

- v8 -> v9:

 - Added patches to handle TDH.SYS.INIT and TDH.SYS.LP.INIT back.
 - Other changes please refer to changelog histroy in individual patches.

 v8: https://lore.kernel.org/lkml/cover.1670566861.git.kai.huang@intel.com/

- v7 -> v8:

 - 200+ LOC removed (from 1800+ -> 1600+).
 - Removed patches to do TDH.SYS.INIT and TDH.SYS.LP.INIT
   (Dave/Peter/Thomas).
 - Removed patch to shut down TDX module (Sean).
 - For memory hotplug, changed to reject non-TDX memory from
   arch_add_memory() to memory_notifier (Dan/David).
 - Simplified the "skeletion patch" as a result of removing
   TDH.SYS.LP.INIT patch.
 - Refined changelog/comments for most of the patches (to tell better
   story, remove silly comments, etc) (Dave).
 - Added new 'struct tdmr_info_list' struct, and changed all TDMR related
   patches to use it (Dave).
 - Effectively merged patch "Reserve TDX module global KeyID" and
   "Configure TDX module with TDMRs and global KeyID", and removed the
   static variable 'tdx_global_keyid', following Dave's suggestion on
   making tdx_sysinfo local variable.
 - For detailed changes please see individual patch changelog history.

 v7: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

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

 v6: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

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

 v5: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

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

 v4: https://lore.kernel.org/lkml/98c84c31d8f062a0b50a69ef4d3188bc259f2af2.1654025431.git.kai.huang@intel.com/T/

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

 v3: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

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

 v2: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

- RFC (v1) -> v2:
  - Rebased to Kirill's latest TDX guest code.
  - Fixed two issues that are related to finding all RAM memory regions
    based on e820.
  - Minor improvement on comments and commit messages.

 v1: https://lore.kernel.org/lkml/529a22d05e21b9218dc3f29c17ac5a176334cac1.camel@intel.com/T/

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

TDX module requires one SEAMCALL (TDH.SYS.LP.INIT) to do per-cpu module
initialization on one cpu before any other SEAMCALLs can be made on that
cpu, including those involved during the module initialization.

Currently kernel simply guarantees all online cpus are "TDX-runnable"
(TDH.SYS.LP.INIT has been done successfully on them).  During module
initialization, the SEAMCALL is done for all online cpus and CPU hotplug
is disabled during the entire module initialization.  If any fails, TDX
is disabled.  In CPU hotplug, the kernel provides another function
tdx_cpu_online() for the user of TDX (KVM for now) to call in it's own
CPU online callback, and reject to online the cpu if SEAMCALL fails.

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

This _will_ be enhanced in the future after first submission.

A better solution, suggested by Kirill, is similar to the per-node memory
encryption flag in this series [4].  We can allow adding/onlining non-TDX
memory to separate NUMA nodes so that both "TDX-capable" nodes and
"TDX-capable" nodes can co-exist.  The new TDX flag can be exposed to
userspace via /sysfs so userspace can bind TDX guests to "TDX-capable"
nodes via NUMA ABIs.

5. Physical Memory Hotplug

Note TDX assumes convertible memory is always physically present during
machine's runtime.  A non-buggy BIOS should never support hot-removal of
any convertible memory.  This implementation doesn't handle ACPI memory
removal but depends on the BIOS to behave correctly.

6. Kexec()

There are two problems in terms of using kexec() to boot to a new kernel
when the old kernel has enabled TDX: 1) Part of the memory pages are
still TDX private pages; 2) There might be dirty cachelines associated
with TDX private pages.

The first problem doesn't matter.  KeyID 0 doesn't have integrity check.
Even the new kernel wants to use any non-zero KeyID, it needs to convert
the memory to that KeyID and such conversion would work from any KeyID.

However the old kernel needs to guarantee there's no dirty cacheline
left behind before booting to the new kernel to avoid silent corruption
from later cacheline writeback (Intel hardware doesn't guarantee cache
coherency across different KeyIDs).

This series just uses wbinvd() to flush cache in stop_this_cpu()
following AMD's SME.




Kai Huang (18):
  x86/tdx: Define TDX supported page sizes as macros
  x86/virt/tdx: Detect TDX during kernel boot
  x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
  x86/virt/tdx: Add skeleton to initialize TDX on demand
  x86/virt/tdx: Add SEAMCALL infrastructure
  x86/virt/tdx: Do TDX module global initialization
  x86/virt/tdx: Do TDX module per-cpu initialization
  x86/virt/tdx: Get information about TDX module and TDX-capable memory
  x86/virt/tdx: Use all system memory when initializing TDX module as
    TDX memory
  x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX
    memory regions
  x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
  x86/virt/tdx: Allocate and set up PAMTs for TDMRs
  x86/virt/tdx: Designate reserved areas for all TDMRs
  x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
  x86/virt/tdx: Configure global KeyID on all packages
  x86/virt/tdx: Initialize all TDMRs
  x86/virt/tdx: Flush cache in kexec() when TDX is enabled
  Documentation/x86: Add documentation for TDX host support

 Documentation/x86/tdx.rst        |  176 +++-
 arch/x86/Kconfig                 |   15 +
 arch/x86/Makefile                |    2 +
 arch/x86/coco/tdx/tdx.c          |    6 +-
 arch/x86/include/asm/msr-index.h |    3 +
 arch/x86/include/asm/tdx.h       |   25 +
 arch/x86/kernel/process.c        |    7 +-
 arch/x86/kernel/setup.c          |    2 +
 arch/x86/virt/Makefile           |    2 +
 arch/x86/virt/vmx/Makefile       |    2 +
 arch/x86/virt/vmx/tdx/Makefile   |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S |   52 ++
 arch/x86/virt/vmx/tdx/tdx.c      | 1440 ++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h      |  161 ++++
 arch/x86/virt/vmx/tdx/tdxcall.S  |   19 +-
 15 files changed, 1897 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 1e70c680375aa33cca97bff0bca68c0f82f5023c
-- 
2.39.1

