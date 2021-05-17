Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5773A382799
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 10:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhEQI5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 04:57:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:2471 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232924AbhEQI5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 04:57:19 -0400
IronPort-SDR: enhxaejO5msepE1w+j+ajsBYc4Zfuiv6pZE8MpXEg8F/DXqZwy38tXSHs5jat9No+wX09ynuwT
 IbIbJg7x9rBQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="198466284"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="198466284"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:55:57 -0700
IronPort-SDR: D1BpDsUshQ4pQouJ7MbqFlOfJyByb+EIHh/s6nPJE8V7JmiwcOTpGUaorT6qW0aWTprGcaM8Wv
 rxpuhGcJtpGw==
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="472307013"
Received: from unknown (HELO [10.239.13.114]) ([10.239.13.114])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:55:53 -0700
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Tao Xu <tao3.xu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
 <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
 <20201102183359.GE21563@linux.intel.com>
 <5117f8d3-c40c-204d-b09c-e49af42ad665@intel.com>
Message-ID: <62084ff3-3fe0-ae16-a6c0-8254a81253fa@intel.com>
Date:   Mon, 17 May 2021 16:55:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5117f8d3-c40c-204d-b09c-e49af42ad665@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/2021 3:20 PM, Xiaoyao Li wrote:
> Hi Sean, Andy and Paolo,

+ real Sean

> On 11/3/2020 2:33 AM, Sean Christopherson wrote:
>> On Mon, Nov 02, 2020 at 10:01:16AM -0800, Andy Lutomirski wrote:
>>> On Mon, Nov 2, 2020 at 9:31 AM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>>
>>>> Tao, this patch should probably be tagged RFC, at least until we can 
>>>> experiment
>>>> with the threshold on real silicon.  KVM and kernel behavior may 
>>>> depend on the
>>>> accuracy of detecting actual attacks, e.g. if we can set a threshold 
>>>> that has
>>>> zero false negatives and near-zero false postives, then it probably 
>>>> makes sense
>>>> to be more assertive in how such VM-Exits are reported and logged.
>>>
>>> If you can actually find a threshold that reliably mitigates the bug
>>> and does not allow a guest to cause undesirably large latency in the
>>> host, then fine.  1/10 if a tick is way too long, I think.
>>
>> Yes, this was my internal review feedback as well.  Either that got 
>> lost along
>> the way or I wasn't clear enough in stating what should be used as a 
>> placeholder
>> until we have silicon in hand.
>>
> 
> We have tested on real silicon and found it can work even with threshold 
> being set to 0.
> 
> It has an internal threshold, which is added to vmcs.notify_window as 
> the final effective threshold. The internal threshold is big enough to 
> cover normal instructions. For those long latency instructions like 
> WBINVD, the processor knows they cannot cause no interrupt window 
> attack. So no Notify VM exit will happen on them.
> 
> Initially, our hardware architect wants to set the notify window to 
> scheduler tick to not break kernel scheduling. But you folks want a 
> smaller one. So are you OK to set the window to 0?
> 
> 

