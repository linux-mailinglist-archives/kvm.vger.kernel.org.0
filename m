Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1784A365387
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 09:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhDTHuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 03:50:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17378 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhDTHuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 03:50:05 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FPbPh51SJzjZrS;
        Tue, 20 Apr 2021 15:47:36 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 20 Apr 2021 15:49:26 +0800
Subject: Re: [RFC PATCH v2 2/2] KVM: x86: Not wr-protect huge page with
 init_all_set dirty log
To:     Ben Gardon <bgardon@google.com>
References: <20210416082511.2856-1-zhukeqian1@huawei.com>
 <20210416082511.2856-3-zhukeqian1@huawei.com>
 <CANgfPd_WzX6Fm7BiMoBoehuLL8tjh4WEqehUhF8biPyL8vS4XQ@mail.gmail.com>
CC:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <49e6bf4f-0142-c9ea-a8c1-7cfe211c8d7b@huawei.com>
Date:   Tue, 20 Apr 2021 15:49:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd_WzX6Fm7BiMoBoehuLL8tjh4WEqehUhF8biPyL8vS4XQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

On 2021/4/20 3:20, Ben Gardon wrote:
> On Fri, Apr 16, 2021 at 1:25 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>>
>> Currently during start dirty logging, if we're with init-all-set,
>> we write protect huge pages and leave normal pages untouched, for
>> that we can enable dirty logging for these pages lazily.
>>
>> Actually enable dirty logging lazily for huge pages is feasible
>> too, which not only reduces the time of start dirty logging, also
>> greatly reduces side-effect on guest when there is high dirty rate.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 48 ++++++++++++++++++++++++++++++++++++++----
>>  arch/x86/kvm/x86.c     | 37 +++++++++-----------------------
>>  2 files changed, 54 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 2ce5bc2ea46d..98fa25172b9a 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -1188,8 +1188,7 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>>   * @gfn_offset: start of the BITS_PER_LONG pages we care about
>>   * @mask: indicates which pages we should protect
>>   *
>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
>> - * logging we do not have any such mappings.
>> + * Used when we do not need to care about huge page mappings.
>>   */
>>  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>>                                      struct kvm_memory_slot *slot,
>> @@ -1246,13 +1245,54 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
>>   * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
>>   * enable dirty logging for them.
>>   *
>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
>> - * logging we do not have any such mappings.
>> + * We need to care about huge page mappings: e.g. during dirty logging we may
>> + * have any such mappings.
>>   */
>>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>>                                 struct kvm_memory_slot *slot,
>>                                 gfn_t gfn_offset, unsigned long mask)
>>  {
>> +       gfn_t start, end;
>> +
>> +       /*
>> +        * Huge pages are NOT write protected when we start dirty log with
>> +        * init-all-set, so we must write protect them at here.
>> +        *
>> +        * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
>> +        * of memslot has no such restriction, so the range can cross two large
>> +        * pages.
>> +        */
>> +       if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>> +               start = slot->base_gfn + gfn_offset + __ffs(mask);
>> +               end = slot->base_gfn + gfn_offset + __fls(mask);
>> +               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
>> +
>> +               /* Cross two large pages? */
>> +               if (ALIGN(start << PAGE_SHIFT, PMD_SIZE) !=
>> +                   ALIGN(end << PAGE_SHIFT, PMD_SIZE))
>> +                       kvm_mmu_slot_gfn_write_protect(kvm, slot, end,
>> +                                                      PG_LEVEL_2M);
>> +       }
>> +
>> +       /*
>> +        * RFC:
>> +        *
>> +        * 1. I don't return early when kvm_mmu_slot_gfn_write_protect() returns
>> +        * true, because I am not very clear about the relationship between
>> +        * legacy mmu and tdp mmu. AFAICS, the code logic is NOT an if/else
>> +        * manner.
>> +        *
>> +        * The kvm_mmu_slot_gfn_write_protect() returns true when we hit a
>> +        * writable large page mapping in legacy mmu mapping or tdp mmu mapping.
>> +        * Do we still have normal mapping in that case? (e.g. We have large
>> +        * mapping in legacy mmu and normal mapping in tdp mmu).
> 
> Right, we can't return early because the two MMUs could map the page
> in different ways, but each MMU could also map the page in multiple
> ways independently.
> For example, if the legacy MMU was being used and we were running a
> nested VM, a page could be mapped 2M in EPT01 and 4K in EPT02, so we'd
> still need kvm_mmu_slot_gfn_write_protect  calls for both levels.
> I don't think there's a case where we can return early here with the
> information that the first calls to kvm_mmu_slot_gfn_write_protect
> access.
Thanks for the detailed explanation.

> 
>> +        *
>> +        * 2. kvm_mmu_slot_gfn_write_protect() doesn't tell us whether the large
>> +        * page mapping exist. If it exists but is clean, we can return early.
>> +        * However, we have to do invasive change.
> 
> What do you mean by invasive change?
We need the kvm_mmu_slot_gfn_write_protect to report whether all mapping are large
and clean, so we can return early. However it's not a part of semantics of this function.

If this is the final code, compared to old code, we have an extra gfn_write_protect(),
I don't whether it's acceptable?

Thanks,
Keqian


> 
>> +        */
>> +
>> +       /* Then we can handle the PT level pages */
>>         if (kvm_x86_ops.cpu_dirty_log_size)
>>                 kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
>>         else
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index eca63625aee4..dfd676ffa7da 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10888,36 +10888,19 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>>                  */
>>                 kvm_mmu_zap_collapsible_sptes(kvm, new);
>>         } else {
>> -               /* By default, write-protect everything to log writes. */
>> -               int level = PG_LEVEL_4K;
>> +               /*
>> +                * If we're with initial-all-set, we don't need to write protect
>> +                * any page because they're reported as dirty already.
>> +                */
>> +               if (kvm_dirty_log_manual_protect_and_init_set(kvm))
>> +                       return;
>>
>>                 if (kvm_x86_ops.cpu_dirty_log_size) {
>> -                       /*
>> -                        * Clear all dirty bits, unless pages are treated as
>> -                        * dirty from the get-go.
>> -                        */
>> -                       if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
>> -                               kvm_mmu_slot_leaf_clear_dirty(kvm, new);
>> -
>> -                       /*
>> -                        * Write-protect large pages on write so that dirty
>> -                        * logging happens at 4k granularity.  No need to
>> -                        * write-protect small SPTEs since write accesses are
>> -                        * logged by the CPU via dirty bits.
>> -                        */
>> -                       level = PG_LEVEL_2M;
>> -               } else if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
>> -                       /*
>> -                        * If we're with initial-all-set, we don't need
>> -                        * to write protect any small page because
>> -                        * they're reported as dirty already.  However
>> -                        * we still need to write-protect huge pages
>> -                        * so that the page split can happen lazily on
>> -                        * the first write to the huge page.
>> -                        */
>> -                       level = PG_LEVEL_2M;
>> +                       kvm_mmu_slot_leaf_clear_dirty(kvm, new);
>> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
>> +               } else {
>> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
>>                 }
>> -               kvm_mmu_slot_remove_write_access(kvm, new, level);
>>         }
>>  }
>>
>> --
>> 2.23.0
>>
> .
> 
