Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC2660AF1
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbjAGAhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbjAGAg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:36:28 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A2E6C29C;
        Fri,  6 Jan 2023 16:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673051751; x=1704587751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aOAUFsSLQRTZY0xZlfuNr828MZiMICWj/1uXvVg70Ks=;
  b=NUF83tS+HBzeHi5imnQXwPWzFLbxdbzH9paPJgOXtZHWUVG5ugIcFn2k
   s7doXD6nTT312Y4OD+97sGJXgzaCUryE7XgCzxdLa5pUfjx3NiwUIqbf4
   trcbL2GzsYls+LJ8iTJq4f6kmzdhZ4UZJQgrE3LPcbjMjD1FXqpJXsO62
   SLANRo2QYb7V25RVd2dS8+hYlJ6uemUuFQQLISm4I+2gZl4miNODsbh0w
   DvHDLf+dxTrFe2aeUTqGQz97r9Q6Q99etYvnQid84EYbQdOkKhI2YqCj+
   NJ6x1eTu1TBxmIfLojLkgIE/PeBa4IDNRzUZf5nKaty+NmOOxJrb8auxK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="349805294"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="349805294"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:35:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="688460597"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="688460597"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 16:35:50 -0800
Message-ID: <ba0fdee9-148b-b0b9-ecde-2610eff02ba1@intel.com>
Date:   Fri, 6 Jan 2023 16:35:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 15/16] x86/virt/tdx: Flush cache in kexec() when TDX is
 enabled
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, peterz@infradead.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1670566861.git.kai.huang@intel.com>
 <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ee5185e1727c3cd8bd51dbf9fcec95d432100d12.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> There are two problems in terms of using kexec() to boot to a new kernel
> when the old kernel has enabled TDX: 1) Part of the memory pages are
> still TDX private pages (i.e. metadata used by the TDX module, and any
> TDX guest memory if kexec() happens when there's any TDX guest alive).
> 2) There might be dirty cachelines associated with TDX private pages.
> 
> Because the hardware doesn't guarantee cache coherency among different
> KeyIDs, the old kernel needs to flush cache (of those TDX private pages)
> before booting to the new kernel.  Also, reading TDX private page using
> any shared non-TDX KeyID with integrity-check enabled can trigger #MC.
> Therefore ideally, the kernel should convert all TDX private pages back
> to normal before booting to the new kernel.

This is just talking about way too many things that just don't apply.

Let's focus on the *ACTUAL* problem that's being addressed instead of
the 15 problems that aren't actual practical problems.

> However, this implementation doesn't convert TDX private pages back to
> normal in kexec() because of below considerations:
> 
> 1) Neither the kernel nor the TDX module has existing infrastructure to
>    track which pages are TDX private pages.
> 2) The number of TDX private pages can be large, and converting all of
>    them (cache flush + using MOVDIR64B to clear the page) in kexec() can
>    be time consuming.
> 3) The new kernel will almost only use KeyID 0 to access memory.  KeyID
>    0 doesn't support integrity-check, so it's OK.
> 4) The kernel doesn't (and may never) support MKTME.  If any 3rd party
>    kernel ever supports MKTME, it can/should do MOVDIR64B to clear the
>    page with the new MKTME KeyID (just like TDX does) before using it.

Yeah, why are we getting all worked up about MKTME when there is not
support?

The only thing that matters here is dirty cacheline writeback.  There
are two things the kernel needs to do to mitigate that:

 1. Stop accessing TDX private memory mappings
  1a. Stop making TDX module calls (uses global private KeyID)
  1b. Stop TDX guests from running (uses per-guest KeyID)
 2. Flush any cachelines from previous private KeyID writes

There are a couple of ways we can do #2.  We do *NOT* need to convert
*ANYTHING* back to KeyID 0.  Page conversion doesn't even come into play
in any way as far as I can tell.

I think you're also saying that since all CPUs go through this path and
there is no TDX activity between the WBINVD and the native_halt() that
1a and 1b basically happen for "free" without needing to do theme
explicitly.

> Therefore, this implementation just flushes cache to make sure there are
> no stale dirty cachelines associated with any TDX private KeyIDs before
> booting to the new kernel, otherwise they may silently corrupt the new
> kernel.

That's fine.  So, this patch kinda happens to land in the right spot
even after thrashing about about a while.

> Following SME support, use wbinvd() to flush cache in stop_this_cpu().
> Theoretically, cache flush is only needed when the TDX module has been
> initialized.  However initializing the TDX module is done on demand at
> runtime, and it takes a mutex to read the module status.  Just check
> whether TDX is enabled by BIOS instead to flush cache.

Yeah, close enough.

> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index c21b7347a26d..0cc84977dc62 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -765,8 +765,14 @@ void __noreturn stop_this_cpu(void *dummy)
>  	 *
>  	 * Test the CPUID bit directly because the machine might've cleared
>  	 * X86_FEATURE_SME due to cmdline options.
> +	 *
> +	 * Similar to SME, if the TDX module is ever initialized, the
> +	 * cachelines associated with any TDX private KeyID must be flushed
> +	 * before transiting to the new kernel.  The TDX module is initialized
> +	 * on demand, and it takes the mutex to read its status.  Just check
> +	 * whether TDX is enabled by BIOS instead to flush cache.
>  	 */

There's too much detail here.  Let's up-level it a bit.  We don't need
to be talking about TDX locking here.

	/*
	 * The TDX module or guests might have left dirty cachelines
	 * behind.  Flush them to avoid corruption from later writeback.
	 * Note that this flushes on all systems where TDX is possible,
	 * but does not actually check that TDX was in use.
	 */

> -	if (cpuid_eax(0x8000001f) & BIT(0))
> +	if (cpuid_eax(0x8000001f) & BIT(0) || platform_tdx_enabled())
>  		native_wbinvd();
>  	for (;;) {
>  		/*

