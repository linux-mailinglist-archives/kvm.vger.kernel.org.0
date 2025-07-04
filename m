Return-Path: <kvm+bounces-51552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB9BEAF8840
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEA9B3B5567
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58FE82627E9;
	Fri,  4 Jul 2025 06:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NlDIU6Hv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFD261586;
	Fri,  4 Jul 2025 06:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751611463; cv=none; b=HPBT4mIPHuc63iaCnakNy5C39qj3gPxgj1l2/cIO0roqDH2o30DV2vvrZKQxjdwQtR8QxYo8tRF9+a/9qvRqVlmOkF9WhQx7d4i1eJ5mqndKrueQhXhX+s/R0b8I+Y/xMiWI1LyxyUBFmcrpVtb/7qa5KStWwTeAROSAewxqIos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751611463; c=relaxed/simple;
	bh=oIBYSjEy8+jfQse5w4moT54WZuna8COxm+9MBf4blws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAlEcpGTgJZ/Irdp1nYxkY/dycN7C/0uVyPgnGhI1tjIhMx5i9jt3cfPQ0s2vNILcFmBS50SaIFuilrLppuKDkECVQ6n4JNzR2r8oXG75VW3C2ECtN/0O+1HE0gP8yViQebGQLAEYsn6o+dB1zBI0H9zJFrHwJTHQ3k6pM0y6Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NlDIU6Hv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751611462; x=1783147462;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oIBYSjEy8+jfQse5w4moT54WZuna8COxm+9MBf4blws=;
  b=NlDIU6Hv8w9DLavQFiliuaaYenVledKr6NgpFsAn7bP9ELsd/88lfX8H
   whTlowy/TKtx8C1QJnZ3pSeRrgDPDcwm93JHmBA0YRI+CjJlNAHVJbDvp
   mHw7VI2tipI+mY6A4ttrbStsYVtv9sBV99Bl5ITgpYGvob3u60NJpDcm+
   9o+PMfk2V9Vq6zqcjFff2WCfEQzYGhWlh1YE0ZDHYbTOokwvRkYwSrglp
   5ZU3PfejuW3lvQa9mvACtAs9PapdAaTrMOjoRAaNBjwV9CAYTW6b1mg3A
   V0/TFqxsKlb1lekJQR7NP6qy1/3BJvRaxliyBBw7e5m8ikNFyrOUEwDGM
   g==;
X-CSE-ConnectionGUID: kaH5oX0tSnaNjm2Um9KG8g==
X-CSE-MsgGUID: un0LNJpLTvq3O/pe4n8G/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="65394036"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="65394036"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:44:21 -0700
X-CSE-ConnectionGUID: TFja1sDeSbu0DzjcG/lfww==
X-CSE-MsgGUID: RnCiRpxzSByDv6yYK4Wspw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="158602598"
Received: from qliang3-mobl3.ccr.corp.intel.com (HELO [10.124.240.2]) ([10.124.240.2])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 23:44:16 -0700
Message-ID: <b61dfcbf-adfc-4572-8625-4b0a57023684@linux.intel.com>
Date: Fri, 4 Jul 2025 14:44:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Xiaoyao Li <xiaoyao.li@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin
 <hpa@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
 <d1cd2b34-9a3f-4dfc-93a2-2a20e9f16e1d@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <d1cd2b34-9a3f-4dfc-93a2-2a20e9f16e1d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 7/4/2025 9:32 AM, Xiaoyao Li wrote:
> On 7/3/2025 11:37 PM, Adrian Hunter wrote:
>> Avoid clearing reclaimed TDX private pages unless the platform is affected
>> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
>> time on unaffected systems.
>>
>> Background
>>
>> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
>>
>>     - Clears the TD Owner bit (which identifies TDX private memory) and
>>       integrity metadata without triggering integrity violations.
>>     - Clears poison from cache lines without consuming it, avoiding MCEs on
>>       access (refer TDX Module Base spec. 16.5. Handling Machine Check
>>       Events during Guest TD Operation).
>>
>> The TDX module also uses MOVDIR64B to initialize private pages before use.
>> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
>> However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
>> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
>>
>> In contrast, when private pages are reclaimed, the TDX Module handles
>> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
>>
>> Problem
>>
>> Clearing all private pages during VM shutdown is costly. For guests
>> with a large amount of memory it can take minutes.
>>
>> Solution
>>
>> TDX Module Base Architecture spec. documents that private pages reclaimed
>> from a TD should be initialized using MOVDIR64B, in order to avoid
>> integrity violation or TD bit mismatch detection when later being read
>> using a shared HKID, refer April 2025 spec. "Page Initialization" in
>> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
>> Initialization by the Host VMM"
>>
>> That is an overstatement and will be clarified in coming versions of the
>> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
>> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
>> Mode" in the same spec, there is no issue accessing such reclaimed pages
>> using a shared key that does not have integrity enabled. Linux always uses
>> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
>> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
>> description in "Intel Architecture Memory Encryption Technologies" spec
>> version 1.6 April 2025. So there is no need to clear pages to avoid
>> integrity violations.
>>
>> There remains a risk of poison consumption. However, in the context of
>> TDX, it is expected that there would be a machine check associated with the
>> original poisoning. On some platforms that results in a panic. However
>> platforms may support "SEAM_NR" Machine Check capability, in which case
>> Linux machine check handler marks the page as poisoned, which prevents it
>> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
>> Implement recovery for errors in TDX/SEAM non-root mode")
>>
>> Improvement
>>
>> By skipping the clearing step on unaffected platforms, shutdown time
>> can improve by up to 40%.
>>
>> On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
>> clearing because these platforms may trigger poison on partial writes to
>> previously-private pages, even with KeyID 0, refer commit 1e536e1068970
>> ("x86/cpu: Detect TDX partial write machine check erratum")
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>
>>
>> Changes in V2:
>>
>>     Improve the comment
>>
>>
>>   arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>> index 14d93ed05bd2..4fa86188aa40 100644
>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>> @@ -642,6 +642,14 @@ void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>>       const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>>       unsigned long phys, end;
>>   +    /*
>> +     * Typically, any write to the page will convert it from TDX
>> +     * private back to normal kernel memory. Systems with the
>> +     * erratum need to do the conversion explicitly.
>
> Can we call out that "system with erratum need to do the conversion explicitly via MOVDIR64B" ?

The original description of the function has mentioned it.
I am wondering if it's better to merge the comments to the function description?


>
> Without "via MOVDIR64B", it leads to the impression that explicit conversion with any write is OK for system with the erratum, and maybe the following code just happened to use movdir64b().
>
>> +     */
>> +    if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
>> +        return;
>> +
>>       end = base + size;
>>       for (phys = base; phys < end; phys += 64)
>>           movdir64b(__va(phys), zero_page);
>


