Return-Path: <kvm+bounces-34978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FA5AA08633
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 05:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBA071889609
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 04:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7774B2063C3;
	Fri, 10 Jan 2025 04:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mjm861TN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840AF1A9B45;
	Fri, 10 Jan 2025 04:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736483383; cv=none; b=LjjhaF5nas9gllOpGE7UITWVAjy+fRP2kwa0TgnRrywrMaxebR3qzRPFQR3s9YwwRW7LXR+Bed4SvWzWAfuigOdOT6kqv65zVyESYeHPhchfC3dFgzsx2D0FtR6zeVovXJThDulJISam3o+qdr0FAg+QUtx6Be+06oY2njkEBQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736483383; c=relaxed/simple;
	bh=SIuYMTW48WTruujhi1P5AUTgszgLUCxLVgalWNwe4b8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZgC6HkepDWAKo7JpD35i2GPYcIZ0Iagz+uTC8iiI9CKDtFc7NmTVWhCl+q7eUtIDqq3KOso9XPABhSpAp5VWNVxT6/UYBhvxjBK0h6YrOnS4exNkgAOXagpdkCGfhVcmsY7HtfrG7bZtPq8rCNKK4PsLgaGMZyKmWj2bu6xfCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mjm861TN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736483381; x=1768019381;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SIuYMTW48WTruujhi1P5AUTgszgLUCxLVgalWNwe4b8=;
  b=Mjm861TNiXv5tXYOG5L1GJitrQ2rSPKf1dkCawNHPsORkMU9AuvZvX9c
   WxvhzigM4uBPj7BzZ8D74yP7R873BsDdjHadf6yV6+rYdZTybZej3uj2n
   IT2q8AnXz7mXRLntFCqb3fpCgxzN2ELzqJgKB26RoGDI0sQ9JqOgbcsa9
   n+e7MytC30dkBhoJ8GP04vt3hFMpp1smJV0Cb6rnqyqFvn+lhhPM9Jn7u
   f6By/JiRh2BJ10bra1Z/1CYSwtqqGvNbrNlw/aw8c0BbsH/sf5l7UTzhq
   uHQ41bewrqjfKIgwyNrtE3RaP5KyrDLh00Npv1nXHWzf+io7nN1CLGEJ9
   g==;
X-CSE-ConnectionGUID: 85m69UdfQNOUsb0A50Gcyg==
X-CSE-MsgGUID: 6CHsTXLVSmua8d2WqOdEEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="59244243"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="59244243"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 20:29:41 -0800
X-CSE-ConnectionGUID: iUNCCqQeTfuvyd5CdvbqUw==
X-CSE-MsgGUID: 45NzMe3xS8CIpUw6IQBg0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="134456536"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 20:29:38 -0800
Message-ID: <7574968a-f0e2-49d5-b740-2454a0f70bb6@intel.com>
Date: Fri, 10 Jan 2025 12:29:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
To: Francesco Lavra <francescolavra.fl@gmail.com>, rick.p.edgecombe@intel.com
Cc: isaku.yamahata@gmail.com, kai.huang@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 reinette.chatre@intel.com, seanjc@google.com, tony.lindgren@linux.intel.com,
 yan.y.zhao@intel.com
References: <dcb03fc9d73b09734dee4110363cace369fc4d4c.camel@gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <dcb03fc9d73b09734dee4110363cace369fc4d4c.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/2025 7:07 PM, Francesco Lavra wrote:
> On 2024-10-30 at 19:00, Rick Edgecombe wrote:
>> @@ -1055,6 +1144,81 @@ static int tdx_td_vcpu_init(struct kvm_vcpu
>> *vcpu, u64 vcpu_rcx)
>>   	return ret;
>>   }
>>   
>> +/* Sometimes reads multipple subleafs. Return how many enties were
>> written. */
>> +static int tdx_vcpu_get_cpuid_leaf(struct kvm_vcpu *vcpu, u32 leaf,
>> int max_cnt,
>> +				   struct kvm_cpuid_entry2
>> *output_e)
>> +{
>> +	int i;
>> +
>> +	if (!max_cnt)
>> +		return 0;
>> +
>> +	/* First try without a subleaf */
>> +	if (!tdx_read_cpuid(vcpu, leaf, 0, false, output_e))
>> +		return 1;
>> +
>> +	/*
>> +	 * If the try without a subleaf failed, try reading subleafs
>> until
>> +	 * failure. The TDX module only supports 6 bits of subleaf
>> index.
> 
> It actually supports 7 bits, i.e. bits 6:0, so the limit below should
> be 0b1111111.

Nice catch!

>> +	 */
>> +	for (i = 0; i < 0b111111; i++) {
>> +		if (i > max_cnt)
>> +			goto out;
> 
> This will make this function return (max_cnt + 1) instead of max_cnt.
> I think the code would be simpler if max_cnt was initialized to
> min(max_cnt, 0x80) (because 0x7f is a supported subleaf index, as far
> as I can tell), and the for() condition was changed to `i < max_cnt`.

Looks better.

>> +		/* Keep reading subleafs until there is a failure.
>> */
>> +		if (tdx_read_cpuid(vcpu, leaf, i, true, output_e))
>> +			return i;
>> +
>> +		output_e++;

here the output_e++ can overflow the buffer.

>> +	}
>> +
>> +out:
>> +	return i;
>> +}
>> +
>> +static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct
>> kvm_tdx_cmd *cmd)
>> +{
>> +	struct kvm_cpuid2 __user *output, *td_cpuid;
>> +	struct kvm_cpuid_entry2 *output_e;
>> +	int r = 0, i = 0, leaf;
>> +
>> +	output = u64_to_user_ptr(cmd->data);
>> +	td_cpuid = kzalloc(sizeof(*td_cpuid) +
>> +			sizeof(output->entries[0]) *
>> KVM_MAX_CPUID_ENTRIES,
>> +			GFP_KERNEL);
>> +	if (!td_cpuid)
>> +		return -ENOMEM;
>> +
>> +	for (leaf = 0; leaf <= 0x1f; leaf++) {
>> +		output_e = &td_cpuid->entries[i];
>> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>> +					     KVM_MAX_CPUID_ENTRIES -
>> i - 1,
> 
> This should be KVM_MAX_CPUID_ENTRIES - i.

Nice catch!

>> +					     output_e);
>> +	}
>> +
>> +	for (leaf = 0x80000000; leaf <= 0x80000008; leaf++) {
>> +		output_e = &td_cpuid->entries[i];
>> +		i += tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
>> +					     KVM_MAX_CPUID_ENTRIES -
>> i - 1,
> 
> Same here.
> 


