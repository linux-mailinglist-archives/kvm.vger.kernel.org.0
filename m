Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57401325859
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 22:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhBYVEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 16:04:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234927AbhBYVAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 16:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614286759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zhZABIuY3Pbl4Q8JCgU55Qt/FN0W7Zsvua1ePi1iSNU=;
        b=D4ycHhejTtv+BoKc5OtRelIiQvsBuYRZTnAfVgg4AWI5Bxh7DKfjaPp+O1sM73TMKxLBvj
        p2P1Vw7A1r1/EJFdz2gNnoLF84Yoi8+hHb7/77LFJOWJ39lZqrotfxTIcY4LLiVW9C5Hf+
        1+bJsUW33xN4wimwM7sxiubvsfq9IZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-j4eOeKVRNtK6n3D8Ldac1Q-1; Thu, 25 Feb 2021 15:59:15 -0500
X-MC-Unique: j4eOeKVRNtK6n3D8Ldac1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DC7A50741;
        Thu, 25 Feb 2021 20:59:13 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CF1861F55;
        Thu, 25 Feb 2021 20:59:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for Linux 5.12
Date:   Thu, 25 Feb 2021 15:59:12 -0500
Message-Id: <20210225205912.61184-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8c6e67bec3192f16fa624203c8131e10cc4814ba:

  Merge tag 'kvmarm-5.12' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2021-02-12 11:23:44 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2df8d3807ce7f75bb975f1aeae8fc6757527c62d:

  KVM: SVM: Fix nested VM-Exit on #GP interception handling (2021-02-25 05:13:05 -0500)

----------------------------------------------------------------
x86:
- take into account HVA before retrying on MMU notifier race
- fixes for nested AMD guests without NPT
- allow INVPCID in guest without PCID
- disable PML in hardware when not in use
- MMU code cleanups

----------------------------------------------------------------
David Stevens (1):
      KVM: x86/mmu: Consider the hva in mmu_notifier retry

Ignacio Alvarado (1):
      selftests: kvm: add hardware_disable test

Like Xu (1):
      KVM: vmx/pmu: Fix dummy check if lbr_desc->event is created

Lukas Bulwahn (1):
      KVM: Documentation: rectify rst markup in KVM_GET_SUPPORTED_HV_CPUID

Makarand Sonare (1):
      KVM: VMX: Dynamically enable/disable PML based on memslot dirty logging

Maxim Levitsky (2):
      KVM: VMX: read idt_vectoring_info a bit earlier
      KVM: nSVM: move nested vmrun tracepoint to enter_svm_guest_mode

Paolo Bonzini (4):
      selftests: kvm: avoid uninitialized variable warning
      KVM: nSVM: fix running nested guests when npt=0
      KVM: nVMX: no need to undo inject_page_fault change on nested vmexit
      KVM: nSVM: prepare guest save area while is_guest_mode is true

Sean Christopherson (17):
      KVM: SVM: Intercept INVPCID when it's disabled to inject #UD
      KVM: x86: Advertise INVPCID by default
      KVM: VMX: Allow INVPCID in guest without PCID
      KVM: x86/mmu: Expand collapsible SPTE zap for TDP MMU to ZONE_DEVICE and HugeTLB pages
      KVM: x86/mmu: Split out max mapping level calculation to helper
      KVM: x86/mmu: Pass the memslot to the rmap callbacks
      KVM: x86/mmu: Consult max mapping level when zapping collapsible SPTEs
      KVM: nVMX: Disable PML in hardware when running L2
      KVM: x86/mmu: Expand on the comment in kvm_vcpu_ad_need_write_protect()
      KVM: x86/mmu: Make dirty log size hook (PML) a value, not a function
      KVM: x86: Move MMU's PML logic to common code
      KVM: x86: Further clarify the logic and comments for toggling log dirty
      KVM: x86/mmu: Don't set dirty bits when disabling dirty logging w/ PML
      KVM: x86: Fold "write-protect large" use case into generic write-protect
      KVM: x86/mmu: Remove a variety of unnecessary exports
      KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault
      KVM: SVM: Fix nested VM-Exit on #GP interception handling

 Documentation/virt/kvm/api.rst                     |   2 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   2 +-
 arch/x86/include/asm/kvm-x86-ops.h                 |   6 +-
 arch/x86/include/asm/kvm_host.h                    |  36 +---
 arch/x86/kvm/cpuid.c                               |   2 +-
 arch/x86/kvm/mmu/mmu.c                             | 224 ++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h                    |   7 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |  14 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  66 +-----
 arch/x86/kvm/mmu/tdp_mmu.h                         |   3 +-
 arch/x86/kvm/svm/nested.c                          |  48 +++--
 arch/x86/kvm/svm/svm.c                             |  22 +-
 arch/x86/kvm/vmx/nested.c                          |  37 ++--
 arch/x86/kvm/vmx/pmu_intel.c                       |   4 +-
 arch/x86/kvm/vmx/vmx.c                             | 112 ++++-------
 arch/x86/kvm/vmx/vmx.h                             |   2 +
 arch/x86/kvm/x86.c                                 | 143 +++++++------
 include/linux/kvm_host.h                           |  25 ++-
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../testing/selftests/kvm/hardware_disable_test.c  | 165 +++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   3 +-
 virt/kvm/kvm_main.c                                |  29 ++-
 24 files changed, 533 insertions(+), 423 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/hardware_disable_test.c

