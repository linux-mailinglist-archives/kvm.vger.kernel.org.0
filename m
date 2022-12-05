Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8364316D
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 20:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiLETOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 14:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiLETOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 14:14:41 -0500
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578291F2FC
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 11:14:40 -0800 (PST)
Received: by mail-oo1-xc49.google.com with SMTP id x6-20020a4a2a46000000b0049ca27b1507so4777948oox.5
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 11:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pcO8knyiGDbFIfMjbOgDj3hfHzch+YeaDL5Ano9tTdg=;
        b=INmgLualos+oybZKFZwP2HhkuPQ1uOH4G3pvi+LqGBVBQ0ECqs/2znFA5G+49vdVZt
         M3MgD4eE2R11m0AZ11wELWQ/wss3KXka1J2zfYzVg7WsiOjWG74u3JVnm+9lc0Gf17XW
         2dxxoZ7jPNIEiZ5LBObcm7TT2mR5lZ9GEfWImBuJkIDCeU0xFENNgQ5p/hW7CeGXEmjQ
         5leQnDtBiOMXG58CQwnynd7hqeC6Bf9Mv09MAYvgPSewiPU+ZB5ierKUyViU8qGOWkwj
         CX8I1fz7l/0Cobjx40GL0vk77NSz8MQa+UNfqNp8UKW2/4nvaJoqJxUDhOIMH5xI8uAK
         +fLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pcO8knyiGDbFIfMjbOgDj3hfHzch+YeaDL5Ano9tTdg=;
        b=V+zsNajlv2Hym8D4GVeb+BF591eM8hdIjIVEcg6LGFofn4gQyoNXG+g8zjM1rLxyp8
         jLaH9P7zq5VUJpyBbO/3R3WEh2BMmpolyuIKiviJgEaAwlZo9iEgXh+wn/1OeilhQscV
         o52b2ID/ler4fWIfKdJ/pyFeJIHQ3aItWIgJ5V9QgGjKEvs/JQ5TgakvkjEYeXleIwRo
         Gdvto21uqyFUX42gE3NJ4swmSNKLA/Iy04EiQOp9KCewgEfmDaY8iK7Li08JZd/ihVak
         ziWPbCG5GzUSxUlk7Mf1/J/f2aBOe3t8fjGd/zi3NSKVPliUnnZYcSrK1iFlLIywxz8U
         WQtA==
X-Gm-Message-State: ANoB5pl8DjjGp0BI7wul1eUwko4Hu8XePp2SlLVAyg3IfaL2fgLSNSqp
        t+wINFqcsgiXTkvehiyI/QlfWF0TI8gf
X-Google-Smtp-Source: AA0mqf5BzkRrJJpeplfASCRvD3cdZ6hCepT9ubKMW5wrpk+knufclse4p3hrETMeNf4B2X/EAJoEAjcW/Ar1
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6870:aa88:b0:143:ca23:34a9 with SMTP
 id gr8-20020a056870aa8800b00143ca2334a9mr20657540oab.235.1670267679700; Mon,
 05 Dec 2022 11:14:39 -0800 (PST)
Date:   Mon,  5 Dec 2022 11:14:17 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221205191430.2455108-1-vipinsh@google.com>
Subject: [Patch v3 00/13] Add Hyper-v extended hypercall support in KVM
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

v3:
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
2.39.0.rc0.267.gcb52ba06e7-goog

