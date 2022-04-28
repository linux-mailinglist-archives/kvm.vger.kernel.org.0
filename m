Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EEB5127F2
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiD1AS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 20:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiD1ASy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 20:18:54 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D9622B38;
        Wed, 27 Apr 2022 17:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651104941; x=1682640941;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hAKuRjHNr9yLfpAW60dj3hws84dhaDPrOBkrdjgC0GI=;
  b=D1yTnmZt8HetHLobkPQsiInWbh0XScDrDoNHasWr859xRo88lgEIikNW
   sLXS317ge04NddOLOUDuS8g1+xU732TZUyDgX3yp3gG6umil1YqsloVNu
   DAkJKjcFBc4nzUTMpMZdI2JxTG+llTBOra1I7DoQJ+MO1lYHUiEXj8yG6
   rzPexIBJcEZRv9AzXW6eA8zolwSBb+XYHed9x2/Nn9RZuvQckNOvMNb/i
   Pv7SLJ5Tsx7Dw3xrDdJIzWOvhvI4OS56kd01BznddxylPoHOLd8cHZCd+
   epNagz5H2PxvIbt4Z1tygCciLcnnaUCB31AjYkLIRsSfiNBd9+xao5bwu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="263699511"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="263699511"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:15:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="533516325"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:15:17 -0700
Message-ID: <0bab7221179229317a11311386c968bd0d40e344.camel@intel.com>
Subject: Re: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Thu, 28 Apr 2022 12:15:14 +1200
In-Reply-To: <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
         <f929fb7a-5bdc-2567-77aa-762a098c8513@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-04-27 at 15:15 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > TDX provides increased levels of memory confidentiality and integrity.
> > This requires special hardware support for features like memory
> > encryption and storage of memory integrity checksums.  Not all memory
> > satisfies these requirements.
> > 
> > As a result, TDX introduced the concept of a "Convertible Memory Region"
> > (CMR).  During boot, the firmware builds a list of all of the memory
> > ranges which can provide the TDX security guarantees.  The list of these
> > ranges, along with TDX module information, is available to the kernel by
> > querying the TDX module via TDH.SYS.INFO SEAMCALL.
> > 
> > Host kernel can choose whether or not to use all convertible memory
> > regions as TDX memory.  Before TDX module is ready to create any TD
> > guests, all TDX memory regions that host kernel intends to use must be
> > configured to the TDX module, using specific data structures defined by
> > TDX architecture.  Constructing those structures requires information of
> > both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
> > to get this information as preparation to construct those structures.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> >  arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
> >  arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
> >  2 files changed, 192 insertions(+)
> > 
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index ef2718423f0f..482e6d858181 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
> >  
> >  static struct p_seamldr_info p_seamldr_info;
> >  
> > +/* Base address of CMR array needs to be 512 bytes aligned. */
> > +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> > +static int tdx_cmr_num;
> > +static struct tdsysinfo_struct tdx_sysinfo;
> 
> I really dislike mixing hardware and software structures.  Please make
> it clear which of these are fully software-defined and which are part of
> the hardware ABI.

Both 'struct tdsysinfo_struct' and 'struct cmr_info' are hardware structures. 
They are defined in tdx.h which has a comment saying the data structures below
this comment is hardware structures:

	+/*
	+ * TDX architectural data structures
	+ */

It is introduced in the P-SEAMLDR patch.

Should I explicitly add comments around the variables saying they are used by
hardware, something like:

	/*
	 * Data structures used by TDH.SYS.INFO SEAMCALL to return CMRs and
	 * TDX module system information.
	 */

?
 
> 
> >  static bool __seamrr_enabled(void)
> >  {
> >  	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> > @@ -468,6 +473,127 @@ static int tdx_module_init_cpus(void)
> >  	return seamcall_on_each_cpu(&sc);
> >  }
> >  
> > +static inline bool cmr_valid(struct cmr_info *cmr)
> > +{
> > +	return !!cmr->size;
> > +}
> > +
> > +static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
> > +		       const char *name)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < cmr_num; i++) {
> > +		struct cmr_info *cmr = &cmr_array[i];
> > +
> > +		pr_info("%s : [0x%llx, 0x%llx)\n", name,
> > +				cmr->base, cmr->base + cmr->size);
> > +	}
> > +}
> > +
> > +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> > +{
> > +	int i, j;
> > +
> > +	/*
> > +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> > +	 *
> > +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> > +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> > +	 *   lowest base address to the highest base address, and they
> > +	 *   are non-overlapping.
> > +	 *
> > +	 * This implies that BIOS may generate invalid empty entries
> > +	 * if total CMRs are less than 32.  Skip them manually.
> > +	 */
> > +	for (i = 0; i < cmr_num; i++) {
> > +		struct cmr_info *cmr = &cmr_array[i];
> > +		struct cmr_info *prev_cmr = NULL;
> > +
> > +		/* Skip further invalid CMRs */
> > +		if (!cmr_valid(cmr))
> > +			break;
> > +
> > +		if (i > 0)
> > +			prev_cmr = &cmr_array[i - 1];
> > +
> > +		/*
> > +		 * It is a TDX firmware bug if CMRs are not
> > +		 * in address ascending order.
> > +		 */
> > +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> > +					cmr->base)) {
> > +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> > +			return -EFAULT;
> 
> -EFAULT is a really weird return code to use for this.  I'd use -EINVAL.

OK thanks.

> 
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Also a sane BIOS should never generate invalid CMR(s) between
> > +	 * two valid CMRs.  Sanity check this and simply return error in
> > +	 * this case.
> > +	 *
> > +	 * By reaching here @i is the index of the first invalid CMR (or
> > +	 * cmr_num).  Starting with next entry of @i since it has already
> > +	 * been checked.
> > +	 */
> > +	for (j = i + 1; j < cmr_num; j++)
> > +		if (cmr_valid(&cmr_array[j])) {
> > +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> > +			return -EFAULT;
> > +		}
> 
> Please add brackets for the for().

OK.

> 
> > +	/*
> > +	 * Trim all tail invalid empty CMRs.  BIOS should generate at
> > +	 * least one valid CMR, otherwise it's a TDX firmware bug.
> > +	 */
> > +	tdx_cmr_num = i;
> > +	if (!tdx_cmr_num) {
> > +		pr_err("Firmware bug: No valid CMR.\n");
> > +		return -EFAULT;
> > +	}
> > +
> > +	/* Print kernel sanitized CMRs */
> > +	print_cmrs(tdx_cmr_array, tdx_cmr_num, "Kernel-sanitized-CMR");
> > +
> > +	return 0;
> > +}
> > +
> > +static int tdx_get_sysinfo(void)
> > +{
> > +	struct tdx_module_output out;
> > +	u64 tdsysinfo_sz, cmr_num;
> > +	int ret;
> > +
> > +	BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
> > +
> > +	ret = seamcall(TDH_SYS_INFO, __pa(&tdx_sysinfo), TDSYSINFO_STRUCT_SIZE,
> > +			__pa(tdx_cmr_array), MAX_CMRS, NULL, &out);
> > +	if (ret)
> > +		return ret;
> > +
> > +	/*
> > +	 * If TDH.SYS.CONFIG succeeds, RDX contains the actual bytes
> > +	 * written to @tdx_sysinfo and R9 contains the actual entries
> > +	 * written to @tdx_cmr_array.  Sanity check them.
> > +	 */
> > +	tdsysinfo_sz = out.rdx;
> > +	cmr_num = out.r9;
> 
> Please vertically align things like this:
> 
> 	tdsysinfo_sz = out.rdx;
> 	cmr_num	     = out.r9;

OK.

> 
> > +	if (WARN_ON_ONCE((tdsysinfo_sz > sizeof(tdx_sysinfo)) || !tdsysinfo_sz ||
> > +				(cmr_num > MAX_CMRS) || !cmr_num))
> > +		return -EFAULT;
> 
> Sanity checking is good, but this makes me wonder how much is too much.
>  I don't see a lot of code for instance checking if sys_write() writes
> more than how much it was supposed to.
> 
> Why are these sanity checks necessary here?  Is the TDX module expected
> to be *THAT* buggy?  The thing that's providing, oh, basically all of
> the security guarantees of this architecture.  It's overflowing the
> buffers you hand it?

I think this check can be removed.  Will remove.

> 
> > +	pr_info("TDX module: vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
> > +		tdx_sysinfo.vendor_id, tdx_sysinfo.major_version,
> > +		tdx_sysinfo.minor_version, tdx_sysinfo.build_date,
> > +		tdx_sysinfo.build_num);
> > +
> > +	/* Print BIOS provided CMRs */
> > +	print_cmrs(tdx_cmr_array, cmr_num, "BIOS-CMR");
> > +
> > +	return sanitize_cmrs(tdx_cmr_array, cmr_num);
> > +}
> 
> Does sanitize_cmrs() sanitize anything?  It looks to me like it *checks*
> the CMRs.  But, sanitizing is an active operation that writes to the
> data being sanitized.  This looks read-only to me.  check_cmrs() would
> be a better name for a passive check.

Sure will change to check_cmrs().

> 
> >  static int init_tdx_module(void)
> >  {
> >  	int ret;
> > @@ -482,6 +608,11 @@ static int init_tdx_module(void)
> >  	if (ret)
> >  		goto out;
> >  
> > +	/* Get TDX module information and CMRs */
> > +	ret = tdx_get_sysinfo();
> > +	if (ret)
> > +		goto out;
> 
> Couldn't we get rid of that comment if you did something like:
> 
> 	ret = tdx_get_sysinfo(&tdx_cmr_array, &tdx_sysinfo);

Yes will do.

> 
> and preferably make the variables function-local.

'tdx_sysinfo' will be used by KVM too.



-- 
Thanks,
-Kai


