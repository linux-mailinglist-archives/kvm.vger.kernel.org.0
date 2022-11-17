Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A502262D067
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 02:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiKQBKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 20:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKQBKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 20:10:39 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F481DF11
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 17:10:37 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id k7so174182pll.6
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 17:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7v+d6JaDwJ1bpDb3Wp/Ga4NomYsL48wpwJx8dilZwfw=;
        b=WIg3/uWSqDpX6Onm/kPloKuk/2+xMLTM0HDwO+4o/Sl+ZDde873x1lzDTJnfVrIQCU
         aTsG5Yc9J4fWtWHq5MHON7C6QMA3JzwJaLoTCEEjYTWj28cxXcJ0xVOBecnqsl9hGcJx
         tD3gISsdr6P+3hP/nMRKirHZztE4LgDDwVOgt1q0wa+pCgZMMj4jr4nWjw91nRtcGVxv
         2eQIuA81x/LD2MJ/az+ZAfgdyGuNseL6aQrXAeyYg0qT1XXls0x4C3hYBAlryFGfvmP7
         6AWkcM//51S0WG93r6WY8gWlujcirESGNiMSgsuELaB3YAHmhgKC9f+Z6WjaldSyHyg+
         4LoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7v+d6JaDwJ1bpDb3Wp/Ga4NomYsL48wpwJx8dilZwfw=;
        b=xF2Y5g/VK5nGGQn4ORV1TZR/m3hhisseKMuwYmMNHdkH6DPg2+MMYJcqRcDLT7Q8Vs
         pBL8jFZtvHT0rCRGcA8gjYzmwzOxaEai1/XmpX9fxXOqlx1PanPSjxbrFvZWqHxhIXFq
         landKUoY7nQtnw/xnhEfAyRD7vobfNSwZCzRpVjIgBZLaqf1XMi8JIYJgrc243kRGdQ8
         dagkZwnWNKl3BJUWsmmcO71NdpYZaJ6TQqHi+cl6UrAaVrdx5zeqFZX6p2O6EK4e9ql2
         vF1upfTr6BD9UaMsSzdiWVrtrq30754TWdyisM2OlmRsxJclowOzMadK0TaMqg1AtRL/
         RJ7g==
X-Gm-Message-State: ANoB5plRsNV8YqGwIdPbE4ymqA8YCnVlPbCshLh0BolrXwjDpEuHNBhA
        Jhrj79YacEZ8aQDt85OO+ha9cQ==
X-Google-Smtp-Source: AA0mqf54RD5Pvk0svu38D8EFgCtS0Yk3hYxgOG1/bS1Fw8Mnp0BPEvRTFzA0mAmuATEQ3ScwkDA+Tg==
X-Received: by 2002:a17:902:eb86:b0:188:c395:1748 with SMTP id q6-20020a170902eb8600b00188c3951748mr315085plg.155.1668647437276;
        Wed, 16 Nov 2022 17:10:37 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0055f209690c0sm11547853pfp.50.2022.11.16.17.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 17:10:36 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:10:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Peter Gonda <pgonda@google.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: [GIT PULL] KVM: selftests: Early pile of updates for 6.2
Message-ID: <Y3WKCRJbbvhnyDg1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please pull a set of selftests updates for 6.2.  Many of these changes are
prep work for future selftests, e.g. for SEV and TDX, and/or have myriad
conflicts, e.g. the former "perf util" code.  I am hoping to get these
changes queued up for 6.2 sooner than later so that the chain of dependent
work doesn't get too long.

Except for the ARM single-step changes[*], everything has been posted for
quite some time and/or has gone through multiple rounds of review.

The ARM single-step changes are a last minute fix to resolve a hilarious
(IMO) collision between the pool-based ucall implementation and the
recently added single-step test.  Turns out that GCC will generate older
flavors of atomics that rely on a monitor to detect conflicts, and that
monitor is cleared by eret.  gdb is allegedly smart enough to skip over
atomic sequences, but our selftest... not so much.

Note, there's one KVM x86 patch hiding in here (cleanup for code that gets
copied into selftests), but its quite innocuous and shouldn't conflict
with anything.

Regarding the "perf util" conflicts, I'm mostly certain I got them right,
but it wouldn't be a bad idea for the folks involved (Cc'd) to double
check that the end result looks correct.

[*] https://lore.kernel.org/all/20221117002350.2178351-1-seanjc@google.com


The following changes since commit d663b8a285986072428a6a145e5994bc275df994:

  KVM: replace direct irq.h inclusion (2022-11-09 12:31:37 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux tags/kvm-selftests-6.2-1

for you to fetch changes up to 5c107f7085f45e071bbcf13006fffccd8e5de0e1:

  KVM: selftests: Assert in prepare_eptp() that nEPT is supported (2022-11-16 16:59:07 -0800)

----------------------------------------------------------------
KVM selftests updates for 6.2

perf_util:
 - Add support for pinning vCPUs in dirty_log_perf_test.
 - Add a lightweight psuedo RNG for guest use, and use it to randomize
   the access pattern and write vs. read percentage in the so called
   "perf util" tests.
 - Rename the so called "perf_util" framework to "memstress".

ucall:
 - Add a common pool-based ucall implementation (code dedup and pre-work
   for running SEV (and beyond) guests in selftests.
 - Fix an issue in ARM's single-step test when using the new pool-based
   implementation; atomics don't play nice with single-step exceptions.

init:
 - Provide a common constructor and arch hook, which will eventually be
   used by x86 to automatically select the right hypercall (AMD vs. Intel).

x86:
 - Clean up x86's page tabe management.
 - Clean up and enhance the "smaller maxphyaddr" test, and add a related
   test to cover generic emulation failure.
 - Clean up the nEPT support checks.
 - Add X86_PROPERTY_* framework to retrieve multi-bit CPUID values.

----------------------------------------------------------------
Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "begining" -> "beginning"

Colton Lewis (4):
      KVM: selftests: implement random number generator for guest code
      KVM: selftests: create -r argument to specify random seed
      KVM: selftests: randomize which pages are written vs read
      KVM: selftests: randomize page access order

David Matlack (13):
      KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
      KVM: selftests: Rename pta (short for perf_test_args) to args
      KVM: selftests: Rename perf_test_util symbols to memstress
      KVM: selftests: Rename emulator_error_test to smaller_maxphyaddr_emulation_test
      KVM: selftests: Explicitly require instructions bytes
      KVM: selftests: Delete dead ucall code
      KVM: selftests: Move flds instruction emulation failure handling to header
      KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
      KVM: selftests: Copy KVM PFERR masks into selftests
      KVM: selftests: Expect #PF(RSVD) when TDP is disabled
      KVM: selftests: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE
      KVM: selftests: Check for KVM nEPT support using "feature" MSRs
      KVM: selftests: Assert in prepare_eptp() that nEPT is supported

Gautam Menghani (1):
      KVM: selftests: Don't assume vcpu->id is '0' in xAPIC state test

Peter Gonda (2):
      tools: Add atomic_test_and_set_bit()
      KVM: selftests: Add ucall pool based implementation

Sean Christopherson (28):
      KVM: arm64: selftests: Disable single-step with correct KVM define
      KVM: arm64: selftests: Disable single-step without relying on ucall()
      KVM: selftests: Consolidate common code for populating ucall struct
      KVM: selftests: Consolidate boilerplate code in get_ucall()
      KVM: selftests: Automatically do init_ucall() for non-barebones VMs
      KVM: selftests: Make arm64's MMIO ucall multi-VM friendly
      KVM: selftests: Drop now-unnecessary ucall_uninit()
      KVM: selftests: Drop helpers to read/write page table entries
      KVM: selftests: Drop reserved bit checks from PTE accessor
      KVM: selftests: Remove useless shifts when creating guest page tables
      KVM: selftests: Verify parent PTE is PRESENT when getting child PTE
      KVM: selftests: Use virt_get_pte() when getting PTE pointer
      KVM: selftests: Use vm_get_page_table_entry() in addr_arch_gva2gpa()
      KVM: selftests: Play nice with huge pages when getting PTEs/GPAs
      KVM: selftests: Avoid JMP in non-faulting path of KVM_ASM_SAFE()
      KVM: selftests: Provide error code as a KVM_ASM_SAFE() output
      KVM: selftests: Add X86_FEATURE_PAE and use it calc "fallback" MAXPHYADDR
      KVM: selftests: Refactor X86_FEATURE_* framework to prep for X86_PROPERTY_*
      KVM: selftests: Add X86_PROPERTY_* framework to retrieve CPUID values
      KVM: selftests: Use X86_PROPERTY_MAX_KVM_LEAF in CPUID test
      KVM: selftests: Refactor kvm_cpuid_has() to prep for X86_PROPERTY_* support
      KVM: selftests: Add kvm_cpu_*() support for X86_PROPERTY_*
      KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX
      KVM: selftests: Convert vmx_pmu_caps_test to use X86_PROPERTY_*
      KVM: selftests: Add PMU feature framework, use in PMU event filter test
      KVM: selftests: Add dedicated helpers for getting x86 Family and Model
      KVM: selftests: Add and use KVM helpers for x86 Family and Model
      KVM: selftests: Drop helpers for getting specific KVM supported CPUID entry

Vipin Sharma (7):
      KVM: selftests: Add missing break between -e and -g option in dirty_log_perf_test
      KVM: selftests: Put command line options in alphabetical order in dirty_log_perf_test
      KVM: selftests: Add atoi_paranoid() to catch errors missed by atoi()
      KVM: selftests: Use SZ_* macros from sizes.h in max_guest_memory_test.c
      KVM: selftests: Shorten the test args in memslot_modification_stress_test.c
      KVM: selftests: Add atoi_positive() and atoi_non_negative() for input validation
      KVM: selftests: Allowing running dirty_log_perf_test on specific CPUs

Vishal Annapurve (3):
      KVM: selftests: move common startup logic to kvm_util.c
      KVM: selftests: Add arch specific initialization
      KVM: selftests: Add arch specific post vm creation hook

 arch/x86/include/asm/kvm_host.h                                          |  20 +++---
 tools/arch/x86/include/asm/atomic.h                                      |   7 ++
 tools/include/asm-generic/atomic-gcc.h                                   |  12 ++++
 tools/testing/selftests/kvm/.gitignore                                   |   3 +-
 tools/testing/selftests/kvm/Makefile                                     |   8 ++-
 tools/testing/selftests/kvm/aarch64/aarch32_id_regs.c                    |   3 -
 tools/testing/selftests/kvm/aarch64/arch_timer.c                         |  29 ++------
 tools/testing/selftests/kvm/aarch64/debug-exceptions.c                   |  32 ++++-----
 tools/testing/selftests/kvm/aarch64/hypercalls.c                         |   3 -
 tools/testing/selftests/kvm/aarch64/psci_test.c                          |   1 -
 tools/testing/selftests/kvm/aarch64/vgic_init.c                          |   2 -
 tools/testing/selftests/kvm/aarch64/vgic_irq.c                           |  10 +--
 tools/testing/selftests/kvm/access_tracking_perf_test.c                  |  22 +++---
 tools/testing/selftests/kvm/demand_paging_test.c                         |  24 +++----
 tools/testing/selftests/kvm/dirty_log_perf_test.c                        | 130 ++++++++++++++++++++++-----------
 tools/testing/selftests/kvm/dirty_log_test.c                             |   3 -
 tools/testing/selftests/kvm/include/kvm_util_base.h                      |  28 ++++++++
 tools/testing/selftests/kvm/include/memstress.h                          |  72 +++++++++++++++++++
 tools/testing/selftests/kvm/include/perf_test_util.h                     |  63 ----------------
 tools/testing/selftests/kvm/include/test_util.h                          |  25 +++++++
 tools/testing/selftests/kvm/include/ucall_common.h                       |  10 ++-
 tools/testing/selftests/kvm/include/x86_64/processor.h                   | 364 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 tools/testing/selftests/kvm/include/x86_64/vmx.h                         |   2 +-
 tools/testing/selftests/kvm/kvm_page_table_test.c                        |   6 +-
 tools/testing/selftests/kvm/lib/aarch64/processor.c                      |  18 ++---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c                          | 102 ++++----------------------
 tools/testing/selftests/kvm/lib/elf.c                                    |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c                               |  85 +++++++++++++++++++++-
 tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c}        | 133 ++++++++++++++++++++--------------
 tools/testing/selftests/kvm/lib/riscv/ucall.c                            |  42 ++---------
 tools/testing/selftests/kvm/lib/s390x/ucall.c                            |  39 ++--------
 tools/testing/selftests/kvm/lib/test_util.c                              |  36 ++++++++++
 tools/testing/selftests/kvm/lib/ucall_common.c                           | 103 ++++++++++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} |  37 +++++-----
 tools/testing/selftests/kvm/lib/x86_64/processor.c                       | 225 +++++++++++++++++++++++----------------------------------
 tools/testing/selftests/kvm/lib/x86_64/ucall.c                           |  39 ++--------
 tools/testing/selftests/kvm/lib/x86_64/vmx.c                             |  12 ++--
 tools/testing/selftests/kvm/max_guest_memory_test.c                      |  21 +++---
 tools/testing/selftests/kvm/memslot_modification_stress_test.c           |  38 +++++-----
 tools/testing/selftests/kvm/memslot_perf_test.c                          |  28 ++------
 tools/testing/selftests/kvm/rseq_test.c                                  |   4 --
 tools/testing/selftests/kvm/s390x/memop.c                                |   2 -
 tools/testing/selftests/kvm/s390x/resets.c                               |   2 -
 tools/testing/selftests/kvm/s390x/sync_regs_test.c                       |   3 -
 tools/testing/selftests/kvm/set_memory_region_test.c                     |   5 +-
 tools/testing/selftests/kvm/steal_time.c                                 |   1 -
 tools/testing/selftests/kvm/system_counter_offset_test.c                 |   1 -
 tools/testing/selftests/kvm/x86_64/amx_test.c                            | 105 +++++++--------------------
 tools/testing/selftests/kvm/x86_64/cpuid_test.c                          |  11 +--
 tools/testing/selftests/kvm/x86_64/cr4_cpuid_sync_test.c                 |   3 -
 tools/testing/selftests/kvm/x86_64/emulator_error_test.c                 | 193 -------------------------------------------------
 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c      |  45 ++++++++++++
 tools/testing/selftests/kvm/x86_64/flds_emulation.h                      |  55 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c                        |   3 -
 tools/testing/selftests/kvm/x86_64/hyperv_features.c                     |   3 +-
 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c                  |   5 +-
 tools/testing/selftests/kvm/x86_64/platform_info_test.c                  |   3 -
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c               |  77 +++++---------------
 tools/testing/selftests/kvm/x86_64/set_sregs_test.c                      |   3 -
 tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c   | 111 ++++++++++++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c         |   3 -
 tools/testing/selftests/kvm/x86_64/sync_regs_test.c                      |   3 -
 tools/testing/selftests/kvm/x86_64/userspace_io_test.c                   |   3 -
 tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c             |   3 -
 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c                  |   1 +
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c                   |  19 +----
 tools/testing/selftests/kvm/x86_64/xapic_state_test.c                    |   4 +-
 67 files changed, 1353 insertions(+), 1157 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/memstress.h
 delete mode 100644 tools/testing/selftests/kvm/include/perf_test_util.h
 rename tools/testing/selftests/kvm/lib/{perf_test_util.c => memstress.c} (63%)
 create mode 100644 tools/testing/selftests/kvm/lib/ucall_common.c
 rename tools/testing/selftests/kvm/lib/x86_64/{perf_test_util.c => memstress.c} (68%)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/emulator_error_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/flds_emulation.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
