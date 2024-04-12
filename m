Return-Path: <kvm+bounces-14386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 064BD8A25DA
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 07:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9EA7283E1F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 05:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25E911BF24;
	Fri, 12 Apr 2024 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWmUo1a3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4CC1B96E;
	Fri, 12 Apr 2024 05:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712900659; cv=none; b=SfCOHi1Zxxx+MbVmK0BRMHDpA6mmTBoSrEr4M+rbkvke/jShGdc+/KUMcEb2o1eiqMCCApihgs2Xl1N/YOkEJvGE5HJ282EJcwL5lz9K49e+1Kd+s64QyCMhmd6kOEmwHLuzalhY3/hRmLw6+fWLGMfxOBqkjr7/woGMVdBWOW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712900659; c=relaxed/simple;
	bh=t9IyVL79bJ8O2rJHXegBc6gcfFgf4W7Q52ai+x63gms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OwX8gskqcCxvXh4ZeeInt3+3fn59jvvw2jm1r9aRucMZ2hN0OKZ4j7vUg26Aqswc3nYV84FG9qpiQd8/ygCRnz8HDBBg38tfi7ntRD/5YCzVgDgKVEClEFLnHAceVloDQwgHuPMDA7EzCR2dgiP0mKpm0eb9K4aokE9zRpLIKH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWmUo1a3; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712900657; x=1744436657;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t9IyVL79bJ8O2rJHXegBc6gcfFgf4W7Q52ai+x63gms=;
  b=PWmUo1a3LTx+EAvExShndAmlfjHqxL8ZjPPzP0DyQjWD8GVyyTavlF1v
   e9u90PlV3DibT9llfRU6zakUvlRexmtEYGWSqjyHfu7g/zp+Mew+wtlc3
   4lgn9dKc13KnceB/mfRYDcslmgyudbY0xBjNuGr9DZfcqGCKUSYUorMPm
   BZJRUInr50IW/Nooj1RNxmAQ8m9xT3BfF4utCBM4PkRNzPAcVAs/zd5/x
   Gp/DU7EMlwdyqQHnHfRNLHUivjQZ3Qv01E325Zv66iO6f6EkFS3PhOOpk
   QN+H0KFr5TNYXBwve/CdkOikySvjZKjC+Kx+9pK6Y40QrXnsTUWDLAacW
   g==;
X-CSE-ConnectionGUID: c5UXe7MkSV+oyZIAhhGW1w==
X-CSE-MsgGUID: /bUfCvTJQPuRvEHIstZrBA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8900269"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8900269"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 22:44:16 -0700
X-CSE-ConnectionGUID: Gis4aWxaStOcmdSKpzh2Pg==
X-CSE-MsgGUID: eLxiMtO2SkuuciJo7EpFAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52100678"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.124.244.162]) ([10.124.244.162])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 22:44:12 -0700
Message-ID: <efc9f54b-a145-4ff5-bb8a-84b9970bc51e@linux.intel.com>
Date: Fri, 12 Apr 2024 13:44:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/41] KVM: x86/pmu: Register PMI handler for
 passthrough PMU
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-6-xiong.y.zhang@linux.intel.com>
 <Zhg0_B4ktNzQbWZZ@google.com>
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <Zhg0_B4ktNzQbWZZ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/12/2024 3:07 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Xiong Zhang <xiong.y.zhang@intel.com>
>>
>> Add function to register/unregister PMI handler at KVM module
>> initialization and destroy time. This allows the host PMU with passthough
>> capability enabled switch PMI handler at PMU context switch time.
>>
>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  arch/x86/kvm/x86.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 2c924075f6f1..4432e736129f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10611,6 +10611,18 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>>  }
>>  EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>>  
>> +void kvm_passthrough_pmu_handler(void)
> 
> s/pmu/pmi, and this needs a verb.  Maybe kvm_handle_guest_pmi()?  Definitely
> open to other names.
kvm_handle_guest_pmi() is ok. 
> 
>> +{
>> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> +
>> +	if (!vcpu) {
>> +		pr_warn_once("%s: no running vcpu found!\n", __func__);
> 
> Unless I misunderstand the code, this can/should be a full WARN_ON_ONCE.  If a
> PMI skids all the way past vcpu_put(), we've got big problems.
yes, it is big problems and user should be noticed.
>  
>> +		return;
>> +	}
>> +
>> +	kvm_make_request(KVM_REQ_PMI, vcpu);
>> +}
>> +
>>  /*
>>   * Called within kvm->srcu read side.
>>   * Returns 1 to let vcpu_run() continue the guest execution loop without
>> @@ -13815,6 +13827,7 @@ static int __init kvm_x86_init(void)
>>  {
>>  	kvm_mmu_x86_module_init();
>>  	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
>> +	kvm_set_vpmu_handler(kvm_passthrough_pmu_handler);
> 
> Hmm, a few patches late, but the "kvm" scope is weird.  This calls a core x86
> function, not a KVM function.
> 
> And to reduce exports and copy+paste, what about something like this?
> 
> void x86_set_kvm_irq_handler(u8 vector, void (*handler)(void))
> {
> 	if (!handler)
> 		handler = dummy_handler;
> 
> 	if (vector == POSTED_INTR_WAKEUP_VECTOR)
> 		kvm_posted_intr_wakeup_handler = handler;
> 	else if (vector == KVM_GUEST_PMI_VECTOR)
> 		kvm_guest_pmi_handler = handler;
> 	else
> 		WARN_ON_ONCE(1);
> 
> 	if (handler == dummy_handler)
> 		synchronize_rcu();
> }
> EXPORT_SYMBOL_GPL(x86_set_kvm_irq_handler);
Good suggestion. Follow it in next version.

