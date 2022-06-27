Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1987655D69A
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiF0GQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 02:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiF0GQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 02:16:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269FC2718;
        Sun, 26 Jun 2022 23:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656310585; x=1687846585;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cMiI0G5aQ0SJqftHpZ+jfjgcjPzZVHY+joSoF5nVFH8=;
  b=KP1Z/3hhw9Mgguffvw7kROFf8oRC/X+gauAeAovQr0zWK3B+8kHXzdxh
   GfFq7pYaa4KSR9aCNrqeTkx+GE8oXAv2OKo0EGtaU4vofcn7/HJDAa6fQ
   EZUZwBjJl6JD/xNs3i22SnWwTZV8xESySBG+a4WUtxC6jrA//g3FToqNx
   9ujAg3KJI26YP+ayMuz5I5/Wj+tPqR0FUWel9+nsv7nD3YJbshOPnh0Mn
   +BkLr+4NjPPX3/HQL+UiwmdGKid11gTQlTzODu145WO9+fbfK6LxiHZSL
   K4PdtiJ80U97LTl5oAKUdm8cResNb4fP4ykxuJpSj1ESm5srTWjCY4N8j
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="270111983"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="270111983"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 23:16:24 -0700
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="657545999"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2022 23:16:21 -0700
Message-ID: <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
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
Date:   Mon, 27 Jun 2022 18:16:19 +1200
In-Reply-To: <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 12:40 -0700, Dave Hansen wrote:
> On 6/22/22 04:17, Kai Huang wrote:
> ...
> > Also, explicitly exclude memory regions below first 1MB as TDX memory
> > because those regions may not be reported as convertible memory.  This
> > is OK as the first 1MB is always reserved during kernel boot and won't
> > end up to the page allocator.
>=20
> Are you sure?  I wasn't for a few minutes until I found reserve_real_mode=
()
>=20
> Could we point to that in this changelog, please?

OK will explicitly point out reserve_real_mode().

>=20
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index efa830853e98..4988a91d5283 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1974,6 +1974,7 @@ config INTEL_TDX_HOST
> >  	depends on X86_64
> >  	depends on KVM_INTEL
> >  	select ARCH_HAS_CC_PLATFORM
> > +	select ARCH_KEEP_MEMBLOCK
> >  	help
> >  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicio=
us
> >  	  host and certain physical attacks.  This option enables necessary T=
DX
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 1bc97756bc0d..2b20d4a7a62b 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -15,6 +15,8 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/smp.h>
> >  #include <linux/atomic.h>
> > +#include <linux/sizes.h>
> > +#include <linux/memblock.h>
> >  #include <asm/cpufeatures.h>
> >  #include <asm/cpufeature.h>
> >  #include <asm/msr-index.h>
> > @@ -338,6 +340,91 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct=
 *tdsysinfo,
> >  	return check_cmrs(cmr_array, actual_cmr_num);
> >  }
> > =20
> > +/*
> > + * Skip the memory region below 1MB.  Return true if the entire
> > + * region is skipped.  Otherwise, the updated range is returned.
> > + */
> > +static bool pfn_range_skip_lowmem(unsigned long *p_start_pfn,
> > +				  unsigned long *p_end_pfn)
> > +{
> > +	u64 start, end;
> > +
> > +	start =3D *p_start_pfn << PAGE_SHIFT;
> > +	end =3D *p_end_pfn << PAGE_SHIFT;
> > +
> > +	if (start < SZ_1M)
> > +		start =3D SZ_1M;
> > +
> > +	if (start >=3D end)
> > +		return true;
> > +
> > +	*p_start_pfn =3D (start >> PAGE_SHIFT);
> > +
> > +	return false;
> > +}
> > +
> > +/*
> > + * Walks over all memblock memory regions that are intended to be
> > + * converted to TDX memory.  Essentially, it is all memblock memory
> > + * regions excluding the low memory below 1MB.
> > + *
> > + * This is because on some TDX platforms the low memory below 1MB is
> > + * not included in CMRs.  Excluding the low 1MB can still guarantee
> > + * that the pages managed by the page allocator are always TDX memory,
> > + * as the low 1MB is reserved during kernel boot and won't end up to
> > + * the ZONE_DMA (see reserve_real_mode()).
> > + */
> > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	=
\
> > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> > +		if (!pfn_range_skip_lowmem(p_start, p_end))
>=20
> Let's summarize where we are at this point:
>=20
> 1. All RAM is described in memblocks
> 2. Some memblocks are reserved and some are free
> 3. The lower 1MB is marked reserved
> 4. for_each_mem_pfn_range() walks all reserved and free memblocks, so we
>    have to exclude the lower 1MB as a special case.
>=20
> That seems superficially rather ridiculous.  Shouldn't we just pick a
> memblock iterator that skips the 1MB?  Surely there is such a thing.

Perhaps you are suggesting we should always loop the _free_ ranges so we do=
n't
need to care about the first 1MB which is reserved?

The problem is some reserved memory regions are actually later freed to the=
 page
allocator, for example, initrd.  So to cover all those 'late-freed-reserved=
-
regions', I used for_each_mem_pfn_range(), instead of for_each_free_mem_ran=
ge().

Btw, I do have a checkpatch warning around this code:

ERROR: Macros with complex values should be enclosed in parentheses
#109: FILE: arch/x86/virt/vmx/tdx/tdx.c:377:
+#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
+	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
+		if (!pfn_range_skip_lowmem(p_start, p_end))

But it looks like a false positive to me.

> Or, should we be doing something different with the 1MB in the memblock
> structure?

memblock APIs are used by other kernel components.  I don't think we should
modify memblock code behaviour for TDX.  Do you have any specific suggestio=
n?

One possible option I can think is explicitly "register" memory regions as =
TDX
memory when they are firstly freed to the page allocator.  Those regions
includes:=C2=A0

1) memblock_free_all();

Where majority of the pages are freed to page allocator from memblock.

2) memblock_free_late();

Which covers regions freed to page allocator after 1).

3) free_init_pages();

Which is explicitly used for some reserved areas such as initrd and part of
kernel image.

This will require new data structures to represent TDX memblock and the cod=
e to
create, insert and merge contiguous TDX memblocks, etc.  The advantage is w=
e can
just iterate those TDX memblocks when constructing TDMRs.


--=20
Thanks,
-Kai


