Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6FE4F8B58
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiDHAnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiDHAn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:27 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF301786BD
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d5-20020a62f805000000b0050566b4f4c0so2011575pfh.11
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E6xF7BRmUXfmciuEZaesrs494yfp8aq+3UzXCgkaDGg=;
        b=eA/KbHhnaC2JgbW/IRh9sTbQJ9whQYQpJxPZuP+GG43bo4xQFfCzjaMHN6RMZidDE0
         19HiC3vHvubzv0C4BtXxIibUeQ+9Z1in7BaYiRACc6oCuCT2hmlKboWSYZotkelmLKIz
         EsKDGE3//xlkWUfKwg6rziwQrmMiFwAR9yF43Q671xGzCIBRS3dnBHJ2NLF7JSTnQB8O
         YvwJMkTS8qwyy/4htcZRNIDRNubMAoR2yYxSSuu3eXEx/NSILgEoy+UwGJKpHmIXUiLV
         kUTXw5t5VNs21yoJPiDoSK/wyL6bDwDp2i4qd120iTW6kL2cv/OT6BXiqLXYfEDcBbE1
         nEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E6xF7BRmUXfmciuEZaesrs494yfp8aq+3UzXCgkaDGg=;
        b=Z27aGIcLi5mSnouBaSwVMQQ9dLQT+/OWvJMpBH/UG3RXI7J76GVV0vA3LIdwyylw0V
         B1bSUhPnUQbeN/OcJ78RlrGsUSABjGX5f82pz7sRHqaomb6PgB5Rvj1acmG3Co5qxTju
         XjwIsg8WN0OKsunxi6v7gKAnbE+GAIh/ZUEdxGWSXo9qtUaX8exNjCXeXFQye0whollE
         jUzH/N2/6G3/OPRbGaKAMOl8AjusJwnE8kYTxjbSpKx4eEJOHo2ef65z/gZWpjmvrcsr
         Zq1fNnBddM5evdwrcRQiCHA0eljmbuzLKp5bhoIea1lEtsPxmv78CeNNdv/lHD5qulR9
         tMOg==
X-Gm-Message-State: AOAM531cU7JcJvC6Q3CQBThfRLqKJWgCTea8+Gfp1GAG1RifX6GuT7g1
        phzYuc4HPV9j+C+Z0cqqiscNiPqVHnttrCT+fikGiiUd2DtYehw/KMxCvf7A2SXzR70pqv3p4dM
        aw9d9x7i6s705eWTJDQMZ4UukEuHZm8ly4yo3L6imIBPo5GH0GeS8LVaU2MrgIHk=
X-Google-Smtp-Source: ABdhPJwWcruWcjxHeX/1C8HwzP9BtdmvN7zU4n1HoFXjhRxc3q5cTBsOGvgA1laxGF7esXseCoeg0vlHvhRwrA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:3b4c:b0:1c6:d9f0:77b8 with SMTP
 id ot12-20020a17090b3b4c00b001c6d9f077b8mr18664455pjb.124.1649378483039; Thu,
 07 Apr 2022 17:41:23 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:07 -0700
Message-Id: <20220408004120.1969099-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 00/13] KVM: selftests: Add aarch64/page_fault_test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
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
  KVM: selftests: aarch64: Add vm_get_pte_gpa library function
  KVM: selftests: Add vm_alloc_page_table_in_memslot library function
  KVM: selftests: aarch64: Export _virt_pg_map with a pt_memslot arg
  KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
  KVM: selftests: Add vm_mem_region_get_src_fd library function
  KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h
    macros
  tools: Copy bitfield.h from the kernel sources
  KVM: selftests: aarch64: Add aarch64/page_fault_test
  KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
  KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
  KVM: selftests: aarch64: Add readonly memslot tests into
    page_fault_test
  KVM: selftests: aarch64: Add mix of tests into page_fault_test

 tools/include/linux/bitfield.h                |  176 +++
 tools/testing/selftests/kvm/Makefile          |    3 +-
 .../selftests/kvm/aarch64/page_fault_test.c   | 1255 +++++++++++++++++
 .../selftests/kvm/demand_paging_test.c        |  227 +--
 .../selftests/kvm/include/aarch64/processor.h |   35 +-
 .../selftests/kvm/include/kvm_util_base.h     |    2 +
 .../selftests/kvm/include/userfaultfd_util.h  |   47 +
 .../selftests/kvm/lib/aarch64/processor.c     |   38 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   37 +-
 .../selftests/kvm/lib/userfaultfd_util.c      |  187 +++
 10 files changed, 1792 insertions(+), 215 deletions(-)
 create mode 100644 tools/include/linux/bitfield.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
 create mode 100644 tools/testing/selftests/kvm/include/userfaultfd_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/userfaultfd_util.c

-- 
2.35.1.1178.g4f1659d476-goog

