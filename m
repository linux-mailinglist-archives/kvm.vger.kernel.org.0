Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270DA35DB6B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 11:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhDMJjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 05:39:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16553 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239428AbhDMJjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 05:39:35 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FKL8Q3g28zPqjV;
        Tue, 13 Apr 2021 17:36:22 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 13 Apr 2021 17:39:07 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20200828081157.15748-1-zhukeqian1@huawei.com>
 <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
 <YGzxzsRlqouaJv6a@google.com>
 <CANgfPd8g3o2mJZi8rtR6jBNeYJTNWR0LTEcD2PeNLJk9JTz4CQ@mail.gmail.com>
CC:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>, <wanghaibin.wang@huawei.com>
Message-ID: <ff6a2cbb-7b18-9528-4e13-8728966e8c84@huawei.com>
Date:   Tue, 13 Apr 2021 17:39:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8g3o2mJZi8rtR6jBNeYJTNWR0LTEcD2PeNLJk9JTz4CQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/4/13 1:19, Ben Gardon wrote:
> On Tue, Apr 6, 2021 at 4:42 PM Sean Christopherson <seanjc@google.com> wrote:
>>
>> +Ben
>>
>> On Tue, Apr 06, 2021, Keqian Zhu wrote:
>>> Hi Paolo,
>>>
>>> I plan to rework this patch and do full test. What do you think about this idea
>>> (enable dirty logging for huge pages lazily)?
>>
>> Ben, don't you also have something similar (or maybe the exact opposite?) in the
>> hopper?  This sounds very familiar, but I can't quite connect the dots that are
>> floating around my head...
> 
> Sorry for the late response, I was out of office last week.
Never mind, Sean has told to me. :)

> 
> Yes, we have two relevant features I'd like to reconcile somehow:
> 1.) Large page shattering - Instead of clearing a large TDP mapping,
> flushing the TLBs, then replacing it with an empty TDP page table, go
> straight from the large mapping to a fully pre-populated table. This
> is slightly slower because the table needs to be pre-populated, but it
> saves many vCPU page faults.
> 2.) Eager page splitting - split all large mappings down to 4k when
> enabling dirty logging, using large page shattering. This makes
> enabling dirty logging much slower, but speeds up the first round (and
> later rounds) of gathering / clearing the dirty log and reduces the
> number of vCPU page faults. We've prefered to do this when enabling
> dirty logging because it's a little less perf-sensitive than the later
> passes where latency and convergence are critical.
OK, I see. I think the lock stuff is an important part, so one question is that
the shattering process is designed to be locked (i.e., protect mapping) or lock-less?

If it's locked, vCPU thread may be blocked for a long time (For arm, there is a
mmu_lock per VM). If it's lock-less, how can we ensure the synchronization of
mapping?

> 
> Large page shattering can happen in the NPT page fault handler or the
> thread enabling dirty logging / clearing the dirty log, so it's
> more-or-less orthogonal to this patch.
> 
> Eager page splitting on the other hand takes the opposite approach to
> this patch, frontloading as much of the work to enable dirty logging
> as possible. Which approach is better is going to depend a lot on the
> guest workload, your live migration constraints, and how the
> user-space hypervisor makes use of KVM's growing number of dirty
> logging options. In our case, the time to migrate a VM is usually less
> of a concern than the performance degradation the guest experiences,
> so we want to do everything we can to minimize vCPU exits and exit
> latency.
Yes, make sense to me.

> 
> I think this is a reasonable change in principle if we're not write
> protecting 4k pages already, but it's hard to really validate all the
> performance implications. With this change we'd move pretty much all
> the work to the first pass of clearing the dirty log, which is
> probably an improvement since it's much more granular. The downside is
Yes, at least split large page lazily is better than current logic.

> that we do more work when we'd really like to be converging the dirty
> set as opposed to earlier when we know all pages are dirty anyway.
I think the dirty collecting procedure is not affected, do I miss something?

> 
>>
>>> PS: As dirty log of TDP MMU has been supported, I should add more code.
>>>
>>> On 2020/8/28 16:11, Keqian Zhu wrote:
>>>> Currently during enable dirty logging, if we're with init-all-set,
>>>> we just write protect huge pages and leave normal pages untouched,
>>>> for that we can enable dirty logging for these pages lazily.
>>>>
>>>> It seems that enable dirty logging lazily for huge pages is feasible
>>>> too, which not only reduces the time of start dirty logging, also
>>>> greatly reduces side-effect on guest when there is high dirty rate.
> 
> The side effect on the guest would also be greatly reduced with large
> page shattering above.
Sure.

> 
>>>>
>>>> (These codes are not tested, for RFC purpose :-) ).
>>>>
>>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |  3 +-
>>>>  arch/x86/kvm/mmu/mmu.c          | 65 ++++++++++++++++++++++++++-------
>>>>  arch/x86/kvm/vmx/vmx.c          |  3 +-
>>>>  arch/x86/kvm/x86.c              | 22 +++++------
>>>>  4 files changed, 62 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index 5303dbc5c9bc..201a068cf43d 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -1296,8 +1296,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>>>>
>>>>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
>>>>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>>>> -                                 struct kvm_memory_slot *memslot,
>>>> -                                 int start_level);
>>>> +                                 struct kvm_memory_slot *memslot);
>>>>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>>>>                                const struct kvm_memory_slot *memslot);
>>>>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>>> index 43fdb0c12a5d..4b7d577de6cd 100644
>>>> --- a/arch/x86/kvm/mmu/mmu.c
>>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>>> @@ -1625,14 +1625,45 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
>>>>  }
>>>>
>>>>  /**
>>>> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
>>>> + * kvm_mmu_write_protect_largepage_masked - write protect selected largepages
>>>>   * @kvm: kvm instance
>>>>   * @slot: slot to protect
>>>>   * @gfn_offset: start of the BITS_PER_LONG pages we care about
>>>>   * @mask: indicates which pages we should protect
>>>>   *
>>>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
>>>> - * logging we do not have any such mappings.
>>>> + * @ret: true if all pages are write protected
>>>> + */
>>>> +static bool kvm_mmu_write_protect_largepage_masked(struct kvm *kvm,
>>>> +                               struct kvm_memory_slot *slot,
>>>> +                               gfn_t gfn_offset, unsigned long mask)
>>>> +{
>>>> +   struct kvm_rmap_head *rmap_head;
>>>> +   bool protected, all_protected;
>>>> +   gfn_t start_gfn = slot->base_gfn + gfn_offset;
>>>> +   int i;
>>>> +
>>>> +   all_protected = true;
>>>> +   while (mask) {
>>>> +           protected = false;
>>>> +           for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
>>>> +                   rmap_head = __gfn_to_rmap(start_gfn + __ffs(mask), i, slot);
>>>> +                   protectd |= __rmap_write_protect(kvm, rmap_head, false);
>>>> +           }
>>>> +
>>>> +           all_protected &= protectd;
>>>> +           /* clear the first set bit */
>>>> +           mask &= mask - 1;
> 
> I'm a little confused by the use of mask in this function. If
> gfn_offset is aligned to some multiple of 64, which I think it is, all
> the bits in the mask will be part of the same large page, so I don't
> think the mask adds anything.
Right. We just need to consider the first set bit. Thanks for your careful review.

> I'm also not sure this function compiles since I think the use of
> protectd above will result in an error.
Yep, my fault.

And as I mentioned before, I should add more code to support TDP...

Thanks,
Keqian
