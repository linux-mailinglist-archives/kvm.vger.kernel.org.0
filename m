Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E2066A116
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjAMRtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjAMRsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:48:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C6091529
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673631435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Idp+2QJKYichphR9XFVP9fF6j0+Z3SfDNnlyg7A5OBQ=;
        b=RfO03t7tJSMAwYb1IZPGJMPAm+WG3fusBFxPKBZrUKb6sWTXgfnBbeDt2YnfHRgtf6C7zc
        GR5ALJGAcFyJfQtg7kjNBCfBfJB1jTBwQlOI0aa9Mh+fE+CP6T91kyE2z/WxrAQqvanLrr
        7esgE/ZgPhnQ7DsJR+EnTWL/BaULZQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-R1goO_ifNVqABGLyPnYW2w-1; Fri, 13 Jan 2023 12:37:11 -0500
X-MC-Unique: R1goO_ifNVqABGLyPnYW2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A262877CA1;
        Fri, 13 Jan 2023 17:37:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E8CF492B05;
        Fri, 13 Jan 2023 17:37:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 6.2-rc4
Date:   Fri, 13 Jan 2023 12:37:10 -0500
Message-Id: <20230113173710.2825302-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:

  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 310bc39546a435c83cc27a0eba878afac0d74714:

  KVM: x86/xen: Avoid deadlock by adding kvm->arch.xen.xen_lock leaf node lock (2023-01-11 17:45:58 -0500)

----------------------------------------------------------------
ARM:

* Fix the PMCR_EL0 reset value after the PMU rework

* Correctly handle S2 fault triggered by a S1 page table walk
  by not always classifying it as a write, as this breaks on
  R/O memslots

* Document why we cannot exit with KVM_EXIT_MMIO when taking
  a write fault from a S1 PTW on a R/O memslot

* Put the Apple M2 on the naughty list for not being able to
  correctly implement the vgic SEIS feature, just like the M1
  before it

* Reviewer updates: Alex is stepping down, replaced by Zenghui

x86:

* Fix various rare locking issues in Xen emulation and teach lockdep
  to detect them

* Documentation improvements

* Do not return host topology information from KVM_GET_SUPPORTED_CPUID

----------------------------------------------------------------
Alexandru Elisei (1):
      MAINTAINERS: Remove myself as a KVM/arm64 reviewer

David Woodhouse (4):
      KVM: x86/xen: Fix lockdep warning on "recursive" gpc locking
      KVM: x86/xen: Fix potential deadlock in kvm_xen_update_runstate_guest()
      KVM: Ensure lockdep knows about kvm->lock vs. vcpu->mutex ordering rule
      KVM: x86/xen: Avoid deadlock by adding kvm->arch.xen.xen_lock leaf node lock

James Clark (1):
      KVM: arm64: PMU: Fix PMCR_EL0 reset value

Marc Zyngier (8):
      KVM: arm64: Fix S1PTW handling on RO memslots
      KVM: arm64: Document the behaviour of S1PTW faults on RO memslots
      KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*
      KVM: arm64: vgic: Add Apple M2 cpus to the list of broken SEIS implementations
      Merge branch kvm-arm64/pmu-fixes-6.2 into kvmarm-master/fixes
      Merge branch kvm-arm64/s1ptw-write-fault into kvmarm-master/fixes
      MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
      Merge branch kvm-arm64/MAINTAINERS into kvmarm-master/fixes

Paolo Bonzini (4):
      KVM: nSVM: clarify recalc_intercepts() wrt CR8
      KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
      Documentation: kvm: fix SRCU locking order docs
      Merge tag 'kvmarm-fixes-6.2-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into kvm-master

 Documentation/virt/kvm/api.rst          | 22 ++++++++
 Documentation/virt/kvm/locking.rst      | 25 ++++-----
 MAINTAINERS                             |  2 +-
 arch/arm64/include/asm/cputype.h        |  4 ++
 arch/arm64/include/asm/esr.h            |  9 ++++
 arch/arm64/include/asm/kvm_arm.h        | 15 ------
 arch/arm64/include/asm/kvm_emulate.h    | 42 ++++++++++-----
 arch/arm64/kvm/hyp/include/hyp/fault.h  |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/mmu.c                    | 21 ++++----
 arch/arm64/kvm/sys_regs.c               |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c           |  2 +
 arch/x86/include/asm/kvm_host.h         |  1 +
 arch/x86/kvm/cpuid.c                    | 32 ++++++------
 arch/x86/kvm/svm/nested.c               | 12 ++---
 arch/x86/kvm/xen.c                      | 90 ++++++++++++++++++---------------
 virt/kvm/kvm_main.c                     |  7 +++
 17 files changed, 175 insertions(+), 115 deletions(-)

