Return-Path: <kvm+bounces-28477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68005998FDC
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFEE4B2510E
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC881A2622;
	Thu, 10 Oct 2024 18:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvAAiL6n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7CD1CCEF0
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584691; cv=none; b=T4CB37MOPLTXVv/XLUbcEUGDcDFfkFM05pkCUFwhyCqfsJrnWFNaRDBiFsFa7VP+y0PdJo9mOo2BOqf7geib3Gbj+Y41mg2N8qKg99LFsD8fd6Tv8dOz9Y2DqCeHV9J+RKCuLudkGq3I3l7ipWJO+N2KLnZ7koQSenEgZ1Us8aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584691; c=relaxed/simple;
	bh=ZiDErZL39SMu+fLJ4hNaeJRSC9FBEv33gGV1Eg3hLco=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Pjn6nxIWD5gKBIInw4FCnnPOrYU5zXXURYf/rK5dU7qOPBHaGGtKD1ivZrbsDDWH1leL/qDMvnJfIONe9yfh7OgFl6Eqwouogk//KiYRHNjFk905sA+2YWwI0A2usBbndTB26RTHCMTqCUcC7UVEVU8oRoZjlrM4uULKQmj6kBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvAAiL6n; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e28d223794so23840337b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584688; x=1729189488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBRfCittAXjccGkBtqBU7H4iPRP62jjV6+4PwlptPDA=;
        b=kvAAiL6nyFcrD3Aji1VZfqICgsoNjAvU/X3Mg26iD4GFV8bMvlgUdYkZ/cBm4fTUdS
         n6tSFKXdw6tZzLKcjxjba58C/nfJZ7QeKNw3LwLtEmps4/ly0Qsw30L042UEUt7J6B4A
         e7IwrYfsPf0ncwsCUYcxzfOwOC4XUXRBFKnzLeG/kDIhAmg0BQZBi7I2XGm+v4AwMVPH
         5v6DlOxN4GOhP+j/fVeWh3RACvDEGb5z0fTdaGMGcfC/Ndn6yu0MKdVw8uvLkARKDbS+
         91iqRhVscdgcaj3TZHg3PyF6+K9TITgNkBpXOmG8X/sJ/pMAsvysj/hXjyg8040UqNDc
         Djzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584688; x=1729189488;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBRfCittAXjccGkBtqBU7H4iPRP62jjV6+4PwlptPDA=;
        b=Bpag5JlqRDHBHMMpYtI866l3WMW7s7Goidbd1ha+g25iCm4Auhue1ug6M1B5s2CZWy
         IXxcPCKFjXscYhrsYxYc9OAHljkhUj5KAtqFJINiwxSAc5HE7q1abpTiTnxZnza7okEK
         2tbZIoIHbO4eJLWjhO3kgT/T9Na23KgbvhBJ+snZjEXkjYq66iBhL0w2VlpR+Z7asxxe
         myZxEzkkQMAh5hFVBvyQ8xy+xbIMNp3qPraaaaH9BD0HcCaqDjTfW1R4dbmShSZlOktq
         t+Y8RhFCLeGnQIFVLye5v7NEo+1ORMRnPIpCdLhc3CNe+URG9qOMcLcE1PNDGnXsbsJD
         QwRg==
X-Gm-Message-State: AOJu0YyK805SGx+ipwcS5vJT6thVjwMPmtg4aSqma4NTRP+9E7poczrS
	1FJvDUauHxG3LTK2Cj4WQ6FdEbaSKI1ahZYVURFXXdjG9UoZaeoMkGlRRcEblADwQs6Ju7hBtYi
	87Q==
X-Google-Smtp-Source: AGHT+IFVWhSyNvZCWHkSlnUyMVGf0mcCDs6zWifUN6uyeZ0ix6vlXwCyyjUyA4S+yzba7AHFzz2C9NUEgCs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3006:b0:6e2:1b8c:39bf with SMTP id
 00721157ae682-6e32213b1b4mr226037b3.2.1728584688198; Thu, 10 Oct 2024
 11:24:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-1-seanjc@google.com>
Subject: [PATCH v13 00/85] KVM: Stop grabbing references to PFNMAP'd pages
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

TL;DR: Eliminate KVM's long-standing (and heinous) behavior of essentially
guessing which pfns are refcounted pages (see kvm_pfn_to_refcounted_page()).

Getting there requires "fixing" arch code that isn't obviously broken.
Specifically, to get rid of kvm_pfn_to_refcounted_page(), KVM needs to
stop marking pages/folios dirty/accessed based solely on the pfn that's
stored in KVM's stage-2 page tables.

Instead of tracking which SPTEs correspond to refcounted pages, simply
remove all of the code that operates on "struct page" based ona the pfn
in stage-2 PTEs.  This is the back ~40-50% of the series.
 
For x86 in particular, which sets accessed/dirty status when that info
would be "lost", e.g. when SPTEs are zapped or KVM clears the dirty flag
in a SPTE, foregoing the updates provides very measurable performance
improvements for related operations.  E.g. when clearing dirty bits as
part of dirty logging, and zapping SPTEs to reconstitue huge pages when
disabling dirty logging.

The front ~40% of the series is cleanups and prep work, and most of it is
x86 focused (purely because x86 added the most special cases, *sigh*).
E.g. several of the inputs to hva_to_pfn() (and it's myriad wrappers),
can be removed by cleaning up and deduplicating x86 code.

v13:
 - Rebased onto v6.12-rc2
 - Collect reviews. [Alex and others]
 - Fix a transient bug in arm64 and RISC-V where KVM would leak a page
   refcount. [Oliver]
 - Fix a dangling comment. [Alex]
 - Drop kvm_lookup_pfn(), as the x86 that "needed" it was stupid and is (was?)
   eliminated in v6.12.
 - Drop check_user_page_hwpoison(). [Paolo]
 - Drop the arm64 MTE fixes that went into 6.12.
 - Slightly redo the guest_memfd interaction to account for 6.12 changes.

v12: https://lore.kernel.org/all/20240726235234.228822-1-seanjc@google.com

David Stevens (3):
  KVM: Replace "async" pointer in gfn=>pfn with "no_wait" and error code
  KVM: Introduce kvm_follow_pfn() to eventually replace "gfn_to_pfn"
    APIs
  KVM: Migrate kvm_vcpu_map() to kvm_follow_pfn()

Sean Christopherson (82):
  KVM: Drop KVM_ERR_PTR_BAD_PAGE and instead return NULL to indicate an
    error
  KVM: Allow calling kvm_release_page_{clean,dirty}() on a NULL page
    pointer
  KVM: Add kvm_release_page_unused() API to put pages that KVM never
    consumes
  KVM: x86/mmu: Skip the "try unsync" path iff the old SPTE was a leaf
    SPTE
  KVM: x86/mmu: Don't overwrite shadow-present MMU SPTEs when
    prefaulting
  KVM: x86/mmu: Invert @can_unsync and renamed to @synchronizing
  KVM: x86/mmu: Mark new SPTE as Accessed when synchronizing existing
    SPTE
  KVM: x86/mmu: Mark folio dirty when creating SPTE, not when
    zapping/modifying
  KVM: x86/mmu: Mark page/folio accessed only when zapping leaf SPTEs
  KVM: x86/mmu: Use gfn_to_page_many_atomic() when prefetching indirect
    PTEs
  KVM: Rename gfn_to_page_many_atomic() to kvm_prefetch_pages()
  KVM: Drop @atomic param from gfn=>pfn and hva=>pfn APIs
  KVM: Annotate that all paths in hva_to_pfn() might sleep
  KVM: Return ERR_SIGPENDING from hva_to_pfn() if GUP returns -EGAIN
  KVM: Drop extra GUP (via check_user_page_hwpoison()) to detect
    poisoned page
  KVM: x86/mmu: Drop kvm_page_fault.hva, i.e. don't track intermediate
    hva
  KVM: Drop unused "hva" pointer from __gfn_to_pfn_memslot()
  KVM: Remove pointless sanity check on @map param to kvm_vcpu_(un)map()
  KVM: Explicitly initialize all fields at the start of kvm_vcpu_map()
  KVM: Use NULL for struct page pointer to indicate mremapped memory
  KVM: nVMX: Rely on kvm_vcpu_unmap() to track validity of eVMCS mapping
  KVM: nVMX: Drop pointless msr_bitmap_map field from struct nested_vmx
  KVM: nVMX: Add helper to put (unmap) vmcs12 pages
  KVM: Use plain "struct page" pointer instead of single-entry array
  KVM: Provide refcounted page as output field in struct kvm_follow_pfn
  KVM: Move kvm_{set,release}_page_{clean,dirty}() helpers up in
    kvm_main.c
  KVM: pfncache: Precisely track refcounted pages
  KVM: Pin (as in FOLL_PIN) pages during kvm_vcpu_map()
  KVM: nVMX: Mark vmcs12's APIC access page dirty when unmapping
  KVM: Pass in write/dirty to kvm_vcpu_map(), not kvm_vcpu_unmap()
  KVM: Get writable mapping for __kvm_vcpu_map() only when necessary
  KVM: Disallow direct access (w/o mmu_notifier) to unpinned pfn by
    default
  KVM: x86: Don't fault-in APIC access page during initial allocation
  KVM: x86/mmu: Add "mmu" prefix fault-in helpers to free up generic
    names
  KVM: x86/mmu: Put direct prefetched pages via kvm_release_page_clean()
  KVM: x86/mmu: Add common helper to handle prefetching SPTEs
  KVM: x86/mmu: Add helper to "finish" handling a guest page fault
  KVM: x86/mmu: Mark pages/folios dirty at the origin of make_spte()
  KVM: Move declarations of memslot accessors up in kvm_host.h
  KVM: Add kvm_faultin_pfn() to specifically service guest page faults
  KVM: x86/mmu: Convert page fault paths to kvm_faultin_pfn()
  KVM: guest_memfd: Pass index, not gfn, to __kvm_gmem_get_pfn()
  KVM: guest_memfd: Provide "struct page" as output from
    kvm_gmem_get_pfn()
  KVM: x86/mmu: Put refcounted pages instead of blindly releasing pfns
  KVM: x86/mmu: Don't mark unused faultin pages as accessed
  KVM: Move x86's API to release a faultin page to common KVM
  KVM: VMX: Hold mmu_lock until page is released when updating APIC
    access page
  KVM: VMX: Use __kvm_faultin_page() to get APIC access page/pfn
  KVM: PPC: e500: Mark "struct page" dirty in kvmppc_e500_shadow_map()
  KVM: PPC: e500: Mark "struct page" pfn accessed before dropping
    mmu_lock
  KVM: PPC: e500: Use __kvm_faultin_pfn() to handle page faults
  KVM: arm64: Mark "struct page" pfns accessed/dirty before dropping
    mmu_lock
  KVM: arm64: Use __kvm_faultin_pfn() to handle memory aborts
  KVM: RISC-V: Mark "struct page" pfns dirty iff a stage-2 PTE is
    installed
  KVM: RISC-V: Mark "struct page" pfns accessed before dropping mmu_lock
  KVM: RISC-V: Use kvm_faultin_pfn() when mapping pfns into the guest
  KVM: PPC: Use __kvm_faultin_pfn() to handle page faults on Book3s HV
  KVM: PPC: Use __kvm_faultin_pfn() to handle page faults on Book3s
    Radix
  KVM: PPC: Drop unused @kvm_ro param from
    kvmppc_book3s_instantiate_page()
  KVM: PPC: Book3S: Mark "struct page" pfns dirty/accessed after
    installing PTE
  KVM: PPC: Use kvm_faultin_pfn() to handle page faults on Book3s PR
  KVM: LoongArch: Mark "struct page" pfns dirty only in "slow" page
    fault path
  KVM: LoongArch: Mark "struct page" pfns accessed only in "slow" page
    fault path
  KVM: LoongArch: Mark "struct page" pfn accessed before dropping
    mmu_lock
  KVM: LoongArch: Use kvm_faultin_pfn() to map pfns into the guest
  KVM: MIPS: Mark "struct page" pfns dirty only in "slow" page fault
    path
  KVM: MIPS: Mark "struct page" pfns accessed only in "slow" page fault
    path
  KVM: MIPS: Mark "struct page" pfns accessed prior to dropping mmu_lock
  KVM: MIPS: Use kvm_faultin_pfn() to map pfns into the guest
  KVM: PPC: Remove extra get_page() to fix page refcount leak
  KVM: PPC: Use kvm_vcpu_map() to map guest memory to patch dcbz
    instructions
  KVM: Convert gfn_to_page() to use kvm_follow_pfn()
  KVM: Add support for read-only usage of gfn_to_page()
  KVM: arm64: Use __gfn_to_page() when copying MTE tags to/from
    userspace
  KVM: PPC: Explicitly require struct page memory for Ultravisor sharing
  KVM: Drop gfn_to_pfn() APIs now that all users are gone
  KVM: s390: Use kvm_release_page_dirty() to unpin "struct page" memory
  KVM: Make kvm_follow_pfn.refcounted_page a required field
  KVM: x86/mmu: Don't mark "struct page" accessed when zapping SPTEs
  KVM: arm64: Don't mark "struct page" accessed when making SPTE young
  KVM: Drop APIs that manipulate "struct page" via pfns
  KVM: Don't grab reference on VM_MIXEDMAP pfns that have a "struct
    page"

 Documentation/virt/kvm/locking.rst     |  80 ++--
 arch/arm64/include/asm/kvm_pgtable.h   |   4 +-
 arch/arm64/kvm/guest.c                 |  21 +-
 arch/arm64/kvm/hyp/pgtable.c           |   7 +-
 arch/arm64/kvm/mmu.c                   |  21 +-
 arch/loongarch/kvm/mmu.c               |  40 +-
 arch/mips/kvm/mmu.c                    |  26 +-
 arch/powerpc/include/asm/kvm_book3s.h  |   4 +-
 arch/powerpc/kvm/book3s.c              |   7 +-
 arch/powerpc/kvm/book3s_32_mmu_host.c  |   7 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c  |  12 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  25 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  35 +-
 arch/powerpc/kvm/book3s_hv_nested.c    |   4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c     |  25 +-
 arch/powerpc/kvm/book3s_pr.c           |  14 +-
 arch/powerpc/kvm/book3s_xive_native.c  |   2 +-
 arch/powerpc/kvm/e500_mmu_host.c       |  19 +-
 arch/riscv/kvm/mmu.c                   |   9 +-
 arch/s390/kvm/vsie.c                   |   4 +-
 arch/x86/kvm/lapic.c                   |  12 -
 arch/x86/kvm/mmu/mmu.c                 | 181 ++++----
 arch/x86/kvm/mmu/mmu_internal.h        |   7 +-
 arch/x86/kvm/mmu/paging_tmpl.h         |  31 +-
 arch/x86/kvm/mmu/spte.c                |  31 +-
 arch/x86/kvm/mmu/spte.h                |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c             |  23 +-
 arch/x86/kvm/svm/nested.c              |   4 +-
 arch/x86/kvm/svm/sev.c                 |  12 +-
 arch/x86/kvm/svm/svm.c                 |   8 +-
 arch/x86/kvm/vmx/nested.c              |  42 +-
 arch/x86/kvm/vmx/vmx.c                 |  28 +-
 arch/x86/kvm/vmx/vmx.h                 |   2 -
 include/linux/kvm_host.h               | 123 +++--
 virt/kvm/guest_memfd.c                 |  28 +-
 virt/kvm/kvm_main.c                    | 602 +++++++++----------------
 virt/kvm/kvm_mm.h                      |  36 +-
 virt/kvm/pfncache.c                    |  20 +-
 38 files changed, 689 insertions(+), 869 deletions(-)


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc1.288.g06298d1525-goog


