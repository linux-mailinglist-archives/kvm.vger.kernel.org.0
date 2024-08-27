Return-Path: <kvm+bounces-25213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D67A1961A0A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FB78B22DC8
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB621D4160;
	Tue, 27 Aug 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wwb5thae"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D51189917
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724798186; cv=none; b=rsBn4Zdii2dQsL4/27VPgaot1MUWCmbm+bJ8yIdM+EYpdBo9dEnoSXuE+a4F2Ui/72rkqHImpQK7jNBp5RdHo+xHE/7xlSPvOrQJ/yMVsKMs7S7LxYZ3J8seeXYBlrHyMonnoRC+3xON8w9OjiHFutjLT7taZsIiugLAlEef0O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724798186; c=relaxed/simple;
	bh=X9PYKJLgK0Anu/T+r7Cmv4P5xnYLXYtrA6NmjBpmoHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nuoUrX6qFWLGfPVamPSBfQF+7fNwgpCUXeJFxfM3+Rci58cP6vWeAq97/qVindar2lP9HC25I9MZi98dtLUEhImYf0SIpIm8Dbq1Ikwa2Q4a/9WI4iAcyDmNKHB2TjYRvCmM1KsDIQecUQZR4/hYU9IdQnqWPUyWajcVQIYnWOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wwb5thae; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-427fc9834deso22675e9.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724798182; x=1725402982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7Z8bHC9lXhnYf47HvMGTMfGY056hXU2IGQLlFcO8fg=;
        b=Wwb5thae4pJdtwp2vOLn4nJduJuft/YyD53+z4YmrT6TjGuxaezsFF9A3ojIrOXJcA
         kh+3I/UzsY/rtlAdHPoVxX7BqkTs9jAaRUQuDLEQbBpTDGm7lQhV/VR7248sVVQOe4JA
         uu978BhZ9wzLKT98IYu7zzQv5jTsCMHH14HwFaikSRYcJzTYStOLcUtG5Ssf9VoT614T
         SOaD1fAMw+PbY3Rb4Hwu1/CxC6SAEK48ckQLWYf4jyEj6Imr/QZTjfbnJt3lbmqHDg3m
         rC52RpX0H0Ial24gWC3VxXIanLoAjL15+MnVJ/yR0bZkj/yILeLqBP2IfXcPIWkxBzbp
         Qyow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724798182; x=1725402982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7Z8bHC9lXhnYf47HvMGTMfGY056hXU2IGQLlFcO8fg=;
        b=Ya2qKMZNv7K4u9FbtX6LCrHW2B/p9Q2GHU2oJJ9dKPuVMjFRRviOO4pj4WsdmYv33X
         SZT2oi2YA9I2/qhlnQCQthCWsj2sg2CvMXTrRJW0vH8PgPZSKFcYZtbo8BqOb1mst3oa
         zeEnFCTslqYPDVOE8cEeTSDtFvCeuxXlQqrXvc6Et+p/lBga/k311usUfPQ3okvN6eOI
         sEKBtDcdCbAgrAH0xgQ7K7yMiphmPznjQMoXVtPLXn913Bbo27p6ZgYCgSY+WTHc68As
         hKD6Njlq1snfP7l1+0Ki/RqBNF7T3eFjWeiXqIX16s1kEC4Nqyl+o56o9Zn2AWoGah7E
         +Pjw==
X-Forwarded-Encrypted: i=1; AJvYcCXWSzLpUEqHp68hvRpVDyHECl+ANMB/oB2QMkUiLUQHGBVW5ij0VXlkzAGnd8rXzP/0HEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN46zvTnWHWIWQg2Mx69J5KdnQXUsDqql2ierIQ2jZ8cH8YyI3
	UI1x4e4s/UyMzKR0G3M/MH7XYWVueqe6JIbKs6wppGqRZuwEUMv3bJvIZc+mTdo3Wp0HLNLPzBS
	x9AtUEmXMtT4SKwGB9I95OIbi7GTT7s+KHem5
X-Google-Smtp-Source: AGHT+IERarZz0t8KpbIzW+ZARbyqwfuN177nAbHR5HvRaocRDTIom/7x2jD8I5SxtyZhmQnBn5njFCAOBfVRulF8IDU=
X-Received: by 2002:a05:600c:1e20:b0:426:68ce:c97a with SMTP id
 5b1f17b1804b1-42ba50d0ba9mr209745e9.7.1724798181619; Tue, 27 Aug 2024
 15:36:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com>
In-Reply-To: <20240826204353.2228736-1-peterx@redhat.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 27 Aug 2024 15:36:07 -0700
Message-ID: <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>, 
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Hildenbrand <david@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 26, 2024 at 1:44=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> v2:
> - Added tags
> - Let folio_walk_start() scan special pmd/pud bits [DavidH]
> - Switch copy_huge_pmd() COW+writable check into a VM_WARN_ON_ONCE()
> - Update commit message to drop mentioning of gup-fast, in patch "mm: Mar=
k
>   special bits for huge pfn mappings when inject" [JasonG]
> - In gup-fast, reorder _special check v.s. _devmap check, so as to make
>   pmd/pud path look the same as pte path [DavidH, JasonG]
> - Enrich comments for follow_pfnmap*() API, emphasize the risk when PFN i=
s
>   used after the end() is invoked, s/-ve/negative/ [JasonG, Sean]
>
> Overview
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> This series is based on mm-unstable, commit b659edec079c of Aug 26th
> latest, with patch "vma remove the unneeded avc bound with non-CoWed foli=
o"
> reverted, as reported broken [0].
>
> This series implements huge pfnmaps support for mm in general.  Huge pfnm=
ap
> allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
> what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
> we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
> as large as 8GB or even bigger.
>
> Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.  The last
> patch (from Alex Williamson) will be the first user of huge pfnmap, so as
> to enable vfio-pci driver to fault in huge pfn mappings.
>
> Implementation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> In reality, it's relatively simple to add such support comparing to many
> other types of mappings, because of PFNMAP's specialties when there's no
> vmemmap backing it, so that most of the kernel routines on huge mappings
> should simply already fail for them, like GUPs or old-school follow_page(=
)
> (which is recently rewritten to be folio_walk* APIs by David).
>
> One trick here is that we're still unmature on PUDs in generic paths here
> and there, as DAX is so far the only user.  This patchset will add the 2n=
d
> user of it.  Hugetlb can be a 3rd user if the hugetlb unification work ca=
n
> go on smoothly, but to be discussed later.
>
> The other trick is how to allow gup-fast working for such huge mappings
> even if there's no direct sign of knowing whether it's a normal page or
> MMIO mapping.  This series chose to keep the pte_special solution, so tha=
t
> it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so th=
at
> gup-fast will be able to identify them and fail properly.
>
> Along the way, we'll also notice that the major pgtable pfn walker, aka,
> follow_pte(), will need to retire soon due to the fact that it only works
> with ptes.  A new set of simple API is introduced (follow_pfnmap* API) to
> be able to do whatever follow_pte() can already do, plus that it can also
> process huge pfnmaps now.  Half of this series is about that and converti=
ng
> all existing pfnmap walkers to use the new API properly.  Hopefully the n=
ew
> API also looks better to avoid exposing e.g. pgtable lock details into th=
e
> callers, so that it can be used in an even more straightforward way.
>
> Here, three more options will be introduced and involved in huge pfnmap:
>
>   - ARCH_SUPPORTS_HUGE_PFNMAP
>
>     Arch developers will need to select this option when huge pfnmap is
>     supported in arch's Kconfig.  After this patchset applied, both x86_6=
4
>     and arm64 will start to enable it by default.
>
>   - ARCH_SUPPORTS_PMD_PFNMAP / ARCH_SUPPORTS_PUD_PFNMAP
>
>     These options are for driver developers to identify whether current
>     arch / config supports huge pfnmaps, making decision on whether it ca=
n
>     use the huge pfnmap APIs to inject them.  One can refer to the last
>     vfio-pci patch from Alex on the use of them properly in a device
>     driver.
>
> So after the whole set applied, and if one would enable some dynamic debu=
g
> lines in vfio-pci core files, we should observe things like:
>
>   vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order =3D 9) BAR 0 pag=
e offset 0x0: 0x100
>   vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order =3D 9) BAR 0 pag=
e offset 0x200: 0x100
>   vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order =3D 9) BAR 0 pag=
e offset 0x400: 0x100
>
> In this specific case, it says that vfio-pci faults in PMDs properly for =
a
> few BAR0 offsets.
>
> Patch Layout
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Patch 1:         Introduce the new options mentioned above for huge PFNMA=
Ps
> Patch 2:         A tiny cleanup
> Patch 3-8:       Preparation patches for huge pfnmap (include introduce
>                  special bit for pmd/pud)
> Patch 9-16:      Introduce follow_pfnmap*() API, use it everywhere, and
>                  then drop follow_pte() API
> Patch 17:        Add huge pfnmap support for x86_64
> Patch 18:        Add huge pfnmap support for arm64
> Patch 19:        Add vfio-pci support for all kinds of huge pfnmaps (Alex=
)
>
> TODO
> =3D=3D=3D=3D
>
> More architectures / More page sizes
> ------------------------------------
>
> Currently only x86_64 (2M+1G) and arm64 (2M) are supported.  There seems =
to
> have plan to support arm64 1G later on top of this series [2].
>
> Any arch will need to first support THP / THP_1G, then provide a special
> bit in pmds/puds to support huge pfnmaps.
>
> remap_pfn_range() support
> -------------------------
>
> Currently, remap_pfn_range() still only maps PTEs.  With the new option,
> remap_pfn_range() can logically start to inject either PMDs or PUDs when
> the alignment requirements match on the VAs.
>
> When the support is there, it should be able to silently benefit all
> drivers that is using remap_pfn_range() in its mmap() handler on better T=
LB
> hit rate and overall faster MMIO accesses similar to processor on hugepag=
es.
>

Hi Peter,

I am curious if there is any work needed for unmap_mapping_range? If a
driver hugely remap_pfn_range()ed at 1G granularity, can the driver
unmap at PAGE_SIZE granularity? For example, when handling a PFN is
poisoned in the 1G mapping, it would be great if the mapping can be
splitted to 2M mappings + 4k mappings, so only the single poisoned PFN
is lost. (Pretty much like the past proposal* to use HGM** to improve
hugetlb's memory failure handling).

Probably these questions can be answered after reading your code,
which I plan to do, but just want to ask in case you have an easy
answer for me.

* https://patchwork.plctlab.org/project/linux-kernel/cover/20230428004139.2=
899856-1-jiaqiyan@google.com/
** https://lwn.net/Articles/912017

> More driver support
> -------------------
>
> VFIO is so far the only consumer for the huge pfnmaps after this series
> applied.  Besides above remap_pfn_range() generic optimization, device
> driver can also try to optimize its mmap() on a better VA alignment for
> either PMD/PUD sizes.  This may, iiuc, normally require userspace changes=
,
> as the driver doesn't normally decide the VA to map a bar.  But I don't
> think I know all the drivers to know the full picture.
>
> Tests Done
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> - Cross-build tests
>
> - run_vmtests.sh
>
> - Hacked e1000e QEMU with 128MB BAR 0, with some prefault test, mprotect(=
)
>   and fork() tests on the bar mapped
>
> - x86_64 + AMD GPU
>   - Needs Alex's modified QEMU to guarantee proper VA alignment to make
>     sure all pages to be mapped with PUDs
>   - Main BAR (8GB) start to use PUD mappings
>   - Sub BAR (??MBs?) start to use PMD mappings
>   - Performance wise, slight improvement comparing to the old PTE mapping=
s
>
> - aarch64 + NIC
>   - Detached NIC test to make sure driver loads fine with PMD mappings
>
> Credits all go to Alex on help testing the GPU/NIC use cases above.
>
> Comments welcomed, thanks.
>
> [0] https://lore.kernel.org/r/73ad9540-3fb8-4154-9a4f-30a0a2b03d41@lucife=
r.local
> [1] https://lore.kernel.org/r/20240807194812.819412-1-peterx@redhat.com
> [2] https://lore.kernel.org/r/498e0731-81a4-4f75-95b4-a8ad0bcc7665@huawei=
.com
>
> Alex Williamson (1):
>   vfio/pci: Implement huge_fault support
>
> Peter Xu (18):
>   mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
>   mm: Drop is_huge_zero_pud()
>   mm: Mark special bits for huge pfn mappings when inject
>   mm: Allow THP orders for PFNMAPs
>   mm/gup: Detect huge pfnmap entries in gup-fast
>   mm/pagewalk: Check pfnmap for folio_walk_start()
>   mm/fork: Accept huge pfnmap entries
>   mm: Always define pxx_pgprot()
>   mm: New follow_pfnmap API
>   KVM: Use follow_pfnmap API
>   s390/pci_mmio: Use follow_pfnmap API
>   mm/x86/pat: Use the new follow_pfnmap API
>   vfio: Use the new follow_pfnmap API
>   acrn: Use the new follow_pfnmap API
>   mm/access_process_vm: Use the new follow_pfnmap API
>   mm: Remove follow_pte()
>   mm/x86: Support large pfn mappings
>   mm/arm64: Support large pfn mappings
>
>  arch/arm64/Kconfig                  |   1 +
>  arch/arm64/include/asm/pgtable.h    |  30 +++++
>  arch/powerpc/include/asm/pgtable.h  |   1 +
>  arch/s390/include/asm/pgtable.h     |   1 +
>  arch/s390/pci/pci_mmio.c            |  22 ++--
>  arch/sparc/include/asm/pgtable_64.h |   1 +
>  arch/x86/Kconfig                    |   1 +
>  arch/x86/include/asm/pgtable.h      |  80 +++++++-----
>  arch/x86/mm/pat/memtype.c           |  17 ++-
>  drivers/vfio/pci/vfio_pci_core.c    |  60 ++++++---
>  drivers/vfio/vfio_iommu_type1.c     |  16 +--
>  drivers/virt/acrn/mm.c              |  16 +--
>  include/linux/huge_mm.h             |  16 +--
>  include/linux/mm.h                  |  57 ++++++++-
>  include/linux/pgtable.h             |  12 ++
>  mm/Kconfig                          |  13 ++
>  mm/gup.c                            |   6 +
>  mm/huge_memory.c                    |  50 +++++---
>  mm/memory.c                         | 183 ++++++++++++++++++++--------
>  mm/pagewalk.c                       |   4 +-
>  virt/kvm/kvm_main.c                 |  19 ++-
>  21 files changed, 425 insertions(+), 181 deletions(-)
>
> --
> 2.45.0
>
>

