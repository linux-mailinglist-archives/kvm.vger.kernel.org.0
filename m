Return-Path: <kvm+bounces-64655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 313D7C89B74
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCEB13A96E6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716B1326931;
	Wed, 26 Nov 2025 12:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QjDJL9h1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F5214F125;
	Wed, 26 Nov 2025 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764159449; cv=none; b=rbpGbuF+MS5zuHuX0k+f7dHi6PUaXDNBvjl3UzHxD/5r2o0hcDVTRv8A9eLDni3F8qrs1CrLYDG9dHIFGfP3Aa3tnZ0Uhx+0cqCMUoHvmvspdC3hyMWIWsFJeQBCa0OGKKAZoNKwHi61OpUBfq3rhg00daAWqQHRU0d1f/dcJt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764159449; c=relaxed/simple;
	bh=Zi8Z/1JVVN5yj9xGlROnJ3igsOEtV3FzNhPX+qSZd4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LKv91cRc3SKBhdwOcwrOYsTBZxIBWCr2layJLxGUfLxoyBoE5s5jn6mlhlNxuJBXNPPuFN75vtCKo6DLJGAJHHvELkRvGR4iGagmwWrWb+VvDsKjCAqGUUnTGGXlL9qjo9GcqigU3XQKurmi7+5u6ncHLX1g1qITUZJoUYVWxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QjDJL9h1; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764159448; x=1795695448;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Zi8Z/1JVVN5yj9xGlROnJ3igsOEtV3FzNhPX+qSZd4o=;
  b=QjDJL9h11SL3aeBI8Bgf3HEB+HRtqrauPGIUw2kPNU7/fw7vmHTO3Y4a
   U1oa9RoadR9HWhkPhRuLjkczvprR8FjIMld7YCBXj8Axx+LzIKQI/JutH
   +PFmJqBbkxTXewSrGbv8gaYORXnAbeKnJbxQGNwLR0W57CwWst/2n/AGF
   18y581Nlw6myZMlT8jSnNNegPAkaJ2mT6XHIGr6gY4ZRtvtPZaC5edsDs
   2i3TTkUcf/Aj2couL5BU1NqCS5vMDakgAcRA6A8UpqgWyc47dRDroVol7
   Plz4PQUBue+U4fdYLVqTDIlXcaG5Iq1cmiHmp9ZWZCkai9tVKtVMcvU9p
   g==;
X-CSE-ConnectionGUID: qMgGnd0ySzy4GMrQVIwE/Q==
X-CSE-MsgGUID: ApuwK4ByTES4I20MZZnyXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="68784258"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="68784258"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 04:17:27 -0800
X-CSE-ConnectionGUID: 3xsZio4cQQarbrm46XbJVw==
X-CSE-MsgGUID: zraMlUiYRnS/P7RYYBLi6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192944295"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 04:17:23 -0800
Message-ID: <33fe9716-ef3b-42f3-9806-4bd23fed6949@intel.com>
Date: Wed, 26 Nov 2025 20:17:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/split_lock: Don't try to handle user split lock
 in TDX guest
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, linux-kernel@vger.kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Reinette Chatre <reinette.chatre@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, chao.p.peng@intel.com
References: <20251126100205.1729391-1-xiaoyao.li@intel.com>
 <20251126100205.1729391-2-xiaoyao.li@intel.com>
 <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <lvobu4gpfsjg63syubgy2jwcja72folflrst7bu2eqv6rhaqre@ttbkykphu32f>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/2025 7:25 PM, Kiryl Shutsemau wrote:
> On Wed, Nov 26, 2025 at 06:02:03PM +0800, Xiaoyao Li wrote:
>> When the host enables split lock detection feature, the split lock from
>> guests (normal or TDX) triggers #AC. The #AC caused by split lock access
>> within a normal guest triggers a VM Exit and is handled in the host.
>> The #AC caused by split lock access within a TDX guest does not trigger
>> a VM Exit and instead it's delivered to the guest self.
>>
>> The default "warning" mode of handling split lock depends on being able
>> to temporarily disable detection to recover from the split lock event.
>> But the MSR that disables detection is not accessible to a guest.
>>
>> This means that TDX guests today can not disable the feature or use
>> the "warning" mode (which is the default). But, they can use the "fatal"
>> mode.
>>
>> Force TDX guests to use the "fatal" mode.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> ---
>>   arch/x86/kernel/cpu/bus_lock.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/bus_lock.c b/arch/x86/kernel/cpu/bus_lock.c
>> index 981f8b1f0792..f278e4ea3dd4 100644
>> --- a/arch/x86/kernel/cpu/bus_lock.c
>> +++ b/arch/x86/kernel/cpu/bus_lock.c
>> @@ -315,9 +315,24 @@ void bus_lock_init(void)
>>   	wrmsrq(MSR_IA32_DEBUGCTLMSR, val);
>>   }
>>   
>> +static bool split_lock_fatal(void)
>> +{
>> +	if (sld_state == sld_fatal)
>> +		return true;
>> +
>> +	/*
>> +	 * TDX guests can not disable split lock detection.
>> +	 * Force them into the fatal behavior.
>> +	 */
>> +	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST))
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>   bool handle_user_split_lock(struct pt_regs *regs, long error_code)
>>   {
>> -	if ((regs->flags & X86_EFLAGS_AC) || sld_state == sld_fatal)
>> +	if ((regs->flags & X86_EFLAGS_AC) || split_lock_fatal())
>>   		return false;
> 
> Maybe it would be cleaner to make it conditional on
> cpu_model_supports_sld instead of special-casing TDX guest?
> 
> #AC on any platfrom when we didn't asked for it suppose to be fatal, no?

But TDX is the only one has such special non-architectural behavior.

For example, for normal VMs under KVM, the behavior is x86 
architectural. MSR_TEST_CTRL is not accessible to normal VMs, and no 
split lock #AC will be delivered to the normal VMs because it's handled 
by KVM.

>>   	split_lock_warn(regs->ip);
>>   	return true;
>> -- 
>> 2.43.0
>>
> 


