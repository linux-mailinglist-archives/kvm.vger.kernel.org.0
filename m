Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6315634B44
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 00:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbiKVXjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 18:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiKVXjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 18:39:53 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F852C7221;
        Tue, 22 Nov 2022 15:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669160391; x=1700696391;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RxI2g5K8kpVdjqlwvUTUddLxgECKx2ZwFurQYDEgcnY=;
  b=FUChoL/842Yw3jkJbSVyP/2wCngg6TMJOGA4PBWHJNEZSIIQ7TjLh05x
   pyYRD+yWVkvRIBd8tgYj2tCkK1nhMmxvltQDi5faWrNrQN09GO5ho0KbG
   YNtSNXZpBEJwkFy1M7Xbw59KljVs/bX2ooWS9peuCavSVh2RE8fAgaBQw
   DXLwcln2As4FFZtmRBT/bktVsvu9Jsl1Is4aulC5MTnlWe+yW5kpEaGkh
   6G1UgK5O5Wr+yNZ+Mj4BxDzFdtn5NopToLqPhq+Q3Ngrc68byBAPzJ2wc
   vfOuWDeTM1R123P3ioECvDuQ8yjLVYI0Du8aa1b19ZR9A37qefLDjv1GN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="301495099"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="301495099"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 15:39:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784016044"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="784016044"
Received: from coltsavx-mobl1.amr.corp.intel.com (HELO [10.255.0.114]) ([10.255.0.114])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 15:39:26 -0800
Message-ID: <850e0899-d54e-6a49-851e-56f4d353905c@intel.com>
Date:   Tue, 22 Nov 2022 15:39:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module
 and TDX-capable memory
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
 <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.  The list of these
> ranges, along with TDX module information, is available to the kernel by
> querying the TDX module via TDH.SYS.INFO SEAMCALL.

I think the last sentence goes too far.  What does it matter what the
name of the SEAMCALL is?  Who cares at this point?  It's in the patch.
Scroll down two pages if you really care.

> The host kernel can choose whether or not to use all convertible memory
> regions as TDX-usable memory.  Before the TDX module is ready to create
> any TDX guests, the kernel needs to configure the TDX-usable memory
> regions by passing an array of "TD Memory Regions" (TDMRs) to the TDX
> module.  Constructing the TDMR array requires information of both the
> TDX module (TDSYSINFO_STRUCT) and the Convertible Memory Regions.  Call
> TDH.SYS.INFO to get this information as a preparation.

That last sentece is kinda goofy.  I think there's a way to distill this
whole thing down more effecively.

	CMRs tell the kernel which memory is TDX compatible.  The kernel
	takes CMRs and constructs  "TD Memory Regions" (TDMRs).  TDMRs
	let the kernel grante TDX protections to some or all of the CMR
	areas.
	
> Use static variables for both TDSYSINFO_STRUCT and CMR array to avoid

I find it very useful to be precise when referring to code.  Your code
says 'tdsysinfo_struct', yet this says 'TDSYSINFO_STRUCT'.  Why the
difference?

> having to pass them as function arguments when constructing the TDMR
> array.  And they are too big to be put to the stack anyway.  Also, KVM
> needs to use the TDSYSINFO_STRUCT to create TDX guests.

This is also a great place to mention that the tdsysinfo_struct contains
a *lot* of gunk which will not be used for a bit or that may never get
used.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2cf7090667aa..43227af25e44 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/align.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
> @@ -40,6 +41,11 @@ static enum tdx_module_status_t tdx_module_status;
>  /* Prevent concurrent attempts on TDX detection and initialization */
>  static DEFINE_MUTEX(tdx_module_lock);
>  
> +/* Below two are used in TDH.SYS.INFO SEAMCALL ABI */
> +static struct tdsysinfo_struct tdx_sysinfo;
> +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> +static int tdx_cmr_num;
> +
>  /*
>   * Detect TDX private KeyIDs to see whether TDX has been enabled by the
>   * BIOS.  Both initializing the TDX module and running TDX guest require
> @@ -208,6 +214,121 @@ static int tdx_module_init_cpus(void)
>  	return atomic_read(&sc.err);
>  }
>  
> +static inline bool is_cmr_empty(struct cmr_info *cmr)
> +{
> +	return !cmr->size;
> +}
> +
> +static inline bool is_cmr_ok(struct cmr_info *cmr)
> +{
> +	/* CMR must be page aligned */
> +	return IS_ALIGNED(cmr->base, PAGE_SIZE) &&
> +		IS_ALIGNED(cmr->size, PAGE_SIZE);
> +}
> +
> +static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
> +		       const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		pr_info("%s : [0x%llx, 0x%llx)\n", name,
> +				cmr->base, cmr->base + cmr->size);
> +	}
> +}
> +
> +/* Check CMRs reported by TDH.SYS.INFO, and trim tail empty CMRs. */
> +static int trim_empty_cmrs(struct cmr_info *cmr_array, int *actual_cmr_num)
> +{
> +	struct cmr_info *cmr;
> +	int i, cmr_num;
> +
> +	/*
> +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> +	 *
> +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> +	 *   lowest base address to the highest base address, and they
> +	 *   are non-overlapping.
> +	 *
> +	 * This implies that BIOS may generate invalid empty entries
> +	 * if total CMRs are less than 32.  Need to skip them manually.
> +	 *
> +	 * CMR also must be 4K aligned.  TDX doesn't trust BIOS.  TDX
> +	 * actually verifies CMRs before it gets enabled, so anything
> +	 * doesn't meet above means kernel bug (or TDX is broken).
> +	 */

I dislike comments like this that describe all the code below.  Can't
you simply put the comment near the code that implements it?

> +	cmr = &cmr_array[0];
> +	/* There must be at least one valid CMR */
> +	if (WARN_ON_ONCE(is_cmr_empty(cmr) || !is_cmr_ok(cmr)))
> +		goto err;
> +
> +	cmr_num = *actual_cmr_num;
> +	for (i = 1; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +		struct cmr_info *prev_cmr = NULL;
> +
> +		/* Skip further empty CMRs */
> +		if (is_cmr_empty(cmr))
> +			break;
> +
> +		/*
> +		 * Do sanity check anyway to make sure CMRs:
> +		 *  - are 4K aligned
> +		 *  - don't overlap
> +		 *  - are in address ascending order.
> +		 */
> +		if (WARN_ON_ONCE(!is_cmr_ok(cmr)))
> +			goto err;

Why does cmr_array[0] get a pass on the empty and sanity checks?

> +		prev_cmr = &cmr_array[i - 1];
> +		if (WARN_ON_ONCE((prev_cmr->base + prev_cmr->size) >
> +					cmr->base))
> +			goto err;
> +	}
> +
> +	/* Update the actual number of CMRs */
> +	*actual_cmr_num = i;

That comment is not helpful.  Yes, this is literally updating the number
of CMRs.  Literally.  That's the "what".  But, the "why" is important.
Why is it doing this?

> +	/* Print kernel checked CMRs */
> +	print_cmrs(cmr_array, *actual_cmr_num, "Kernel-checked-CMR");

This is the point where I start to lose patience with these comments.
These are just a waste of space.

Also, I saw the loop above check 'cmr_num' CMRs for is_cmr_ok().  Now,
it'll print an 'actual_cmr_num=1' number of CMRs as being
"kernel-checked".  Why?  That makes zero sense.

> +	return 0;
> +err:
> +	pr_info("[TDX broken ?]: Invalid CMRs detected\n");
> +	print_cmrs(cmr_array, cmr_num, "BIOS-CMR");
> +	return -EINVAL;
> +}
> +
> +static int tdx_get_sysinfo(void)
> +{
> +	struct tdx_module_output out;
> +	int ret;
> +
> +	BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
> +
> +	ret = seamcall(TDH_SYS_INFO, __pa(&tdx_sysinfo), TDSYSINFO_STRUCT_SIZE,
> +			__pa(tdx_cmr_array), MAX_CMRS, NULL, &out);
> +	if (ret)
> +		return ret;
> +
> +	/* R9 contains the actual entries written the CMR array. */
> +	tdx_cmr_num = out.r9;
> +
> +	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
> +		tdx_sysinfo.attributes, tdx_sysinfo.vendor_id,
> +		tdx_sysinfo.major_version, tdx_sysinfo.minor_version,
> +		tdx_sysinfo.build_date, tdx_sysinfo.build_num);

This is a case where a little bit of vertical alignment will go a long way:

> +		tdx_sysinfo.attributes,    tdx_sysinfo.vendor_id,
> +		tdx_sysinfo.major_version, tdx_sysinfo.minor_version,
> +		tdx_sysinfo.build_date,    tdx_sysinfo.build_num);

> +
> +	/*
> +	 * trim_empty_cmrs() updates the actual number of CMRs by
> +	 * dropping all tail empty CMRs.
> +	 */
> +	return trim_empty_cmrs(tdx_cmr_array, &tdx_cmr_num);
> +}

Why does this both need to respect the "tdx_cmr_num = out.r9" value
*and* trim the empty ones?  Couldn't it just ignore the "tdx_cmr_num =
out.r9" value and just trim the empty ones either way?  It's not like
there is a billion of them.  It would simplify the code for sure.

>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -232,6 +353,10 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out;
>  
> +	ret = tdx_get_sysinfo();
> +	if (ret)
> +		goto out;
> +
>  	/*
>  	 * Return -EINVAL until all steps of TDX module initialization
>  	 * process are done.
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 9ba11808bd45..8e273756098c 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -15,10 +15,71 @@
>  /*
>   * TDX module SEAMCALL leaf functions
>   */
> +#define TDH_SYS_INFO		32
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35
>  #define TDH_SYS_LP_SHUTDOWN	44
>  
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
> +#define TDSYSINFO_STRUCT_SIZE		1024
> +#define TDSYSINFO_STRUCT_ALIGNMENT	1024
> +
> +struct tdsysinfo_struct {
> +	/* TDX-SEAM Module Info */
> +	u32	attributes;
> +	u32	vendor_id;
> +	u32	build_date;
> +	u16	build_num;
> +	u16	minor_version;
> +	u16	major_version;
> +	u8	reserved0[14];
> +	/* Memory Info */
> +	u16	max_tdmrs;
> +	u16	max_reserved_per_tdmr;
> +	u16	pamt_entry_size;
> +	u8	reserved1[10];
> +	/* Control Struct Info */
> +	u16	tdcs_base_size;
> +	u8	reserved2[2];
> +	u16	tdvps_base_size;
> +	u8	tdvps_xfam_dependent_size;
> +	u8	reserved3[9];
> +	/* TD Capabilities */
> +	u64	attributes_fixed0;
> +	u64	attributes_fixed1;
> +	u64	xfam_fixed0;
> +	u64	xfam_fixed1;
> +	u8	reserved4[32];
> +	u32	num_cpuid_config;
> +	/*
> +	 * The actual number of CPUID_CONFIG depends on above
> +	 * 'num_cpuid_config'.  The size of 'struct tdsysinfo_struct'
> +	 * is 1024B defined by TDX architecture.  Use a union with
> +	 * specific padding to make 'sizeof(struct tdsysinfo_struct)'
> +	 * equal to 1024.
> +	 */
> +	union {
> +		struct cpuid_config	cpuid_configs[0];
> +		u8			reserved5[892];
> +	};

Can you double check what the "right" way to do variable arrays is these
days?  I thought the [0] method was discouraged.

Also, it isn't *really* 892 bytes of reserved space, right?  Anything
that's not cpuid_configs[] is reserved, I presume.  Could you try to be
more precise there?

> +} __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
> +
>  /*
>   * Do not put any hardware-defined TDX structure representations below
>   * this comment!

