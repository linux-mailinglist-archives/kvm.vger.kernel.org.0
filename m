Return-Path: <kvm+bounces-8833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E8E857200
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2DBC2857B7
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99CD145FED;
	Thu, 15 Feb 2024 23:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O1lWa9OY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF4B14534A
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041254; cv=none; b=udmqnGxigWHrhPnSnJhZnZPerTkgAWYpg1RhY9eaRoaJwbVdlOCx67Y3rzFPj7LFnfyEIMkdokKh0gNLE40odugcOBS6xjfy4jjP+RbTwXeirvmR73FhQP1CrI79uUNoVB92wdKxGZHP2wiW5UVbaMBB0W3GiJd/i5sQ4pwwYXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041254; c=relaxed/simple;
	bh=yk14AcXTQHA27Gb/SBvmkQvyvuZuhyDE+j+f3Lxt4U8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R5FlFf4hUdsFAanP9qQdojTiHM/M25HlierVDfLtWWp6kKFRP94kIOsaa2IDU+eEmc/hIOiewPGDjzXCErvCz964meKoj6xHQfZO4BPk+l5ulELZB+AzzzYIzHVaTQH67Jt1u/3a96Hm5TDvnfbHnakmalVQgGpMq3YLNA+PBT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O1lWa9OY; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbee93a3e1so270182276.3
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041251; x=1708646051; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RVHDbsLCzKA6jU33GkHFBG7ui0Dmr1Nv/9yBfaTWLpk=;
        b=O1lWa9OY7spZxLKz7/4nsLTd/wjukV2dSfl/JF3xGZmo6+XMHrti+zPiMfegrR5nPB
         SyQSdJ7VioHKzPvmIifMnFokjkyAJozpLiSLoYyDFkE2gj9ZoM8gt6IsFejt3A9eFDcQ
         PlBgTH8LYjNTsRV3/a7CBGa5oI1+Hoxn8/IE+vyoqyr6GjTIGf+7RJY9QE6FsCpbsbf+
         lnu71PD6R1gaakHTJIuHVhOLetMsdWSqUGRTlnuUrouKAxLzEalGBFroDf3EMyEh5o02
         o4KGMQiBaI33KI9y+z+CJpdZrGkI8b5JoqqMaYva6/N/tg0atlmHNUNwbGVpSXMqVMqu
         1t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041251; x=1708646051;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVHDbsLCzKA6jU33GkHFBG7ui0Dmr1Nv/9yBfaTWLpk=;
        b=mMGcjr8L36dIpf0bCmrwchOxIXWW2Xg61uZKR1WjlWUu+PaL9unk+6B9zL0+pTwpih
         J+keIQITK88gf15fvF6Z30LD5jN/8js43yogkBfaC3rS/Qx1nThA6xcUcenGliNgB0Nw
         GNdsyr5NxBdxgxiJjvjSGqqusyKWra2KJkqa7Pxoj/CXVWLxQKtlmJRiLi/dqH8Z5f9N
         C5t1WTzV/PACOh1X6TmE1ECzEKILHEKIJ6gIWrYWbhhTR1io7Aapv1KvCGrh9JaWPTPl
         puokmNHywHYSgUO162zOdBrtMhqaRule6zNJR4DUYictwrihijTkZhs6ly4zzMh4XDP8
         8wYg==
X-Forwarded-Encrypted: i=1; AJvYcCWmFG1cyhWoRutyKkiI0Oa1HW4n+bkRupwH4AdnMLMAf94wfF27chRZ6+1+nx0SEzNxiPer+667Qenb/+e0C8RAatcD
X-Gm-Message-State: AOJu0Yw4ztUL07onE0wPiIoD1CsMrCsrpMTqb6/w53hu6y0TU+n/chp/
	vl/xB+2+ppRf4nfmnEomhWcNUWBmzNmadGXczAFiuE2lRb1QhU5y1PGXX9CkPyjc6XmtdH6Z9xy
	By71E/3KvnQ==
X-Google-Smtp-Source: AGHT+IFl/CO6vEYOQ41kQQkoQMB/UhM3h8n87bs0hICpIfyI/Z2uK79xOvS6wrlKrM9msRwacDrCKCSCqMZ2CQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:2702:0:b0:dbd:73bd:e55a with SMTP id
 n2-20020a252702000000b00dbd73bde55amr198126ybn.4.1708041250792; Thu, 15 Feb
 2024 15:54:10 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-1-amoorthy@google.com>
Subject: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

This series adds an option to cause stage-2 fault handlers to
KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
the userspace mappings. Doing so allows userspace to receive stage-2
faults directly from KVM_RUN instead of through userfaultfd, which
suffers from serious contention issues as the number of vCPUs scales.

Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
demand_paging_test, which demonstrates the scalability improvements:
the following data was collected using [2] on an x86 machine with 256
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

The diff since the last version is small enough that I've attached a
range-diff in the cover letter- hopefully it's useful for review.

Links
~~~~~
[1] Original RFC from James Houghton:
    https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/

[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables the new capabilities.
    All data was collected after applying the entire series

---

v7
  - Add comment for the upgrade-to-atomic in __gfn_to_pfn_memslot()
    [James]
  - Expand description for KVM_MEM_GUEST_MEMFD in kvm/api.rst [James]
    and split it off into its own commit [Anish]
  - Update documentation to indicate that KVM_CAP_MEMORY_FAULT_INFO is
    available on arm [James]
  - Expand commit message for the "enable KVM_CAP_MEMORY_FAULT_INFO on
    arm64" commit [Anish]
  - Drop buggy "fast GUP on read faults" patch [Thanks James!]
  - Make KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING mutually exclusive
    [Sean, Oliver]
  - Drop incorrect "Documentation:" from some shortlogs [Sean]
  - Add description for the KVM_EXIT_MEMORY_FAULT RWX patch [Sean]
  - Style issues [Sean]

v6: https://lore.kernel.org/kvm/20231109210325.3806151-1-amoorthy@google.com/
  - Rebase onto guest_memfd series [Anish/Sean]
  - Set write fault flag properly in user_mem_abort() [Oliver]
  - Reformat unnecessarily multi-line comments [Sean]
  - Drop the kvm_vcpu_read|write_guest_page() annotations [Sean]
  - Rename *USERFAULT_ON_MISSING to *EXIT_ON_MISSING [David]
  - Remove unnecessary rounding in user_mem_abort() annotation [David]
  - Rewrite logs for KVM_MEM_EXIT_ON_MISSING patches and squash
    them with the stage-2 fault annotation patches [Sean]
  - Undo the enum parameter addition to __gfn_to_pfn_memslot(), and just
    add another boolean parameter instead [Sean]
  - Better shortlog for the hva_to_pfn_fast() change [Anish]

v5: https://lore.kernel.org/kvm/20230908222905.1321305-1-amoorthy@google.com/
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

Anish Moorthy (14):
  KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
  KVM: Add function comments for __kvm_read/write_guest_page()
  KVM: Documentation: Make note of the KVM_MEM_GUEST_MEMFD memslot flag
  KVM: Simplify error handling in __gfn_to_pfn_memslot()
  KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to
    userspace
  KVM: Add memslot flag to let userspace force an exit on missing hva
    mappings
  KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from
    stage-2 fault handler
  KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the
    stage-2 fault handler
  KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
  KVM: selftests: Report per-vcpu demand paging rate from demand paging
    test
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  39 ++-
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |   7 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c        |   2 +-
 arch/x86/kvm/Kconfig                          |   1 +
 arch/x86/kvm/mmu/mmu.c                        |   8 +-
 include/linux/kvm_host.h                      |  21 +-
 include/uapi/linux/kvm.h                      |   5 +
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
 virt/kvm/kvm_main.c                           |  46 ++-
 22 files changed, 453 insertions(+), 172 deletions(-)

Range-diff against v6:
 1:  2089d8955538 !  1:  063d5d109f34 KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
    @@ Metadata
     Author: Anish Moorthy <amoorthy@google.com>
     
      ## Commit message ##
    -    KVM: Documentation: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
    +    KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
     
    -    The current docstring can be read as "atomic -> allowed to sleep," when
    -    in fact the intended statement is "atomic -> NOT allowed to sleep." Make
    -    that clearer in the docstring.
    +    The current description can be read as "atomic -> allowed to sleep,"
    +    when in fact the intended statement is "atomic -> NOT allowed to sleep."
    +    Make that clearer in the docstring.
     
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
     
 2:  36963c6eee29 !  2:  e038fe64f44a KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
    @@ Metadata
     Author: Anish Moorthy <amoorthy@google.com>
     
      ## Commit message ##
    -    KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
    +    KVM: Add function comments for __kvm_read/write_guest_page()
     
         The (gfn, data, offset, len) order of parameters is a little strange
    -    since "offset" applies to "gfn" rather than to "data". Add docstrings to
    -    make things perfectly clear.
    +    since "offset" applies to "gfn" rather than to "data". Add function
    +    comments to make things perfectly clear.
     
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
     
 -:  ------------ >  3:  812a2208da95 KVM: Documentation: Make note of the KVM_MEM_GUEST_MEMFD memslot flag
 3:  4994835c51f5 =  4:  44cec9bf6166 KVM: Simplify error handling in __gfn_to_pfn_memslot()
 4:  3d51224854b1 !  5:  df09c7482fbf KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to userspace
    @@ Metadata
      ## Commit message ##
         KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to userspace
     
    +    kvm_prepare_memory_fault_exit() already takes parameters describing the
    +    RWX-ness of the relevant access but doesn't actually do anything with
    +    them. Define and use the flags necessary to pass this information on to
    +    userspace.
    +
         Suggested-by: Sean Christopherson <seanjc@google.com>
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
     
 5:  6bab46398020 <  -:  ------------ KVM: Try using fast GUP to resolve read faults
 6:  556e7079c419 !  6:  6a6993bda462 KVM: Add memslot flag to let userspace force an exit on missing hva mappings
    @@ Commit message
     
         Suggested-by: James Houghton <jthoughton@google.com>
         Suggested-by: Sean Christopherson <seanjc@google.com>
    -    Reviewed-by: James Houghton <jthoughton@google.com>
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
     
      ## Documentation/virt/kvm/api.rst ##
     @@ Documentation/virt/kvm/api.rst: yet and must be cleared on entry.
    -   /* for kvm_userspace_memory_region::flags */
        #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
        #define KVM_MEM_READONLY	(1UL << 1)
    -+  #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
    +   #define KVM_MEM_GUEST_MEMFD      (1UL << 2)
     +  #define KVM_MEM_EXIT_ON_MISSING  (1UL << 3)
      
      This ioctl allows the user to create, modify or delete a guest physical
    @@ Documentation/virt/kvm/api.rst: It is recommended that the lower 21 bits of gues
      be identical.  This allows large pages in the guest to be backed by large
      pages in the host.
      
    --The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
    --KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
    +-The flags field supports three flags
     +The flags field supports four flags
    -+
    -+1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
    + 
    + 1.  KVM_MEM_LOG_DIRTY_PAGES: can be set to instruct KVM to keep track of
      writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
    --use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
    -+use it.
    -+2.  KVM_MEM_READONLY: can be set, if KVM_CAP_READONLY_MEM capability allows it,
    - to make a new slot read-only.  In this case, writes to this memory will be
    +@@ Documentation/virt/kvm/api.rst: to make a new slot read-only.  In this case, writes to this memory will be
      posted to userspace as KVM_EXIT_MMIO exits.
    -+3.  KVM_MEM_GUEST_MEMFD
    + 3.  KVM_MEM_GUEST_MEMFD: see KVM_SET_USER_MEMORY_REGION2. This flag is
    + incompatible with KVM_SET_USER_MEMORY_REGION.
     +4.  KVM_MEM_EXIT_ON_MISSING: see KVM_CAP_EXIT_ON_MISSING for details.
      
      When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
      the memory region are automatically reflected into the guest.  For example, an
    +@@ Documentation/virt/kvm/api.rst: Instead, an abort (data abort if the cause of the page-table update
    + was a load or a store, instruction abort if it was an instruction
    + fetch) is injected in the guest.
    + 
    ++Note: KVM_MEM_READONLY and KVM_MEM_EXIT_ON_MISSING are currently mutually
    ++exclusive.
    ++
    + 4.36 KVM_SET_TSS_ADDR
    + ---------------------
    + 
     @@ Documentation/virt/kvm/api.rst: error/annotated fault.
      
      See KVM_EXIT_MEMORY_FAULT for more information.
    @@ include/uapi/linux/kvm.h: struct kvm_userspace_memory_region2 {
      
      /* for KVM_IRQ_LINE */
      struct kvm_irq_level {
    -@@ include/uapi/linux/kvm.h: struct kvm_ppc_resize_hpt {
    +@@ include/uapi/linux/kvm.h: struct kvm_enable_cap {
      #define KVM_CAP_MEMORY_ATTRIBUTES 233
      #define KVM_CAP_GUEST_MEMFD 234
      #define KVM_CAP_VM_TYPES 235
     +#define KVM_CAP_EXIT_ON_MISSING 236
      
    - #ifdef KVM_CAP_IRQ_ROUTING
    - 
    + struct kvm_irq_routing_irqchip {
    + 	__u32 irqchip;
     
      ## virt/kvm/Kconfig ##
     @@ virt/kvm/Kconfig: config KVM_GENERIC_PRIVATE_MEM
    @@ virt/kvm/kvm_main.c: static int check_memory_region_flags(struct kvm *kvm,
     +
      	if (mem->flags & ~valid_flags)
      		return -EINVAL;
    ++	else if ((mem->flags & KVM_MEM_READONLY) &&
    ++		 (mem->flags & KVM_MEM_EXIT_ON_MISSING))
    ++		return -EINVAL;
      
    + 	return 0;
    + }
     @@ virt/kvm/kvm_main.c: kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
      
      kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
    @@ virt/kvm/kvm_main.c: kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot
      		writable = NULL;
      	}
      
    -+	if (!atomic && can_exit_on_missing
    -+	    && kvm_is_slot_exit_on_missing(slot)) {
    ++	/* When the slot is exit-on-missing (and when we should respect that)
    ++	 * set atomic=true to prevent GUP from faulting in the userspace
    ++	 * mappings.
    ++	 */
    ++	if (!atomic && can_exit_on_missing &&
    ++	    kvm_is_slot_exit_on_missing(slot)) {
     +		atomic = true;
     +		if (async) {
     +			*async = false;
 7:  28b6fe1ad5b9 !  7:  70696937be14 KVM: x86: Enable KVM_CAP_EXIT_ON_MISSING and annotate EFAULTs from stage-2 fault handler
    @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for more information.
     
      ## arch/x86/kvm/Kconfig ##
     @@ arch/x86/kvm/Kconfig: config KVM
    - 	select INTERVAL_TREE
    + 	select KVM_VFIO
      	select HAVE_KVM_PM_NOTIFIER if PM
      	select KVM_GENERIC_HARDWARE_ENABLING
     +        select HAVE_KVM_EXIT_ON_MISSING
 8:  a80db5672168 <  -:  ------------ KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
 -:  ------------ >  8:  05bbf29372ed KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the stage-2 fault handler
 9:  70c5db4f5c9e !  9:  bb22b31c8437 KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from stage-2 fault-handler
    @@ Metadata
     Author: Anish Moorthy <amoorthy@google.com>
     
      ## Commit message ##
    -    KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and annotate an EFAULT from stage-2 fault-handler
    +    KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
     
         Prevent the stage-2 fault handler from faulting in pages when
         KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
    -    calls to check the memslot flag.
    -
    -    To actually make that behavior useful, prepare a KVM_EXIT_MEMORY_FAULT
    -    when the stage-2 handler cannot resolve the pfn for a fault. With
    -    KVM_MEM_EXIT_ON_MISSING enabled this effects the delivery of stage-2
    -    faults as vCPU exits, which userspace can attempt to resolve without
    -    terminating the guest.
    +    call to check the memslot flag. This effects the delivery of stage-2
    +    faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
    +    can attempt to resolve without terminating the guest.
     
         Delivering stage-2 faults to userspace in this way sidesteps the
         significant scalabiliy issues associated with using userfaultfd for the
    @@ Documentation/virt/kvm/api.rst: See KVM_EXIT_MEMORY_FAULT for more information.
     
      ## arch/arm64/kvm/Kconfig ##
     @@ arch/arm64/kvm/Kconfig: menuconfig KVM
    + 	select SCHED_INFO
      	select GUEST_PERF_EVENTS if PERF_EVENTS
    - 	select INTERVAL_TREE
      	select XARRAY_MULTI
     +        select HAVE_KVM_EXIT_ON_MISSING
      	help
    @@ arch/arm64/kvm/mmu.c: static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr
      	if (pfn == KVM_PFN_ERR_HWPOISON) {
      		kvm_send_hwpoison_signal(hva, vma_shift);
      		return 0;
    - 	}
    --	if (is_error_noslot_pfn(pfn))
    -+	if (is_error_noslot_pfn(pfn)) {
    -+		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
    -+					      write_fault, exec_fault, false);
    - 		return -EFAULT;
    -+	}
    - 
    - 	if (kvm_is_device_pfn(pfn)) {
    - 		/*
10:  ab913b9b5570 = 10:  a62ee8593b84 KVM: selftests: Report per-vcpu demand paging rate from demand paging test
11:  a27ff8b097d7 ! 11:  58ddb652eac1 KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
    @@ Commit message
         configuring the number of reader threads per UFFD as well: add the "-r"
         flag to do so.
     
    -    Acked-by: James Houghton <jthoughton@google.com>
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
    +    Acked-by: James Houghton <jthoughton@google.com>
     
      ## tools/testing/selftests/kvm/aarch64/page_fault_test.c ##
     @@ tools/testing/selftests/kvm/aarch64/page_fault_test.c: static void setup_uffd(struct kvm_vm *vm, struct test_params *p,
12:  ee196df32964 ! 12:  b4cfe82097e2 KVM: selftests: Use EPOLL in userfaultfd_util reader threads and signal errors via TEST_ASSERT
    @@ Commit message
         [1] Single-vCPU performance does suffer somewhat.
         [2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>
     
    -    Acked-by: James Houghton <jthoughton@google.com>
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
    +    Acked-by: James Houghton <jthoughton@google.com>
     
      ## tools/testing/selftests/kvm/demand_paging_test.c ##
     @@
13:  9406cb2581e5 = 13:  f8095728fcef KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
14:  dbab5917e1f6 ! 14:  a5863f1206bb KVM: selftests: Handle memory fault exits in demand_paging_test
    @@ Commit message
     
         Demonstrate a (very basic) scheme for supporting memory fault exits.
     
    -    >From the vCPU threads:
    +    From the vCPU threads:
         1. Simply issue UFFDIO_COPY/CONTINUEs in response to memory fault exits,
            with the purpose of establishing the absent mappings. Do so with
            wake_waiters=false to avoid serializing on the userfaultfd wait queue
    @@ Commit message
         [A] In reality it is much likelier that the vCPU thread simply lost a
             race to establish the mapping for the page.
     
    -    Acked-by: James Houghton <jthoughton@google.com>
         Signed-off-by: Anish Moorthy <amoorthy@google.com>
    +    Acked-by: James Houghton <jthoughton@google.com>
     
      ## tools/testing/selftests/kvm/demand_paging_test.c ##
     @@

base-commit: 687d8f4c3dea0758afd748968d91288220bbe7e3
-- 
2.44.0.rc0.258.g7320e95886-goog


