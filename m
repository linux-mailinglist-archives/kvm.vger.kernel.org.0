Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3AD636EEF
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiKXA3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKXA3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:29:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF934D2282;
        Wed, 23 Nov 2022 16:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669249737; x=1700785737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7iJeUEYffRwAZrB5OROPBwpZSEw2VkisKwUL2idoEgk=;
  b=VRvFBdW7D2ZqleIYbOxZLp17DYWAFG/SN8lBmCs5FVlp4d8IHeDY4tLX
   oQm/5zGRKQOUkRUja3GQo3ExenPIPUOLfhZuwSgfkA4EbkEwBqOdv7SdT
   1+2KZ9Y6YbSirD76V7UwMXUTtTkY7ZMKemJLGchKRExgV1rAejLOWVWS/
   +ZtqYGUz4LaeVZor4li1ls2HG/fWjMN2AnJvlEj8E2b+NE6wxmA62ihpK
   SsadV+WpxBEqQ58dF5S+4lTpGfPCBBSBYy5Ig0oNq0tK+P4SeR78hKeTy
   R9hmFt4bNhK+CEmW6wOZ+ZWDWId2IlC5r7QlihOUJhGB3FBAXW0r8mExy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294571425"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294571425"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:28:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="748003079"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="748003079"
Received: from vcbudden-mobl3.amr.corp.intel.com (HELO [10.212.129.67]) ([10.212.129.67])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 16:28:55 -0800
Message-ID: <001d826d-a644-37ef-6b6d-729be14fe5ca@intel.com>
Date:   Wed, 23 Nov 2022 16:28:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 17/20] x86/virt/tdx: Configure global KeyID on all
 packages
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
References: <cover.1668988357.git.kai.huang@intel.com>
 <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <8d8285cc5efa6302cf42a3fe2c9153d1a9dbcdac.1668988357.git.kai.huang@intel.com>
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

On 11/20/22 16:26, Kai Huang wrote:
> After the array of TDMRs and the global KeyID are configured to the TDX
> module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
> on all packages.
> 
> TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
> it cannot run concurrently on different CPUs.  Implement a helper to
> run SEAMCALL on one cpu for each package one by one, and use it to
> configure the global KeyID on all packages.

This has the same problems as SYS.LP.INIT.  It's basically snake oil in
some TDX configurations.

This really only needs to be done when the TDX module has memory
mappings on a socket for which it needs to use the "global KeyID".  If
there's no PAMT on a socket, there are probably no allocations there to
speak of and no *technical* reason to call TDH.SYS.KEY.CONFIG on that
socket.  At least none I can see.

So, let's check up on this requirement as well.  This could also turn
out to be a real pain if all the CPUs on a socket are offline.

> Intel hardware doesn't guarantee cache coherency across different
> KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
> with KeyID 0) before the TDX module uses the global KeyID to access the
> PAMT.  Following the TDX module specification, flush cache before
> configuring the global KeyID on all packages.

I think it's probably worth an aside here about why TDX security isn't
dependent on this step.  I *think* it boils down to the memory integrity
protections.  If the caches aren't flushed, a dirty KeyID-0 cacheline
could be written back to RAM.  The TDX module would come along later and
read the cacheline using KeyID-whatever, get an integrity mismatch,
machine check, and then everyone would be sad.

Everyone is sad, but TDX security remains intact because memory
integrity saved us.

Is it memory integrity or the TD bit, actually?

> Given the PAMT size can be large (~1/256th of system RAM), just use
> WBINVD on all CPUs to flush.

<sigh>

> Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
> used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
> to flush cache before freeing the PAMTs back to the kernel.  Note using
> MOVDIR64B (which changes the page's associated KeyID from the old TDX
> private KeyID back to KeyID 0, which is used by the kernel) to clear
> PMATs isn't needed, as the KeyID 0 doesn't support integrity check.

I hope this is covered in the code well.

> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 3a032930e58a..99d1be5941a7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -224,6 +224,46 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
>  	on_each_cpu(seamcall_smp_call_function, sc, true);
>  }
>  
> +/*
> + * Call one SEAMCALL on one (any) cpu for each physical package in
> + * serialized way.  Return immediately in case of any error if
> + * SEAMCALL fails on any cpu.
> + *
> + * Note for serialized calls 'struct seamcall_ctx::err' doesn't have
> + * to be atomic, but for simplicity just reuse it instead of adding
> + * a new one.
> + */
> +static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
> +{
> +	cpumask_var_t packages;
> +	int cpu, ret = 0;
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> +		return -ENOMEM;
> +
> +	for_each_online_cpu(cpu) {
> +		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
> +					packages))
> +			continue;
> +
> +		ret = smp_call_function_single(cpu, seamcall_smp_call_function,
> +				sc, true);
> +		if (ret)
> +			break;
> +
> +		/*
> +		 * Doesn't have to use atomic_read(), but it doesn't
> +		 * hurt either.
> +		 */

I don't think you need to cover this twice.  Just do it in one comment.

> +		ret = atomic_read(&sc->err);
> +		if (ret)
> +			break;
> +	}
> +
> +	free_cpumask_var(packages);
> +	return ret;
> +}
> +
>  static int tdx_module_init_cpus(void)
>  {
>  	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_INIT };
> @@ -1010,6 +1050,22 @@ static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
>  	return ret;
>  }
>  
> +static int config_global_keyid(void)
> +{
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
> +
> +	/*
> +	 * Configure the key of the global KeyID on all packages by
> +	 * calling TDH.SYS.KEY.CONFIG on all packages in a serialized
> +	 * way as it cannot run concurrently on different CPUs.
> +	 *
> +	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
> +	 * a recoverable error).  Assume this is exceedingly rare and
> +	 * just return error if encountered instead of retrying.
> +	 */
> +	return seamcall_on_each_package_serialized(&sc);
> +}
> +
>  /*
>   * Detect and initialize the TDX module.
>   *
> @@ -1098,15 +1154,44 @@ static int init_tdx_module(void)
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
> +	wbinvd_on_all_cpus();
> +
> +	/* Config the key of global KeyID on all packages */
> +	ret = config_global_keyid();
> +	if (ret)
> +		goto out_free_pamts;
> +
>  	/*
>  	 * Return -EINVAL until all steps of TDX module initialization
>  	 * process are done.
>  	 */
>  	ret = -EINVAL;
>  out_free_pamts:
> -	if (ret)
> +	if (ret) {
> +		/*
> +		 * Part of PAMT may already have been initialized by

						s/initialized/written/

> +		 * TDX module.  Flush cache before returning PAMT back
> +		 * to the kernel.
> +		 *
> +		 * Note there's no need to do MOVDIR64B (which changes
> +		 * the page's associated KeyID from the old TDX private
> +		 * KeyID back to KeyID 0, which is used by the kernel),
> +		 * as KeyID 0 doesn't support integrity check.
> +		 */

MOVDIR64B is the tiniest of implementation details and also not the only
way to initialize memory integrity metadata.

Just keep this high level:

		* No need to worry about memory integrity checks here.
		* KeyID 0 has integrity checking disabled.

> +		wbinvd_on_all_cpus();
>  		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
> -	else
> +	} else
>  		pr_info("%lu pages allocated for PAMT.\n",
>  				tdmrs_count_pamt_pages(tdmr_array, tdmr_num));
>  out_free_tdmrs:
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index c26bab2555ca..768d097412ab 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -15,6 +15,7 @@
>  /*
>   * TDX module SEAMCALL leaf functions
>   */
> +#define TDH_SYS_KEY_CONFIG	31
>  #define TDH_SYS_INFO		32
>  #define TDH_SYS_INIT		33
>  #define TDH_SYS_LP_INIT		35

