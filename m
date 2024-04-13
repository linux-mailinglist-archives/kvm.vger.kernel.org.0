Return-Path: <kvm+bounces-14592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E22C8A3AA9
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 05:30:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7D271F24266
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E101AAD3;
	Sat, 13 Apr 2024 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MYkKD03H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2240317722;
	Sat, 13 Apr 2024 03:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712979004; cv=none; b=jEVxG4ermGbicCqV78q+RvzIhRbMTH8JU1/b73hNEuluaNFSw27gQL/zXCaGbKWJs2rRqpRNNaaWwxaSui+doLTQnpp+qKRPduYWkIDRpaOlPnv1fGpmYiUY2FDRwdmSU6Rtbzt3lqNrAar/FLZ8vLwzgOVsQjVuefh6qZUE/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712979004; c=relaxed/simple;
	bh=U63yV+bzfQZSVisuEs2mKLPCsBSfAnt51A8BFJqeIx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pM41ik3a9AJARJYxa5vcm0w7wurZbxdUPrOB9kzTTNOolkfEmxIlAKSUjXB7ggCeQNxDlX1PTYb1LHZHqEAsnBdMXh3KhiMd6J/qTh9gcknfK2F5yfUmh9WX08Z3tbFphCp2czOkimEaYHulXLHst3Kv96Hp+CLqo/Ixu1Gw3X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MYkKD03H; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712979003; x=1744515003;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U63yV+bzfQZSVisuEs2mKLPCsBSfAnt51A8BFJqeIx0=;
  b=MYkKD03HdYN2ke/sme1xXswtFL48yDWN9iQy7Lzf0I+05PQbhG5WXUM5
   3G/d8A+NEeVJN6dLWzvlu/WyzZ1fJJzpfhtRPflvy4EHcFHcSgp1rgKMt
   3qRrmyh8khW4PC0QWQDOukTncrTnsfg7jH4f9gG/j20fJtwZjQu3jxslO
   W2jHI9MhkHfaEnzTn1FGseawO6ARNmDpS9p20zGzLKE7jQk6f3tVM+sCE
   M9ofGZTxPoV+ghU/2y/7NPJurxaagCCbQPcBrYxJEKtqhkbcIVXrgh0ZL
   yhBpBTjpa22ZIOgEKIrHhAuMJW9ULu+kLdze/pVoUTZTeVa98W/BF1dGD
   Q==;
X-CSE-ConnectionGUID: PJ00+z1/TdCoFNSBfcdBtA==
X-CSE-MsgGUID: QE1qT6leQ/aaAooViZHBtQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8306769"
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="8306769"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:30:02 -0700
X-CSE-ConnectionGUID: j5r019zuRyyfhPbNWxJf2A==
X-CSE-MsgGUID: 8c2KW5U1RpWdwONbmCT8BA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="25826620"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:29:58 -0700
Message-ID: <64c895af-67a2-48de-b509-dd44d295ffe9@linux.intel.com>
Date: Sat, 13 Apr 2024 11:29:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 27/41] KVM: x86/pmu: Clear PERF_METRICS MSR for guest
To: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com,
 kan.liang@intel.com, zhenyuw@linux.intel.com, jmattson@google.com,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-28-xiong.y.zhang@linux.intel.com>
 <ZhhbJCGcJ6Rshkfk@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZhhbJCGcJ6Rshkfk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/12/2024 5:50 AM, Sean Christopherson wrote:
> On Fri, Jan 26, 2024, Xiong Zhang wrote:
>> From: Dapeng Mi <dapeng1.mi@linux.intel.com>
>>
>> Since perf topdown metrics feature is not supported yet, clear
>> PERF_METRICS MSR for guest.
> Please rewrite with --verbose, I have no idea what MSR_PERF_METRICS, and thus no
> clue why it needs to be zeroed when loading guest context, e.g. it's not passed
> through, so why does it matter?

Sure. MSR_PERF_METRICS actually reports the perf topdown metrics 
portion. I would add more details.


>
>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 4b4da7f17895..ad0434646a29 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -916,6 +916,10 @@ static void intel_restore_pmu_context(struct kvm_vcpu *vcpu)
>>   	 */
>>   	for (i = pmu->nr_arch_fixed_counters; i < kvm_pmu_cap.num_counters_fixed; i++)
>>   		wrmsrl(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>> +
>> +	/* Clear PERF_METRICS MSR since guest topdown metrics is not supported yet. */
>> +	if (kvm_caps.host_perf_cap & PMU_CAP_PERF_METRICS)
>> +		wrmsrl(MSR_PERF_METRICS, 0);
>>   }
>>   
>>   struct kvm_pmu_ops intel_pmu_ops __initdata = {
>> -- 
>> 2.34.1
>>

