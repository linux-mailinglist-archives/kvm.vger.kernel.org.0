Return-Path: <kvm+bounces-13265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0E2689388E
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 09:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 849942817C5
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28702BA27;
	Mon,  1 Apr 2024 07:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iIbxlKgQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E719473;
	Mon,  1 Apr 2024 07:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711955245; cv=none; b=NsYCoBZ3scHbcj5dA8Ui8H8x+5Oo8q4k9Cot0yJJDEpuGO/Wpax/XIxeIto9TuApvJ6pZI9s2XBgpVG4qTY5VcT46WwfI9QM59+bPs0y982Viq/211Reyh9RT0AIEdERjpTttPfDXSJwhOKDtq0QkyP+RZZ0p8lTmbs0QKoP9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711955245; c=relaxed/simple;
	bh=a16RU2Hu1GS33HCADY7Bnjo7ilQmCDcPkDOhMwQFHo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L5ddS8/c+CQ+pwKZc85NVTDCpmRgAE8vyigxMLs4KjUaEVn2ntdlSzhcgx/EhpkRwulLLbXzRbgM+eWLOcVH8UygKCkuzLhaeTWmLQlBUcoLMWrOG915c1h5zhc5wXJSIzgUHMkIVLGx7KmMW1YZMtlolMhl3GwT9b73j6lp1kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iIbxlKgQ; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711955244; x=1743491244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a16RU2Hu1GS33HCADY7Bnjo7ilQmCDcPkDOhMwQFHo0=;
  b=iIbxlKgQ2XKg4+yTQsuB3iifstZeW43qy2wy3/tqPKgKuiDepLZyz7jT
   EFnXpaorQPANTcOj7pfS0lbLprgBbSmjQFT9w8Y2UX63nKQYzOtPF4wBY
   XGWohZfopqwGBAQem3DDlmA7o7iJ7va+RxEUZgIOgDN+gXLXXSxmLx6XV
   1vmUGVQuaud27Ix1JlS6NnyujEK3sgiZQXw6nPaTOQIqgs/SghtTPk388
   QW/2R12aJECpyLdrhmnVeLFmiVLlNZFzDF7a30QP25CQMN01Rl6O1Cyj6
   Z6eGWrQdvWOm7BIj7wKJ9EgzNQyk7hN1iQaKrHyT0ud3J8meoVcG9sqXJ
   Q==;
X-CSE-ConnectionGUID: xHMqWG8KS6e2eMfmANIh8A==
X-CSE-MsgGUID: 9M4qxnjrRLytLtV7WIgUxQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="7262612"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="7262612"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:07:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="18085110"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 00:07:17 -0700
Message-ID: <1e063b73-0f9a-4956-9634-2552e6e63ee1@intel.com>
Date: Mon, 1 Apr 2024 15:07:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
To: Sean Christopherson <seanjc@google.com>, Zhao Liu <zhao1.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-9-seanjc@google.com> <ZfRtSKcXTI/lAQxE@intel.com>
 <ZfSLRrf1CtJEGZw2@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZfSLRrf1CtJEGZw2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/2024 1:54 AM, Sean Christopherson wrote:
> On Fri, Mar 15, 2024, Zhao Liu wrote:
>> On Fri, Mar 08, 2024 at 05:27:24PM -0800, Sean Christopherson wrote:
>>> Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
>>> and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
>>> that the function looks like all the helpers that grab values from
>>> VMX_BASIC and VMX_MISC MSR values.
> 
> ...
> 
>>> -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
>>>   #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
>>>   #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
>>>   #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
>>> @@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>>>   
>>>   static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>>>   {
>>> -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
>>> +	return vmx_misc & GENMASK_ULL(4, 0);
>>>   }
>>
>> I feel keeping VMX_MISC_PREEMPTION_TIMER_RATE_MASK is clearer than
>> GENMASK_ULL(4, 0), and the former improves code readability.
>>
>> May not need to drop VMX_MISC_PREEMPTION_TIMER_RATE_MASK?
> 
> I don't necessarily disagree, but in this case I value consistency over one
> individual case.  As called out in the changelog, the motivation is to make
> vmx_misc_preemption_timer_rate() look like all the surrounding helpers.
> 
> _If_ we want to preserve the mask, then we should add #defines for vmx_misc_cr3_count(),
> vmx_misc_max_msr(), etc.
> 
> I don't have a super strong preference, though I think my vote would be to not
> add the masks and go with this patch.  These helpers are intended to be the _only_
> way to access the fields, i.e. they effectively _are_ the mask macros, just in
> function form.
> 

+1.

However, it seems different for vmx_basic_vmcs_mem_type() in patch 5, 
that I just recommended to define the MASK.

Because we already have

	#define VMX_BASIC_MEM_TYPE_SHIFT	50

and it has been used in vmx/nested.c,

static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
{
	return (vmx_basic & GENMASK_ULL(53, 50)) >>
		VMX_BASIC_MEM_TYPE_SHIFT;
}

looks not intuitive than original patch.

