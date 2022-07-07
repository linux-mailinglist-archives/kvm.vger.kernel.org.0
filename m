Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24D356AF1B
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 01:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiGGXmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 19:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236588AbiGGXmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 19:42:06 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BD660694;
        Thu,  7 Jul 2022 16:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657237326; x=1688773326;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1oAFq84mWfA/CQ19Wsv/7u5AVCUkDw9Y1yFTUvUAZEI=;
  b=ea2sOUBVQ4sHWTdsup0S+i6X6Se4NXivjFxBIru4hw1O4h5eEWBS4ueh
   Toz3NrlVdiSfTOELm+ci+UFyr7H5qtsnyDGTe8NJAqeeJFwPqLLwDAJeA
   6yS4mBscWLOGa6B9lJojb0DbOoGOvoYVpBl0NIy0a4LRbcBU5ysLLa6Ha
   X5fjWdf41MaVXMWuJN1RFEEKFfLi7OWSBEOEaPjXbl6j1fNpBpXW1Luuz
   20W/EhUsCEIHGRZibchiZM/Hu8LfHXrtt+VpyiCGDwA3CTeAJMeLZUhOV
   zblYNB/N6rwdoX7a1/VWF7Hqf1eia8Xf285juqvBLJwna6w0FWz6kISl/
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="284886970"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="284886970"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 16:42:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="920786491"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 16:42:02 -0700
Message-ID: <700b6dc7e8f038b9f8f3fc07bee89109e3f329de.camel@intel.com>
Subject: Re: [PATCH v5 12/22] x86/virt/tdx: Convert all memory regions in
 memblock to TDX memory
From:   Kai Huang <kai.huang@intel.com>
To:     Juergen Gross <jgross@suse.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Fri, 08 Jul 2022 11:42:00 +1200
In-Reply-To: <d262b7dd-d7eb-0251-e3c7-0bb0a626749d@suse.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <8288396be7fedd10521a28531e138579594d757a.1655894131.git.kai.huang@intel.com>
         <20d63398-928f-0c6f-47ec-8e225c049ad8@intel.com>
         <76d7604ff21b26252733165478d5c54035d84d98.camel@intel.com>
         <880f3991-09e5-2f96-d5ba-213cff05c458@intel.com>
         <d262b7dd-d7eb-0251-e3c7-0bb0a626749d@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-07 at 16:36 +0200, Juergen Gross wrote:
> On 07.07.22 16:26, Dave Hansen wrote:
> > On 6/26/22 23:16, Kai Huang wrote:
> > > On Fri, 2022-06-24 at 12:40 -0700, Dave Hansen wrote:
> > > > > +/*
> > > > > + * Walks over all memblock memory regions that are intended to b=
e
> > > > > + * converted to TDX memory.  Essentially, it is all memblock mem=
ory
> > > > > + * regions excluding the low memory below 1MB.
> > > > > + *
> > > > > + * This is because on some TDX platforms the low memory below 1M=
B is
> > > > > + * not included in CMRs.  Excluding the low 1MB can still guaran=
tee
> > > > > + * that the pages managed by the page allocator are always TDX m=
emory,
> > > > > + * as the low 1MB is reserved during kernel boot and won't end u=
p to
> > > > > + * the ZONE_DMA (see reserve_real_mode()).
> > > > > + */
> > > > > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p=
_nid)	\
> > > > > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	=
\
> > > > > +		if (!pfn_range_skip_lowmem(p_start, p_end))
> > > >=20
> > > > Let's summarize where we are at this point:
> > > >=20
> > > > 1. All RAM is described in memblocks
> > > > 2. Some memblocks are reserved and some are free
> > > > 3. The lower 1MB is marked reserved
> > > > 4. for_each_mem_pfn_range() walks all reserved and free memblocks, =
so we
> > > >     have to exclude the lower 1MB as a special case.
> > > >=20
> > > > That seems superficially rather ridiculous.  Shouldn't we just pick=
 a
> > > > memblock iterator that skips the 1MB?  Surely there is such a thing=
.
> > >=20
> > > Perhaps you are suggesting we should always loop the _free_ ranges so=
 we don't
> > > need to care about the first 1MB which is reserved?
> > >=20
> > > The problem is some reserved memory regions are actually later freed =
to the page
> > > allocator, for example, initrd.  So to cover all those 'late-freed-re=
served-
> > > regions', I used for_each_mem_pfn_range(), instead of for_each_free_m=
em_range().
> >=20
> > Why not just entirely remove the lower 1MB from the memblock structure
> > on TDX systems?  Do something equivalent to adding this on the kernel
> > command line:
> >=20
> > 	memmap=3D1M$0x0
> >=20
> > > Btw, I do have a checkpatch warning around this code:
> > >=20
> > > ERROR: Macros with complex values should be enclosed in parentheses
> > > #109: FILE: arch/x86/virt/vmx/tdx/tdx.c:377:
> > > +#define memblock_for_each_tdx_mem_pfn_range(i, p_start, p_end, p_nid=
)	\
> > > +	for_each_mem_pfn_range(i, MAX_NUMNODES, p_start, p_end, p_nid)	\
> > > +		if (!pfn_range_skip_lowmem(p_start, p_end))
> > >=20
> > > But it looks like a false positive to me.
> >=20
> > I think it doesn't like the if().
>=20
> I think it is right.
>=20
> Consider:
>=20
> if (a)
>      memblock_for_each_tdx_mem_pfn_range(...)
>          func();
> else
>      other_func();
>=20
>=20
>=20
Interesting case.  Thanks.

Yes we will require explicit { } around memblock_for_each_tdx_mem_pfn_range=
() in
this case.

--=20
Thanks,
-Kai


