Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D13724257
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbjFFMif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 08:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236529AbjFFMic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 08:38:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1B810C3;
        Tue,  6 Jun 2023 05:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686055110; x=1717591110;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H/iH/hJMR3hBdZN5X97g2WPo8WuAVbo2nUSQSiOHU6s=;
  b=nxAl6eEkM0osgc4vsR9f1X6K/l6B8w9IVVnSAShDkD3KMWDEBTVa/32l
   qT479vaobQqZsy6SZZW0knkxNFF3aWpHP+conA8Prp6hsYoX5aVVkhEt+
   DkinxDtA3yGbMkigxPWKtTb8voKa1JMwbBQaPGJqQgxuc1BtIA3sxUbhU
   lpBb24hptoy+3S3vHc6Oq+t9SopOg29X8f7Qox421TDtrwyR4ePNCElaG
   vCWOBlglOq0Yjt9m9lbLQPwB1CtcU91rI/EMqe4K9EPl6VjbbNOY1OiE5
   OJAnaS1sadRswXrx30qAybrzTl93UvvHxbeeHwLlwo2OIsqpejO+pS2h6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="420200541"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="420200541"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:38:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="703144717"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="703144717"
Received: from rgraefe-mobl1.ger.corp.intel.com (HELO box.shutemov.name) ([10.252.58.173])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:38:24 -0700
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 5AB7D10A6A4; Tue,  6 Jun 2023 15:38:21 +0300 (+03)
Date:   Tue, 6 Jun 2023 15:38:21 +0300
From:   kirill.shutemov@linux.intel.com
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, dave.hansen@intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v11 04/20] x86/cpu: Detect TDX partial write machine
 check erratum
Message-ID: <20230606123821.exit7gyxs42dxotz@box.shutemov.name>
References: <cover.1685887183.git.kai.huang@intel.com>
 <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86f2a8814240f4bbe850f6a09fc9d0b934979d1b.1685887183.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 02:27:17AM +1200, Kai Huang wrote:
> TDX memory has integrity and confidentiality protections.  Violations of
> this integrity protection are supposed to only affect TDX operations and
> are never supposed to affect the host kernel itself.  In other words,
> the host kernel should never, itself, see machine checks induced by the
> TDX integrity hardware.
> 
> Alas, the first few generations of TDX hardware have an erratum.  A
> "partial" write to a TDX private memory cacheline will silently "poison"
> the line.  Subsequent reads will consume the poison and generate a
> machine check.  According to the TDX hardware spec, neither of these
> things should have happened.
> 
> Virtually all kernel memory accesses operations happen in full
> cachelines.  In practice, writing a "byte" of memory usually reads a 64
> byte cacheline of memory, modifies it, then writes the whole line back.
> Those operations do not trigger this problem.
> 
> This problem is triggered by "partial" writes where a write transaction
> of less than cacheline lands at the memory controller.  The CPU does
> these via non-temporal write instructions (like MOVNTI), or through
> UC/WC memory mappings.  The issue can also be triggered away from the
> CPU by devices doing partial writes via DMA.
> 
> With this erratum, there are additional things need to be done around
> machine check handler and kexec(), etc.  Similar to other CPU bugs, use
> a CPU bug bit to indicate this erratum, and detect this erratum during
> early boot.  Note this bug reflects the hardware thus it is detected
> regardless of whether the kernel is built with TDX support or not.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v10 -> v11:
>  - New patch
> 
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/kernel/cpu/intel.c        | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index cb8ca46213be..dc8701f8d88b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -483,5 +483,6 @@
>  #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
>  #define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
>  #define X86_BUG_SMT_RSB			X86_BUG(29) /* CPU is vulnerable to Cross-Thread Return Address Predictions */
> +#define X86_BUG_TDX_PW_MCE		X86_BUG(30) /* CPU may incur #MC if non-TD software does partial write to TDX private memory */
>  
>  #endif /* _ASM_X86_CPUFEATURES_H */
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1c4639588ff9..251b333e53d2 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -1552,3 +1552,24 @@ u8 get_this_hybrid_cpu_type(void)
>  
>  	return cpuid_eax(0x0000001a) >> X86_HYBRID_CPU_TYPE_ID_SHIFT;
>  }
> +
> +/*
> + * These CPUs have an erratum.  A partial write from non-TD
> + * software (e.g. via MOVNTI variants or UC/WC mapping) to TDX
> + * private memory poisons that memory, and a subsequent read of
> + * that memory triggers #MC.
> + */
> +static const struct x86_cpu_id tdx_pw_mce_cpu_ids[] __initconst = {
> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
> +	{ }
> +};
> +
> +static int __init tdx_erratum_detect(void)
> +{
> +	if (x86_match_cpu(tdx_pw_mce_cpu_ids))
> +		setup_force_cpu_bug(X86_BUG_TDX_PW_MCE);
> +
> +	return 0;
> +}
> +early_initcall(tdx_erratum_detect);

Initcall? Don't we already have a codepath to call it directly?
Maybe cpu_set_bug_bits()?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
