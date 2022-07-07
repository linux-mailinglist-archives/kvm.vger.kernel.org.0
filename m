Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCFF569849
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 04:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbiGGCou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 22:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGGCot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 22:44:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67B62E6A6;
        Wed,  6 Jul 2022 19:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657161888; x=1688697888;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   content-transfer-encoding:mime-version:date;
  bh=Gb3nr30qWpCvqvwt/EmXMfqV47lb+zWrxN4Q99RWa5Q=;
  b=fQ+o2HVkYa6hF2IvUL9W7rnKdueBOU+lUXW00eWsWr6fxbHxQb9a8EOf
   7IMkSSJA0WOAIKGwYR8IagyYq4PcFBrP8JG7DFfXEoqgyWz8Tm6/X4JLf
   A4IgfiBTrTafFh5Z71v7CDiAPjec+5igD8UVROFjD1b7WIqp+BCeXImg4
   QL4N687BDQxdCUsR0yg2Kw0AM0y1+trcCmy4NHTQoiUJu6Vpf4Vf2XvBT
   kJyH1TRoWy6t8Y1X6mk9/jPAzilRmxJ5wliyqTCCg+pcEaYvNjI1Wa7RB
   Ask0AXxppIY6+RvWPN0KRzFI4JeY61PC15miO9LNQadfQ6wKfcX9tNuby
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="283939646"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="283939646"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 19:44:48 -0700
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="683153469"
Received: from toddpric-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.182.230])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 19:44:45 -0700
Message-ID: <202a463dd5443ccf2dc502e496e7d45ba5f05440.camel@intel.com>
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
In-Reply-To: <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
         <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Date:   Thu, 07 Jul 2022 14:37:46 +1200
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > +/*
> > > + * Walks over all memblock memory regions that are intended to be
> > > + * converted to TDX memory.  Essentially, it is all memblock memory
> > > + * regions excluding the low memory below 1MB.
> > > + *
> > > + * This is because on some TDX platforms the low memory below 1MB is
> > > + * not included in CMRs.  Excluding the low 1MB can still guarantee
> > > + * that the pages managed by the page allocator are always TDX memor=
y,
> > > + * as the low 1MB is reserved during kernel boot and won't end up to
> > > + * the ZONE_DMA (see reserve_real_mode()).
> > > + */
> > > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid=
)	\
> > > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> > > +		if (!pfn_range_skip_lowmem(p_start, p_end))
> >=20
> > Let's summarize where we are at this point:
> >=20
> > 1. All RAM is described in memblocks
> > 2. Some memblocks are reserved and some are free
> > 3. The lower 1MB is marked reserved
> > 4. for_each_mem_pfn_range() walks all reserved and free memblocks, so w=
e
> >    have to exclude the lower 1MB as a special case.
> >=20
> > That seems superficially rather ridiculous.  Shouldn't we just pick a
> > memblock iterator that skips the 1MB?  Surely there is such a thing.
>=20
> Perhaps you are suggesting we should always loop the _free_ ranges so we =
don't
> need to care about the first 1MB which is reserved?
>=20
> The problem is some reserved memory regions are actually later freed to t=
he page
> allocator, for example, initrd.  So to cover all those 'late-freed-reserv=
ed-
> regions', I used for_each_mem_pfn_range(), instead of for_each_free_mem_r=
ange().
>=20
> Btw, I do have a checkpatch warning around this code:
>=20
> ERROR: Macros with complex values should be enclosed in parentheses
> #109: FILE: arch/x86/virt/vmx/tdx/tdx.c:377:
> +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid)	\
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> +		if (!pfn_range_skip_lowmem(p_start, p_end))
>=20
> But it looks like a false positive to me.

Hi Dave,

Sorry to ping. Just double check, any comments around here, ..

>=20
> > Or, should we be doing something different with the 1MB in the memblock
> > structure?
>=20
> memblock APIs are used by other kernel components.  I don't think we shou=
ld
> modify memblock code behaviour for TDX.  Do you have any specific suggest=
ion?
>=20
> One possible option I can think is explicitly "register" memory regions a=
s TDX
> memory when they are firstly freed to the page allocator. =20

[...]

>=20
> This will require new data structures to represent TDX memblock and the c=
ode to
> create, insert and merge contiguous TDX memblocks, etc.  The advantage is=
 we can
> just iterate those TDX memblocks when constructing TDMRs.
>=20
>=20

And here?

