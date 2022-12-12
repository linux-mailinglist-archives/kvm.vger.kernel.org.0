Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE164A750
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiLLShe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiLLShZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:37:25 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6B412AE5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:23 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 134-20020a63008c000000b00478b9313e0eso7996021pga.9
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cV0LLC+HCNdvxfmizvUcCR3HoP+4upKhCe7XAna94P4=;
        b=PM1U30z95XSwVBUcwkLONjXh8FOmRymYzewstTmmN0m5GpDgEDRD2w6293bsG55xOX
         M1PYEjk/jZ7Bo8rN6H2j5f7wNqk/zjvPNryzLmYxHXPmjepJsAQZPx7qjeuU3NNbVxZ7
         U4Z2O+W+RhTrZd1VF+VaNuzBsd7o+MQiH+SFSW/rXk2TVVvQuNdJBhJH8Rb7TZ7TE/DD
         STbH6sQi2z5cTKOWZFvOq2SOMv2ZzpCBc6swNkk+RbDxP4n8If3MbdUYjIp+eCmpdVLS
         7nQAzk+PfHfbBWpdneIz/Z88hs5h9i4mo+LxFb1s2QVo502Z1T5CT2+LbzMmfBedehIc
         NHcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cV0LLC+HCNdvxfmizvUcCR3HoP+4upKhCe7XAna94P4=;
        b=1mOX6gr+MxTHkh9rhIvnjH9p6pszQepoJ6F+8KCXucJOPp/5F7JZfJTbZs6Euw6Tg/
         ieZRR/OIkxSxI3vY2JG4YssdOs5r1G5cUYtfZ4RgrJVCNhYfQOi5xR+rqY0PMOMm9zES
         13qn3qtubRKDq1g65V7LJkUeGs6nx4/QU7jsAhROFzOoOIfISKVRT6xKWcTgdw4+i9Yz
         P5iD9Oq5zsu5JX0yxd798Xjk59/EBJpShr/30lUanujdd2dOryaXp6KxRfp4+BICKWpr
         uaKPVQG/Pqi9eEW8RGbJWeoc9uENqkbxmHU7YqFtHy3wm/Uq9bOcWjn3vUKQkw1Vpj7L
         D00w==
X-Gm-Message-State: ANoB5pm65Z9UvDrDW45C0M66wYx+/JSuw6ulrsqcfchhrEOr1ibnIeaw
        KW7FJRoolMkSY7hLGQWJIYhlEo+eFaMV
X-Google-Smtp-Source: AA0mqf4Pp6v9GMCglZ2al+1oWG2kdei4LxltxjU/+uQ8UG1qFC/Wq8g1XL1zBB9wdcR4SiiHwmgkSeGseqcy
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a62:b402:0:b0:56e:8f96:6b2e with SMTP id
 h2-20020a62b402000000b0056e8f966b2emr99339691pfn.18.1670870242747; Mon, 12
 Dec 2022 10:37:22 -0800 (PST)
Date:   Mon, 12 Dec 2022 10:37:07 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221212183720.4062037-1-vipinsh@google.com>
Subject: [Patch v4 00/13] Add Hyper-v extended hypercall support in KVM
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Hi,

There are two patch series combined in this one because I have rebased
my patch series (patches 8 to 13) on top of Vitaly's "Hyper-V invariant TSC control
feature" (patches 1 to 7).
https://lore.kernel.org/kvm/87o7szouyr.fsf@ovpn-194-185.brq.redhat.com/

Vitaly's series had some small merge conflicts on the KVM queue branch I
have fixed them in this series, no code changes.

My patches (8 to 13) add Hyper-V extended hypercall support and selftests.

v4:
- Changed vm_vaddr_t to vm_paddr_t in hyperv_extended_hypercalls.
- Changed ASSERT_EXIT_REASON to TEST_ASSERT_KVM_EXIT_REASON

v3: https://lore.kernel.org/lkml/20221205191430.2455108-1-vipinsh@google.com/
- Rebased on top of Vitaly's "Hyper-V invariant TSC control feature"
  series.
- Removed enabling KVM_CAP_HYPERV_ENFORCE_CPUID in
  hyperv_extended_hypercalls test.


v2: https://lore.kernel.org/lkml/20221121234026.3037083-1-vipinsh@google.com/
- Intorduced ASSERT_EXIT_REASON macro and replaced all occurences of
  TEST_ASSERT for vcpu exit reason.
- Skip hyperv_extended_hypercalls test if extended hypercalls are not
  supported by the kernel.
- Rebased with latest KVM queue.
- Addressed all of the comments in patch 6 of v1.

v1: https://lore.kernel.org/lkml/20221105045704.2315186-1-vipinsh@google.com/

RFC: https://lore.kernel.org/lkml/20221021185916.1494314-1-vipinsh@google.com/

Vipin Sharma (6):
  KVM: x86: hyper-v: Use common code for hypercall userspace exit
  KVM: x86: hyper-v: Add extended hypercall support in Hyper-v
  KVM: selftests: Test Hyper-V extended hypercall enablement
  KVM: selftests: Replace hardcoded Linux OS id with HYPERV_LINUX_OS_ID
  KVM: selftests: Make vCPU exit reason test assertion common.
  KVM: selftests: Test Hyper-V extended hypercall exit to userspace

Vitaly Kuznetsov (7):
  x86/hyperv: Add HV_EXPOSE_INVARIANT_TSC define
  KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX
  KVM: x86: Hyper-V invariant TSC control
  KVM: selftests: Rename 'msr->available' to 'msr->fault_exepected' in
    hyperv_features test
  KVM: selftests: Convert hyperv_features test to using
    KVM_X86_CPU_FEATURE()
  KVM: selftests: Test that values written to Hyper-V MSRs are preserved
  KVM: selftests: Test Hyper-V invariant TSC control

 arch/x86/include/asm/hyperv-tlfs.h            |   3 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kernel/cpu/mshyperv.c                |   2 +-
 arch/x86/kvm/cpuid.c                          |  11 +-
 arch/x86/kvm/hyperv.c                         |  74 +++-
 arch/x86/kvm/hyperv.h                         |  27 ++
 arch/x86/kvm/reverse_cpuid.h                  |   7 +
 arch/x86/kvm/x86.c                            |   4 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/psci_test.c |   4 +-
 .../testing/selftests/kvm/include/test_util.h |  10 +
 .../selftests/kvm/include/x86_64/hyperv.h     | 149 +++++---
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../kvm/lib/s390x/diag318_test_handler.c      |   3 +-
 .../selftests/kvm/s390x/sync_regs_test.c      |  15 +-
 .../selftests/kvm/set_memory_region_test.c    |   6 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |   8 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |   8 +-
 .../testing/selftests/kvm/x86_64/debug_regs.c |   2 +-
 .../selftests/kvm/x86_64/flds_emulation.h     |   5 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |   9 +-
 .../selftests/kvm/x86_64/hyperv_evmcs.c       |   8 +-
 .../kvm/x86_64/hyperv_extended_hypercalls.c   |  93 +++++
 .../selftests/kvm/x86_64/hyperv_features.c    | 353 +++++++++++-------
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |   6 +-
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |   7 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   |  14 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |   5 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |   5 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c |   9 +-
 .../kvm/x86_64/nested_exceptions_test.c       |   5 +-
 .../selftests/kvm/x86_64/platform_info_test.c |  14 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |   6 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   9 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   8 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |   8 +-
 .../kvm/x86_64/svm_nested_shutdown_test.c     |   7 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |   6 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |   6 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     |  25 +-
 .../kvm/x86_64/triple_fault_event_test.c      |   9 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |   6 +-
 .../kvm/x86_64/ucna_injection_test.c          |  22 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |   6 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  22 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  11 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |   5 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   7 +-
 .../vmx_exception_with_invalid_guest_state.c  |   4 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |   4 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |   6 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |   8 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   6 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |   6 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |   7 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |   5 +-
 57 files changed, 586 insertions(+), 493 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hypercalls.c

-- 
2.39.0.rc1.256.g54fd8350bd-goog

