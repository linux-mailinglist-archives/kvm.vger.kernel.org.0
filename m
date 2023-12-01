Return-Path: <kvm+bounces-3169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D18980148D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 21:36:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C0301C209D1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 20:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1155453E3E;
	Fri,  1 Dec 2023 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HLmEZvFk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F318310E5;
	Fri,  1 Dec 2023 12:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701462956; x=1732998956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LMf1fItzoZA3T76vtDhmr3DZRsMRth2RfoIKey8Owo0=;
  b=HLmEZvFkXHlwS9hobsZN10QXNY9JajhFBVtEg22WrDjVpukCdzcVkJqB
   WJ2xsk0oMqPm9XLfCGJ8N6PZZQqIJTVp5FJveNI1jBTE+T7FeYhJ4+XJL
   bvHESli7uhAexuFFVtrRVrwbN/dBLQkKFROx8gmqPQlDRu2YD5ANVn/gy
   v10+nmjcgadG3HoFiJlY5bBYuH7/Wc7Tlm6RFb317So+F6tFmQNQRKQ9z
   SFnzjyUE6efx7lYq8jdjEkq7tmG+gmJuB3J0Jl3WGoiuLdNoXP6iitH6W
   0Y/e+LAYPaG8vh38sI87bEUvRO6g+GBRlQ/5pckBL0UgcACG/hGroe3Sr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="390714800"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="390714800"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 12:35:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="773551436"
X-IronPort-AV: E=Sophos;i="6.04,242,1695711600"; 
   d="scan'208";a="773551436"
Received: from jturmaud-mobl1.amr.corp.intel.com (HELO [10.209.91.66]) ([10.209.91.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2023 12:35:53 -0800
Message-ID: <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
Date: Fri, 1 Dec 2023 12:35:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 22/23] x86/mce: Improve error log of kernel space TDX
 #MC due to erratum
Content-Language: en-US
To: Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: x86@kernel.org, kirill.shutemov@linux.intel.com, peterz@infradead.org,
 tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com, rafael@kernel.org,
 david@redhat.com, dan.j.williams@intel.com, len.brown@intel.com,
 ak@linux.intel.com, isaku.yamahata@intel.com, ying.huang@intel.com,
 chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 nik.borisov@suse.com, bagasdotme@gmail.com, sagis@google.com,
 imammedo@redhat.com
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/9/23 03:55, Kai Huang wrote:
> +static bool is_pamt_page(unsigned long phys)
> +{
> +	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
> +	int i;
> +
> +	/*
> +	 * This function is called from #MC handler, and theoretically
> +	 * it could run in parallel with the TDX module initialization
> +	 * on other logical cpus.  But it's not OK to hold mutex here
> +	 * so just blindly check module status to make sure PAMTs/TDMRs
> +	 * are stable to access.
> +	 *
> +	 * This may return inaccurate result in rare cases, e.g., when
> +	 * #MC happens on a PAMT page during module initialization, but
> +	 * this is fine as #MC handler doesn't need a 100% accurate
> +	 * result.
> +	 */

It doesn't need perfect accuracy.  But how do we know it's not going to
go, for instance, chase a bad pointer?

> +	if (tdx_module_status != TDX_MODULE_INITIALIZED)
> +		return false;

As an example, what prevents this CPU from observing
tdx_module_status==TDX_MODULE_INITIALIZED while the PAMT structure is
being assembled?

> +	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
> +		unsigned long base, size;
> +
> +		tdmr_get_pamt(tdmr_entry(tdmr_list, i), &base, &size);
> +
> +		if (phys >= base && phys < (base + size))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Return whether the memory page at the given physical address is TDX
> + * private memory or not.  Called from #MC handler do_machine_check().
> + *
> + * Note this function may not return an accurate result in rare cases.
> + * This is fine as the #MC handler doesn't need a 100% accurate result,
> + * because it cannot distinguish #MC between software bug and real
> + * hardware error anyway.
> + */
> +bool tdx_is_private_mem(unsigned long phys)
> +{
> +	struct tdx_module_args args = {
> +		.rcx = phys & PAGE_MASK,
> +	};
> +	u64 sret;
> +
> +	if (!platform_tdx_enabled())
> +		return false;
> +
> +	/* Get page type from the TDX module */
> +	sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
> +	/*
> +	 * Handle the case that CPU isn't in VMX operation.
> +	 *
> +	 * KVM guarantees no VM is running (thus no TDX guest)
> +	 * when there's any online CPU isn't in VMX operation.
> +	 * This means there will be no TDX guest private memory
> +	 * and Secure-EPT pages.  However the TDX module may have
> +	 * been initialized and the memory page could be PAMT.
> +	 */
> +	if (sret == TDX_SEAMCALL_UD)
> +		return is_pamt_page(phys);

Either this is comment is wonky or the module initialization is buggy.

config_global_keyid() goes and does SEAMCALLs on all CPUs.  There are
zero checks or special handling in there for whether the CPU has done
VMXON.  So, by the time we've started initializing the TDX module
(including the PAMT), all online CPUs must be able to do SEAMCALLs.  Right?

So how can we have a working PAMT here when this CPU can't do SEAMCALLs?

I don't think we should even bother with this complexity.  I think we
can just fix the whole thing by saying that unless you can make a
non-init SEAMCALL, we just assume the memory can't be private.

The transition to being able to make non-init SEAMCALLs is also #MC safe
*and* it's at a point when the tdmr_list is stable.

Can anyone shoot any holes in that? :)

