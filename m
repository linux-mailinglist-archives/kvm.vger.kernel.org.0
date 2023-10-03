Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA897B6E00
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbjJCQHR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbjJCQHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:07:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3409FAB;
        Tue,  3 Oct 2023 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696349233; x=1727885233;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wymdIEl8VVVgMijc78DcYYzoGVblxaV2STsFsGMfpf0=;
  b=WD70Xu6mpjkvjxwRuh3sdyOcRYLY0dCZ/UxXUP2mkil5cmMDy1D3aKL4
   2JRkvCGeeAdRqWvj6CvXL4stU9w/XGUir7wXAggW/mUhCo/IQupyoxMj2
   Y6dyWPHgWsUT8ZeREieu6TgHr8FXvYvqxwPd603kVFOkJ6PeXc4gLPPWo
   873iI3OC+587oDMZactzBPnEyE5iW8yBcIiM9pdQbT9E75kyMx/e5n9pv
   WIReMUpLcHSiJtuCm4MxYE4bC3vdcGJvTvlOt+JtW44xubDgEHgdBFf9I
   bnp+HYMFKjLuDi3xhaZs5/cqSH7vtJb4J+WcHvtH1gdrfJeekDFiflLKm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="449406312"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="449406312"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:07:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="700760945"
X-IronPort-AV: E=Sophos;i="6.03,197,1694761200"; 
   d="scan'208";a="700760945"
Received: from ddiaz-mobl4.amr.corp.intel.com (HELO [10.209.57.36]) ([10.209.57.36])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2023 09:07:07 -0700
Message-ID: <e7ae2b89-f2c4-e95f-342b-fcf92a2e0ae3@intel.com>
Date:   Tue, 3 Oct 2023 09:07:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] arch/x86: Set XSS while handling #VC intercept for CPUID
Content-Language: en-US
To:     Jinank Jain <jinankjain@linux.microsoft.com>, seanjc@google.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jinankjain@microsoft.com, thomas.lendacky@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     wei.liu@kernel.org, tiala@microsoft.com
References: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/3/23 02:28, Jinank Jain wrote:
...
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 2eabccde94fb..92350a24848c 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -880,6 +880,9 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  	if (snp_cpuid_ret != -EOPNOTSUPP)
>  		return ES_VMM_ERROR;
>  
> +	if (regs->ax == 0xD && regs->cx == 0x1)
> +		ghcb_set_xss(ghcb, 0);

The spec talks about leaf 0xD, but not the subleaf:

> XSS is only required to besupplied when a request forCPUID 0000_000D
> is made andthe guest supports the XSS MSR(0x0000_0DA0).
Why restrict this to subleaf (regx->cx) 1?

Second, XCR0 is being supplied regardless of the CPUID leaf.  Why should
XSS be restricted to 0xD while XCR0 is universally supplied?

Third, why is it OK to supply a garbage (0) value?  If the GHCB field is
required it's surely because the host *NEEDS* the value to do something.
 Won't a garbage value potentially confuse the host?

