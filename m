Return-Path: <kvm+bounces-23708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9271694D431
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E36C2B22487
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A7431990C4;
	Fri,  9 Aug 2024 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhG9NU0u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60231870
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 16:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219758; cv=none; b=MBTx4QDi/8D67D1cmiXeLamLTyFlpWbWYlOuQD2yW94o5Jx/3OxE25X+oknIQP9Jxqn2B6yPQQKlsfAkhYecRuVNDekzQet4b6/Zlw7XjhT3hwinPR7fbPWEnxtEFUItz9D6nqkdGv8c8TaGIqhwgQTcFxzdSNuH1pCqfnc6LlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219758; c=relaxed/simple;
	bh=2WgmQgQEfr26aTfowCfsCu0TYq0w2lQ2BLK13a6pqnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gq+l/TRZcvjzWSr1vP9PIdbgVMNLTEfjxp0abulJkd+63MJZR7VcJhS5xye5QKtjR+xXD+IgMUWF2vGd4e4Ggg8wTm5muMYDWUZRejUJ1cBPAznySz/ZuN4Lwy2SqfikEU7vpejxjl+RxKPftVSMqiQpU73PR/28s/IkUeEGLP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhG9NU0u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723219755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H3FphSULA278eQYK8IhU8kCmMsD1ITR1tZt6BMM/yRo=;
	b=BhG9NU0ueCmcC3gIjYHgnAE13civaizyi0c/69Y5JKjZPnxeRj8lMpG2ZnoNCntRlerZE6
	OHxxGXb6x2uuhNtP/YmkahjdSBjrOUg32i57Cx13yQRFhKlsRz3LoeISAWufFWwA+HAZ0p
	0A8gqDuKwTV4euTQdyNZph7a+bR5+78=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-D8VMX860NPK-RZ11JUxUBw-1; Fri, 09 Aug 2024 12:09:14 -0400
X-MC-Unique: D8VMX860NPK-RZ11JUxUBw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-44fe28cd027so3757311cf.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 09:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723219754; x=1723824554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H3FphSULA278eQYK8IhU8kCmMsD1ITR1tZt6BMM/yRo=;
        b=BH4V0yyMT9izGm4SUGFIuvALR656x7wMUKWUNxfP8sGht9lzyr07iqkFoJFQFyjS3A
         1q8QCA8wgIJv6WhleUYn+GAlDTFZtzO1IfEUFRsj+xUiu0SKHmtRXG5JqQ5NPRuOqWky
         ZbY+OXZ9V4QH6JYIm16vHZGGhhEo0MEDlyW23OElzlZO3HbeqREr6+OYM9bp94yI+dsP
         0zEn4gpu1LyU9OQdUOFntfpJMlD6hITqlNRSrdFRr2EPb+8d7yA0Q66KNQs64uSMUG96
         EJQ32t8zfENuKRRLoRa88vNUG9QK7r58dURtLKrPgbiLZtLMsLR6D9ZmITUjt8rwvtjW
         Kyqg==
X-Forwarded-Encrypted: i=1; AJvYcCVCwclgL5r83AaZC+ybnlZFZKe+2GoLru6OvjvtJYHUOzn3kpGNZLVrAFHZAaxsq/jsem0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuvUsHycgq8RRyw+isNDJLMwnbpWYp1NECoadMWAZt3QxT8XDY
	7NAfYw4519fNeL3zIInxRnDWoALKRoa5AKBaEitv7GR0exNACPWvj+uQ+Pc+a/2plSezLe3wR5q
	oAsPdCwSGfFy6E5ZKUZT3NgWa4gXSewOv8n1ePx0ggaLQjjD98A==
X-Received: by 2002:a05:622a:1b8e:b0:447:e636:9ea9 with SMTP id d75a77b69052e-4531251c724mr14418091cf.3.1723219753542;
        Fri, 09 Aug 2024 09:09:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWNPDs+vlFTPHpFuMrdeo6E/S0PAcXPPqx11I4cRXb3TL+utF6Zl6s0U3W9M0F2mk2TxiY/g==
X-Received: by 2002:a05:622a:1b8e:b0:447:e636:9ea9 with SMTP id d75a77b69052e-4531251c724mr14417681cf.3.1723219752892;
        Fri, 09 Aug 2024 09:09:12 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c870016csm22526741cf.19.2024.08.09.09.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 09:09:11 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	peterx@redhat.com,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 00/19] mm: Support huge pfnmaps
Date: Fri,  9 Aug 2024 12:08:50 -0400
Message-ID: <20240809160909.1023470-1-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Overview
========

This series is based on mm-unstable, commit 98808d08fc0f of Aug 7th latest,
plus dax 1g fix [1].  Note that this series should also apply if without
the dax 1g fix series, but when without it, mprotect() will trigger similar
errors otherwise on PUD mappings.

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

Nothing I plan to do myself, as in our VM use case most of these doesn't
yet apply, but still list something I think might be interesting.

More architectures / More page sizes
------------------------------------

Currently only x86_64 (2M+1G) and arm64 (2M) are supported.

For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
on 1G will be automatically enabled.

Generically speaking, arch will need to first support THP / THP_1G, then
provide a special bit in pmds/puds to support huge pfnmaps.

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

Tests
=====

- Cross-build tests that I normally do. I only saw one bluetooth driver
  build failure on i386 PAE on top of latest mm-unstable, but shouldn't be
  relevant.

- run_vmtests.sh whole set, no more failures (e.g. mlock2 tests fail on
  mm-unstable)

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

[1] https://lore.kernel.org/r/20240807194812.819412-1-peterx@redhat.com

Alex Williamson (1):
  vfio/pci: Implement huge_fault support

Peter Xu (18):
  mm: Introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud
  mm: Drop is_huge_zero_pud()
  mm: Mark special bits for huge pfn mappings when inject
  mm: Allow THP orders for PFNMAPs
  mm/gup: Detect huge pfnmap entries in gup-fast
  mm/pagewalk: Check pfnmap early for folio_walk_start()
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
 arch/x86/include/asm/pgtable.h      |  80 ++++++++-----
 arch/x86/mm/pat/memtype.c           |  17 ++-
 drivers/vfio/pci/vfio_pci_core.c    |  60 +++++++---
 drivers/vfio/vfio_iommu_type1.c     |  16 +--
 drivers/virt/acrn/mm.c              |  16 +--
 include/linux/huge_mm.h             |  16 +--
 include/linux/mm.h                  |  57 ++++++++-
 include/linux/pgtable.h             |  12 ++
 mm/Kconfig                          |  13 ++
 mm/gup.c                            |   6 +
 mm/huge_memory.c                    |  48 +++++---
 mm/memory.c                         | 178 ++++++++++++++++++++--------
 mm/pagewalk.c                       |   5 +
 virt/kvm/kvm_main.c                 |  19 ++-
 21 files changed, 422 insertions(+), 178 deletions(-)

-- 
2.45.0


