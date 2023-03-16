Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E094C6BD1BB
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbjCPOGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 10:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjCPOGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 10:06:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F40D58B6
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 07:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678975548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/8g7fUH4/RipZKQITUlU71WoFZ3ij/ncUi8oVz8ATl0=;
        b=V4MoRlZ0MAfD+Bm+9ys7ABPX5bsVuODnqbM8wg5HcRl/JcYkpLpXyOwy1FJkOnvRTqHR2I
        WOb97Pn7kVeTVV1UGZjH8C56WVZwk2IQPdC1eRKy+rLs5nscAxY0K/j3ZNLrqRfgAOAlxE
        tTuMT6WXWlAQgPJYQ2/bdb8TIe5kdbY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-kxZo_iKQPka5mMEey_-6_Q-1; Thu, 16 Mar 2023 10:05:44 -0400
X-MC-Unique: kxZo_iKQPka5mMEey_-6_Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 882991C087A0;
        Thu, 16 Mar 2023 14:05:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B00A40D1C5;
        Thu, 16 Mar 2023 14:05:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.3-rc3
Date:   Thu, 16 Mar 2023 10:05:43 -0400
Message-Id: <20230316140543.3253564-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit eeac8ede17557680855031c6f305ece2378af326:

  Linux 6.3-rc2 (2023-03-12 16:36:44 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to f3e707413dbe3920a972d0c2b51175180e7de36b:

  KVM: selftests: Sync KVM exit reasons in selftests (2023-03-14 10:20:10 -0400)

----------------------------------------------------------------
ARM64:

* Address a rather annoying bug w.r.t. guest timer offsetting.  The
  synchronization of timer offsets between vCPUs was broken, leading to
  inconsistent timer reads within the VM.

x86:

* New tests for the slow path of the EVTCHNOP_send Xen hypercall

* Add missing nVMX consistency checks for CR0 and CR4

* Fix bug that broke AMD GATag on 512 vCPU machines

Selftests:

* Skip hugetlb tests if huge pages are not available

* Sync KVM exit reasons

----------------------------------------------------------------
David Woodhouse (2):
      KVM: selftests: Use enum for test numbers in xen_shinfo_test
      KVM: selftests: Add EVTCHNOP_send slow path test to xen_shinfo_test

Marc Zyngier (1):
      KVM: arm64: timers: Convert per-vcpu virtual offset to a global value

Paolo Bonzini (4):
      Merge tag 'kvmarm-fixes-6.3-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      KVM: nVMX: add missing consistency checks for CR0 and CR4
      KVM: nVMX: remove unnecessary #ifdef
      selftests: KVM: skip hugetlb tests if huge pages are not available

Rong Tao (2):
      KVM: VMX: Fix indentation coding style issue
      KVM: VMX: Use tabs instead of spaces for indentation

Sean Christopherson (5):
      KVM: SVM: Fix a benign off-by-one bug in AVIC physical table mask
      KVM: SVM: WARN if GATag generation drops VM or vCPU ID information
      KVM: selftests: Move the guts of kvm_hypercall() to a separate macro
      KVM: selftests: Add helpers to make Xen-style VMCALL/VMMCALL hypercalls
      KVM: selftests: Add macro to generate KVM exit reason strings

Suravee Suthikulpanit (1):
      KVM: SVM: Modify AVIC GATag to support max number of 512 vCPUs

Vipin Sharma (3):
      KVM: selftests: Make vCPU exit reason test assertion common
      KVM: selftests: Print expected and actual exit reason in KVM exit reason assert
      KVM: selftests: Sync KVM exit reasons in selftests

 arch/arm64/include/asm/kvm_host.h                  |   3 +
 arch/arm64/kvm/arch_timer.c                        |  45 +---
 arch/arm64/kvm/hypercalls.c                        |   2 +-
 arch/x86/include/asm/svm.h                         |  12 +-
 arch/x86/kvm/svm/avic.c                            |  37 +++-
 arch/x86/kvm/vmx/nested.c                          |  18 +-
 arch/x86/kvm/vmx/vmenter.S                         |   4 +-
 arch/x86/kvm/vmx/vmx.c                             |  12 +-
 include/kvm/arm_arch_timer.h                       |  15 ++
 tools/testing/selftests/kvm/aarch64/psci_test.c    |   4 +-
 tools/testing/selftests/kvm/include/test_util.h    |   9 +
 .../selftests/kvm/include/x86_64/processor.h       |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |  67 +++---
 .../selftests/kvm/lib/s390x/diag318_test_handler.c |   3 +-
 tools/testing/selftests/kvm/lib/test_util.c        |  25 ++-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  39 ++--
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |  15 +-
 .../testing/selftests/kvm/set_memory_region_test.c |   6 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |   8 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |   8 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c    |   2 +-
 .../testing/selftests/kvm/x86_64/flds_emulation.h  |   5 +-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  |   7 +-
 tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c  |   8 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |  14 +-
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |   6 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |   7 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |  14 +-
 .../testing/selftests/kvm/x86_64/kvm_clock_test.c  |   5 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |   5 +-
 .../selftests/kvm/x86_64/monitor_mwait_test.c      |   9 +-
 .../selftests/kvm/x86_64/nested_exceptions_test.c  |   5 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |  14 +-
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |   6 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   9 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |   8 +-
 .../selftests/kvm/x86_64/svm_int_ctl_test.c        |   8 +-
 .../kvm/x86_64/svm_nested_shutdown_test.c          |   7 +-
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |   6 +-
 .../testing/selftests/kvm/x86_64/svm_vmcall_test.c |   6 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |  25 +--
 .../selftests/kvm/x86_64/triple_fault_event_test.c |   9 +-
 .../selftests/kvm/x86_64/tsc_scaling_sync.c        |   6 +-
 .../selftests/kvm/x86_64/ucna_injection_test.c     |  22 +-
 .../selftests/kvm/x86_64/userspace_io_test.c       |   6 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |  22 +-
 .../selftests/kvm/x86_64/vmx_apic_access_test.c    |  11 +-
 .../kvm/x86_64/vmx_close_while_nested_test.c       |   5 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |   7 +-
 .../vmx_exception_with_invalid_guest_state.c       |   4 +-
 .../kvm/x86_64/vmx_invalid_nested_guest_state.c    |   4 +-
 .../kvm/x86_64/vmx_nested_tsc_scaling_test.c       |   6 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c         |   8 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   6 +-
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c  |   6 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c | 228 +++++++++++----------
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |   5 +-
 57 files changed, 354 insertions(+), 511 deletions(-)

