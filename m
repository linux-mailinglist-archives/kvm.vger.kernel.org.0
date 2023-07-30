Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9637685A9
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 15:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjG3Nis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 09:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjG3Niq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 09:38:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7961700
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 06:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690724279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DSftxCILntSGnswMPgbYyCjlJ7VpupykbCPvHRv8Qw4=;
        b=PCyx8WLTcdP+SP4idNx1pl88tNOUDYwOPtyIeBM11XMBfLI4n7Ut/XoglD1WH3leLMoWOO
        pAxg3CscyG/Nx9Os2qZoqaoS462l1YQ2PX7L46QzorII5mOh41Sou0bV9zO+v/Gtfw1mWw
        PXNFvY+TRWYZYnry4ZHrI8KR1Y/FvpM=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-lzXbus6AOXW-eGcW8AxYQA-1; Sun, 30 Jul 2023 09:37:54 -0400
X-MC-Unique: lzXbus6AOXW-eGcW8AxYQA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BC9C3C0DDA4;
        Sun, 30 Jul 2023 13:37:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2BD5C57964;
        Sun, 30 Jul 2023 13:37:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM x86 fixes for Linux 6.5-rc4
Date:   Sun, 30 Jul 2023 09:37:53 -0400
Message-Id: <20230730133753.2839616-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 6eaae198076080886b9e7d57f4ae06fa782f90ef:

  Linux 6.5-rc3 (2023-07-23 15:24:10 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 5a7591176c47cce363c1eed704241e5d1c42c5a6:

  KVM: selftests: Expand x86's sregs test to cover illegal CR0 values (2023-07-29 11:05:32 -0400)

Half kernel, half selftests.

----------------------------------------------------------------
x86:

* Do not register IRQ bypass consumer if posted interrupts not supported

* Fix missed device interrupt due to non-atomic update of IRR

* Use GFP_KERNEL_ACCOUNT for pid_table in ipiv

* Make VMREAD error path play nice with noinstr

* x86: Acquire SRCU read lock when handling fastpath MSR writes

* Support linking rseq tests statically against glibc 2.35+

* Fix reference count for stats file descriptors

* Detect userspace setting invalid CR0

Non-KVM:

* Remove coccinelle script that has caused multiple confusion
  ("debugfs, coccinelle: check for obsolete DEFINE_SIMPLE_ATTRIBUTE() usage",
  acked by Greg)

----------------------------------------------------------------
Like Xu (1):
      KVM: x86/irq: Conditionally register IRQ bypass consumer again

Maxim Levitsky (3):
      KVM: x86: VMX: __kvm_apic_update_irr must update the IRR atomically
      KVM: x86: VMX: set irr_pending in kvm_apic_update_irr
      KVM: x86: check the kvm_cpu_get_interrupt result before using it

Peng Hao (1):
      KVM: X86: Use GFP_KERNEL_ACCOUNT for pid_table in ipiv

Sean Christopherson (16):
      KVM: VMX: Make VMREAD error path play nice with noinstr
      KVM: VMX: Use vmread_error() to report VM-Fail in "goto" path
      KVM: x86: Acquire SRCU read lock when handling fastpath MSR writes
      Revert "KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid"
      selftests/rseq: Play nice with binaries statically linked against glibc 2.35+
      KVM: Grab a reference to KVM for VM and vCPU stats file descriptors
      KVM: selftests: Use pread() to read binary stats header
      KVM: selftests: Clean up stats fd in common stats_test() helper
      KVM: selftests: Explicitly free vcpus array in binary stats test
      KVM: selftests: Verify userspace can create "redundant" binary stats files
      KVM: selftests: Verify stats fd can be dup()'d and read
      KVM: selftests: Verify stats fd is usable after VM fd has been closed
      Revert "debugfs, coccinelle: check for obsolete DEFINE_SIMPLE_ATTRIBUTE() usage"
      KVM: x86: Disallow KVM_SET_SREGS{2} if incoming CR0 is invalid
      KVM: VMX: Don't fudge CR0 and CR4 for restricted L2 guest
      KVM: selftests: Expand x86's sregs test to cover illegal CR0 values

 arch/x86/include/asm/kvm-x86-ops.h                 |  1 +
 arch/x86/include/asm/kvm_host.h                    |  3 +-
 arch/x86/kvm/lapic.c                               | 25 +++++---
 arch/x86/kvm/svm/svm.c                             | 16 ++---
 arch/x86/kvm/vmx/vmenter.S                         |  8 +--
 arch/x86/kvm/vmx/vmx.c                             | 64 ++++++++++++++------
 arch/x86/kvm/vmx/vmx_ops.h                         | 12 +++-
 arch/x86/kvm/x86.c                                 | 50 +++++++++++-----
 .../api/debugfs/debugfs_simple_attr.cocci          | 68 ---------------------
 .../testing/selftests/kvm/include/kvm_util_base.h  |  6 +-
 .../testing/selftests/kvm/kvm_binary_stats_test.c  | 68 ++++++++++++++-------
 .../testing/selftests/kvm/x86_64/set_sregs_test.c  | 70 ++++++++++++----------
 tools/testing/selftests/rseq/rseq.c                | 28 +++++++--
 virt/kvm/kvm_main.c                                | 24 ++++++++
 14 files changed, 256 insertions(+), 187 deletions(-)
 delete mode 100644 scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci

