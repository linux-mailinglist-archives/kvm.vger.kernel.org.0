Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8D346CB8D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 04:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbhLHDcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 22:32:52 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:45599 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236530AbhLHDcw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 22:32:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Uzq7g5R_1638934156;
Received: from 30.22.113.150(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uzq7g5R_1638934156)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 11:29:18 +0800
Message-ID: <65955c88-e15e-cce2-a64d-9dbacc29ad2e@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 11:29:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 16/15] KVM: X86: Update mmu->pdptrs only when it is
 changed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144527.88852-1-jiangshanlai@gmail.com> <Ya/xsx1pcB0Pq/Pm@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <Ya/xsx1pcB0Pq/Pm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/8 07:43, Sean Christopherson wrote:
> On Thu, Nov 11, 2021, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> It is unchanged in most cases.
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6ca19cac4aff..0176eaa86a35 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -828,10 +828,13 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>>   		}
>>   	}
>>   
>> -	memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>> -	kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>> -	/* Ensure the dirty PDPTEs to be loaded. */
>> -	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +	kvm_register_mark_available(vcpu, VCPU_EXREG_PDPTR);
>> +	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
>> +		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>> +		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>> +		/* Ensure the dirty PDPTEs to be loaded. */
>> +		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +	}
> 
> Can this be unqueued until there's sufficient justification that (a) this is
> correct and (b) actually provides a meaningful performance optimization?  There
> have been far too many PDPTR caching bugs to make this change without an analysis
> of why it's safe, e.g. what guarantees the that PDPTRs in the VMCS are sync'd
> with mmu->pdptrs?  I'm not saying they aren't, I just want the changelog to prove
> that they are.

I have zero intent to improve performance for 32bit guests.

For correctness, the patch needs to be revaluated, I agree it to be unqueued.


> 
> The next patch does add a fairly heavy unload of the current root for !TDP, but
> that's a bug fix and should be ordered before any optimizations anyways.

I don't have strong option on the patch ordering and I have a preference which is
already applied to other patchset.

This patch is a preparation patch for next patch.  It has very limited or even
negative value without next patch and it was not in the original 15-patch patchset
until I found the defect fixed by the next patch that I appended both as "16/15"
and "17/15".

But kvm has many small defects for so many years, I has fixed several in this
circle and there are some pending.

And the kvm works for so many years even with these small defects and they only
hit when the guest deliberately do something, and even the guest does these things,
it only reveals that the kvm doesn't fully conform the SDM, it can't hurt host any
degree.

For important fix or for bug that can hurt host, I would definitely make the bug
fix first and other patches are ordered later.

For defect like this, I prefer "clean" patches policy: several cleanup or
preparation patches first to give the code a better basic and then fix the defects.

It is OK for me if fixes like this (normal guest doesn't hit it and it can't hurt
host) go into or doesn't go into the stable tree.

For example, I used my patch ordering policy in "permission_fault() for SMAP"
patchset where the fix went in patch3 which fixes implicit supervisor access when
the CPL < 3.  For next spin, I would be a new preparation patch first to add
"implicit access" in pfec. The fix itself can't go as the first patch.

This is a reply not specified to this patch.  And for this patch and next patch I
will take your suggestion or another possible approach.

Thanks
Lai
