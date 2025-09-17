Return-Path: <kvm+bounces-57813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CADB7D312
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B9BD1B26922
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 02:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5202F3C02;
	Wed, 17 Sep 2025 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFDs8zQ7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3979721578F;
	Wed, 17 Sep 2025 02:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758077515; cv=none; b=YTnu4hihV4PuYvcZycI5qRYBGWp9TPv8ER4OXmrNta8P5RWuup5xKZRQkRUhiuWiv07GH+9Hm1LVPVvBWJY9qjfwVZPbv9pyH6WPmujmwavWVxwa8GhyZqslMMaQiuAalKsnBLBTz9aNpd7WxrRxUa48EJ4w3NxMAR7eywCROi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758077515; c=relaxed/simple;
	bh=rMqi48YwWFVnRsqh0GVjp34vpoJ2wbyzH02XVtdHUms=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=t1P8lfwF82SOo6r1hTBgNqavnbjGWJH7J/yPerIefxb7NiBaLwbZc0gJ17V52v1EgXFnELW56w76fXbTpA5L6sMJGrggwAlpE8y+6i3+YnP7ZOdheOQ4NW4g//KIglIwiYfRUhthvmWiv25+XW5UoLOzc3jRj0bOQuzI9+zo7xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WFDs8zQ7; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758077514; x=1789613514;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=rMqi48YwWFVnRsqh0GVjp34vpoJ2wbyzH02XVtdHUms=;
  b=WFDs8zQ7WNzaCLl66cI6qbF6HPJeayvKYexBJztphDmr7GXTHTplxmtX
   Hbx6YRIh8ZYJp6oP/TeIJUSfjA9LIevbRa0H277aL268ANDj5nBZOdtl6
   XoHCwviKqpj/X2PMpyO44IE3+W/vtnqBd19CuQWRWzrdF0GkO9PYg++A+
   40bdxSeb42q1leJTFNdtm+57970zu/MLSJgSB2B2/cPI5RlKLbkrWE1aJ
   Ui1kuedVaz/3lTYHt2MSyGi62emIa62cbY82ReuEcdnlAWvHmqa9w1jfG
   mGmm+ewbxFvvJf1e76naNba1vi5CQ/bCgWvso4VRIXsobEiSgsJSTuhCU
   g==;
X-CSE-ConnectionGUID: EM+8V7sMT1+V+qX6lobqtw==
X-CSE-MsgGUID: AlhIBc3bQ6SauzfHIcOhfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64174913"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64174913"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 19:51:53 -0700
X-CSE-ConnectionGUID: 3od9O47pQ/OSIVzcVaLEDw==
X-CSE-MsgGUID: D5YljDkZRaq5WWFl+NI17w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,270,1751266800"; 
   d="scan'208";a="180378268"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 19:51:51 -0700
Message-ID: <3800f472-025b-4d44-ad4a-a5bb1f9841d2@linux.intel.com>
Date: Wed, 17 Sep 2025 10:51:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 09/41] KVM: x86: Load guest FPU state when access
 XSAVE-managed MSRs
From: Binbin Wu <binbin.wu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-10-seanjc@google.com>
 <c4b9d87b-fddc-420b-ac86-7da48a42610f@linux.intel.com>
Content-Language: en-US
In-Reply-To: <c4b9d87b-fddc-420b-ac86-7da48a42610f@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/16/2025 4:28 PM, Binbin Wu wrote:
>
>
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
>> Load the guest's FPU state if userspace is accessing MSRs whose values
>> are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
>> to facilitate access to such kind of MSRs.
>>
>> If MSRs supported in kvm_caps.supported_xss are passed through to guest,
>> the guest MSRs are swapped with host's before vCPU exits to userspace and
>> after it reenters kernel before next VM-entry.
>>
>> Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
>> explicitly check @vcpu is non-null before attempting to load guest state.
>> The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
>> loading guest FPU state (which doesn't exist).
>>
>> Note that guest_cpuid_has() is not queried as host userspace is allowed to
>> access MSRs that have not been exposed to the guest, e.g. it might do
>> KVM_SET_MSRS prior to KVM_SET_CPUID2.
>>
>> The two helpers are put here in order to manifest accessing xsave-managed
>> MSRs requires special check and handling to guarantee the correctness of
>> read/write to the MSRs.
>>
>> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Tested-by: Mathias Krause <minipli@grsecurity.net>
>> Tested-by: John Allen <john.allen@amd.com>
>> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> [sean: drop S_CET, add big comment, move accessors to x86.c]
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>
> Two nits below.
>
>> ---
>>   arch/x86/kvm/x86.c | 86 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 85 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c5e38d6943fe..a95ca2fbd3a9 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>>   static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
>>     static DEFINE_MUTEX(vendor_module_lock);
>> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
>> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
>> +
>>   struct kvm_x86_ops kvm_x86_ops __read_mostly;
>>     #define KVM_X86_OP(func)                         \
>> @@ -3801,6 +3804,66 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>>       mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>>   }
>>   +/*
>> + * Returns true if the MSR in question is managed via XSTATE, i.e. is context
>> + * switched with the rest of guest FPU state.  Note!  S_CET is _not_ context
>> + * switched via XSTATE even though it _is_ saved/restored via XSAVES/XRSTORS.
>> + * Because S_CET is loaded on VM-Enter and VM-Exit via dedicated VMCS fields,
>> + * the value saved/restored via XSTATE is always the host's value.  That detail
>> + * is _extremely_ important, as the guest's S_CET must _never_ be resident in
>> + * hardware while executing in the host.  Loading guest values for U_CET and
>> + * PL[0-3]_SSP while executing in the kernel is safe, as U_CET is specific to
>> + * userspace, and PL[0-3]_SSP are only consumed when transitioning to lower
>> + * privilegel levels, i.e. are effectively only consumed by userspace as well.
>> + */

privilegel -> privilege



