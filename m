Return-Path: <kvm+bounces-3390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5423D803B22
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AD081C2099A
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000F92E630;
	Mon,  4 Dec 2023 17:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cqjQZDeT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C62ABB;
	Mon,  4 Dec 2023 09:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701709642; x=1733245642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qOapASXW9sV5EN1o2BAcOJimFv0X/vGsorTUtaMTOWw=;
  b=cqjQZDeTeQMaVdp9c0M7CgAWVQ51Hahx0Bd9zJtgbSUVOVBJ48LaRrRW
   5Aw7fe0d1R7bR6oHQDsPGhh+B6XsAER4RQwwxLMOV4lf5uaCyQa2rypKb
   49D8C1l264/WmACUubnYV7f8bE0v0+LUymUX/6m/a3KMah/NdsAULWIb7
   D2decWzanCkH7l1hIe6T/GME3FQRhCLDVdxa5Md+9/zNpr9pAjLG4N1tL
   vkOaGTMQbahsVRsK2XiBRNT3Co8ExU8rocYYSP93HuGhVvmeSLBCXlyqz
   ZcdCLQyE5Txfc6j6w9cl0tjM3MP6DYRI86WexmV/eSu47UJrFefTsSGwE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="12480099"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="12480099"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 09:07:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="774316847"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="774316847"
Received: from gauravs1-mobl.amr.corp.intel.com (HELO [10.209.53.199]) ([10.209.53.199])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 09:07:18 -0800
Message-ID: <bcff605a-3b8d-4dcc-a5cb-63dab1a74ed4@intel.com>
Date: Mon, 4 Dec 2023 09:07:17 -0800
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
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "sathyanarayanan.kuppuswamy@linux.intel.com"
 <sathyanarayanan.kuppuswamy@linux.intel.com>,
 "Luck, Tony" <tony.luck@intel.com>, "david@redhat.com" <david@redhat.com>,
 "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
 "ak@linux.intel.com" <ak@linux.intel.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
 <hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
 "sagis@google.com" <sagis@google.com>,
 "imammedo@redhat.com" <imammedo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "Gao, Chao" <chao.gao@intel.com>, "Brown, Len" <len.brown@intel.com>,
 "rafael@kernel.org" <rafael@kernel.org>, "Huang, Ying"
 <ying.huang@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <cover.1699527082.git.kai.huang@intel.com>
 <9e80873fac878aa5d697cbcd4d456d01e1009d1f.1699527082.git.kai.huang@intel.com>
 <b3b265f9-48fa-4574-a925-cbdaaa44a689@intel.com>
 <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <afc875ace6f9f955557f5c7e811b3046278e4c51.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/23 03:44, Huang, Kai wrote:
...
>> It doesn't need perfect accuracy.  But how do we know it's not going to
>> go, for instance, chase a bad pointer?
>>
>>> +   if (tdx_module_status != TDX_MODULE_INITIALIZED)
>>> +           return false;
>>
>> As an example, what prevents this CPU from observing
>> tdx_module_status==TDX_MODULE_INITIALIZED while the PAMT structure is
>> being assembled?
> 
> There are two types of memory order serializing operations between assembling
> the TDMR/PAMT structure and setting the tdx_module_status to
> TDX_MODULE_INITIALIZED: 1) wbvind_on_all_cpus(); 2) bunch of SEAMCALLs;
> 
> WBINVD is a serializing instruction.  SEAMCALL is a VMEXIT to the TDX module,
> which involves GDT/LDT/control registers/MSRs switch so it is also a serializing
> operation.
> 
> But perhaps we can explicitly add a smp_wmb() between assembling TDMR/PAMT
> structure and setting tdx_module_status if that's better.

... and there's zero documentation of this dependency because ... ?

I suspect it's because it was never looked at until Tony made a comment
about it and we started looking at it.  In other words, it worked by
coincidence.

>>> +   for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
>>> +           unsigned long base, size;
>>> +
>>> +           tdmr_get_pamt(tdmr_entry(tdmr_list, i), &base, &size);
>>> +
>>> +           if (phys >= base && phys < (base + size))
>>> +                   return true;
>>> +   }
>>> +
>>> +   return false;
>>> +}
>>> +
>>> +/*
>>> + * Return whether the memory page at the given physical address is TDX
>>> + * private memory or not.  Called from #MC handler do_machine_check().
>>> + *
>>> + * Note this function may not return an accurate result in rare cases.
>>> + * This is fine as the #MC handler doesn't need a 100% accurate result,
>>> + * because it cannot distinguish #MC between software bug and real
>>> + * hardware error anyway.
>>> + */
>>> +bool tdx_is_private_mem(unsigned long phys)
>>> +{
>>> +   struct tdx_module_args args = {
>>> +           .rcx = phys & PAGE_MASK,
>>> +   };
>>> +   u64 sret;
>>> +
>>> +   if (!platform_tdx_enabled())
>>> +           return false;
>>> +
>>> +   /* Get page type from the TDX module */
>>> +   sret = __seamcall_ret(TDH_PHYMEM_PAGE_RDMD, &args);
>>> +   /*
>>> +    * Handle the case that CPU isn't in VMX operation.
>>> +    *
>>> +    * KVM guarantees no VM is running (thus no TDX guest)
>>> +    * when there's any online CPU isn't in VMX operation.
>>> +    * This means there will be no TDX guest private memory
>>> +    * and Secure-EPT pages.  However the TDX module may have
>>> +    * been initialized and the memory page could be PAMT.
>>> +    */
>>> +   if (sret == TDX_SEAMCALL_UD)
>>> +           return is_pamt_page(phys);
>>
>> Either this is comment is wonky or the module initialization is buggy.
>>
>> config_global_keyid() goes and does SEAMCALLs on all CPUs.  There are
>> zero checks or special handling in there for whether the CPU has done
>> VMXON.  So, by the time we've started initializing the TDX module
>> (including the PAMT), all online CPUs must be able to do SEAMCALLs.  Right?
>>
>> So how can we have a working PAMT here when this CPU can't do SEAMCALLs?
> 
> The corner case is KVM can enable VMX on all cpus, initialize the TDX module,
> and then disable VMX on all cpus.  One example is KVM can be unloaded after it
> initializes the TDX module.
> 
> In this case CPU cannot do SEAMCALL but PAMTs are already working :-)
> 
> However if SEAMCALL cannot be made (due to out of VMX), then the module can only
> be initialized or the initialization hasn't been tried, so both
> tdx_module_status and the tdx_tdmr_list are stable to access.

None of this even matters.  Let's remind ourselves how unbelievably
unlikely this is:

1. You're on an affected system that has the erratum
2. The KVM module gets unloaded, runs vmxoff
3. A kernel bug using a very rare partial write corrupts the PAMT
4. A second bug reads the PAMT consuming poison, #MC is generated
5. Enter #MC handler, SEAMCALL fails
6. #MC handler just reports a plain hardware error

The only thing even remotely wrong with this situation is that the
report won't pin the #MC on TDX.  Play stupid games (removing modules),
win stupid prizes (worse error message).

Can we dynamically mark a module as unsafe to remove?  If so, I'd
happily just say that we should make kvm_intel.ko unsafe to remove when
TDX is supported and move on with life.

tl;dr: I think even looking a #MC on the PAMT after the kvm module is
removed is a fool's errand.

