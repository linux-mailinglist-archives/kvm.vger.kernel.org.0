Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFE47CD377
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 07:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjJRFUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 01:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjJRFU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 01:20:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C81BA;
        Tue, 17 Oct 2023 22:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697606428; x=1729142428;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ljGA96pJdhn4htcQFUZHNLFUU0HFsDrmUML7iu2lJmM=;
  b=NkDGnyUEoN3R4PBGmK+1jisLWPwnhyVT95AKBftggPqC766zp9TH9Apw
   sfMqh2hbaJ1Zahas3TA7WlRBuTz+ubApQiWo7UPoHuQ1la/uhcFTMadUi
   oJ24oNrmwqctlO5457nqyHHB2Nr7A0Cqkh30tVJhX5QZxrE9AiF4yt4f4
   GLPK8guQuRhh2z86ReowICCrxc08XKljjGFOYN7duajz4kizEzrnSAb2a
   X8qjymA4Xd2W+vB1dtgmY+c+LTJrem2Z0LVsXZ1cEd3m2hJeVyHLwfJMu
   c38W6dKtAhGpto9xwNBek4051n2RGpjEgxGp9nSBbZTyKmjle+47T+lPw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="371003324"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="371003324"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 22:20:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="822291496"
X-IronPort-AV: E=Sophos;i="6.03,234,1694761200"; 
   d="scan'208";a="822291496"
Received: from jysong-mobl1.amr.corp.intel.com (HELO [10.251.4.174]) ([10.251.4.174])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 22:20:26 -0700
Message-ID: <3133a1a5-58c0-4b31-89fe-e86ffa12a342@linux.intel.com>
Date:   Tue, 17 Oct 2023 22:20:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] kvmclock: Use free_decrypted_pages()
Content-Language: en-US
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        elena.reshetova@intel.com, isaku.yamahata@intel.com,
        seanjc@google.com, Michael Kelley <mikelley@microsoft.com>,
        thomas.lendacky@amd.com, decui@microsoft.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
References: <20231017202505.340906-1-rick.p.edgecombe@intel.com>
 <20231017202505.340906-4-rick.p.edgecombe@intel.com>
From:   Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20231017202505.340906-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/2023 1:24 PM, Rick Edgecombe wrote:
> On TDX it is possible for the untrusted host to cause
> set_memory_encrypted() or set_memory_decrypted() to fail such that an
> error is returned and the resulting memory is shared. Callers need to take
> care to handle these errors to avoid returning decrypted (shared) memory to
> the page allocator, which could lead to functional or security issues.
> 
> Kvmclock could free decrypted/shared pages if set_memory_decrypted() fails.
> Use the recently added free_decrypted_pages() to avoid this.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---

Since it a fix, do you want to add Fixes tag?

Otherwise, it looks good to me.

Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>


>  arch/x86/kernel/kvmclock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index fb8f52149be9..587b159c4e53 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -227,7 +227,7 @@ static void __init kvmclock_init_mem(void)
>  		r = set_memory_decrypted((unsigned long) hvclock_mem,
>  					 1UL << order);
>  		if (r) {
> -			__free_pages(p, order);
> +			free_decrypted_pages((unsigned long)hvclock_mem, order);
>  			hvclock_mem = NULL;
>  			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
>  			return;

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
