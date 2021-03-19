Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A353426CA
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhCSUZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 16:25:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230206AbhCSUZZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 16:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616185520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PMF1Va7K5vPqZ+/8veih9JjawoEvPslxFD06HPVOZ3Y=;
        b=A9khCmcUNGk/BtEfdnTxnJjOQ8Js0qt9Qmu3/zX3RlPg1MAYeXrNbcKjdDXrYt/UHftgaM
        Q3ZaixwLCi1II2muTDCy7uqOj2jQrBhkW4IH5t6Ir7nVnv32o+whHlv81cnPJQlMfFWr/r
        6zhKLxupEs0V1YAjT3qE9UsnDs7h1IQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-dBMOzxH6M_2ICz1x-dzqSw-1; Fri, 19 Mar 2021 16:25:18 -0400
X-MC-Unique: dBMOzxH6M_2ICz1x-dzqSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5554F801817;
        Fri, 19 Mar 2021 20:25:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0231F1A874;
        Fri, 19 Mar 2021 20:25:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.12-rc4
Date:   Fri, 19 Mar 2021 16:25:16 -0400
Message-Id: <20210319202516.2235406-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 1e28eed17697bcf343c6743f0028cc3b5dd88bf0:

  Linux 5.12-rc3 (2021-03-14 14:41:02 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9ce3746d64132a561bceab6421715e7c04e85074:

  documentation/kvm: additional explanations on KVM_SET_BOOT_CPU_ID (2021-03-19 05:31:32 -0400)

----------------------------------------------------------------
x86:
* new selftests
* fixes for migration with HyperV re-enlightenment enabled
* fix RCU/SRCU usage
* fixes for local_irq_restore misuse false positive

----------------------------------------------------------------
Ben Gardon (3):
      KVM: x86/mmu: Fix RCU usage in handle_removed_tdp_mmu_page
      KVM: x86/mmu: Fix RCU usage when atomically zapping SPTEs
      KVM: x86/mmu: Factor out tdp_iter_return_to_root

Emanuele Giuseppe Esposito (4):
      selftests: kvm: add get_msr_index_features
      selftests: kvm: add _vm_ioctl
      selftests: kvm: add set_boot_cpu_id test
      documentation/kvm: additional explanations on KVM_SET_BOOT_CPU_ID

Sean Christopherson (2):
      KVM: x86/mmu: Store the address space ID in the TDP iterator
      KVM: x86: Protect userspace MSR filter with SRCU, and set atomically-ish

Vitaly Kuznetsov (5):
      KVM: x86: hyper-v: Limit guest to writing zero to HV_X64_MSR_TSC_EMULATION_STATUS
      KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs
      KVM: x86: hyper-v: Track Hyper-V TSC page status
      KVM: x86: hyper-v: Don't touch TSC page values when guest opted for re-enlightenment
      selftests: kvm: Add basic Hyper-V clocksources tests

Wanpeng Li (2):
      KVM: X86: Fix missing local pCPU when executing wbinvd on all dirty pCPUs
      x86/kvm: Fix broken irq restoration in kvm_wait

 Documentation/virt/kvm/api.rst                     |   9 +-
 arch/x86/include/asm/kvm_host.h                    |  34 ++-
 arch/x86/kernel/kvm.c                              |  23 +-
 arch/x86/kvm/hyperv.c                              |  91 +++++++-
 arch/x86/kvm/hyperv.h                              |   1 +
 arch/x86/kvm/mmu/mmu_internal.h                    |   5 +
 arch/x86/kvm/mmu/tdp_iter.c                        |  30 ++-
 arch/x86/kvm/mmu/tdp_iter.h                        |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  40 ++--
 arch/x86/kvm/x86.c                                 | 113 +++++----
 tools/testing/selftests/kvm/.gitignore             |   3 +
 tools/testing/selftests/kvm/Makefile               |   3 +
 tools/testing/selftests/kvm/include/kvm_util.h     |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   7 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   2 -
 .../selftests/kvm/x86_64/get_msr_index_features.c  | 134 +++++++++++
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  | 260 +++++++++++++++++++++
 .../testing/selftests/kvm/x86_64/set_boot_cpu_id.c | 166 +++++++++++++
 18 files changed, 807 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_clock.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/set_boot_cpu_id.c

