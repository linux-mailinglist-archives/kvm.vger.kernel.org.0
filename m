Return-Path: <kvm+bounces-46069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6364BAB1735
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 16:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0E8D1C438CD
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 14:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82126219302;
	Fri,  9 May 2025 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zhVGrA/I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D8720DD72
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 14:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746800445; cv=none; b=oH1d7Ve7TOE+6w5frD1qrwDUoaTbomDMLPlenTorGKDGVNTv3dEUmC1ZXYnys7FaVeQ+dVDd6rTIbjZPNtM3iKCrJrIGsdkHEJonTBYHJARjkJ7VRWjphIOXp2Pw0LLnPgrybb4cV3p7borD7o2Crr6sW8uaa4U7Z6UNG8TS/Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746800445; c=relaxed/simple;
	bh=eDc7hpV8mFz9ZVKRbb2cWOFUhIvHrxzxI01GBMazwLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bcWmAicsaKYERGPyfeO4lH8Fq3wINL8Ld7idLVbxZdCRyA6QEsE9X/DxbmOTeSeY31ehYsM3E9eC48P+8sUcqDbRbyFJDfuD+3yirxqlrA1dhpdYpuBw7YvrXW3YrF+KxWebom006ytMDx6P9vHmXrlvbFrxFopDh7Uc7PvhQn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zhVGrA/I; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22fa47f295dso149755ad.1
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 07:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746800443; x=1747405243; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moBHzHDyJ+ya/MaaN6Oywnqn4QEL/5Jq1pzflezF+gw=;
        b=zhVGrA/IEtPmKrmlWPhvDMM8FUBG2JLore1sk7WY/6FFaSyIjhMCXpAUr1uNtU4mdT
         nx/i85ABaYDCbX80aCuWHHBeI1cs9CBv9LMKnDs1sdmsR+1/z1dkabILjYhvjjYbctkd
         5I5/YYFjXgMdhlk8WhGQfwEnxsrCem89Pcn6a8g7jzXTCibjp51TfMoKRsx4smMwZVjS
         h50sgMRS6Ebx3uYlpPfWpseXrDErma5yCDHbv29XBQsoEonvMaXVoea4UBa1QzDtFOcN
         m0BPrNMEf3GQEhag98MTYPR2PpabbrQp2+9MfcjBP6BlbcT1SoiVcTf5l80GBMwiKFjY
         ZN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746800443; x=1747405243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=moBHzHDyJ+ya/MaaN6Oywnqn4QEL/5Jq1pzflezF+gw=;
        b=dAJdgYbJBtZPQKFmBvQbNhiV3PZ8dDjqFJ4ZY6fwhwIbzOotIidfFXDmG7wxAlXzvS
         nO7p7BZ9T7hjKCQUvOc7Vw1UkF3szgs1OybDideBuuU4GWL0Fdfl/ReruKjnL5vFW88x
         Eu16uEf7EJ9yYRddKoMd62w00c6Egj6SwX4xB2/OhqxapsV4NvXa8se0ecOfuD0J4zdw
         ichmeHfd8pmNsicqaAmIGRo0Ne04H+wMwALhXXS70QBPUMSz1cN1KS+KGUg/Z/oS/G/+
         RzhpUdRPmp4MmB7DSERBQi1a3dm93YLQ01Qk+wDqy1DMvcAxRDhGid3x4upDvSLg7i/r
         p27Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMVfCQNRBLVb3O+h6P0H2MQVDJWwPQ8XPUOzORRwuiJgieqf199bOluLvqs7KMOf/SipY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL1JJlPn+VtWhfmbMV68UzVRTb1k3mGsMbxqXbSa7bFBIMedRp
	glgjqAtr/d0Vw3cLrukdp2llrA/u8rAoYO7DZJb9y2uO0OkZTtqhUbuauV2lr6Ry/7Lv8mr63c8
	BDnemiSeJINs6YbqorX3HHUXS2rt+Any5v8FZ
X-Gm-Gg: ASbGncuEz0r1IO05m30x/X+cFvws3J1p9R4wlXo5pBuduJYIKtt/Z/NHXLpC6kesKiC
	x27/5si2UVmo53x8b0+4RoFd+CyiRxlfb27kY9Lf2/TxCAWcg0JTenbNbXPTeTM6z+bmFGSk/Xh
	eB8NBalPQm3UIBwcrPaOy5j/IcDfIRx5O81QaQ6/M+4Hri3iYJCWdrKrg++zim8LKFvA==
X-Google-Smtp-Source: AGHT+IGRSEChiQBLtmQX3oCLi80JzANjJTCCCR1ABm66fOsAg41JG6MCKCK1VHfnHqLqXXy8ThrnyKByKMuZOv62JY8=
X-Received: by 2002:a17:903:4403:b0:216:21cb:2e14 with SMTP id
 d9443c01a7336-22fcfa67bbdmr1914215ad.21.1746800442422; Fri, 09 May 2025
 07:20:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com> <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com> <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com> <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com> <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com> <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
In-Reply-To: <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 9 May 2025 07:20:30 -0700
X-Gm-Features: ATxdqUEFpmOgH9gL4BF0ErzQfY3agqA_hxkjzfvkMyRXh9Eg-VzGAj1LA5FoSo0
Message-ID: <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 8:22=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Thu, May 08, 2025 at 07:10:19AM -0700, Vishal Annapurve wrote:
> > On Wed, May 7, 2025 at 6:32=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> =
wrote:
> > >
> > > On Wed, May 07, 2025 at 07:56:08AM -0700, Vishal Annapurve wrote:
> > > > On Wed, May 7, 2025 at 12:39=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.=
com> wrote:
> > > > >
> > > > > On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> > > > > > On Mon, May 5, 2025 at 11:07=E2=80=AFPM Yan Zhao <yan.y.zhao@in=
tel.com> wrote:
> > > > > > >
> > > > > > > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wr=
ote:
> > > > > > > > On Mon, May 5, 2025 at 5:56=E2=80=AFPM Yan Zhao <yan.y.zhao=
@intel.com> wrote:
> > > > > > > > >
> > > > > > > > > Sorry for the late reply, I was on leave last week.
> > > > > > > > >
> > > > > > > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurv=
e wrote:
> > > > > > > > > > On Mon, Apr 28, 2025 at 5:52=E2=80=AFPM Yan Zhao <yan.y=
.zhao@intel.com> wrote:
> > > > > > > > > > > So, we plan to remove folio_ref_add()/folio_put_refs(=
) in future, only invoking
> > > > > > > > > > > folio_ref_add() in the event of a removal failure.
> > > > > > > > > >
> > > > > > > > > > In my opinion, the above scheme can be deployed with th=
is series
> > > > > > > > > > itself. guest_memfd will not take away memory from TDX =
VMs without an
> > > > > > > > > I initially intended to add a separate patch at the end o=
f this series to
> > > > > > > > > implement invoking folio_ref_add() only upon a removal fa=
ilure. However, I
> > > > > > > > > decided against it since it's not a must before guest_mem=
fd supports in-place
> > > > > > > > > conversion.
> > > > > > > > >
> > > > > > > > > We can include it in the next version If you think it's b=
etter.
> > > > > > > >
> > > > > > > > Ackerley is planning to send out a series for 1G Hugetlb su=
pport with
> > > > > > > > guest memfd soon, hopefully this week. Plus I don't see any=
 reason to
> > > > > > > > hold extra refcounts in TDX stack so it would be good to cl=
ean up this
> > > > > > > > logic.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > invalidation. folio_ref_add() will not work for memory =
not backed by
> > > > > > > > > > page structs, but that problem can be solved in future =
possibly by
> > > > > > > > > With current TDX code, all memory must be backed by a pag=
e struct.
> > > > > > > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a =
"struct page *" rather
> > > > > > > > > than a pfn.
> > > > > > > > >
> > > > > > > > > > notifying guest_memfd of certain ranges being in use ev=
en after
> > > > > > > > > > invalidation completes.
> > > > > > > > > A curious question:
> > > > > > > > > To support memory not backed by page structs in future, i=
s there any counterpart
> > > > > > > > > to the page struct to hold ref count and map count?
> > > > > > > > >
> > > > > > > >
> > > > > > > > I imagine the needed support will match similar semantics a=
s VM_PFNMAP
> > > > > > > > [1] memory. No need to maintain refcounts/map counts for su=
ch physical
> > > > > > > > memory ranges as all users will be notified when mappings a=
re
> > > > > > > > changed/removed.
> > > > > > > So, it's possible to map such memory in both shared and priva=
te EPT
> > > > > > > simultaneously?
> > > > > >
> > > > > > No, guest_memfd will still ensure that userspace can only fault=
 in
> > > > > > shared memory regions in order to support CoCo VM usecases.
> > > > > Before guest_memfd converts a PFN from shared to private, how doe=
s it ensure
> > > > > there are no shared mappings? e.g., in [1], it uses the folio ref=
erence count
> > > > > to ensure that.
> > > > >
> > > > > Or do you believe that by eliminating the struct page, there woul=
d be no
> > > > > GUP, thereby ensuring no shared mappings by requiring all mappers=
 to unmap in
> > > > > response to a guest_memfd invalidation notification?
> > > >
> > > > Yes.
> > > >
> > > > >
> > > > > As in Documentation/core-api/pin_user_pages.rst, long-term pinnin=
g users have
> > > > > no need to register mmu notifier. So why users like VFIO must reg=
ister
> > > > > guest_memfd invalidation notification?
> > > >
> > > > VM_PFNMAP'd memory can't be long term pinned, so users of such memo=
ry
> > > > ranges will have to adopt mechanisms to get notified. I think it wo=
uld
> > > Hmm, in current VFIO, it does not register any notifier for VM_PFNMAP=
'd memory.
> >
> > I don't completely understand how VM_PFNMAP'd memory is used today for
> > VFIO. Maybe only MMIO regions are backed by pfnmap today and the story
> > for normal memory backed by pfnmap is yet to materialize.
> VFIO can fault in VM_PFNMAP'd memory which is not from MMIO regions. It w=
orks
> because it knows VM_PFNMAP'd memory are always pinned.
>
> Another example is udmabuf (drivers/dma-buf/udmabuf.c), it mmaps normal f=
olios
> with VM_PFNMAP flag without registering mmu notifier because those folios=
 are
> pinned.
>

I might be wrongly throwing out some terminologies here then.
VM_PFNMAP flag can be set for memory backed by folios/page structs.
udmabuf seems to be working with pinned "folios" in the backend.

The goal is to get to a stage where guest_memfd is backed by pfn
ranges unmanaged by kernel that guest_memfd owns and distributes to
userspace, KVM, IOMMU subject to shareability attributes. if the
shareability changes, the users will get notified and will have to
invalidate their mappings. guest_memfd will allow mmaping such ranges
with VM_PFNMAP flag set by default in the VMAs to indicate the need of
special handling/lack of page structs.

As an intermediate stage, it makes sense to me to just not have
private memory backed by page structs and use a special "filemap" to
map file offsets to these private memory ranges. This step will also
need similar contract with users -
   1) memory is pinned by guest_memfd
   2) users will get invalidation notifiers on shareability changes

I am sure there is a lot of work here and many quirks to be addressed,
let's discuss this more with better context around. A few related RFC
series are planned to be posted in the near future.

> > >
> > > > be easy to pursue new users of guest_memfd to follow this scheme.
> > > > Irrespective of whether VM_PFNMAP'd support lands, guest_memfd
> > > > hugepage support already needs the stance of: "Guest memfd owns all
> > > > long-term refcounts on private memory" as discussed at LPC [1].
> > > >
> > > > [1] https://lpc.events/event/18/contributions/1764/attachments/1409=
/3182/LPC%202024_%201G%20page%20support%20for%20guest_memfd.pdf
> > > > (slide 12)
> > > >
> > > > >
> > > > > Besides, how would guest_memfd handle potential unmap failures? e=
.g. what
> > > > > happens to prevent converting a private PFN to shared if there ar=
e errors when
> > > > > TDX unmaps a private PFN or if a device refuses to stop DMAing to=
 a PFN.
> > > >
> > > > Users will have to signal such failures via the invalidation callba=
ck
> > > > results or other appropriate mechanisms. guest_memfd can relay the
> > > > failures up the call chain to the userspace.
> > > AFAIK, operations that perform actual unmapping do not allow failure,=
 e.g.
> > > kvm_mmu_unmap_gfn_range(), iopt_area_unfill_domains(),
> > > vfio_iommu_unmap_unpin_all(), vfio_iommu_unmap_unpin_reaccount().
> >
> > Very likely because these operations simply don't fail.
>
> I think they are intentionally designed to be no-fail.
>
> e.g. in __iopt_area_unfill_domain(), no-fail is achieved by using a small=
 backup
> buffer allocated on stack in case of kmalloc() failure.
>
>
> > >
> > > That's why we rely on increasing folio ref count to reflect failure, =
which are
> > > due to unexpected SEAMCALL errors.
> >
> > TDX stack is adding a scenario where invalidation can fail, a cleaner
> > solution would be to propagate the result as an invalidation failure.
> Not sure if linux kernel accepts unmap failure.
>
> > Another option is to notify guest_memfd out of band to convey the
> > ranges that failed invalidation.
> Yes, this might be better. Something similar like holding folio ref count=
 to
> let guest_memfd know that a certain PFN cannot be re-assigned.
>
> > With in-place conversion supported, even if the refcount is raised for
> > such pages, they can still get used by the host if the guest_memfd is
> > unaware that the invalidation failed.
> I thought guest_memfd should check if folio ref count is 0 (or a base cou=
nt)
> before conversion, splitting or re-assignment. Otherwise, why do you care=
 if
> TDX holds the ref count? :)
>

Soon to be posted RFC series by Ackerley currently explicitly checks
for safe private page refcounts when folio splitting is needed and not
for every private to shared conversion. A simple solution would be for
guest_memfd to check safe page refcounts for each private to shared
conversion even if split is not required but will need to be reworked
when either of the stages discussed above land where page structs are
not around.

>
> > >
> > > > > Currently, guest_memfd can rely on page ref count to avoid re-ass=
igning a PFN
> > > > > that fails to be unmapped.
> > > > >
> > > > >
> > > > > [1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@go=
ogle.com/
> > > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > > Any guest_memfd range updates will result in invalidations/=
updates of
> > > > > > > > userspace, guest, IOMMU or any other page tables referring =
to
> > > > > > > > guest_memfd backed pfns. This story will become clearer onc=
e the
> > > > > > > > support for PFN range allocator for backing guest_memfd sta=
rts getting
> > > > > > > > discussed.
> > > > > > > Ok. It is indeed unclear right now to support such kind of me=
mory.
> > > > > > >
> > > > > > > Up to now, we don't anticipate TDX will allow any mapping of =
VM_PFNMAP memory
> > > > > > > into private EPT until TDX connect.
> > > > > >
> > > > > > There is a plan to use VM_PFNMAP memory for all of guest_memfd
> > > > > > shared/private ranges orthogonal to TDX connect usecase. With T=
DX
> > > > > > connect/Sev TIO, major difference would be that guest_memfd pri=
vate
> > > > > > ranges will be mapped into IOMMU page tables.
> > > > > >
> > > > > > Irrespective of whether/when VM_PFNMAP memory support lands, th=
ere
> > > > > > have been discussions on not using page structs for private mem=
ory
> > > > > > ranges altogether [1] even with hugetlb allocator, which will s=
implify
> > > > > > seamless merge/split story for private hugepages to support mem=
ory
> > > > > > conversion. So I think the general direction we should head tow=
ards is
> > > > > > not relying on refcounts for guest_memfd private ranges and/or =
page
> > > > > > structs altogether.
> > > > > It's fine to use PFN, but I wonder if there're counterparts of st=
ruct page to
> > > > > keep all necessary info.
> > > > >
> > > >
> > > > Story will become clearer once VM_PFNMAP'd memory support starts
> > > > getting discussed. In case of guest_memfd, there is flexibility to
> > > > store metadata for physical ranges within guest_memfd just like
> > > > shareability tracking.
> > > Ok.
> > >
> > > > >
> > > > > > I think the series [2] to work better with PFNMAP'd physical me=
mory in
> > > > > > KVM is in the very right direction of not assuming page struct =
backed
> > > > > > memory ranges for guest_memfd as well.
> > > > > Note: Currently, VM_PFNMAP is usually used together with flag VM_=
IO. in KVM
> > > > > hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | V=
M_PFNMAP)".
> > > > >
> > > > >
> > > > > > [1] https://lore.kernel.org/all/CAGtprH8akKUF=3D8+RkX_QMjp35C0b=
U1zxGi4v1Zm5AWCw=3D8V8AQ@mail.gmail.com/
> > > > > > [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.143=
4605-1-seanjc@google.com/
> > > > > >
> > > > > > > And even in that scenario, the memory is only for private MMI=
O, so the backend
> > > > > > > driver is VFIO pci driver rather than guest_memfd.
> > > > > >
> > > > > > Not necessary. As I mentioned above guest_memfd ranges will be =
backed
> > > > > > by VM_PFNMAP memory.
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memo=
ry.c#L6543
> > > >

