Return-Path: <kvm+bounces-30147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B4C9B73F8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 05:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E93E01C23116
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 04:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159CA13D8B4;
	Thu, 31 Oct 2024 04:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PQAlH1PV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D679E13CA8A;
	Thu, 31 Oct 2024 04:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730350583; cv=none; b=NhlatDjoY6dJjnbPNKR+Ez9CLSR/twyCiI/OfYkR1gnJ1LvUF8SFYiLmtq1KWCoL0FBdV9wN4Y6sxzQ/2tJed6zcz50gh92wi/4mgPBgowXIfyT5GQQMpmjJaj/Cn7Ile6m5N8RpOIBAiOgA+cnktBg3lU1uemFhAI/LGcar1Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730350583; c=relaxed/simple;
	bh=flCsxwyjLE26j5Y/rFURu6azx7PHBiVzA7lT9R6aWno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jqA++0Km3OFLuLGNltbikuW3DiMtLcRnCerc+Z5MMhLShmYs0nGbY1M/1nITxIgsuSIi9PANwH9swxZ13coHFHg4JCJiP0m/eZ9zYkw/uM0K2k4RnCrS7NnGCPwZH0Ti3Tinb3Ldzqf6grnHAxPsW2IxNCh2kw7ZGJsg0lcIa+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PQAlH1PV; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730350582; x=1761886582;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=flCsxwyjLE26j5Y/rFURu6azx7PHBiVzA7lT9R6aWno=;
  b=PQAlH1PVNjPkF/GFCrTBeQd2CbapX86YRF3Msi0JanXtQgKVlDK0f3LZ
   y1W1TTnWhCwlKQKYjDs9nVdKfgprfd6MRE6XNFQ2qOB/5H7rz7OWE49Rr
   ZQjyIF04jiIHHe7XzoKWc1lkfy4DhfxvYYlInUtHRGjriBR0DfhDuoRtt
   b9K27vwI6YhCCDOW1I9uecUOaUcGFKKxEBa7Gc3uWt8dgp/e25pnd3qh5
   uWPFFXePVJdDYi0GsVrOqMya54rCN/4WZTv47C1LZar7K1cK03TwnFL3B
   TCuZxUEwF1+R4lEQc+ECLN0yTdrN3PO5SV3vPE5m1EgWhzBUS9lg4o+yd
   g==;
X-CSE-ConnectionGUID: NoyoBI+OQ/6NYnmqqD2neg==
X-CSE-MsgGUID: oc1MAIenS6acsvs9lHBJYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="33866738"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="33866738"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 21:56:20 -0700
X-CSE-ConnectionGUID: lA4uBXjaQHKh9JmtN8S87w==
X-CSE-MsgGUID: aTI7/ZNRSrSJJBM/3DXaWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="82172371"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 21:56:17 -0700
Message-ID: <4734379d-97c4-44c8-ae40-be46da6e6239@linux.intel.com>
Date: Thu, 31 Oct 2024 12:56:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 isaku.yamahata@intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 yuan.yao@linux.intel.com, xiaoyao.li@intel.com
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZyKbxTWBZUdqRvca@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 10/31/2024 4:49 AM, Sean Christopherson wrote:
> On Mon, Aug 26, 2024, Binbin Wu wrote:
>> Check whether a KVM hypercall needs to exit to userspace or not based on
>> hypercall_exit_enabled field of struct kvm_arch.
>>
>> Userspace can request a hypercall to exit to userspace for handling by
>> enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
>> hypercall_exit_enabled.  Make the check code generic based on it.
>>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Reviewed-by: Kai Huang <kai.huang@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 5 +++--
>>   arch/x86/kvm/x86.h | 4 ++++
>>   2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 966fb301d44b..e521f14ad2b2 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10220,8 +10220,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>>   
>>   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>> -		/* MAP_GPA tosses the request to the user space. */
>> +	/* Check !ret first to make sure nr is a valid KVM hypercall. */
>> +	if (!ret && user_exit_on_hypercall(vcpu->kvm, nr))
> I don't love that the caller has to re-check for user_exit_on_hypercall().
Agree, it is not ideal.

But if __kvm_emulate_hypercall() returns 0 to indicate user exit and 1 to
indicate success, then the callers have to convert the return code to set
return value for guest.  E.g., TDX code also needs to do the conversion.

> I also don't love that there's a surprising number of checks lurking in
> __kvm_emulate_hypercall(), e.g. that CPL==0, especially since the above comment
> about "a valid KVM hypercall" can be intrepreted as meaning KVM is *only* checking
> if the hypercall number is valid.
>
> E.g. my initial reaction was that we could add a separate path for userspace
> hypercalls, but that would be subtly wrong.  And my second reaction was to hoist
> the common checks out of __kvm_emulate_hypercall(), but then I remembered that
> the only reason __kvm_emulate_hypercall() is separate is to allow it to be called
> by TDX with different source/destionation registers.
>
> So, I'm strongly leaning towards dropping the above change, squashing the addition
> of the helper with patch 2, and then landing this on top.
>
> Thoughts?
I have no strong preference and OK with the proposal below.

Just some cases, which don't get the return value right as pointed by Kai
in another thread.
https://lore.kernel.org/kvm/3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com/


>
> --
> Subject: [PATCH] KVM: x86: Use '0' in __kvm_emulate_hypercall()  to signal
>   "exit to userspace"
>
> Rework __kvm_emulate_hypercall() to use '0' to indicate an exit to
> userspace instead of relying on the caller to manually check for success
> *and* if user_exit_on_hypercall() is true.  Use '1' for "success" to
> (mostly) align with KVM's de factor return codes, where '0' == exit to
> userspace, '1' == resume guest, and -errno == failure.  Unfortunately,
> some of the PV error codes returned to the guest are postive values, so
> the pattern doesn't exactly match KVM's "standard", but it should be close
> enough to be intuitive for KVM readers.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 21 +++++++++++++++------
>   1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e09daa3b157c..5fdeb58221e2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10024,7 +10024,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   
>   	switch (nr) {
>   	case KVM_HC_VAPIC_POLL_IRQ:
> -		ret = 0;
> +		ret = 1;
>   		break;
>   	case KVM_HC_KICK_CPU:
>   		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
> @@ -10032,7 +10032,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   
>   		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
>   		kvm_sched_yield(vcpu, a1);
> -		ret = 0;
> +		ret = 1;
>   		break;
>   #ifdef CONFIG_X86_64
>   	case KVM_HC_CLOCK_PAIRING:
> @@ -10050,7 +10050,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   			break;
>   
>   		kvm_sched_yield(vcpu, a0);
> -		ret = 0;
> +		ret = 1;
>   		break;
>   	case KVM_HC_MAP_GPA_RANGE: {
>   		u64 gpa = a0, npages = a1, attrs = a2;
> @@ -10111,12 +10111,21 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>   
>   	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	if (!ret)
>   		return 0;
>   
> -	if (!op_64_bit)
> +	/*
> +	 * KVM's ABI with the guest is that '0' is success, and any other value
> +	 * is an error code.  Internally, '0' == exit to userspace (see above)
> +	 * and '1' == success, as KVM's de facto standard return codes are that
> +	 * plus -errno == failure.  Explicitly check for '1' as some PV error
> +	 * codes are positive values.
> +	 */
I didn't understand the last sentence:
"Explicitly check for '1' as some PV error codes are positive values."

The functions called in __kvm_emulate_hypercall() for PV features return
-KVM_EXXX for error code.
Did you mean the functions like kvm_pv_enable_async_pf(), which return
1 for error, would be called in __kvm_emulate_hypercall() in the future?
If this is the concern, then we cannot simply convert 1 to 0 then.

> +	if (ret == 1)
> +		ret = 0;
> +	else if (!op_64_bit)
>   		ret = (u32)ret;
> +
>   	kvm_rax_write(vcpu, ret);
>   
>   	return kvm_skip_emulated_instruction(vcpu);
>
> base-commit: 675248928970d33f7fc8ca9851a170c98f4f1c4f


