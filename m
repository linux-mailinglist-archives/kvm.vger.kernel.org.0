Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EA56A2604
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 01:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBYAwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBYAwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 19:52:32 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185AF5DCDB;
        Fri, 24 Feb 2023 16:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677286351; x=1708822351;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QyBNcXVGD289vqc1yYgpdvhNOZnTrxlg0aNx5AVie6U=;
  b=FZqR1OE+bApeUQw5t6glQeMdq0GGBuP4v+2OuPXkeF2in06MLb/Q1ySm
   6kBX/r/0Ml3H9gqg8Emqs1AWsMztPAhDAQm2/kLe/bWEDqBgCDaOBo9gu
   oNAxjo1G6oDTMSFws7zxKCNDdoRbmaWu9uw/kaQgq9mnh44igkzRKof5R
   48IGIMG3xCiaZc9nTOA8Wl+mM8s9g59h8XGj0gQUFDHIA43KP7dsEiiOx
   ayDq/ut0bpXF49rrEeNeGGEWcF8MWJu7LS9dD6BqHO64cpjwEH/cH4fuj
   AwvkIdEXS9adCu04KaaG/AOLZhbmlc05xlnil4Gjlf94Y4MULncFyRxOl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="361121505"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="361121505"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 16:52:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="815920415"
X-IronPort-AV: E=Sophos;i="5.97,326,1669104000"; 
   d="scan'208";a="815920415"
Received: from ydu6-mobl1.gar.corp.intel.com (HELO desk) ([10.209.68.79])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 16:52:29 -0800
Date:   Fri, 24 Feb 2023 16:52:21 -0800
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
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
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <20230225005221.425yahqvxb57c43x@desk>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/lUSC5x2ZkTIGu4@zn.tnic>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 01:20:24AM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 04:09:31PM -0800, Josh Poimboeuf wrote:
> > Ah, I had to stare it that for a bit to figure out how it works.
> 
> Yeah, it is a bit "hidden". :)
> 
> > setup_real_mode() reads MSR_EFER from the boot CPU and stores it in
> > trampoline_header->efer.  Then the other CPUs read that stored value in
> > startup_32() and write it into their MSR.
> 
> Exactly.
> 
> > Yeah, I think that would be good.  Otherwise it's rather magical.
> 
> Yap, see below.
> 
> > That EFER MSR is a surprising place to put that bit.
> 
> That MSR is very important on AMD. Consider it AMD's CR4. :-)
> 
> Thx.
> 
> ---
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> Date: Sat, 25 Feb 2023 01:11:31 +0100
> Subject: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
> 
> The AutoIBRS bit gets set only on the BSP as part of determining which
> mitigation to enable on AMD. Setting on the APs relies on the
> circumstance that the APs get booted through the trampoline and EFER
> - the MSR which contains that bit - gets replicated on every AP from the
> BSP.
> 
> However, this can change in the future and considering the security
> implications of this bit not being set on every CPU, make sure it is set
> by verifying EFER later in the boot process and on every AP.
> 
> Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
> Link: https://lore.kernel.org/r/20230224185257.o3mcmloei5zqu7wa@treble
> ---
>  arch/x86/kernel/cpu/amd.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 380753b14cab..de624c1442c2 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -996,6 +996,16 @@ static void init_amd(struct cpuinfo_x86 *c)
>  		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
>  
>  	check_null_seg_clears_base(c);
> +
> +	/*
> +	 * Make sure EFER[AIBRSE - Automatic IBRS Enable] is set. The APs are brought up
> +	 * using the trampoline code and as part of it, EFER gets prepared there in order
> +	 * to be replicated onto them. Regardless, set it here again, if not set, to protect
> +	 * against any future refactoring/code reorganization which might miss setting
> +	 * this important bit.
> +	 */
> +	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
> +		msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);

Is it intended to be set regardless of the spectre_v2 mitigation status?
