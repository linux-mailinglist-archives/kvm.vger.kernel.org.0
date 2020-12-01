Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F82C94A2
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 02:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgLAB0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 20:26:18 -0500
Received: from mga05.intel.com ([192.55.52.43]:61065 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730037AbgLAB0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 20:26:18 -0500
IronPort-SDR: LFYbiZ/PEyua4oe1WzzSIc5sZElrTRXEOel3At7VHFPpYtBfPRNfqynAM35aeP7Lz49UqFTOss
 i7F6HyntJcfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="257452991"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="257452991"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:25:37 -0800
IronPort-SDR: qJWgCtexdRDgL0abS9F/Mc757eplyHZlRPL8TtkC34L3iut3muWe84Cd/8TNTilIDhQyeeytPr
 mmKONjc+7wbw==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480886177"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:25:31 -0800
Subject: Re: [PATCH v2 04/17] perf: x86/ds: Handle guest PEBS overflow PMI and
 inject it to guest
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, wei.w.wang@intel.com,
        Tony Luck <tony.luck@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201109021254.79755-5-like.xu@linux.intel.com>
 <20201117143529.GJ3121406@hirez.programming.kicks-ass.net>
 <b2c3f889-44dd-cadb-f225-a4c5db3a4447@linux.intel.com>
 <20201118180721.GA3121392@hirez.programming.kicks-ass.net>
 <682011d8-934f-4c76-69b0-788f71d91961@intel.com>
 <20201130104935.GN3040@hirez.programming.kicks-ass.net>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <7739a926-8da8-32c5-650d-2ee46ddab1ed@intel.com>
Date:   Tue, 1 Dec 2020 09:25:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130104935.GN3040@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2020/11/30 18:49, Peter Zijlstra wrote:
> On Fri, Nov 27, 2020 at 10:14:49AM +0800, Xu, Like wrote:
>
>>> OK, but the code here wanted to inspect the guest DS from the host. It
>>> states this is somehow complicated/expensive. But surely we can at the
>>> very least map the first guest DS page somewhere so we can at least
>>> access the control bits without too much magic.
>> We note that the SDM has a contiguous present memory mapping
>> assumption about the DS save area and the PEBS buffer area.
>>
>> Therefore, we revisit your suggestion here and move it a bit forward:
>>
>> When the PEBS is enabled, KVM will cache the following values:
>> - gva ds_area (kvm msr trap)
>> - hva1 for "gva ds_area" (walk guest page table)
>> - hva2 for "gva pebs_buffer_base" via hva1 (walk guest page table)
> What this [gh]va? Guest/Host Virtual Address? I think you're assuming I
> know about all this virt crap,.. I don't.
Oh, my bad and let me add it:

gva: guest virtual address
gpa: guest physical address
gfn: guest frame number
hva: host virtual adderss
hpa: host physical address

In the KVM, we get hva from gva in the following way:

gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
gfn = gpa >> PAGE_SHIFT;
slot = gfn_to_memslot(kvm, gfn);
hva = gfn_to_hva_memslot_prot(slot, gfn, NULL);

>
>> if the "gva ds_area" cache hits,
> what?
Sorry, it looks a misuse of terminology.

I mean KVM will save the last used "gva ds_area" value and its hva in the 
extra fields,
if the "gva ds_area" does not change this time, we will not walk the guest 
page table
to get its hva again.

I think it's the main point in your suggestion, and I try to elaborate it.
>> - access PEBS "interrupt threshold" and "Counter Reset[]" via hva1
>> - get "gva2 pebs_buffer_base" via __copy_from_user(hva1)
> But you already had hva2, so what's the point?
hva1 is for for "gva ds_area"
hva2 is for "gva pebs_buffer_base"

The point is before using the last save hva2, we need to
make sure that "gva pebs_buffer_base" is not changed to avoid
that some malicious drivers may change it without changing ds_area.

>
>> if the "gva2 pebs_buffer_base" cache hits,
> What?
>
>> - we get "gva2 pebs_index" via __copy_from_user(hva2),
> pebs_index is in ds_are, which would be hva1
Yes, we get "gva2 pebs_index" via __copy_from_user(hva1).
>
>> - rewrite the guest PEBS records via hva2 and pebs_index
>>
>> If any cache misses, setup the cache values via walking tables again.
>>
>> I wonder if you would agree with this optimization idea,
>> we look forward to your confirmation for the next step.
> I'm utterly confused. I really can't follow.
Generally, KVM will save hva1 (gva1 ds_area) and hva2 (for gva2 
pebs_buffer_base)
in the first round of the guest page table walking and reuse them
if they're not changed in subsequent use.

I think this approach is feasible, and please complain if you are still 
confused or disagree.

Thanks,
Like Xu
