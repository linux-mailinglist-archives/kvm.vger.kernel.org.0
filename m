Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B367CC4B4
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343806AbjJQNYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbjJQNYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:24:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEC8EA;
        Tue, 17 Oct 2023 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697549048; x=1729085048;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uszfRUn9BLweBrg2Qb9HUI53y7cKRyD27NThnz/706Y=;
  b=HQTIAEhw9lZKrBLZINbJzwCPtcz/N+q+tpCdIOi5WUP08TNDfaRUF0hc
   mNSi1AUazAGxbeUOJgasRmfzm5YRPDVtuXQMgoDZWdR8H7qD+j/NqkOHb
   YAzbjPw/UDL+/Ffht4veAZiu4oiwh1L6bG9IBYV6BgYMpSGwqi8QgfdMf
   8CABl15H91SvYOh2dLyouq/TfL3M1h8YAJJcE+WuYZD2DsdlyiDT1/kI5
   qsw7T8BcT7j9nLKS/yDo3MGKo6D36NKFAIoppdAchnl3FkmAJOTDZJKIm
   Vn17dzVmKIHIaYRIUy+PtH4EEm6v6cGAaZAwYT7WGG8gxlDzLScpB7kAz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="370846525"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="370846525"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:24:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="826438449"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="826438449"
Received: from nmdsouza-mobl1.amr.corp.intel.com (HELO [10.209.106.102]) ([10.209.106.102])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 06:24:02 -0700
Message-ID: <9dcd49ba-66a6-4f1f-aadc-3d4c6ce16d15@linux.intel.com>
Date:   Tue, 17 Oct 2023 06:24:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 01/23] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        nik.borisov@suse.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com
References: <cover.1697532085.git.kai.huang@intel.com>
 <121aab11b48b4e6550cfe6d23b4daab744ee2076.1697532085.git.kai.huang@intel.com>
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <121aab11b48b4e6550cfe6d23b4daab744ee2076.1697532085.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/2023 3:14 AM, Kai Huang wrote:
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
> During machine boot, TDX microcode verifies that the BIOS programmed TDX
> private KeyIDs consistently and correctly programmed across all CPU
> packages.  The MSRs are locked in this state after verification.  This
> is why MSR_IA32_MKTME_KEYID_PARTITIONING gets used for TDX enumeration:
> it indicates not just that the hardware supports TDX, but that all the
> boot-time security checks passed.
> 
> The TDX module is expected to be loaded by the BIOS when it enables TDX,
> but the kernel needs to properly initialize it before it can be used to
> create and run any TDX guests.  The TDX module will be initialized by
> the KVM subsystem when KVM wants to use TDX.
> 
> Add a new early_initcall(tdx_init) to detect the TDX by detecting TDX
> private KeyIDs.  Also add a function to report whether TDX is enabled by
> the BIOS.  Similar to AMD SME, kexec() will use it to determine whether
> cache flush is needed.
> 
> The TDX module itself requires one TDX KeyID as the 'TDX global KeyID'
> to protect its metadata.  Each TDX guest also needs a TDX KeyID for its
> own protection.  Just use the first TDX KeyID as the global KeyID and
> leave the rest for TDX guests.  If no TDX KeyID is left for TDX guests,
> disable TDX as initializing the TDX module alone is useless.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---

Looks good to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

> 
> v13 -> v14:
>  - "tdx:" -> "virt/tdx:" (internal)
>  - Add Dave's tag
>  
> ---
>  arch/x86/include/asm/msr-index.h |  3 ++
>  arch/x86/include/asm/tdx.h       |  4 ++
>  arch/x86/virt/vmx/tdx/Makefile   |  2 +-
>  arch/x86/virt/vmx/tdx/tdx.c      | 90 ++++++++++++++++++++++++++++++++
>  4 files changed, 98 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/virt/vmx/tdx/tdx.c
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..7a44cac70e9f 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -535,6 +535,9 @@
>  #define MSR_RELOAD_PMC0			0x000014c1
>  #define MSR_RELOAD_FIXED_CTR0		0x00001309
>  
> +/* KeyID partitioning between MKTME and TDX */
> +#define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
> +
>  /*
>   * AMD64 MSRs. Not complete. See the architecture manual for a more
>   * complete list.
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index adcbe3f1de30..a252328734c7 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -81,6 +81,10 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  u64 __seamcall(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
>  u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
> +
> +bool platform_tdx_enabled(void);
> +#else
> +static inline bool platform_tdx_enabled(void) { return false; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 46ef8f73aebb..90da47eb85ee 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,2 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-y += seamcall.o
> +obj-y += seamcall.o tdx.o
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> new file mode 100644
> index 000000000000..13d22ea2e2d9
> --- /dev/null
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright(c) 2023 Intel Corporation.
> + *
> + * Intel Trusted Domain Extensions (TDX) support
> + */
> +
> +#define pr_fmt(fmt)	"virt/tdx: " fmt
> +
> +#include <linux/types.h>
> +#include <linux/cache.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/printk.h>
> +#include <asm/msr-index.h>
> +#include <asm/msr.h>
> +#include <asm/tdx.h>
> +
> +static u32 tdx_global_keyid __ro_after_init;
> +static u32 tdx_guest_keyid_start __ro_after_init;
> +static u32 tdx_nr_guest_keyids __ro_after_init;
> +
> +static int __init record_keyid_partitioning(u32 *tdx_keyid_start,
> +					    u32 *nr_tdx_keyids)
> +{
> +	u32 _nr_mktme_keyids, _tdx_keyid_start, _nr_tdx_keyids;
> +	int ret;
> +
> +	/*
> +	 * IA32_MKTME_KEYID_PARTIONING:
> +	 *   Bit [31:0]:	Number of MKTME KeyIDs.
> +	 *   Bit [63:32]:	Number of TDX private KeyIDs.
> +	 */
> +	ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &_nr_mktme_keyids,
> +			&_nr_tdx_keyids);
> +	if (ret)
> +		return -ENODEV;
> +
> +	if (!_nr_tdx_keyids)
> +		return -ENODEV;
> +
> +	/* TDX KeyIDs start after the last MKTME KeyID. */
> +	_tdx_keyid_start = _nr_mktme_keyids + 1;
> +
> +	*tdx_keyid_start = _tdx_keyid_start;
> +	*nr_tdx_keyids = _nr_tdx_keyids;
> +
> +	return 0;
> +}
> +
> +static int __init tdx_init(void)
> +{
> +	u32 tdx_keyid_start, nr_tdx_keyids;
> +	int err;
> +
> +	err = record_keyid_partitioning(&tdx_keyid_start, &nr_tdx_keyids);
> +	if (err)
> +		return err;
> +
> +	pr_info("BIOS enabled: private KeyID range [%u, %u)\n",
> +			tdx_keyid_start, tdx_keyid_start + nr_tdx_keyids);
> +
> +	/*
> +	 * The TDX module itself requires one 'global KeyID' to protect
> +	 * its metadata.  If there's only one TDX KeyID, there won't be
> +	 * any left for TDX guests thus there's no point to enable TDX
> +	 * at all.
> +	 */
> +	if (nr_tdx_keyids < 2) {
> +		pr_err("initialization failed: too few private KeyIDs available.\n");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * Just use the first TDX KeyID as the 'global KeyID' and
> +	 * leave the rest for TDX guests.
> +	 */
> +	tdx_global_keyid = tdx_keyid_start;
> +	tdx_guest_keyid_start = tdx_keyid_start + 1;
> +	tdx_nr_guest_keyids = nr_tdx_keyids - 1;
> +
> +	return 0;
> +}
> +early_initcall(tdx_init);
> +
> +/* Return whether the BIOS has enabled TDX */
> +bool platform_tdx_enabled(void)
> +{
> +	return !!tdx_global_keyid;
> +}

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
