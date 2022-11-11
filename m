Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A322625CF3
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 15:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiKKOZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 09:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234345AbiKKOZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 09:25:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17261C12
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 06:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668176616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DQvaK18xpntOJnjbHREtfUicOEQ4gaHEqXXR6rsGJ4Q=;
        b=BtKbbQ8u3vMfOa1cb3D0838wKxEOqXMrwA7yXGnRvo98f38Sn9F7ftUu1+Opk6X20GZCxc
        wn2Y1VxU//UD9Pi2vezNeRUDh6zpM3EgjnoHig9JHP5gLeeqj7xESY0CZDtxYMcClSnBIO
        LG63qjY0cOGwhaz5TEWBnDWl3TG6Dbg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-66ppEtGBO9Gny7j9BZkDsg-1; Fri, 11 Nov 2022 09:23:33 -0500
X-MC-Unique: 66ppEtGBO9Gny7j9BZkDsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3C073817A6D;
        Fri, 11 Nov 2022 14:23:32 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6F97C15BA8;
        Fri, 11 Nov 2022 14:23:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.1-rc6
Date:   Fri, 11 Nov 2022 09:23:32 -0500
Message-Id: <20221111142332.1352383-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

  Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 6d3085e4d89ad7e6c7f1c6cf929d903393565861:

  KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range() (2022-11-11 07:19:46 -0500)

This is a pretty large diffstat for this time of the release.  The main
culprit is a reorganization of the AMD assembly trampoline, allowing
percpu variables to be accessed early.  This is needed for the return
stack depth tracking retbleed mitigation that will be in 6.2, but it
also makes it possible to tighten the IBRS restore on vmexit.  The latter
change is a long tail of the spectrev2/retbleed patches (the corresponding
Intel change was simpler and went in already last June), which is why I
am including it right now instead of sharing a topic branch with tip.

Being assembly and being rich in comments makes the line count balloon
a bit, but I am pretty confident in the change (famous last words)
because the reorganization actually makes everything simpler and more
understandable than before.  It has also had external review and has been
tested on the aforementioned 6.2 changes, which explode quite brutally
without the fix.

Apart from this, things are pretty normal.  Do shout metaphorically if
you disagree.

Thanks,

Paolo

----------------------------------------------------------------
s390:

* PCI fix

* PV clock fix

x86:

* Fix clash between PMU MSRs and other MSRs

* Prepare SVM assembly trampoline for 6.2 retbleed mitigation
  and for...

* ... tightening IBRS restore on vmexit, moving it before
  the first RET or indirect branch

* Fix log level for VMSA dump

* Block all page faults during kvm_zap_gfn_range()

Tools:

* kvm_stat: fix incorrect detection of debugfs

* kvm_stat: update vmexit definitions

----------------------------------------------------------------
Like Xu (3):
      KVM: x86/pmu: Do not speculatively query Intel GP PMCs that don't exist yet
      KVM: x86/pmu: Limit the maximum number of supported Intel GP counters
      KVM: x86/pmu: Limit the maximum number of supported AMD GP counters

Matthias Gerstner (1):
      tools/kvm_stat: fix incorrect detection of debugfs

Nico Boehr (1):
      KVM: s390: pv: don't allow userspace to set the clock under PV

Paolo Bonzini (12):
      KVM: x86: use a separate asm-offsets.c file
      KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm
      KVM: SVM: adjust register allocation for __svm_vcpu_run()
      KVM: SVM: retrieve VMCB from assembly
      KVM: SVM: remove unused field from struct vcpu_svm
      KVM: SVM: remove dead field from struct svm_cpu_data
      KVM: SVM: do not allocate struct svm_cpu_data dynamically
      KVM: SVM: move guest vmsave/vmload back to assembly
      KVM: SVM: restore host save area from assembly
      KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
      x86, KVM: remove unnecessary argument to x86_virt_spec_ctrl and callers
      Merge tag 'kvm-s390-master-6.1-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD

Peter Gonda (1):
      KVM: SVM: Only dump VMSA to klog at KERN_DEBUG level

Rafael Mendonca (1):
      KVM: s390: pci: Fix allocation size of aift kzdev elements

Rong Tao (1):
      tools/kvm_stat: update exit reasons for vmx/svm/aarch64/userspace

Sean Christopherson (1):
      KVM: x86/mmu: Block all page faults during kvm_zap_gfn_range()

 Documentation/virt/kvm/devices/vm.rst |   3 +
 arch/s390/kvm/kvm-s390.c              |  26 ++--
 arch/s390/kvm/kvm-s390.h              |   1 -
 arch/s390/kvm/pci.c                   |   2 +-
 arch/x86/include/asm/kvm_host.h       |   7 +-
 arch/x86/include/asm/spec-ctrl.h      |  10 +-
 arch/x86/kernel/asm-offsets.c         |   6 -
 arch/x86/kernel/cpu/bugs.c            |  15 +-
 arch/x86/kvm/.gitignore               |   2 +
 arch/x86/kvm/Makefile                 |  12 ++
 arch/x86/kvm/kvm-asm-offsets.c        |  29 ++++
 arch/x86/kvm/mmu/mmu.c                |   4 +-
 arch/x86/kvm/pmu.c                    |   2 +-
 arch/x86/kvm/svm/pmu.c                |   7 +-
 arch/x86/kvm/svm/sev.c                |   6 +-
 arch/x86/kvm/svm/svm.c                | 105 +++++---------
 arch/x86/kvm/svm/svm.h                |  11 +-
 arch/x86/kvm/svm/svm_ops.h            |   5 -
 arch/x86/kvm/svm/vmenter.S            | 260 +++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/pmu_intel.c          |   4 +-
 arch/x86/kvm/vmx/vmenter.S            |   2 +-
 arch/x86/kvm/x86.c                    |  25 ++--
 tools/kvm/kvm_stat/kvm_stat           |  98 +++++++++++--
 23 files changed, 435 insertions(+), 207 deletions(-)
 create mode 100644 arch/x86/kvm/.gitignore
 create mode 100644 arch/x86/kvm/kvm-asm-offsets.c

