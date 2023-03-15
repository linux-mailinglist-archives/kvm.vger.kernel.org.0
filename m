Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E276D6BA50A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCOCSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCOCSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811FAE1B7
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:01 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54476ef9caeso11766267b3.6
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846680;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zrwn/D2esioJTsmrB76zHBd8QH3KMNecKIKJG49dN70=;
        b=fqwktPk0/e4lkPx92MjNDulmdifwEcbYjW4eko2JrE7fbub3R4HbTHpGtDFNebB3Dn
         cvReJu0tZYhG48WuOBEEmaEGZ7jdhjx825nvjdYfh7WL7w8xNlowiUZworOiLlw2S5r3
         2rkYSIPVfbaZc2oyJ8HwEJCT3eOaPw9fcKVumEE4JO3aeUTSLeofXRTNbCF6EGr8DzRE
         bKpwMuwvPBA1EL9CAxPvncdvzLRTmU0KrT2si8rAsrLs7wrll1iPFLZSvZz1l6Cj/CkL
         7hBguVQdSwYs3wLx3xzka+87VH+9cPOI3pzhQJ61u/MNCFlaV+/Da0A5oL47sgl8mF9U
         31WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846680;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zrwn/D2esioJTsmrB76zHBd8QH3KMNecKIKJG49dN70=;
        b=j7EjY+OLPtSddcWO0TJCoJYysNldbJFzPQfSatblTPsOteFGufKNAU2UZQZUyW86oO
         CHoQEyOStrpkVLsHwlQYvFDRdtIOCTTCsL7SVzZZ+PW97MZ8AeOE9FgiOsc8UntNxutf
         p0hiHMpOtlAETB9jYRRN1cdwMPJe9ybKP582uV/+ViNdzCbNisqHvoGJFHcP3YGDd2Fw
         JdvAR+CC7tlLK1uzaNTgxHJNQEG97Y50/N4L6uxvfgQRUBqz49B2XAV3J+qavg63uf7V
         Bzt0kpMpikDSaHQ0igDPfJwf8mU8oLUgGp6vfen4U6oX4sjQJ7+FuaIYGAcbtvrfqkn+
         FPNQ==
X-Gm-Message-State: AO0yUKXxPMW2HlHpxVZswRHzbQUh+pme5UPGH6nZX7K4f8WzonAHLu1a
        Trr2vNz2V85uVdw7KSv4Bflpl7Y1t5dF/Q==
X-Google-Smtp-Source: AK7set/bVOj15qK8HN52vi3urbJ5zhH6QRfAGOgouh7fr1bQ+quMYUzvtX3u4i4A6f6rXFbMShEcHW07l0YbfQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:9f0e:0:b0:b3b:fb47:8534 with SMTP id
 n14-20020a259f0e000000b00b3bfb478534mr5281885ybq.5.1678846680735; Tue, 14 Mar
 2023 19:18:00 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-1-amoorthy@google.com>
Subject: [WIP Patch v2 00/14] Avoiding slow get-user-pages via memory fault exit
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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

Hi Sean, here's what I'm planing to send up as v2 of the scalable
userfaultfd series.

Don't worry, I'm not asking you to review this all :) I just have a few
remaining questions regarding KVM_CAP_MEMORY_FAULT_EXIT which seem important
enough to mention before I ask for more attention from others, and they'll be
clearer with the patches in hand. Anything else I'm happy to find out about when
I send the actual v2.

I want your opinion on

1. The general API I've set up for KVM_CAP_MEMORY_FAULT_EXIT
   (described in the api.rst file)
2. Whether the UNKNOWN exit reason cases (everywhere but
   handle_error_pfn atm) would need to be given "real" reasons
   before this could be merged.
3. If you think I've missed sites that currently -EFAULT to userspace

About (3): after we agreed to only tackle cases where -EFAULT currently makes it
to userspace, I went though our list and tried to trace which EFAULTS actually
bubble up to KVM_RUN. That set ended being suspiciously small, so I wanted to
sanity-check my findings with you. Lmk if you see obvious errors in my list
below.

--- EFAULTs under KVM_RUN ---

Confident that needs conversion (already converted)
---------------------------------------------------
* direct_map
* handle_error_pfn
* setup_vmgexit_scratch
* kvm_handle_page_fault
* FNAME(fetch)

EFAULT does not propagate to userspace (do not convert)
-------------------------------------------------------
* record_steal_time (arch/x86/kvm/x86.c:3463)
* hva_to_pfn_retry
* kvm_vcpu_map
* FNAME(update_accessed_dirty_bits)
* __kvm_gfn_to_hva_cache_init
  Might actually make it to userspace, but only through
  kvm_read|write_guest_offset_cached- would be covered by those conversions
* kvm_gfn_to_hva_cache_init
* __kvm_read_guest_page
* hva_to_pfn_remapped
  handle_error_pfn will handle this for the scalable uffd case. Don't think
  other callers -EFAULT to userspace.

Still unsure if needs conversion
--------------------------------
* __kvm_read_guest_atomic
  The EFAULT might be propagated though FNAME(sync_page)?
* kvm_write_guest_offset_cached (virt/kvm/kvm_main.c:3226)
* __kvm_write_guest_page
  Called from kvm_write_guest_offset_cached: if that needs change, this does too
* kvm_write_guest_page
  Two interesting paths:
      - kvm_pv_clock_pairing returns a custom KVM_EFAULT error here
        (arch/x86/kvm/x86.c:9578)
      - kvm_write_guest_offset_cached returns this directly (so if that needs
        change, this does too)
* kvm_read_guest_offset_cached
  I actually do see a path to userspace, but it's through hyper-v, which we've
  said is out of scope for round 1.

--- Actual Cover Letter ---

Omitted: hasn't changed much since v1 anyways

--- Changelog ---

WIP v2
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
  KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand
    paging test
  KVM: selftests: Use EPOLL in userfaultfd_util reader threads and
    signal errors via TEST_ASSERT
  KVM: Allow hva_pfn_fast to resolve read-only faults.
  KVM: x86: Add KVM_CAP_X86_MEMORY_FAULT_EXIT and associated kvm_run
    field
  KVM: x86: Implement memory fault exit for direct_map
  KVM: x86: Implement memory fault exit for kvm_handle_page_fault
  KVM: x86: Implement memory fault exit for setup_vmgexit_scratch
  KVM: x86: Implement memory fault exit for FNAME(fetch)
  KVM: Introduce KVM_CAP_MEMORY_FAULT_NOWAIT without implementation
  KVM: x86: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
  KVM: arm64: Allow user_mem_abort to return 0 to signal a 'normal' exit
  KVM: arm64: Implement KVM_CAP_MEMORY_FAULT_NOWAIT
  KVM: selftests: Add memslot_flags parameter to memstress_create_vm
  KVM: selftests: Handle memory fault exits in demand_paging_test

 Documentation/virt/kvm/api.rst                |  74 ++++-
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  29 +-
 arch/x86/kvm/mmu/mmu.c                        |  42 ++-
 arch/x86/kvm/mmu/paging_tmpl.h                |   4 +-
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/x86.c                            |   2 +
 include/linux/kvm_host.h                      |  22 ++
 include/uapi/linux/kvm.h                      |  19 ++
 tools/include/uapi/linux/kvm.h                |  17 ++
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/access_tracking_perf_test.c |   2 +-
 .../selftests/kvm/demand_paging_test.c        | 253 ++++++++++++++----
 .../selftests/kvm/dirty_log_perf_test.c       |   2 +-
 .../testing/selftests/kvm/include/memstress.h |   2 +-
 .../selftests/kvm/include/userfaultfd_util.h  |  18 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   4 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 160 ++++++-----
 .../kvm/memslot_modification_stress_test.c    |   2 +-
 virt/kvm/kvm_main.c                           |  41 ++-
 20 files changed, 544 insertions(+), 158 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

