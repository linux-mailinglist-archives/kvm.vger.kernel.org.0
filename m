Return-Path: <kvm+bounces-46374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5292FAB5B6B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE4394C1BB8
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 17:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD902BEC2F;
	Tue, 13 May 2025 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vss0vy3q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63320645
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157624; cv=none; b=QQcCtIn60E/PzjP+36NCmRoYmtmh7j231FS409lsUTtgb8h1dIoBQ2WV12RT7MpEZBesDf8P0v+h6tBt/mAi4FshxDAnJpbJswDL0TC9CmwXrZG8XuJISteCoaX8p3sRbnz62CQZa7nYD2KdEUFV107eloctSB+PSKQSqYUsxQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157624; c=relaxed/simple;
	bh=UsF6HG16axyOEZ/Utyd531RQaYOSyimthyIueQnbsZI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pvYRZ8jNAPH1hpIgqXAMGvlI6JUKfWZWmjluIU6fAqK9zRDCQNngrEyfuosZ3KA0FExDeJpLDTmfP4b4wYl506QJ4KlrHaEmxxQgyLyWkEnekwKTSWCo9wmGB0Y+78eR4+U1NUgXg0BCkreV9BAWL2VzrAYMXtdcZYgGF3GiwyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vss0vy3q; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so9459380a91.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747157622; x=1747762422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fV79NjYFq2VlF5V68DyneLa/vutPr1U/0jQFLwhrO54=;
        b=Vss0vy3q6NQZ7x/JaXEckp8PitDQQjWsHA4YGVpu1for3pHIPuXM+Gl+zuuSH0d+eL
         LTrnXjps/xJjcWq2OS5/Dqab4UNsJPes4WtUurv77syAhvVsDn/MtRATS/Cq+tmC21Ns
         cprtg+aLuJP7tMSEVwdX5b9rg6wQr6gcOZHddvLiw9f/JoyLYJrYcwRjvgnG1JZ3/VyR
         7KkDkNytM/w44/0xs/aDb+5/fXrJuKfYSe4nNq/Gr53xczmiuX1S/i7jcIZFpV6elTHU
         p9LYXwOPA87POSENdvrqcRQg24a0JNySi6YfaWKVnWU4XL6EqeUn5SIukbL2Ixg1omNe
         4MqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157622; x=1747762422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fV79NjYFq2VlF5V68DyneLa/vutPr1U/0jQFLwhrO54=;
        b=B8CH+kB9HHV38+iBEbZS9BpvDt3vtQylzU/iZJ9s5bYRYv4b7B/g9qAIk/5VqcKZDr
         jbVo429dxbge8OCPcDGK5RSGTC5Wd3K7A0GzchpHQvrKKA/PVkoLV1OBCshYEd+JwnRE
         bTMKA0ByzNjrlAjXcgky7vgUv+ecr8uc3160yGhcDfWlkXBbHyDw8bV1iFQ8nwU15SoV
         XHhM694C5D+V0Bn0Q9BmEIK80Zu4LxacwH9wPsLprMwWo8AezoXQyj2VpV/VfWXb7aw8
         RCEL1O269qkpK7AbdHurlAG1b0pxM5YFgfrgA9NYbvv3dm0kGfxa1ym4mUWjS0ZVtBGj
         KtbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWufNs+hgY1+UNKFYBQrZnDRG2DTrQX2GSAQI/+DVmYhtaFWj1hCmxUw9HS9TCEUOj4BBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGwrgDS+UIMNNIPfli+FtgXQRXieq0yyuX362alblWQt3kbnyr
	XfC7rQx9czusdSPiYoEPlpZPfHEMkOB+I/ChjOfTrbrPrT5lWt9yfP8lpJFm6LpCSgHQGVv0r2v
	6vXKSL+CEBZX3KhcNu6cZ6g==
X-Google-Smtp-Source: AGHT+IE/QrqCYoxMifQdYTL4Mo/fH2ztj6AZJmvHJIXStI/hx6qgpbSxckXMzWhT9nWhSwuOjFbrkE+J8cHlliT1AQ==
X-Received: from pjbsf4.prod.google.com ([2002:a17:90b:51c4:b0:30a:7c16:a1aa])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:38c4:b0:2fe:b174:31fe with SMTP id 98e67ed59e1d1-30e2e583d63mr688641a91.2.1747157621644;
 Tue, 13 May 2025 10:33:41 -0700 (PDT)
Date: Tue, 13 May 2025 10:33:40 -0700
In-Reply-To: <aBrQYIyrxhqd+fBO@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com> <diqz4iy5xvgi.fsf@ackerleytng-ctop.c.googlers.com>
 <aBlkplRxLNojF4m1@yzhao56-desk.sh.intel.com> <diqz1pt1sfw8.fsf@ackerleytng-ctop.c.googlers.com>
 <aBrQYIyrxhqd+fBO@yzhao56-desk.sh.intel.com>
Message-ID: <diqzv7q4pg97.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 39/39] KVM: guest_memfd: Dynamically split/reconstruct
 HugeTLB page
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: vannapurve@google.com, chenyi.qiang@intel.com, tabba@google.com, 
	quic_eberman@quicinc.com, roypat@amazon.co.uk, jgg@nvidia.com, 
	peterx@redhat.com, david@redhat.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, seanjc@google.com, pbonzini@redhat.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	isaku.yamahata@intel.com, muchun.song@linux.dev, erdemaktas@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Tue, May 06, 2025 at 12:22:47PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>> 
>> >> > <snip>
>> >> >
>> >> > What options does userspace have in this scenario?
>> >> > It can't reduce the flag to KVM_GUEST_MEMFD_HUGE_2MB. Adjusting the gmem.pgoff
>> >> > isn't ideal either.
>> >> >
>> >> > What about something similar as below?
>> >> >
>> >> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> >> > index d2feacd14786..87c33704a748 100644
>> >> > --- a/virt/kvm/guest_memfd.c
>> >> > +++ b/virt/kvm/guest_memfd.c
>> >> > @@ -1842,8 +1842,16 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
>> >> >         }
>> >> >
>> >> >         *pfn = folio_file_pfn(folio, index);
>> >> > -       if (max_order)
>> >> > -               *max_order = folio_order(folio);
>> >> > +       if (max_order) {
>> >> > +               int order;
>> >> > +
>> >> > +               order = folio_order(folio);
>> >> > +
>> >> > +               while (order > 0 && ((slot->base_gfn ^ slot->gmem.pgoff) & ((1 << order) - 1)))
>> >> > +                       order--;
>> >> > +
>> >> > +               *max_order = order;
>> >> > +       }
>> >> >
>> >> >         *is_prepared = folio_test_uptodate(folio);
>> >> >         return folio;
>> >> >
>> >> 
>> >> Vishal was wondering how this is working before guest_memfd was
>> >> introduced, for other backing memory like HugeTLB.
>> >> 
>> >> I then poked around and found this [1]. I will be adding a similar check
>> >> for any slot where kvm_slot_can_be_private(slot).
>> >>
>> >> Yan, that should work, right?
>> > No, I don't think the checking of ugfn [1] should work.
>> >
>> > 1. Even for slots bound to in-place-conversion guest_memfd (i.e. shared memory
>> > are allocated from guest_memfd), the slot->userspace_addr does not necessarily
>> > have the same offset as slot->gmem.pgoff. Even if we audit the offset in
>> > kvm_gmem_bind(), userspace could invoke munmap() and mmap() afterwards, causing
>> > slot->userspace_addr to point to a different offset.
>> >
>> > 2. for slots bound to guest_memfd that do not support in-place-conversion,
>> > shared memory is allocated from a different backend. Therefore, checking
>> > "slot->base_gfn ^ slot->gmem.pgoff" is required for private memory. The check is
>> > currently absent because guest_memfd supports 4K only.
>> >
>> >
>> 
>> Let me clarify, I meant these changes:
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4b64ab3..d0dccf1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12938,6 +12938,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages)
>>         return 0;
>>  }
>>  
>> +static inline bool kvm_is_level_aligned(u64 value, int level)
>> +{
>> +       return IS_ALIGNED(value, KVM_PAGES_PER_HPAGE(level));
>> +}
>> +
>>  static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>>                                       struct kvm_memory_slot *slot)
>>  {
>> @@ -12971,16 +12976,20 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>>  
>>                 slot->arch.lpage_info[i - 1] = linfo;
>>  
>> -               if (slot->base_gfn & (KVM_PAGES_PER_HPAGE(level) - 1))
>> +               if (!kvm_is_level_aligned(slot->base_gfn, level))
>>                         linfo[0].disallow_lpage = 1;
>> -               if ((slot->base_gfn + npages) & (KVM_PAGES_PER_HPAGE(level) - 1))
>> +               if (!kvm_is_level_aligned(slot->base_gfn + npages, level))
>>                         linfo[lpages - 1].disallow_lpage = 1;
>>                 ugfn = slot->userspace_addr >> PAGE_SHIFT;
>>                 /*
>> -                * If the gfn and userspace address are not aligned wrt each
>> -                * other, disable large page support for this slot.
>> +                * If the gfn and userspace address are not aligned or if gfn
>> +                * and guest_memfd offset are not aligned wrt each other,
>> +                * disable large page support for this slot.
>>                  */
>> -               if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
>> +               if (!kvm_is_level_aligned(slot->base_gfn ^ ugfn, level) ||
>> +                   (kvm_slot_can_be_private(slot) &&
>> +                    !kvm_is_level_aligned(slot->base_gfn ^ slot->gmem.pgoff,
>> +                                          level))) {
>>                         unsigned long j;
>>  
>>                         for (j = 0; j < lpages; ++j)
>> 
>> This does not rely on the ugfn check, but adds a similar check for gmem.pgoff.
> In the case of shared memory is not allocated from guest_memfd, (e.g. with the
> current upstream code), the checking of gmem.pgoff here will disallow huge page
> of shared memory even if "slot->base_gfn ^ ugfn" is aligned.
>

Thanks, I get it now. What you mean is that the memslot could have been
set up such that

+ slot->userspace_addr is aligned with slot->base_gfn, to be used for
  shared memory, and 
+ slot->gmem.pgoff is not aligned with slot->base_gfn, to be used for
  private memory

and this check would disallow huge page mappings even though this
memslot was going to only be used for shared memory.

The only way to fix this would indeed be a runtime check, since the
shared/private status can change at runtime.

I think it is okay that this check is stricter than necessary, since it
just results in mapping without huge pages.

What do you think?

>> I think this should take care of case (1.), for guest_memfds going to be
>> used for both shared and private memory. Userspace can't update
>> slot->userspace_addr, since guest_memfd memslots cannot be updated and
>> can only be deleted.
>> 
>> If userspace re-uses slot->userspace_addr for some other memory address
>> without deleting and re-adding a memslot,
>> 
>> + KVM's access to memory should still be fine, since after the recent
>>   discussion at guest_memfd upstream call, KVM's guest faults will
>>   always go via fd+offset and KVM's access won't be disrupted
>>   there. Whatever checking done at memslot binding time will still be
>>   valid.
> Could the offset of shared memory and offset of private memory be different if
> userspace re-uses slot->userspace_addr without deleting and re-adding a memslot?
>

They could be different, yes. I think what you mean is if userspace does
something like

addr = mmap(guest_memfd);
ioctl(KVM_SET_USER_MEMORY_REGION, addr, guest_memfd);
munmap(addr);
addr = mmap(addr, other_fd);
(with no second call to KVM_SET_USER_MEMORY_REGION)

Without guest_memfd, when munmap() happens, KVM should get a
notification via mmu_notifiers. That will unmap the pages from guest
page tables. At the next fault, host page tables will be consulted to
determine max_mapping_level, and at that time the mapping level would be
the new mapping level in host page tables.

> Then though the two offsets are validated as equal in kvm_gmem_bind(), they may
> differ later on.
>

This is true.

Continuing from above, with guest_memfd, no issues if guest_memfd is
only used for private memory, since shared memory uses the same
mechanism as before guest_memfd.

If guest_memfd is used for both private and shared memory, on unmapping,
KVM will also get notified via mmu_notifiers. On the next fault, the
mapping level is determined as follows (I have a patch coming up that
will illustrate this better)

1. guest_memfd will return 4K since this is a shared folio and shared
   folios are always split to 4K. But suppose in future guest_memfd
   supports shared folios at higher levels, say 1G, we continue...
2. lpage info (not updated since userspace swapped out addr) will say
   map at 1G
3. Since this is a shared fault, we check host page tables, which would
   say 4K since there was a munmap() and mmap().

I think it should still work as expected.

>> + Host's access and other accesses (e.g. instruction emulation, which
>>   uses slot->userspace_addr) to guest memory will be broken, but I think
>>   there's nothing protecting against that. The same breakage would
>>   happen for non-guest_memfd memslot.
> Why is host access broken in non-guest_memfd case?
> The HVA is still a valid one in QEMU's mmap-ed address space.
>

I was thinking that if a guest was executing code and the code gets
swapped out from under its feet by replacing the memory pointed to by
addr, the guest would be broken.

Now that I think about it again, it could be a valid use case. You're
right, thanks for pointing this out!

>> p.s. I will be adding the validation as you suggested [1], though that
>> shouldn't make a difference here, since the above check directly
>> validates against gmem.pgoff.
>> 
>> Regarding 2., checking this checks against gmem.pgoff and should handle
>> that as well.
>> 
>> [1] https://lore.kernel.org/all/aBnMp26iWWhUrsVf@yzhao56-desk.sh.intel.com/
>> 
>> I prefer checking at binding time because it aligns with the ugfn check
>> that is already there, and avoids having to check at every fault.
>> 
>> >> [1] https://github.com/torvalds/linux/blob/b6ea1680d0ac0e45157a819c41b46565f4616186/arch/x86/kvm/x86.c#L12996
>> >> 
>> >> >> >> Adding checks at binding time will allow hugepage-unaligned offsets (to
>> >> >> >> be at parity with non-guest_memfd backing memory) but still fix this
>> >> >> >> issue.
>> >> >> >> 
>> >> >> >> lpage_info will make sure that ranges near the bounds will be
>> >> >> >> fragmented, but the hugepages in the middle will still be mappable as
>> >> >> >> hugepages.
>> >> >> >> 
>> >> >> >> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3706/binding-must-have-same-alignment.svg

