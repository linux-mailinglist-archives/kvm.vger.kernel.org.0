Return-Path: <kvm+bounces-48609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B287DACF927
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 23:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD91E189D227
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF1127EC80;
	Thu,  5 Jun 2025 21:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DrK08CQO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D843F20330
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 21:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749157983; cv=none; b=VV09FhfGOCJzGQui+tk+LBbYla79EfNmzOMu2lpaUAARQbcJerHhOU5Laa9LbRHp7wdxNxJnUYUc5vxrgfpbb8VQkSp66TlI+WligzZHFOSnqc4OkKIc/CxXGPStpCLq+KR8JqILUBg7Agoa+B7CK98L1vs7TOFk98thVY2m9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749157983; c=relaxed/simple;
	bh=tFDePnJjAJFc1+SWn+DrxUx7b6BBTnnbLN1XOS+DgBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NcHx6RFGxqjydAPznzW6dDZ6rGq+3eque8cjxvIS6Kyp2po8fdi5T/fYE/clrxoQciuo/8nr8OD+oiSV4Lj0JhT5QA93lB6gIBtNlpxvZOMaEnkTozmgVghYnDqtU/5CBTc02GQb/iL/RoheOWQDT0Sge7SCIYpbuq/6C3MlFA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DrK08CQO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748269c6516so345579b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 14:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749157980; x=1749762780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nV/EksNhnvwxUc+6HNl4qI0B45dI75nVSAURiB2WujU=;
        b=DrK08CQOQng8lLhooDvx3JiHDWvJAhCtk78bLMa+AYyD2OfLYTVJilnMSwgYzp3pal
         GK8tRnBu2j7TqH8Nc4zcdmSVaCnhu9sZWm3wdkml8ONLft+NDTMze6HlbfFalImG0FeI
         KPm8y/lvaKFJTNCU0Oy2iXxb+8uwbHC3PoF4jf8pmnOmNWth0F6uSjO9sQNykIDnGiQO
         CpOP2lrj5s1c7M0eUVdVB5MsnIB0ZWQqVcHfSBYRpG5Ceit6WSzTu3X555PHd69ndHqp
         RFMGVvf2p1YeWdApDfj6AAKYg1ww1L2UYQSYrJUS2lP0WQoJcSNbANbXnD8RzHUsa04S
         Ginw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749157980; x=1749762780;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nV/EksNhnvwxUc+6HNl4qI0B45dI75nVSAURiB2WujU=;
        b=CqUKL80Sagf6IZNtr0nakpd+9Hk/rHHpi2k8gr15mjIFzAkm99EZTZlmw1EgxixBvG
         PaqAzmL5zvgNmRdlbgcYOwX8k06DXJ3Tjh8mqMAQPEA5HjEXQe0pVnV8VaLOUu3zkNyN
         rhcFSK3ec8BRzwriel6lTxIfHdblRDZskBUblBQpFv26Y+q/jckxti7eQ/UfV89k6kJY
         Fy041SAS71jy2eI5j3AVKJI3tkYE6mJRkThUtkMmnigx4nFUrC1Pv0bfqrpqpFj/eq9F
         rg4GSOg3WvFy6KbdznOfxLw36Oow4rQCd4OJN45OdPclYvQd9g3R3Ten2akCbvDuov+t
         P81g==
X-Forwarded-Encrypted: i=1; AJvYcCXheYDOHseRQ5ysqjKzVeobBDgMIEWubiQuIvI56LcJTAmWWT5r0qtI73vWZZBubj0dNCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywojwjogs28AF9kZjid9J+H9mrJUBY0d1biEp71PQu+5YNkYRRP
	dVAZaKF7SCnHZnASPf4Xc+gw4q4xiAHhfCc6M/2FFuDzUhahrOQvxjRo2F2xq9wl0eaWHcDm51T
	zBpmVANsBOX7eJT5A7LbfY0wEnA==
X-Google-Smtp-Source: AGHT+IElxGRsdyFsm6NZYzCEr3x3yVLk5tEWK+wQtGSqbNW4QHU/jkC0JW589WIZj9j5Ykby706Ic2ekK+n0kAkgEA==
X-Received: from pfiu22.prod.google.com ([2002:a05:6a00:1256:b0:747:b608:3d8e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4b51:b0:740:41e4:e761 with SMTP id d2e1a72fcca58-74827f3ba85mr1481404b3a.22.1749157980073;
 Thu, 05 Jun 2025 14:13:00 -0700 (PDT)
Date: Thu, 05 Jun 2025 14:12:58 -0700
In-Reply-To: <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com> <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
Message-ID: <diqzldq5j3j9.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: vannapurve@google.com, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kirill.shutemov@intel.com, 
	tabba@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
>> Yan Zhao <yan.y.zhao@intel.com> writes:
>>=20
>> > On Mon, May 12, 2025 at 09:53:43AM -0700, Vishal Annapurve wrote:
>> >> On Sun, May 11, 2025 at 7:18=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.co=
m> wrote:
>> >> > ...
>> >> > >
>> >> > > I might be wrongly throwing out some terminologies here then.
>> >> > > VM_PFNMAP flag can be set for memory backed by folios/page struct=
s.
>> >> > > udmabuf seems to be working with pinned "folios" in the backend.
>> >> > >
>> >> > > The goal is to get to a stage where guest_memfd is backed by pfn
>> >> > > ranges unmanaged by kernel that guest_memfd owns and distributes =
to
>> >> > > userspace, KVM, IOMMU subject to shareability attributes. if the
>> >> > OK. So from point of the reset part of kernel, those pfns are not r=
egarded as
>> >> > memory.
>> >> >
>> >> > > shareability changes, the users will get notified and will have t=
o
>> >> > > invalidate their mappings. guest_memfd will allow mmaping such ra=
nges
>> >> > > with VM_PFNMAP flag set by default in the VMAs to indicate the ne=
ed of
>> >> > > special handling/lack of page structs.
>> >> > My concern is a failable invalidation notifer may not be ideal.
>> >> > Instead of relying on ref counts (or other mechanisms) to determine=
 whether to
>> >> > start shareabilitiy changes, with a failable invalidation notifier,=
 some users
>> >> > may fail the invalidation and the shareability change, even after o=
ther users
>> >> > have successfully unmapped a range.
>> >>
>> >> Even if one user fails to invalidate its mappings, I don't see a
>> >> reason to go ahead with shareability change. Shareability should not
>> >> change unless all existing users let go of their soon-to-be-invalid
>> >> view of memory.
>>=20
>> Hi Yan,
>>=20
>> While working on the 1G (aka HugeTLB) page support for guest_memfd
>> series [1], we took into account conversion failures too. The steps are
>> in kvm_gmem_convert_range(). (It might be easier to pull the entire
>> series from GitHub [2] because the steps for conversion changed in two
>> separate patches.)
>>=20
>> We do need to handle errors across ranges to be converted, possibly from
>> different memslots. The goal is to either have the entire conversion
>> happen (including page split/merge) or nothing at all when the ioctl
>> returns.
>>=20
>> We try to undo the restructuring (whether split or merge) and undo any
>> shareability changes on error (barring ENOMEM, in which case we leave a
>> WARNing).
> As the undo can fail (as the case you leave a WARNing, in patch 38 in [1]=
), it
> can lead to WARNings in kernel with folios not being properly added to th=
e
> filemap.
>

I'm not sure how else to handle errors on rollback path. I've hopefully
addressed this on the other thread at [1].

>> The part we don't restore is the presence of the pages in the host or
>> guest page tables. For that, our idea is that if unmapped, the next
>> access will just map it in, so there's no issue there.
>
> I don't think so.
>
> As in patch 38 in [1], on failure, it may fail to
> - restore the shareability
> - restore the folio's filemap status
> - restore the folio's hugetlb stash metadata
> - restore the folio's merged/split status
>

The plan is that we try our best to restore shareability, filemap,
restructuring (aka split/merge, including stash metadata) other than
failures on rollback.

> Also, the host page table is not restored.
>
>

This is by design, the host page tables can be re-populated on the next
fault. I've hopefully addressed this on the other thread at [1].

>> > My thinking is that:
>> >
>> > 1. guest_memfd starts shared-to-private conversion
>> > 2. guest_memfd sends invalidation notifications
>> >    2.1 invalidate notification --> A --> Unmap and return success
>> >    2.2 invalidate notification --> B --> Unmap and return success
>> >    2.3 invalidate notification --> C --> return failure
>> > 3. guest_memfd finds 2.3 fails, fails shared-to-private conversion and=
 keeps
>> >    shareability as shared
>> >
>> > Though the GFN remains shared after 3, it's unmapped in user A and B i=
n 2.1 and
>> > 2.2. Even if additional notifications could be sent to A and B to ask =
for
>> > mapping the GFN back, the map operation might fail. Consequently, A an=
d B might
>> > not be able to restore the mapped status of the GFN.
>>=20
>> For conversion we don't attempt to restore mappings anywhere (whether in
>> guest or host page tables). What do you think of not restoring the
>> mappings?
> It could cause problem if the mappings in S-EPT can't be restored.
>
> For TDX private-to-shared conversion, if kvm_gmem_convert_should_proceed(=
) -->
> kvm_gmem_unmap_private() --> kvm_mmu_unmap_gfn_range() fails in the end, =
then
> the GFN shareability is restored to private. The next guest access to
> the partially unmapped private memory can meet a fatal error: "access bef=
ore
> acceptance".
>
> It could occur in such a scenario:
> 1. TD issues a TDVMCALL_MAP_GPA to convert a private GFN to shared
> 2. Conversion fails in KVM.
> 3. set_memory_decrypted() fails in TD.
> 4. TD thinks the GFN is still accepted as private and accesses it.
>
>

This is true, I was thinking that this isn't handled solely in
conversion but by being part of the contract between userspace VMM and
the guest, that guest must handle conversion failures. I've hopefully
addressed this on the other thread at [1].

>> > For IOMMU mappings, this
>> > could result in DMAR failure following a failed attempt to do shared-t=
o-private
>> > conversion.
>>=20
>> I believe the current conversion setup guards against this because after
>> unmapping from the host, we check for any unexpected refcounts.
> Right, it's fine if we check for any unexpected refcounts.
>
>
>> (This unmapping is not the unmapping we're concerned about, since this i=
s
>> shared memory, and unmapping doesn't go through TDX.)
>>=20
>> Coming back to the refcounts, if the IOMMU had mappings, these refcounts
>> are "unexpected". The conversion ioctl will return to userspace with an
>> error.
>>=20
>> IO can continue to happen, since the memory is still mapped in the
>> IOMMU. The memory state is still shared. No issue there.
>>=20
>> In RFCv2 [1], we expect userspace to see the error, then try and remove
>> the memory from the IOMMU, and then try conversion again.
> I don't think it's right to depend on that userspace could always perform=
 in=20
> kernel's expected way, i.e. trying conversion until it succeeds.
>

Let me think more deeply about this. Please let me know if there's
anything I missed.

It is true that a buggy or malicious userspace VMM can ignore conversion
failures and report success to the guest, but if both the userspace VMM
and guest are malicious, it's quite hard for the kernel to defend
against that.

I think as long as there's no point where the guest can crash the host
in a fixed way, I think it is okay to rely on a userspace VMM and guest
protocol.

IIUC the guest can crash the host (original point of having guest_memfd)
if the guest can convince the host to write to private memory. For that
to happen, the memory must be faulted into the Secure EPTs, and the
shareability state must be ALL for the host to fault it in.

So to have this issue, the conversion failure must be such that the
memory remains faulted into the Secure EPTs while shareability is
shared. Since unmapping from secure EPTs happens pretty early before any
shareability is changed or any rollback (and rollback failures) can
happen, I think we should be quite safe?

If unmapping of private memory fails, this is where I think guest_memfd
should get an error from the unmap and it should not proceed to change
shareability.


> We need to restore to the previous status (which includes the host page t=
able)
> if conversion can't be done.

Most of the previous status (shareability, filemap,
restructuring (aka split/merge, including stash metadata)) are restored
other than during rollback failures.

As for presence in host page tables, is it okay to defer that till the
next fault, and if not okay, why not?

For presence in guest page tables, is it okay to fall back on the
protocol where the guest must handle conversion failures, and if not
okay, why not?

> That said, in my view, a better flow would be:
>
> 1. guest_memfd sends a pre-invalidation request to users (users here mean=
s the
>    consumers in kernel of memory allocated from guest_memfd).
>
> 2. Users (A, B, ..., X) perform pre-checks to determine if invalidation c=
an
>    proceed. For example, in the case of TDX, this might involve memory
>    allocation and page splitting.
>
> 3. Based on the pre-check results, guest_memfd either aborts the invalida=
tion or
>    proceeds by sending the actual invalidation request.
>
> 4. Users (A-X) perform the actual unmap operation, ensuring it cannot fai=
l. For
>    TDX, the unmap must succeed unless there are bugs in the KVM or TDX mo=
dule.
>    In such cases, TDX can callback guest_memfd to inform the poison-statu=
s of
>    the page or elevate the page reference count.
>
> 5. guest_memfd completes the invalidation process. If the memory is marke=
d as
>    "poison," guest_memfd can handle it accordingly. If the page has an el=
evated
>    reference count, guest_memfd may not need to take special action, as t=
he
>    elevated count prevents the OS from reallocating the page.
>    (but from your reply below, seems a callback to guest_memfd is a bette=
r
>    approach).
>
>

Thanks for this, I've tried to combine this into my response at
[1]. I think this works, but it's hard because

a. Pre-checks are hard to check (explained at [1])
b. Even after all the checks, unmapping can still fail, and those still
   have to be handled, and to handle those, we have to buy into the
   userspace VMM/guest protocol, so why not just buy into the protocol
   to start with?

[1] https://lore.kernel.org/all/diqztt4uhunj.fsf@ackerleytng-ctop.c.googler=
s.com/

>> The part in concern here is unmapping failures of private pages, for
>> private-to-shared conversions, since that part goes through TDX and
>> might fail.
> IMO, even for TDX, the real unmap must not fail unless there are bugs in =
the KVM
> or TDX module.
> So, for page splitting in S-EPT, I prefer to try splitting in the
> pre-invalidation phase before conducting any real unmap.
>
>

Thanks for your detailed suggestion.

>> One other thing about taking refcounts is that in RFCv2,
>> private-to-shared conversions assume that there are no refcounts on the
>> private pages at all. (See filemap_remove_folio_for_restructuring() in
>> [3])
>>
>> Haven't had a chance to think about all the edge cases, but for now I
>> think on unmapping failure, in addition to taking a refcount, we should
>> return an error at least up to guest_memfd, so that guest_memfd could
>> perhaps keep the refcount on that page, but drop the page from the
>> filemap. Another option could be to track messed up addresses and always
>> check that on conversion or something - not sure yet.
>
> It looks good to me. See the bullet 4 in my proposed flow above.
>

Thanks again for your detailed suggestion.

>> Either way, guest_memfd must know. If guest_memfd is not informed, on a
>> next conversion request, the conversion will just spin in
>> filemap_remove_folio_for_restructuring().
> It makes sense.
>
>
>> What do you think of this part about informing guest_memfd of the
>> failure to unmap?
> So, do you want to add a guest_memfd callback to achieve this purpose?
>

I will need to think the entire thing through, but I meant informing as
in returning an error to guest_memfd so that guest_memfd knows. I think
returning an error should be the first cause of action.

As for whether guest_memfd should know how to handle the error or
whether the userspace VMM should participate in deciding what to do with
the error, I'm not sure. If you have suggestions on this, I hope we can
combine the suggestions about the conversion protocol on the other thread.

Regarding a callback, are you thinking something like not having the
unmap return an error, but instead TDX will call a function like
kvm_gmem_error_at_offset(loff_t offset), and guest_memfd will then
record that somewhere, and then immediately after calling unmap
guest_memfd will check kvm_gmem_was_there_an_error_in_range() and then
determining whether there's an error? Something like that?

I guess it could work but feels a little odd.

>
> BTW, here's an analysis of why we can't let kvm_mmu_unmap_gfn_range()
> and mmu_notifier_invalidate_range_start() fail, based on the repo
> https://github.com/torvalds/linux.git, commit cd2e103d57e5 ("Merge tag
> 'hardening-v6.16-rc1-fix1-take2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux")

Thank you, I appreciate the effort you took to enumerate these. The
following suggestions are based on my current understanding. I don't
have time in the near future to do the plumbing to test out the
suggestion, but for now I want to see if this suggestion makes sense,
maybe you can correct any misunderstandings first.=20

>
> 1. Status of mmu notifier
> -------------------------------
> (1) There're 34 direct callers of mmu_notifier_invalidate_range_start().
>     1. clear_refs_write
>     2. do_pagemap_scan
>     3. uprobe_write_opcode
>     4. do_huge_zero_wp_pmd
>     5. __split_huge_pmd (N)
>     6. __split_huge_pud (N)
>     7. move_pages_huge_pmd
>     8. copy_hugetlb_page_range
>     9. hugetlb_unshare_pmds  (N)
>     10. hugetlb_change_protection
>     11. hugetlb_wp
>     12. unmap_hugepage_range (N)
>     13. move_hugetlb_page_tables
>     14. collapse_huge_page
>     15. retract_page_tables
>     16. collapse_pte_mapped_thp
>     17. write_protect_page
>     18. replace_page
>     19. madvise_free_single_vma
>     20. wp_clean_pre_vma
>     21. wp_page_copy=20
>     22. zap_page_range_single_batched (N)
>     23. unmap_vmas (N)
>     24. copy_page_range=20
>     25. remove_device_exclusive_entry
>     26. migrate_vma_collect
>     27. __migrate_device_pages
>     28. change_pud_range=20
>     29. move_page_tables
>     30. page_vma_mkclean_one
>     31. try_to_unmap_one
>     32. try_to_migrate_one
>     33. make_device_exclusive
>     34. move_pages_pte
>
> Of these 34 direct callers, those marked with (N) cannot tolerate
> mmu_notifier_invalidate_range_start() failing. I have not yet investigate=
d all
> 34 direct callers one by one, so the list of (N) is incomplete.
>
> For 5. __split_huge_pmd(), Documentation/mm/transhuge.rst says:
> "Note that split_huge_pmd() doesn't have any limitations on refcounting:
> pmd can be split at any point and never fails." This is because split_hug=
e_pmd()
> serves as a graceful fallback design for code walking pagetables but unaw=
are
> about huge pmds.
>
>

Do these callers, especially those with (N), ever try to unmap any TDX
private pages? guest_memfd only gives shared pages to core-mm, so for
shared pages, there will continue to be no chance of errors.

If we change mmu_notifier_invalidate_range_start() to return an int, all
of the callers that never invalidate shared pages can continue to safely
rely on the fact that mmu_notifier_invalidate_range_start() will return
0.

For the callers of mmu_notifier_invalidate_range_start() that may touch
private pages, I believe that's only guest_memfd and KVM. That's where
we want the error, and will handle the error.

Another point here is that I was thinking to put EPT splitting together
with actual unmapping instead of with invalidation because we will
probably invalidate more than we unmap (see explanation at [1] about the
race). Maybe moving EPT splitting to unmap could help?

> (2) There's 1 direct caller of mmu_notifier_invalidate_range_start_nonblo=
ck(),
> __oom_reap_task_mm(), which only expects the error -EAGAIN.
>
> In mn_hlist_invalidate_range_start():
> "WARN_ON(mmu_notifier_range_blockable(range) || _ret !=3D -EAGAIN);"
>
>
> (3) For DMAs, drivers need to invoke pin_user_pages() to pin memory. In t=
hat
> case, they don't need to register mmu notifier.
>
> Or, device drivers can pin pages via get_user_pages*(), and register for =
mmu        =20
> notifier callbacks for the memory range. Then, upon receiving a notifier =
       =20
> "invalidate range" callback , stop the device from using the range, and u=
npin   =20
> the pages.
>
> See Documentation/core-api/pin_user_pages.rst.
>
>

Do you mean that we should teach device drivers to get callbacks for
private pages? Are you looking ahead to handle TDX IO on private pages?
So far we haven't handled that yet.

> 2. Cases that cannot tolerate failure of mmu_notifier_invalidate_range_st=
art()
> -------------------------------
> (1) Error fallback cases.
>
>     1. split_huge_pmd() as mentioned in Documentation/mm/transhuge.rst.
>        split_huge_pmd() is designed as a graceful fallback without failur=
e.
>
>        split_huge_pmd
>         |->__split_huge_pmd
>            |->mmu_notifier_range_init
>            |  mmu_notifier_invalidate_range_start
>            |  split_huge_pmd_locked
>            |  mmu_notifier_invalidate_range_end
>
>
>     2. in fs/iomap/buffered-io.c, iomap_write_failed() itself is error ha=
ndling.
>        iomap_write_failed
>          |->truncate_pagecache_range
>             |->unmap_mapping_range
>             |  |->unmap_mapping_pages
>             |     |->unmap_mapping_range_tree
>             |        |->unmap_mapping_range_vma
>             |           |->zap_page_range_single
>             |              |->zap_page_range_single_batched
>             |                       |->mmu_notifier_range_init
>             |                       |  mmu_notifier_invalidate_range_star=
t
>             |                       |  unmap_single_vma
>             |                       |  mmu_notifier_invalidate_range_end
>             |->truncate_inode_pages_range
>                |->truncate_cleanup_folio
>                   |->if (folio_mapped(folio))
>                   |     unmap_mapping_folio(folio);
>                          |->unmap_mapping_range_tree
>                             |->unmap_mapping_range_vma
>                                |->zap_page_range_single
>                                   |->zap_page_range_single_batched
>                                      |->mmu_notifier_range_init
>                                      |  mmu_notifier_invalidate_range_sta=
rt
>                                      |  unmap_single_vma
>                                      |  mmu_notifier_invalidate_range_end
>
>    3. in mm/memory.c, zap_page_range_single() is invoked to handle error.
>       remap_pfn_range_notrack
>         |->int error =3D remap_pfn_range_internal(vma, addr, pfn, size, p=
rot);
>         |  if (!error)
>         |      return 0;
> 	|  zap_page_range_single
>            |->zap_page_range_single_batched
>               |->mmu_notifier_range_init
>               |  mmu_notifier_invalidate_range_start
>               |  unmap_single_vma
>               |  mmu_notifier_invalidate_range_end
>
>    4. in kernel/events/core.c, zap_page_range_single() is invoked to clea=
r any
>       partial mappings on error.
>
>       perf_mmap
>         |->ret =3D map_range(rb, vma);
>                  |  err =3D remap_pfn_range
>                  |->if (err)=20
>                  |     zap_page_range_single
>                         |->zap_page_range_single_batched
>                            |->mmu_notifier_range_init
>                            |  mmu_notifier_invalidate_range_start
>                            |  unmap_single_vma
>                            |  mmu_notifier_invalidate_range_end
>
>
>    5. in mm/memory.c, unmap_mapping_folio() is invoked to unmap posion pa=
ge.
>
>       __do_fault
> 	|->if (unlikely(PageHWPoison(vmf->page))) {=20
> 	|	vm_fault_t poisonret =3D VM_FAULT_HWPOISON;
> 	|	if (ret & VM_FAULT_LOCKED) {
> 	|		if (page_mapped(vmf->page))
> 	|			unmap_mapping_folio(folio);
>         |                       |->unmap_mapping_range_tree
>         |                          |->unmap_mapping_range_vma
>         |                             |->zap_page_range_single
>         |                                |->zap_page_range_single_batched
>         |                                   |->mmu_notifier_range_init
>         |                                   |  mmu_notifier_invalidate_ra=
nge_start
>         |                                   |  unmap_single_vma
>         |                                   |  mmu_notifier_invalidate_ra=
nge_end
> 	|		if (mapping_evict_folio(folio->mapping, folio))
> 	|			poisonret =3D VM_FAULT_NOPAGE;=20
> 	|		folio_unlock(folio);
> 	|	}
> 	|	folio_put(folio);
> 	|	vmf->page =3D NULL;
> 	|	return poisonret;
> 	|  }
>
>
>   6. in mm/vma.c, in __mmap_region(), unmap_region() is invoked to undo a=
ny
>      partial mapping done by a device driver.
>
>      __mmap_new_vma
>        |->__mmap_new_file_vma(map, vma);
>           |->error =3D mmap_file(vma->vm_file, vma);
>           |  if (error)
>           |     unmap_region
>                  |->unmap_vmas
>                     |->mmu_notifier_range_init
>                     |  mmu_notifier_invalidate_range_start
>                     |  unmap_single_vma
>                     |  mmu_notifier_invalidate_range_end
>
>

These should probably not ever be invalidating or unmapping private pages.

> (2) No-fail cases
> -------------------------------
> 1. iput() cannot fail.=20
>
> iput
>  |->iput_final
>     |->WRITE_ONCE(inode->i_state, state | I_FREEING);
>     |  inode_lru_list_del(inode);
>     |  evict(inode);
>        |->op->evict_inode(inode);
>           |->shmem_evict_inode
>              |->shmem_truncate_range
>                 |->truncate_inode_pages_range
>                    |->truncate_cleanup_folio
>                       |->if (folio_mapped(folio))
>                       |     unmap_mapping_folio(folio);
>                             |->unmap_mapping_range_tree
>                                |->unmap_mapping_range_vma
>                                   |->zap_page_range_single
>                                      |->zap_page_range_single_batched
>                                         |->mmu_notifier_range_init
>                                         |  mmu_notifier_invalidate_range_=
start
>                                         |  unmap_single_vma
>                                         |  mmu_notifier_invalidate_range_=
end
>
>
> 2. exit_mmap() cannot fail
>
> exit_mmap
>   |->mmu_notifier_release(mm);
>      |->unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX, false);
>         |->mmu_notifier_range_init
>         |  mmu_notifier_invalidate_range_start
>         |  unmap_single_vma
>         |  mmu_notifier_invalidate_range_end
>
>

These should probably not ever be invalidating or unmapping private pages.

> 3. KVM Cases That Cannot Tolerate Unmap Failure
> -------------------------------
> Allowing unmap operations to fail in the following scenarios would make i=
t very
> difficult or even impossible to handle the failure:
>
> (1) __kvm_mmu_get_shadow_page() is designed to reliably obtain a shadow p=
age
> without expecting any failure.
>
> mmu_alloc_direct_roots
>   |->mmu_alloc_root
>      |->kvm_mmu_get_shadow_page
>         |->__kvm_mmu_get_shadow_page
>            |->kvm_mmu_alloc_shadow_page
>               |->account_shadowed
>                  |->kvm_mmu_slot_gfn_write_protect
>                     |->kvm_tdp_mmu_write_protect_gfn
>                        |->write_protect_gfn
>                           |->tdp_mmu_iter_set_spte
>
>

I need to learn more about shadow pages but IIUC TDX doesn't use shadow
pages so this path won't interact with unmapping private pages.

> (2) kvm_vfio_release() and kvm_vfio_file_del() cannot fail
>
> kvm_vfio_release/kvm_vfio_file_del
>  |->kvm_vfio_update_coherency
>     |->kvm_arch_unregister_noncoherent_dma
>        |->kvm_noncoherent_dma_assignment_start_or_stop
>           |->kvm_zap_gfn_range
>              |->kvm_tdp_mmu_zap_leafs
>                 |->tdp_mmu_zap_leafs
>                    |->tdp_mmu_iter_set_spte
>
>

I need to learn more about VFIO but for now IIUC IO uses shared pages,
so this path won't interact with unmapping private pages.

> (3) There're lots of callers of __kvm_set_or_clear_apicv_inhibit() curren=
tly
> never expect failure of unmap.
>
> __kvm_set_or_clear_apicv_inhibit
>   |->kvm_zap_gfn_range
>      |->kvm_tdp_mmu_zap_leafs
>         |->tdp_mmu_zap_leafs
>            |->tdp_mmu_iter_set_spte
>
>
>

There could be some TDX specific things such that TDX doesn't use this
path.

> 4. Cases in KVM where it's hard to make tdp_mmu_set_spte() (update SPTE w=
ith
> write mmu_lock) failable.
>
> (1) kvm_vcpu_flush_tlb_guest()
>
> kvm_vcpu_flush_tlb_guest
>   |->kvm_mmu_sync_roots
>      |->mmu_sync_children
>         |->kvm_vcpu_write_protect_gfn
>            |->kvm_mmu_slot_gfn_write_protect
>               |->kvm_tdp_mmu_write_protect_gfn
>                  |->write_protect_gfn
>                     |->tdp_mmu_iter_set_spte
>                        |->tdp_mmu_set_spte
>
>
> (2) handle_removed_pt() and handle_changed_spte().
>

Thank you so much for looking into these, I'm hoping that the number of
cases where TDX and private pages are unmapped are really limited to a
few paths that we have to rework.

If we agree that the error has to be handled, then regardless of how we
let the caller know that an error happened, all paths touching TDX
private pages have to be reworked.

Between (1) returning an error vs (2) marking error and having the
caller check for errors, then it's probably better to use the standard
approach of returning an error since it is better understood, and
there's no need to have extra data structures?

>
> Thanks
> Yan

