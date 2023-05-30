Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79A67170A3
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbjE3WWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 18:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjE3WWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 18:22:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78019102;
        Tue, 30 May 2023 15:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685485331; x=1717021331;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1yclU0/PNC1x/+Z0XR9VHAZKmtWtaT5GSX759uuyefU=;
  b=iy+YT3DU3F3cO+Jr4TA5g6yGimxpFsh2v/mQ1SD46clyAbdd31T8+wIC
   LPHp1lIwZ2PDrF9ZAMlt9FFf2P4q7FVbIr3vGMRtoKrgj3HKXyhi9MT5/
   IWSnI5XPgey8/hAayeIWAT1GWdtclLV0546oDOna0ttdNYqai9ql25+c1
   Pl32HehHvTfeHawCDxP11w6ut0eUIjZFUZ+R+NlSLeH4ZRFDUIRTDxkzL
   Y4E/JxmycqQT9LwA3srK/ZtUpcwJ0d30qTjknXsuTO3nvpOHcI6pbgiTl
   STAjqf0lcecAulBbwy/HGOAi7pz8IMEPRHkgCxNr5K/c6MzlKcCHxx7Ew
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="335411349"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="335411349"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:22:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796440615"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="796440615"
Received: from jswalken-mobl.amr.corp.intel.com (HELO [10.212.134.46]) ([10.212.134.46])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:22:10 -0700
Message-ID: <2a6502e3-ba87-0355-af09-825e8467b81f@intel.com>
Date:   Tue, 30 May 2023 15:22:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] x86/fpu/xstate: clear XSAVE features if DISABLED_MASK set
Content-Language: en-US
To:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Kyle Huey <me@kylehuey.com>, neelnatu@google.com,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230530200152.18961-1-jon@nutanix.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <20230530200152.18961-1-jon@nutanix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/23 13:01, Jon Kohler wrote:
> Respect DISABLED_MASK when clearing XSAVE features, such that features
> that are disabled do not appear in the xfeatures mask.

One sanity check that I'd suggest adopting is "How many other users in
the code do this?"  How many DISABLED_MASK_BIT_SET() users are there?

> This is important for kvm_load_{guest|host}_xsave_state, which look
> at host_xcr0 and will do an expensive xsetbv when the guest and host
> do not match.

Is that the only problem?  kvm_load_guest_xsave_state() seems to have
some #ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS code and I can't
imagine that KVM guests can even use PKRU if this code is compiled out.

Also, this will set XFEATURE_PKRU in xcr0 and go to the trouble of
XSAVE/XRSTOR'ing it all over the place even for regular tasks.

> A prime example if CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is disabled,
> the guest OS will not see PKU masked; however, the guest will incur
> xsetbv since the host mask will never match the guest, even though
> DISABLED_MASK16 has DISABLE_PKU set.

OK, so you care because you're seeing KVM go slow.  You tracked it down
to lots of XSETBV's?  You said, "what the heck, why is it doing XSETBV
so much?" and tracked it down to 'max_features' which we use to populate
XCR0?

> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> index 0bab497c9436..211ef82b53e3 100644
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -798,7 +798,8 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>  		unsigned short cid = xsave_cpuid_features[i];
> 
>  		/* Careful: X86_FEATURE_FPU is 0! */
> -		if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid))
> +		if ((i != XFEATURE_FP && !cid) || !boot_cpu_has(cid) ||
> +		    DISABLED_MASK_BIT_SET(cid))
>  			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
>  	}

I _think_ I'd rather this just be cpu_feature_enabled(cid) rather than
using DISABLED_MASK_BIT_SET() directly.

But, I guess this probably also isn't a big deal for _most_ people.  Any
sane distro kernel will just set CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
since it's pretty widespread on modern CPUs and works across Intel and
AMD now.

