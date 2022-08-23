Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C6259EFF4
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiHWXre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 19:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiHWXrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 19:47:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0C08A7C7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:31 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33580e26058so263444657b3.4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 16:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=lI8RVWeGiy/V5ixpWNIycXsB5AxR7O8H8gTuNCP1X3Y=;
        b=Z/MYPuRIYLWOvU+H5Y/4TJkXS3p4QothM/xmo7VtKPYYs4Ah+erSdsyShoPZlJyfJN
         toHS+uotvqskkWRJ2OcNF2p/gkUx79zmGf1LZ+1E7RVLE061+4NJmCDVFLHmZix4j6t4
         /7odh6OD7df9R4lo355CzWgtijXfaNiX9b8/EO16by1LXTYbR936gkJPsqaI+40t/qM8
         oVfIOHdf0JLU9K1PZaH8IwxVHlYG6+emhRIjOjHTYKZQ04WfVquri/v+JoJGzDl7j5MJ
         xZPUDO+afV1cFOB6z6DHOTm/p77wBkzXQPW+8kK5Hlotqi1/RKXoMzxV2g+10tQUoYxS
         dJ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=lI8RVWeGiy/V5ixpWNIycXsB5AxR7O8H8gTuNCP1X3Y=;
        b=XV4rnMmdjwFkP5WeKdRypoZSj3YIcKImwYaRG3/8Dhc0vKE5kjsXwMiqb7FCM0cGPI
         itDyRZxOSpPu8343iHoX4E27g9r051cTAH42SZW1v8mScSiHuJFb81r5ZJYXbEQNY1Iq
         H6+3uTONliB07i4yvuceQArVP6Re+MhZqPYWYYxw8X2tfNfoUdYn5dl7hatU4lbNJ1IN
         h5zsDBsGK5JeSPntHXLvdx8vKZsMQ6ym2oo2edkaADuFWc8o2wkfW74n95Qgf17r0FRd
         YRNeh/9/5hwH1t4hbl67K/wNhh0Mv444smvd857Z5ZPdfU2MX9oBhcj8sURJ05o9Pq8K
         WMmg==
X-Gm-Message-State: ACgBeo3ZCBog1ZnJN4z6A0zoFrb9/NYarySpmAx2P0+i9ery6wlBh1iw
        UkF83Uo1bMY9cpAoE6v63RpOVfNO0iNOjcTPr7/mNL7xTHJJpKpqo4CDgUqNgGUYPOoPh04fbG0
        yAbVQ4aem2fnIDEQ7Bf0ZytX0MbH+4bAEFE6lurp3zSln0wBgjp+wrOBOxjTc+4E=
X-Google-Smtp-Source: AA6agR7FEUM+UiCqKmbZaKSVuJLapiaSgSGc2xyg1kI5PP9P/z6BPcYx3aCDwK5KuIg5SonqG5GdhaofPEYMIg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7183:0:b0:31f:63f4:1743 with SMTP id
 m125-20020a817183000000b0031f63f41743mr28768685ywc.176.1661298450536; Tue, 23
 Aug 2022 16:47:30 -0700 (PDT)
Date:   Tue, 23 Aug 2022 23:47:14 +0000
Message-Id: <20220823234727.621535-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 00/13] KVM: selftests: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatclack@google.com, axelrasmussen@google.com,
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
- allocating less memory for the test (smaller memslots).
- better comments, including an ascii diagram about how memory is laid out
  for the test.

v2 -> v3:
Thank you very much Oliver and Ben
- collected r-b's from Ben. [Ben]
- moved some defitions (like TCR_EL1_HA) to common headers. [Oliver]
- use FIELD_GET and ARM64_FEATURE_MASK. [Oliver]
- put test data in a macro. [Oliver]
- check for DCZID_EL1.DZP=0b0 before using "dc zva". [Oliver]
- various new comments. [Oliver]
- use 'asm' instead of hand assembly. [Oliver]
- don't copy test descriptors into the guest. [Oliver]
- rename large_page_size into backing_page_size. [Oliver]
- add enumeration for memory types (4 is MT_NORMAL). [Oliver]
- refactored the test macro definitions.

v1 -> v2: https://lore.kernel.org/kvmarm/20220323225405.267155-1-ricarkol@google.com/
- collect r-b from Ben for the memslot lib commit. [Ben]
- move userfaultfd desc struct to header. [Ben]
- move commit "KVM: selftests: Add vm_mem_region_get_src_fd library function"
  to right before it's used. [Ben]
- nit: wrong indentation in patch 6. [Ben]

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
 .../selftests/kvm/aarch64/page_fault_test.c   | 1132 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  228 +---
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |   65 +-
 .../selftests/kvm/include/userfaultfd_util.h  |   46 +
 .../selftests/kvm/lib/aarch64/processor.c     |   29 +-
 tools/testing/selftests/kvm/lib/elf.c         |    3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  129 +-
 .../selftests/kvm/lib/riscv/processor.c       |    7 +-
 .../selftests/kvm/lib/s390x/processor.c       |    7 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 .../selftests/kvm/lib/x86_64/processor.c      |   13 +-
 14 files changed, 1801 insertions(+), 258 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.37.1.595.g718a3a8f04-goog

