Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97308432B94
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 03:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhJSBsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 21:48:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:58305 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhJSBsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 21:48:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10141"; a="228673420"
X-IronPort-AV: E=Sophos;i="5.85,383,1624345200"; 
   d="scan'208";a="228673420"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 18:46:33 -0700
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="661608314"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 18:46:31 -0700
Message-ID: <b9b72305-d05e-bb60-ab24-7d4eb45182e3@intel.com>
Date:   Tue, 19 Oct 2021 09:46:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com> <YTp/oGmiin19q4sQ@google.com>
 <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
 <486f0075-494d-1d84-2d85-1d451496d1f0@redhat.com>
 <157ba65d-bd2a-288a-6091-9427e2809b02@intel.com>
 <YW2uUcor5nhDZ3DS@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YW2uUcor5nhDZ3DS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/2021 1:26 AM, Sean Christopherson wrote:
> On Mon, Oct 18, 2021, Xiaoyao Li wrote:
>> On 10/18/2021 8:47 PM, Paolo Bonzini wrote:
>>>>> One option would be to bump that to the theoretical max of 15,
>>>>> which doesn't seem too horrible, especially if pt_desc as a whole
>>>>> is allocated on-demand, which it probably should be since it isn't
>>>>> exactly tiny (nor ubiquitous)
>>>>>
>>>>> A different option would be to let userspace define whatever it
>>>>> wants for guest CPUID, and instead cap nr_addr_ranges at
>>>>> min(host.cpuid, guest.cpuid, RTIT_ADDR_RANGE).
>>>
>>> This is the safest option.

I think I misunderstood it. sigh...

It's not architecture consistent that guest sees a certain number of 
RTIT_ADDR_RANGE from its CPUID but may get #GP when it accesses high index.

OK, you mean it's userspace's fault and KVM shouldn't get blamed for it. 
It seems reasonable for me now.

>> My concern was that change userspace's input silently is not good.
> 
> Technically KVM isn't changing userspace's input, as KVM will still enumerate
> CPUID as defined by userspace.  What KVM is doing is refusing to emulate/virtualize
> a bogus vCPU model, e.g. by injecting #GP on an MSR access that userspace
> incorrectly told the guest was legal.  That is standard operation procedure for
> KVM, e.g. there are any number of instructions that will fault if userspace lies
> about the vCPU model.
> 
>> prefer this, we certainly need to extend the userspace to query what value
>> is finally accepted and set by KVM.
> 
> That would be __do_cpuid_func()'s responsibility to cap leaf 0x14 output with
> RTIT_ADDR_RANGE.  I.e. enumerate the supported ranges in KVM_GET_SUPPORTED_CPUID,
> after that it's userspace's responsibility to not mess up.
> 



