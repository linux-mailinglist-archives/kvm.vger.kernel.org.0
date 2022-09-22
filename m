Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3E5E598F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiIVDWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiIVDVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478548E9A6
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 14-20020a63000e000000b00438c0563dc2so4503288pga.9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=vOCd7HxJstUKWJboW0He2GH0i7g9UghEjvAbgHv0/5U=;
        b=ef64lwDYZlVHVsa/eO3B8hrajj20Y7Tykb2icIJTTQczuIKtpCSKvpQbnM16Tsa465
         NrrhZblNBgqp1HMtiF//TwYk7hfAxTZjC0Epgsludcvt6DUF/ZdJVuDI+vTKjxeArzCN
         oChzNYTvrkRYbs6OHZJTHGPIaHrOSluYg/UYMkHsycSVCjdXVUpJ0IBpBt6Q79cElRog
         kK+pzCxqWfAd3betqgiCcmwIir6vgOdouo53BfUCTECs8eH8dUqTXdNQdfjsZD/vKVw5
         l8pMIrUddHHCcEiub0ZsFa1GDp8EYxrkf2i7yNisDvU3v1MTBZdCJdvg1K2cPYMTMYfo
         GaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=vOCd7HxJstUKWJboW0He2GH0i7g9UghEjvAbgHv0/5U=;
        b=lEt51PXDcpNI2GIydtVU5NzvAq6TKRa9oea76SJOPO/s1NVhCcf5+H7wWqqblu0Ptd
         g+5a9LfNqG3QmISNja6r9FUCSgU6IrMMQPCh4ujPPJxAozynNQsvLc+juhsF3nJtZTCm
         /KHw2Yz5302XLA3XGFjJeHX6FOj0Ewi5rIgfX5JtFRV3Z4xZsyn/Cn6seuJDs13EDZtc
         BftDaWPr9o3jpyMbURHrEAyJociXQrkpQzwhbUemHmZC6LGLCkeLNT6nfxw6umBd4HUr
         J+t1RXK7T0eVnLwTRbeUg2h8JyLyW+S3QbAFYX1HcXKLuUNNDTiWn01J/mLDUffNxM0y
         09Ag==
X-Gm-Message-State: ACrzQf2R2DwiqQL4+ztKYdbtgUZkoGZrAQuBa0QLq10OWXm8L4XVlICW
        olj9mq/FX7LtIsO1z9nM2PwJOWMs1XPKUc8n/IxwkYBWjbB737BJtlrCnOv17KYYUjxsPKwiVOG
        ZDbWry24UDQpXGyMd17lsDQrfKjCtjy+GK5Z0FPC3kSHwKmmzdkKYo5+lXhndYLY=
X-Google-Smtp-Source: AMsMyM4GEqUiMmywFHcBtxS7fOoy8JrHLHNECwGDQrSvlboxGqxe3BGcuQGijWp60npZ5/FnnHVaQJoPma3zEA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:2b0c:b0:203:b7b1:2ba2 with SMTP
 id x12-20020a17090a2b0c00b00203b7b12ba2mr1467090pjc.34.1663816739618; Wed, 21
 Sep 2022 20:18:59 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-1-ricarkol@google.com>
Subject: [PATCH v8 00/14] KVM: selftests: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds a new aarch64 selftest for testing stage 2 fault handling
for various combinations of guest accesses (e.g., write, S1PTW), backing
sources (e.g., anon), and types of faults (e.g., read on hugetlbfs with a
hole, write on a readonly memslot). Each test tries a different combination
and then checks that the access results in the right behavior (e.g., uffd
faults with the right address and write/read flag). Some interesting
combinations are:

- loading an instruction leads to a stage 1 page-table-walk that misses on
  stage 2 because the backing memslot for the page table it not in host
  memory (a hole was punched right there) and the fault is handled using
  userfaultfd.  The expected behavior is that this leads to a userfaultfd
  fault marked as a write. See commit c4ad98e4b72c ("KVM: arm64: Assume
  write fault on S1PTW permission fault on instruction fetch") for why
  that's a write.
- a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu
  run.
- write-faulting on a memslot that's marked for userfaultfd handling and
  dirty logging should result in a uffd fault and having the respective bit
  set in the dirty log.

The first 8 commits of this series add library support. The first one adds
a new userfaultfd library. Commits 2-5 add some misc library changes that
will be used by the new test, like a library function to get the GPA of a
PTE.  Commits 6-8 breaks the implicit assumption that code and page tables
live in memslot memslots should allocators use. This is then used by the
new test to place the page tables in a specific memslot.  The last 5
commits add the new selftest, one type of test at a time. It first adds
core tests, then uffd, then dirty logging, then readonly memslots tests,
and finally combinations of the previous ones (like uffd and dirty logging
at the same time).

v7 -> v8: https://lore.kernel.org/kvmarm/20220920042551.3154283-1-ricarkol@google.com/
- applied Sean's suggestion of adding a fourth region: DATA, and renamed
  the old DATA one to DATA_TEST. [Sean]
- removed some unneeded code in page_fault_test.c. [Andrew]
- removed r-b's from Andrew and Oliver in commit "KVM: selftests: Use the
  right memslot for code, page-tables, and data allocations", as the commit
  changed quite a bit (again). Thanks for the reviews! would it have been OK
  to keep it? not sure how strict we all are about collecting r-b's on a
  commit that changed.

v6 -> v7: https://lore.kernel.org/kvmarm/Yyi03sX5hx36M%2FZr@google.com/
- removed struct kvm_vm_mem_params. Changed page_fault_test.c accordingly. [Sean]
- applied Oliver's patch to fix page_fault_test compilation warnings. [Oliver]
- added R-b's from Oliver and Andrew. Didn't Andrew's R-b on 6/13 as the
  commit changed afterwards.

v5 -> v6: https://lore.kernel.org/kvmarm/20220823234727.621535-1-ricarkol@google.com/
- added "enum memslot_type" and all the related cleanups due to it [Andrew]
- default kvm_vm_mem_default with size=0 [Andrew,Sean]
- __vm_vaddr_alloc() taking "enum memslot_type" and all the related
  cleanups due to this change [Andrew]

v4 -> v5: https://lore.kernel.org/kvmarm/20220624213257.1504783-1-ricarkol@google.com/
- biggest change: followed suggestion from Sean and Andrew regarding a new
  arg for vm_create() to specify the guest memory layout. That's taken care
  of with these two new commits: KVM: selftests: Use the right memslot for
  code, page-tables, and data allocations KVM: selftests: Change
  ____vm_create() to take struct kvm_vm_mem_params plus the respective
  changes in the page_fault_test itself (mostly code reduction).
- dropped some commits that are not needed after the above change:
	KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
	KVM: selftests: Add vm_alloc_page_table_in_memslot library function
	KVM: selftests: Add vm_mem_region_get_src_fd library function
- addressed Oliver comments in commit "KVM: selftests: aarch64: Add
  aarch64/page_fault_test"
- collect r-b's from Andrew

Ricardo Koller (14):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add virt_get_pte_hva() library function
  KVM: selftests: Add missing close and munmap in
    __vm_mem_region_delete()
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: Stash backing_src_type in struct userspace_mem_region
  KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
  KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and
    vm_vaddr_alloc()
  KVM: selftests: Use the right memslot for code, page-tables, and data
    allocations
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    2 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 1110 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   31 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   45 +
 .../selftests/kvm/lib/aarch64/processor.c     |   48 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   82 +-
 .../selftests/kvm/lib/riscv/processor.c       |   29 +-
 .../selftests/kvm/lib/s390x/processor.c       |    8 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  186 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 15 files changed, 1721 insertions(+), 276 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.3.968.ga6b4b080e4-goog

