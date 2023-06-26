Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4973E1AD
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjFZONu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjFZONr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:13:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBE810E7;
        Mon, 26 Jun 2023 07:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788814; x=1719324814;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=psCgDDLbjhZ2K4kae5gzxul1wXH5G7UqNqB5dydQ/uU=;
  b=JsMzLo9HGNVFcLAVftN1vi/cvY09R7+GOQlTo5jsfb56ZWJcikkfAeVn
   LPCpFcQiFkR/R8QTTBq/UaJTX2iWwSHH9XoLCiCXmaqv4mi6E79plPzhd
   WyFMicA9ik7Wy5yxPRCbOARFZ+s6uyL4FhMkMvtMqWykDEcuDKqacg9X7
   kLUyyqC3m9Z972AiXpDDL7kEI0jLgz6Os0x3hJBRO1ukTGoegrOjgVYfd
   vMbHTSCXYDRaMFCuPR9cn78CKcPvCfVw52O4aagBz19u0ncrDQ7ZAnu5q
   RaLKdaXCX/3cRXZDWtdg2nHQX1Toqn1UAUo46+5Gsczalmmbt75mpVA0c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033458"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033458"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:13:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292201"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292201"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:13:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 00/22] TDX host kernel support
Date:   Tue, 27 Jun 2023 02:12:30 +1200
Message-Id: <cover.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
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
host and certain physical attacks.  TDX specs are available in [1].

This series is the initial support to enable TDX with minimal code to
allow KVM to create and run TDX guests.  KVM support for TDX is being
developed separately[2].  A new "userspace inaccessible memfd" approach
to support TDX private memory is also being developed[3].  The KVM will
only support the new "userspace inaccessible memfd" as TDX guest memory.

Also, a few first generations of TDX hardware have an erratum[4], and
require additional handing.

This series doesn't aim to support all functionalities, and doesn't aim
to resolve all things perfectly.  All other optimizations will be posted
as follow-up once this initial TDX support is upstreamed.

(For memory hotplug, sorry for broadcasting widely but I cc'ed the
linux-mm@kvack.org following Kirill's suggestion so MM experts can also
help to provide comments.)

Hi Dave/Kirill/Tony/David and all,

Thanks for your review on the previous versions.  Appreciate your review
on this version and any tag if patches look good to you.  Thanks!

----- Changelog history: ------

- v11 -> v12:
 - Addressed comments in v11 from Dave/Kirill/David and others.
 - Collected review tags from Dave/Kirill/David and others.
 - Splitted the SEAMCALL infrastructure patch into 2 patches for better
   reveiw.
 - One more patch to change to keep TDMRs when module initialization is
   successful for better review.

 v11: https://lore.kernel.org/lkml/cover.1685887183.git.kai.huang@intel.com/T/

- v10 -> v11:

 - Addressed comments in v10
 - Added patches to handle TDX "partial write machine check" erratum.
 - Added a new patch to handle running out of entropy in common code.
 - Fixed a bug in kexec() support.

 v10: https://lore.kernel.org/kvm/cover.1678111292.git.kai.huang@intel.com/

- v9 -> v10:

 - Changed the per-cpu initalization handling
   - Gave up "ensuring all online cpus are TDX-runnable when TDX module
     is initialized", but just provide two basic functions, tdx_enable()
     and tdx_cpu_enable(), to let the user of TDX to make sure the
     tdx_cpu_enable() has been done successfully when the user wants to
     use particular cpu for TDX.
   - Thus, moved per-cpu initialization out of tdx_enable().  Now
     tdx_enable() just assumes VMXON and tdx_cpu_enable() has been done
     on all online cpus before calling it.
   - Merged the tdx_enable() skeleton patch and per-cpu initialization
     patch together to tell better story.
   - Moved "SEAMCALL infrastructure" patch before the tdx_enable() patch.

 v9: https://lore.kernel.org/lkml/cover.1676286526.git.kai.huang@intel.com/

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

Also, TDX requires a per-cpu initialization SEAMCALL to be done before
making any SEAMCALL on that cpu.

This series adds two functions: tdx_cpu_enable() and tdx_enable() to do
per-cpu initialization and module initialization respectively.

2. CPU hotplug

DX doesn't support physical (ACPI) CPU hotplug.  A non-buggy BIOS should
never support hotpluggable CPU devicee and/or deliver ACPI CPU hotplug
event to the kernel.  This series doesn't handle physical (ACPI) CPU
hotplug at all but depends on the BIOS to behave correctly.

Also, tdx_cpu_enable() will simply return error for any hot-added cpu if
something insane happened.

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

5. Physical Memory Hotplug

Note TDX assumes convertible memory is always physically present during
machine's runtime.  A non-buggy BIOS should never support hot-removal of
any convertible memory.  This implementation doesn't handle ACPI memory
removal but depends on the BIOS to behave correctly.

Also, if something insane really happened, 4) makes sure either TDX
cannot be enabled or hot-added memory will be rejected after TDX gets
enabled.

6. Kexec()

Similar to AMD's SME, in kexec() kernel needs to flush dirty cachelines
of TDX private memory otherwise they may silently corrupt the new kernel.

7. TDX erratum

The first few generations of TDX hardware have an erratum.  A partial
write to a TDX private memory cacheline will silently "poison" the
line.  Subsequent reads will consume the poison and generate a machine
check.

The fast warm reset reboot doesn't reset TDX private memory.  With this
erratum, all TDX private pages needs to be converted back to normal
before a fast warm reset reboot or booting to the new kernel in kexec().
Otherwise, the new kernel may get unexpected machine check.

In normal condition, triggering the erratum in Linux requires some kind
of kernel bug involving relatively exotic memory writes to TDX private
memory and will manifest via spurious-looking machine checks when
reading the affected memory.  Machine check handler is improved to deal
with such machine check.


[1]: TDX specs
https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

[2]: KVM TDX basic feature support
https://lore.kernel.org/kvm/cover.1685333727.git.isaku.yamahata@intel.com/T/#t

[3]: KVM: mm: fd-based approach for supporting KVM
https://lore.kernel.org/kvm/20221202061347.1070246-1-chao.p.peng@linux.intel.com/

[4]: TDX erratum
https://cdrdv2.intel.com/v1/dl/getContent/772415?explicitVersion=true




Kai Huang (22):
  x86/tdx: Define TDX supported page sizes as macros
  x86/virt/tdx: Detect TDX during kernel boot
  x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
  x86/cpu: Detect TDX partial write machine check erratum
  x86/virt/tdx: Add SEAMCALL infrastructure
  x86/virt/tdx: Handle SEAMCALL running out of entropy error
  x86/virt/tdx: Add skeleton to enable TDX on demand
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
  x86/kexec: Flush cache of TDX private memory
  x86/virt/tdx: Keep TDMRs when module initialization is successful
  x86/kexec(): Reset TDX private memory on platforms with TDX erratum
  x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
  x86/mce: Improve error log of kernel space TDX #MC due to erratum
  Documentation/x86: Add documentation for TDX host support

 Documentation/arch/x86/tdx.rst     |  189 +++-
 arch/x86/Kconfig                   |   15 +
 arch/x86/Makefile                  |    2 +
 arch/x86/coco/tdx/tdx.c            |    6 +-
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/msr-index.h   |    3 +
 arch/x86/include/asm/tdx.h         |   26 +
 arch/x86/kernel/cpu/intel.c        |   17 +
 arch/x86/kernel/cpu/mce/core.c     |   33 +
 arch/x86/kernel/machine_kexec_64.c |    9 +
 arch/x86/kernel/process.c          |    7 +-
 arch/x86/kernel/reboot.c           |   15 +
 arch/x86/kernel/setup.c            |    2 +
 arch/x86/virt/Makefile             |    2 +
 arch/x86/virt/vmx/Makefile         |    2 +
 arch/x86/virt/vmx/tdx/Makefile     |    2 +
 arch/x86/virt/vmx/tdx/seamcall.S   |   52 +
 arch/x86/virt/vmx/tdx/tdx.c        | 1542 ++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h        |  151 +++
 arch/x86/virt/vmx/tdx/tdxcall.S    |   19 +-
 20 files changed, 2078 insertions(+), 17 deletions(-)
 create mode 100644 arch/x86/virt/Makefile
 create mode 100644 arch/x86/virt/vmx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/Makefile
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
 create mode 100644 arch/x86/virt/vmx/tdx/tdx.h


base-commit: 94142c9d1bdf1c18027a42758ceb6bdd59a92012
-- 
2.40.1

