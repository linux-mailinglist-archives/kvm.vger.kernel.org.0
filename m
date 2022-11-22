Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76386633124
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbiKVAKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiKVAKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:10:44 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95DAD478;
        Mon, 21 Nov 2022 16:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669075843; x=1700611843;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Io9xGqqirZVU1UcPCT7yv8XH2H8JPl4N+0kewny9aSE=;
  b=hjBrXRojbU1AUHzCfh/hsOcXaSrfmZhaoX1bcSIxOD8a2qDAY/0rlTu/
   nXY0/GywuC15weyQnQ0L4QgpzJls1XGHpwyXmIxA+a3qjEXOEJjYisiIV
   ihoIPHyzJD+NF1GF2uRyK5UIt9c2EdFsXNUDYFZ2AJzL0P8XxF7U4ZnxX
   nNwIcsjAhW7aqG3OyNPhizO5qM6IMeG0wK5LBP7Mtdqnbbbb+Bo7tqi7U
   mcs8C92QW6Yvo6B2WbCY+LnHIpFO9PSEpCyaBRHVFCNgPgVlm6folFYTS
   0sdU7jLlBXdvk7HeWXvqv1S3I0cPQlruZRx7p1o1VPngF2ZBxH9zRsQvr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="315512504"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="315512504"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:10:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="815898126"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="815898126"
Received: from ticela-or-327.amr.corp.intel.com (HELO [10.209.6.63]) ([10.209.6.63])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 16:10:41 -0800
Message-ID: <e758572a-5bb1-092a-10f6-591fb4526997@intel.com>
Date:   Mon, 21 Nov 2022 16:10:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> host and certain physical attacks.  A CPU-attested software module
> called 'the TDX module' runs inside a new isolated memory range as a
> trusted hypervisor to manage and run protected VMs.
> 
> Pre-TDX Intel hardware has support for a memory encryption architecture
> called MKTME.  The memory encryption hardware underpinning MKTME is also
> used for Intel TDX.  TDX ends up "stealing" some of the physical address
> space from the MKTME architecture for crypto-protection to VMs.  The
> BIOS is responsible for partitioning the "KeyID" space between legacy
> MKTME and TDX.  The KeyIDs reserved for TDX are called 'TDX private
> KeyIDs' or 'TDX KeyIDs' for short.
> 
> TDX doesn't trust the BIOS.  During machine boot, TDX verifies the TDX
> private KeyIDs are consistently and correctly programmed by the BIOS
> across all CPU packages before it enables TDX on any CPU core.  A valid
> TDX private KeyID range on BSP indicates TDX has been enabled by the
> BIOS, otherwise the BIOS is buggy.
> 
> The TDX module is expected to be loaded by the BIOS when it enables TDX,
> but the kernel needs to properly initialize it before it can be used to
> create and run any TDX guests.  The TDX module will be initialized at
> runtime by the user (i.e. KVM) on demand.

Calling KVM "the user" is a stretch.  How about we give actual user
facts instead of filling this with i.e.'s when there's only one actual
way it happens?

	The TDX module will be initialized by the KVM subsystem when
	<insert actual trigger description here>.

> Add a new early_initcall(tdx_init) to do TDX early boot initialization.
> Only detect TDX private KeyIDs for now.  Some other early checks will
> follow up.

Just say what this patch is doing.  Don't try to

>  Also add a new function to report whether TDX has been
> enabled by BIOS (TDX private KeyID range is valid).  Kexec() will also
> need it to determine whether need to flush dirty cachelines that are
> associated with any TDX private KeyIDs before booting to the new kernel.

That last sentence doesn't parse correctly.

> To start to support TDX, create a new arch/x86/virt/vmx/tdx/tdx.c for
> TDX host kernel support.  Add a new Kconfig option CONFIG_INTEL_TDX_HOST
> to opt-in TDX host kernel support (to distinguish with TDX guest kernel
> support).  So far only KVM is the only user of TDX.  Make the new config
> option depend on KVM_INTEL.
..
> +config INTEL_TDX_HOST
> +	bool "Intel Trust Domain Extensions (TDX) host support"
> +	depends on CPU_SUP_INTEL
> +	depends on X86_64
> +	depends on KVM_INTEL
> +	help
> +	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
> +	  host and certain physical attacks.  This option enables necessary TDX
> +	  support in host kernel to run protected VMs.
> +
> +	  If unsure, say N.
> +
>  config EFI
>  	bool "EFI runtime service support"
>  	depends on ACPI
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 415a5d138de4..38d3e8addc5f 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -246,6 +246,8 @@ archheaders:
>  
>  libs-y  += arch/x86/lib/
>  
> +core-y += arch/x86/virt/
> +
>  # drivers-y are linked after core-y
>  drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
>  drivers-$(CONFIG_PCI)            += arch/x86/pci/
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index e9a3f4a6fba1..51c4222a13ae 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -98,5 +98,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  	return -ENODEV;
>  }
>  #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
> +
> +#ifdef CONFIG_INTEL_TDX_HOST
> +bool platform_tdx_enabled(void);
> +#else	/* !CONFIG_INTEL_TDX_HOST */
> +static inline bool platform_tdx_enabled(void) { return false; }
> +#endif	/* CONFIG_INTEL_TDX_HOST */
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASM_X86_TDX_H */
> diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
> new file mode 100644
> index 000000000000..1e36502cd738
> --- /dev/null
> +++ b/arch/x86/virt/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-y	+= vmx/
> diff --git a/arch/x86/virt/vmx/Makefile b/arch/x86/virt/vmx/Makefile
> new file mode 100644
> index 000000000000..feebda21d793
> --- /dev/null
> +++ b/arch/x86/virt/vmx/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx/
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> new file mode 100644
> index 000000000000..93ca8b73e1f1
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -0,0 +1,2 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-y += tdx.o
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> new file mode 100644
> index 000000000000..982d9c453b6b
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2022 Intel Corporation.
> + *
> + * Intel Trusted Domain Extensions (TDX) support
> + */
> +
> +#define pr_fmt(fmt)	"tdx: " fmt
> +
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/printk.h>
> +#include <asm/msr-index.h>
> +#include <asm/msr.h>
> +#include <asm/tdx.h>
> +#include "tdx.h"
> +
> +static u32 tdx_keyid_start __ro_after_init;
> +static u32 tdx_keyid_num __ro_after_init;
> +
> +/*
> + * Detect TDX private KeyIDs to see whether TDX has been enabled by the
> + * BIOS.  Both initializing the TDX module and running TDX guest require
> + * TDX private KeyID.

This comment is not right, sorry.

Talk about the function at a *HIGH* level.  Don't talk about every
little detailed facet of the function.  That's what the code is there for.

> + * TDX doesn't trust BIOS.  TDX verifies all configurations from BIOS
> + * are correct before enabling TDX on any core.  TDX requires the BIOS
> + * to correctly and consistently program TDX private KeyIDs on all CPU
> + * packages.  Unless there is a BIOS bug, detecting a valid TDX private
> + * KeyID range on BSP indicates TDX has been enabled by the BIOS.  If
> + * there's such BIOS bug, it will be caught later when initializing the
> + * TDX module.
> + */

I have no idea what that comment is doing.  Can it just be removed?

> +static int __init detect_tdx(void)
> +{
> +	int ret;
> +
> +	/*
> +	 * IA32_MKTME_KEYID_PARTIONING:
> +	 *   Bit [31:0]:	Number of MKTME KeyIDs.
> +	 *   Bit [63:32]:	Number of TDX private KeyIDs.
> +	 */
> +	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &tdx_keyid_start,
> +			&tdx_keyid_num);

'tdx_keyid_start' appears to be named wrong.

> +	if (ret)
> +		return -ENODEV;
> +
> +	if (!tdx_keyid_num)
> +		return -ENODEV;
> +
> +	/*
> +	 * KeyID 0 is for TME.  MKTME KeyIDs start from 1.  TDX private
> +	 * KeyIDs start after the last MKTME KeyID.
> +	 */

Is the TME key a "MKTME KeyID"?

> +	tdx_keyid_start++;

... and this confirms it.

This probably should be:

	u32 nr_mktme_keyids;

	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING,
					&nr_mktme_keyids,
					&tdx_keyid_num);
	...

	/* TDX KeyIDs start after the last MKTME KeyID */
	tdx_keyid_start = nr_mktme_keyids + 1;

See how that makes actual logical sense and barely even needs the comment?


> +	pr_info("TDX enabled by BIOS. TDX private KeyID range: [%u, %u)\n",
> +			tdx_keyid_start, tdx_keyid_start + tdx_keyid_num);
> +
> +	return 0;
> +}
> +
> +static void __init clear_tdx(void)
> +{
> +	tdx_keyid_start = tdx_keyid_num = 0;
> +}

This is where a comment is needed and can actually help.

/*
 * tdx_keyid_start/num indicate that TDX is uninitialized.  This
 * is used in TDX initialization error paths to take it from
 * initialized -> uninitialized.
 */

> +static int __init tdx_init(void)
> +{
> +	if (detect_tdx())
> +		return -ENODEV;

This reads as:

	if tdx is detected:
		return error


So, first, why bother having detect_tdx() return fancy -ERRNO codes if
they're going to be throw away?  You could at *least* do:


	int err;

	err = tdx_record_keyid_partioning();
	if (err)
		return err;

Note how tdx_record_keyid_partioning() actually talks about what the
function does.  There's also a recent trend in x86 land not to put
obvious prefixes on functions.  That would make the naming more or less
record_keyid_partioning().

I kinda like the consistent prefixes but Boris doesn't.

> +	/*
> +	 * Initializing the TDX module requires one TDX private KeyID.
> +	 * If there's only one TDX KeyID then after module initialization
> +	 * KVM won't be able to run any TDX guest, which makes the whole
> +	 * thing worthless.  Just disable TDX in this case.
> +	 */
> +	if (tdx_keyid_num < 2) {
> +		pr_info("Disable TDX as there's only one TDX private KeyID available.\n");
> +		goto no_tdx;
> +	}

'tdx_keyid_num' is a crummy name.  Here it reads like, "if the tdx keyid
number is < 2'.  Which is wrong.  A better name would be: nr_tdx_keyids

That's also a horrible error message.  You have:

+#define pr_fmt(fmt)	"tdx: " fmt

so that message will look like:

tdx: Disable TDX as there's only one TDX private KeyID available.

How many 'TDX' strings do we need in one message.  How about:

	pr_info("initialization failed: too few private KeyIDs available
(%d).\n", nr_tdx_keyids;

That gives a lot more information and removes the two redundant TDX strings.

 +no_tdx:
> +	clear_tdx();
> +	return -ENODEV;
> +}
> +early_initcall(tdx_init);
> +
> +/* Return whether the BIOS has enabled TDX */
> +bool platform_tdx_enabled(void)
> +{
> +	return !!tdx_keyid_num;
> +}
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> new file mode 100644
> index 000000000000..d00074abcb20
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _X86_VIRT_TDX_H
> +#define _X86_VIRT_TDX_H
> +
> +/*
> + * This file contains both macros and data structures defined by the TDX
> + * architecture and Linux defined software data structures and functions.
> + * The two should not be mixed together for better readability.  The
> + * architectural definitions come first.
> + */
> +
> +/* MSR to report KeyID partitioning between MKTME and TDX */
> +#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
> +
> +#endif

