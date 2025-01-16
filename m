Return-Path: <kvm+bounces-35635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28011A13675
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 10:19:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 418DE167D1F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AF61D95A3;
	Thu, 16 Jan 2025 09:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xnwI3YUy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20AD4A05
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 09:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019189; cv=none; b=QDoc6qogZCAZaUxNdhEhr/ogrF8WLmHqxk/pIEz+9VphPHuZ9P24sToLDcHHYLrOa89P8QS5WIwldR/Y2xyrpGTuOnuDM+c3q28D1XGUI7fVgmbGGmooNQteX8UqTc41sCDZzYZRRbxA8gfeqGQn2CLhnSDTCLvBg4QUyVhRX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019189; c=relaxed/simple;
	bh=o9sTj5DM+zlnNnoDC/0h4jm3J6PO0PJuplVlGaYJvkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=osTUpWxUPiJaIpcQKcDv9ZiA+Lf/V7F378t6Bjg7Vmmmb6U2+r87dJtuzkz7C21g6pct3Gnfp6ar5i9qsJz/aTID0BcTR0j6hW/sxD9n8KeI8O8pJYuW7gzL+OFiYJADcRcBR0Z3zir5nmW8BQMAjdtw10ofnnaZaIWAk/QjFPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xnwI3YUy; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso28755e9.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 01:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737019186; x=1737623986; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QOQTH7tUiMk7fJ9MtVwTdXT5DSu9exzYGVvW00E16nc=;
        b=xnwI3YUyGrF2YOT4rzuEzYRr6igErgmlP9bK7NMjTRxexdNiptuenWek0RHYQ8lDdS
         4rSTFzeMlS2PMkfv+vrwCLhCMGqKroW4wWQsNjOiqitfMss9H84dm4ATcfu8NmPpJV4J
         YLFopInW/z8FxlkqBOSOUZ5GsxTh6TfhNgu5Yay5gSVbsdjY+Yml1yxy96OzjzCquYKp
         BEBcMKU9Ofm7sdcsoPIebJzb4GDpYEeAmtpyGwItmhu9JX+5Q85lOB+QxEFIcc52eCrU
         jRMUGjlyV9zKGU6+7iGFz3WOp3xMe0p770wspKPf+pC43JkfBZmkf0nsumNUkPTsuhh6
         mkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737019186; x=1737623986;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QOQTH7tUiMk7fJ9MtVwTdXT5DSu9exzYGVvW00E16nc=;
        b=tmUuhvnivj9cm2fR33qR6zkyv26lQE+A55j2Oytyci457iX5WCmDrNey2MQLwGjFR5
         UAGRmOkra01L91ZVtawJtrLOrdGnH8wNUTYsP2GkfImknET+Bn9eNmNzFp4gS84w7m6F
         LWM1Nl810baxNLsnDtVxZ5HdLAI0qJf2VAYIH82LsjS1YtHWW8dkwTQJV8Umqp4HLxqR
         yMI0EMDWhrAXr2zKskKN82xEqcgq4TYsQN2JI7SlQ3WokqFi494EiWJrczU4FRSuZ4ev
         aPCNDrqtQP1iVvOcqtV+VCPu0cVLJvtaIB8ZYhURnVbkRNopSREh7U5o17qtqQ/VBuIo
         WT9A==
X-Gm-Message-State: AOJu0YxTdiF0nXZGwwSInKPS0b/hWxpwl9W5LEAxt/SH/GHp1g5X8nXD
	632KpplyhWt4YqJU8UGTgB1BcBuyfivrGRYMdfNs+OHnfm+hNSsR9R11Nsmo0Cyg6odX/EOVRzB
	TeUHpfilGtuFEU0Hv39IGi+Lek7g8Nx/zS5pR
X-Gm-Gg: ASbGncsgTWEJP9TyPkDWUjhop5RKmEEPctXNoBb7pSbbw79YrKl8cy/rahbZBWSifJ2
	X1SzEH6d+kZk7p5eGXEdXrR7QphU+1xnDlg+FMTIxPL5M0YGJ1pLZ8NAiM3g+Nw+ei+8=
X-Google-Smtp-Source: AGHT+IE8aMwLow5sWY5fJzCKY+xspZ5j3Pvj+/nmGPI1JUwww3Pw+7qETN7C17jt8ym+ycXUPeSkWTSDDlDTu48ZCmI=
X-Received: by 2002:a05:600c:19c9:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4388b2ec3a2mr860695e9.2.1737019185907; Thu, 16 Jan 2025
 01:19:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EHjTzcx=eXSERSANMByhcgRRAbUL3kPAYkeu-uUgd0nPBPPA@mail.gmail.com>
 <diqzh65zzjc9.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzh65zzjc9.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 16 Jan 2025 09:19:09 +0000
X-Gm-Features: AbW1kvYfdnAg5jzOGsWKnus5CfXOeCmlxVqueDrpwKXgQxSqa_22kWzst03_IAY
Message-ID: <CA+EHjTwXqUHoEp8oqiNDcWqXxCBLHU1+jAdEN8J-pHZjxKnM+A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Thu, 16 Jan 2025 at 00:35, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Hi,
> >
> > As mentioned in the guest_memfd sync (2025-01-09), below is the state
> > diagram that uses the new states in this patch series, and how they
> > would interact with sharing/unsharing in pKVM:
> >
> > https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf
>
> Thanks Fuad!
>
> I took a look at the state diagram [1] and the branch that this patch is
> on [2], and here's what I understand about the flow:
>
> 1. From state H in the state diagram, the guest can request to unshare a
>    page. When KVM handles this unsharing, KVM marks the folio
>    mappability as NONE (state J).
> 2. The transition from state J to state K or I is independent of KVM -
>    userspace has to do this unmapping
> 3. On the next vcpu_run() from userspace, continuing from userspace's
>    handling of the unshare request, guest_memfd will check and try to
>    register a callback if the folio's mappability is NONE. If the folio
>    is mapped, or if folio is not mapped but refcount is elevated for
>    whatever reason, vcpu_run() fails and exits to userspace. If folio is
>    not mapped and gmem holds the last refcount, set folio mappability to
>    GUEST.
>
> Here's one issue I see based on the above understanding:
>
> Registration of the folio_put() callback only happens if the VMM
> actually tries to do vcpu_run(). For 4K folios I think this is okay
> since the 4K folio can be freed via the transition state K -> state I,
> but for hugetlb folios that have been split for sharing with userspace,
> not getting a folio_put() callback means never putting the hugetlb folio
> together. Hence, relying on vcpu_run() to add the folio_put() callback
> leaves a way that hugetlb pages can be removed from the system.
>
> I think we should try and find a path forward that works for both 4K and
> hugetlb folios.

I agree, this could be an issue, but we could find other ways to
trigger the callback for huge folios. The important thing I was trying
to get to is how to have the callback and be able to register it.

> IIUC page._mapcount and page.page_type works as a union because
> page_type is only set for page types that are never mapped to userspace,
> like PGTY_slab, PGTY_offline, etc.

In the last guest_memfd sync, David Hildenbrand mentioned that that
would be a temporary restriction since the two structures would
eventually be decoupled, work being done by Matthew Wilcox I believe.


> Technically PGTY_guest_memfd is only set once the page can never be
> mapped to userspace, but PGTY_guest_memfd can only be set once mapcount
> reaches 0. Since mapcount is added in the faulting process, could gmem
> perhaps use some kind of .unmap/.unfault callback, so that gmem gets
> notified of all unmaps and will know for sure that the mapcount gets to
> 0?

I'm not sure if there is such a callback. If there were, I'm not sure
what that would buy us really. The main pain point is the refcount
going down to zero. The mapcount part is pretty straightforard and
likely to be only temporary as mentioned, i.e., when it get decoupled,
we could register the callback earlier and simplify the transition
altogether.

> Alternatively, I took a look at the folio_is_zone_device()
> implementation, and page.flags is used to identify the page's type. IIUC
> a ZONE_DEVICE page also falls in the intersection of needing a
> folio_put() callback and can be mapped to userspace. Could we use a
> similar approach, using page.flags to identify a page as a guest_memfd
> page? That way we don't need to know when unmapping happens, and will
> always be able to get a folio_put() callback.

Same as above, with this being temporary, adding a new page flag might
not be something that the rest of the community might be too excited
about :)

Thanks for your comments!
/fuad

> [1] https://lpc.events/event/18/contributions/1758/attachments/1457/3699/Guestmemfd%20folio%20state%20page_type.pdf
> [2] https://android-kvm.googlesource.com/linux/+/764360863785ba16d974253a572c87abdd9fdf0b%5E%21/#F0
>
> > This patch series doesn't necessarily impose all these transitions,
> > many of them would be a matter of policy. This just happens to be the
> > current way I've done it with pKVM/arm64.
> >
> > Cheers,
> > /fuad
> >
> > On Fri, 13 Dec 2024 at 16:48, Fuad Tabba <tabba@google.com> wrote:
> >>
> >> This series adds restricted mmap() support to guest_memfd, as
> >> well as support for guest_memfd on arm64. It is based on Linux
> >> 6.13-rc2.  Please refer to v3 for the context [1].
> >>
> >> Main changes since v3:
> >> - Added a new folio type for guestmem, used to register a
> >>   callback when a folio's reference count reaches 0 (Matthew
> >>   Wilcox, DavidH) [2]
> >> - Introduce new mappability states for folios, where a folio can
> >> be mappable by the host and the guest, only the guest, or by no
> >> one (transient state)
> >> - Rebased on Linux 6.13-rc2
> >> - Refactoring and tidying up
> >>
> >> Cheers,
> >> /fuad
> >>
> >> [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
> >> [2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/
> >>
> >> Ackerley Tng (2):
> >>   KVM: guest_memfd: Make guest mem use guest mem inodes instead of
> >>     anonymous inodes
> >>   KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
> >>
> >> Fuad Tabba (12):
> >>   mm: Consolidate freeing of typed folios on final folio_put()
> >>   KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
> >>     the folio lock
> >>   KVM: guest_memfd: Folio mappability states and functions that manage
> >>     their transition
> >>   KVM: guest_memfd: Handle final folio_put() of guestmem pages
> >>   KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
> >>   KVM: guest_memfd: Add guest_memfd support to
> >>     kvm_(read|/write)_guest_page()
> >>   KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
> >>     mappable
> >>   KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
> >>     mappable
> >>   KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
> >>     allowed
> >>   KVM: arm64: Skip VMA checks for slots without userspace address
> >>   KVM: arm64: Handle guest_memfd()-backed guest page faults
> >>   KVM: arm64: Enable guest_memfd private memory when pKVM is enabled
> >>
> >>  Documentation/virt/kvm/api.rst                |   4 +
> >>  arch/arm64/include/asm/kvm_host.h             |   3 +
> >>  arch/arm64/kvm/Kconfig                        |   1 +
> >>  arch/arm64/kvm/mmu.c                          | 119 +++-
> >>  include/linux/kvm_host.h                      |  75 +++
> >>  include/linux/page-flags.h                    |  22 +
> >>  include/uapi/linux/kvm.h                      |   2 +
> >>  include/uapi/linux/magic.h                    |   1 +
> >>  mm/debug.c                                    |   1 +
> >>  mm/swap.c                                     |  28 +-
> >>  tools/testing/selftests/kvm/Makefile          |   1 +
> >>  .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
> >>  virt/kvm/Kconfig                              |   4 +
> >>  virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
> >>  virt/kvm/kvm_main.c                           | 229 ++++++-
> >>  15 files changed, 1074 insertions(+), 59 deletions(-)
> >>
> >>
> >> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> >> --
> >> 2.47.1.613.gc27f4b7a9f-goog
> >>

