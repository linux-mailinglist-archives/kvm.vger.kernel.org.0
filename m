Return-Path: <kvm+bounces-2529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A6F7FAAF3
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:06:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ECA6281B4E
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EDB45BF0;
	Mon, 27 Nov 2023 20:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emmHap0E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2447D60;
	Mon, 27 Nov 2023 12:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701115553; x=1732651553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sLfmFDfnARUkdYgWbja6UI634BRfOfcrqLDCDQVh0CY=;
  b=emmHap0EActmNdPVR5ghUGPtJj/FAz5K9eLsMxbu5AeQ1vxWpNuxis6E
   FtzcOYj0E1sBV6MV1pO27uRuwCzuZdY5pCXns1Cz3t5tM/elFKviEDvU7
   OX0cHqNSB0vp5k0Q6A50AH1seVSda6jumRwhDl3FtSl2/dLEpj7c1WdAC
   Zqhdz/H/v/gOa7FJTp4ZltIorYOHUDnhw1ldhf3kTd6M0M5fnmj5N0HLw
   4sXANJdZDOiafXhndqbKJlaJffr3Pdtys2MFDPLPt9o5hzS4NpWrHN1Dc
   T2uDgiktUFaA2bLnun+JzjQVMvYpYJR1lKmp+Ke6Kv+IQcxPm/PafizC4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="383165225"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="383165225"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 12:05:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="16707389"
Received: from jdmart2-mobl1.amr.corp.intel.com (HELO [10.212.214.63]) ([10.212.214.63])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 12:05:51 -0800
Message-ID: <4ca2f6c1-97a7-4992-b01f-60341f6749ff@intel.com>
Date: Mon, 27 Nov 2023 12:05:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 17/23] x86/kexec: Flush cache of TDX private memory
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
 <2151c68079c1cb837d07bd8015e4ff1f662e1a6e.1699527082.git.kai.huang@intel.com>
 <cfea7192-4b29-46f9-a500-149121f493c8@intel.com>
 <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <e8fd4bff8244e9e709c997da309e73a932567959.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/23 11:33, Huang, Kai wrote:
> On Mon, 2023-11-27 at 10:13 -0800, Hansen, Dave wrote:
>> On 11/9/23 03:55, Kai Huang wrote:
>> ...
>>> --- a/arch/x86/kernel/reboot.c
>>> +++ b/arch/x86/kernel/reboot.c
>>> @@ -31,6 +31,7 @@
>>>  #include <asm/realmode.h>
>>>  #include <asm/x86_init.h>
>>>  #include <asm/efi.h>
>>> +#include <asm/tdx.h>
>>>
>>>  /*
>>>   * Power off function, if any
>>> @@ -741,6 +742,20 @@ void native_machine_shutdown(void)
>>>     local_irq_disable();
>>>     stop_other_cpus();
>>>  #endif
>>> +   /*
>>> +    * stop_other_cpus() has flushed all dirty cachelines of TDX
>>> +    * private memory on remote cpus.  Unlike SME, which does the
>>> +    * cache flush on _this_ cpu in the relocate_kernel(), flush
>>> +    * the cache for _this_ cpu here.  This is because on the
>>> +    * platforms with "partial write machine check" erratum the
>>> +    * kernel needs to convert all TDX private pages back to normal
>>> +    * before booting to the new kernel in kexec(), and the cache
>>> +    * flush must be done before that.  If the kernel took SME's way,
>>> +    * it would have to muck with the relocate_kernel() assembly to
>>> +    * do memory conversion.
>>> +    */
>>> +   if (platform_tdx_enabled())
>>> +           native_wbinvd();
>>
>> Why can't the TDX host code just set host_mem_enc_active=1?
>>
>> Sure, you'll end up *using* the SME WBINVD support, but then you don't
>> have two different WBINVD call sites.  You also don't have to mess with
>> a single line of assembly.
> 
> I wanted to avoid changing the assembly.
> 
> Perhaps the comment isn't very clear.  Flushing cache (on the CPU running kexec)
> when the host_mem_enc_active=1 is handled in the relocate_kernel() assembly,
> which happens at very late stage right before jumping to the new kernel.
> However for TDX when the platform has erratum we need to convert TDX private
> pages back to normal, which must be done after flushing cache.  If we reuse
> host_mem_enc_active=1, then we will need to change the assembly code to do that.

I honestly think you need to stop thinking about the partial write issue
at this point in the series.  It's really causing a horrible amount of
unnecessary confusion.

Here's the golden rule:

	The boot CPU needs to run WBINVD sometime after it stops writing
	to private memory but before it starts treating the memory as
	shared.

On SME kernels, that key point evidently in early boot when it's
enabling SME.  I _think_ that point is also a valid place to do WBINVD
on no-TDX-erratum systems.

On TDX systems with the erratum, there's a *second* point before the
private=>shared conversion occurs.  I think what you're trying to do
here is prematurely optimize the erratum-affected affected systems so
that they don't do two WBINVDs.  Please stop trying to do that.

This WBINVD is only _needed_ for the erratum.  It should be closer to
the actual erratum handing.

