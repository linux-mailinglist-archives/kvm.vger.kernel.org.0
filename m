Return-Path: <kvm+bounces-30564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DA29BBC40
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 18:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00BDD280D08
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 17:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873041C8767;
	Mon,  4 Nov 2024 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XCc9cDXj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C611C82E3;
	Mon,  4 Nov 2024 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730742312; cv=none; b=e1FeF0CoHQgukeBKrWUTcbjU9Nc3ryUAm+3HVEajH+p6/NaVep091VtoTafBMBn6hHMEZdplc18V9Hopv8PNps3kcbYAeACjPXWPIF6DYtMf+ex6KM7S1yD/4uC1uEY2H33Ujj5V7Ftxsd7HH4kbK4LcZU/xNJH3kFxPjI1eNgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730742312; c=relaxed/simple;
	bh=xcQoMFiBVD3g2XkuqAPHBMlnjC9d6uSuEzVw7iBxDZw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cls8EivJUIPdBFY952bt6FopJJh2Pysh8Hkv+T/CQdEdLLaQT79ctEMGd9+z3IWQaXVljbrv6nlTy58ZsGew50vAAuJ7cZuQPOJvegOsK8WP6a//BUFzGCVDZbNfjYaMC6ZMuj01oM9qr5uYXqElegbMqB8PBgkDNuai6fjBkzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XCc9cDXj; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730742307; x=1762278307;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xcQoMFiBVD3g2XkuqAPHBMlnjC9d6uSuEzVw7iBxDZw=;
  b=XCc9cDXjyD+teXROQp/e+1iTx/MD5z4Q1ufUnTHgkzidnrpjWNe7RZRv
   vSqWP6Qd5sDxN6QmvQMkJb1OMlgWBrhUTla7xUVeWiKMREgRzpmvSpVEb
   dEY031lJcLLGcREe2U1p7oPAkBUJuem/NZ0P0OIMBgNssidGLqJrD3N0D
   EScemq9F6MpV/Lt0fUMPI19ee7rBdQ7g5uv3b8WZLMw9DU2CoeGPGDdyk
   Izx/mMl1m/M0pRiYdsY/tWI5kAMmT6UG/xKYQdh446addLLWnHrLhQCCk
   V5eBNJ4eLSvA2U3Nu24yUv938HFyiGpzLOGYMBdncU7D41sxc5rDpt3SI
   g==;
X-CSE-ConnectionGUID: VkcD1WwMSuCX5XulJmlQkA==
X-CSE-MsgGUID: umDpI7OpRDmLA0mr8j7hnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="29878488"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="29878488"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 09:45:06 -0800
X-CSE-ConnectionGUID: 9PevOESPSy2B07B3+FQoyQ==
X-CSE-MsgGUID: rXFH/nHHRrqb2kApwnEQ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83835371"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.221.97]) ([10.124.221.97])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 09:45:05 -0800
Message-ID: <62063466-69bc-4eca-9f22-492c70b02250@intel.com>
Date: Mon, 4 Nov 2024 09:45:04 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
To: "Shah, Amit" <Amit.Shah@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
 "kai.huang@intel.com" <kai.huang@intel.com>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Moger, Babu"
 <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
 "Kaplan, David" <David.Kaplan@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
 <20241031153925.36216-2-amit@kernel.org>
 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
 <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
 <bb90dce4-8963-476a-900b-40c3c00d8aac@intel.com>
 <b79c02aab50080cc8bee132eb5a0b12c42c4be06.camel@amd.com>
 <53c918b4-2e03-4f68-b3f3-d18f62d5805c@intel.com>
 <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
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
In-Reply-To: <3ac6da4a8586014925057a413ce46407b9699fa9.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/24 09:22, Shah, Amit wrote:
>> I think you're wrong.  We can't depend on ERAPS for this.  Linux 
>> doesn't flush the TLB on context switches when PCIDs are in play.
>> Thus, ERAPS won't flush the RSB and will leave bad state in there
>> and will leave the system vulnerable.
>>
>> Or what am I missing?
> I just received confirmation from our hardware engineers on this too:
> 
> 1. the RSB is flushed when CR3 is updated
> 2. the RSB is flushed when INVPCID is issued (except type 0 - single
> address).
> 
> I didn't mention 1. so far, which led to your question, right?  

Not only did you not mention it, you said something _completely_
different.  So, where the documentation for this thing?  I dug through
the 57230 .zip file and I see the CPUID bit:

	24 ERAPS. Read-only. Reset: 1. Indicates support for enhanced
		  return address predictor security.

but nothing telling us how it works.

> Does this now cover all the cases?

Nope, it's worse than I thought.  Look at:

> SYM_FUNC_START(__switch_to_asm)
...
>         FILL_RETURN_BUFFER %r12, RSB_CLEAR_LOOPS, X86_FEATURE_RSB_CTXSW

which does the RSB fill at the same time it switches RSP.

So we feel the need to flush the RSB on *ALL* task switches.  That
includes switches between threads in a process *AND* switches over to
kernel threads from user ones.

So, I'll flip this back around.  Today, X86_FEATURE_RSB_CTXSW zaps the
RSB whenever RSP is updated to a new task stack.  Please convince me
that ERAPS provides superior coverage or is unnecessary in all the
possible combinations switching between:

	different thread, same mm
	user=>kernel, same mm
	kernel=>user, same mm
	different mm (we already covered this)

Because several of those switches can happen without a CR3 write or INVPCID.

