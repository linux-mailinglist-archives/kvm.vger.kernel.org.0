Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5931B35E44E
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343993AbhDMQp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 12:45:27 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:34617 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhDMQpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 12:45:25 -0400
Received: by mail-io1-f44.google.com with SMTP id x16so17745675iob.1
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 09:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iW2orkpn3/bzDHR5jPZkG2zO1Q6UU2wcOtmPep0vycU=;
        b=ptKyptyd2M1R0uP2kg7qbRB0HFHBiTngZVZp76hLjgU8pntkRy/yfJhGlG6fZXFUUX
         Z2Mx8p6wcLsvoG4FFjuLw08Cho9ybo0HMb0eHuUnIvtDRzqbI6n/bGALY4bOATp/WIrI
         o7WmoJ5gcVbyKVsF6dZed5p+peWEuSaHuAPh3sO0w4wgxXNXQtc2JkR6ziEiGzoJbaL0
         v4GsqH6hMD6qg1Z1mHesX0XcqBJ/0tdkLRvQTamAXl0nQBrIkrUOTz4q3TtPPApEmYDj
         D8aOUXTM35MulbndOdkKUX2OiTLHiKVIzUfqrBLFbXziVtLyaMO0oKW79jUBbxI0RP2z
         Z96w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iW2orkpn3/bzDHR5jPZkG2zO1Q6UU2wcOtmPep0vycU=;
        b=QLjQ4oeF7/IXXYnOyljMYEq6i0NUs0/O3tAazsw2EMkZ7qI9TjA57MWwOOsn8pXS9U
         fFbLZGI4/TMiOZkll/brCygWZJIZheWdV+5wwLNxEsQqE8BkmIkCtu/f8eUKfYnkw3hX
         vxQGfER7qkmjHKLr4RdIR4zBuIGPL/rMo2GShU6T4EFPvUViDLm/7Q8jjvTpeRU2vdEb
         kKdo4WXFAR1uedyMRNKs/LAElcygMpa1Ol2nEOeKuiIKG545VU0mMdv4/Pw7h9VKNKHC
         CiAM1i/bQH3Ojz1AvrSAjEYKO26m7T1fMvFz5jAIBobG4AzyBrs4S+GgvDz+T4CqLRoS
         rySQ==
X-Gm-Message-State: AOAM531zdSXqIx+Qn/paBdl3IdjrJIcbsklM3sUAiNgLADFiXuNFJLQI
        FL4s7Ufn7nbtaI5DYMnhiR9eJtfmuW+SYYXKhhu4VQ==
X-Google-Smtp-Source: ABdhPJyk/d7gyQFEWjiwVrht2iN3YM/8SZ4nXYtZYT8ezEwvOL/DChwvZ7s5Zpi69z55104KJUzOiXqG87IBkF8ykHM=
X-Received: by 2002:a05:6638:1648:: with SMTP id a8mr34063909jat.25.1618332245231;
 Tue, 13 Apr 2021 09:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200828081157.15748-1-zhukeqian1@huawei.com> <107696eb-755f-7807-a484-da63aad01ce4@huawei.com>
 <YGzxzsRlqouaJv6a@google.com> <CANgfPd8g3o2mJZi8rtR6jBNeYJTNWR0LTEcD2PeNLJk9JTz4CQ@mail.gmail.com>
 <ff6a2cbb-7b18-9528-4e13-8728966e8c84@huawei.com>
In-Reply-To: <ff6a2cbb-7b18-9528-4e13-8728966e8c84@huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Apr 2021 09:43:54 -0700
Message-ID: <CANgfPd_h509o3kQGEQjuy2tzqnQ+toR4snJVAug=N2TULce3ag@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 2:39 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>
>
>
> On 2021/4/13 1:19, Ben Gardon wrote:
> > On Tue, Apr 6, 2021 at 4:42 PM Sean Christopherson <seanjc@google.com> wrote:
> >>
> >> +Ben
> >>
> >> On Tue, Apr 06, 2021, Keqian Zhu wrote:
> >>> Hi Paolo,
> >>>
> >>> I plan to rework this patch and do full test. What do you think about this idea
> >>> (enable dirty logging for huge pages lazily)?
> >>
> >> Ben, don't you also have something similar (or maybe the exact opposite?) in the
> >> hopper?  This sounds very familiar, but I can't quite connect the dots that are
> >> floating around my head...
> >
> > Sorry for the late response, I was out of office last week.
> Never mind, Sean has told to me. :)
>
> >
> > Yes, we have two relevant features I'd like to reconcile somehow:
> > 1.) Large page shattering - Instead of clearing a large TDP mapping,
> > flushing the TLBs, then replacing it with an empty TDP page table, go
> > straight from the large mapping to a fully pre-populated table. This
> > is slightly slower because the table needs to be pre-populated, but it
> > saves many vCPU page faults.
> > 2.) Eager page splitting - split all large mappings down to 4k when
> > enabling dirty logging, using large page shattering. This makes
> > enabling dirty logging much slower, but speeds up the first round (and
> > later rounds) of gathering / clearing the dirty log and reduces the
> > number of vCPU page faults. We've prefered to do this when enabling
> > dirty logging because it's a little less perf-sensitive than the later
> > passes where latency and convergence are critical.
> OK, I see. I think the lock stuff is an important part, so one question is that
> the shattering process is designed to be locked (i.e., protect mapping) or lock-less?
>
> If it's locked, vCPU thread may be blocked for a long time (For arm, there is a
> mmu_lock per VM). If it's lock-less, how can we ensure the synchronization of
> mapping?

The TDP MMU for x86 could do it under the MMU read lock, but the
legacy / shadow x86 MMU and other architectures would need the whole
MMU lock.
While we do increase the time required to address a large SPTE, we can
completely avoid the vCPU needing the MMU lock on an access to that
SPTE as the translation goes straight from a large, writable SPTE, to
a 4k spte with either the d bit cleared or write protected. If it's
write protected, the fault can (at least on x86) be resolved without
the MMU lock.

When I'm able to put together a large page shattering series, I'll do
some performance analysis and see how it changes things, but that part
is sort of orthogonal to this change. The more I think about it, the
better the init-all-set approach for large pages sounds, compared to
eager splitting. I'm definitely in support of this patch and am happy
to help review when you send out the v2 with TDP MMU support and such.

>
> >
> > Large page shattering can happen in the NPT page fault handler or the
> > thread enabling dirty logging / clearing the dirty log, so it's
> > more-or-less orthogonal to this patch.
> >
> > Eager page splitting on the other hand takes the opposite approach to
> > this patch, frontloading as much of the work to enable dirty logging
> > as possible. Which approach is better is going to depend a lot on the
> > guest workload, your live migration constraints, and how the
> > user-space hypervisor makes use of KVM's growing number of dirty
> > logging options. In our case, the time to migrate a VM is usually less
> > of a concern than the performance degradation the guest experiences,
> > so we want to do everything we can to minimize vCPU exits and exit
> > latency.
> Yes, make sense to me.
>
> >
> > I think this is a reasonable change in principle if we're not write
> > protecting 4k pages already, but it's hard to really validate all the
> > performance implications. With this change we'd move pretty much all
> > the work to the first pass of clearing the dirty log, which is
> > probably an improvement since it's much more granular. The downside is
> Yes, at least split large page lazily is better than current logic.
>
> > that we do more work when we'd really like to be converging the dirty
> > set as opposed to earlier when we know all pages are dirty anyway.
> I think the dirty collecting procedure is not affected, do I miss something?

Oh yeah, good point. Since the splitting of large SPTEs is happening
in the vCPU threads it wouldn't slow dirty log collection at all. We
would have to do slightly more work to write protect the large SPTEs
that weren't written to, but that's a relatively small amount of work.

>
> >
> >>
> >>> PS: As dirty log of TDP MMU has been supported, I should add more code.
> >>>
> >>> On 2020/8/28 16:11, Keqian Zhu wrote:
> >>>> Currently during enable dirty logging, if we're with init-all-set,
> >>>> we just write protect huge pages and leave normal pages untouched,
> >>>> for that we can enable dirty logging for these pages lazily.
> >>>>
> >>>> It seems that enable dirty logging lazily for huge pages is feasible
> >>>> too, which not only reduces the time of start dirty logging, also
> >>>> greatly reduces side-effect on guest when there is high dirty rate.
> >
> > The side effect on the guest would also be greatly reduced with large
> > page shattering above.
> Sure.
>
> >
> >>>>
> >>>> (These codes are not tested, for RFC purpose :-) ).
> >>>>
> >>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> >>>> ---
> >>>>  arch/x86/include/asm/kvm_host.h |  3 +-
> >>>>  arch/x86/kvm/mmu/mmu.c          | 65 ++++++++++++++++++++++++++-------
> >>>>  arch/x86/kvm/vmx/vmx.c          |  3 +-
> >>>>  arch/x86/kvm/x86.c              | 22 +++++------
> >>>>  4 files changed, 62 insertions(+), 31 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >>>> index 5303dbc5c9bc..201a068cf43d 100644
> >>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>> @@ -1296,8 +1296,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
> >>>>
> >>>>  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
> >>>>  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >>>> -                                 struct kvm_memory_slot *memslot,
> >>>> -                                 int start_level);
> >>>> +                                 struct kvm_memory_slot *memslot);
> >>>>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >>>>                                const struct kvm_memory_slot *memslot);
> >>>>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
> >>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>>> index 43fdb0c12a5d..4b7d577de6cd 100644
> >>>> --- a/arch/x86/kvm/mmu/mmu.c
> >>>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>>> @@ -1625,14 +1625,45 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
> >>>>  }
> >>>>
> >>>>  /**
> >>>> - * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
> >>>> + * kvm_mmu_write_protect_largepage_masked - write protect selected largepages
> >>>>   * @kvm: kvm instance
> >>>>   * @slot: slot to protect
> >>>>   * @gfn_offset: start of the BITS_PER_LONG pages we care about
> >>>>   * @mask: indicates which pages we should protect
> >>>>   *
> >>>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
> >>>> - * logging we do not have any such mappings.
> >>>> + * @ret: true if all pages are write protected
> >>>> + */
> >>>> +static bool kvm_mmu_write_protect_largepage_masked(struct kvm *kvm,
> >>>> +                               struct kvm_memory_slot *slot,
> >>>> +                               gfn_t gfn_offset, unsigned long mask)
> >>>> +{
> >>>> +   struct kvm_rmap_head *rmap_head;
> >>>> +   bool protected, all_protected;
> >>>> +   gfn_t start_gfn = slot->base_gfn + gfn_offset;
> >>>> +   int i;
> >>>> +
> >>>> +   all_protected = true;
> >>>> +   while (mask) {
> >>>> +           protected = false;
> >>>> +           for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
> >>>> +                   rmap_head = __gfn_to_rmap(start_gfn + __ffs(mask), i, slot);
> >>>> +                   protectd |= __rmap_write_protect(kvm, rmap_head, false);
> >>>> +           }
> >>>> +
> >>>> +           all_protected &= protectd;
> >>>> +           /* clear the first set bit */
> >>>> +           mask &= mask - 1;
> >
> > I'm a little confused by the use of mask in this function. If
> > gfn_offset is aligned to some multiple of 64, which I think it is, all
> > the bits in the mask will be part of the same large page, so I don't
> > think the mask adds anything.
> Right. We just need to consider the first set bit. Thanks for your careful review.
>
> > I'm also not sure this function compiles since I think the use of
> > protectd above will result in an error.
> Yep, my fault.
>
> And as I mentioned before, I should add more code to support TDP...
>
> Thanks,
> Keqian
