Return-Path: <kvm+bounces-71747-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4GHDJzlrnmnnVAQAu9opvQ
	(envelope-from <kvm+bounces-71747-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:23:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 083BE1912DC
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 82DCE301FDB9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624A22BCF6C;
	Wed, 25 Feb 2026 03:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0YqMpnY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7802B217F33;
	Wed, 25 Feb 2026 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771989806; cv=none; b=gsEk/CfNLWoGsx3jrxGmAWv6wGbKuXdhAJt+Uy4zwKTpILlO0PG3dnINkLEVGf8U0fZDtEBGucTIcq1/tr+M4PhIpuHtEsp6iAgFipKJ1+kv2Av51C1ZPUyNDBSM/WRNIRrH353/gsMD10XzrILKNmWom1jpTaQqTaWZSCMqZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771989806; c=relaxed/simple;
	bh=fdPpGFsfhcNkYYJovguqzV2NDnvxyAskr7Q6U0zrLa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXXIPD8kuyhOUaKzsm31NbGlzPf4+1+Cp/55BHHaPJwrmmtf/Amab9AKoBXOeF63H2oCenFLP3T6Zc8kktjPOjbZ4PA5oleVgM3a2G5IAMpErXjAXDytXcuQVM3M4mo9AdMVzLxuylWm+DnJ9URYEMyxWBXjxpePOJ8hHEwSGFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0YqMpnY; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771989805; x=1803525805;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fdPpGFsfhcNkYYJovguqzV2NDnvxyAskr7Q6U0zrLa8=;
  b=J0YqMpnYNLEgPd6BwsuAn20qSBGqMbj1VAKJ4EALM6ycynmJhMzVm3CZ
   3wWXR9t7M1jKk4pB+YyO+eULilH+HmBD9BTeP0purdD2JD8SiZGSdFkaB
   V2FzmWGjwDvVwdyGM6zoXw4UcWWFFLaW5fC41Yv11cYYVPyaVmsOdoT9I
   b3CKzjz57Z/rPd3e+WCizySV4U9JGpVIEJQiEDREElhn0dQSYwhNT4B/D
   MmQZoaWNq+Qp1CclHaq11qLUCAPFBzTrpH3UfTZedjX+bQDU32N1eHCsI
   SCQ9EjU1ZSkF2RbRddDndgMPOdyuWg/gXWHyzIZOS8i/x42ioPi+b9JN+
   w==;
X-CSE-ConnectionGUID: 8aWQiwE0TFKkQ9mARqmNrA==
X-CSE-MsgGUID: YvbPVpxYQoic4vW5j32/Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="73065557"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="73065557"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 19:23:25 -0800
X-CSE-ConnectionGUID: G1BEvh1TRlGwfDlwnpSI8w==
X-CSE-MsgGUID: glHZXKZqRsyIuzSYpSo4Nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="220218433"
Received: from unknown (HELO [10.238.1.83]) ([10.238.1.83])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 19:23:21 -0800
Message-ID: <66336533-8bee-4219-9936-3163c7ce06bb@linux.intel.com>
Date: Wed, 25 Feb 2026 11:23:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: TDX: Set SIGNIFCANT_INDEX flag for supported CPUIDs
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 "changyuanl@google.com" <changyuanl@google.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, Binbin Wu
 <binbin.wu@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
 "kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "tglx@kernel.org" <tglx@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
References: <20260223214336.722463-1-changyuanl@google.com>
 <213d614fe73e183a230c8f4e0c8fa1cc3d45df39.camel@intel.com>
 <fd3b58fd-a450-471a-89a3-541c3f88c874@linux.intel.com>
 <aZ3LxD5XMepnU8jh@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <aZ3LxD5XMepnU8jh@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-71747-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: 083BE1912DC
X-Rspamd-Action: no action



On 2/25/2026 12:03 AM, Sean Christopherson wrote:
> On Tue, Feb 24, 2026, Binbin Wu wrote:
>> On 2/24/2026 9:57 AM, Edgecombe, Rick P wrote:
>>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>>> index 2d7a4d52ccfb4..0c524f9a94a6c 100644
>>>> --- a/arch/x86/kvm/vmx/tdx.c
>>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>>> @@ -172,9 +172,15 @@ static void td_init_cpuid_entry2(struct
>>>> kvm_cpuid_entry2 *entry, unsigned char i
>>>>  	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
>>>>  	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
>>>>  
>>>> -	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
>>>> +	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF) {
>>>>  		entry->index = 0;
>>>> +		entry->flags &= ~KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>>
>>> There are two callers of this. One is already zeroed, and the other has
>>> stack garbage in flags. But that second caller doesn't look at the
>>> flags so it is harmless. Maybe it would be simpler and clearer to just
>>> zero init the entry struct in that caller. Then you don't need to clear
>>> it here. Or alternatively set flags to zero above, and then add
>>> KVM_CPUID_FLAG_SIGNIFCANT_INDEX if needed. Rather than manipulating a
>>> single bit in a field of garbage, which seems weird.
> 
> +1, td_init_cpuid_entry2() should initialize flags to '0' and then set
> KVM_CPUID_FLAG_SIGNIFCANT_INDEX as appropriate.
> 
>>>> +	} else {
>>>> +		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>>> +	}
>>>>  
>>>> +	WARN_ON_ONCE(cpuid_function_is_indexed(entry->function) !=
>>>> +		     !!(entry->flags &
>>>> KVM_CPUID_FLAG_SIGNIFCANT_INDEX));
>>>
>>> It warns on leaf 0x23 for me. Is it intentional?
>>
>> I guess because the list in cpuid_function_is_indexed() is hard-coded
>> and 0x23 is not added into the list yet.
> 
> Yeah, I was anticipating that we'd run afoul of leaves that aren't known to
> the kernel.  FWIW, it looks like 0x24 is also indexed.
> 
>> It's fine for existing KVM code because cpuid_function_is_indexed() is
>> only used to check that if a CPUID entry is queried without index, it
>> shouldn't be included in the indexed list.
>>
>> But adding the consistency check here would cause compatibility issue.
>> Generally, if a new CPUID indexed function is added for some new CPU and
>> the TDX module reports it, KVM versions without the CPUID function in
>> the list will trigger the warning.
> 
> IMO, that's a good thing and working as intended.  WARNs aren't inherently evil.
> While the goal is to be WARN-free, in this case triggering the WARN if the TDX
> Module is updated (or new silicon arrives) is desirable, because it alerts us to
> that new behavior, so that we can go update KVM.

So it effectively leverages the TDX module's interface to retrieve the hardware
information to validate the hard-coded list.

Do we need to consider the panic_on_warn case? I guess the option will not be
enabled in a production environment?

> 
> But we should "fix" 0x23 and 0x24 before landing this patch.
> 


