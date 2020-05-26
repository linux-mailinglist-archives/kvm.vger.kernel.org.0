Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5841D60C5
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgEPMYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:24:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726219AbgEPMYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589631857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=8mmEst/G2NAr0kipPJrp+ihzAeJTb8tA3U7VWWeYgP4=;
        b=Y6cEPyGbuao4T5tPmyiQU//Naac6HK79TMFp1jgKjqY5jxXFtHyEB64j2g1v42UpsQ34Wk
        XBs3WKeiDtEc1H/p+RkHopSCKheGYM5F1BmQOf/9j0qreG5YVWh+N1pMJe47G9wNuvXPRl
        uYUbfRW5qumSm2F3ayomQX0LHNV2XvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-5Sf6BMQYMyelcSRVZ_uPWg-1; Sat, 16 May 2020 08:24:15 -0400
X-MC-Unique: 5Sf6BMQYMyelcSRVZ_uPWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BE5F1005510;
        Sat, 16 May 2020 12:24:14 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F02032657D;
        Sat, 16 May 2020 12:24:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.7-rc6
Date:   Sat, 16 May 2020 08:24:13 -0400
Message-Id: <20200516122413.693424-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 2673cb6849722a4ffd74c27a9200a9ec43f64be3:

  Merge tag 'kvm-s390-master-5.7-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD (2020-05-06 08:09:17 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c4e0e4ab4cf3ec2b3f0b628ead108d677644ebd9:

  KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce (2020-05-15 13:48:56 -0400)

----------------------------------------------------------------
A new testcase for guest debugging (gdbstub) that exposed a bunch of
bugs, mostly for AMD processors.  And a few other x86 fixes.

----------------------------------------------------------------
Babu Moger (1):
      KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c

Jim Mattson (1):
      KVM: x86: Fix off-by-one error in kvm_vcpu_ioctl_x86_setup_mce

Paolo Bonzini (6):
      KVM: x86: fix DR6 delivery for various cases of #DB injection
      KVM: nSVM: trap #DB and #BP to userspace if guest debugging is on
      KVM: SVM: keep DR6 synchronized with vcpu->arch.dr6
      KVM: x86, SVM: isolate vcpu->arch.dr6 from vmcb->save.dr6
      KVM: VMX: pass correct DR6 for GD userspace exit
      Merge branch 'kvm-amd-fixes' into HEAD

Peter Xu (4):
      KVM: X86: Declare KVM_CAP_SET_GUEST_DEBUG properly
      KVM: X86: Set RTM for DB_VECTOR too for KVM_EXIT_DEBUG
      KVM: X86: Fix single-step with KVM_SET_GUEST_DEBUG
      KVM: selftests: Add KVM_SET_GUEST_DEBUG test

Suravee Suthikulpanit (2):
      KVM: Introduce kvm_make_all_cpus_request_except()
      KVM: SVM: Disable AVIC before setting V_IRQ

 arch/x86/include/asm/kvm_host.h                 |   4 +-
 arch/x86/kvm/hyperv.c                           |   2 +-
 arch/x86/kvm/svm/nested.c                       |  39 ++++-
 arch/x86/kvm/svm/svm.c                          |  36 +++--
 arch/x86/kvm/vmx/vmx.c                          |  41 +----
 arch/x86/kvm/x86.c                              |  60 ++++---
 include/linux/kvm_host.h                        |   3 +
 tools/testing/selftests/kvm/Makefile            |   1 +
 tools/testing/selftests/kvm/include/kvm_util.h  |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c      |   9 ++
 tools/testing/selftests/kvm/x86_64/debug_regs.c | 202 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c                             |  14 +-
 12 files changed, 325 insertions(+), 88 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/debug_regs.c

