Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFD50BDBB
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 18:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353440AbiDVRAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 13:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345433AbiDVQ7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 12:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FCAA5FF31
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 09:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650646619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6ojSZXPxoDV2f3YOyvbbjydnRtJRzwjRtv+89W8ar4I=;
        b=PtwcmwT9pl5rm93iN2i6RVAdktCL2ioDmtNjPTIm4OjJQ22SDlzeBrJbI4kKLjbEvBGJl+
        9fJOFSc03i9q2r8Ifr4wvdMVaVKa/lpvOYbrl0zgM5/pyfLqTj71hhmTiIyJAA25GHgamb
        4Dlwi47EEgsOVpcnsoARdaO/x1qh52U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-0TRUTmCUPLGLWrakOyZq_Q-1; Fri, 22 Apr 2022 12:56:56 -0400
X-MC-Unique: 0TRUTmCUPLGLWrakOyZq_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1733A1E1AE4C;
        Fri, 22 Apr 2022 16:56:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDC5A2166B5E;
        Fri, 22 Apr 2022 16:56:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.18-rc4
Date:   Fri, 22 Apr 2022 12:56:55 -0400
Message-Id: <20220422165655.1665574-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit b2d229d4ddb17db541098b83524d901257e93845:

  Linux 5.18-rc3 (2022-04-17 13:57:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e852be8b148e117e25be1c98cf72ee489b05919e:

  kvm: selftests: introduce and use more page size-related constants (2022-04-21 15:41:01 -0400)

The main and larger change here is a workaround for AMD's lack of cache
coherency for encrypted-memory guests.

I have another patch pending, but it's waiting for review from the
architecture maintainers.

----------------------------------------------------------------
RISC-V:

* Remove 's' & 'u' as valid ISA extension

* Do not allow disabling the base extensions 'i'/'m'/'a'/'c'

x86:

* Fix NMI watchdog in guests on AMD

* Fix for SEV cache incoherency issues

* Don't re-acquire SRCU lock in complete_emulated_io()

* Avoid NULL pointer deref if VM creation fails

* Fix race conditions between APICv disabling and vCPU creation

* Bugfixes for disabling of APICv

* Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume

selftests:

* Do not use bitfields larger than 32-bits, they differ between GCC and clang

----------------------------------------------------------------
Atish Patra (2):
      RISC-V: KVM: Remove 's' & 'u' as valid ISA extension
      RISC-V: KVM: Restrict the extensions that can be disabled

Like Xu (1):
      KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog

Mingwei Zhang (2):
      KVM: SVM: Flush when freeing encrypted pages even on SME_COHERENT CPUs
      KVM: SEV: add cache flush to solve SEV cache incoherency issues

Paolo Bonzini (3):
      Merge tag 'kvm-riscv-fixes-5.18-2' of https://github.com/kvm-riscv/linux into HEAD
      kvm: selftests: do not use bitfields larger than 32-bits for PTEs
      kvm: selftests: introduce and use more page size-related constants

Sean Christopherson (9):
      KVM: x86: Don't re-acquire SRCU lock in complete_emulated_io()
      KVM: RISC-V: Use kvm_vcpu.srcu_idx, drop RISC-V's unnecessary copy
      KVM: Add helpers to wrap vcpu->srcu_idx and yell if it's abused
      KVM: Initialize debugfs_dentry when a VM is created to avoid NULL deref
      KVM: x86: Tag APICv DISABLE inhibit, not ABSENT, if APICv is disabled
      KVM: nVMX: Defer APICv updates while L2 is active until L1 is active
      KVM: x86: Pend KVM_REQ_APICV_UPDATE during vCPU creation to fix a race
      KVM: x86: Skip KVM_GUESTDBG_BLOCKIRQ APICv update if APICv is disabled
      KVM: SVM: Simplify and harden helper to flush SEV guest page(s)

Thomas Huth (1):
      KVM: selftests: Silence compiler warning in the kvm_page_table_test

Tom Rix (1):
      KVM: SPDX style and spelling fixes

Wanpeng Li (1):
      x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume

 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   9 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |  16 +-
 arch/powerpc/kvm/book3s_rtas.c                     |   4 +-
 arch/powerpc/kvm/powerpc.c                         |   4 +-
 arch/riscv/include/asm/kvm_host.h                  |   3 -
 arch/riscv/kvm/vcpu.c                              |  37 ++--
 arch/riscv/kvm/vcpu_exit.c                         |   4 +-
 arch/s390/kvm/interrupt.c                          |   4 +-
 arch/s390/kvm/kvm-s390.c                           |   8 +-
 arch/s390/kvm/vsie.c                               |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   1 +
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/kernel/kvm.c                              |  13 ++
 arch/x86/kvm/pmu.h                                 |   9 +
 arch/x86/kvm/svm/pmu.c                             |   1 +
 arch/x86/kvm/svm/sev.c                             |  67 ++++---
 arch/x86/kvm/svm/svm.c                             |   1 +
 arch/x86/kvm/svm/svm.h                             |   2 +
 arch/x86/kvm/vmx/nested.c                          |   5 +
 arch/x86/kvm/vmx/pmu_intel.c                       |   8 +-
 arch/x86/kvm/vmx/vmx.c                             |   5 +
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |  60 +++---
 include/linux/kvm_host.h                           |  26 ++-
 .../selftests/kvm/include/x86_64/processor.h       |  17 ++
 tools/testing/selftests/kvm/kvm_page_table_test.c  |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 202 +++++++++------------
 tools/testing/selftests/kvm/x86_64/amx_test.c      |   1 -
 .../selftests/kvm/x86_64/emulator_error_test.c     |   1 -
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   2 -
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   1 -
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   1 -
 .../testing/selftests/kvm/x86_64/xen_vmcall_test.c |   1 -
 virt/kvm/dirty_ring.c                              |   2 +-
 virt/kvm/kvm_main.c                                |  43 +++--
 virt/kvm/kvm_mm.h                                  |   2 +-
 36 files changed, 316 insertions(+), 252 deletions(-)

