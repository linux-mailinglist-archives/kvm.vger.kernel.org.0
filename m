Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A858C3BF71F
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 10:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhGHI4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 04:56:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:56562 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231190AbhGHI4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 04:56:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="207645707"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="207645707"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:53:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487473996"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.108]) ([10.249.171.108])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 01:53:28 -0700
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To:     Peter Zijlstra <peterz@infradead.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        xen-devel@lists.xenproject.org
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <82ae3758-6b99-dc43-9515-fabb2b036f3b@linux.intel.com>
Date:   Thu, 8 Jul 2021 16:53:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2021 7:22 PM, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 8f71dd72ef95..c71af4cfba9b 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
>>    */
>>   DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
>>   
>> +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
>> +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
>> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
>> +
>> +void arch_perf_update_guest_cbs(void)
>> +{
>> +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
>> +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
>> +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->state)
>> +		static_call_update(x86_guest_state, perf_guest_cbs->state);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
>> +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
>> +		static_call_update(x86_guest_handle_intel_pt_intr,
>> +				   perf_guest_cbs->handle_intel_pt_intr);
>> +}
> Coding style wants { } on that last if().
will fix these coding style issues in V8

Thanks!
