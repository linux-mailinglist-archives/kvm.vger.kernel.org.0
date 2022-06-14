Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404AB54BB1F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbiFNUHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbiFNUHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:15 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65E04D694
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q2-20020a170902dac200b00168b3978426so5339208plx.17
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Y/tp3P4CyEsqzCtz4TsuZA5xtlM3kgJ4gCUD8ryHEG8=;
        b=LM5NLpFv0ecv33NSvoH3NaPLT8NKC7pq0R6a+yifO4O5F/4vxQRN+rP8PQYVwxtMj+
         CG6ky41IVB++vObWXU+neCQqHF5Mvmy8dZkY65cEwL/iMMhmkEeFcg2LkRwUBN7HvW0E
         zZDWQ7CK81fzQkKKbilDYUQFgtnUpw0X/0iAl9nlnzSdGdSKwesWzk+XWhv1dWYEesLI
         IG7xJcnd/okXibBS4swJLVK9CLAd/NrlMsa8n4NAjd9dqjXObDUQfXDzi/r6z3uY1cSs
         3Fx456rUKjS6c0OK+jb+eAsi9lvjq/burjHAKqH3XZKQg08DHbtTj9zyn1kVGNZQq4tq
         M0iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Y/tp3P4CyEsqzCtz4TsuZA5xtlM3kgJ4gCUD8ryHEG8=;
        b=FCnC5S65SXzNdfsRRnZjExNWTUoTn2eVLOVF4G95LsALARhGp+vXtlWJuBUnrsaMSI
         acU66l8g1+Yr3hbBnLyVvo8oGc3fJowmEb7OjH+v6YonkKYWSAt6C2uzEKznIJ5ZLM2b
         DkCXGDfGZKyxPp9k+O6yRa0eQ0zOAC3vBKR9cTvbHg3hBQQ2Y/jOyrQI5t2HBEdWt5AP
         TWbCEVjYh6na4Xi7pH4En9Jx63C7KEHyHjlluTtipS9fHjPHM0dHWQUYqhJc2hC6laqP
         JBiP90jjNlTDTLmBMZWbLUVXLxlXs1es1WE+f8jn3774t7s0vFPPhZWQq3NFR2YcLP51
         9dYQ==
X-Gm-Message-State: AJIora9VnYtiQszC5wZXnesTbtti5shvZg4APM7bhmYATx0DczEaDEki
        YB3/wUthlRJWQrmwpITQ490NxuadkPQ=
X-Google-Smtp-Source: AGRyM1tzh8InvhFptD9zp9wAktQRzqIcQ2mfWPRhpqsYFMyFyzOayCA/ijklVnVj/2BIrng8AicyCX/fU1o=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8f87:b0:166:3cf5:335f with SMTP id
 z7-20020a1709028f8700b001663cf5335fmr5790098plo.119.1655237233229; Tue, 14
 Jun 2022 13:07:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:25 +0000
Message-Id: <20220614200707.3315957-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 00/42] KVM: selftests: Overhaul Part II - CPUID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Rework (x86) KVM selftests' handling of CPUID to track CPUID on a per-vCPU
basis, and add X86_FEATURE_* / CPUID support in the style of KVM-Unit-Tests,
e.g. add kvm_cpu_has(), vcpu_{clear,set}_cpuid_feature(), this_cpu_has(),
etc...

The two main goals are to simplify checking or modifying CPUID-based
features, and to eliminate the absolutely awful behavior of modifying the
global "cpuid" that is cached by kvm_get_supported_cpuid().

Build tested on all architectures, all tests except AMX run on x86
(SEV INIT_EX wasn't broken, PEBKAC).

v2: Rebased to kvm/queue.

v1: https://lore.kernel.org/all/20220604012058.1972195-1-seanjc@google.com

Sean Christopherson (42):
  KVM: selftests: Set KVM's supported CPUID as vCPU's CPUID during
    recreate
  KVM: sefltests: Use CPUID_XSAVE and CPUID_OSXAVE instead of
    X86_FEATURE_*
  KVM: selftests: Add framework to query KVM CPUID bits
  KVM: selftests: Use kvm_cpu_has() in the SEV migration test
  KVM: selftests: Use kvm_cpu_has() for nested SVM checks
  KVM: selftests: Use kvm_cpu_has() for nested VMX checks
  KVM: selftests: Use kvm_cpu_has() to query PDCM in PMU selftest
  KVM: selftests: Drop redundant vcpu_set_cpuid() from PMU selftest
  KVM: selftests: Use kvm_cpu_has() for XSAVES in XSS MSR test
  KVM: selftests: Check for _both_ XTILE data and cfg in AMX test
  KVM: selftests: Use kvm_cpu_has() in AMX test
  KVM: selftests: Use kvm_cpu_has() for XSAVE in cr4_cpuid_sync_test
  KVM: selftests: Remove the obsolete/dead MMU role test
  KVM: selftests: Use kvm_cpu_has() for KVM's PV steal time
  KVM: selftests: Use kvm_cpu_has() for nSVM soft INT injection test
  KVM: selftests: Verify that kvm_cpuid2.entries layout is unchanged by
    KVM
  KVM: selftests: Split out kvm_cpuid2_size() from allocate_kvm_cpuid2()
  KVM: selftests: Cache CPUID in struct kvm_vcpu
  KVM: selftests: Don't use a static local in
    vcpu_get_supported_hv_cpuid()
  KVM: selftests: Rename and tweak get_cpuid() to get_cpuid_entry()
  KVM: selftests: Use get_cpuid_entry() in
    kvm_get_supported_cpuid_index()
  KVM: selftests: Add helpers to get and modify a vCPU's CPUID entries
  KVM: selftests: Use vm->pa_bits to generate reserved PA bits
  KVM: selftests: Add and use helper to set vCPU's CPUID maxphyaddr
  KVM: selftests: Use vcpu_get_cpuid_entry() in PV features test (sort
    of)
  KVM: selftests: Use vCPU's CPUID directly in Hyper-V test
  KVM: selftests: Use vcpu_get_cpuid_entry() in CPUID test
  KVM: selftests: Use vcpu_{set,clear}_cpuid_feature() in nVMX state
    test
  KVM: selftests: Use vcpu_clear_cpuid_feature() to clear x2APIC
  KVM: selftests: Make get_supported_cpuid() returns "const"
  KVM: selftests: Set input function/index in raw CPUID helper(s)
  KVM: selftests: Add this_cpu_has() to query X86_FEATURE_* via cpuid()
  KVM: selftests: Use this_cpu_has() in CR4/CPUID sync test
  KVM: selftests: Use this_cpu_has() to detect SVM support in L1
  KVM: selftests: Drop unnecessary use of
    kvm_get_supported_cpuid_index()
  KVM: selftests: Rename kvm_get_supported_cpuid_index() to
    __..._entry()
  KVM: selftests: Inline "get max CPUID leaf" helpers
  KVM: selftests: Check KVM's supported CPUID, not host CPUID, for XFD
  KVM: selftests: Skip AMX test if ARCH_REQ_XCOMP_GUEST_PERM isn't
    supported
  KVM: selftests: Clean up requirements for XFD-aware XSAVE features
  KVM: selftests: Use the common cpuid() helper in
    cpu_vendor_string_is()
  KVM: selftests: Drop unused SVM_CPUID_FUNC macro

 tools/testing/selftests/kvm/.gitignore        |   1 -
 tools/testing/selftests/kvm/Makefile          |   1 -
 .../selftests/kvm/include/kvm_util_base.h     |  14 +
 .../selftests/kvm/include/x86_64/processor.h  | 297 +++++++++++++++---
 .../selftests/kvm/include/x86_64/svm.h        |   2 -
 .../selftests/kvm/include/x86_64/svm_util.h   |  15 -
 .../selftests/kvm/include/x86_64/vmx.h        |   2 -
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +-
 .../selftests/kvm/lib/x86_64/perf_test_util.c |   2 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 289 +++++++----------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 -
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  12 -
 tools/testing/selftests/kvm/steal_time.c      |   4 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  48 +--
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  89 +++---
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  21 +-
 .../kvm/x86_64/emulator_error_test.c          |  10 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |   2 +-
 .../selftests/kvm/x86_64/hyperv_cpuid.c       |  14 +-
 .../selftests/kvm/x86_64/hyperv_features.c    | 126 ++++----
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |   2 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  14 +-
 .../selftests/kvm/x86_64/mmu_role_test.c      | 137 --------
 .../kvm/x86_64/pmu_event_filter_test.c        |  14 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  28 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  13 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |   9 +-
 .../testing/selftests/kvm/x86_64/state_test.c |   7 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |   2 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  10 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |   2 +-
 .../kvm/x86_64/triple_fault_event_test.c      |   2 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |   2 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |   2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |   2 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |   2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |   2 +-
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  14 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |   4 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  22 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |   2 +-
 .../selftests/kvm/x86_64/xapic_state_test.c   |  10 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |   8 +-
 43 files changed, 562 insertions(+), 727 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c


base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
-- 
2.36.1.476.g0c4daa206d-goog

