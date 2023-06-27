Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCB773F921
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 11:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjF0Jxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 05:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjF0Jwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 05:52:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177E9295A;
        Tue, 27 Jun 2023 02:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687859544; x=1719395544;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P7P0wQ1E8RmiIKSnjWYXDvU2USxNtYlCqn1VIsppLGM=;
  b=A3xFRHe/4puV9zoCZkKAQHNrUd9Ox05ZoLJkSR/8GOzPH1oC6GQ9589f
   2z/hD8LKeXjSp4ytOTujRP2RdgRFwSV/OWl2FpulwrBKYtSEq4yYqSNbo
   GhmUOPB4QRpoKZ1z4Xf3vMRKxmlLDg7BORCjpOdFSfm+it/LJ1K1dXDgF
   gtwkWTaWi9X1PSx5NblOLQD6mxnPJQURQ/Cf0byiAjKZMiUKKYefs4SiS
   2r6mblKxuixElX364LubUUCGqR/sPu7fOTqk/Bm3AHkxLPfdxUG8ZiDBB
   +92zh2XHhunCjayywNn5rU9O18QFhZtKtZyOAPLWB0JLn/SHCtBkwevSf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="427528702"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="427528702"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:52:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="781794448"
X-IronPort-AV: E=Sophos;i="6.01,162,1684825200"; 
   d="scan'208";a="781794448"
Received: from rbhaumik-mobl2.ger.corp.intel.com (HELO box.shutemov.name) ([10.251.217.121])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2023 02:51:55 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 06EC2103732; Tue, 27 Jun 2023 12:51:53 +0300 (+03)
Date:   Tue, 27 Jun 2023 12:51:52 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        tony.luck@intel.com, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v12 12/22] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Message-ID: <20230627095152.zmeb2djphpboo5ya@box.shutemov.name>
References: <cover.1687784645.git.kai.huang@intel.com>
 <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ea233226ec7a05e8c5627a499e97ea4cbd6950.1687784645.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 02:12:42AM +1200, Kai Huang wrote:
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
>   - Allocate three PAMTs of the TDMR in one contiguous chunk to minimize
>     the total number of reserved areas consumed for PAMTs.
>   - Try to first allocate PAMT from the local node of the TDMR for better
>     NUMA locality.
> 
> Also dump out how many pages are allocated for PAMTs when the TDX module
> is initialized successfully.  This helps answer the eternal "where did
> all my memory go?" questions.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
