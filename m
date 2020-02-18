Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3AE1637B5
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBRXyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:54:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:40044 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgBRXyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:54:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:54:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="224313154"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 15:54:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] KVM: Move x86 init ops to separate struct
Date:   Tue, 18 Feb 2020 15:54:28 -0800
Message-Id: <20200218235437.20533-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The non-x86 part of this series is wholly contained in patch 01.  Compared
to other recent kvm-wide changes, this one is very straightforward (famous
last words).

Like a few other architectures, e.g. PPC, x86 uses a set of global hooks
to call back into vendor code on demand.  A handlful of the x86 hooks are
used only within the scope of kvm_init().  This series moves the init-only
hooks to a separate struct, partly to clean up the code a bit, but mainly
so that the runtime hooks can be made available only after the x86 vendor
has completed its ->hardware_setup().  While working on a different series
I spent a fair bit of time scratching my as to why a kvm_x86_ops wasn't
working, and eventually realized VMX's callback wasn't "ready" because the
vmcs_config hadn't yet been populated.

Due to lack of a cross-compiling setup, the non-x86 changes in patch 01
are untested.

The SVM changes in patch 02 are fairly well tested, e.g. fudged things
enough to ensure KVM didn't explode on a null pointer.

Patch 05 is a bit scary as a rogue dereference of kvm_x86_ops before
->hardware_setup() will crash KVM (maybe the kernel?).  I didn't find any
obvious ways to use kvm_x86_ops on AMD, and tested on a few different
Intel CPUs, so I'm reasonably confident that there are no existing
violations.

v2:
  - Rebase to kvm/queue, 2c2787938512 ("KVM: selftests: Stop ...")
  - Collect tags. [Cornelia]
  - Add a patch to make kvm_x86_ops its own instance and copy
    {vmx,svm}_x86_ops by value, which saves a memory access on every
    invocation of a kvm_x86_ops hook. [Paolo]
  - Add patches to tag {vmx,svm}_x86_ops as __initdata after they're
    copied by value.

Sean Christopherson (9):
  KVM: Pass kvm_init()'s opaque param to additional arch funcs
  KVM: x86: Move init-only kvm_x86_ops to separate struct
  KVM: VMX: Move hardware_setup() definition below vmx_x86_ops
  KVM: VMX: Configure runtime hooks using vmx_x86_ops
  KVM: x86: Set kvm_x86_ops only after ->hardware_setup() completes
  KVM: x86: Copy kvm_x86_ops by value to eliminate layer of indirection
  KVM: x86: Drop __exit from kvm_x86_ops' hardware_unsetup()
  KVM: VMX: Annotate vmx_x86_ops as __initdata
  KVM: SVM: Annotate svm_x86_ops as __initdata

 arch/mips/kvm/mips.c            |   4 +-
 arch/powerpc/kvm/powerpc.c      |   4 +-
 arch/s390/kvm/kvm-s390.c        |   4 +-
 arch/x86/include/asm/kvm_host.h |  35 +--
 arch/x86/kvm/cpuid.c            |  24 +-
 arch/x86/kvm/hyperv.c           |   8 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  30 +--
 arch/x86/kvm/mmu.h              |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  38 ++--
 arch/x86/kvm/pmu.c              |  30 +--
 arch/x86/kvm/pmu.h              |   2 +-
 arch/x86/kvm/svm.c              |  21 +-
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/vmx/nested.c       |  17 +-
 arch/x86/kvm/vmx/nested.h       |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c    |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 353 +++++++++++++++--------------
 arch/x86/kvm/x86.c              | 384 ++++++++++++++++----------------
 arch/x86/kvm/x86.h              |   4 +-
 include/linux/kvm_host.h        |   4 +-
 virt/kvm/arm/arm.c              |   4 +-
 virt/kvm/kvm_main.c             |  18 +-
 23 files changed, 519 insertions(+), 488 deletions(-)

-- 
2.24.1

