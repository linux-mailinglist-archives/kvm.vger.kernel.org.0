Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D4A36242C
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243493AbhDPPmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:02 -0400
Received: from mga12.intel.com ([192.55.52.136]:63662 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235514AbhDPPmB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:01 -0400
IronPort-SDR: qByucoM14H8DwyAFPGwMzh0MQkeoZi9DFopOlw9770N02taZSywMRoMGAmGr/eAfCv3+bicOfI
 Tnf4mo1kSRmw==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="174550435"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="174550435"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:36 -0700
IronPort-SDR: JHSnJpXle56RA6NOpktcidrINTGGvy+pVP+IY3njKrzX6L3ewV0BhUmmbMqeo9bSv6+cmm05xB
 WB9eJa8RjXkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453378435"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2021 08:41:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id C158A12A; Fri, 16 Apr 2021 18:41:49 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 00/13] TDX and guest memory unmapping
Date:   Fri, 16 Apr 2021 18:40:53 +0300
Message-Id: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX integrity check failures may lead to system shutdown host kernel must
not allow any writes to TD-private memory. This requirment clashes with
KVM design: KVM expects the guest memory to be mapped into host userspace
(e.g. QEMU).

This patchset aims to start discussion on how we can approach the issue.

The core of the change is in the last patch. Please see more detailed
description of the issue and proposoal of the solution there.

TODO:
  - THP support
  - Clarify semantics wrt. page cache

v2:
  - Unpoison page on free
  - Authorize access to the page: only the KVM that poisoned the page
    allows to touch it
  - FOLL_ALLOW_POISONED is implemented

The patchset can also be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-poison

Kirill A. Shutemov (13):
  x86/mm: Move force_dma_unencrypted() to common code
  x86/kvm: Introduce KVM memory protection feature
  x86/kvm: Make DMA pages shared
  x86/kvm: Use bounce buffers for KVM memory protection
  x86/kvmclock: Share hvclock memory with the host
  x86/realmode: Share trampoline area if KVM memory protection enabled
  mm: Add hwpoison_entry_to_pfn() and hwpoison_entry_to_page()
  mm/gup: Add FOLL_ALLOW_POISONED
  shmem: Fail shmem_getpage_gfp() on poisoned pages
  mm: Keep page reference for hwpoison entries
  mm: Replace hwpoison entry with present PTE if page got unpoisoned
  KVM: passdown struct kvm to hva_to_pfn_slow()
  KVM: unmap guest memory using poisoned pages

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |   2 +-
 arch/x86/Kconfig                       |   9 +-
 arch/x86/include/asm/cpufeatures.h     |   1 +
 arch/x86/include/asm/io.h              |   4 +-
 arch/x86/include/asm/kvm_para.h        |   5 +
 arch/x86/include/asm/mem_encrypt.h     |   7 +-
 arch/x86/include/uapi/asm/kvm_para.h   |   3 +-
 arch/x86/kernel/kvm.c                  |  19 +++
 arch/x86/kernel/kvmclock.c             |   2 +-
 arch/x86/kernel/pci-swiotlb.c          |   3 +-
 arch/x86/kvm/Kconfig                   |   1 +
 arch/x86/kvm/cpuid.c                   |   3 +-
 arch/x86/kvm/mmu/mmu.c                 |  20 ++-
 arch/x86/kvm/mmu/paging_tmpl.h         |  10 +-
 arch/x86/kvm/x86.c                     |   6 +
 arch/x86/mm/Makefile                   |   2 +
 arch/x86/mm/mem_encrypt.c              |  74 ---------
 arch/x86/mm/mem_encrypt_common.c       |  87 ++++++++++
 arch/x86/mm/pat/set_memory.c           |  10 ++
 arch/x86/realmode/init.c               |   7 +-
 include/linux/kvm_host.h               |  31 +++-
 include/linux/mm.h                     |   1 +
 include/linux/swapops.h                |  20 +++
 include/uapi/linux/kvm_para.h          |   5 +-
 mm/gup.c                               |  29 ++--
 mm/memory.c                            |  44 ++++-
 mm/page_alloc.c                        |   7 +
 mm/rmap.c                              |   2 +-
 mm/shmem.c                             |   7 +
 virt/Makefile                          |   2 +-
 virt/kvm/Kconfig                       |   4 +
 virt/kvm/Makefile                      |   1 +
 virt/kvm/kvm_main.c                    | 212 +++++++++++++++++++------
 virt/kvm/mem_protected.c               | 110 +++++++++++++
 35 files changed, 593 insertions(+), 159 deletions(-)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c
 create mode 100644 virt/kvm/Makefile
 create mode 100644 virt/kvm/mem_protected.c

-- 
2.26.3

