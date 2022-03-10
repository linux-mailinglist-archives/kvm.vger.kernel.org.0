Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911B94D4FA4
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242928AbiCJQqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiCJQqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:46:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DDE15C652
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b70-20020a253449000000b0062c16d950c5so4893010yba.9
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=u3uM3T4fqIIeENkI/oDpiYVbdZfSHJ4n+nq816F+RHI=;
        b=U2lUv0c5x8Z0tN10iiJZ878tYRw0HCaxpmIWdgxRG42XmJ2qQxvxlr55QWE0uba6NF
         w24obauq196u/V/FWSukU1rEvuuXS7Gf9PI09w9CreeXa151tTESSChdK1qsS85Q3Q9d
         XN0VJMNQxqbYSykfz4PV70Nu+JGcqny+V5ajpc2ECC5Dp8L/O2lXAY9IrdtoB3+OQSLI
         yuumD9zr9RQEjaXpH5KegTN5RlU/lUVzKJUGxIl+7Qw3MjA6LvVNgWlK84i131Rv6yO4
         pTJeWOmDo20DosIqYhXf0PI87OtHUU3jGeDwXWZKQAW0BmE1+lm0lGbPTfjEXCpiqi5+
         b8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=u3uM3T4fqIIeENkI/oDpiYVbdZfSHJ4n+nq816F+RHI=;
        b=bIuzfqIwRUxyaMAmsoDIOFXUA2mH4Dwi79Ilz87GQ5rzwbG8Kwc1Moznm3uFVydn8P
         Em69w7UgHEdbkeOyucvlkL1rqzK1ymdFeT7NjAtT0lEdsEFNcfq0VrvCdzs7F5xeQhha
         u5P17jJQjuhXY59hTqmV2TxsCPjIEKn6Ca3g35aEdYSxjByn7ZwNMH0LfZbMRzjVzzqT
         hsy6IouVcUi14SeplNDfU+OkqXcjJ6YCObVtzPOH597tl2roJ4RAgTAOk29VboiB/aJC
         tjVRvM8MQ+1htMtX60w9M6bqNA5IhR1yuTss9tBYc3CEgQhq6SkoqYteL7Z7iOEqTaS4
         CqmA==
X-Gm-Message-State: AOAM533GAo3MKIdVUe5zB6CNrI/AQHDDOyRgSUUAHp06Ox1qwsfDvsDs
        ZMNl8kxVqcI8H+EeJzD1RIculFJvDGFs
X-Google-Smtp-Source: ABdhPJydjXqqkEgL+Wd+e99wiH5YSGHqTeHibW+DKcVMd0Qem1lVbAgVSdLWzBZL6FnyP7b5P0DAKt1MkO5E
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a25:c0ce:0:b0:628:7267:b0f2 with SMTP id
 c197-20020a25c0ce000000b006287267b0f2mr4785097ybf.570.1646930744265; Thu, 10
 Mar 2022 08:45:44 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:19 -0800
Message-Id: <20220310164532.1821490-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 00/13] KVM: x86: Add a cap to disable NX hugepages on a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Given the high cost of NX hugepages in terms of TLB performance, it may
be desirable to disable the mitigation on a per-VM basis. In the case of public
cloud providers with many VMs on a single host, some VMs may be more trusted
than others. In order to maximize performance on critical VMs, while still
providing some protection to the host from iTLB Multihit, allow the mitigation
to be selectively disabled.

Disabling NX hugepages on a VM is relatively straightforward, but I took this
as an opportunity to add some NX hugepages test coverage and clean up selftests
infrastructure a bit.

Patches 1-2 add some library calls for accessing stats via the binary stats API.
Patches 3-5 improve memslot ID handling in the KVM util library.
Patch 6 is a misc logging improvement.
Patches 7 and 13 implement an NX hugepages test.
Patches 8, 9, 10, and 12 implement disabling NX on a VM.
Patch 11 is a small cleanup of a bad merge.

This series was tested with the new selftest and the rest of the KVM selftests
on an Intel Haswell machine.

The following tests failed, but I do not believe that has anything to do with
this series:
	userspace_io_test
	vmx_nested_tsc_scaling_test
	vmx_preemption_timer_test

Ben Gardon (13):
  selftests: KVM: Dump VM stats in binary stats test
  selftests: KVM: Test reading a single stat
  selftests: KVM: Wrap memslot IDs in a struct for readability
  selftests: KVM: Add memslot parameter to VM vaddr allocation
  selftests: KVM: Add memslot parameter to elf_load
  selftests: KVM: Improve error message in vm_phy_pages_alloc
  selftests: KVM: Add NX huge pages test
  KVM: x86/MMU: Factor out updating NX hugepages state for a VM
  KVM: x86/MMU: Track NX hugepages on a per-VM basis
  KVM: x86/MMU: Allow NX huge pages to be disabled on a per-vm basis
  KVM: x86: Fix errant brace in KVM capability handling
  KVM: x86/MMU: Require reboot permission to disable NX hugepages
  selftests: KVM: Test disabling NX hugepages on a VM

 arch/x86/include/asm/kvm_host.h               |   3 +
 arch/x86/kvm/mmu.h                            |   9 +-
 arch/x86/kvm/mmu/mmu.c                        |  23 +-
 arch/x86/kvm/mmu/spte.c                       |   7 +-
 arch/x86/kvm/mmu/spte.h                       |   3 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   3 +-
 arch/x86/kvm/x86.c                            |  24 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |   2 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   7 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |  45 +--
 .../selftests/kvm/hardware_disable_test.c     |   2 +-
 .../selftests/kvm/include/kvm_util_base.h     |  57 ++--
 .../selftests/kvm/include/x86_64/vmx.h        |   4 +-
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +
 .../selftests/kvm/kvm_page_table_test.c       |   9 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   7 +-
 tools/testing/selftests/kvm/lib/elf.c         |   5 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 311 +++++++++++++++---
 .../selftests/kvm/lib/kvm_util_internal.h     |   2 +-
 .../selftests/kvm/lib/perf_test_util.c        |   4 +-
 .../selftests/kvm/lib/riscv/processor.c       |   5 +-
 .../selftests/kvm/lib/s390x/processor.c       |   9 +-
 .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 +++
 .../selftests/kvm/lib/x86_64/processor.c      |  11 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |   8 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  26 +-
 .../selftests/kvm/max_guest_memory_test.c     |   6 +-
 .../kvm/memslot_modification_stress_test.c    |   6 +-
 .../testing/selftests/kvm/memslot_perf_test.c |  11 +-
 .../selftests/kvm/set_memory_region_test.c    |   8 +-
 tools/testing/selftests/kvm/steal_time.c      |   3 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |   6 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |   2 +-
 .../kvm/x86_64/emulator_error_test.c          |   2 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |   2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |   6 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |   2 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   3 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 149 +++++++++
 .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  10 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   2 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |   4 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |   2 +-
 48 files changed, 704 insertions(+), 190 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
 create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
 create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh

-- 
2.35.1.616.g0bdcbb4464-goog

