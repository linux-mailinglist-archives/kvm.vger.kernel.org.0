Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6257B6609AD
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 23:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAFWt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 17:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjAFWt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 17:49:27 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D503C0FF;
        Fri,  6 Jan 2023 14:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673045366; x=1704581366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Wx7/2xlsGHq0QW2ou9GvgJ90Ghw3fsOK3yqO6pk4BQQ=;
  b=fdcgp1Tkt44hqVE3/rkMCyt0POHvFeUSl96T/CnB0Bb1RYjK3bh1iQbJ
   Ee1oSUn96/RuneeWE3SdDe6U9iAD2AGeOvN2SH4wNjdBh+s4jthLyExsz
   PoTY8bp29WHreuxe/9vrRBbiQPsQ4OdkfKcs1QfbEvmpPz/wyXgorOzUU
   0uPmURdcQfpygn5eKVP6wvNrq2LXQisl60ouUFBMeKLo0TobtpBZhsSZD
   wdjmzIud9dVIrqvzI0rSZQPWrYbOJWCYnbC2FVWDcwAYH8GxC2r1skfAi
   rnWSqvToWe3tH5KpQ4gHXRXQd+ToZX7ZK4Am1rc3rXf6YK6vM4Giro9vm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="387040280"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="387040280"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:49:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="719340233"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="719340233"
Received: from xiangyuy-mobl.amr.corp.intel.com (HELO [10.212.251.186]) ([10.212.251.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 14:49:24 -0800
Message-ID: <9dca3a1d-eace-07ed-4cd2-09621912314a@intel.com>
Date:   Fri, 6 Jan 2023 14:49:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all
 packages
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
 <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/22 22:52, Kai Huang wrote:
> After the list of TDMRs and the global KeyID are configured to the TDX
> module, the kernel needs to configure the key of the global KeyID on all
> packages using TDH.SYS.KEY.CONFIG.
> 
> TDH.SYS.KEY.CONFIG needs to be done on one (any) cpu for each package.
> Also, it cannot run concurrently on different cpus, so just use
> smp_call_function_single() to do it one by one.
> 
> Note to keep things simple, neither the function to configure the global
> KeyID on all packages nor the tdx_enable() checks whether there's at
> least one online cpu for each package.  Also, neither of them explicitly
> prevents any cpu from going offline.  It is caller's responsibility to
> guarantee this.

OK, but does someone *actually* do this?

> Intel hardware doesn't guarantee cache coherency across different
> KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
> with KeyID 0) before the TDX module uses the global KeyID to access the
> PAMT.  Otherwise, those dirty cachelines can silently corrupt the TDX
> module's metadata.  Note this breaks TDX from functionality point of
> view but TDX's security remains intact.

	Intel hardware doesn't guarantee cache coherency across
	different KeyIDs.  The PAMTs are transitioning from being used
	by the kernel mapping (KeyId 0) to the TDX module's "global
	KeyID" mapping.

	This means that the kernel must flush any dirty KeyID-0 PAMT
	cachelines before the TDX module uses the global KeyID to access
	the PAMT.  Otherwise, if those dirty cachelines were written
	back, they would corrupt the TDX module's metadata.  Aside: This
	corruption would be detected by the memory integrity hardware on
	the next read of the memory with the global KeyID.  The result
	would likely be fatal to the system but would not impact TDX
	security.

> Following the TDX module specification, flush cache before configuring
> the global KeyID on all packages.  Given the PAMT size can be large
> (~1/256th of system RAM), just use WBINVD on all CPUs to flush.
> 
> Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
> used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
> to flush cache before freeing the PAMTs back to the kernel.

						s/need to// ^


> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ab961443fed5..4c779e8412f1 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -946,6 +946,66 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
>  	return ret;
>  }
>  
> +static void do_global_key_config(void *data)
> +{
> +	int ret;
> +
> +	/*
> +	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is a
> +	 * recoverable error).  Assume this is exceedingly rare and
> +	 * just return error if encountered instead of retrying.
> +	 */
> +	ret = seamcall(TDH_SYS_KEY_CONFIG, 0, 0, 0, 0, NULL, NULL);
> +
> +	*(int *)data = ret;
> +}
> +
> +/*
> + * Configure the global KeyID on all packages by doing TDH.SYS.KEY.CONFIG
> + * on one online cpu for each package.  If any package doesn't have any
> + * online

This looks like it stopped mid-sentence.

> + * Note:
> + *
> + * This function neither checks whether there's at least one online cpu
> + * for each package, nor explicitly prevents any cpu from going offline.
> + * If any package doesn't have any online cpu then the SEAMCALL won't be
> + * done on that package and the later step of TDX module initialization
> + * will fail.  The caller needs to guarantee this.
> + */

*Does* the caller guarantee it?

You're basically saying, "this code needs $FOO to work", but you're not
saying who *provides* $FOO.

> +static int config_global_keyid(void)
> +{
> +	cpumask_var_t packages;
> +	int cpu, ret = 0;
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	for_each_online_cpu(cpu) {
> +		int err;
> +
> +		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
> +					packages))
> +			continue;
> +
> +		/*
> +		 * TDH.SYS.KEY.CONFIG cannot run concurrently on
> +		 * different cpus, so just do it one by one.
> +		 */
> +		ret = smp_call_function_single(cpu, do_global_key_config, &err,
> +				true);
> +		if (ret)
> +			break;
> +		if (err) {
> +			ret = err;
> +			break;
> +		}
> +	}
> +
> +	free_cpumask_var(packages);
> +	return ret;
> +}
> +
>  static int init_tdx_module(void)
>  {
>  	/*
> @@ -998,19 +1058,46 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_pamts;
>  
> +	/*
> +	 * Hardware doesn't guarantee cache coherency across different
> +	 * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
> +	 * (associated with KeyID 0) before the TDX module can use the
> +	 * global KeyID to access the PAMT.  Given PAMTs are potentially
> +	 * large (~1/256th of system RAM), just use WBINVD on all cpus
> +	 * to flush the cache.
> +	 *
> +	 * Follow the TDX spec to flush cache before configuring the
> +	 * global KeyID on all packages.
> +	 */

I don't think this second paragraph adds very much clarity.


