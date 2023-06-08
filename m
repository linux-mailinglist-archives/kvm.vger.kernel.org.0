Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE6F728B52
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbjFHWw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 18:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236906AbjFHWwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 18:52:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317932D78;
        Thu,  8 Jun 2023 15:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686264774; x=1717800774;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=21zWUj9vAPSBXRfUhmtCO8AmWkPwEC5zfq8Lbo30rO8=;
  b=SJEVaLgOQP0Ix4g7gnqGoEU5vuAZAGdWYncSrdAdnNZjXVC8Bjdf7Zzw
   vxXKp2Ze281ZiqaXgurvl6O5LfKSeZcgI5wkg7TCG6b9s7fFXYJs+yTyO
   cnY52jYVuYMfxiB7qR74iKkqpDU3bHw9xrgG0+97griZgvSJfnaQ/HIM3
   tWdPLdbjyIzRZWEGmj/1r0ENWeTAz/0kWBmkGDmj8tl4oKAWbAPzKQ2cc
   Sh0ccV/ZgJ5cWIweKSkXEjLVinN87g+rB3FjVp8KOBe38OZS7F2+N/qIV
   mPdYG6POno6FWWEYFMqCjnH2ymgkmqpXIVEMmYWr3kePXklYQqUmKxMk6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="342129258"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="342129258"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 15:52:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="780071573"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="780071573"
Received: from fgorter-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.59.89])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 15:52:48 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id B87CF104C0F; Fri,  9 Jun 2023 01:52:45 +0300 (+03)
Date:   Fri, 9 Jun 2023 01:52:45 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 10/20] x86/virt/tdx: Add placeholder to construct
 TDMRs to cover all TDX memory regions
Message-ID: <20230608225245.rvygi5zkr2niolsj@box>
References: <cover.1685887183.git.kai.huang@intel.com>
 <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9148e67e968d7aed4707b67ea9b1aa761401255.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:23AM +1200, Kai Huang wrote:
> @@ -50,6 +51,8 @@ static DEFINE_MUTEX(tdx_module_lock);
>  /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
>  static LIST_HEAD(tdx_memlist);
>  
> +static struct tdmr_info_list tdx_tdmr_list;
> +
>  /*
>   * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
>   * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL

The name is misleading. It is not list, it is an array.


...

> @@ -112,6 +135,15 @@ struct tdx_memblock {
>  	unsigned long end_pfn;
>  };
>  
> +struct tdmr_info_list {
> +	void *tdmrs;	/* Flexible array to hold 'tdmr_info's */
> +	int nr_consumed_tdmrs;	/* How many 'tdmr_info's are in use */
> +
> +	/* Metadata for finding target 'tdmr_info' and freeing @tdmrs */
> +	int tdmr_sz;	/* Size of one 'tdmr_info' */
> +	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
> +};
> +
>  struct tdx_module_output;
>  u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);

Otherwise, looks okay.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
