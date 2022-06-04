Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295FF53D449
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349907AbiFDBVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349892AbiFDBVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:03 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2330D562F2
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:01 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s9-20020a634509000000b003fc7de146d4so4572677pga.3
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ytk01AywVxfpy/H4xrSv9yFhlhsPnTzrSXpjouRTBH4=;
        b=HaLHDo5ck2L/YcDY4rUqNTZoWZfxc7sic8u0bt1fOK76FXR3junhnfmD+CoEunr1MZ
         ReVOo/aI+Ob3DFXX5ys0EQQ2Uk+n0eryymqKCRY3A7QhJ4ABu5EeF7EErHW5iZbu45nA
         GlOF4N79tMArskdmoLU9iE1b/ALoE6wOl2pJVZFofxasjNIJgnG1go0Yj+Y341o6Hh/Q
         1NY9Y0uuhOYA8YIBeZp7XVR0qL4gy0hK1SOlEiPMwW8w/Ikkj4jV1pOeTkZlOyROi5eM
         VaLBR78SsAvbiiS91zygv8gtAdc/G1qkLUfiDOKcioxO6rY/ybp+9qVirS9GS4EN8Zvu
         MEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ytk01AywVxfpy/H4xrSv9yFhlhsPnTzrSXpjouRTBH4=;
        b=lwFM+vW+YsJCf0OVEHOfqYnQhR8O0u1S2u2QyMMyCzQlBqt+EAEzohPhsyg0epW3EC
         8zLoqJfKPF/4O/EGlstJE7N2iF8Y0nBX2esPgtTMYfMd9iiVmHbh6WibM1z5DZ9W/Pgx
         8b5e410w7eg66+DoTXzMkbpQ9vETM7mWiOSE04CDgNDcE/f8mQzOYIL35BKbyiEKg1FC
         2qiVv9N3pW9nnnVcSiYZDDsxkYuEbyuGaC1ASQ4+vFokX+yVrBNm42XDctzS+EzwX038
         ewLZYqlb3YzdiGe5BlyojpPh8hg4qW6dNdDSPfGmrI89eGVG9GkeaSzxa+9B/mj8552q
         ZDYA==
X-Gm-Message-State: AOAM531C0t/IwyxWZCTkRekG9eYqYpI/ifVk3N/T2mNajNVuqUPOm6Si
        fXPxwjBL0QinSkHsCBdzEC4p+tND50w=
X-Google-Smtp-Source: ABdhPJwIMEkNCPOd2nanx6zZNBLhtK+EcfBxhdXRjiTeKjPGKumpkQYFWdTbxQyfeC++1AL83/6oQ+8fk90=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:3015:b0:163:c6a5:dcb with SMTP id
 o21-20020a170903301500b00163c6a50dcbmr12782538pla.38.1654305660615; Fri, 03
 Jun 2022 18:21:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:16 +0000
Message-Id: <20220604012058.1972195-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 00/42] KVM: selftests: Overhaul Part II - CPUID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

This builds on the selftests overhaul[*].  Build tested on all
architectures, all tests except AMX and SEV run on x86.

https://lore.kernel.org/all/20220603004331.1523888-1-seanjc@google.com

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
 .../selftests/kvm/include/x86_64/vmx.h        |   3 -
 tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +-
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
 42 files changed, 561 insertions(+), 727 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/mmu_role_test.c


base-commit: fa72038b1752a8f9b7ac57b1351d729239e6b6d8
-- 
2.36.1.255.ge46751e96f-goog

