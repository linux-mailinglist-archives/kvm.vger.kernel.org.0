Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324376E00F3
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDLVfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLVfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE7C7A85
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54f69fb5cafso71983727b3.12
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335315; x=1683927315;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MEHMIaN+CjvT3NOB98sOvS+cCj2L9OMIJTblslenw6o=;
        b=OW68UtvL6QVecVpXo8gdhAakChrF4onyj5YaYg8Dbd9jaRuc8F10sw4k/ziHUIm4fr
         orQJ7SA8dC4Ki+r7H4TX5eVlQNPEdTjpiwdEwA1lUEum8NWexm3C/6bim7XFF9+5GO1T
         L0RhSSunc4Wpg1WbTnR/cZ25ZxUsB4svJc94LGGGtaER5vXiU+gg9QVWPIWxaltCegcM
         LfjfaJZJMVzfh8yBbZK8+dEq/ew1BA66F9iLC0A+/JO20051ZQ4Zn379u2DxvKil3bkC
         qpePjiQfd01G8jTdxGmKKI4VC/Pxza1C/D68Uz0rOrRsktTtNImgFb4FuGCFNRv7P1gf
         YwOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335315; x=1683927315;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MEHMIaN+CjvT3NOB98sOvS+cCj2L9OMIJTblslenw6o=;
        b=aWGFPp2F273YrNcAwRwYVjjDz/VhMV1Mx6PVYAkAnae0f5zbKV7TIaMewdU29xX0L5
         MxZL+b/Mocihrdq0twJ7ngqk+hEi1WqrWkHhtyQV0IcYoV5rumvpbHY1o0HF31XfLihw
         /ANNSvUxn8OHEnL23wIV01gS3UAmoPjlnyqA6uy5br7Qr3Tsu8VZOP+Zq3g/DH5RINF2
         agvS+IcWUpQ0KWA+ORGXrT3b530sRosfijElYKA/sSlwp3nB0Ez+z5yfoU1UkLJy8nam
         LUughA2qH7iA5JtcmVFrCzztkKrAinx/AiRzsOjUln4pp8Jvf5OmHgpkWSFrreOcX6mh
         3OYg==
X-Gm-Message-State: AAQBX9eb6NiuZ2YiOqku+DywtZcRhWv8RwWsImpiryIlH8zK/5cERFd2
        x/AXpQ8zUctyV1Fxc9M70ECheDZxU1X3dA==
X-Google-Smtp-Source: AKy350bkWlSXqypOsDQuqrGi0hmoin7r8Nd8gxJNleXJBXC/gmDI513qyLrz86YoD4pvFUuQ3Zg9plOmvxUBsw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:d7d3:0:b0:b68:7a4a:5258 with SMTP id
 o202-20020a25d7d3000000b00b687a4a5258mr21996ybg.3.1681335315074; Wed, 12 Apr
 2023 14:35:15 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:34:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-1-amoorthy@google.com>
Subject: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
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

Due to serialization on internal wait queues, userfaultfd can be quite
slow at delivering faults to userspace when many vCPUs fault on the same
VMA/uffd: this problem only worsens as the number of vCPUs increases.
This series allows page faults encountered in KVM_RUN to bypass
userfaultfd (KVM_CAP_ABSENT_MAPPING_FAULT) and be delivered directly via
VM exit to the faulting vCPU (KVM_CAP_MEMORY_FAULT_INFO), allowing much
higher page-in rates during uffd-based postcopy.

As a first step, KVM_CAP_MEMORY_FAULT_INFO is introduced. This
capability is meant to deliver useful information to userspace (i.e. the
problematic range of guest physical memory) when a vCPU fails a guest
memory access. KVM_RUN currently just returns -1 and sets errno=EFAULT
in response to these failed accesses: the new capability will cause it
to also fill the kvm_run struct with an exit reason of
KVM_EXIT_MEMORY_FAULT and populate the memory_fault field with the
faulting range.

Upon receiving an annotated EFAULT, userspace may take appropriate
action to resolve the failed access. For instance, this might involve a
UFFDIO_CONTINUE or MADV_POPULATE_WRITE in the context of uffd-based live
migration postcopy.

KVM_CAP_MEMORY_FAULT_INFO comes with two important caveats, one public
and another internal.

1. Its implementation is incomplete: userspace may still receive
   un-annotated EFAULTs (exit reason != KVM_EXIT_MEMORY_FAULT) and must
   be able to handle these, although these cases are to be fixed as the
   maintainers learn of/identify them.

2. The implementation strategy given in this series, which is basically
   to fill the kvm_run.memory_fault field whenever a vCPU fails a guest
   memory access (even if the resulting EFAULT might not have been
   returned to userspace from KVM_RUN) is not without risk: some safety
   measures are taken, but they will not ensure total correctness.

   For example, if there are any existing paths in KVM_RUN which cause
   a vCPU to (1) populate the kvm_run struct in preparation for an
   exit to userspace then (2) try and fail to access guest memory for
   some reason, but ignore the result of the access and then (3)
   complete the exit to userspace, then the contents of the kvm_run
   struct written in (1) could be lost.

   Another example: if KVM_RUN fails a guest memory access for which the
   EFAULT is annotated but does not return the EFAULT to userspace,
   then later encounters another *un*annotated EFAULT which *is*
   returned to userspace, then the kvm_run.memory_fault field read by
   userspace will correspond to the first EFAULT, not the second.

   The discussion on this topic and of the alternative (filling the
   efault info only for those cases where KVM_RUN immediately returns to
   userspace) occurs in [3].

KVM_CAP_ABSENT_MAPPING_FAULT is introduced next (and is, I should note,
an idea proposed by James Houghton in [1] :). This capability causes
KVM_RUN to error with errno=EFAULT when it encounters a page fault for
which the userspace page tables do not contain present mappings. When
combined with KVM_CAP_MEMORY_FAULT_INFO, this capability allows KVM to
deliver information on page faults directly to the involved vCPU thread,
thus bypassing the userfaultfd wait queue and its related contention.

As a side note, KVM_CAP_ABSENT_MAPPING_FAULT prevents KVM from
generating async page faults. For this reason, hypervisors using it to
improve postcopy performance will likely want to disable it at the end
of postcopy.

KVM's demand paging self test is extended to demonstrate the performance
benefits of using the two new capabilities to bypass the userfaultfd
wait queue. The performance samples below (rates in thousands of
pages/s, n = 5), were generated using [2] on an x86 machine with 256
cores.

vCPUs, Average Paging Rate (w/o new caps), Average Paging Rate (w/ new caps)
1       150     340
2       191     477
4       210     809
8       155     1239
16      130     1595
32      108     2299
64      86      3482
128     62      4134
256     36      4012

[1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables the new capabilities.
    All data was collected after applying both the entire series and
    the following bugfix:
    https://lore.kernel.org/kvm/20230223001805.2971237-1-amoorthy@google.com/#r
[3] https://lore.kernel.org/kvm/ZBTgnjXJvR8jtc4i@google.com/

---

v3
  - Rework the implementation to be based on two orthogonal
    capabilities (KVM_CAP_MEMORY_FAULT_INFO and
    KVM_CAP_ABSENT_MAPPING_FAULT) [Sean, Oliver]
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

Anish Moorthy (22):
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: Allow hva_pfn_fast() to resolve read-only faults.
  KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN  at the start of
    KVM_RUN
  KVM: Add KVM_CAP_MEMORY_FAULT_INFO
  KVM: Add docstrings to __kvm_write_guest_page() and
    __kvm_read_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_map()
  KVM: x86: Annotate -EFAULTs from kvm_mmu_page_fault()
  KVM: x86: Annotate -EFAULTs from setup_vmgexit_scratch()
  KVM: x86: Annotate -EFAULTs from kvm_handle_page_fault()
  KVM: x86: Annotate -EFAULTs from kvm_hv_get_assist_page()
  KVM: x86: Annotate -EFAULTs from kvm_pv_clock_pairing()
  KVM: x86: Annotate -EFAULTs from direct_map()
  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
  KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT without implementation
  KVM: x86: Implement KVM_CAP_ABSENT_MAPPING_FAULT
  KVM: arm64: Annotate (some) -EFAULTs from user_mem_abort()
  KVM: arm64: Implement KVM_CAP_ABSENT_MAPPING_FAULT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  66 ++++-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/mmu.c                          |  18 +-
 arch/x86/kvm/hyperv.c                         |  14 +-
 arch/x86/kvm/mmu/mmu.c                        |  39 ++-
 arch/x86/kvm/svm/sev.c                        |   1 +
 arch/x86/kvm/x86.c                            |   7 +-
 include/linux/kvm_host.h                      |  19 ++
 include/uapi/linux/kvm.h                      |  18 ++
 tools/include/uapi/linux/kvm.h                |  12 +
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 242 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  18 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 158 +++++++-----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 virt/kvm/kvm_main.c                           |  75 +++++-
 20 files changed, 551 insertions(+), 154 deletions(-)


base-commit: d8708b80fa0e6e21bc0c9e7276ad0bccef73b6e7
-- 
2.40.0.577.gac1e443424-goog

