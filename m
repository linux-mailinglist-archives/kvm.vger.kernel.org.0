Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805BE6605DD
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 18:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjAFRqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 12:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234433AbjAFRq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 12:46:28 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0443224F;
        Fri,  6 Jan 2023 09:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673027184; x=1704563184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vgc/P/waRlsOS+ZIRR3a4mKEJ5nGTFXHhCEpPUW08Cc=;
  b=dNExepknSw3q7Azd2yA9RZncIMI7HFrAKyV0Rg8I7T+5rcFvnPybcf00
   KoDrh8ACmYl5bGB5rYsJIhVfemUQ/7ZbmAefKR3h9r+Qx9Jz1+8GuYlby
   U5asDRagpJ6uixyTCvUEOGcI8XLXxQQ8RC3PeKolQ24JmsngHOwpLUc+f
   qVEm1EABhOSNXl/2gfmCgHGT2GKvuwlqLNEZz0GVvfFfAF78ZIWfEnsVe
   8QTkYT1nrmSmJVqiX1HRFN0pDg+WVOHcgrbj/eI+42jOQAjcBP8vciNUB
   e2hSPKSoXHWSF3IP6K88tsQdwThGgSQcNmGMzP0+BUnVBmLwnhEr8a/ZG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="302223465"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="302223465"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:46:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="744705105"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="744705105"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 09:46:13 -0800
Message-ID: <d1093b3e-cdab-b138-d488-19b9456be978@intel.com>
Date:   Fri, 6 Jan 2023 09:46:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> For now, both the TDX module information and CMRs are only used during
> the module initialization, so declare them as local.  However, they are
> 1024 bytes and 512 bytes respectively.  Putting them to the stack
> exceeds the default "stack frame size" that the kernel assumes as safe,
> and the compiler yields a warning about this.  Add a kernel build flag
> to extend the safe stack size to 4K for tdx.c to silence the warning --
> the initialization function is only called once so it's safe to have a
> 4K stack.

Gah.  This has gone off in a really odd direction.

The fact that this is called once really has nothing to do with how
tolerant of a large stack we should be.  If a function is called once
from a deep call stack, it can't consume a lot of stack space.  If it's
called a billion times from a shallow stack depth, it can use all the
stack it wants.

All I really wanted here was this:

static int init_tdx_module(void)
{
-	struct cmr_info cmr_array[MAX_CMRS] ...;+	static struct cmr_info
cmr_array[MAX_CMRS] ...;

Just make the function variable static instead of having it be a global.
 That's *IT*.

> Note not all members in the 1024 bytes TDX module information are used
> (even by the KVM).

I'm not sure what this has to do with anything.

> diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> index 38d534f2c113..f8a40d15fdfc 100644
> --- a/arch/x86/virt/vmx/tdx/Makefile
> +++ b/arch/x86/virt/vmx/tdx/Makefile
> @@ -1,2 +1,3 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +CFLAGS_tdx.o += -Wframe-larger-than=4096
>  obj-y += tdx.o seamcall.o
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index b7cedf0589db..6fe505c32599 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -13,6 +13,7 @@
>  #include <linux/errno.h>
>  #include <linux/printk.h>
>  #include <linux/mutex.h>
> +#include <asm/pgtable_types.h>
>  #include <asm/msr.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
> @@ -107,9 +108,8 @@ bool platform_tdx_enabled(void)
>   * leaf function return code and the additional output respectively if
>   * not NULL.
>   */
> -static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> -				    u64 *seamcall_ret,
> -				    struct tdx_module_output *out)
> +static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
> +		    u64 *seamcall_ret, struct tdx_module_output *out)
>  {
>  	u64 sret;
>  
> @@ -150,12 +150,85 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	}
>  }
>  
> +static inline bool is_cmr_empty(struct cmr_info *cmr)
> +{
> +	return !cmr->size;
> +}
> +
> +static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_cmrs; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		/*
> +		 * The array of CMRs reported via TDH.SYS.INFO can
> +		 * contain tail empty CMRs.  Don't print them.
> +		 */
> +		if (is_cmr_empty(cmr))
> +			break;
> +
> +		pr_info("CMR: [0x%llx, 0x%llx)\n", cmr->base,
> +				cmr->base + cmr->size);
> +	}
> +}
> +
> +/*
> + * Get the TDX module information (TDSYSINFO_STRUCT) and the array of
> + * CMRs, and save them to @sysinfo and @cmr_array, which come from the
> + * kernel stack.  @sysinfo must have been padded to have enough room
> + * to save the TDSYSINFO_STRUCT.
> + */
> +static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
> +			   struct cmr_info *cmr_array)
> +{
> +	struct tdx_module_output out;
> +	u64 sysinfo_pa, cmr_array_pa;
> +	int ret;
> +
> +	/*
> +	 * Cannot use __pa() directly as @sysinfo and @cmr_array
> +	 * come from the kernel stack.
> +	 */
> +	sysinfo_pa = slow_virt_to_phys(sysinfo);
> +	cmr_array_pa = slow_virt_to_phys(cmr_array);

Note: they won't be on the kernel stack if they're 'static'.

> +	ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
> +			cmr_array_pa, MAX_CMRS, NULL, &out);
> +	if (ret)
> +		return ret;
> +
> +	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
> +		sysinfo->attributes,	sysinfo->vendor_id,
> +		sysinfo->major_version, sysinfo->minor_version,
> +		sysinfo->build_date,	sysinfo->build_num);
> +
> +	/* R9 contains the actual entries written to the CMR array. */
> +	print_cmrs(cmr_array, out.r9);
> +
> +	return 0;
> +}
> +
>  static int init_tdx_module(void)
>  {
> +	/*
> +	 * @tdsysinfo and @cmr_array are used in TDH.SYS.INFO SEAMCALL ABI.
> +	 * They are 1024 bytes and 512 bytes respectively but it's fine to
> +	 * keep them in the stack as this function is only called once.
> +	 */

Again, more silliness about being called once.

> +	DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
> +			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
> +	struct cmr_info cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);

One more thing about being on the stack: These aren't implicitly zeroed.
 They might have stack gunk from other calls in them.  I _think_ that's
OK because of, for instance, the 'out.r9' that limits how many CMRs get
read.  But, not being zeroed is a potential source of bugs and it's also
something that reviewers (and you) need to think about to make sure it
doesn't have side-effects.

> +	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
> +	int ret;
> +
> +	ret = tdx_get_sysinfo(sysinfo, cmr_array);
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * TODO:
>  	 *
> -	 *  - Get TDX module information and TDX-capable memory regions.
>  	 *  - Build the list of TDX-usable memory regions.
>  	 *  - Construct a list of TDMRs to cover all TDX-usable memory
>  	 *    regions.
> @@ -166,7 +239,9 @@ static int init_tdx_module(void)
>  	 *
>  	 *  Return error before all steps are done.
>  	 */
> -	return -EINVAL;
> +	ret = -EINVAL;
> +out:
> +	return ret;
>  }

I'm going to be lazy and not look into the future.  But, you don't need
the "out:" label here, yet.  It doesn'serve any purpose like this, so
why introduce it here?

>  static int __tdx_enable(void)
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 884357a4133c..6d32f62e4182 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -3,6 +3,8 @@
>  #define _X86_VIRT_TDX_H
>  
>  #include <linux/types.h>
> +#include <linux/stddef.h>
> +#include <linux/compiler_attributes.h>
>  
>  /*
>   * This file contains both macros and data structures defined by the TDX
> @@ -14,6 +16,80 @@
>  /* MSR to report KeyID partitioning between MKTME and TDX */
>  #define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
>  
> +/*
> + * TDX module SEAMCALL leaf functions
> + */
> +#define TDH_SYS_INFO		32
> +
> +struct cmr_info {
> +	u64	base;
> +	u64	size;
> +} __packed;
> +
> +#define MAX_CMRS			32
> +#define CMR_INFO_ARRAY_ALIGNMENT	512
> +
> +struct cpuid_config {
> +	u32	leaf;
> +	u32	sub_leaf;
> +	u32	eax;
> +	u32	ebx;
> +	u32	ecx;
> +	u32	edx;
> +} __packed;
> +
> +#define DECLARE_PADDED_STRUCT(type, name, size, alignment)	\
> +	struct type##_padded {					\
> +		union {						\
> +			struct type name;			\
> +			u8 padding[size];			\
> +		};						\
> +	} name##_padded __aligned(alignment)
> +
> +#define PADDED_STRUCT(name)	(name##_padded.name)

These don't turn out looking _that_ nice in practice, but I do vastly
prefer them to hard-coded padding.

<snip>
