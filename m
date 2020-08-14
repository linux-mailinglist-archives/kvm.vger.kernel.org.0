Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69B92447B7
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 12:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHNKJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 06:09:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:39212 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgHNKJk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 06:09:40 -0400
IronPort-SDR: v9olPLzJFE8/D8EMOYiRzvBhLxyrqkWLDiVOc4HoyjvaYaCwpZ9V+Y+NH4RlhBbvm5TiXUaFaJ
 /W9bzwc20Hyg==
X-IronPort-AV: E=McAfee;i="6000,8403,9712"; a="142225727"
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="142225727"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 03:09:40 -0700
IronPort-SDR: Ybx8mk0552li0bdHdUB5/dPO86kL96paT7UAUsymjTxWeEEFMaHNyg4TVfG+hdQR/GllgXHLp9
 0J1o/mhb1tUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,311,1592895600"; 
   d="scan'208";a="325687704"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.93]) ([10.238.2.93])
  by orsmga008.jf.intel.com with ESMTP; 14 Aug 2020 03:09:37 -0700
Subject: Re: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-8-chenyi.qiang@intel.com>
 <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com>
 <1481a482-c20b-5531-736c-de0c5d3d611c@intel.com>
 <CALMp9eQ5HhhXaEVKwnn6N6xxd2QOkNkE7ysiwq+3P=HB-Y1uzg@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <ae2191a7-a165-3b50-2c8d-e2ddb4505455@intel.com>
Date:   Fri, 14 Aug 2020 18:07:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ5HhhXaEVKwnn6N6xxd2QOkNkE7ysiwq+3P=HB-Y1uzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/14/2020 1:52 AM, Jim Mattson wrote:
> On Wed, Aug 12, 2020 at 9:54 PM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>>
>>
>> On 8/11/2020 8:05 AM, Jim Mattson wrote:
>>> On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>>>
>>>> PKS MSR passes through guest directly. Configure the MSR to match the
>>>> L0/L1 settings so that nested VM runs PKS properly.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
> 
>>>> +           (!vmx->nested.nested_run_pending ||
>>>> +            !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PKRS)))
>>>> +               vmcs_write64(GUEST_IA32_PKRS, vmx->nested.vmcs01_guest_pkrs);
>>>
>>> This doesn't seem right to me. On the target of a live migration, with
>>> L2 active at the time the snapshot was taken (i.e.,
>>> vmx->nested.nested_run_pending=0), it looks like we're going to try to
>>> overwrite the current L2 PKRS value with L1's PKRS value (except that
>>> in this situation, vmx->nested.vmcs01_guest_pkrs should actually be
>>> 0). Am I missing something?
>>>
>>
>> We overwrite the L2 PKRS with L1's value when L2 doesn't support PKS.
>> Because the L1's VM_ENTRY_LOAD_IA32_PKRS is off, we need to migrate L1's
>> PKRS to L2.
> 
> I'm thinking of the case where vmx->nested.nested_run_pending is
> false, and we are processing a KVM_SET_NESTED_STATE ioctl, yet
> VM_ENTRY_LOAD_IA32_PKRS *is* set in the vmcs12.
> 

Oh, I miss this case. What I'm still confused here is that the 
restoration for GUEST_IA32_DEBUGCTL and GUEST_BNDCFGS have the same 
issue, right? or I miss something.
