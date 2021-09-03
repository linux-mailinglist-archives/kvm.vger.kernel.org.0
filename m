Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A866F4003C4
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 19:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350170AbhICRBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 13:01:37 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:48422 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235492AbhICRBg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 13:01:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0Un7jB2E_1630688433;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Un7jB2E_1630688433)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 04 Sep 2021 01:00:34 +0800
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com> <YTFhCt87vzo4xDrc@google.com>
 <YTFkMvdGug3uS2e4@google.com>
 <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
 <YTJIBr/lm5QU/Z3W@google.com>
 <7067bec0-8a15-1a18-481e-e2ea79575dcf@linux.alibaba.com>
 <YTJP/Ys8Fdxdm/Qk@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <c3bd7db9-2356-2bb3-4869-7c3edf922e53@linux.alibaba.com>
Date:   Sat, 4 Sep 2021 01:00:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTJP/Ys8Fdxdm/Qk@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/9/4 00:40, Sean Christopherson wrote:
> On Sat, Sep 04, 2021, Lai Jiangshan wrote:
>>
>> On 2021/9/4 00:06, Sean Christopherson wrote:
>>
>>> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
>>> index 50ade6450ace..2ff123ec0d64 100644
>>> --- a/arch/x86/kvm/mmu/paging_tmpl.h
>>> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
>>> @@ -704,6 +704,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>>>    			access = gw->pt_access[it.level - 2];
>>>    			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
>>>    					      it.level-1, false, access);
>>> +			if (sp->unsync_children &&
>>> +			    mmu_sync_children(vcpu, sp, false))
>>> +				return RET_PF_RETRY;
>>
>> It was like my first (unsent) fix.  Just return RET_PF_RETRY when break.
>>
>> And then I thought that it'd be better to retry fetching directly rather than
>> retry guest when the conditions are still valid/unchanged to avoid all the
>> next guest page walking and GUP().  Although the code does not check all
>> conditions such as interrupt event pending. (we can add that too)
> 
> But not in a bug fix that needs to go to stable branches.

Good point, it is too complicated for a fix, I accept just "return RET_PF_RETRY".
(and don't need "SOME_ARBITRARY_THRESHOLD").

Is it Ok? I will update the patch as it.

>   
>> I think it is a good design to allow break mmu_lock when mmu is handling
>> heavy work.
> 
> I don't disagree in principle, but I question the relevance/need.  I doubt this
> code is relevant to nested TDP performance as hypervisors generally don't do the
> type of PTE manipulations that would lead to linking an existing unsync sp.  And
> for legacy shadow paging, my preference would be to put it into maintenance-only
> mode as much as possible.  I'm not dead set against new features/functionality
> for shadow paging, but for something like dropping mmu_lock in the page fault path,
> IMO there needs to be performance numbers to justify such a change.
> 

I understood the concern and the relevance/need.

