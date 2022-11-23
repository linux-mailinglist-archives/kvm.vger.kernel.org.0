Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28041636E9F
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 00:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiKWX47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 18:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKWX46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 18:56:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F276E0DD1;
        Wed, 23 Nov 2022 15:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669247817; x=1700783817;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CFET33j4BltTpLTUFtSwfx+NssCIekeUgbWNJ9vumtw=;
  b=E8ehgS6Wjk0PpCjkLwru++CM/f3fulhEm5nFKTa+0Cg/GPG3D7rW5cVt
   2efZgejOp4L44ACKLRFFyNOtm2lbvToGdfwc1B1lRQAO6wUKouvhtLcSF
   EimtuLDdXNdIJc2FiX2gG+/uiI0bw0/rDfZidXPaXLZJ7ktwBAcceljgV
   N3Gk6F6/xYnqdQIrnoqOmWCilxYaVC9XVLRoT+l3WaydLf3VP9ZbLl9/I
   nc6LpT8HcLfNUvxHqR6sABO23LTticXbzKoVIIcMOGm9Hdv3/O8dL4yiv
   rsZ7FeBm8A7FpnYTUxghX1otGY/qsouOrZUPL3SkSjx0y+STNUgT44hI4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="314216023"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="314216023"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:56:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747991633"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747991633"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:56:55 -0800
Message-ID: <301184ce-05e5-871c-7a6c-4298a0cbd1ae@intel.com>
Date:   Wed, 23 Nov 2022 15:56:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 16/20] x86/virt/tdx: Configure TDX module with TDMRs
 and global KeyID
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <344234642a5eb9dc1aa34410f641f596ec428ea5.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/22 16:26, Kai Huang wrote:
> After the TDX-usable memory regions are constructed in an array of TDMRs
> and the global KeyID is reserved, configure them to the TDX module using
> TDH.SYS.CONFIG SEAMCALL.  TDH.SYS.CONFIG can only be called once and can
> be done on any logical cpu.
> 
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  2 ++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index e2cbeeb7f0dc..3a032930e58a 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -979,6 +979,37 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
>  	return ret;
>  }
>  
> +static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
> +			     u64 global_keyid)
> +{
> +	u64 *tdmr_pa_array;
> +	int i, array_sz;
> +	u64 ret;
> +
> +	/*
> +	 * TDMR_INFO entries are configured to the TDX module via an
> +	 * array of the physical address of each TDMR_INFO.  TDX module
> +	 * requires the array itself to be 512-byte aligned.  Round up
> +	 * the array size to 512-byte aligned so the buffer allocated
> +	 * by kzalloc() will meet the alignment requirement.
> +	 */

Aagh.  Return of (a different) 512-byte aligned structure.

> +	array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
> +	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);

Just to be clear, all that chatter about alignment is because the
*START* of the array has to be aligned.  Right?  I see alignment for
'array_sz', but that's not the start of the array.

tdmr_pa_array is the start of the array.  Where is *THAT* aligned?

How does rounding up the size make kzalloc() magically know how to align
the *START* of the allocation?

Because I'm actually questioning my own sanity at this point, I went and
double-checked the docs (Documentation/core-api/memory-allocation.rst):

> The address of a chunk allocated with `kmalloc` is aligned to at least
> ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
> alignment is also guaranteed to be at least the respective size.

Hint #1: ARCH_KMALLOC_MINALIGN is way less than 512.
Hint #2: tdmr_num is not guaranteed to be a power of two.
Hint #3: Comments don't actually affect the allocation

<snip>
