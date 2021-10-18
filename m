Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB3C431EF5
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 16:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhJROIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 10:08:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:63165 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234743AbhJROGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 10:06:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="314448694"
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="314448694"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 06:56:16 -0700
X-IronPort-AV: E=Sophos;i="5.85,382,1624345200"; 
   d="scan'208";a="493595860"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.173.213]) ([10.249.173.213])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2021 06:56:14 -0700
Message-ID: <157ba65d-bd2a-288a-6091-9427e2809b02@intel.com>
Date:   Mon, 18 Oct 2021 21:56:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.2.0
Subject: Re: [PATCH v2 6/7] KVM: VMX: Check Intel PT related CPUID leaves
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
 <20210827070249.924633-7-xiaoyao.li@intel.com> <YTp/oGmiin19q4sQ@google.com>
 <a7988439-5a4c-3d5a-ea4a-0fad181ad733@intel.com>
 <486f0075-494d-1d84-2d85-1d451496d1f0@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <486f0075-494d-1d84-2d85-1d451496d1f0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2021 8:47 PM, Paolo Bonzini wrote:
> On 10/09/21 03:59, Xiaoyao Li wrote:
>>>
>>> Ugh, looking at the rest of the code, even this isn't sufficient
>>> because pt_desc.guest.addr_{a,b} are hardcoded at 4 entries, i.e.
>>> running KVM on hardware with >4 entries will lead to buffer
>>> overflows.
>>
>> it's hardcoded to 4 because there is a note of "no processors support
>>  more than 4 address ranges" in SDM vol.3 Chapter 31.3.1, table
>> 31-11
> 
> True, but I agree with Sean that it's not pretty.

Yes. We can add the check to validate the hardware is not bigger than 4 
for future processors. Intel folks are supposed to send new patches 
before silicon with more than 4 PT_ADDR_RANGE delivered.

>>> One option would be to bump that to the theoretical max of 15,
>>> which doesn't seem too horrible, especially if pt_desc as a whole
>>> is allocated on-demand, which it probably should be since it isn't
>>> exactly tiny (nor ubiquitous)
>>>
>>> A different option would be to let userspace define whatever it
>>> wants for guest CPUID, and instead cap nr_addr_ranges at
>>> min(host.cpuid, guest.cpuid, RTIT_ADDR_RANGE).
> 
> This is the safest option.

My concern was that change userspace's input silently is not good. If 
you prefer this, we certainly need to extend the userspace to query what 
value is finally accepted and set by KVM.

> Paolo
> 

