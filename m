Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5149868A796
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 02:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjBDBqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 20:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjBDBp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 20:45:58 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D690A07E7
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 17:45:55 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id s16-20020a17090aba1000b002303782fcd8so5072276pjr.9
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 17:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CjIJEhAYbMSv6XJ6YPRSrYusHoPT/o7sKHbXDwqrZAg=;
        b=QecYNx8Ora54T0SLOnSkFDljXnyyMtJNe3ass//2WlUOCd5RflFrtCU9Q575bcu2LT
         Qaq0JzEv9jMiY6uyoNi2VZrLAoomU6ZmSMsN3cR8M2MqZIYktpZ/VDgL4aLEJJ8KF8Wm
         bHTQF0ThYIIR48wEc5y3Fqp2X3DothPzD3xLLKaagSfnuSR7MlYO3XacK9+UxxqI0Ysa
         rjNY34G6CcMp54S3yrXX6eJDU1uSzpYPpbVIWkul2zPoVRCCDwAwSjJTkbxIJGrEwUJf
         v0En1igEE9Xi3/JwJpmWLLJ+smT/gwaX7JCTTz2vaYBx4zBMIQcHByzwsfSdnquXgaZR
         mxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CjIJEhAYbMSv6XJ6YPRSrYusHoPT/o7sKHbXDwqrZAg=;
        b=RTu3H+4r/JLVkLx1eKkpqSr7MIPyjalYl6WPyCQbGLkXAHCvPq+K0yfeABDXLMs1qF
         yN2f4dJwqzYSssY19/ka8mRzCuXNVrOvNd47m3RG1DcMXMN42zr2h3YfzdbphdBxoF7/
         e94tjOA55nrLyDObRAxs85Z9QLrR+dapNIwRyH2Zucw9QzneKmMLcpgk810lbgiOvKll
         AdLD58o6FmdRDh7RvsQtZQAELwotFNkhGWxAXwmSxKwsuK/OZlR6rlbDWrzO1gg13yPA
         /ZTodmN98v+8sr821oITU1owf5b6FXaE8PZ0qG2IXpIWzACjJAs5c5JzXiJMYGkVa6PD
         Rc4w==
X-Gm-Message-State: AO0yUKWlDtVPp8fF6TTnyusbjq4uNghJawg83ZOCHFDEWHfGstIIVnlZ
        03aH+PwJclZTm0bi2bIul+TjYyCCZfT7
X-Google-Smtp-Source: AK7set9xkoWukRUDEh7W2nt6n3Zt+7FBDZYp16LPMhz90fIkU20kwi0NZXZTmudtL8RhYT07MPMazJc6jFZb
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:c94c:b0:196:77f2:559d with SMTP id
 i12-20020a170902c94c00b0019677f2559dmr2884957pla.18.1675475154953; Fri, 03
 Feb 2023 17:45:54 -0800 (PST)
Date:   Fri,  3 Feb 2023 17:45:43 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204014547.583711-1-vipinsh@google.com>
Subject: [Patch v2 0/4] Common KVM exit reason test assertions and exit reason sync
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     dmatlack@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch seris is extracted from
https://lore.kernel.org/lkml/20221212183720.4062037-1-vipinsh@google.com/
series.

Specifically, patch 12 is taken out from there and now expanded in to
this series.

This patch series contains following changes:

Patch 1 & 2:
  Make a macro to clean up all KVM exit reason test assertion.

  There are few places where explicit run->exit_reason are used but they
  cannot be replaced with current macro.

  I used following command KVM selftests directory and changed each
  occurrence:
    grep "run->exit_reason" -nir ./

Patch 3:
  This is from Sean Christopherson. Adding a macro to generate KVM
  exit strings.

Patch 4:
  Sync KVM_EXIT_* reasons to sefltests. Many reasons are not present in
  selftest code.

v2:
- Improve test assert message.
- Add macro to generate KVM_EXIT_* reason strings.
- Update selftests KVM_EXIT_ reasons to latest version.

v1: https://lore.kernel.org/lkml/20221212183720.4062037-13-vipinsh@google.com/

Sean Christopherson (1):
  KVM: selftests: Add macro to generate KVM exit reason strings

Vipin Sharma (3):
  KVM: selftests: Make vCPU exit reason test assertion common
  KVM: selftests: Print expected and actual exit reason in KVM exit
    reason assert
  KVM: selftests: Sync KVM exit reasons in selftests

 .../testing/selftests/kvm/aarch64/psci_test.c |  4 +-
 .../testing/selftests/kvm/include/test_util.h |  9 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 66 ++++++++++++-------
 .../kvm/lib/s390x/diag318_test_handler.c      |  3 +-
 .../selftests/kvm/s390x/sync_regs_test.c      | 15 +----
 .../selftests/kvm/set_memory_region_test.c    |  6 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c |  8 +--
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  8 +--
 .../testing/selftests/kvm/x86_64/debug_regs.c |  2 +-
 .../selftests/kvm/x86_64/flds_emulation.h     |  5 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  7 +-
 .../selftests/kvm/x86_64/hyperv_evmcs.c       |  8 +--
 .../selftests/kvm/x86_64/hyperv_features.c    | 14 +---
 .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  6 +-
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  7 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 14 +---
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  5 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c |  9 +--
 .../kvm/x86_64/nested_exceptions_test.c       |  5 +-
 .../selftests/kvm/x86_64/platform_info_test.c | 14 +---
 .../kvm/x86_64/pmu_event_filter_test.c        |  6 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |  9 +--
 .../testing/selftests/kvm/x86_64/state_test.c |  8 +--
 .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  8 +--
 .../kvm/x86_64/svm_nested_shutdown_test.c     |  7 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +-
 .../selftests/kvm/x86_64/svm_vmcall_test.c    |  6 +-
 .../selftests/kvm/x86_64/sync_regs_test.c     | 25 ++-----
 .../kvm/x86_64/triple_fault_event_test.c      |  9 +--
 .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  6 +-
 .../kvm/x86_64/ucna_injection_test.c          | 22 ++-----
 .../selftests/kvm/x86_64/userspace_io_test.c  |  6 +-
 .../kvm/x86_64/userspace_msr_exit_test.c      | 22 ++-----
 .../kvm/x86_64/vmx_apic_access_test.c         | 11 +---
 .../kvm/x86_64/vmx_close_while_nested_test.c  |  5 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  7 +-
 .../vmx_exception_with_invalid_guest_state.c  |  4 +-
 .../x86_64/vmx_invalid_nested_guest_state.c   |  4 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  6 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  8 +--
 .../kvm/x86_64/vmx_tsc_adjust_test.c          |  6 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  6 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  7 +-
 .../selftests/kvm/x86_64/xen_vmcall_test.c    |  5 +-
 45 files changed, 111 insertions(+), 318 deletions(-)

-- 
2.39.1.519.gcb327c4b5f-goog

