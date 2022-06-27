Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765BB55CF26
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiF0Kbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 06:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiF0Kbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 06:31:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4A6163;
        Mon, 27 Jun 2022 03:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656325902; x=1687861902;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=eDm1C43BNjodQTqk/kM+BPvE/Kk0mTDyJMEPDHe3erY=;
  b=HG16Is1GQUz5533LMbWWwCQdgEmae6XGJ8Q/mTgt8g+LeE7+imNq7rt0
   fTo747vQZ6XdRSeLCanmtni4LRbkFq0wEm61QTM8ku7bb4k6uJMxXG5Vw
   Zqns9ayi52J/ofKFzmETs3Zfn3LFZvSBnW3H4SRLWprsYi+UpY4gmDOyh
   q1mNP4AnQtyv/1PlGnbcC44CyU2cJ6htmsACjz+qgBLdhbxxgmOdj6UFO
   ATtk631WY+zA1sWghBBLGNKaAZH7M6h7gR4UmJ61oEdMsX9zAbZvMRxmr
   6TH2zbsJj5rDwpzmk0IYSxtzNhgOPAkST5nhdHTw3wt9k85JeUP5s3gxM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="264462451"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="264462451"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 03:31:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="616744674"
Received: from fzaeni-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.88.6])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 03:31:38 -0700
Message-ID: <b376aef05bc032fdf8cc23762ce77a14830440cd.camel@intel.com>
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
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
Date:   Mon, 27 Jun 2022 22:31:36 +1200
In-Reply-To: <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
         <e72703b0-767a-ec88-7cb6-f95a3564d823@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 13:13 -0700, Dave Hansen wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 4988a91d5283..ec496e96d120 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
> > =C2=A0	depends on CPU_SUP_INTEL
> > =C2=A0	depends on X86_64
> > =C2=A0	depends on KVM_INTEL
> > +	depends on CONTIG_ALLOC
> > =C2=A0	select ARCH_HAS_CC_PLATFORM
> > =C2=A0	select ARCH_KEEP_MEMBLOCK
> > =C2=A0	help
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index fd9f449b5395..36260dd7e69f 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -558,6 +558,196 @@ static int create_tdmrs(struct tdmr_info *tdmr_ar=
ray,
> > int *tdmr_num)
> > =C2=A0	return 0;
> > =C2=A0}
> > =C2=A0
> > +/* Page sizes supported by TDX */
> > +enum tdx_page_sz {
> > +	TDX_PG_4K,
> > +	TDX_PG_2M,
> > +	TDX_PG_1G,
> > +	TDX_PG_MAX,
> > +};
>=20
> Are these the same constants as the magic numbers in Kirill's
> try_accept_one()?

try_accept_once() uses 'enum pg_level' PG_LEVEL_{4K,2M,1G} directly.  They =
can
be used directly too, but 'enum pg_level' has more than we need here:

enum pg_level {
        PG_LEVEL_NONE,                                                     =
   =20
        PG_LEVEL_4K,                                                       =
   =20
        PG_LEVEL_2M,                                                       =
   =20
        PG_LEVEL_1G,
        PG_LEVEL_512G,                                                     =
   =20
        PG_LEVEL_NUM                                                       =
   =20
};=20

It has PG_LEVEL_NONE, so PG_LEVEL_4K starts with 1.

Below in tdmr_set_up_pamt(), I have two local arrays to store the base/size=
 for
all TDX supported page sizes:

	unsigned long pamt_base[TDX_PG_MAX];
	unsigned long pamt_size[TDX_PG_MAX];=20

And a loop to calculate the size of PAMT for each page size:

	for (pgsz =3D TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
		pamt_size[pgsz] =3D tdmr_get_pamt_sz(tdmr, pgsz);
		...
	}

And later a similar loop to get the PAMT base of each page size too.

I can change them to:

	/*
	 * TDX only supports 4K, 2M and 1G page, but doesn't
	 * support 512G page size.
	 */
#define TDX_PG_LEVEL_MAX	PG_LEVEL_512G

	unsigned long pamt_base[TDX_PG_LEVEL_MAX];
	unsigned long pamt_size[TDX_PG_LEVEL_MAX];

And change the loop to:

	for (pgsz =3D PG_LEVEL_4K; pgsz < TDX_PG_LEVEL_MAX; pgsz++) {
		pamt_size[pgsz] =3D tdmr_get_pamt_sz(tdmr, pgsz);
		...
	}

This would waste one 'unsigned long' for both pamt_base and pamt_size array=
, as
entry 0 isn't used for both of them.  Or we explicitly -1 array index:

	for (pgsz =3D PG_LEVEL_4K; pgsz < TDX_PG_LEVEL_MAX; pgsz++) {
		pamt_size[pgsz - 1] =3D tdmr_get_pamt_sz(tdmr, pgsz);
		...
	}

What's your opinion?=20

> > +/*
> > + * Calculate PAMT size given a TDMR and a page size.  The returned
> > + * PAMT size is always aligned up to 4K page boundary.
> > + */
> > +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr,
> > +				      enum tdx_page_sz pgsz)
> > +{
> > +	unsigned long pamt_sz;
> > +	int pamt_entry_nr;
>=20
> 'nr_pamt_entries', please.

OK.

>=20
> > +	switch (pgsz) {
> > +	case TDX_PG_4K:
> > +		pamt_entry_nr =3D tdmr->size >> PAGE_SHIFT;
> > +		break;
> > +	case TDX_PG_2M:
> > +		pamt_entry_nr =3D tdmr->size >> PMD_SHIFT;
> > +		break;
> > +	case TDX_PG_1G:
> > +		pamt_entry_nr =3D tdmr->size >> PUD_SHIFT;
> > +		break;
> > +	default:
> > +		WARN_ON_ONCE(1);
> > +		return 0;
> > +	}
> > +
> > +	pamt_sz =3D pamt_entry_nr * tdx_sysinfo.pamt_entry_size;
> > +	/* TDX requires PAMT size must be 4K aligned */
> > +	pamt_sz =3D ALIGN(pamt_sz, PAGE_SIZE);
> > +
> > +	return pamt_sz;
> > +}
> > +
> > +/*
> > + * Pick a NUMA node on which to allocate this TDMR's metadata.
> > + *
> > + * This is imprecise since TDMRs are 1G aligned and NUMA nodes might
> > + * not be.  If the TDMR covers more than one node, just use the _first=
_
> > + * one.  This can lead to small areas of off-node metadata for some
> > + * memory.
> > + */
> > +static int tdmr_get_nid(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long start_pfn, end_pfn;
> > +	int i, nid;
> > +
> > +	/* Find the first memory region covered by the TDMR */
> > +	memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, &nid)
> > {
> > +		if (end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
> > +			return nid;
> > +	}
> > +
> > +	/*
> > +	 * No memory region found for this TDMR.  It cannot happen since
> > +	 * when one TDMR is created, it must cover at least one (or
> > +	 * partial) memory region.
> > +	 */
> > +	WARN_ON_ONCE(1);
> > +	return 0;
> > +}
>=20
> You should really describe what you are doing.  At first glance "return
> 0;" looks like "declare success".  How about something like this?
>=20
> 	/*
> 	 * Fall back to allocating the TDMR from node 0 when no memblock
> 	 * can be found.  This should never happen since TDMRs originate
> 	 * from the memblocks.
> 	 */
>=20
> Does that miss any of the points you were trying to make?

No. Your comments looks better and will use yours.  Thanks.

>=20
> > +static int tdmr_set_up_pamt(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long pamt_base[TDX_PG_MAX];
> > +	unsigned long pamt_size[TDX_PG_MAX];
> > +	unsigned long tdmr_pamt_base;
> > +	unsigned long tdmr_pamt_size;
> > +	enum tdx_page_sz pgsz;
> > +	struct page *pamt;
> > +	int nid;
> > +
> > +	nid =3D tdmr_get_nid(tdmr);
> > +
> > +	/*
> > +	 * Calculate the PAMT size for each TDX supported page size
> > +	 * and the total PAMT size.
> > +	 */
> > +	tdmr_pamt_size =3D 0;
> > +	for (pgsz =3D TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> > +		pamt_size[pgsz] =3D tdmr_get_pamt_sz(tdmr, pgsz);
> > +		tdmr_pamt_size +=3D pamt_size[pgsz];
> > +	}
> > +
> > +	/*
> > +	 * Allocate one chunk of physically contiguous memory for all
> > +	 * PAMTs.  This helps minimize the PAMT's use of reserved areas
> > +	 * in overlapped TDMRs.
> > +	 */
> > +	pamt =3D alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
> > +			nid, &node_online_map);
> > +	if (!pamt)
> > +		return -ENOMEM;
>=20
> I'm not sure it's worth mentioning, but this doesn't really need to be
> GFP_KERNEL.  __GFP_HIGHMEM would actually be just fine.  But,
> considering that this is 64-bit only, that's just a technicality.



>=20
> > +	/* Calculate PAMT base and size for all supported page sizes. */
>=20
> That comment isn't doing much good.  If you say anything here it should b=
e:
>=20
> 	/*
> 	 * Break the contiguous allocation back up into
> 	 * the individual PAMTs for each page size:
> 	 */
>=20
> Also, this is *not* "calculating size".  That's done above.

Thanks will use this comment.

>=20
> > +	tdmr_pamt_base =3D page_to_pfn(pamt) << PAGE_SHIFT;
> > +	for (pgsz =3D TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> > +		pamt_base[pgsz] =3D tdmr_pamt_base;
> > +		tdmr_pamt_base +=3D pamt_size[pgsz];
> > +	}
> > +
> > +	tdmr->pamt_4k_base =3D pamt_base[TDX_PG_4K];
> > +	tdmr->pamt_4k_size =3D pamt_size[TDX_PG_4K];
> > +	tdmr->pamt_2m_base =3D pamt_base[TDX_PG_2M];
> > +	tdmr->pamt_2m_size =3D pamt_size[TDX_PG_2M];
> > +	tdmr->pamt_1g_base =3D pamt_base[TDX_PG_1G];
> > +	tdmr->pamt_1g_size =3D pamt_size[TDX_PG_1G];
> > +
> > +	return 0;
> > +}
> >=20
> > +static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_=
pfn,
> > +			  unsigned long *pamt_npages)
> > +{
> > +	unsigned long pamt_base, pamt_sz;
> > +
> > +	/*
> > +	 * The PAMT was allocated in one contiguous unit.  The 4K PAMT
> > +	 * should always point to the beginning of that allocation.
> > +	 */
> > +	pamt_base =3D tdmr->pamt_4k_base;
> > +	pamt_sz =3D tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr-
> > >pamt_1g_size;
> > +
> > +	*pamt_pfn =3D pamt_base >> PAGE_SHIFT;
> > +	*pamt_npages =3D pamt_sz >> PAGE_SHIFT;
> > +}
> > +
> > +static void tdmr_free_pamt(struct tdmr_info *tdmr)
> > +{
> > +	unsigned long pamt_pfn, pamt_npages;
> > +
> > +	tdmr_get_pamt(tdmr, &pamt_pfn, &pamt_npages);
> > +
> > +	/* Do nothing if PAMT hasn't been allocated for this TDMR */
> > +	if (!pamt_npages)
> > +		return;
> > +
> > +	if (WARN_ON_ONCE(!pamt_pfn))
> > +		return;
> > +
> > +	free_contig_range(pamt_pfn, pamt_npages);
> > +}
> > +
> > +static void tdmrs_free_pamt_all(struct tdmr_info *tdmr_array, int tdmr=
_num)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < tdmr_num; i++)
> > +		tdmr_free_pamt(tdmr_array_entry(tdmr_array, i));
> > +}
> > +
> > +/* Allocate and set up PAMTs for all TDMRs */
> > +static int tdmrs_set_up_pamt_all(struct tdmr_info *tdmr_array, int
> > tdmr_num)
> > +{
> > +	int i, ret =3D 0;
> > +
> > +	for (i =3D 0; i < tdmr_num; i++) {
> > +		ret =3D tdmr_set_up_pamt(tdmr_array_entry(tdmr_array, i));
> > +		if (ret)
> > +			goto err;
> > +	}
> > +
> > +	return 0;
> > +err:
> > +	tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> > +	return ret;
> > +}
> > +
> > +static unsigned long tdmrs_get_pamt_pages(struct tdmr_info *tdmr_array=
,
> > +					  int tdmr_num)
>=20
> "get" is for refcounting.  tdmrs_count_pamt_pages() would be preferable.

Will use count.  Thanks.

>=20
> > +{
> > +	unsigned long pamt_npages =3D 0;
> > +	int i;
> > +
> > +	for (i =3D 0; i < tdmr_num; i++) {
> > +		unsigned long pfn, npages;
> > +
> > +		tdmr_get_pamt(tdmr_array_entry(tdmr_array, i), &pfn,
> > &npages);
> > +		pamt_npages +=3D npages;
> > +	}
> > +
> > +	return pamt_npages;
> > +}
> > +
> > =C2=A0/*
> > =C2=A0=C2=A0* Construct an array of TDMRs to cover all memory regions i=
n memblock.
> > =C2=A0=C2=A0* This makes sure all pages managed by the page allocator a=
re TDX
> > @@ -572,8 +762,13 @@ static int construct_tdmrs_memeblock(struct tdmr_i=
nfo
> > *tdmr_array,
> > =C2=A0	if (ret)
> > =C2=A0		goto err;
> > =C2=A0
> > +	ret =3D tdmrs_set_up_pamt_all(tdmr_array, *tdmr_num);
> > +	if (ret)
> > +		goto err;
> > +
> > =C2=A0	/* Return -EINVAL until constructing TDMRs is done */
> > =C2=A0	ret =3D -EINVAL;
> > +	tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
> > =C2=A0err:
> > =C2=A0	return ret;
> > =C2=A0}
> > @@ -644,6 +839,11 @@ static int init_tdx_module(void)
> > =C2=A0	 * process are done.
> > =C2=A0	 */
> > =C2=A0	ret =3D -EINVAL;
> > +	if (ret)
> > +		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> > +	else
> > +		pr_info("%lu pages allocated for PAMT.\n",
> > +				tdmrs_get_pamt_pages(tdmr_array,
> > tdmr_num));
> > =C2=A0out_free_tdmrs:
> > =C2=A0	/*
> > =C2=A0	 * The array of TDMRs is freed no matter the initialization is
>=20
> The rest looks OK.

Thanks.

--=20
Thanks,
-Kai


