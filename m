Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA755979C3
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbiHQWq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 18:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHQWq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 18:46:57 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B15273316
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 15:46:56 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-333a4a5d495so159651657b3.10
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 15:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VgB0IXyB8K/W7BILetTUFUv3mtFhSIsLEJGiw/WAcd0=;
        b=ZUxYSYE6iXRhjwq49l6y+SYLoAsvGQQAz9PRhYPCcgemVDkiv5Af4/0H2qlnikx6pW
         GIXbTYJp6TahUHSZeqvIIV5k/y34SrfuwH1rtNgvK0QdJog3qLbf/GczQCDodJgVqFas
         Rdz0kUIjB8bjUiDEegGaXbLc0b1tbGYq660nOzHWVL0G4IvQDyQQfDfUjPwM5JkCNVqO
         voFBypkZF9nyC37LCSqUOIz+Jxm1ZwFANtri0JFmtZgHFVdJ2HOGVfr+piYLJKOoRtDR
         rn8mu/v0RVppv8cROcBreZOJRgG58l2hqc9q0ZOrXIz2UgkLlEmbbs4GxYV775HxLu7d
         W/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VgB0IXyB8K/W7BILetTUFUv3mtFhSIsLEJGiw/WAcd0=;
        b=1KccaGw5Sm+6sy2KNOBE8/5BKWoJ6d1oSSp80ACYVjvsD5EaQgrAZ+v2As+0HEzU7o
         Ya7j/UjLo056179Wi4l1O0iKQdXwYiegajFNbfSntVHSkHV6LJd9NQtooD27uXT2h3WG
         Gwhf/Sgkcc4+uCSLTZ5TNW/nsXy0RXoq8xaNj9h1pQMD/1KAt+IH9C20aXz/hZiQPcpY
         3SdIkHZlaUNtJ3IM5q9g6EVSDCOWk9mhFRX6Tp4URjSrZ7HOo8gX1q5lJiNqJzGmr5Zj
         WNdWT5WPawC7qHVeDYf7Xy2qOfmFkb/ZISXN25nKm8tX8KbSvavs17vacjMC4n49BCAs
         UI5Q==
X-Gm-Message-State: ACgBeo1JwHMOC9rmgWrdAueUxLfEG7YpTu8lEQr4DxTwnrAiO6kXDZMX
        brJ7Er/FIQYy+Edcwp8fyeK3FfEzOU6oaq3cKP8/yQ==
X-Google-Smtp-Source: AA6agR4WrpkGtgxaX39MMYJ/IPxta3ZPmes7UZGPbM/EugBNKab75VylR9CL0geLgmtYDKoCF6vVGAidM0dBa6Ho2/M=
X-Received: by 2002:a05:6902:34b:b0:691:4b82:7624 with SMTP id
 e11-20020a056902034b00b006914b827624mr423096ybs.614.1660776415131; Wed, 17
 Aug 2022 15:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655894131.git.kai.huang@intel.com> <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
In-Reply-To: <c504a8acd06dc455050c25e2a4cc70aef5eb9358.1655894131.git.kai.huang@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Wed, 17 Aug 2022 15:46:44 -0700
Message-ID: <CAAhR5DEsB_88RukdkdbWxQz6=58b+AgQhGc9GRgvhMV3jq5TFg@mail.gmail.com>
Subject: Re: [PATCH v5 15/22] x86/virt/tdx: Allocate and set up PAMTs for TDMRs
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022 at 4:19 AM Kai Huang <kai.huang@intel.com> wrote:
>
> The TDX module uses additional metadata to record things like which
> guest "owns" a given page of memory.  This metadata, referred as
> Physical Address Metadata Table (PAMT), essentially serves as the
> 'struct page' for the TDX module.  PAMTs are not reserved by hardware
> up front.  They must be allocated by the kernel and then given to the
> TDX module.
>
> TDX supports 3 page sizes: 4K, 2M, and 1G.  Each "TD Memory Region"
> (TDMR) has 3 PAMTs to track the 3 supported page sizes.  Each PAMT must
> be a physically contiguous area from a Convertible Memory Region (CMR).
> However, the PAMTs which track pages in one TDMR do not need to reside
> within that TDMR but can be anywhere in CMRs.  If one PAMT overlaps with
> any TDMR, the overlapping part must be reported as a reserved area in
> that particular TDMR.
>
> Use alloc_contig_pages() since PAMT must be a physically contiguous area
> and it may be potentially large (~1/256th of the size of the given TDMR).
> The downside is alloc_contig_pages() may fail at runtime.  One (bad)
> mitigation is to launch a TD guest early during system boot to get those
> PAMTs allocated at early time, but the only way to fix is to add a boot
> option to allocate or reserve PAMTs during kernel boot.
>
> TDX only supports a limited number of reserved areas per TDMR to cover
> both PAMTs and memory holes within the given TDMR.  If many PAMTs are
> allocated within a single TDMR, the reserved areas may not be sufficient
> to cover all of them.
>
> Adopt the following policies when allocating PAMTs for a given TDMR:
>
>   - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
>     the total number of reserved areas consumed for PAMTs.
>   - Try to first allocate PAMT from the local node of the TDMR for better
>     NUMA locality.
>
> Also dump out how many pages are allocated for PAMTs when the TDX module
> is initialized successfully.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>
> - v3 -> v5 (no feedback on v4):
>  - Used memblock to get the NUMA node for given TDMR.
>  - Removed tdmr_get_pamt_sz() helper but use open-code instead.
>  - Changed to use 'switch .. case..' for each TDX supported page size in
>    tdmr_get_pamt_sz() (the original __tdmr_get_pamt_sz()).
>  - Added printing out memory used for PAMT allocation when TDX module is
>    initialized successfully.
>  - Explained downside of alloc_contig_pages() in changelog.
>  - Addressed other minor comments.
>
> ---
>  arch/x86/Kconfig            |   1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 200 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 201 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 4988a91d5283..ec496e96d120 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1973,6 +1973,7 @@ config INTEL_TDX_HOST
>         depends on CPU_SUP_INTEL
>         depends on X86_64
>         depends on KVM_INTEL
> +       depends on CONTIG_ALLOC
>         select ARCH_HAS_CC_PLATFORM
>         select ARCH_KEEP_MEMBLOCK
>         help
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fd9f449b5395..36260dd7e69f 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -558,6 +558,196 @@ static int create_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
>         return 0;
>  }
>
> +/* Page sizes supported by TDX */
> +enum tdx_page_sz {
> +       TDX_PG_4K,
> +       TDX_PG_2M,
> +       TDX_PG_1G,
> +       TDX_PG_MAX,
> +};
> +
> +/*
> + * Calculate PAMT size given a TDMR and a page size.  The returned
> + * PAMT size is always aligned up to 4K page boundary.
> + */
> +static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr,
> +                                     enum tdx_page_sz pgsz)
> +{
> +       unsigned long pamt_sz;
> +       int pamt_entry_nr;
            ^
This should be an 'unsigned long'. Otherwise you get an integer
overflow for large memory machines.

> +
> +       switch (pgsz) {
> +       case TDX_PG_4K:
> +               pamt_entry_nr = tdmr->size >> PAGE_SHIFT;
> +               break;
> +       case TDX_PG_2M:
> +               pamt_entry_nr = tdmr->size >> PMD_SHIFT;
> +               break;
> +       case TDX_PG_1G:
> +               pamt_entry_nr = tdmr->size >> PUD_SHIFT;
> +               break;
> +       default:
> +               WARN_ON_ONCE(1);
> +               return 0;
> +       }
> +
> +       pamt_sz = pamt_entry_nr * tdx_sysinfo.pamt_entry_size;
> +       /* TDX requires PAMT size must be 4K aligned */
> +       pamt_sz = ALIGN(pamt_sz, PAGE_SIZE);
> +
> +       return pamt_sz;
> +}
> +
> +/*
> + * Pick a NUMA node on which to allocate this TDMR's metadata.
> + *
> + * This is imprecise since TDMRs are 1G aligned and NUMA nodes might
> + * not be.  If the TDMR covers more than one node, just use the _first_
> + * one.  This can lead to small areas of off-node metadata for some
> + * memory.
> + */
> +static int tdmr_get_nid(struct tdmr_info *tdmr)
> +{
> +       unsigned long start_pfn, end_pfn;
> +       int i, nid;
> +
> +       /* Find the first memory region covered by the TDMR */
> +       memblock_for_each_tdx_mem_pfn_range(i, &start_pfn, &end_pfn, &nid) {
> +               if (end_pfn > (tdmr_start(tdmr) >> PAGE_SHIFT))
> +                       return nid;
> +       }
> +
> +       /*
> +        * No memory region found for this TDMR.  It cannot happen since
> +        * when one TDMR is created, it must cover at least one (or
> +        * partial) memory region.
> +        */
> +       WARN_ON_ONCE(1);
> +       return 0;
> +}
> +
> +static int tdmr_set_up_pamt(struct tdmr_info *tdmr)
> +{
> +       unsigned long pamt_base[TDX_PG_MAX];
> +       unsigned long pamt_size[TDX_PG_MAX];
> +       unsigned long tdmr_pamt_base;
> +       unsigned long tdmr_pamt_size;
> +       enum tdx_page_sz pgsz;
> +       struct page *pamt;
> +       int nid;
> +
> +       nid = tdmr_get_nid(tdmr);
> +
> +       /*
> +        * Calculate the PAMT size for each TDX supported page size
> +        * and the total PAMT size.
> +        */
> +       tdmr_pamt_size = 0;
> +       for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> +               pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz);
> +               tdmr_pamt_size += pamt_size[pgsz];
> +       }
> +
> +       /*
> +        * Allocate one chunk of physically contiguous memory for all
> +        * PAMTs.  This helps minimize the PAMT's use of reserved areas
> +        * in overlapped TDMRs.
> +        */
> +       pamt = alloc_contig_pages(tdmr_pamt_size >> PAGE_SHIFT, GFP_KERNEL,
> +                       nid, &node_online_map);
> +       if (!pamt)
> +               return -ENOMEM;
> +
> +       /* Calculate PAMT base and size for all supported page sizes. */
> +       tdmr_pamt_base = page_to_pfn(pamt) << PAGE_SHIFT;
> +       for (pgsz = TDX_PG_4K; pgsz < TDX_PG_MAX; pgsz++) {
> +               pamt_base[pgsz] = tdmr_pamt_base;
> +               tdmr_pamt_base += pamt_size[pgsz];
> +       }
> +
> +       tdmr->pamt_4k_base = pamt_base[TDX_PG_4K];
> +       tdmr->pamt_4k_size = pamt_size[TDX_PG_4K];
> +       tdmr->pamt_2m_base = pamt_base[TDX_PG_2M];
> +       tdmr->pamt_2m_size = pamt_size[TDX_PG_2M];
> +       tdmr->pamt_1g_base = pamt_base[TDX_PG_1G];
> +       tdmr->pamt_1g_size = pamt_size[TDX_PG_1G];
> +
> +       return 0;
> +}
> +
> +static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_pfn,
> +                         unsigned long *pamt_npages)
> +{
> +       unsigned long pamt_base, pamt_sz;
> +
> +       /*
> +        * The PAMT was allocated in one contiguous unit.  The 4K PAMT
> +        * should always point to the beginning of that allocation.
> +        */
> +       pamt_base = tdmr->pamt_4k_base;
> +       pamt_sz = tdmr->pamt_4k_size + tdmr->pamt_2m_size + tdmr->pamt_1g_size;
> +
> +       *pamt_pfn = pamt_base >> PAGE_SHIFT;
> +       *pamt_npages = pamt_sz >> PAGE_SHIFT;
> +}
> +
> +static void tdmr_free_pamt(struct tdmr_info *tdmr)
> +{
> +       unsigned long pamt_pfn, pamt_npages;
> +
> +       tdmr_get_pamt(tdmr, &pamt_pfn, &pamt_npages);
> +
> +       /* Do nothing if PAMT hasn't been allocated for this TDMR */
> +       if (!pamt_npages)
> +               return;
> +
> +       if (WARN_ON_ONCE(!pamt_pfn))
> +               return;
> +
> +       free_contig_range(pamt_pfn, pamt_npages);
> +}
> +
> +static void tdmrs_free_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
> +{
> +       int i;
> +
> +       for (i = 0; i < tdmr_num; i++)
> +               tdmr_free_pamt(tdmr_array_entry(tdmr_array, i));
> +}
> +
> +/* Allocate and set up PAMTs for all TDMRs */
> +static int tdmrs_set_up_pamt_all(struct tdmr_info *tdmr_array, int tdmr_num)
> +{
> +       int i, ret = 0;
> +
> +       for (i = 0; i < tdmr_num; i++) {
> +               ret = tdmr_set_up_pamt(tdmr_array_entry(tdmr_array, i));
> +               if (ret)
> +                       goto err;
> +       }
> +
> +       return 0;
> +err:
> +       tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> +       return ret;
> +}
> +
> +static unsigned long tdmrs_get_pamt_pages(struct tdmr_info *tdmr_array,
> +                                         int tdmr_num)
> +{
> +       unsigned long pamt_npages = 0;
> +       int i;
> +
> +       for (i = 0; i < tdmr_num; i++) {
> +               unsigned long pfn, npages;
> +
> +               tdmr_get_pamt(tdmr_array_entry(tdmr_array, i), &pfn, &npages);
> +               pamt_npages += npages;
> +       }
> +
> +       return pamt_npages;
> +}
> +
>  /*
>   * Construct an array of TDMRs to cover all memory regions in memblock.
>   * This makes sure all pages managed by the page allocator are TDX
> @@ -572,8 +762,13 @@ static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
>         if (ret)
>                 goto err;
>
> +       ret = tdmrs_set_up_pamt_all(tdmr_array, *tdmr_num);
> +       if (ret)
> +               goto err;
> +
>         /* Return -EINVAL until constructing TDMRs is done */
>         ret = -EINVAL;
> +       tdmrs_free_pamt_all(tdmr_array, *tdmr_num);
>  err:
>         return ret;
>  }
> @@ -644,6 +839,11 @@ static int init_tdx_module(void)
>          * process are done.
>          */
>         ret = -EINVAL;
> +       if (ret)
> +               tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> +       else
> +               pr_info("%lu pages allocated for PAMT.\n",
> +                               tdmrs_get_pamt_pages(tdmr_array, tdmr_num));
>  out_free_tdmrs:
>         /*
>          * The array of TDMRs is freed no matter the initialization is
> --
> 2.36.1
>
