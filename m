Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6399E351F93
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 21:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbhDATWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 15:22:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234981AbhDATV0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 15:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617304886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vvLDO2u5BxPZbBq5VTfe/3e16RM7zi3D4zzYHWMuYwE=;
        b=jS48htJh+TNkLd8tmXbtrsYRfQ3ORIEa0EpOViWff8flea8bxa0pCEmdsJB7C9DD8Bt4Vd
        1MK9Cm279Z+fOSnAvDrgnhrJPg8NrYJpEr78rhtY7EsPoe7lIhfNOIxrM9AG/eba5/3ypU
        p++dX9L8VHONh12hzl/+yo0OBbOCYN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-sMcizY3QPIOoyiOMZgp80w-1; Thu, 01 Apr 2021 15:21:22 -0400
X-MC-Unique: sMcizY3QPIOoyiOMZgp80w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E638C83DD20;
        Thu,  1 Apr 2021 19:21:21 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 949B319C59;
        Thu,  1 Apr 2021 19:21:21 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.12-rc6
Date:   Thu,  1 Apr 2021 15:21:20 -0400
Message-Id: <20210401192120.3280562-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit a5e13c6df0e41702d2b2c77c8ad41677ebb065b3:

  Linux 5.12-rc5 (2021-03-28 15:48:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 55626ca9c6909d077eca71bccbe15fef6e5ad917:

  selftests: kvm: Check that TSC page value is small after KVM_SET_CLOCK(0) (2021-04-01 05:14:19 -0400)

It's a bit larger than I (and probably you) would like by the time we 
get to -rc6, but perhaps not entirely unexpected since the changes in
the last merge window were larger than usual.

The SVM fixes will cause conflicts in the next merge window, but I have
already tried a merge and just keeping the "new" (5.13) code will be
fine.

During the merge window I mentioned that I was considering a switch
of the default MMU around 5.12-rc3.  However, I am not going to do
this until at least 5.13.

----------------------------------------------------------------
x86:

* Fixes for missing TLB flushes with TDP MMU

* Fixes for race conditions in nested SVM

* Fixes for lockdep splat with Xen emulation

* Fix for kvmclock underflow

* Fix srcdir != builddir builds

* Other small cleanups

ARM:
* Fix GICv3 MMIO compatibility probing

* Prevent guests from using the ARMv8.4 self-hosted tracing extension

----------------------------------------------------------------
Dongli Zhang (1):
      KVM: x86: remove unused declaration of kvm_write_tsc()

Haiwei Li (1):
      KVM: clean up the unused argument

Marc Zyngier (1):
      KVM: arm64: Fix CPU interface MMIO compatibility detection

Paolo Bonzini (7):
      Merge tag 'kvmarm-fixes-5.12-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge commit 'kvm-tdp-fix-flushes' into kvm-master
      KVM: SVM: load control fields from VMCB12 before checking them
      KVM: SVM: ensure that EFER.SVME is set when running nested guest or on nested vmexit
      Merge branch 'kvm-fix-svm-races' into kvm-master
      KVM: x86: reduce pvclock_gtod_sync_lock critical sections
      KVM: x86: disable interrupts while pvclock_gtod_sync_lock is taken

Sean Christopherson (3):
      KVM: x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap
      KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
      KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages

Siddharth Chandrasekaran (1):
      KVM: make: Fix out-of-source module builds

Stefan Raspl (1):
      tools/kvm_stat: Add restart delay

Suzuki K Poulose (2):
      KVM: arm64: Hide system instruction access to Trace registers
      KVM: arm64: Disable guest access to trace filter controls

Vitaly Kuznetsov (4):
      KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE
      selftests: kvm: make hardware_disable_test less verbose
      KVM: x86: Prevent 'hv_clock->system_time' from going negative in kvm_guest_time_update()
      selftests: kvm: Check that TSC page value is small after KVM_SET_CLOCK(0)

 arch/arm64/include/asm/kvm_arm.h                   |  1 +
 arch/arm64/kernel/cpufeature.c                     |  1 -
 arch/arm64/kvm/debug.c                             |  2 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  9 ++++
 arch/x86/kvm/Makefile                              |  2 +-
 arch/x86/kvm/mmu/mmu.c                             |  9 ++--
 arch/x86/kvm/mmu/tdp_mmu.c                         | 26 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.h                         | 24 ++++++++-
 arch/x86/kvm/svm/nested.c                          | 28 +++++++++--
 arch/x86/kvm/svm/pmu.c                             |  8 +++
 arch/x86/kvm/x86.c                                 | 57 ++++++++++++++--------
 arch/x86/kvm/x86.h                                 |  1 -
 tools/kvm/kvm_stat/kvm_stat.service                |  1 +
 .../testing/selftests/kvm/hardware_disable_test.c  | 10 ++--
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c  | 13 ++++-
 15 files changed, 139 insertions(+), 53 deletions(-)

