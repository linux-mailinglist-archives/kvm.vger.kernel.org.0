Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2851D54D19E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346321AbiFOTbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 15:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiFOTbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 15:31:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EA8544E5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:33 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso11106503ybo.20
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 12:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ujbTuF7wHL3jgoldUstjeqPiNhEKNXNdkEJqhtwaExI=;
        b=X/jBqn6uHacP47ES/1gAqIxB1BLuNrKtdCWxFWndHzdGVJ8CGMxvoBpQtGR1dF8jJY
         9x83uNjezzB0p4JKVInBkOid09xuuh/T148qjwdf2VWuX8N0oZfxCG1qOObg/FVO5vLb
         h+3bWX9kSYf/OzwrbdZrZRNQgxiFWN5Tg1RbEl8/3AZYtXG91S6PSRpcGr7YcSkmrzZn
         Xc5V8ZuuGbcZfjJ59Dz5RBFpZpEtsYAhXqmwRSUnX82lYNN+2h6FqvbLW7P9PHvARocz
         PmOBEzFcj9pKEmqEP7tPXBj/7bnFRozP89ZaI3MP9GBoF0BGx8pDhG7Z3Dp2ZZgvZC9t
         nuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ujbTuF7wHL3jgoldUstjeqPiNhEKNXNdkEJqhtwaExI=;
        b=E3EquqzeZncnX9PQ6dSNSjfVqpTVGo8ODa+iE5N6H2iabQHa8+oWVaNeAE3mO09tBg
         4YdlDkZIPFMBdcpeGLsyBvDFX1E4AyGfRoaUi1lcFyngCbHVshjMtm7jy9E3dD4DyfGE
         7ePCLzUClGZO82Rbm1yOIEefi9nwoSbdWBz5vrCrmLt77wvAYe0832RxcSftgBi1gaLW
         VduW5qPM3x9LVpi1XH4kGPg3uIVmB9P+Xuu2GuTAliU1rBioaDLzQGiaHUopYofXIk2L
         4Xzy7fEtoBKAkjKYsTKEO2EiV61H4GnNMFK9FAxnSf5jvNtJW8/YeNPE0SyusBKVNQHF
         166A==
X-Gm-Message-State: AJIora95E/F9rFj5zla8rEv/NiuhN5/w6UqFGy//RD5Jyr33yotB/KwS
        PgWbrNyFTUwWX2dVijALwMpYKbLio/sJYNiw+GaArrcZTXT45tr33SJTyjcGPmbIR4aP36H8+TS
        xLRAI7yXN/dn2aygqyKQm0CnnTL3mu2h8o5/NkfRHHwaI16QOJQQ83AycV2NBnWV34dDi2Z8=
X-Google-Smtp-Source: AGRyM1vyz33n7LCFcwa2kyZ9I73ns2dLaRfSiuOSvnRIOFvFpz87+8u9krZeJDJZaq+RGvfjSs+40qv8+W9wl30sgg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1023:b0:665:12c1:b44d with
 SMTP id x3-20020a056902102300b0066512c1b44dmr1606396ybt.472.1655321492933;
 Wed, 15 Jun 2022 12:31:32 -0700 (PDT)
Date:   Wed, 15 Jun 2022 19:31:12 +0000
Message-Id: <20220615193116.806312-1-coltonlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 0/4] Fix filename reporting in guest asserts
From:   Colton Lewis <coltonlewis@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Cc:     seanjc@google.com, drjones@redhat.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org,
        Colton Lewis <coltonlewis@google.com>
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

Fix filename reporting in guest asserts by way of abstracting out
magic numbers and introducing new reporting macros to report
consistently with less duplication.

Colton Lewis (4):
  KVM: selftests: enumerate GUEST_ASSERT arguments
  KVM: selftests: Increase UCALL_MAX_ARGS to 7
  KVM: selftests: Write REPORT_GUEST_ASSERT macros to pair with
    GUEST_ASSERT
  KVM: selftests: Fix filename reporting in guest asserts

 .../selftests/kvm/aarch64/arch_timer.c        | 12 ++--
 .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  4 +-
 .../selftests/kvm/include/ucall_common.h      | 66 +++++++++++++++++--
 .../testing/selftests/kvm/memslot_perf_test.c |  4 +-
 tools/testing/selftests/kvm/steal_time.c      |  3 +-
 .../kvm/system_counter_offset_test.c          |  3 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  3 +-
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  3 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  2 +-
 .../kvm/x86_64/emulator_error_test.c          |  3 +-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  3 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  3 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  6 +-
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  3 +-
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  3 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  3 +-
 .../selftests/kvm/x86_64/set_boot_cpu_id.c    |  4 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  3 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  2 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  2 +-
 .../selftests/kvm/x86_64/tsc_msrs_test.c      |  4 +-
 .../selftests/kvm/x86_64/userspace_io_test.c  |  4 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      |  5 +-
 .../kvm/x86_64/vmx_apic_access_test.c         |  3 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  2 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  3 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |  2 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  3 +-
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |  2 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  2 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  2 +-
 33 files changed, 100 insertions(+), 73 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

