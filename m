Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9E60F779
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiJ0MgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiJ0MgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:36:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3798263D18;
        Thu, 27 Oct 2022 05:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666874162; x=1698410162;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kMIurRzsa691osTcsV/hECDNaAIwmHkC2vJzZbTA8CU=;
  b=LeIs8rjpZuKVmK8Zym9lRgxfdgN0qwcrLOsIZbU62HyS4/SANtgN+LQ7
   B56P/krm49ecLHuMyl5P8idDDCtvJqF2YQjKcPQP8mdO719oxd79j55vt
   P6XB+Coc3QxGmN+8OUF/IiUpGR6VWlHZq8z0mOeSfui4/sfEmi1zM5Eni
   Wk7lypxQ5WVIrRFxOK9DriD1ceBJn2SkqtGDQ1l4BFhmJkcvoBHmomgtI
   LNYDnAITaxrpBIJngpVc0w/WXEk75F+mHPGcRr34W4PI1v1HWcgv9YdXD
   M9/X7sqT4CNbX9WpcX3OI2zE8u60Fx1fEOnjxpSGUVdXk3GyvkJFr8a9K
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="306939273"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="306939273"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:35:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="583539685"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="583539685"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.251.5.115]) ([10.251.5.115])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:35:53 -0700
Message-ID: <49a6cf62-547f-0f70-3c40-4d7cc077a5c7@linux.intel.com>
Date:   Thu, 27 Oct 2022 05:35:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v6 18/21] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1666824663.git.kai.huang@intel.com>
 <c88eb1d501abffc5b9181ef0930579871b7fcbff.1666824663.git.kai.huang@intel.com>
From:   Andi Kleen <ak@linux.intel.com>
In-Reply-To: <c88eb1d501abffc5b9181ef0930579871b7fcbff.1666824663.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/26/2022 4:16 PM, Kai Huang wrote:
> After the array of TDMRs and the global KeyID are configured to the TDX
> module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
> on all packages.
>
> TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
> it cannot run concurrently on different CPUs.  Implement a helper to
> run SEAMCALL on one cpu for each package one by one, and use it to
> configure the global KeyID on all packages.
>
> Intel hardware doesn't guarantee cache coherency across different
> KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
> with KeyID 0) before the TDX module uses the global KeyID to access the
> PAMT.  Following the TDX module specification, flush cache before
> configuring the global KeyID on all packages.
>
> Given the PAMT size can be large (~1/256th of system RAM), just use
> WBINVD on all CPUs to flush.
>
> Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 83 ++++++++++++++++++++++++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h |  1 +
>   2 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fdfce715dda6..9cfb01e7666a 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -354,6 +354,46 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
>   	on_each_cpu(seamcall_smp_call_function, sc, true);
>   }
>   
> +/*
> + * Call one SEAMCALL on one (any) cpu for each physical package in
> + * serialized way.  Return immediately in case of any error if
> + * SEAMCALL fails on any cpu.


It's not clear what are you serializing against (against itself or other 
calls of this functions)

I assume its because the TDX module errors out for parallel calls 
instead of waiting.

The code seems to only do itself, so where is the check against others? 
I assume in the callers but that would need to be explained. Also could 
it need serialization against other kinds of seam calls?

Perhaps it might be more efficient to just broad cast and handle a retry 
with some synchronization in the low level code.

That likely would cause less review thrash than just reimplementing a 
common function like this here.


-Andi


