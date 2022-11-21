Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D397E63190B
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 04:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKUDve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 22:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKUDvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 22:51:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800B01EEF0;
        Sun, 20 Nov 2022 19:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669002692; x=1700538692;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hohlFiBJb37bBIJI1v6/igX0NmrgDgUxGKaO+zYS7MY=;
  b=P6BINSiatazXrYxSbfynfsDgqnEFlMdRzgxuED55KubyOVJ2d0qqovvg
   l/KJCKMfqujcZ+1mbtpYvqoDoS+gZie8HxOjZwt2qtWu9GFCcgk3c+IMC
   z5YMWn4cLtAHv5fdTKTc3cv/3dJ/g285KCUxKSTw+m+RiDSsRCThX0HjP
   xcIkGEvobZ8TYXIn6Pzmr29nasQ6gjq6PcTOk/Q+0mBs+zbfr4tQ7yxsh
   v7JzoifseLjW8A4a5GvmmU0FppA0qjT9H7IvVd69uDHi9ZSkR8eICouJ1
   L3JywNdrz/xQcZzfsZFxxD9AF+/Cvxrsl51aGGfic5vbdcrvSawhmvvJ1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="315285795"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="315285795"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 19:51:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="765820331"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="765820331"
Received: from mjcardon-mobl.amr.corp.intel.com (HELO [10.209.57.10]) ([10.209.57.10])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 19:51:31 -0800
Message-ID: <62c67ed3-e4d1-082f-800a-b0837c9432a9@linux.intel.com>
Date:   Sun, 20 Nov 2022 19:51:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH v7 03/20] x86/virt/tdx: Disable TDX if X2APIC is not
 enabled
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <c5f484c1a87ee052597fd5f539cf021f158755b9.1668988357.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/20/22 4:26 PM, Kai Huang wrote:
> The MMIO/xAPIC interface has some problems, most notably the APIC LEAK

"some problems" looks more generic. May be we can be specific here. Like
it has security issues?

> [1].  This bug allows an attacker to use the APIC MMIO interface to
> extract data from the SGX enclave.
> 
> TDX is not immune from this either.  Early check X2APIC and disable TDX
> if X2APIC is not enabled, and make INTEL_TDX_HOST depend on X86_X2APIC.
> 
> [1]: https://aepicleak.com/aepicleak.pdf
> 
> Link: https://lore.kernel.org/lkml/d6ffb489-7024-ff74-bd2f-d1e06573bb82@intel.com/
> Link: https://lore.kernel.org/lkml/ba80b303-31bf-d44a-b05d-5c0f83038798@intel.com/
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v6 -> v7:
>  - Changed to use "Link" for the two lore links to get rid of checkpatch
>    warning.
> 
> ---
>  arch/x86/Kconfig            |  1 +
>  arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cced4ef3bfb2..dd333b46fafb 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1958,6 +1958,7 @@ config INTEL_TDX_HOST
>  	depends on CPU_SUP_INTEL
>  	depends on X86_64
>  	depends on KVM_INTEL
> +	depends on X86_X2APIC
>  	help
>  	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>  	  host and certain physical attacks.  This option enables necessary TDX
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 982d9c453b6b..8d943bdc8335 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -12,6 +12,7 @@
>  #include <linux/printk.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
> +#include <asm/apic.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> @@ -81,6 +82,16 @@ static int __init tdx_init(void)
>  		goto no_tdx;
>  	}
>  
> +	/*
> +	 * TDX requires X2APIC being enabled to prevent potential data
> +	 * leak via APIC MMIO registers.  Just disable TDX if not using
> +	 * X2APIC.

Remove the double space.

> +	 */
> +	if (!x2apic_enabled()) {
> +		pr_info("Disable TDX as X2APIC is not enabled.\n");

pr_warn()?

> +		goto no_tdx;
> +	}
> +
>  	return 0;
>  no_tdx:
>  	clear_tdx();

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
