Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F956740C11
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbjF1I6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:58:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:18178 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235352AbjF1Ilz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687941715; x=1719477715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X9YT8xO1mfFgYrBvJu14NdxwqGz4OshNKa7870JKD48=;
  b=LYXCEPLG02x5wzP5NQtm/UeN4WG2S8IMaioni6vogskTqt3b1Kpb4FPN
   v4ROzqnIu1dJJ9vHJF6w44vz5aqwoxVgYAZJATSiw19e9F3Hn7IX3ld6d
   j9HaI2Qa208tZUo+AKfybB4vCJKtI+tNJZGWJl9GK8MhNWTpLhxoJbM4f
   xU21k7Jqvnv749bKbXQlj3VN6prn81BHgFyT3D7V/ogq+AtQHLLq/jtKf
   9kNTUEAqSMt4Pb6szMLprRu6Mt01ZoS83CacaJn4RwLrLrAXnpe6XcTAF
   lchnDjFiQ0xi6tOLCUybmGBGBLK6JaRHofVFvEvq5NQhxGXgKxWmgCFiO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="351556274"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="351556274"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 00:04:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10754"; a="829969771"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="829969771"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2023 00:04:19 -0700
Date:   Wed, 28 Jun 2023 15:04:19 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 00/22] TDX host kernel support
Message-ID: <20230628070418.6dky65allycok4us@yy-desk-7060>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:30AM +1200, Kai Huang wrote:
> Intel Trusted Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  TDX specs are available in [1].
>
> This series is the initial support to enable TDX with minimal code to
> allow KVM to create and run TDX guests.  KVM support for TDX is being
> developed separately[2].  A new "userspace inaccessible memfd" approach
> to support TDX private memory is also being developed[3].  The KVM will
> only support the new "userspace inaccessible memfd" as TDX guest memory.
>
> Also, a few first generations of TDX hardware have an erratum[4], and
> require additional handing.
>
> This series doesn't aim to support all functionalities, and doesn't aim
> to resolve all things perfectly.  All other optimizations will be posted
> as follow-up once this initial TDX support is upstreamed.
>
> (For memory hotplug, sorry for broadcasting widely but I cc'ed the
> linux-mm@kvack.org following Kirill's suggestion so MM experts can also
> help to provide comments.)

.....

>
> == Design Considerations ==
>
> 1. Initialize the TDX module at runtime
>
> There are basically two ways the TDX module could be initialized: either
> in early boot, or at runtime before the first TDX guest is run.  This
> series implements the runtime initialization.
>
> Also, TDX requires a per-cpu initialization SEAMCALL to be done before
> making any SEAMCALL on that cpu.
>
> This series adds two functions: tdx_cpu_enable() and tdx_enable() to do
> per-cpu initialization and module initialization respectively.
>
> 2. CPU hotplug
>
> DX doesn't support physical (ACPI) CPU hotplug.  A non-buggy BIOS should
  ^^

Need T here.

> never support hotpluggable CPU devicee and/or deliver ACPI CPU hotplug
> event to the kernel.  This series doesn't handle physical (ACPI) CPU
> hotplug at all but depends on the BIOS to behave correctly.
>
> Also, tdx_cpu_enable() will simply return error for any hot-added cpu if
> something insane happened.
>
> Note TDX works with CPU logical online/offline, thus this series still
> allows to do logical CPU online/offline.
>
> 3. Kernel policy on TDX memory
>
> The TDX module reports a list of "Convertible Memory Region" (CMR) to
> indicate which memory regions are TDX-capable.  The TDX architecture
> allows the VMM to designate specific convertible memory regions as usable
> for TDX private memory.
>
> The initial support of TDX guests will only allocate TDX private memory
> from the global page allocator.  This series chooses to designate _all_
> system RAM in the core-mm at the time of initializing TDX module as TDX
> memory to guarantee all pages in the page allocator are TDX pages.
>
> 4. Memory Hotplug
>
> After the kernel passes all "TDX-usable" memory regions to the TDX
> module, the set of "TDX-usable" memory regions are fixed during module's
> runtime.  No more "TDX-usable" memory can be added to the TDX module
> after that.
>
> To achieve above "to guarantee all pages in the page allocator are TDX
> pages", this series simply choose to reject any non-TDX-usable memory in
> memory hotplug.
>
> 5. Physical Memory Hotplug
>
> Note TDX assumes convertible memory is always physically present during
> machine's runtime.  A non-buggy BIOS should never support hot-removal of
> any convertible memory.  This implementation doesn't handle ACPI memory
> removal but depends on the BIOS to behave correctly.
>
> Also, if something insane really happened, 4) makes sure either TDX

Please remove "4)" if have no specific meaning here.

> cannot be enabled or hot-added memory will be rejected after TDX gets
> enabled.
>
> 6. Kexec()
>
> Similar to AMD's SME, in kexec() kernel needs to flush dirty cachelines
> of TDX private memory otherwise they may silently corrupt the new kernel.
>
> 7. TDX erratum
>
> The first few generations of TDX hardware have an erratum.  A partial
> write to a TDX private memory cacheline will silently "poison" the
> line.  Subsequent reads will consume the poison and generate a machine
> check.
>
> The fast warm reset reboot doesn't reset TDX private memory.  With this
> erratum, all TDX private pages needs to be converted back to normal
> before a fast warm reset reboot or booting to the new kernel in kexec().
> Otherwise, the new kernel may get unexpected machine check.
>
> In normal condition, triggering the erratum in Linux requires some kind
> of kernel bug involving relatively exotic memory writes to TDX private
> memory and will manifest via spurious-looking machine checks when
> reading the affected memory.  Machine check handler is improved to deal
> with such machine check.
>
>
> [1]: TDX specs
> https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
>
> [2]: KVM TDX basic feature support
> https://lore.kernel.org/kvm/cover.1685333727.git.isaku.yamahata@intel.com/T/#t
>
> [3]: KVM: mm: fd-based approach for supporting KVM
> https://lore.kernel.org/kvm/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
>
> [4]: TDX erratum
> https://cdrdv2.intel.com/v1/dl/getContent/772415?explicitVersion=true
>
>
>
>
> Kai Huang (22):
>   x86/tdx: Define TDX supported page sizes as macros
>   x86/virt/tdx: Detect TDX during kernel boot
>   x86/virt/tdx: Make INTEL_TDX_HOST depend on X86_X2APIC
>   x86/cpu: Detect TDX partial write machine check erratum
>   x86/virt/tdx: Add SEAMCALL infrastructure
>   x86/virt/tdx: Handle SEAMCALL running out of entropy error
>   x86/virt/tdx: Add skeleton to enable TDX on demand
>   x86/virt/tdx: Get information about TDX module and TDX-capable memory
>   x86/virt/tdx: Use all system memory when initializing TDX module as
>     TDX memory
>   x86/virt/tdx: Add placeholder to construct TDMRs to cover all TDX
>     memory regions
>   x86/virt/tdx: Fill out TDMRs to cover all TDX memory regions
>   x86/virt/tdx: Allocate and set up PAMTs for TDMRs
>   x86/virt/tdx: Designate reserved areas for all TDMRs
>   x86/virt/tdx: Configure TDX module with the TDMRs and global KeyID
>   x86/virt/tdx: Configure global KeyID on all packages
>   x86/virt/tdx: Initialize all TDMRs
>   x86/kexec: Flush cache of TDX private memory
>   x86/virt/tdx: Keep TDMRs when module initialization is successful
>   x86/kexec(): Reset TDX private memory on platforms with TDX erratum
>   x86/virt/tdx: Allow SEAMCALL to handle #UD and #GP
>   x86/mce: Improve error log of kernel space TDX #MC due to erratum
>   Documentation/x86: Add documentation for TDX host support
>
>  Documentation/arch/x86/tdx.rst     |  189 +++-
>  arch/x86/Kconfig                   |   15 +
>  arch/x86/Makefile                  |    2 +
>  arch/x86/coco/tdx/tdx.c            |    6 +-
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  arch/x86/include/asm/msr-index.h   |    3 +
>  arch/x86/include/asm/tdx.h         |   26 +
>  arch/x86/kernel/cpu/intel.c        |   17 +
>  arch/x86/kernel/cpu/mce/core.c     |   33 +
>  arch/x86/kernel/machine_kexec_64.c |    9 +
>  arch/x86/kernel/process.c          |    7 +-
>  arch/x86/kernel/reboot.c           |   15 +
>  arch/x86/kernel/setup.c            |    2 +
>  arch/x86/virt/Makefile             |    2 +
>  arch/x86/virt/vmx/Makefile         |    2 +
>  arch/x86/virt/vmx/tdx/Makefile     |    2 +
>  arch/x86/virt/vmx/tdx/seamcall.S   |   52 +
>  arch/x86/virt/vmx/tdx/tdx.c        | 1542 ++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h        |  151 +++
>  arch/x86/virt/vmx/tdx/tdxcall.S    |   19 +-
>  20 files changed, 2078 insertions(+), 17 deletions(-)
>  create mode 100644 arch/x86/virt/Makefile
>  create mode 100644 arch/x86/virt/vmx/Makefile
>  create mode 100644 arch/x86/virt/vmx/tdx/Makefile
>  create mode 100644 arch/x86/virt/vmx/tdx/seamcall.S
>  create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
>  create mode 100644 arch/x86/virt/vmx/tdx/tdx.h
>
>
> base-commit: 94142c9d1bdf1c18027a42758ceb6bdd59a92012
> --
> 2.40.1
>
