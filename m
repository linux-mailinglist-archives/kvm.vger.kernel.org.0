Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3133374ED18
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 13:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjGKLnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 07:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjGKLnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 07:43:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801DB11D
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 04:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689075735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TVNlN8Fu7HKmMU86W9Jarak9bhN5uqIsTvRRP5Jak7k=;
        b=KCqyOyuInjXCSkaL4exPNgn7PQOZypf/+FHH7G2zdBGhg7OKMBk1DDZ6odFtaQu9yDHQmj
        DgZptEP7c5WkImYHMbW4/bAhdFHCD7jr/jXcsmlVi2x/aNsiaC5UFlRGcoh6vnSCKzMi0d
        4rD9VSLgA26BPfc5rY/EzQ9iK5wMT8w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-5Uj4JuEsMYmP22yOatKKbg-1; Tue, 11 Jul 2023 07:42:14 -0400
X-MC-Unique: 5Uj4JuEsMYmP22yOatKKbg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30932d15a30so3468388f8f.1
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 04:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689075733; x=1691667733;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TVNlN8Fu7HKmMU86W9Jarak9bhN5uqIsTvRRP5Jak7k=;
        b=Zwu5IX7UHVKSuwpQ3wsn6SxoffIzbbbNB00uThqHRF2ZQlENreD6p3gjqqimJIdVce
         ZXav8rvg7XrSc3uMRa6BDtkd7TF5xj12P9WanB4A9SzWWTKQm69uihlJUfeQpC39LuAr
         XBWlBMB+cMZnL5kU2WY1+/6FVYrBfWdFFsDOsVJTWM63/l+0qu9WcYGSt/LHhcpdWem+
         Encvr8c9pWvYtdO7Ob0cq0yVYQLqW14FvNiT5ToLqglb2IDk7Z8eGL3zX9JMptIyuo9z
         uGPH6Kp57bmTEBBBJ3S023HvNALHFkw5bhF46XcUQG3TTHu3+UWU5+cLwgN7Z+m3CZTa
         tO+A==
X-Gm-Message-State: ABy/qLY+ZCUGypmtuwegz+p4PjDwecckOZiZsd5xbuGREWetePi4nt31
        qF8GVxpnwpcBC6mOo+jt04RYzcs2q8H6VwvBOu8M7o2dlBBTD/v325iEkWq6fDITbMPkVyKGL4T
        a3fighRa66Fyk
X-Received: by 2002:a05:6000:370:b0:313:f9a0:c530 with SMTP id f16-20020a056000037000b00313f9a0c530mr16858072wrf.52.1689075733282;
        Tue, 11 Jul 2023 04:42:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG930FaW9+FN5ODUew7AowqA5AQd10iiEj46Z4R/Iy1KQe+FGD8mJ1gLZStu1NIkLAOOBxXqA==
X-Received: by 2002:a05:6000:370:b0:313:f9a0:c530 with SMTP id f16-20020a056000037000b00313f9a0c530mr16858053wrf.52.1689075732814;
        Tue, 11 Jul 2023 04:42:12 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:4000:13ad:ed64:37e6:115d? (p200300cbc745400013aded6437e6115d.dip0.t-ipconnect.de. [2003:cb:c745:4000:13ad:ed64:37e6:115d])
        by smtp.gmail.com with ESMTPSA id s15-20020adff80f000000b00313f9a0c521sm2045310wrp.107.2023.07.11.04.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 04:42:12 -0700 (PDT)
Message-ID: <68a8cba5-55b6-4c8a-f4e6-d528fc839285@redhat.com>
Date:   Tue, 11 Jul 2023 13:42:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1687784645.git.kai.huang@intel.com>
 <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.06.23 16:12, Kai Huang wrote:
> The TDX module uses additional metadata to record things like which
> guest "owns" a given page of memory.  This metadata, referred as
> Physical Address Metadata Table (PAMT), essentially serves as the
> 'struct page' for the TDX module.  PAMTs are not reserved by hardware
> up front.  They must be allocated by the kernel and then given to the
> TDX module during module initialization.
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
> mitigation is to launch a TDX guest early during system boot to get
> those PAMTs allocated at early time, but the only way to fix is to add a
> boot option to allocate or reserve PAMTs during kernel boot.
> 
> It is imperfect but will be improved on later.
> 
> TDX only supports a limited number of reserved areas per TDMR to cover
> both PAMTs and memory holes within the given TDMR.  If many PAMTs are
> allocated within a single TDMR, the reserved areas may not be sufficient
> to cover all of them.
> 
> Adopt the following policies when allocating PAMTs for a given TDMR:
> 
>    - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
>      the total number of reserved areas consumed for PAMTs.
>    - Try to first allocate PAMT from the local node of the TDMR for better
>      NUMA locality.
> 
> Also dump out how many pages are allocated for PAMTs when the TDX module
> is initialized successfully.  This helps answer the eternal "where did
> all my memory go?" questions.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
> v11 -> v12:
>   - Moved TDX_PS_NUM from tdx.c to <asm/tdx.h> (Kirill)
>   - "<= TDX_PS_1G" -> "< TDX_PS_NUM" (Kirill)
>   - Changed tdmr_get_pamt() to return base and size instead of base_pfn
>     and npages and related code directly (Dave).
>   - Simplified PAMT kb counting. (Dave)
>   - tdmrs_count_pamt_pages() -> tdmr_count_pamt_kb() (Kirill/Dave)
> 
> v10 -> v11:
>   - No update
> 
> v9 -> v10:
>   - Removed code change in disable_tdx_module() as it doesn't exist
>     anymore.
> 
> v8 -> v9:
>   - Added TDX_PS_NR macro instead of open-coding (Dave).
>   - Better alignment of 'pamt_entry_size' in tdmr_set_up_pamt() (Dave).
>   - Changed to print out PAMTs in "KBs" instead of "pages" (Dave).
>   - Added Dave's Reviewed-by.
> 
> v7 -> v8: (Dave)
>   - Changelog:
>    - Added a sentence to state PAMT allocation will be improved.
>    - Others suggested by Dave.
>   - Moved 'nid' of 'struct tdx_memblock' to this patch.
>   - Improved comments around tdmr_get_nid().
>   - WARN_ON_ONCE() -> pr_warn() in tdmr_get_nid().
>   - Other changes due to 'struct tdmr_info_list'.
> 
> v6 -> v7:
>   - Changes due to using macros instead of 'enum' for TDX supported page
>     sizes.
> 
> v5 -> v6:
>   - Rebase due to using 'tdx_memblock' instead of memblock.
>   - 'int pamt_entry_nr' -> 'unsigned long nr_pamt_entries' (Dave/Sagis).
>   - Improved comment around tdmr_get_nid() (Dave).
>   - Improved comment in tdmr_set_up_pamt() around breaking the PAMT
>     into PAMTs for 4K/2M/1G (Dave).
>   - tdmrs_get_pamt_pages() -> tdmrs_count_pamt_pages() (Dave).
> 
> - v3 -> v5 (no feedback on v4):
>   - Used memblock to get the NUMA node for given TDMR.
>   - Removed tdmr_get_pamt_sz() helper but use open-code instead.
>   - Changed to use 'switch .. case..' for each TDX supported page size in
>     tdmr_get_pamt_sz() (the original __tdmr_get_pamt_sz()).
>   - Added printing out memory used for PAMT allocation when TDX module is
>     initialized successfully.
>   - Explained downside of alloc_contig_pages() in changelog.
>   - Addressed other minor comments.
> 
> 
> ---
>   arch/x86/Kconfig            |   1 +
>   arch/x86/include/asm/tdx.h  |   1 +
>   arch/x86/virt/vmx/tdx/tdx.c | 215 +++++++++++++++++++++++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h |   1 +
>   4 files changed, 213 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 2226d8a4c749..ad364f01de33 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1959,6 +1959,7 @@ config INTEL_TDX_HOST
>   	depends on KVM_INTEL
>   	depends on X86_X2APIC
>   	select ARCH_KEEP_MEMBLOCK
> +	depends on CONTIG_ALLOC
>   	help
>   	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>   	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index d8226a50c58c..91416fd600cd 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -24,6 +24,7 @@
>   #define TDX_PS_4K	0
>   #define TDX_PS_2M	1
>   #define TDX_PS_1G	2
> +#define TDX_PS_NR	(TDX_PS_1G + 1)
>   
>   /*
>    * Used to gather the output registers values of the TDCALL and SEAMCALL
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 2ffc1517a93b..fd5417577f26 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -221,7 +221,7 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
>    * overlap.
>    */
>   static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
> -			    unsigned long end_pfn)
> +			    unsigned long end_pfn, int nid)
>   {
>   	struct tdx_memblock *tmb;
>   
> @@ -232,6 +232,7 @@ static int add_tdx_memblock(struct list_head *tmb_list, unsigned long start_pfn,
>   	INIT_LIST_HEAD(&tmb->list);
>   	tmb->start_pfn = start_pfn;
>   	tmb->end_pfn = end_pfn;
> +	tmb->nid = nid;
>   
>   	/* @tmb_list is protected by mem_hotplug_lock */
>   	list_add_tail(&tmb->list, tmb_list);
> @@ -259,9 +260,9 @@ static void free_tdx_memlist(struct list_head *tmb_list)
>   static int build_tdx_memlist(struct list_head *tmb_list)
>   {
>   	unsigned long start_pfn, end_pfn;
> -	int i, ret;
> +	int i, nid, ret;
>   
> -	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>   		/*
>   		 * The first 1MB is not reported as TDX convertible memory.
>   		 * Although the first 1MB is always reserved and won't end up
> @@ -277,7 +278,7 @@ static int build_tdx_memlist(struct list_head *tmb_list)
>   		 * memblock has already guaranteed they are in address
>   		 * ascending order and don't overlap.
>   		 */
> -		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn);
> +		ret = add_tdx_memblock(tmb_list, start_pfn, end_pfn, nid);
>   		if (ret)
>   			goto err;

Why did you decide to defer remembering the nid as well? I'd just move 
that part to the patch that adds add_tdx_memblock().

-- 
Cheers,

David / dhildenb

