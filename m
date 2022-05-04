Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9451B261
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379109AbiEDWxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355920AbiEDWxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:53:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A7527F3
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:49:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gb16-20020a17090b061000b001d78792caebso1316190pjb.5
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=j76ezE9GuMcgh+azSWqeqxg1EVetPVla9Ox2a6vhqUI=;
        b=go6VGqLC1sTEwjzyH0S2QG3N2xUpKxNByiiICWd0zsYmHH2umI8zq/RwgxLmzGePIz
         hOX+LMxBrNiOD8fVcR8/YtXQ+a38Ll3hiC0LzY5GT0IKVc0owHR++x67hdVNhxU3owGr
         zBvTbKUgverQMXMNOI2p1MyL0tcQcko2ymSYZQe0ywXA8l6ixmr0vwY6k59deQ+I/CE6
         Kdcqm9O6OvtCrxbovFMJI3p5XnVaS4GnKVhCwUPAO3YY2KFRRNvI7mKqrj2U+0uOT9Ff
         RyATmGco9Vom2ji4z6OknaICTjOfOD9voDNPW+1ud/guY/PeMm4QpSKcmn1SgVI1pHVp
         Mabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=j76ezE9GuMcgh+azSWqeqxg1EVetPVla9Ox2a6vhqUI=;
        b=ji+oT1S5po1gtVV9fquFCqtJAqB6RxjWIQHB3htFN9aDaQyaDOAu6CCw2nmDXoJqem
         JN0MfMpZY88RtrWRNbE5o5FRkVX6Wqwuh041WFinrqYbnPX9liFtlh8SXaFLygvc5WN9
         wk6Ygx2gJffxHtnCBwIWswjUPzojoqFs8hWWwuTY/gWoOyZej7QjNAz9hPAeGtZX2MjS
         g/2ffU0I9Vg/dfrLSSPI+MPJ/SjfDyIBeXFXW+at5KpeTvt0Mm6tl1OqSVnNYSBFd1ay
         V5rITW9nHPK5BD/cV0kQMYmwZG8kW6RlSCEDoQcd80ppWeVXyPWB2BE91di1DDDJp/YR
         fJ0g==
X-Gm-Message-State: AOAM530HOk6slo8XkGKLRLlqE/m1sIcHyIkcPCRtDPFvlG3Gu3YSjtb2
        uQUK+pEDxuRpz+Qo7bsKnPNjPMWri4k=
X-Google-Smtp-Source: ABdhPJzHFOm3Jj17tlJfs2w8wz8Q8OFUml5tzr1uaZ9XP1W2YSHNv/yOlcuE4ZF1FT3AnJ3jg29Ea1Oy8F4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:aa8a:b0:1c9:bfd8:9a90 with SMTP id
 l10-20020a17090aaa8a00b001c9bfd89a90mr2253831pjq.118.1651704572147; Wed, 04
 May 2022 15:49:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:47:06 +0000
Message-Id: <20220504224914.1654036-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 000/128] KVM: selftests: Overhaul APIs, purge VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Overhaul KVM's selftest APIs to get selftests to a state where adding new
features and writing tests is less painful/disgusting (I feel dirty every
time I copy+paste VCPU_ID).

The primary theme is to stop treating tests like second class citizens.
Stop hiding vcpu, kvm_vm, etc...  There's no sensitive data/constructs, and
the encapsulation has led to really, really bad and difficult to maintain
code.  E.g. having to pass around the VM just to call a vCPU ioctl(),
arbitrary non-zero vCPU IDs, tests having to care about the vCPU ID in the
first place, etc...

The other theme in the rework is to deduplicate code and try to set us
up for success in the future.  E.g. provide macros/helpers instead of
spamming CTRL-C => CTRL-V (see the -700 LoC), structure the VM creation
APIs to build on one another, etc...

The ridiculous patch count (as opposed to just laughable) is due to
converting each test away from using hardcoded vCPU IDs in a separate patch.
The vast majority of those patches probably aren't worth reviewing in depth,
the changes are mostly mechanical in nature.

However, _running_ non-x86 tests (or tests that have unique non-x86
behavior) would be extremely valuable.  All patches have been compile tested
on x86, arm, risc-v, and s390, but I've only run the tests on x86.  Based on
my track record for the x86+common tests, I will be very, very surprised if
I didn't break any of the non-x86 tests, e.g. pthread_create()'s 'void *'
param tripped me up multiple times.

I believe the only x86 test I haven't run is amx_test, due to lack of
hardware.

Based on kvm/queue + kvm/master (wanted to avoid conflicts with fixes that
are sitting in kvm/master):

  2fd3ab9c169a Merge remote-tracking branch 'kvm/master' into x86/selftests_overhaul
  2764011106d0 (kvm/queue) KVM: VMX: Include MKTME KeyID bits in shadow_zero_check

Cc: kvm@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Oliver Upton <oupton@google.com>

Sean Christopherson (128):
  KVM: selftests: Fix buggy-but-benign check in
    test_v3_new_redist_regions()
  KVM: selftests: Drop stale declarations from kvm_util_base.h
  KVM: selftests: Unconditionally compile KVM selftests with -Werror
  KVM: selftests: Always open VM file descriptors with O_RDWR
  KVM: selftests: Add another underscore to inner ioctl() helpers
  KVM: selftests: Make vcpu_ioctl() a wrapper to pretty print ioctl name
  KVM: selftests: Drop @mode from common vm_create() helper
  KVM: selftests: Split vcpu_set_nested_state() into two helpers
  KVM: sefltests: Use vcpu_ioctl() and __vcpu_ioctl() helpers
  KVM: selftests: Add __vcpu_run() helper
  KVM: selftests: Use vcpu_access_device_attr() in arm64 code
  KVM: selftests: Remove vcpu_get_fd()
  KVM: selftests: Add vcpu_get() to retrieve and assert on vCPU
    existence
  KVM: selftests: Make vm_ioctl() a wrapper to pretty print ioctl name
  KVM: sefltests: Use vm_ioctl() and __vm_ioctl() helpers
  KVM: selftests: Make kvm_ioctl() a wrapper to pretty print ioctl name
  KVM: selftests: Use kvm_ioctl() helpers
  KVM: selftests: Use __KVM_SYSCALL_ERROR() to handle non-KVM syscall
    errors
  KVM: selftests: Make x86-64's register dump helpers static
  KVM: selftests: Get rid of kvm_util_internal.h
  KVM: selftests: Use KVM_IOCTL_ERROR() for one-off arm64 ioctls
  KVM: selftests: Drop @test param from kvm_create_device()
  KVM: selftests: Move KVM_CREATE_DEVICE_TEST code to separate helper
  KVM: selftests: Multiplex return code and fd in __kvm_create_device()
  KVM: selftests: Rename KVM_HAS_DEVICE_ATTR helpers for consistency
  KVM: selftests: Drop 'int' return from asserting *_has_device_attr()
  KVM: selftests: Split get/set device_attr helpers
  KVM: selftests: Add a VM backpointer to 'struct vcpu'
  KVM: selftests: Add vm_create_*() variants to expose/return 'struct
    vcpu'
  KVM: selftests: Push vm_adjust_num_guest_pages() into "w/o vCPUs"
    helper
  KVM: selftests: Use vm_create_without_vcpus() in set_boot_cpu_id
  KVM: selftests: Use vm_create_without_vcpus() in dirty_log_test
  KVM: selftests: Use vm_create_without_vcpus() in hardware_disable_test
  KVM: selftests: Use vm_create_without_vcpus() in psci_cpu_on_test
  KVM: selftests: Rename vm_create() => vm_create_barebones(), drop
    param
  KVM: selftests: Rename vm_create_without_vcpus() => vm_create()
  KVM: selftests: Make vm_create() a wrapper that specifies
    VM_MODE_DEFAULT
  KVM: selftests: Rename xAPIC state test's vcpu struct
  KVM: selftests: Rename vcpu.state => vcpu.run
  KVM: selftests: Rename 'struct vcpu' to 'struct kvm_vcpu'
  KVM: selftests: Return the created vCPU from vm_vcpu_add()
  KVM: selftests: Convert memslot_perf_test away from VCPU_ID
  KVM: selftests: Convert rseq_test away from VCPU_ID
  KVM: selftests: Convert xss_msr_test away from VCPU_ID
  KVM: selftests: Convert vmx_preemption_timer_test away from VCPU_ID
  KVM: selftests: Convert vmx_pmu_msrs_test away from VCPU_ID
  KVM: selftests: Convert vmx_set_nested_state_test away from VCPU_ID
  KVM: selftests: Convert vmx_tsc_adjust_test away from VCPU_ID
  KVM: selftests: Convert mmu_role_test away from VCPU_ID
  KVM: selftests: Convert pmu_event_filter_test away from VCPU_ID
  KVM: selftests: Convert smm_test away from VCPU_ID
  KVM: selftests: Convert state_test away from VCPU_ID
  KVM: selftests: Convert svm_int_ctl_test away from VCPU_ID
  KVM: selftests: Convert svm_vmcall_test away from VCPU_ID
  KVM: selftests: Convert sync_regs_test away from VCPU_ID
  KVM: selftests: Convert hyperv_cpuid away from VCPU_ID
  KVM: selftests: Convert kvm_pv_test away from VCPU_ID
  KVM: selftests: Convert platform_info_test away from VCPU_ID
  KVM: selftests: Convert vmx_nested_tsc_scaling_test away from VCPU_ID
  KVM: selftests: Convert set_sregs_test away from VCPU_ID
  KVM: selftests: Convert vmx_dirty_log_test away from VCPU_ID
  KVM: selftests: Convert vmx_close_while_nested_test away from VCPU_ID
  KVM: selftests: Convert vmx_apic_access_test away from VCPU_ID
  KVM: selftests: Convert userspace_msr_exit_test away from VCPU_ID
  KVM: selftests: Convert vmx_exception_with_invalid_guest_state away
    from VCPU_ID
  KVM: selftests: Convert tsc_msrs_test away from VCPU_ID
  KVM: selftests: Convert kvm_clock_test away from VCPU_ID
  KVM: selftests: Convert hyperv_svm_test away from VCPU_ID
  KVM: selftests: Convert hyperv_features away from VCPU_ID
  KVM: selftests: Convert hyperv_clock away from VCPU_ID
  KVM: selftests: Convert evmcs_test away from VCPU_ID
  KVM: selftests: Convert emulator_error_test away from VCPU_ID
  KVM: selftests: Convert debug_regs away from VCPU_ID
  KVM: selftests: Add proper helper for advancing RIP in debug_regs
  KVM: selftests: Convert amx_test away from VCPU_ID
  KVM: selftests: Convert cr4_cpuid_sync_test away from VCPU_ID
  KVM: selftests: Convert cpuid_test away from VCPU_ID
  KVM: selftests: Convert userspace_io_test away from VCPU_ID
  KVM: selftests: Convert vmx_invalid_nested_guest_state away from
    VCPU_ID
  KVM: selftests: Convert xen_vmcall_test away from VCPU_ID
  KVM: selftests: Convert xen_shinfo_test away from VCPU_ID
  KVM: selftests: Convert dirty_log_test away from VCPU_ID
  KVM: selftests: Convert set_memory_region_test away from VCPU_ID
  KVM: selftests: Convert system_counter_offset_test away from VCPU_ID
  KVM: selftests: Track kvm_vcpu object in tsc_scaling_sync
  KVM: selftests: Convert xapic_state_test away from hardcoded vCPU ID
  KVM: selftests: Convert debug-exceptions away from VCPU_ID
  KVM: selftests: Convert fix_hypercall_test away from VCPU_ID
  KVM: selftests: Convert vgic_irq away from VCPU_ID
  KVM: selftests: Make arm64's guest_get_vcpuid() declaration arm64-only
  KVM: selftests: Move vm_is_unrestricted_guest() to x86-64
  KVM: selftests: Add "arch" to common utils that have arch
    implementations
  KVM: selftests: Return created vcpu from vm_vcpu_add_default()
  KVM: selftests: Rename vm_vcpu_add* helpers to better show
    relationships
  KVM: selftests: Convert set_boot_cpu_id away from global VCPU_IDs
  KVM: selftests: Convert psci_cpu_on_test away from VCPU_ID
  KVM: selftests: Convert hardware_disable_test to pass around vCPU
    objects
  KVM: selftests: Add VM creation helper that "returns" vCPUs
  KVM: selftests: Convert steal_time away from VCPU_ID
  KVM: selftests: Convert arch_timer away from VCPU_ID
  KVM: selftests: Fix typo in vgic_init test
  KVM: selftests: Convert vgic_init away from
    vm_create_default_with_vcpus()
  KVM: selftests: Convert xapic_ipi_test away from *_VCPU_ID
  KVM: selftests: Convert sync_regs_test away from VCPU_ID
  KVM: selftests: Convert s390's "resets" test away from VCPU_ID
  KVM: selftests: Convert memop away from VCPU_ID
  KVM: selftests: Convert s390x/diag318_test_handler away from VCPU_ID
  KVM: selftests: Convert tprot away from VCPU_ID
  KVM: selftests: Use vm_create() in tsc_scaling_sync
  KVM: selftests: Use vm_create_with_vcpus() in max_guest_memory_test
  KVM: selftests: Drop vm_create_default* helpers
  KVM: selftests: Drop @vcpuids param from VM creators
  KVM: selftests: Convert kvm_page_table_test away from reliance on
    vcpu_id
  KVM: selftests: Convert kvm_binary_stats_test away from vCPU IDs
  KVM: selftests: Convert get-reg-list away from its "VCPU_ID"
  KVM: selftests: Stop hardcoding vCPU IDs in vcpu_width_config
  KVM: selftests: Stop conflating vCPU index and ID in perf tests
  KVM: selftests: Remove vcpu_get() usage from dirty_log_test
  KVM: selftests: Require vCPU output array when creating VM with vCPUs
  KVM: selftests: Purge vm+vcpu_id == vcpu silliness
  KVM: selftests: Drop vcpu_get(), rename vcpu_find() => vcpu_exists()
  KVM: selftests: Remove vcpu_state() helper
  KVM: selftests: Open code and drop 'struct kvm_vm' accessors
  KVM: selftests: Drop @slot0_mem_pages from __vm_create_with_vcpus()
  KVM: selftests: Drop @num_percpu_pages from __vm_create_with_vcpus()
  KVM: selftests: Move per-VM/per-vCPU nr pages calculation to
    __vm_create()
  KVM: selftests: Trust that MAXPHYADDR > memslot0 in
    vmx_apic_access_test
  KVM: selftests: Drop DEFAULT_GUEST_PHY_PAGES, open code the magic
    number

 tools/testing/selftests/kvm/Makefile          |    2 +-
 .../selftests/kvm/aarch64/arch_timer.c        |   68 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  |   17 +-
 .../selftests/kvm/aarch64/get-reg-list.c      |   19 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  |   23 +-
 .../selftests/kvm/aarch64/vcpu_width_config.c |   66 +-
 .../testing/selftests/kvm/aarch64/vgic_init.c |  369 +++---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |   35 +-
 .../selftests/kvm/access_tracking_perf_test.c |   81 +-
 .../selftests/kvm/demand_paging_test.c        |   49 +-
 .../selftests/kvm/dirty_log_perf_test.c       |   42 +-
 tools/testing/selftests/kvm/dirty_log_test.c  |   86 +-
 .../selftests/kvm/hardware_disable_test.c     |   29 +-
 .../selftests/kvm/include/aarch64/processor.h |   20 +-
 .../selftests/kvm/include/aarch64/vgic.h      |    6 +-
 .../selftests/kvm/include/kvm_util_base.h     |  690 ++++++++---
 .../selftests/kvm/include/perf_test_util.h    |    5 +-
 .../selftests/kvm/include/riscv/processor.h   |    8 +-
 .../selftests/kvm/include/ucall_common.h      |    2 +-
 .../selftests/kvm/include/x86_64/evmcs.h      |    2 +-
 .../selftests/kvm/include/x86_64/processor.h  |   52 +-
 .../selftests/kvm/kvm_binary_stats_test.c     |   26 +-
 .../selftests/kvm/kvm_create_max_vcpus.c      |    4 +-
 .../selftests/kvm/kvm_page_table_test.c       |   66 +-
 .../selftests/kvm/lib/aarch64/processor.c     |   79 +-
 .../testing/selftests/kvm/lib/aarch64/ucall.c |    9 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   54 +-
 tools/testing/selftests/kvm/lib/elf.c         |    1 -
 tools/testing/selftests/kvm/lib/guest_modes.c |    6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 1076 +++--------------
 .../selftests/kvm/lib/kvm_util_internal.h     |  128 --
 .../selftests/kvm/lib/perf_test_util.c        |   84 +-
 .../selftests/kvm/lib/riscv/processor.c       |  111 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c |    9 +-
 .../kvm/lib/s390x/diag318_test_handler.c      |    9 +-
 .../selftests/kvm/lib/s390x/processor.c       |   44 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c |    8 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  320 ++---
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |    1 -
 .../testing/selftests/kvm/lib/x86_64/ucall.c  |   10 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |    5 +-
 .../selftests/kvm/max_guest_memory_test.c     |   53 +-
 .../kvm/memslot_modification_stress_test.c    |   13 +-
 .../testing/selftests/kvm/memslot_perf_test.c |   28 +-
 tools/testing/selftests/kvm/rseq_test.c       |    9 +-
 tools/testing/selftests/kvm/s390x/memop.c     |   82 +-
 tools/testing/selftests/kvm/s390x/resets.c    |  137 ++-
 .../selftests/kvm/s390x/sync_regs_test.c      |   37 +-
 tools/testing/selftests/kvm/s390x/tprot.c     |   25 +-
 .../selftests/kvm/set_memory_region_test.c    |   43 +-
 tools/testing/selftests/kvm/steal_time.c      |  123 +-
 .../kvm/system_counter_offset_test.c          |   29 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |   33 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |   29 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |   17 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c |   72 +-
 .../kvm/x86_64/emulator_error_test.c          |   65 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   51 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c |   34 +-
 .../kvm/x86_64/get_msr_index_features.c       |   16 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |   25 +-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |   25 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |   51 +-
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |   14 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |   23 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   25 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c  |    6 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      |   20 +-
 .../selftests/kvm/x86_64/platform_info_test.c |   34 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |   71 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |   86 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |   47 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |   17 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   37 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   29 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |   21 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |   16 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |   52 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |   35 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |   20 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |   18 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  165 ++-
 .../kvm/x86_64/vmx_apic_access_test.c         |   27 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |   17 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   13 +-
 .../vmx_exception_with_invalid_guest_state.c  |   62 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |   18 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |   19 +-
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  |   25 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |   30 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |   86 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   13 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   48 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   |   60 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |   62 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |   17 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |   10 +-
 97 files changed, 2607 insertions(+), 3354 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/lib/kvm_util_internal.h


base-commit: 2fd3ab9c169a9ee91ca2a1e14cc454b03c86225e
-- 
2.36.0.464.gb9c8b46e94-goog

