Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2D017C099
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 15:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgCFOnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 09:43:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:49905 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgCFOnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 09:43:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 06:42:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,522,1574150400"; 
   d="scan'208";a="234870124"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 06 Mar 2020 06:42:51 -0800
Received: from [10.251.20.182] (kliang2-mobl.ccr.corp.intel.com [10.251.20.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id E5D7A580298;
        Fri,  6 Mar 2020 06:42:48 -0800 (PST)
Subject: Re: [PATCH v1 01/11] perf/x86/core: Support KVM to assign a dedicated
 counter for guest PEBS
To:     Peter Zijlstra <peterz@infradead.org>,
        Luwei Kang <luwei.kang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        like.xu@linux.intel.com
References: <1583431025-19802-1-git-send-email-luwei.kang@intel.com>
 <1583431025-19802-2-git-send-email-luwei.kang@intel.com>
 <20200306135317.GD12561@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <b72cb68e-1a0a-eeff-21b4-ce412e939cfd@linux.intel.com>
Date:   Fri, 6 Mar 2020 09:42:47 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200306135317.GD12561@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/6/2020 8:53 AM, Peter Zijlstra wrote:
> On Fri, Mar 06, 2020 at 01:56:55AM +0800, Luwei Kang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> The PEBS event created by host needs to be assigned specific counters
>> requested by the guest, which means the guest and host counter indexes
>> have to be the same or fail to create. This is needed because PEBS leaks
>> counter indexes into the guest. Otherwise, the guest driver will be
>> confused by the counter indexes in the status field of the PEBS record.
>>
>> A guest_dedicated_idx field is added to indicate the counter index
>> specifically requested by KVM. The dedicated event constraints would
>> constrain the counter in the host to the same numbered counter in guest.
>>
>> A intel_ctrl_guest_dedicated_mask field is added to indicate the enabled
>> counters for guest PEBS events. The IA32_PEBS_ENABLE MSR will be switched
>> during the VMX transitions if intel_ctrl_guest_owned is set.
>>
> 
>> +	/* the guest specified counter index of KVM owned event, e.g PEBS */
>> +	int				guest_dedicated_idx;
> 
> We've always objected to guest 'owned' counters, they destroy scheduling
> freedom. Why are you expecting that to be any different this time?
>

The new proposal tries to 'own' a counter by setting the event 
constraint. It doesn't stop other events using the counter.
If there is high priority event which requires the same counter, 
scheduler can still reject the request from KVM.
I don't think it destroys the scheduling freedom this time.

Thanks,
Kan

