Return-Path: <kvm+bounces-10761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53FFC86FB3A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B1B2281DDA
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E76E171A7;
	Mon,  4 Mar 2024 07:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HMl5ewI4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB94171A2;
	Mon,  4 Mar 2024 07:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709539157; cv=none; b=JxyauE3fasGPmyEiyf68d0HqpAXqF3fVB5/lCusN4R998/DV5hhXR0Buqxr8BOWzbmC50aMcgB/IqQCQShV7fLeJvi/6ghTblUewcIs6qfPuFiCfRkYuIudLY5uXSz7hE7OC6tH0dt3DHsPJ2s9I3sK7lRHbYReRjdg0VZiVbGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709539157; c=relaxed/simple;
	bh=wbUpByb5oxuPadRm9JZleAn/NqozTy3sADip5yJwJ3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kQObubfAgMxZr0oVU1/AdtpNo7z3MP+qJUw8tGQmnPokXKnWKhGPIfCr13jiD7/2wX/5nR78H7Rr8bLT2uyYpe021J9hRq94qvnW/bp2DpZa5wUh9l9eNEdCdcrbSNXQ/1+S9OjmPQ0I2xMLFdu4QcWTTig37dPdtNeUiIsvNic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HMl5ewI4; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709539156; x=1741075156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wbUpByb5oxuPadRm9JZleAn/NqozTy3sADip5yJwJ3M=;
  b=HMl5ewI4bfFEgLfpEvUa+/RUTNs5rKLTDdNNBv0Wo1kgeL4X8v9PVf8T
   cuQnB3IUhYQF2QV+iQN6s4wgA0V9bd4fYtlU9iBmq+QM7f4E6E6kyzmeE
   H4xXk6Ww+qtud6lgWspITvdPbMZxff/ipmMlmmpP1ugXCjncFBKwDjbQK
   0DbGjpXtWYY3OgadBOqIDoFKUepsbRJax6JS5ZRj646I/SCyvjcVYlgZc
   xR/jMsXfcC5C+t79aGEkyLXMtXphrK5t/X+YgmWvsWE2259ydcjP5/y25
   U3QhGPLEXtyKoEAjn3hfzZ5XCLPyrZEic68ThEqeyI9Jrf1fiaCKXolB4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="26480268"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="26480268"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 23:59:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="13469584"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.239.60]) ([10.124.239.60])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2024 23:59:08 -0800
Message-ID: <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
Date: Mon, 4 Mar 2024 15:59:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Content-Language: en-US
To: Sandipan Das <sandipan.das@amd.com>, Like Xu <like.xu.linux@gmail.com>
Cc: seanjc@google.com, pbonzini@redhat.com, mizhang@google.com,
 jmattson@google.com, ravi.bangoria@amd.com, nikunj.dadhania@amd.com,
 santosh.shukla@amd.com, manali.shukla@amd.com, babu.moger@amd.com,
 kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 3/1/2024 5:00 PM, Sandipan Das wrote:
> On 3/1/2024 2:07 PM, Like Xu wrote:
>> On 1/3/2024 3:50 pm, Sandipan Das wrote:
>>> With PerfMonV2, a performance monitoring counter will start operating
>>> only when both the PERF_CTLx enable bit as well as the corresponding
>>> PerfCntrGlobalCtl enable bit are set.
>>>
>>> When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
>>> for a guest but the guest kernel does not support PerfMonV2 (such as
>>> kernels older than v5.19), the guest counters do not count since the
>>> PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
>>> writes to it.
>> If the vcpu has the PerfMonV2 feature, it should not work the way legacy
>> PMU does. Users need to use the new driver to operate the new hardware,
>> don't they ? One practical approach is that the hypervisor should not set
>> the PerfMonV2 bit for this unpatched 'v5.19' guest.
>>
> My understanding is that the legacy method of managing the counters should
> still work because the enable bits in PerfCntrGlobalCtl are expected to be
> set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrGlobalCtl
> is set to 0x3f after a system reset. That way, the guest kernel can use either


If so, please add the PPR description here as comments.


> the new or legacy method.
>
>>> This is not observed on bare-metal as the default value of the
>>> PerfCntrGlobalCtl MSR after a reset is 0x3f (assuming there are six
>>> counters) and the counters can still be operated by using the enable
>>> bit in the PERF_CTLx MSRs. Replicate the same behaviour in guests for
>>> compatibility with older kernels.
>>>
>>> Before:
>>>
>>>     $ perf stat -e cycles:u true
>>>
>>>      Performance counter stats for 'true':
>>>
>>>                      0      cycles:u
>>>
>>>            0.001074773 seconds time elapsed
>>>
>>>            0.001169000 seconds user
>>>            0.000000000 seconds sys
>>>
>>> After:
>>>
>>>     $ perf stat -e cycles:u true
>>>
>>>      Performance counter stats for 'true':
>>>
>>>                227,850      cycles:u
>>>
>>>            0.037770758 seconds time elapsed
>>>
>>>            0.000000000 seconds user
>>>            0.037886000 seconds sys
>>>
>>> Reported-by: Babu Moger <babu.moger@amd.com>
>>> Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
>>> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
>>> ---
>>>    arch/x86/kvm/svm/pmu.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>>> index b6a7ad4d6914..14709c564d6a 100644
>>> --- a/arch/x86/kvm/svm/pmu.c
>>> +++ b/arch/x86/kvm/svm/pmu.c
>>> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>>        if (pmu->version > 1) {
>>>            pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>>>            pmu->global_status_mask = pmu->global_ctrl_mask;
>>> +        pmu->global_ctrl = ~pmu->global_ctrl_mask;


It seems to be more easily understand to calculate global_ctrl firstly 
and then derive the globol_ctrl_mask (negative logic).

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e886300f0f97..7ac9b080aba6 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -199,7 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
kvm_pmu_cap.num_counters_gp);

         if (pmu->version > 1) {
-               pmu->global_ctrl_mask = ~((1ull << 
pmu->nr_arch_gp_counters) - 1);
+               pmu->global_ctrl = (1ull << pmu->nr_arch_gp_counters) - 1;
+               pmu->global_ctrl_mask = ~pmu->global_ctrl;
                 pmu->global_status_mask = pmu->global_ctrl_mask;
         }

>>>        }
>>>          pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
>

