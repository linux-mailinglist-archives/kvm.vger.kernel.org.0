Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658EDD0925
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 10:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfJIIHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 04:07:20 -0400
Received: from mga03.intel.com ([134.134.136.65]:63394 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbfJIIHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 04:07:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 01:07:19 -0700
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="197945186"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.239.196.204]) ([10.239.196.204])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 09 Oct 2019 01:07:16 -0700
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
 <20191008121140.GN2294@hirez.programming.kicks-ass.net>
 <d492e08e-bf14-0a8b-bc8c-397f8893ddb5@linux.intel.com>
 <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <3f9c6787-6fe9-0867-3e85-d3fb661484d4@linux.intel.com>
Date:   Wed, 9 Oct 2019 16:07:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <bfd23868-064e-4bf5-4dfb-211d36c409c1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
On 2019/10/9 15:15, Paolo Bonzini wrote:
> On 09/10/19 05:14, Like Xu wrote:
>>>
>>>
>>>> I'm not sure is this your personal preference or is there a technical
>>>> reason such as this usage is not incompatible with union syntax?
>>>
>>> Apparently it 'works', so there is no hard technical reason, but
>>> consider that _Bool is specified as an integer type large enough to
>>> store the values 0 and 1, then consider it as a base type for a
>>> bitfield. That's just disguisting.
>>
>> It's reasonable. Thanks.
> 
> /me chimes in since this is KVM code after all...
> 
> For stuff like hardware registers, bitfields are probably a bad idea
> anyway, so let's only consider the case of space optimization.
> 
> bool:2 would definitely cause an eyebrow raise, but I don't see why
> bool:1 bitfields are a problem.  An integer type large enough to store
> the values 0 and 1 can be of any size bigger than one bit.
> 
> bool bitfields preserve the magic behavior where something like this:
> 
>    foo->x = y;
> 
> (x is a bool bitfield) would be compiled as
> 
>    foo->x = (y != 0);
> 
> which can be a plus or a minus depending on the point of view. :)
> Either way, bool bitfields are useful if you are using bitfields for
> space optimization, especially if you have existing code using bool and
> it might rely on the idiom above.
> 
> However, in this patch bitfields are unnecessary and they result in
> worse code from the compiler.  There is plenty of padding in struct
> kvm_pmu, with or without bitfields, so I'd go with "u8 event_count; bool
> enable_cleanup;" (or better "need_cleanup").

Thanks. The "u8 event_count; bool need_cleanup;" looks good to me.

So is the lazy release mechanism looks reasonable to you ?
If so, I may release the next version based on current feedback.

> 
> Thanks,
> 
> Paolo
> 

