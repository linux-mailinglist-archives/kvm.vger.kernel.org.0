Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2FC65B3B9
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbjABPD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 10:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbjABPDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 10:03:36 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED828FEA
        for <kvm@vger.kernel.org>; Mon,  2 Jan 2023 07:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672671815; x=1704207815;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ewFkyV0boZJhQiAAEXzc/pLPo66h7zoDQ9PAXlMuubA=;
  b=RPhqU3CKons5p2er5cZ9OTcmrDh76s5OD3YIbEDNyy+zxTt02IgdFI6U
   WydYFEKgkir2mY4vaVURQPffM0FqsfKU5ODkgHZEunU2k5ict/gi3g9Du
   le1mKTvAgrVZ/To/sQ9E3hSOb94HNjCwwKrgtLV5TovJRq/mRDb9BlDKN
   omqnx6COF6s86jVjlAyhhyzgil6O7ynHaa+1RYoNhEvh4PkXGKJIMkAIa
   Ke/CwcDalnvaX4UKPabLuxbgqH/4c8RIZ5P7yskJxT5BxAuONmZA/uSfH
   V4qt+kr57w1NxK+8HpKjhUR21gNerk+QMzJlFJuc4CwcgG+giEiDSMW0+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="407754910"
X-IronPort-AV: E=Sophos;i="5.96,294,1665471600"; 
   d="scan'208";a="407754910"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 07:03:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10578"; a="654508023"
X-IronPort-AV: E=Sophos;i="5.96,294,1665471600"; 
   d="scan'208";a="654508023"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.251]) ([10.249.169.251])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 07:03:14 -0800
Message-ID: <93332d0c-108c-7f10-1f21-6dd94abcfb7f@intel.com>
Date:   Mon, 2 Jan 2023 23:03:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
Content-Language: en-US
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20221230162442.3781098-2-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/31/2022 12:24 AM, Aaron Lewis wrote:
> Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> to be set if they can't all be set.  That way userspace or a guest
> doesn't fail if it attempts to set them in XCR0.
> 
> [1] CPUID.(EAX=0DH,ECX=0):EAX.BNDREGS[bit-3]
>      CPUID.(EAX=0DH,ECX=0):EAX.BNDCSR[bit-4]
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c4e8257629165..2431c46d456b4 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -855,6 +855,16 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>   	return 0;
>   }
>   
> +static u64 sanitize_xcr0(u64 xcr0)
> +{
> +	u64 mask;
> +
> +	mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> +	if ((xcr0 & mask) != mask)
> +		xcr0 &= ~mask;

Maybe it can WARN_ON_ONCE() here.

It implies either a kernel bug that permitted_xcr0 is invalid or a 
broken HW.

> +	return xcr0;
> +}
> +
>   static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   {
>   	struct kvm_cpuid_entry2 *entry;
> @@ -982,6 +992,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
>   		u64 permitted_xss = kvm_caps.supported_xss;
>   
> +		permitted_xcr0 = sanitize_xcr0(permitted_xcr0);
> +
>   		entry->eax &= permitted_xcr0;
>   		entry->ebx = xstate_required_size(permitted_xcr0, false);
>   		entry->ecx = entry->ebx;

