Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABE8512850
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 02:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbiD1A5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 20:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiD1A5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 20:57:02 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC6861289;
        Wed, 27 Apr 2022 17:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651107230; x=1682643230;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i3TMLMHB0n9Z70Mt4hmeDdDDnfVhrgTmKVl2zVzsyKM=;
  b=BIx5gkahMXqS9QKFaTyu7svp73txXkkmX51vEtuWCpbNpn6TSz4GL+dG
   WA+jfAbF3lUCE8Hld8Wba8XH0KX6RsgCHJrtlXqyB0aLioskt7Cw4jEiN
   IOaN9rXomRYM9PKKS8FEK+L3EiRSLciuCJc34+Lxu+mnR7XFzgQxWOuX7
   ciYpeOPzTZzn56Po0vrtVhyLh4XHSQfiJ7GL19AWa2AGNTTofFnVCZOor
   /L+AShkdQT62EbpvcP2omjKZIjpfcrKsErKzh3/6tuoN79jU+VriBFOKy
   t6ALPyfmn8jpMBi5KQ/rkFtBlOFzHYkk4XVal9ZzGXTrefGaX3pDZyb64
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="266279130"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="266279130"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:53:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="661484693"
Received: from rrnambia-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.60.78])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 17:53:47 -0700
Message-ID: <228cfa7e5326fa378c1dde2b5e9022146f97b706.camel@intel.com>
Subject: Re: [PATCH v3 10/21] x86/virt/tdx: Add placeholder to coveret all
 system RAM as TDX memory
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
Date:   Thu, 28 Apr 2022 12:53:45 +1200
In-Reply-To: <d69c08da-80fa-2001-bbe8-8c45552e74ae@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <6230ef28be8c360ab326c8f592acf1964ac065c1.1649219184.git.kai.huang@intel.com>
         <d69c08da-80fa-2001-bbe8-8c45552e74ae@intel.com>
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

On Wed, 2022-04-27 at 15:24 -0700, Dave Hansen wrote:
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
> > querying the TDX module.
> > 
> > In order to provide crypto protection to TD guests, the TDX architecture
> 
> There's that "crypto protection" thing again.  I'm not really a fan of
> the changes made to this changelog since I wrote it. :)

Sorry about that.  I'll remove "In order to provide crypto protection to TD
guests".

> 
> > also needs additional metadata to record things like which TD guest
> > "owns" a given page of memory.  This metadata essentially serves as the
> > 'struct page' for the TDX module.  The space for this metadata is not
> > reserved by the hardware upfront and must be allocated by the kernel
> 
> 			    ^ "up front"

Thanks will change to "up front".

Btw, the gmail grammar check gives me a red line if I use "up front", but it
doesn't complain "upfront".

> 
> ...
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 482e6d858181..ec27350d53c1 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/cpu.h>
> >  #include <linux/smp.h>
> >  #include <linux/atomic.h>
> > +#include <linux/slab.h>
> >  #include <asm/msr-index.h>
> >  #include <asm/msr.h>
> >  #include <asm/cpufeature.h>
> > @@ -594,8 +595,29 @@ static int tdx_get_sysinfo(void)
> >  	return sanitize_cmrs(tdx_cmr_array, cmr_num);
> >  }
> >  
> > +static void free_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < tdmr_num; i++) {
> > +		struct tdmr_info *tdmr = tdmr_array[i];
> > +
> > +		/* kfree() works with NULL */
> > +		kfree(tdmr);
> > +		tdmr_array[i] = NULL;
> > +	}
> > +}
> > +
> > +static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
> > +{
> > +	/* Return -EFAULT until constructing TDMRs is done */
> > +	return -EFAULT;
> > +}
> > +
> >  static int init_tdx_module(void)
> >  {
> > +	struct tdmr_info **tdmr_array;
> > +	int tdmr_num;
> >  	int ret;
> >  
> >  	/* TDX module global initialization */
> > @@ -613,11 +635,36 @@ static int init_tdx_module(void)
> >  	if (ret)
> >  		goto out;
> >  
> > +	/*
> > +	 * Prepare enough space to hold pointers of TDMRs (TDMR_INFO).
> > +	 * TDX requires TDMR_INFO being 512 aligned.  Each TDMR is
> 
> 					 ^ "512-byte aligned"
> 
> Right?

Yes.  Will update.

> 
> > +	 * allocated individually within construct_tdmrs() to meet
> > +	 * this requirement.
> > +	 */
> > +	tdmr_array = kcalloc(tdx_sysinfo.max_tdmrs, sizeof(struct tdmr_info *),
> > +			GFP_KERNEL);
> 
> Where, exactly is that alignment provided?  A 'struct tdmr_info *' is 8
> bytes so a tdx_sysinfo.max_tdmrs=8 kcalloc() would only guarantee
> 64-byte alignment.

The entries in the array only contain a pointer to TDMR_INFO.  The actual
TDMR_INFO is allocated separately. The array itself is never used by TDX
hardware so it doesn't matter.  We just need to guarantee each TDMR_INFO is
512B-byte aligned.

> 
> Also, I'm surprised that this is an array of virtual address pointers.
> The previous interactions with the TDX module seemed to all take
> physical addresses.  How is it that this hardware structure which has
> hardware alignment constraints is holding virtual addresses?

In later patches when TDMRs are configured to the TDX module, the input will be
converted to physical address, and there will be another array which is used by
the TDX module hardware.  This array is used to by kernel only to construct
TDMRs.

> 
> > +	if (!tdmr_array) {
> > +		ret = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	/* Construct TDMRs to build TDX memory */
> > +	ret = construct_tdmrs(tdmr_array, &tdmr_num);
> > +	if (ret)
> > +		goto out_free_tdmrs;
> > +
> >  	/*
> >  	 * Return -EFAULT until all steps of TDX module
> >  	 * initialization are done.
> >  	 */
> >  	ret = -EFAULT;
> 
> There's the -EFAULT again.  I'd replace these with a better error code.

I couldn't think out a better error code.  -EINVAL looks doesn't suit.  -EAGAIN
also doesn't make sense for now since we always shutdown the TDX module in case
of any error so caller should never retry.  I think we need some error code to
tell "the job isn't done yet".  Perhaps -EBUSY?



-- 
Thanks,
-Kai


