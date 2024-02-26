Return-Path: <kvm+bounces-9776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A94C3866EE4
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 343681F26CC2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC66F7A723;
	Mon, 26 Feb 2024 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r0+0nnWa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DB21CA9F
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938354; cv=none; b=Byat+a6HfTW/FUFX4yH4m7chq9/7X143v+E5zaA0qJ2t0YTwot7e6MIJqnj84RyYWHXeUo0I0E+mKbyesloBjuxQ6cpUT9W/s9XI2SWE+RJD1bou5E/rIop9CEp0DKXmOo2j+P0L07b5u973hUGJo1n1zAtMRGLDCt7sDlDhtDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938354; c=relaxed/simple;
	bh=DGDOY12oobXLPZUazkiYwX7hvCEsA/b9upyEJcRN6S0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mo7AGPDIxwysQa+cZ7YOPBVcrc3oYBkWHrN30kEsLKpN1PKFPwHHOEkhQ8JXDa6RPm0AF4W+s5wEDK+GGvBvx5/9ctJvHoAmjOM6+xNB4hGrax5J/ZoNYSzk5o8SiQeAYd2RMJAQWtLCgFNda0TQaON9exPRWwPmv2GhISVFmNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r0+0nnWa; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7d643a40a91so1686821241.0
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 01:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708938351; x=1709543151; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=29ukxl3SZDNqQP6DfxAR7ZWQCxlzQHsam7YuMTpfEGw=;
        b=r0+0nnWarLwsTBGYJ4SzFon3dlOhixTmY41BBVHoiV0fM+PNeDC8oWXiMv2OjWmy9l
         6KXvW5MRWJZgBOIlC3WfmW9WLyYvgSCtDvRJfFnvlMBBkc8BFbHkEDCAnlVB/3Ai4/Yv
         m1NdJ5pnsGtKgBSxjDqBPg3Xd2fwv9/cDXkuI2cuO3iRWP7+niq0QOgkxS2nz9z9p8Pf
         zEfEt3nGtMjIN7y5iX7QHD8Sravf2/SSl78XxLqLj8qq3YxWcdB/2aLQPUa22SBjOpWf
         CPsGPm56E9Yky1ok09a4fKYZK6uF/9cfgtW0eM0rEcHO6pfY1WuZUV9BWu9L8e2WGHsg
         Holg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938351; x=1709543151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29ukxl3SZDNqQP6DfxAR7ZWQCxlzQHsam7YuMTpfEGw=;
        b=bMby6EBlY4XyjmCEBw2T4Jd08JCydQHxe5lE1jUqfJkUz1crIpEbUmVmP9QsbC6sum
         UMIsxYbgZR31Sk3vhFl31LnboPLMFkAyN8FX9VzBqRPMQc9tObDX7JMVbTRy0duTqrhX
         R9y21+Mh/8L3I6tgf1M5vJtum6yVs9dhH6OGp151dc3IvVJviBtaPZfGiGmIK02nzIwK
         t8Ed1rsE7hFYMmlTf2DA0L+qO0yxC2F338GowjUaz3gWFkuuljrrSvCI0o0806D+Oczc
         JfwrlN7hWYi9rr44LGZs1iPYF5DGFeQu0iPcumtAoWnB3UyssfsIO6d2ljhc0jRXMSpO
         nXzg==
X-Gm-Message-State: AOJu0YzbpIiDbNh8Kgsh1c9QAzqTL6Ep2+MLSQ8QwgVN6mjwiVuNTRLv
	kdGJ/u4FsPcLIqrkX/uDElvAL4NifwN1u7f8wKZ6Phv5NgH/+bIVrJ7XoHm40imnjmCkeYQAowp
	/ezNk6LCQGaE4eO+EDbldHYIODD27u32xwLBL
X-Google-Smtp-Source: AGHT+IFvKMvzj0x6NIYigHYi4Yda/z6JzMdz/VTHwIGPN9mQqjsPc/fpWPOdOkXwIljDLg4VV/RAi9mEKTLQLDnPXOk=
X-Received: by 2002:a05:6102:54a5:b0:470:38fd:272e with SMTP id
 bk37-20020a05610254a500b0047038fd272emr4568738vsb.12.1708938350698; Mon, 26
 Feb 2024 01:05:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com> <ZdiI-40gNDKf6YgC@raptor>
In-Reply-To: <ZdiI-40gNDKf6YgC@raptor>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 26 Feb 2024 09:05:12 +0000
Message-ID: <CA+EHjTyJqsCPGfvyjAsL763FdLdB9QhpwSewBe2y7Y195Y+5ig@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Fri, Feb 23, 2024 at 12:01=E2=80=AFPM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> I have a question regarding memory shared between the host and a protecte=
d
> guest. I scanned the series, and the pKVM patches this series is based on=
,
> but I couldn't easily find the answer.
>
> When a page is shared, that page is not mapped in the stage 2 tables that
> the host maintains for a regular VM (kvm->arch.mmu), right? It wouldn't
> make much sense for KVM to maintain its own stage 2 that is never used, b=
ut
> I thought I should double check that to make sure I'm not missing
> something.

You're right. In protected mode the stage-2 tables are maintained by
the hypervisor in EL2, since we don't trust the host kernel. It is
still KVM of course, but not the regular VM structure, like you said.

Cheers,
/fuad

>
> Thanks,
> Alex
>
> On Thu, Feb 22, 2024 at 04:10:21PM +0000, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd [1], as
> > well as support guest_memfd on pKVM/arm64.
> >
> > This series is based on Linux 6.8-rc4 + our pKVM core series [2].
> > The KVM core patches apply to Linux 6.8-rc4 (patches 1-6), but
> > the remainder (patches 7-26) require the pKVM core series. A git
> > repo with this series applied can be found here [3]. We have a
> > (WIP) kvmtool port capable of running the code in this series
> > [4]. For a technical deep dive into pKVM, please refer to Quentin
> > Perret's KVM Forum Presentation [5, 6].
> >
> > I've covered some of the issues presented here in my LPC 2023
> > presentation [7].
> >
> > We haven't started using this in Android yet, but we aim to move
> > away from anonymous memory to guest_memfd once we have the
> > necessary support merged upstream. Others (e.g., Gunyah [8]) are
> > also looking into guest_memfd for similar reasons as us.
> >
> > By design, guest_memfd cannot be mapped, read, or written by the
> > host userspace. In pKVM, memory shared between a protected guest
> > and the host is shared in-place, unlike the other confidential
> > computing solutions that guest_memfd was originally envisaged for
> > (e.g, TDX). When initializing a guest, as well as when accessing
> > memory shared by the guest to the host, it would be useful to
> > support mapping that memory at the host to avoid copying its
> > contents.
> >
> > One of the benefits of guest_memfd is that it prevents a
> > misbehaving host process from crashing the system when attempting
> > to access (deliberately or accidentally) protected guest memory,
> > since this memory isn't mapped to begin with. Without
> > guest_memfd, the hypervisor would still prevent such accesses,
> > but in certain cases the host kernel wouldn't be able to recover,
> > causing the system to crash.
> >
> > Support for mmap() in this patch series maintains the invariant
> > that only memory shared with the host, either explicitly by the
> > guest or implicitly before the guest has started running (in
> > order to populate its memory) is allowed to be mapped. At no time
> > should private memory be mapped at the host.
> >
> > This patch series is divided into two parts:
> >
> > The first part is to the KVM core code (patches 1-6), and is
> > based on guest_memfd as of Linux 6.8-rc4. It adds opt-in support
> > for mapping guest memory only as long as it is shared. For that,
> > the host needs to know the sharing status of guest memory.
> > Therefore, the series adds a new KVM memory attribute, accessible
> > only by the host kernel, that specifies whether the memory is
> > allowed to be mapped by the host userspace.
> >
> > The second part of the series (patches 7-26) adds guest_memfd
> > support for pKVM/arm64, and is based on the latest version of our
> > pKVM series [2]. It uses guest_memfd instead of the current
> > approach in Android (not upstreamed) of maintaining a long-term
> > GUP on anonymous memory donated to the guest. These patches
> > handle faulting in guest memory for a guest, as well as handling
> > sharing and unsharing of guest memory while maintaining the
> > invariant mentioned earlier.
> >
> > In addition to general feedback, we would like feedback on how we
> > handle mmap() and faulting-in guest pages at the host (KVM: Add
> > restricted support for mapping guest_memfd by the host).
> >
> > We don't enforce the invariant that only memory shared with the
> > host can be mapped by the host userspace in
> > file_operations::mmap(), but in vm_operations_struct:fault(). On
> > vm_operations_struct::fault(), we check whether the page is
> > shared with the host. If not, we deliver a SIGBUS to the current
> > task. The reason for enforcing this at fault() is that mmap()
> > does not elevate the pagecount(); it's the faulting in of the
> > page which does. Even if we were to check at mmap() whether an
> > address can be mapped, we would still need to check again on
> > fault(), since between mmap() and fault() the status of the page
> > can change.
> >
> > This creates the situation where access to successfully mmap()'d
> > memory might SIGBUS at page fault. There is precedence for
> > similar behavior in the kernel I believe, with MADV_HWPOISON and
> > the hugetlbfs cgroups controller, which could SIGBUS at page
> > fault time depending on the accounting limit.
> >
> > Another pKVM specific aspect we would like feedback on, is how to
> > handle memory mapped by the host being unshared by a guest. The
> > approach we've taken is that on an unshare call from the guest,
> > the host userspace is notified that the memory has been unshared,
> > in order to allow it to unmap it and mark it as PRIVATE as
> > acknowledgment. If the host does not unmap the memory, the
> > unshare call issued by the guest fails, which the guest is
> > informed about on return.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.=
com/
> >
> > [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstrea=
m/pkvm-core
> >
> > [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guest=
mem-6.8-rfc-v1
> >
> > [4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/gue=
stmem-6.8
> >
> > [5] Protected KVM on arm64 (slides)
> > https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%20202=
2%20-%20pKVM%20deep%20dive.pdf
> >
> > [6] Protected KVM on arm64 (video)
> > https://www.youtube.com/watch?v=3D9npebeVFbFw
> >
> > [7] Supporting guest private memory in Protected KVM on Android (presen=
tation)
> > https://lpc.events/event/17/contributions/1487/
> >
> > [8] Drivers for Gunyah (patch series)
> > https://lore.kernel.org/all/20240109-gunyah-v16-0-634904bf4ce9@quicinc.=
com/
> >
> > Fuad Tabba (20):
> >   KVM: Split KVM memory attributes into user and kernel attributes
> >   KVM: Introduce kvm_gmem_get_pfn_locked(), which retains the folio loc=
k
> >   KVM: Add restricted support for mapping guestmem by the host
> >   KVM: Don't allow private attribute to be set if mapped by host
> >   KVM: Don't allow private attribute to be removed for unmappable memor=
y
> >   KVM: Implement kvm_(read|/write)_guest_page for private memory slots
> >   KVM: arm64: Create hypercall return handler
> >   KVM: arm64: Refactor code around handling return from host to guest
> >   KVM: arm64: Rename kvm_pinned_page to kvm_guest_page
> >   KVM: arm64: Add a field to indicate whether the guest page was pinned
> >   KVM: arm64: Do not allow changes to private memory slots
> >   KVM: arm64: Skip VMA checks for slots without userspace address
> >   KVM: arm64: Handle guest_memfd()-backed guest page faults
> >   KVM: arm64: Track sharing of memory from protected guest to host
> >   KVM: arm64: Mark a protected VM's memory as unmappable at
> >     initialization
> >   KVM: arm64: Handle unshare on way back to guest entry rather than exi=
t
> >   KVM: arm64: Check that host unmaps memory unshared by guest
> >   KVM: arm64: Add handlers for kvm_arch_*_set_memory_attributes()
> >   KVM: arm64: Enable private memory support when pKVM is enabled
> >   KVM: arm64: Enable private memory kconfig for arm64
> >
> > Keir Fraser (3):
> >   KVM: arm64: Implement MEM_RELINQUISH SMCCC hypercall
> >   KVM: arm64: Strictly check page type in MEM_RELINQUISH hypercall
> >   KVM: arm64: Avoid unnecessary unmap walk in MEM_RELINQUISH hypercall
> >
> > Quentin Perret (1):
> >   KVM: arm64: Turn llist of pinned pages into an rb-tree
> >
> > Will Deacon (2):
> >   KVM: arm64: Add initial support for KVM_CAP_EXIT_HYPERCALL
> >   KVM: arm64: Allow userspace to receive SHARE and UNSHARE notification=
s
> >
> >  arch/arm64/include/asm/kvm_host.h             |  17 +-
> >  arch/arm64/include/asm/kvm_pkvm.h             |   1 +
> >  arch/arm64/kvm/Kconfig                        |   2 +
> >  arch/arm64/kvm/arm.c                          |  32 ++-
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   1 +
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  24 +-
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  67 +++++
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  89 +++++-
> >  arch/arm64/kvm/hyp/nvhe/switch.c              |   1 +
> >  arch/arm64/kvm/hypercalls.c                   | 117 +++++++-
> >  arch/arm64/kvm/mmu.c                          | 138 +++++++++-
> >  arch/arm64/kvm/pkvm.c                         |  83 +++++-
> >  include/linux/arm-smccc.h                     |   7 +
> >  include/linux/kvm_host.h                      |  34 +++
> >  include/uapi/linux/kvm.h                      |   4 +
> >  virt/kvm/Kconfig                              |   4 +
> >  virt/kvm/guest_memfd.c                        |  89 +++++-
> >  virt/kvm/kvm_main.c                           | 260 ++++++++++++++++--
> >  19 files changed, 904 insertions(+), 68 deletions(-)
> >
> > --
> > 2.44.0.rc1.240.g4c46232300-goog
> >
> >

