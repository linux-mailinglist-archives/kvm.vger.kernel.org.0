Return-Path: <kvm+bounces-25080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFE895FAC0
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:44:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 855DC1F232D4
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 20:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1494E19AA41;
	Mon, 26 Aug 2024 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mqo4rYXI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEAF198A35
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 20:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724705042; cv=none; b=F5gWMnXGV0xtNiA4rkBLlOT0wNFjneGsQNTny7LWYbi9+zFkCN9GzGLvtEqfmhZo+u9NZLPqAPhoo0l0Vy6cwbajSTxIc6TaMqH6X02Y8MiDLOehGCIBWa8upvy7itdnm9sHiL9k64S0IZJinfA9FKkoi5aY1xutbCF4z5wwVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724705042; c=relaxed/simple;
	bh=BVO+YR246l/9r0e/byPt8EUyViZMVVysBhWLwpx9cAg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nTVAZauQJgTLFb3DJykWJUH/lNlKIdHb/Fol3KshP5pLY7GpLYaVO/b8jo1tg5hueiaEWIVbqOgvhaOydrx6kw35Yg1YkSfuUBe04yqzadzmDVGptAsH+WPbE4tzhN3i9S7SDc7oC3ThbYnQQOgpTcFOwAuSjvX5q3fSN43C0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mqo4rYXI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724705038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CqQ/hRiY99K+cUirVhLBuO5vcLt3pG6RmiLI5l4wO5w=;
	b=Mqo4rYXIXYijh7KUSw04RFVnMJxux3NxzPfiv340sw4vpVOdsPEbfae6VDFiXkN5liH55Q
	2pbKalotnII8UGNSaS11t0IGlMOkCoXPnp/mguRiy0P9kdxL+sQrG/ZsrfSEcczYgOCqVe
	GCdfLhVEyETtjkgV9WCcs+gqchepD8E=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-8UR-1fjIPgKmTnxCW0P6BA-1; Mon, 26 Aug 2024 16:43:57 -0400
X-MC-Unique: 8UR-1fjIPgKmTnxCW0P6BA-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-5da5516c615so6121828eaf.1
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 13:43:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724705037; x=1725309837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CqQ/hRiY99K+cUirVhLBuO5vcLt3pG6RmiLI5l4wO5w=;
        b=S6reX0oGyUlC7shiMT/ntACWU6Zfzjyf0OisumHCu8kXJuDRpNMBkGeETOqJm+pUiA
         YklhslDoAXrniIyntai9Yo7+Va666enwby+sX4Xaw1uGIs4M9r6y0e2vIRgXW76m85gB
         UkYy9Nnbft+eQ+8Ma+jZekPYAta28jO+IqaTBilVhh3Ztu+2HoURgnMkStmncbHIdJ1+
         zIs1lhiOJYLQjur/OxYNUf078anTSFrEcbOu4BQeoi4AcGIfLhrZvQjFMYkmgCXQNRrD
         Dg2+aB59qX6dbLxGvrbsVTk1b3f1+L83Ue/aZBICAItRC6lsmJA/eHI2m1lGjQh3q18s
         hvVg==
X-Forwarded-Encrypted: i=1; AJvYcCVWPCP//KDFjd7DiWWkHGIQPKdzmdAk/3qUwa1AoOZQ7fmDXlnpSk0an/jvIgI3qj5PdQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDhLuZBc2l17/FhYqmIH5bL1JjxEey0xB1o9kH2VIDn6O+4zyj
	266loXZsOSl/hmKV6/RbqyhUsdJs47KK3zUp5rLpfuyi0WEGEBTeWteQUBJm2kMMM8dx89YWl8T
	JpnzD3vg8vNQ1xAPzlbrW6S9RcP56dmB9jigTXl6YPa+Mp8bf2Q==
X-Received: by 2002:a05:6358:5f02:b0:1a2:5c3a:f0f4 with SMTP id e5c5f4694b2df-1b5c21404f7mr1432947255d.10.1724705036529;
        Mon, 26 Aug 2024 13:43:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyyKMsJpLPMEksW4NYjFhzYiamATxdwSrsf9LyMQ9VEwCSu9KgZAw+ZJQVxwesTLM/WU2jhQ==
X-Received: by 2002:a05:6358:5f02:b0:1a2:5c3a:f0f4 with SMTP id e5c5f4694b2df-1b5c21404f7mr1432945155d.10.1724705036056;
        Mon, 26 Aug 2024 13:43:56 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3fd6c1sm491055185a.121.2024.08.26.13.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 13:43:55 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	peterx@redhat.com,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 00/19] mm: Support huge pfnmaps
Date: Mon, 26 Aug 2024 16:43:34 -0400
Message-ID: <20240826204353.2228736-1-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- Added tags
- Let folio_walk_start() scan special pmd/pud bits [DavidH]
- Switch copy_huge_pmd() COW+writable check into a VM_WARN_ON_ONCE()
- Update commit message to drop mentioning of gup-fast, in patch "mm: Mark
  special bits for huge pfn mappings when inject" [JasonG]
- In gup-fast, reorder _special check v.s. _devmap check, so as to make
  pmd/pud path look the same as pte path [DavidH, JasonG]
- Enrich comments for follow_pfnmap*() API, emphasize the risk when PFN is
  used after the end() is invoked, s/-ve/negative/ [JasonG, Sean]

Overview
========

This series is based on mm-unstable, commit b659edec079c of Aug 26th
latest, with patch "vma remove the unneeded avc bound with non-CoWed folio"
reverted, as reported broken [0].

This series implements huge pfnmaps support for mm in general.  Huge pfnmap
allows e.g. VM_PFNMAP vmas to map in either PMD or PUD levels, similar to
what we do with dax / thp / hugetlb so far to benefit from TLB hits.  Now
we extend that idea to PFN mappings, e.g. PCI MMIO bars where it can grow
as large as 8GB or even bigger.

Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.  The last
patch (from Alex Williamson) will be the first user of huge pfnmap, so as
to enable vfio-pci driver to fault in huge pfn mappings.

Implementation
==============

In reality, it's relatively simple to add such support comparing to many
other types of mappings, because of PFNMAP's specialties when there's no
vmemmap backing it, so that most of the kernel routines on huge mappings
should simply already fail for them, like GUPs or old-school follow_page()
(which is recently rewritten to be folio_walk* APIs by David).

One trick here is that we're still unmature on PUDs in generic paths here
and there, as DAX is so far the only user.  This patchset will add the 2nd
user of it.  Hugetlb can be a 3rd user if the hugetlb unification work can
go on smoothly, but to be discussed later.

The other trick is how to allow gup-fast working for such huge mappings
even if there's no direct sign of knowing whether it's a normal page or
MMIO mapping.  This series chose to keep the pte_special solution, so that
it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
gup-fast will be able to identify them and fail properly.

Along the way, we'll also notice that the major pgtable pfn walker, aka,
follow_pte(), will need to retire soon due to the fact that it only works
with ptes.  A new set of simple API is introduced (follow_pfnmap* API) to
be able to do whatever follow_pte() can already do, plus that it can also
process huge pfnmaps now.  Half of this series is about that and converting
all existing pfnmap walkers to use the new API properly.  Hopefully the new
API also looks better to avoid exposing e.g. pgtable lock details into the
callers, so that it can be used in an even more straightforward way.

Here, three more options will be introduced and involved in huge pfnmap:

  - ARCH_SUPPORTS_HUGE_PFNMAP

    Arch developers will need to select this option when huge pfnmap is
    supported in arch's Kconfig.  After this patchset applied, both x86_64
    and arm64 will start to enable it by default.

  - ARCH_SUPPORTS_PMD_PFNMAP / ARCH_SUPPORTS_PUD_PFNMAP

    These options are for driver developers to identify whether current
    arch / config supports huge pfnmaps, making decision on whether it can
    use the huge pfnmap APIs to inject them.  One can refer to the last
    vfio-pci patch from Alex on the use of them properly in a device
    driver.

So after the whole set applied, and if one would enable some dynamic debug
lines in vfio-pci core files, we should observe things like:

  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x0: 0x100
  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x200: 0x100
  vfio-pci 0000:00:06.0: vfio_pci_mmap_huge_fault(,order = 9) BAR 0 page offset 0x400: 0x100

In this specific case, it says that vfio-pci faults in PMDs properly for a
few BAR0 offsets.

Patch Layout
============

Patch 1:         Introduce the new options mentioned above for huge PFNMAPs
Patch 2:         A tiny cleanup
Patch 3-8:       Preparation patches for huge pfnmap (include introduce
                 special bit for pmd/pud)
Patch 9-16:      Introduce follow_pfnmap*() API, use it everywhere, and
                 then drop follow_pte() API
Patch 17:        Add huge pfnmap support for x86_64
Patch 18:        Add huge pfnmap support for arm64
Patch 19:        Add vfio-pci support for all kinds of huge pfnmaps (Alex)

TODO
====

More architectures / More page sizes
------------------------------------

Currently only x86_64 (2M+1G) and arm64 (2M) are supported.  There seems to
have plan to support arm64 1G later on top of this series [2].

Any arch will need to first support THP / THP_1G, then provide a special
bit in pmds/puds to support huge pfnmaps.

remap_pfn_range() support
-------------------------

Currently, remap_pfn_range() still only maps PTEs.  With the new option,
remap_pfn_range() can logically start to inject either PMDs or PUDs when
the alignment requirements match on the VAs.

When the support is there, it should be able to silently benefit all
drivers that is using remap_pfn_range() in its mmap() handler on better TLB
hit rate and overall faster MMIO accesses similar to processor on hugepages.

More driver support
-------------------

VFIO is so far the only consumer for the huge pfnmaps after this series
applied.  Besides above remap_pfn_range() generic optimization, device
driver can also try to optimize its mmap() on a better VA alignment for
either PMD/PUD sizes.  This may, iiuc, normally require userspace changes,
as the driver doesn't normally decide the VA to map a bar.  But I don't
think I know all the drivers to know the full picture.

Tests Done
==========

- Cross-build tests

- run_vmtests.sh

- Hacked e1000e QEMU with 128MB BAR 0, with some prefault test, mprotect()
  and fork() tests on the bar mapped

- x86_64 + AMD GPU
  - Needs Alex's modified QEMU to guarantee proper VA alignment to make
    sure all pages to be mapped with PUDs
  - Main BAR (8GB) start to use PUD mappings
  - Sub BAR (??MBs?) start to use PMD mappings
  - Performance wise, slight improvement comparing to the old PTE mappings

- aarch64 + NIC
  - Detached NIC test to make sure driver loads fine with PMD mappings

Credits all go to Alex on help testing the GPU/NIC use cases above.

Comments welcomed, thanks.

[0] https://lore.kernel.org/r/73ad9540-3fb8-4154-9a4f-30a0a2b03d41@lucifer.local
[1] https://lore.kernel.org/r/20240807194812.819412-1-peterx@redhat.com
[2] https://lore.kernel.org/r/498e0731-81a4-4f75-95b4-a8ad0bcc7665@huawei.com

Alex Williamson (1):
  vfio/pci: Implement huge_fault support

Peter Xu (18):
  mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
  mm: Drop is_huge_zero_pud()
  mm: Mark special bits for huge pfn mappings when inject
  mm: Allow THP orders for PFNMAPs
  mm/gup: Detect huge pfnmap entries in gup-fast
  mm/pagewalk: Check pfnmap for folio_walk_start()
  mm/fork: Accept huge pfnmap entries
  mm: Always define pxx_pgprot()
  mm: New follow_pfnmap API
  KVM: Use follow_pfnmap API
  s390/pci_mmio: Use follow_pfnmap API
  mm/x86/pat: Use the new follow_pfnmap API
  vfio: Use the new follow_pfnmap API
  acrn: Use the new follow_pfnmap API
  mm/access_process_vm: Use the new follow_pfnmap API
  mm: Remove follow_pte()
  mm/x86: Support large pfn mappings
  mm/arm64: Support large pfn mappings

 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/pgtable.h    |  30 +++++
 arch/powerpc/include/asm/pgtable.h  |   1 +
 arch/s390/include/asm/pgtable.h     |   1 +
 arch/s390/pci/pci_mmio.c            |  22 ++--
 arch/sparc/include/asm/pgtable_64.h |   1 +
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/pgtable.h      |  80 +++++++-----
 arch/x86/mm/pat/memtype.c           |  17 ++-
 drivers/vfio/pci/vfio_pci_core.c    |  60 ++++++---
 drivers/vfio/vfio_iommu_type1.c     |  16 +--
 drivers/virt/acrn/mm.c              |  16 +--
 include/linux/huge_mm.h             |  16 +--
 include/linux/mm.h                  |  57 ++++++++-
 include/linux/pgtable.h             |  12 ++
 mm/Kconfig                          |  13 ++
 mm/gup.c                            |   6 +
 mm/huge_memory.c                    |  50 +++++---
 mm/memory.c                         | 183 ++++++++++++++++++++--------
 mm/pagewalk.c                       |   4 +-
 virt/kvm/kvm_main.c                 |  19 ++-
 21 files changed, 425 insertions(+), 181 deletions(-)

-- 
2.45.0


