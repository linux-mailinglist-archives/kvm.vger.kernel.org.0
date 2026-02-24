Return-Path: <kvm+bounces-71598-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ePO3MX9mnWlgPQQAu9opvQ
	(envelope-from <kvm+bounces-71598-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:51:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB22183FDC
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 09:51:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E6B23043AD1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BC9369205;
	Tue, 24 Feb 2026 08:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PrhLybBc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB2A286A9;
	Tue, 24 Feb 2026 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771923051; cv=none; b=kxUuxvrF9qzBrVUSf0AQeXiFa3sl+hU4g+ehde2D4Zbzh0CBNmCEOO51TeMLCkwrtxr8e1t+TUiXjgcFolK/EKrMcFhPX8zQOzTHdBErg4HkPVfL4qfXKqpR0UxOWdGXLiF5tn1saFQzYH675qGaknissIsfuehm8QdLTRfezCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771923051; c=relaxed/simple;
	bh=C75KOvvjHFWqov1guLEmtGNejIuoHElmRmt3toQluh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpHgUEr3jbaPBEROWVXoa6+ApgWIRBfXPdSbCkKVMaf9Iv4Svm/vC7Mgu1GVyZb9b0ifKi4PQ9CsbAoXpKkvLiOkX4A6kdUsakfqQTFhmqe+qItMlDa/KeMTvvX6MelpDKo8wXQAuJTdyayQ4iJIQVx8PqsAiFApldzU9Jqp1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PrhLybBc; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771923050; x=1803459050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C75KOvvjHFWqov1guLEmtGNejIuoHElmRmt3toQluh0=;
  b=PrhLybBcgfLEAWpWtqsbpbepWlFGhlEsFCCqUUVdEBJqMb4ho5wzes7d
   mrze6VTpAcuneV+6/vIQ5jpt1O1FNfzYbTmI8yrrR0xVL/f6w+iD5/zDF
   0Px/6j08jMH3J/E5+FziASZXhxTBTorDuUmkXlyOJnTwdxycth9V7qRzG
   nR13LADdl9cbvQJNemAJrzqS1MBW/P4R16n9EL81sDv6I0uTa4QeEqsT3
   W7o4sX8MBmU31eF/EU5BleKknJSG6+y8YK5JP9MC9xivpyWh3IYTlHTKb
   b6eW44iNz1BaCsEFGdpWC1DR8e8cMk58IGwWT2YysLi7a0nqJd+p1/+AA
   g==;
X-CSE-ConnectionGUID: whH/6VoaR8m9RHPltb0FAQ==
X-CSE-MsgGUID: JaZIDVSXTKC/wgMtlcJ70A==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76792981"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="76792981"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 00:50:49 -0800
X-CSE-ConnectionGUID: lXzU1TXXQJSjwmAmcNrmIA==
X-CSE-MsgGUID: gv5EC7wERniXtS/dN3xTRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="253567991"
Received: from unknown (HELO [10.238.1.83]) ([10.238.1.83])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 00:50:45 -0800
Message-ID: <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
Date: Tue, 24 Feb 2026 16:50:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "changyuanl@google.com" <changyuanl@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "tglx@kernel.org" <tglx@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <20260223214336.722463-1-changyuanl@google.com>
 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-71598-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:dkim,linux.intel.com:mid]
X-Rspamd-Queue-Id: 4BB22183FDC
X-Rspamd-Action: no action



On 2/24/2026 9:57 AM, Edgecombe, Rick P wrote:
> +binbin
> 
> On Mon, 2026-02-23 at 13:43 -0800, Changyuan Lyu wrote:
>> Set the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag in the kvm_cpuid_entry2
>> structures returned by KVM_TDX_CAPABILITIES if the CPUID is indexed.
>> This ensures consistency with the CPUID entries returned by
>> KVM_GET_SUPPORTED_CPUID.
>>
>> Additionally, add a WARN_ON_ONCE() to verify that the TDX module's
>> reported entries align with KVM's expectations regarding indexed
>> CPUID functions.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
>> ---
>>  arch/x86/kvm/vmx/tdx.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 2d7a4d52ccfb4..0c524f9a94a6c 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -172,9 +172,15 @@ static void td_init_cpuid_entry2(struct
>> kvm_cpuid_entry2 *entry, unsigned char i
>>  	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
>>  	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
>>  
>> -	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
>> +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF) {
>>  		entry->index = 0;
>> +		entry->flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> 
> There are two callers of this. One is already zeroed, and the other has
> stack garbage in flags. But that second caller doesn't look at the
> flags so it is harmless. Maybe it would be simpler and clearer to just
> zero init the entry struct in that caller. Then you don't need to clear
> it here. Or alternatively set flags to zero above, and then add
> KVM_CPUID_FLAG_SIGNIFCANT_INDEX if needed. Rather than manipulating a
> single bit in a field of garbage, which seems weird.
> 
>> +	} else {
>> +		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>> +	}
>>  
>> +	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=
>> +		     !!(entry->flags &
>> KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
> 
> It warns on leaf 0x23 for me. Is it intentional?

I guess because the list in cpuid_function_is_indexed() is hard-coded
and 0x23 is not added into the list yet.

It's fine for existing KVM code because cpuid_function_is_indexed() is
only used to check that if a CPUID entry is queried without index, it
shouldn't be included in the indexed list.

But adding the consistency check here would cause compatibility issue.
Generally, if a new CPUID indexed function is added for some new CPU and
the TDX module reports it, KVM versions without the CPUID function in
the list will trigger the warning.


> 
> This warning kind of begs the question of how how much consistency
> there should be between KVM_TDX_CAPABILITIES and
> KVM_GET_SUPPORTED_CPUID. There was quite a bit of debate on this and in
> the end we moved forward with a solution that did the bare minimum
> consistency checking.
> 
> We actually have been looking at some potential TDX module changes to
> fix the deficiencies from not enforcing the consistency. But didn't
> consider this pattern. Can you explain more about the failure mode?  
> 
>>  	/*
>>  	 * The TDX module doesn't allow configuring the guest phys
>> addr bits
>>  	 * (EAX[23:16]).  However, KVM uses it as an interface to
>> the userspace
>> --
> 


