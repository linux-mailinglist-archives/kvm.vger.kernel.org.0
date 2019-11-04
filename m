Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C670EF0F9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 00:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfKDXBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 18:01:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729877AbfKDXAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 18:00:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572908412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ccbFpKYBf8rSYhwgpOa9EKqIFsGHUnTReWBLwR3XiZo=;
        b=Y6JNfU8QCeNRd49w25vPvLPj6Gexuof3SsLvGkbsRFdnq6+v8t//fRNZFg25Jo49Ap+N49
        cuz93ftPMM+4RGVJsCFkbwcDJTihsYHUyLAdYwQ1OtURrwhaoPsnE0F16Ee7t8MXkBuFjG
        xXx+6yU0czSi+Am75GvJR56vJT8F2tY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-PDryOjlMOumflRoIWuy8mg-1; Mon, 04 Nov 2019 18:00:09 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8543C1800DFD;
        Mon,  4 Nov 2019 23:00:08 +0000 (UTC)
Received: from mail (ovpn-121-157.rdu2.redhat.com [10.10.121.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC0175D6D4;
        Mon,  4 Nov 2019 23:00:02 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 00/13] KVM monolithic v3
Date:   Mon,  4 Nov 2019 17:59:48 -0500
Message-Id: <20191104230001.27774-1-aarcange@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: PDryOjlMOumflRoIWuy8mg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Here's the rebase of KVM monolithic on 5.4-rc6 after improving the
Kbuild as suggested in the v2 review.

This should have corrected also the non-x86 KVM builds (not verified
so it may not have full coverage yet, but I should have fixed all
issues reported by kbot so far).

The effect of the patchset is visible at the end of the below pdf. I
dropped CPUID so the results are still an exact match only for the
last two bench slides which are the only important ones in real life.

https://people.redhat.com/~aarcange/slides/2019-KVM-monolithic.pdf

https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=3Dkvm-=
mono3

Andrea Arcangeli (13):
  KVM: monolithic: x86: remove kvm.ko
  KVM: monolithic: x86: convert the kvm_x86_ops and kvm_pmu_ops methods
    to external functions
  kvm: monolithic: fixup x86-32 build
  KVM: monolithic: x86: handle the request_immediate_exit variation
  KVM: monolithic: add more section prefixes
  KVM: monolithic: x86: remove __exit section prefix from
    machine_unsetup
  KVM: monolithic: x86: remove __init section prefix from
    kvm_x86_cpu_has_kvm_support
  KVM: monolithic: remove exports
  KVM: monolithic: x86: drop the kvm_pmu_ops structure
  KVM: x86: optimize more exit handlers in vmx.c
  KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
  KVM: retpolines: x86: eliminate retpoline from svm.c exit handlers
  x86: retpolines: eliminate retpoline from msr event handlers

 arch/powerpc/kvm/book3s.c       |   2 +-
 arch/x86/events/intel/core.c    |  11 +
 arch/x86/include/asm/kvm_host.h | 210 ++++++++-
 arch/x86/kvm/Kconfig            |  30 +-
 arch/x86/kvm/Makefile           |   5 +-
 arch/x86/kvm/cpuid.c            |  27 +-
 arch/x86/kvm/hyperv.c           |   8 +-
 arch/x86/kvm/irq.c              |   4 -
 arch/x86/kvm/irq_comm.c         |   2 -
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  46 +-
 arch/x86/kvm/mmu.c              |  50 +-
 arch/x86/kvm/mmu.h              |   4 +-
 arch/x86/kvm/mtrr.c             |   2 -
 arch/x86/kvm/pmu.c              |  27 +-
 arch/x86/kvm/pmu.h              |  37 +-
 arch/x86/kvm/pmu_amd.c          |  43 +-
 arch/x86/kvm/svm.c              | 683 ++++++++++++++++-----------
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/vmx/nested.c       |  84 ++--
 arch/x86/kvm/vmx/pmu_intel.c    |  46 +-
 arch/x86/kvm/vmx/vmx.c          | 807 ++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h          |  39 +-
 arch/x86/kvm/x86.c              | 418 ++++++-----------
 arch/x86/kvm/x86.h              |   2 +-
 include/linux/kvm_host.h        |   8 +-
 virt/kvm/arm/arm.c              |   2 +-
 virt/kvm/eventfd.c              |   1 -
 virt/kvm/kvm_main.c             |  70 +--
 29 files changed, 1440 insertions(+), 1242 deletions(-)

