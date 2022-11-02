Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC186171AD
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 00:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiKBXTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 19:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKBXTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 19:19:17 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D15218A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 16:19:15 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s82-20020a632c55000000b0046b2491aa95so92983pgs.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 16:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v+0QB2AcjXWwXQFe0Sl30YwZEOHl7lG2VkKFom8MCIE=;
        b=aw3MvDnhjGhzU1N6s+Vpw6sc746Hsx1nkI0d46VmBcJKGrP/BJLyU4nszyhTbJdoTf
         oofi962rp1gcsq9xO3VFhTcWtZK6/xQ/3tFYJ9+Uj+Dk2GcKrDL4HigNkzsIFpy3Q79n
         /wG/NMqz1oBz2i5EST1RhC8Hi5hVLUf4USV0ge1OT5BhXgXcS8ylDR+K4VXPhApjhIG3
         OlaKTmjuVOgoRP+QcCoTz+8mzEp4DSP7dVJWGcJ12El2CQ1hCL3jRjRnd2iT2XfA+oCo
         nSPZrAZE9Fwc/n2HoWbhBJay4U0cc48uC3MWJYPi8Mq7p0wuNGF3sCDpmc1GQ081YOYu
         gnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+0QB2AcjXWwXQFe0Sl30YwZEOHl7lG2VkKFom8MCIE=;
        b=oXyKBV7G0eROhFrmJ5urdKyGpyYh9sMZlm2gZzk0Zz2g1geWFl84rPh+4gFdyWFwY6
         67dAXUDPFHJla8nMzxqvVwkGDPuxBzpycM+J8khIviL1yCWqRQHv27QcPoB7FByssXWW
         T1dJnTLq3TX6ltu6imTi/irBFOR3Ch8zidXQEIBqVjUgZY+mRg+1rIOT+Ud9tviA72dL
         MfXxcCVyZR6kvSBu1Lmv1y4hHA45snu70v3wy/FLGD1lH4M5WH4fnwBaTh/1pQxC6Ya+
         WDXcKsmrLUmBJkoadHmqYA2sgvgQ4ZZnnqpRGLcv9COZJWtTzYZx8MjdDYfBBpSbCxWd
         VCJA==
X-Gm-Message-State: ACrzQf1Uw1udHmZOFAS9rIJYLhMUZUfQAggFD7IGiFm3hAJCwB7tLMOB
        3+2eDkgPzusRzBjN3rQQYBKqzaT/mGs=
X-Google-Smtp-Source: AMsMyM7HWZzp0WdXRiToVUsPaCC4IFhAkimeV47TR3c6KmefAfOorOpJlBK9HTJEVktIVE8qzHY5o99pP4Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef52:b0:17c:f072:95bc with SMTP id
 e18-20020a170902ef5200b0017cf07295bcmr26742303plx.28.1667431155303; Wed, 02
 Nov 2022 16:19:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 23:18:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-1-seanjc@google.com>
Subject: [PATCH 00/44] KVM: Rework kvm_init() and hardware enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Non-x86 folks, please test on hardware when possible.  I made a _lot_ of
mistakes when moving code around.  Thankfully, x86 was the trickiest code
to deal with, and I'm fairly confident that I found all the bugs I
introduced via testing.  But the number of mistakes I made and found on
x86 makes me more than a bit worried that I screwed something up in other
arch code.

This is a continuation of Chao's series to do x86 CPU compatibility checks
during virtualization hardware enabling[1], and of Isaku's series to try
and clean up the hardware enabling paths so that x86 (Intel specifically)
can temporarily enable hardware during module initialization without
causing undue pain for other architectures[2].  It also includes one patch
from another mini-series from Isaku that provides the less controversial
patches[3].

The main theme of this series is to kill off kvm_arch_init(),
kvm_arch_hardware_(un)setup(), and kvm_arch_check_processor_compat(), which
all originated in x86 code from way back when, and needlessly complicate
both common KVM code and architecture code.  E.g. many architectures don't
mark functions/data as __init/__ro_after_init purely because kvm_init()
isn't marked __init to support x86's separate vendor modules.

The idea/hope is that with those hooks gone (moved to arch code), it will
be easier for x86 (and other architectures) to modify their module init
sequences as needed without having to fight common KVM code.  E.g. I'm
hoping that ARM can build on this to simplify its hardware enabling logic,
especially the pKVM side of things.

There are bug fixes throughout this series.  They are more scattered than
I would usually prefer, but getting the sequencing correct was a gigantic
pain for many of the x86 fixes due to needing to fix common code in order
for the x86 fix to have any meaning.  And while the bugs are often fatal,
they aren't all that interesting for most users as they either require a
malicious admin or broken hardware, i.e. aren't likely to be encountered
by the vast majority of KVM users.  So unless someone _really_ wants a
particular fix isolated for backporting, I'm not planning on shuffling
patches.

Tested on x86.  Lightly tested on arm64.  Compile tested only on all other
architectures.

[1] https://lore.kernel.org/all/20220216031528.92558-1-chao.gao@intel.com
[2] https://lore.kernel.org/all/cover.1663869838.git.isaku.yamahata@intel.com
[3] https://lore.kernel.org/all/cover.1667369456.git.isaku.yamahata@intel.com

Chao Gao (3):
  KVM: x86: Do compatibility checks when onlining CPU
  KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
  KVM: Disable CPU hotplug during hardware enabling

Isaku Yamahata (3):
  KVM: Drop kvm_count_lock and instead protect kvm_usage_count with
    kvm_lock
  KVM: Remove on_each_cpu(hardware_disable_nolock) in kvm_exit()
  KVM: Make hardware_enable_failed a local variable in the "enable all"
    path

Marc Zyngier (1):
  KVM: arm64: Simplify the CPUHP logic

Sean Christopherson (37):
  KVM: Register /dev/kvm as the _very_ last thing during initialization
  KVM: Initialize IRQ FD after arch hardware setup
  KVM: Allocate cpus_hardware_enabled after arch hardware setup
  KVM: Teardown VFIO ops earlier in kvm_exit()
  KVM: s390: Unwind kvm_arch_init() piece-by-piece() if a step fails
  KVM: s390: Move hardware setup/unsetup to init/exit
  KVM: x86: Do timer initialization after XCR0 configuration
  KVM: x86: Move hardware setup/unsetup to init/exit
  KVM: Drop arch hardware (un)setup hooks
  KVM: VMX: Clean up eVMCS enabling if KVM initialization fails
  KVM: x86: Move guts of kvm_arch_init() to standalone helper
  KVM: VMX: Do _all_ initialization before exposing /dev/kvm to
    userspace
  KVM: x86: Serialize vendor module initialization (hardware setup)
  KVM: arm64: Free hypervisor allocations if vector slot init fails
  KVM: arm64: Unregister perf callbacks if hypervisor finalization fails
  KVM: arm64: Do arm/arch initialiation without bouncing through
    kvm_init()
  KVM: arm64: Mark kvm_arm_init() and its unique descendants as __init
  KVM: MIPS: Hardcode callbacks to hardware virtualization extensions
  KVM: MIPS: Setup VZ emulation? directly from kvm_mips_init()
  KVM: MIPS: Register die notifier prior to kvm_init()
  KVM: RISC-V: Do arch init directly in riscv_kvm_init()
  KVM: RISC-V: Tag init functions and data with __init, __ro_after_init
  KVM: PPC: Move processor compatibility check to module init
  KVM: s390: Do s390 specific init without bouncing through kvm_init()
  KVM: s390: Mark __kvm_s390_init() and its descendants as __init
  KVM: Drop kvm_arch_{init,exit}() hooks
  KVM: VMX: Make VMCS configuration/capabilities structs read-only after
    init
  KVM: x86: Do CPU compatibility checks in x86 code
  KVM: Drop kvm_arch_check_processor_compat() hook
  KVM: x86: Use KBUILD_MODNAME to specify vendor module name
  KVM: x86: Unify pr_fmt to use module name for all KVM modules
  KVM: x86: Do VMX/SVM support checks directly in vendor code
  KVM: VMX: Shuffle support checks and hardware enabling code around
  KVM: SVM: Check for SVM support in CPU compatibility checks
  KVM: Use a per-CPU variable to track which CPUs have enabled
    virtualization
  KVM: Register syscore (suspend/resume) ops early in kvm_init()
  KVM: Opt out of generic hardware enabling on s390 and PPC

 Documentation/virt/kvm/locking.rst  |  18 +-
 arch/arm64/include/asm/kvm_host.h   |  15 +-
 arch/arm64/include/asm/kvm_mmu.h    |   4 +-
 arch/arm64/kvm/Kconfig              |   1 +
 arch/arm64/kvm/arch_timer.c         |  29 +-
 arch/arm64/kvm/arm.c                |  93 +++---
 arch/arm64/kvm/mmu.c                |  12 +-
 arch/arm64/kvm/reset.c              |   8 +-
 arch/arm64/kvm/sys_regs.c           |   6 +-
 arch/arm64/kvm/vgic/vgic-init.c     |  19 +-
 arch/arm64/kvm/vmid.c               |   6 +-
 arch/mips/include/asm/kvm_host.h    |   3 +-
 arch/mips/kvm/Kconfig               |   1 +
 arch/mips/kvm/Makefile              |   2 +-
 arch/mips/kvm/callback.c            |  14 -
 arch/mips/kvm/mips.c                |  34 +--
 arch/mips/kvm/vz.c                  |   7 +-
 arch/powerpc/include/asm/kvm_host.h |   3 -
 arch/powerpc/include/asm/kvm_ppc.h  |   1 -
 arch/powerpc/kvm/book3s.c           |  12 +-
 arch/powerpc/kvm/e500.c             |   6 +-
 arch/powerpc/kvm/e500mc.c           |   6 +-
 arch/powerpc/kvm/powerpc.c          |  20 --
 arch/riscv/include/asm/kvm_host.h   |   7 +-
 arch/riscv/kvm/Kconfig              |   1 +
 arch/riscv/kvm/main.c               |  23 +-
 arch/riscv/kvm/mmu.c                |  12 +-
 arch/riscv/kvm/vmid.c               |   4 +-
 arch/s390/include/asm/kvm_host.h    |   1 -
 arch/s390/kvm/interrupt.c           |   2 +-
 arch/s390/kvm/kvm-s390.c            |  84 +++---
 arch/s390/kvm/kvm-s390.h            |   2 +-
 arch/s390/kvm/pci.c                 |   2 +-
 arch/s390/kvm/pci.h                 |   2 +-
 arch/x86/include/asm/kvm_host.h     |   7 +-
 arch/x86/kvm/Kconfig                |   1 +
 arch/x86/kvm/cpuid.c                |   1 +
 arch/x86/kvm/debugfs.c              |   2 +
 arch/x86/kvm/emulate.c              |   1 +
 arch/x86/kvm/hyperv.c               |   1 +
 arch/x86/kvm/i8254.c                |   4 +-
 arch/x86/kvm/i8259.c                |   4 +-
 arch/x86/kvm/ioapic.c               |   1 +
 arch/x86/kvm/irq.c                  |   1 +
 arch/x86/kvm/irq_comm.c             |   7 +-
 arch/x86/kvm/kvm_onhyperv.c         |   1 +
 arch/x86/kvm/lapic.c                |   8 +-
 arch/x86/kvm/mmu/mmu.c              |   6 +-
 arch/x86/kvm/mmu/page_track.c       |   1 +
 arch/x86/kvm/mmu/spte.c             |   4 +-
 arch/x86/kvm/mmu/spte.h             |   4 +-
 arch/x86/kvm/mmu/tdp_iter.c         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c          |   1 +
 arch/x86/kvm/mtrr.c                 |   1 +
 arch/x86/kvm/pmu.c                  |   1 +
 arch/x86/kvm/smm.c                  |   1 +
 arch/x86/kvm/svm/avic.c             |   2 +-
 arch/x86/kvm/svm/nested.c           |   2 +-
 arch/x86/kvm/svm/pmu.c              |   2 +
 arch/x86/kvm/svm/sev.c              |   1 +
 arch/x86/kvm/svm/svm.c              |  90 +++---
 arch/x86/kvm/svm/svm_onhyperv.c     |   1 +
 arch/x86/kvm/svm/svm_onhyperv.h     |   4 +-
 arch/x86/kvm/vmx/capabilities.h     |   4 +-
 arch/x86/kvm/vmx/evmcs.c            |   1 +
 arch/x86/kvm/vmx/evmcs.h            |   4 +-
 arch/x86/kvm/vmx/nested.c           |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c        |   5 +-
 arch/x86/kvm/vmx/posted_intr.c      |   2 +
 arch/x86/kvm/vmx/sgx.c              |   5 +-
 arch/x86/kvm/vmx/vmcs12.c           |   1 +
 arch/x86/kvm/vmx/vmx.c              | 438 +++++++++++++++-------------
 arch/x86/kvm/vmx/vmx_ops.h          |   4 +-
 arch/x86/kvm/x86.c                  | 252 +++++++++-------
 arch/x86/kvm/xen.c                  |   1 +
 include/kvm/arm_arch_timer.h        |   6 +-
 include/kvm/arm_vgic.h              |   4 +
 include/linux/cpuhotplug.h          |   5 +-
 include/linux/kvm_host.h            |  13 +-
 virt/kvm/Kconfig                    |   3 +
 virt/kvm/kvm_main.c                 | 302 ++++++++++---------
 81 files changed, 861 insertions(+), 813 deletions(-)
 delete mode 100644 arch/mips/kvm/callback.c


base-commit: d5af637323dd156bad071a3f8fc0d7166cca1276
-- 
2.38.1.431.g37b22c650d-goog

