Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805A96203E1
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 00:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiKGXlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 18:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiKGXlH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 18:41:07 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1453317076;
        Mon,  7 Nov 2022 15:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667864467; x=1699400467;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HkPqplWnWgKasGuEjl+2C0+gJiDFRh+H10A4rXRH/Z0=;
  b=PlIfBVJdQYf6s0VPQVtS18XWHJeHthWnS+DAvKp1Gd0x6wuG0KOmAPZo
   6d3Hb97XbGSgkobs6GD9js9hWExAHDTagmbHnCpgbdIFYQ525nQrLKSOb
   Ln7eP6jT1wRsZfQH4oGa0EuqNdfMTFyg6DFoezWNpQAi01G4S56PoSak7
   intSfP4llqIpJA1g7FkIErhXlC9oVnmm4Vl1xa6MdJwebCq8jRpe6/ZnR
   tpd7nYf+CJFEBz+jmLZZ2S+5GjrmWGWn/kJ7PXbzI4DI406HaRFCzHCgA
   z8qdLsIR8tE2huoi4RIjK+naLfl1hUzd+JZi3ZhJOP+JcQafVjm/ChECu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="309261744"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="309261744"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:41:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="630668969"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="630668969"
Received: from peggykes-mobl.amr.corp.intel.com (HELO [10.251.7.244]) ([10.251.7.244])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 15:41:04 -0800
Message-ID: <da41d7f0-68ea-0c21-1dca-218f8184a0f3@intel.com>
Date:   Mon, 7 Nov 2022 15:41:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Content-Language: en-US
To:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com> <Y2WJjdY3wwQl9/q9@zn.tnic>
 <Y2ZEinL+wlIX+1Sn@hirez.programming.kicks-ass.net>
 <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <d413c064-ee9b-5853-9cf1-544adde22c8a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/7/22 14:39, Kim Phillips wrote:
> I've started a version that has AUTOIBRS reuse SPECTRE_V2_EIBRS
> spectre_v2_mitigation enum, but, so far, it's change to bugs.c
> looks bigger: 58 lines changed vs. 34 (see below).
> 
> Let me know if you want me to send it as a part of a v2 submission
> after I take care of the kvm CPUID review.

Thanks for putting that together.  I generally like how this looks.

I think it probably goes to a _bit_ too much trouble to turn off
"eibrs,lfence/retpoline".  If someone goes to the trouble of specifying
those, a warning or pr_info() is probably enough.  You don't need to
actively override it.

> -    } else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode) &&
> -           mode != SPECTRE_V2_AUTO_IBRS) {
> +    } else if ((boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) ||
> +           (boot_cpu_has(X86_FEATURE_AUTOIBRS) && !spectre_v2_in_ibrs_mode(mode))) {
>          setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
>          pr_info("Enabling Restricted Speculation for firmware calls\n"); 

Did the "mode != SPECTRE_V2_AUTO_IBRS" check get dropped accidentally?
Or is it unnecessary now?
