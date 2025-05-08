Return-Path: <kvm+bounces-45897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2309AAFC89
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 16:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F001C3BCC41
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 14:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D0D267B74;
	Thu,  8 May 2025 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J2jKosAs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0821253957
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746713434; cv=none; b=SzZ92lFisFXXySqU73hv7j5+5lqx8rFN4d2Dl1OpXBjsSyB5gGKRWYPdqCPZKR8I3e6vLIIB8pByBTugrj/MmH900PhEck+LJ/0KtfdUcSpd6TKWSFR4NNjgv/fzqehi7RdkVeFMiL//zA8bR9mUAErkAtMnS9dczCRNg09wNlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746713434; c=relaxed/simple;
	bh=zwqe8n1F1m1w1e7lXM4Lu8Y4bcVnFfSGuEScYAE6pe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XxZ0QVJ0GxGwMVKODER/gMrEu8XXzKIXDTfEivKwRNOe18GO94LO1mhILvp09o54Onf0XFIaMcVjTEgdv8LM3yqu39yTMTgJstnXqMcs43lmhd9ZfiibSe4vrAy1oPnJc/wpMivoCufWWuoBdE8riFcJU1wqeXv6/e9GjCScKV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J2jKosAs; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22e1eafa891so188105ad.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 07:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746713432; x=1747318232; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zwqe8n1F1m1w1e7lXM4Lu8Y4bcVnFfSGuEScYAE6pe0=;
        b=J2jKosAsGylhFy1fJa1yfe2WXE/vVJk4glvsm4PA6099MlVSD6TSxj9xtPOp7kf3F4
         z8QjTRFCOlC0OGn09Mwu50kr8xygcS42rsXzNWx69LIOxZx6eAC6D/CRCm9Q33ryv+YG
         RQWAPuJMqv4yUBt+bVKiqdMkY3/UBW4ziMD2GZYf+c4DxnjjxHCP7WmTWNzLuVgPF8u7
         GLoMUgTLI+b2kEDHk0pHDwbUS/jl4Mzz2z1az8GKZQyWaIUjBpF59gYQeVWWWoDFFfBX
         dPkQwXg6W2ahb/85IeUaYPrlPhtE3Q+TgJnANjE3TTUhZfgBeR6UoVW+CANxS9FRtYnW
         2QuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746713432; x=1747318232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zwqe8n1F1m1w1e7lXM4Lu8Y4bcVnFfSGuEScYAE6pe0=;
        b=Ln2Gfip2mLlbHKj1C5S4tT3ZWTKB7qO8zYJ22yjmbsCDflDs4JNGCDfTrd6fgZdiQu
         TQK4GPkdY4QZ5i0Tv9EGNQY0JHQ5+tjzVtMKaWnTWT2i6Go7LpYzbyJs1cFTeopi8sho
         8zaTHnxiGsJbWvrIufeWfJd2/s7QUNKeTDURuPeXG61MKGLRmRwC1FeCrd2in+k9mFs+
         H/iHMUsvyOcCQBrWqhjBZHzig+KL0QhVomcQ+anv0K6A9fflLTaPRenm/q2on7jKx1ne
         1Q66Whz+AL2vkkTa/ZFPfDYxREy5jQshJCv/EbgUCUUc6HFersRCMcVauMnLwFGj7C76
         RA7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHc9dQmGfhoqtw/0BTvHOJb4g0NP5QoTZ8cNQkmU8yosFm0PMQjBOWyN6GW1bSK/aenTg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrKesVHFI04J4G8N8px7ZgN6nzC2zpR/IvciqZ86f1wIcAPK9B
	06iiXlxM+XYD9aKPiCPoPSThrZPWe5wTlrCQOWs8FyCq1XbLII9a6eVaT8GMB1ai7Lx6bbKptne
	QwFRUXTn1GVJ+WmWHMRZi4jwWQc/XAdJC9v7w
X-Gm-Gg: ASbGncsY7/+j2jngeBE9eEtlNHOxhXG7bUjlfPtBn/CUzGDbWNNl9beSqbKB5XCjlug
	zhTzxdrtrvBs/WteHca1a2C32rFTsdN9dlXfCqhuWK2h2/pWXSA8RhDb1jst7a/Ib1Up0WITcVB
	l8G3FitFne1QdhMNbP5P7jv2nXnMqKy4RGn+tUGP239Q7q7Tsrc757zQc=
X-Google-Smtp-Source: AGHT+IEh70aQvHm9Ez/T9w1QV1ErfeXE9sNdnw97zi2XUcYXtZAvT4iDdbVPsSThyuivxkSP48fe/UejuBy8PvCtObs=
X-Received: by 2002:a17:902:da89:b0:22e:570f:e25 with SMTP id
 d9443c01a7336-22fa148efdemr2541355ad.13.1746713431263; Thu, 08 May 2025
 07:10:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030603.329-1-yan.y.zhao@intel.com> <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com> <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com> <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com> <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com> <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
In-Reply-To: <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 8 May 2025 07:10:19 -0700
X-Gm-Features: ATxdqUH_uhJzbyz3ZRGmoCFDO9CDFYwrMETTJ4mFPOzp9Sq23c_bSAtNZ34Y5z8
Message-ID: <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
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

On Wed, May 7, 2025 at 6:32=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Wed, May 07, 2025 at 07:56:08AM -0700, Vishal Annapurve wrote:
> > On Wed, May 7, 2025 at 12:39=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > >
> > > On Tue, May 06, 2025 at 06:18:55AM -0700, Vishal Annapurve wrote:
> > > > On Mon, May 5, 2025 at 11:07=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.=
com> wrote:
> > > > >
> > > > > On Mon, May 05, 2025 at 10:08:24PM -0700, Vishal Annapurve wrote:
> > > > > > On Mon, May 5, 2025 at 5:56=E2=80=AFPM Yan Zhao <yan.y.zhao@int=
el.com> wrote:
> > > > > > >
> > > > > > > Sorry for the late reply, I was on leave last week.
> > > > > > >
> > > > > > > On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wr=
ote:
> > > > > > > > On Mon, Apr 28, 2025 at 5:52=E2=80=AFPM Yan Zhao <yan.y.zha=
o@intel.com> wrote:
> > > > > > > > > So, we plan to remove folio_ref_add()/folio_put_refs() in=
 future, only invoking
> > > > > > > > > folio_ref_add() in the event of a removal failure.
> > > > > > > >
> > > > > > > > In my opinion, the above scheme can be deployed with this s=
eries
> > > > > > > > itself. guest_memfd will not take away memory from TDX VMs =
without an
> > > > > > > I initially intended to add a separate patch at the end of th=
is series to
> > > > > > > implement invoking folio_ref_add() only upon a removal failur=
e. However, I
> > > > > > > decided against it since it's not a must before guest_memfd s=
upports in-place
> > > > > > > conversion.
> > > > > > >
> > > > > > > We can include it in the next version If you think it's bette=
r.
> > > > > >
> > > > > > Ackerley is planning to send out a series for 1G Hugetlb suppor=
t with
> > > > > > guest memfd soon, hopefully this week. Plus I don't see any rea=
son to
> > > > > > hold extra refcounts in TDX stack so it would be good to clean =
up this
> > > > > > logic.
> > > > > >
> > > > > > >
> > > > > > > > invalidation. folio_ref_add() will not work for memory not =
backed by
> > > > > > > > page structs, but that problem can be solved in future poss=
ibly by
> > > > > > > With current TDX code, all memory must be backed by a page st=
ruct.
> > > > > > > Both tdh_mem_page_add() and tdh_mem_page_aug() require a "str=
uct page *" rather
> > > > > > > than a pfn.
> > > > > > >
> > > > > > > > notifying guest_memfd of certain ranges being in use even a=
fter
> > > > > > > > invalidation completes.
> > > > > > > A curious question:
> > > > > > > To support memory not backed by page structs in future, is th=
ere any counterpart
> > > > > > > to the page struct to hold ref count and map count?
> > > > > > >
> > > > > >
> > > > > > I imagine the needed support will match similar semantics as VM=
_PFNMAP
> > > > > > [1] memory. No need to maintain refcounts/map counts for such p=
hysical
> > > > > > memory ranges as all users will be notified when mappings are
> > > > > > changed/removed.
> > > > > So, it's possible to map such memory in both shared and private E=
PT
> > > > > simultaneously?
> > > >
> > > > No, guest_memfd will still ensure that userspace can only fault in
> > > > shared memory regions in order to support CoCo VM usecases.
> > > Before guest_memfd converts a PFN from shared to private, how does it=
 ensure
> > > there are no shared mappings? e.g., in [1], it uses the folio referen=
ce count
> > > to ensure that.
> > >
> > > Or do you believe that by eliminating the struct page, there would be=
 no
> > > GUP, thereby ensuring no shared mappings by requiring all mappers to =
unmap in
> > > response to a guest_memfd invalidation notification?
> >
> > Yes.
> >
> > >
> > > As in Documentation/core-api/pin_user_pages.rst, long-term pinning us=
ers have
> > > no need to register mmu notifier. So why users like VFIO must registe=
r
> > > guest_memfd invalidation notification?
> >
> > VM_PFNMAP'd memory can't be long term pinned, so users of such memory
> > ranges will have to adopt mechanisms to get notified. I think it would
> Hmm, in current VFIO, it does not register any notifier for VM_PFNMAP'd m=
emory.

I don't completely understand how VM_PFNMAP'd memory is used today for
VFIO. Maybe only MMIO regions are backed by pfnmap today and the story
for normal memory backed by pfnmap is yet to materialize.

>
> > be easy to pursue new users of guest_memfd to follow this scheme.
> > Irrespective of whether VM_PFNMAP'd support lands, guest_memfd
> > hugepage support already needs the stance of: "Guest memfd owns all
> > long-term refcounts on private memory" as discussed at LPC [1].
> >
> > [1] https://lpc.events/event/18/contributions/1764/attachments/1409/318=
2/LPC%202024_%201G%20page%20support%20for%20guest_memfd.pdf
> > (slide 12)
> >
> > >
> > > Besides, how would guest_memfd handle potential unmap failures? e.g. =
what
> > > happens to prevent converting a private PFN to shared if there are er=
rors when
> > > TDX unmaps a private PFN or if a device refuses to stop DMAing to a P=
FN.
> >
> > Users will have to signal such failures via the invalidation callback
> > results or other appropriate mechanisms. guest_memfd can relay the
> > failures up the call chain to the userspace.
> AFAIK, operations that perform actual unmapping do not allow failure, e.g=
.
> kvm_mmu_unmap_gfn_range(), iopt_area_unfill_domains(),
> vfio_iommu_unmap_unpin_all(), vfio_iommu_unmap_unpin_reaccount().

Very likely because these operations simply don't fail.

>
> That's why we rely on increasing folio ref count to reflect failure, whic=
h are
> due to unexpected SEAMCALL errors.

TDX stack is adding a scenario where invalidation can fail, a cleaner
solution would be to propagate the result as an invalidation failure.
Another option is to notify guest_memfd out of band to convey the
ranges that failed invalidation.

With in-place conversion supported, even if the refcount is raised for
such pages, they can still get used by the host if the guest_memfd is
unaware that the invalidation failed.

>
> > > Currently, guest_memfd can rely on page ref count to avoid re-assigni=
ng a PFN
> > > that fails to be unmapped.
> > >
> > >
> > > [1] https://lore.kernel.org/all/20250328153133.3504118-5-tabba@google=
.com/
> > >
> > >
> > > > >
> > > > >
> > > > > > Any guest_memfd range updates will result in invalidations/upda=
tes of
> > > > > > userspace, guest, IOMMU or any other page tables referring to
> > > > > > guest_memfd backed pfns. This story will become clearer once th=
e
> > > > > > support for PFN range allocator for backing guest_memfd starts =
getting
> > > > > > discussed.
> > > > > Ok. It is indeed unclear right now to support such kind of memory=
.
> > > > >
> > > > > Up to now, we don't anticipate TDX will allow any mapping of VM_P=
FNMAP memory
> > > > > into private EPT until TDX connect.
> > > >
> > > > There is a plan to use VM_PFNMAP memory for all of guest_memfd
> > > > shared/private ranges orthogonal to TDX connect usecase. With TDX
> > > > connect/Sev TIO, major difference would be that guest_memfd private
> > > > ranges will be mapped into IOMMU page tables.
> > > >
> > > > Irrespective of whether/when VM_PFNMAP memory support lands, there
> > > > have been discussions on not using page structs for private memory
> > > > ranges altogether [1] even with hugetlb allocator, which will simpl=
ify
> > > > seamless merge/split story for private hugepages to support memory
> > > > conversion. So I think the general direction we should head towards=
 is
> > > > not relying on refcounts for guest_memfd private ranges and/or page
> > > > structs altogether.
> > > It's fine to use PFN, but I wonder if there're counterparts of struct=
 page to
> > > keep all necessary info.
> > >
> >
> > Story will become clearer once VM_PFNMAP'd memory support starts
> > getting discussed. In case of guest_memfd, there is flexibility to
> > store metadata for physical ranges within guest_memfd just like
> > shareability tracking.
> Ok.
>
> > >
> > > > I think the series [2] to work better with PFNMAP'd physical memory=
 in
> > > > KVM is in the very right direction of not assuming page struct back=
ed
> > > > memory ranges for guest_memfd as well.
> > > Note: Currently, VM_PFNMAP is usually used together with flag VM_IO. =
in KVM
> > > hva_to_pfn_remapped() only applies to "vma->vm_flags & (VM_IO | VM_PF=
NMAP)".
> > >
> > >
> > > > [1] https://lore.kernel.org/all/CAGtprH8akKUF=3D8+RkX_QMjp35C0bU1zx=
Gi4v1Zm5AWCw=3D8V8AQ@mail.gmail.com/
> > > > [2] https://lore.kernel.org/linux-arm-kernel/20241010182427.1434605=
-1-seanjc@google.com/
> > > >
> > > > > And even in that scenario, the memory is only for private MMIO, s=
o the backend
> > > > > driver is VFIO pci driver rather than guest_memfd.
> > > >
> > > > Not necessary. As I mentioned above guest_memfd ranges will be back=
ed
> > > > by VM_PFNMAP memory.
> > > >
> > > > >
> > > > >
> > > > > > [1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c=
#L6543
> >

