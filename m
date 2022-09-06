Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59705AF348
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIFSJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIFSJg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A641DA4E
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 62-20020a250341000000b006a93b57e2daso3787981ybd.2
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=osvdecwQ9TbqCzgSDLR+EUy4Gafe3dmIEyoN8ruQZ88=;
        b=BZNrcgHO1hAhAvCC0zMJWsaZ5V6+BkJKYqVqbbaBG2vyyU3XAu3LDHflIvmCrB3UI9
         ARVO7VgEfvkv4fMfmdPDR7KzNR08pzC/kLIIKqXl+w7RBJQETiGR/C5YJxEGunViqenr
         o6/yofAFeZh2CRSiRiUuRlY/XusUjg/aj4P1PSNfezsOoePVvVrGHQW7gFqJK2U+ss77
         hWRCcVH9X9+YxZwDFKal+DNtRvtDpyBiD/TJpZrg6ZkMTG/gy4Ry6ZVzR8IPZu6w9XvT
         xBR0x6chEh5gRyhetpAkMS8X32+33AUZfYqNNeSxlv/kHAwc8fzUSBX59UaWWU/SPHvR
         h2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=osvdecwQ9TbqCzgSDLR+EUy4Gafe3dmIEyoN8ruQZ88=;
        b=cGTQk5OeMQwRkE0OnaLhBKa0hGqwduYdvClDFfMGSF7kNwR57J02aAr7jum6AjsPbY
         Rka/PH+HXKLaztwRdBuFx4sPj3JHl7Zv19joZeXIPea/kXVcPXGtASZ5CnCs80LHezRW
         uT/IISqNXuJL8mWNW63bLuRSQppc8wPqryTVYSsOu1y4a8qryWZVnmuIczvJ5SA7KYoT
         4Hifg5JP/EquyjuHQFORqdXqUfelEvh9UvFi2BikVFnjQn5kub+Xg+CVsyJ3f2LHLf+5
         N0Ov8kjZtBpKjZ+UafX9oKVWXxBW6qjc5lX/m9Rx81pdgTrOe8ER93cPHXg/c+HNrSdx
         YRmA==
X-Gm-Message-State: ACgBeo2q5ARXpskuAxVoCeb4R1OE6hoUEKN4ZtFV1gzrq2QQKDSEXPkx
        sl+fXdZIhUZ9rYeT3O9WV3ASpvQvm+GXcDFoqE1z1qK/zqs/Ikc7wmRcZpbRbEr2FqjAp2Tc9Ku
        5qLmO8nfFLyeopXM5wceZ4XROdNciIPK4IpynqokbghMt1rFKi2nAAAqbDAOkhGU=
X-Google-Smtp-Source: AA6agR6Yv6niZAAVaz/9aFt/3aqdoAVqOvLOHKsxKdW94fEiNqvcR3RYS7oC8IBgFz//r31loHO6v8LqrCbsbg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7382:0:b0:328:306f:26d2 with SMTP id
 o124-20020a817382000000b00328306f26d2mr44190014ywc.486.1662487774120; Tue, 06
 Sep 2022 11:09:34 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-1-ricarkol@google.com>
Subject: [PATCH v6 00/13] KVM: selftests: Add aarch64/page_fault_test
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds a new aarch64 selftest for testing stage 2 fault handling for
various combinations of guest accesses (e.g., write, S1PTW), backing sources
(e.g., anon), and types of faults (e.g., read on hugetlbfs with a hole, write
on a readonly memslot). Each test tries a different combination and then checks
that the access results in the right behavior (e.g., uffd faults with the right
address and write/read flag). Some interesting combinations are:

- loading an instruction leads to a stage 1 page-table-walk that misses on
  stage 2 because the backing memslot for the page table it not in host memory
  (a hole was punched right there) and the fault is handled using userfaultfd.
  The expected behavior is that this leads to a userfaultfd fault marked as a
  write. See commit c4ad98e4b72c ("KVM: arm64: Assume write fault on S1PTW
  permission fault on instruction fetch") for why that's a write.
- a cas (compare-and-swap) on a readonly memslot leads to a failed vcpu run.
- write-faulting on a memslot that's marked for userfaultfd handling and dirty
  logging should result in a uffd fault and having the respective bit set in
  the dirty log.

The first 8 commits of this series add library support. The first one adds a
new userfaultfd library (out of demand_paging_test.c). The next 3 add some
library functions to get the GPA of a PTE, and to get the fd of a backing
source. Commit 6 fixes a leaked fd when using shared backing stores. The last 5
commits add the new selftest, one type of test at a time. It first adds core
tests, then uffd, then dirty logging, then readonly memslots tests, and finally
combinations of the previous ones (like uffd and dirty logging at the same
time).

v5 -> v6: https://lore.kernel.org/kvmarm/20220823234727.621535-1-ricarkol@google.com/
- added "enum memslot_type" and all the related cleanups due to it [Andrew]
- default kvm_vm_mem_default with size=0 [Andrew,Sean]
- __vm_vaddr_alloc() taking "enum memslot_type" and all the related cleanups
  due to this change [Andrew]

v4 -> v5: https://lore.kernel.org/kvmarm/20220624213257.1504783-1-ricarkol@google.com/
- biggest change: followed suggestion from Sean and Andrew regarding a new
  arg for vm_create() to specify the guest memory layout. That's taken care
  of with these two new commits:
	KVM: selftests: Use the right memslot for code, page-tables, and data allocations
	KVM: selftests: Change ____vm_create() to take struct kvm_vm_mem_params
  plus the respective changes in the page_fault_test itself (mostly code reduction).
- dropped some commits that are not needed after the above change:
	KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
	KVM: selftests: Add vm_alloc_page_table_in_memslot library function
	KVM: selftests: Add vm_mem_region_get_src_fd library function
- addressed Oliver comments in commit "KVM: selftests: aarch64: Add
  aarch64/page_fault_test"
- collect r-b's from Andrew

v3 -> v4: https://lore.kernel.org/kvmarm/20220408004120.1969099-1-ricarkol@google.com/
- rebased on top of latest kvm/queue.
- addressed Oliver comments: vm_get_pte_gpa rename, page_fault_test and
  other nits.
- adding MAIR entry for MT_DEVICE_nGnRnE. The value and indices are both
  0, so the change is really esthetic.

Ricardo Koller (13):
  KVM: selftests: Add a userfaultfd library
  KVM: selftests: aarch64: Add virt_get_pte_hva() library function
  KVM: selftests: Add missing close and munmap in
    __vm_mem_region_delete()
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: Stash backing_src_type in struct userspace_mem_region
  KVM: selftests: Change ____vm_create() to take struct
    kvm_vm_mem_params
  KVM: selftests: Use the right memslot for code, page-tables, and data
    allocations
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/Makefile          |    2 +
 .../selftests/kvm/aarch64/page_fault_test.c   | 1137 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   55 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   29 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  122 +-
 .../selftests/kvm/lib/riscv/processor.c       |    7 +-
 .../selftests/kvm/lib/s390x/processor.c       |    7 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 14 files changed, 1789 insertions(+), 258 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.2.789.g6183377224-goog

