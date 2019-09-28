Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18903C1178
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfI1RXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfI1RXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:24 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82B6690B0A;
        Sat, 28 Sep 2019 17:23:24 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48291261B8;
        Sat, 28 Sep 2019 17:23:24 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 00/14] KVM monolithic v2
Date:   Sat, 28 Sep 2019 13:23:09 -0400
Message-Id: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Sat, 28 Sep 2019 17:23:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

as usual the last 4 patches could be splitted off but I did more
measurements in that area and I altered the commit headers. They're
fairly small commits compared to the previous part so I kept it
considering they're needed to benchmark the previous part.

The KVM monolithic enhancement is easy to identify checking the word
"monolithic" in the subject so there's no confusion about where that
work stops.

This renames all functions in place mixed up in whatever location they
existed in svm.c or vmx.c. If they require an inline call they're
defined now as extern before the kvm_x86_ops structure.

Converting those small kvm_x86 functions to inlines requires more
Makefile work and header restructuring so it's left for later.

The removal of kvm_x86_ops is also left for later because that
requires lots of logic changes in the code scattered all over the
place in KVM code. This patchset tries to do the conversion with as
few logic changes as possible, so the code works the same and this
only improves the implementation and the performance.

Doing the conversion plus the logic changes at the same time would
pose the risk of not being able to identify through bisection if any
regression is caused by a bug in the conversion or in one small commit
to alter the logic and to remove the need of one more pointer to
function.

It's best if each single removal of any pointer to functional change
is done through a separate small commit. After all those small commits
done incrementally with this patchset, the kvm_x86_ops structure can
be deleted.

https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=kvm-mono2

Thanks,
Andrea

Andrea Arcangeli (14):
  KVM: monolithic: x86: remove kvm.ko
  KVM: monolithic: x86: disable linking vmx and svm at the same time
    into the kernel
  KVM: monolithic: x86: convert the kvm_x86_ops and kvm_pmu_ops methods
    to external functions
  KVM: monolithic: x86: handle the request_immediate_exit variation
  KVM: monolithic: add more section prefixes in the KVM common code
  KVM: monolithic: x86: remove __exit section prefix from
    machine_unsetup
  KVM: monolithic: x86: remove __init section prefix from
    kvm_x86_cpu_has_kvm_support
  KVM: monolithic: x86: remove exports
  KVM: monolithic: remove exports from KVM common code
  KVM: monolithic: x86: drop the kvm_pmu_ops structure
  KVM: x86: optimize more exit handlers in vmx.c
  KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
  KVM: retpolines: x86: eliminate retpoline from svm.c exit handlers
  x86: retpolines: eliminate retpoline from msr event handlers

 arch/x86/events/intel/core.c    |  11 +
 arch/x86/include/asm/kvm_host.h | 205 +++++++-
 arch/x86/kvm/Kconfig            |  24 +-
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
 arch/x86/kvm/svm.c              | 682 ++++++++++++++++-----------
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/vmx/nested.c       |  84 ++--
 arch/x86/kvm/vmx/pmu_intel.c    |  46 +-
 arch/x86/kvm/vmx/vmx.c          | 795 ++++++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.h          |  39 +-
 arch/x86/kvm/x86.c              | 418 +++++++----------
 arch/x86/kvm/x86.h              |   2 +-
 include/linux/kvm_host.h        |   4 +-
 virt/kvm/eventfd.c              |   1 -
 virt/kvm/kvm_main.c             |  71 +--
 27 files changed, 1413 insertions(+), 1238 deletions(-)
