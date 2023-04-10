Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC766DCA96
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 20:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDJSQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 14:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjDJSQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 14:16:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1F91BEB;
        Mon, 10 Apr 2023 11:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681150577; x=1712686577;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0ix6Ckdt+5OCc4ou2uz+XeRPoBdpCTfcvuC4e0JJtKY=;
  b=I9u49lSrUF+aCtXmGpkGJT0EInLdutiuhCs7fip5M3E0e4Rgi7JRbmaP
   HKnVhlJYR2Po0my1YMZilpcvaIeTOYPINRjKs4ciIwAnBFUm81336HTWD
   08oUzZRlwfgmDIOF/aniQ+v7AWNB/DDfq/58rKTtByegjg84HDU1Fhs9P
   mJwO+kQ+VogxKHDSjPa6aZD3mzOcoCEVwu6b/6KF8a60EygMB5kMPEQnd
   aQqv+EHaKjh/k6chW08USkrqMvQEkClmH79G17/j0O34pYzuhXNpCLhKm
   gcmoJOs4RuTKJr/OncKAUN/vDT3H4Ysit1ezoYZv/fYtNoZshG3Ek1EyB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327516577"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="327516577"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:16:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="752850815"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="752850815"
Received: from arsetion-mobl.amr.corp.intel.com (HELO [10.209.122.228]) ([10.209.122.228])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 11:16:16 -0700
Message-ID: <bbde7529-eb64-5454-0984-bfdabac37b64@intel.com>
Date:   Mon, 10 Apr 2023 11:16:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v7 23/33] x86/fred: let ret_from_fork() jmp to
 fred_exit_user when FRED is enabled
Content-Language: en-US
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com, jiangshanlai@gmail.com,
        shan.kang@intel.com
References: <20230404102716.1795-1-xin3.li@intel.com>
 <20230404102716.1795-24-xin3.li@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230404102716.1795-24-xin3.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 03:27, Xin Li wrote:
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -299,7 +299,12 @@ SYM_CODE_START_NOALIGN(ret_from_fork)
>  	UNWIND_HINT_REGS
>  	movq	%rsp, %rdi
>  	call	syscall_exit_to_user_mode	/* returns with IRQs disabled */
> +#ifdef CONFIG_X86_FRED
> +	ALTERNATIVE "jmp swapgs_restore_regs_and_return_to_usermode", \
> +		    "jmp fred_exit_user", X86_FEATURE_FRED
> +#else
>  	jmp	swapgs_restore_regs_and_return_to_usermode
> +#endif

Does the #ifdef really buy us anything here?

I guess it might save a *TINY* amount of time at alternative processing
time.  But that doesn't really seem worth it.
