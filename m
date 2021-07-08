Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6383C1473
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 15:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhGHNmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 09:42:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:8677 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhGHNmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 09:42:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209547676"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209547676"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 06:39:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487607065"
Received: from shancao1-mobl1.ccr.corp.intel.com (HELO [10.255.28.226]) ([10.255.28.226])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 06:39:51 -0700
Subject: Re: [PATCH V7 03/18] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-4-lingshan.zhu@intel.com>
 <YN74d+LwFbwO75N3@hirez.programming.kicks-ass.net>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <1ee16a88-3de6-759c-db9e-ce2f3b6993b0@intel.com>
Date:   Thu, 8 Jul 2021 21:39:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YN74d+LwFbwO75N3@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/2/2021 7:28 PM, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:42:51PM +0800, Zhu Lingshan wrote:
>> +DECLARE_STATIC_CALL(x86_guest_state, *(perf_guest_cbs->state));
>> +
>> +/*
>> + * We may be running with guest PEBS events created by KVM, and the
>> + * PEBS records are logged into the guest's DS and invisible to host.
>> + *
>> + * In the case of guest PEBS overflow, we only trigger a fake event
>> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
>> + * The guest will then vm-entry and check the guest DS area to read
>> + * the guest PEBS records.
>> + *
>> + * The contents and other behavior of the guest event do not matter.
>> + */
>> +static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
>> +				      struct perf_sample_data *data)
>> +{
>> +	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
>> +	struct perf_event *event = NULL;
>> +	unsigned int guest = 0;
>> +	int bit;
>> +
>> +	if (!x86_pmu.pebs_vmx || !x86_pmu.pebs_active ||
>> +	    !(cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask))
>> +		return;
>> +
>> +	guest = static_call(x86_guest_state)();
>> +	if (!(guest & PERF_GUEST_ACTIVE))
>> +		return;
> I think you've got the branches the wrong way around here; nobody runs a
> VM so this branch will get you out without a load.
>
> Only if you're one of those daft people running a VM, are you interested
> in any of the other conditions that are required.
>
> Also, I think both pebs_active and pebs_vmx can he a static_branch, but
> that can be done later I suppose.
Hi Peter,

If I understand this correctly, are you suggesting we put "if (!(guest & 
PERF_GUEST_ACTIVE))" first because this is a lower cost branch?

Thanks,
Zhu Lingshan

