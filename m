Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406F9799231
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343700AbjIHW3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbjIHW3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:29:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9B31FC6
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7ea5814674so2509022276.1
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212188; x=1694816988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+mRD5R0g+3C4eFyIJeU86inpLRRH1F8aUW/T/MJ4xk0=;
        b=unA951IYdxkUBb76jwUVjkRobdtu2fHsUU8gc+fMQHdA3Z/uPZmQ0SqwvIUCKRoum8
         grUrx6PKqOUXVNNETU+dY09Z7peNXBINAMNlzUxSTo6GkGD7Kvf19iob010uzYjLFyxD
         UUre4qMDQaYNAKmwz9gOhqVgZC6ir8cGH3UFIPm6A7G/gJ6NIq7Sfl31jzShYZzv9KWH
         yk3W7gXrtm8GVPdkgjSgbHFJDB8vUxy0xhX47QFogBEr2/zIZmNZ1gXGApitjozevtKa
         /MJQJciSGrb395nBer6giEEOmbG3paFpWxJ/Km9s0cYGcEJVW9q7VaAe+BgPczsxXXVe
         VNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212188; x=1694816988;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+mRD5R0g+3C4eFyIJeU86inpLRRH1F8aUW/T/MJ4xk0=;
        b=WlPmyhjPj/TEMQHlI3An6LqXnEwnFmZV7XSAV3vBmMPsS/fqnLx11do7L4dfom4GPP
         xr+r5Kvi7IOgbcCNmQzD2gA1hzo6/EuC9Q7OsmMvoq+GnnuVhmywBvyB9TntwuC2i4VU
         gPDuWhy+4cFTMt3t0LMWD7j80zc4Kyrey1Z6IclfW07x1McDQhZTj+oeT8Ld9bLKEpQH
         Z+YzmqKhNjk6zFrMhR9aQJNWAbPcDgjcj6NVhHXOTvSFV8GsW8Rc1gygrGu/fx3TbqjH
         U1NoVqS2yhDQOE0kCcg5FH80HqpDGraElPux5oW1XvKw5kZas+htmKzvi1syNYyxfhPx
         2EtA==
X-Gm-Message-State: AOJu0YxI7ZEw0LzVRuqY+giCoYMwzzxsmNFCM+zOMNQlYU021osqX6KK
        AOoTGAKDrODVB27551DidWTiofKMNg13jA==
X-Google-Smtp-Source: AGHT+IHmsxaY3bkuY8VBzYpFB/Q8l2vMvWvc+aSfV3MyKlmDY5wUsQbKQrNZr6Y4Ly2m8H8ylcs04PpFQ8MwEw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:5083:0:b0:d7b:9d44:7578 with SMTP id
 e125-20020a255083000000b00d7b9d447578mr77991ybb.12.1694212188120; Fri, 08 Sep
 2023 15:29:48 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-1-amoorthy@google.com>
Subject: [PATCH v5 00/17] Improve KVM + userfaultfd live migration via
 annotated memory faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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

This series improves the scalability of KVM and userfaultfd migration by
actually providing a mechanism to *bypass* userfaultfd while handling
stage 2 page table violations. A more complete description of the
problem is provided in the cover letter for v4 (linked below).

Major changes in v5
~~~~~~~~~~~~~~~~~~~
* A new union is added to the run struct to store memory fault
  annotations. This resolves the concerns I brought up (see the
  "Important Note") in the cover letter of v4.
* Querying the new memslot flag is moved out of x86/arm64 code and into
  __gfn_to_pfn_memslot() itself.

Outstanding Issues/Details
~~~~~~~~~~~~~~~~~~~~~~~~~~
The two commits for introducing/implementing
KVM_CAP_USERFAULT_ON_MISSING will/should probably generate the most
discussion on this version.

Also, a question: in the user_mem_abort() annotation, should the
annotations be aligned to PAGE_SIZE rather than vma_pagesize?

Base Commit
~~~~~~~~~~~
This series is based off of kvm/next (d011151616e7)

Links/Notes
~~~~~~~~~~~
[1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables the new capabilities.
    All data was collected after applying the entire series
[3] https://lore.kernel.org/kvm/ZBTgnjXJvR8jtc4i@google.com/
[4] https://lore.kernel.org/kvm/ZHkfDCItA8HUxOG1@linux.dev/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf
[5] https://lore.kernel.org/kvm/168556721574.515120.10821482819846567909.b4-ty@google.com/T/#t

---

v5
  - Rename APIs (again) [Sean]
  - Initialize hardware_exit_reason along w/ exit_reason on x86 [Isaku]
  - Reword hva_to_pfn_fast() change commit message [Sean]
  - Correct style on terminal if statements [Sean]
  - Switch to kconfig to signal KVM_CAP_USERFAULT_ON_MISSING [Sean]
  - Add read fault flag for annotated faults [Sean]
  - read/write_guest_page() changes
      - Move the annotations into vcpu wrapper fns [Sean]
      - Reorder parameters [Robert]
  - Rename kvm_populate_efault_info() to
    kvm_handle_guest_uaccess_fault() [Sean]
  - Remove unnecessary EINVAL on trying to enable memory fault info cap [Sean]
  - Correct description of the faults which hva_to_pfn_fast() can now
    resolve [Sean]
  - Eliminate unnecessary parameter added to __kvm_faultin_pfn() [Sean]
  - Magnanimously accept Sean's rewrite of the handle_error_pfn()
    annotation [Anish]
  - Remove vcpu null check from kvm_handle_guest_uaccess_fault [Sean]

v4: https://lore.kernel.org/kvm/20230602161921.208564-1-amoorthy@google.com/T/#t
  - Fix excessive indentation [Robert, Oliver]
  - Calculate final stats when uffd handler fn returns an error [Robert]
  - Remove redundant info from uffd_desc [Robert]
  - Fix various commit message typos [Robert]
  - Add comment about suppressed EEXISTs in selftest [Robert]
  - Add exit_reasons_known definition for KVM_EXIT_MEMORY_FAULT [Robert]
  - Fix some include/logic issues in self test [Robert]
  - Rename no-slow-gup cap to KVM_CAP_NOWAIT_ON_FAULT [Oliver, Sean]
  - Make KVM_CAP_MEMORY_FAULT_INFO informational-only [Oliver, Sean]
  - Drop most of the annotations from v3: see
    https://lore.kernel.org/kvm/20230412213510.1220557-1-amoorthy@google.com/T/#mfe28e6a5015b7cd8c5ea1c351b0ca194aeb33daf
  - Remove WARN on bare efaults [Sean, Oliver]
  - Eliminate unnecessary UFFDIO_WAKE call from self test [James]

v3: https://lore.kernel.org/kvm/ZEBXi5tZZNxA+jRs@x1n/T/#t
  - Rework the implementation to be based on two orthogonal
    capabilities (KVM_CAP_MEMORY_FAULT_INFO and
    KVM_CAP_NOWAIT_ON_FAULT) [Sean, Oliver]
  - Change return code of kvm_populate_efault_info [Isaku]
  - Use kvm_populate_efault_info from arm code [Oliver]

v2: https://lore.kernel.org/kvm/20230315021738.1151386-1-amoorthy@google.com/

    This was a bit of a misfire, as I sent my WIP series on the mailing
    list but was just targeting Sean for some feedback. Oliver Upton and
    Isaku Yamahata ended up discovering the series and giving me some
    feedback anyways, so thanks to them :) In the end, there was enough
    discussion to justify retroactively labeling it as v2, even with the
    limited cc list.

  - Introduce KVM_CAP_X86_MEMORY_FAULT_EXIT.
  - API changes:
        - Gate KVM_CAP_MEMORY_FAULT_NOWAIT behind
          KVM_CAP_x86_MEMORY_FAULT_EXIT (on x86 only: arm has no such
          requirement).
        - Switched to memslot flag
  - Take Oliver's simplification to the "allow fast gup for readable
    faults" logic.
  - Slightly redefine the return code of user_mem_abort.
  - Fix documentation errors brought up by Marc
  - Reword commit messages in imperative mood

v1: https://lore.kernel.org/kvm/20230215011614.725983-1-amoorthy@google.com/

Anish Moorthy (17):
  KVM: Clarify documentation of hva_to_pfn()'s 'atomic' parameter
  KVM: Add docstrings to __kvm_read/write_guest_page()
  KVM: Simplify error handling in __gfn_to_pfn_memslot()
  KVM: Add KVM_CAP_MEMORY_FAULT_INFO
  KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page()
  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
  KVM: arm64: Annotate -EFAULT from user_mem_abort()
  KVM: Allow hva_pfn_fast() to resolve read faults
  KVM: Introduce KVM_CAP_USERFAULT_ON_MISSING without implementation
  KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by atomizing
    __gfn_to_pfn_memslot() calls
  KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
  KVM: arm64: Enable KVM_CAP_USERFAULT_ON_MISSING
  KVM: selftests: Report per-vcpu demand paging rate from demand paging
    test
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  77 ++++-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          |  17 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |   3 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   3 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |  21 +-
 include/linux/kvm_host.h                      |  58 +++-
 include/uapi/linux/kvm.h                      |  36 +++
 tools/include/uapi/linux/kvm.h                |  25 ++
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 295 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 .../x86_64/dirty_log_page_splitting_test.c    |   2 +-
 virt/kvm/Kconfig                              |   3 +
 virt/kvm/kvm_main.c                           |  83 +++--
 22 files changed, 633 insertions(+), 184 deletions(-)

-- 
2.42.0.283.g2d96d420d3-goog

