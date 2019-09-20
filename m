Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9CDB9907
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 23:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405358AbfITV0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 17:26:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbfITVZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Sep 2019 17:25:13 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B194E6412E;
        Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1C10A5D9CD;
        Fri, 20 Sep 2019 21:25:10 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/17] KVM monolithic v1
Date:   Fri, 20 Sep 2019 17:24:52 -0400
Message-Id: <20190920212509.2578-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 20 Sep 2019 21:25:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patchset micro optimizes the vmexit to increase performance by
dropping the kvm.ko kernel module.

All common KVM code gets linked twice into kvm-intel and kvm-amd with
the only cons of using more disk space, but the pros of CPU (and RAM)
runtime benefits.

This improves the vmexit performance by two digits percent on
microbenchmarks with the spectre_v2 default mitigation on both VMX and
SVM. With spectre_v2=off or with CPUs with IBRS_ALL in
ARCH_CAPABILITIES this still improve performance but it's more of the
order of 1%.

We'll still have to deal with CPUs without IBRS_ALL for a decade and
reducing the vmexit latency is important to pass certain benchmarks
with workloads that happen to trigger frequent vmexits without having
to set spectre_v2=off in the host (which at least in theory would make
the host kernel vulnerable from a spectre v2 attack from the guest,
even through hyperthreading).

The first patch 1/17 should be splitted off from this series and it's
intended to be merged separately, it's included here only to avoid any
possible erroneous measurement if using kexec for testing, in turn if
using kexec it's recommended to include it in the baseline
measurements too.

A git clonable branch for quick testing is available here:

  https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=kvm-mono1

Thanks,
Andrea

Andrea Arcangeli (17):
  x86: spec_ctrl: fix SPEC_CTRL initialization after kexec
  KVM: monolithic: x86: convert the kvm_x86_ops methods to external
    functions
  KVM: monolithic: x86: handle the request_immediate_exit variation
  KVM: monolithic: x86: convert the kvm_pmu_ops methods to external
    functions
  KVM: monolithic: x86: enable the kvm_x86_ops external functions
  KVM: monolithic: x86: enable the kvm_pmu_ops external functions
  KVM: monolithic: x86: adjust the section prefixes
  KVM: monolithic: adjust the section prefixes in the KVM common code
  KVM: monolithic: x86: remove kvm.ko
  KVM: monolithic: x86: use the external functions instead of
    kvm_x86_ops
  KVM: monolithic: x86: remove exports
  KVM: monolithic: remove exports from KVM common code
  KVM: monolithic: x86: drop the kvm_pmu_ops structure
  KVM: monolithic: x86: inline more exit handlers in vmx.c
  KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
  KVM: retpolines: x86: eliminate retpoline from svm.c exit handlers
  x86: retpolines: eliminate retpoline from msr event handlers

 arch/x86/events/intel/core.c     |  11 +
 arch/x86/include/asm/kvm_host.h  |  15 +-
 arch/x86/include/asm/kvm_ops.h   | 166 ++++++++
 arch/x86/include/asm/msr-index.h |   2 +
 arch/x86/kernel/cpu/bugs.c       |  20 +-
 arch/x86/kvm/Makefile            |   5 +-
 arch/x86/kvm/cpuid.c             |  27 +-
 arch/x86/kvm/hyperv.c            |   8 +-
 arch/x86/kvm/irq.c               |   4 -
 arch/x86/kvm/irq_comm.c          |   2 -
 arch/x86/kvm/kvm_cache_regs.h    |  10 +-
 arch/x86/kvm/lapic.c             |  44 +-
 arch/x86/kvm/mmu.c               |  50 +--
 arch/x86/kvm/mmu.h               |   4 +-
 arch/x86/kvm/mtrr.c              |   2 -
 arch/x86/kvm/pmu.c               |  27 +-
 arch/x86/kvm/pmu.h               |  21 +-
 arch/x86/kvm/pmu_amd.c           |  15 +-
 arch/x86/kvm/pmu_amd_ops.c       |  68 ++++
 arch/x86/kvm/pmu_ops.h           |  22 +
 arch/x86/kvm/svm.c               |  19 +-
 arch/x86/kvm/svm_ops.c           | 672 ++++++++++++++++++++++++++++++
 arch/x86/kvm/trace.h             |   4 +-
 arch/x86/kvm/vmx/pmu_intel.c     |  17 +-
 arch/x86/kvm/vmx/pmu_intel_ops.c |  68 ++++
 arch/x86/kvm/vmx/vmx.c           |  36 +-
 arch/x86/kvm/vmx/vmx_ops.c       | 675 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c               | 409 +++++++------------
 arch/x86/kvm/x86.h               |   2 +-
 virt/kvm/eventfd.c               |   1 -
 virt/kvm/kvm_main.c              |  71 +---
 31 files changed, 1982 insertions(+), 515 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm_ops.h
 create mode 100644 arch/x86/kvm/pmu_amd_ops.c
 create mode 100644 arch/x86/kvm/pmu_ops.h
 create mode 100644 arch/x86/kvm/svm_ops.c
 create mode 100644 arch/x86/kvm/vmx/pmu_intel_ops.c
 create mode 100644 arch/x86/kvm/vmx/vmx_ops.c

