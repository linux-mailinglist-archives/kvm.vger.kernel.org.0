Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1575672074F
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbjFBQUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbjFBQTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:19:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1447F134
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:19:49 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba82ed6e450so2974809276.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722789; x=1688314789;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6XEBz9vZ4GaMwxLYRmjTfyz0gOAdRn9RA5RT2cb0IyA=;
        b=ZMarG+U/DtT0dCKCKelXKtd0UYgq9QVipmuXlk7S7GeSvigVtlTPhIFVZJV0Ak7avW
         YAMdzUm8c7pX7VjTlPU/QszCkVgn2q+2masw6Khbdgp4LNG9jmGPJX+p3ai1dZXTfmhS
         ffbACinuHVjcSupnRJC1LJ59Fotd89fv6lJWZ8qPBop7d6bdPEEz1tzgI+FCZj3KTOUo
         ehnoWJfXmxG9ppCCIFlk1vSc+cpLRhDgiCkIRpGmo9fVdVs0JM788LOwxXityfOUnHbU
         HBo6yXuvObC3qHWfjNbE5xccqCiuhfUokuhv1L4MY/dKwWnh32lakD4FN5ZI0IEYSbK5
         Cyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722789; x=1688314789;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6XEBz9vZ4GaMwxLYRmjTfyz0gOAdRn9RA5RT2cb0IyA=;
        b=Yoh61+cnDBEo/VRRKK4uqrJYFwVCTsXn3Pn4oXxe8cPQ7Iiaef4b0rJX1R552jUPWW
         K3ztFYF9OYSCn+KW2SykJumrqRLdsYu2vXuIBhmRxe/He7L6SeJ53cHyUnfz30SY4jrf
         C04A2hdQBaypDQQbr25/5SK/6gaNyLehlv2FSj35nNmWjWmqFd3rOzjyCgznntCFOkT6
         9sZP4ZgXoRnd4/omaaWOM7JUvwF4FAf3fe8SZ9EYgy0C8ulOiHFGpEIr/1MYsD/rV0Q0
         K0gtjzJNQKil3akSQGOx55Z5cpP9QpPWxuBmZ99gIpQRlAr5O13dyCtC8i9AyBbjVm1I
         p84g==
X-Gm-Message-State: AC+VfDyXPYnfDNmj+KzN0SUaTTjR2ZkEMCJGGBwtNWAWU87V/ZRel3Wy
        +3sNUa4McFd+h2QQHsF0hdIvBZycQO+3RQ==
X-Google-Smtp-Source: ACHHUZ65idIrfmcdEUCtjKqDV/SlpSwiiW7U+Ki4ZHZFgkxLpDvNeYMRIoBi2NBV/nyn9jrprKg1OxIkpnGJHw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:2402:0:b0:b9a:6508:1b5f with SMTP id
 k2-20020a252402000000b00b9a65081b5fmr1275178ybk.11.1685722788928; Fri, 02 Jun
 2023 09:19:48 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-1-amoorthy@google.com>
Subject: [PATCH v4 00/16] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
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

Outstanding Issues
~~~~~~~~~~~~~~~~~~
- The list of annotation sites still needs feedback. My latest
  assessment of which sites to annotate is in [4]
- The WARNs introduced in the kvm_populate_efault_info() helper need
  to be sorted out (gate behind kconfig?)
- Probably more (but hopefully not too much more :)

Cover Letter
~~~~~~~~~~~~
Due to serialization on internal wait queues, userfaultfd can be quite
slow at delivering faults to userspace when many vCPUs fault on the same
VMA/uffd: this problem only worsens as the number of vCPUs increases.
This series allows page faults encountered in KVM_RUN to bypass
userfaultfd (KVM_CAP_NOWAIT_ON_FAULT) and be delivered directly via
VM exit to the faulting vCPU (KVM_CAP_MEMORY_FAULT_INFO), allowing much
higher page-in rates during uffd-based postcopy.

KVM_CAP_MEMORY_FAULT_INFO comes first. This capability delivers
information to userspace on vCPU guest memory access failures. KVM_RUN
currently just returns -1 and sets errno=EFAULT upon these failures.

Upon receiving an annotated EFAULT, userspace may diagnose and act to
resolve the failed access. This might involve a MADV_POPULATE_READ|WRITE
or, in the context of uffd-based live migration postcopy, a
UFFDIO_COPY|CONTINUE.

~~~~~~~~~~~~~~ IMPORTANT NOTE ~~~~~~~~~~~~~~
The implementation strategy for KVM_CAP_MEMORY_FAULT_INFO has risks: for
example, if there are any existing paths in KVM_RUN which cause a vCPU
to (1) populate the kvm_run struct then (2) fail a vCPU guest memory
access but ignore the failure and then (3) complete the exit to
userspace set up in (1), then the contents of the kvm_run struct written
in (1) will be corrupted.

Another example: if KVM_RUN fails a guest memory access for which the
EFAULT is annotated but does not return the EFAULT to userspace, then
later returns an *un*annotated EFAULT to userspace, then userspace will
receive incorrect information.

These are pathological and (hopefully) hypothetical cases, but awareness
is important.

Rationale for taking this approach over the alternative strategy of
filling the efault info only for verified return paths from KVM_RUN to
userserspace occurred in [3].
~~~~~~~~~~~~~~ END IMPORTANT NOTE ~~~~~~~~~~~~~~

KVM_CAP_NOWAIT_ON_FAULT (originally proposed by James Houghton in [1])
comes next. This capability causes KVM_RUN to error with errno=EFAULT
when it encounters a page fault which would require the vCPU thread to
sleep. During uffd-based postcopy this allows delivery of page faults
directly to vCPU threads, bypassing the uffd wait queue and contention.

Side note" KVM_CAP_NOWAIT_ON_FAULT prevents async page faults, so
userspace will likely want to limit its use to uffd-based postcopy.

KVM's demand paging self test is extended to demonstrate the benefits
of the new caps to uffd-based postcopy. The performance samples below
(rates in thousands of pages/s, avg of 5 runs), were gathered using [2]
on an x86 machine with 256 cores.

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

Base Commit
~~~~~~~~~~~
This series is based off of kvm/next (39428f6ea9ea) with [5] applied

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

v4
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

Anish Moorthy (16):
  KVM: Allow hva_pfn_fast() to resolve read-only faults.
  KVM: x86: Set vCPU exit reason to KVM_EXIT_UNKNOWN  at the start of
    KVM_RUN
  KVM: Add KVM_CAP_MEMORY_FAULT_INFO
  KVM: Add docstrings to __kvm_write_guest_page() and
    __kvm_read_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
  KVM: Annotate -EFAULTs from kvm_vcpu_read_guest_page()
  KVM: Simplify error handling in __gfn_to_pfn_memslot()
  KVM: x86: Annotate -EFAULTs from kvm_handle_error_pfn()
  KVM: Introduce KVM_CAP_NOWAIT_ON_FAULT without implementation
  KVM: x86: Implement KVM_CAP_NOWAIT_ON_FAULT
  KVM: arm64: Implement KVM_CAP_NOWAIT_ON_FAULT
  KVM: selftests: Report per-vcpu demand paging rate from demand paging
    test
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  74 ++++-
 arch/arm64/kvm/arm.c                          |   2 +
 arch/arm64/kvm/mmu.c                          |  16 +-
 arch/x86/kvm/mmu/mmu.c                        |  30 +-
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvm_host.h                      |  15 +
 include/uapi/linux/kvm.h                      |  15 +
 tools/include/uapi/linux/kvm.h                |   8 +
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 285 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  17 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 159 ++++++----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 virt/kvm/kvm_main.c                           |  97 ++++--
 19 files changed, 564 insertions(+), 174 deletions(-)

-- 
2.41.0.rc0.172.g3f132b7071-goog

