Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E8256AF11
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 01:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiGGXex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 19:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbiGGXew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 19:34:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F772B619;
        Thu,  7 Jul 2022 16:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657236892; x=1688772892;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=JilDWVlu+XR9pm2fl+BnTL46v6CctvgFCzRvLBJzxJY=;
  b=RaiqanAAbKyb4EYISraC62Y2UhSUUF8hy0Dzrxgy642nRMyJzFn16Fx/
   G6NEM+uUWiz6Vx8LaAToTDHUCymBK3stch9KwKa1OzXC/dCg4TvgljK8x
   6xu8IszWipGMwJDLH0xGMsjYDeTW0O/5zHZRUpLtOF+pEW9VT7ejrzp97
   hdm639r9Odw8BFEBnfgJTNzEFFRU0JNE8cKWZV5cx9fzz6pNNsAcR5hHU
   epESZdBMhVCa9SJWJQ+suvJWm5vMPXIj6FRh5BZme4OU5ziYNBs6sZ5Nf
   nx9UTM3JqFraiT7nEci6jO9FT2hlfEEAmGMreNIAoWQYwLpkGC9WjNYH+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="370458757"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="370458757"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 16:34:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="568708757"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 16:34:48 -0700
Message-ID: <da423f82faec260150b158381a24300f3cd00ffa.camel@intel.com>
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
Date:   Fri, 08 Jul 2022 11:34:45 +1200
In-Reply-To: <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
         <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
         <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-07 at 07:26 -0700, Dave Hansen wrote:
> On 6/26/22 23:16, Kai Huang wrote:
> > On Fri, 2022-06-24 at 12:40 -0700, Dave Hansen wrote:
> > > > +/*
> > > > + * Walks over all memblock memory regions that are intended to be
> > > > + * converted to TDX memory.  Essentially, it is all memblock memor=
y
> > > > + * regions excluding the low memory below 1MB.
> > > > + *
> > > > + * This is because on some TDX platforms the low memory below 1MB =
is
> > > > + * not included in CMRs.  Excluding the low 1MB can still guarante=
e
> > > > + * that the pages managed by the page allocator are always TDX mem=
ory,
> > > > + * as the low 1MB is reserved during kernel boot and won't end up =
to
> > > > + * the ZONE_DMA (see reserve_real_mode()).
> > > > + */
> > > > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_n=
id)	\
> > > > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> > > > +		if (!pfn_range_skip_lowmem(p_start, p_end))
> > >=20
> > > Let's summarize where we are at this point:
> > >=20
> > > 1. All RAM is described in memblocks
> > > 2. Some memblocks are reserved and some are free
> > > 3. The lower 1MB is marked reserved
> > > 4. for_each_mem_pfn_range() walks all reserved and free memblocks, so=
 we
> > >    have to exclude the lower 1MB as a special case.
> > >=20
> > > That seems superficially rather ridiculous.  Shouldn't we just pick a
> > > memblock iterator that skips the 1MB?  Surely there is such a thing.
> >=20
> > Perhaps you are suggesting we should always loop the _free_ ranges so w=
e don't
> > need to care about the first 1MB which is reserved?
> >=20
> > The problem is some reserved memory regions are actually later freed to=
 the page
> > allocator, for example, initrd.  So to cover all those 'late-freed-rese=
rved-
> > regions', I used for_each_mem_pfn_range(), instead of for_each_free_mem=
_range().
>=20
> Why not just entirely remove the lower 1MB from the memblock structure
> on TDX systems?  Do something equivalent to adding this on the kernel
> command line:
>=20
> 	memmap=3D1M$0x0

I will explore this option.  Thanks!

>=20
> > Btw, I do have a checkpatch warning around this code:
> >=20
> > ERROR: Macros with complex values should be enclosed in parentheses
> > #109: FILE: arch/x86/virt/vmx/tdx/tdx.c:377:
> > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	=
\
> > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> > +		if (!pfn_range_skip_lowmem(p_start, p_end))
> >=20
> > But it looks like a false positive to me.
>=20
> I think it doesn't like the if().

Yes. I'll explore your suggestion above and I hope this can be avoided.


--=20
Thanks,
-Kai


