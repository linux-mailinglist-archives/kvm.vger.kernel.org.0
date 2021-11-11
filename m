Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A4144CF7B
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 03:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhKKCKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 21:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbhKKCK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 21:10:29 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC69C0613F5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:41 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id f206-20020a6238d7000000b004a02dd7156bso1477642pfa.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 18:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=tUIQRP/L4Fp0gX6OhmNi7HbxcL+5uZ5JBj+c5s8Epc0=;
        b=SHNbfqTm3J0sCYDnSCPJl2DJ6T9yOTXJQHvuHx8d04TG6gGxpzfaf/C1v4gFFxrBPV
         Nqw7AUHS01qZz0UD93QTZiHv9vFDhe2GdeiYEKJ4f9tX2pvUysavfJFD5gQ4gNAG6pKe
         lJuw7Z3tdfLgDKejGON+MO9SGmEzmVIPRzmdTSDCNpCRdZIISx15JlmN7eHU6e0hABbO
         ggSU2q0H1akcoFCvWhLk23HEYoCc8zZRMmEW+nbv3sbHxH0cDekH6WrEbtb1X+tgaA6k
         FbiWW2J5zLyfWA9uMi2CyYilMp6JqRACLddKb1B7Cqi9I+sv88k2AOHAQxuAqltrxkop
         Ei4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=tUIQRP/L4Fp0gX6OhmNi7HbxcL+5uZ5JBj+c5s8Epc0=;
        b=M5sOmyZ8R1a/ijtkSDWLDVs2ilyAcyBkVsXEIVqLLkN1V4wFgtSVHqMeH801scg2lz
         ctxcxb88eOykQV1ou/LAiqn8Gs1EmzgA6OM2nNlNaWCH/bHBwmcCZ5w0iuPsd3UFrqLp
         6aUcvaH/T/DTo215ltuc0yRMjixNRvR/3n7sdl3xFQhXkHpQZYyE1cZ8K0jQUPN/iqVb
         77db1199YQJ5zTyKLDS+PFyb9TaGMiVrmMQmCoj/GfOrOVpsbI7F4fk5MzTGYFfaFYO4
         khGQ1EjubXt2kf8Xm+FPvqAYWVdCjZ3eIqR3MRKDrKDbq1Bk3aSxqEgmRVe38YO1/Ljz
         0teQ==
X-Gm-Message-State: AOAM5301FDSwPO3KDvIU6bKhZLvbcHsH0EUjq0gVe+YFzFLH0RSUbiBQ
        0EWXXqArkUZGpOwoEIe7QDkEcMJhMB0=
X-Google-Smtp-Source: ABdhPJyLbpoo29ePfTjvBFgohxjl3NBLChAqmG4K4wYBtXh/2rWx5xqvq1BN1sRzHdfKDemaaNnkz7tBMNU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2004:b0:142:6344:2c08 with SMTP id
 s4-20020a170903200400b0014263442c08mr3739627pla.51.1636596461111; Wed, 10 Nov
 2021 18:07:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Nov 2021 02:07:21 +0000
Message-Id: <20211111020738.2512932-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v4 00/17] perf: KVM: Fix, optimize, and clean up callbacks
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a combination of ~2 series to fix bugs in the perf+KVM callbacks,
optimize the callbacks by employing static_call, and do a variety of
cleanup in both perf and KVM.

For the non-perf patches, I think everything except patch 13 (Paolo) and
patches 15 and 16 (Marc) has the appropriate acks.

Patch 1 fixes a set of mostly-theoretical bugs by protecting the guest
callbacks pointer with RCU.

Patches 2 and 3 fix an Intel PT handling bug where KVM incorrectly
eats PT interrupts when PT is supposed to be owned entirely by the host.

Patches 4-9 clean up perf's callback infrastructure and switch to
static_call for arm64 and x86 (the only survivors).

Patches 10-17 clean up related KVM code and unify the arm64/x86 callbacks.

Based on Linus' tree, commit cb690f5238d7 ("Merge tag 'for-5.16/drivers...).

v4:
  - Rebase.
  - Collect acks and reviews.
  - Fully protect perf_guest_cbs with RCU. [Paolo].
  - Add patch to hide arm64's kvm_arm_pmu_available behind
    CONFIG_HW_PERF_EVENTS=y.

v3:
  - https://lore.kernel.org/all/20210922000533.713300-1-seanjc@google.com/
  - Add wrappers for guest callbacks to that stubs can be provided when
    GUEST_PERF_EVENTS=n.
  - s/HAVE_GUEST_PERF_EVENTS/GUEST_PERF_EVENTS and select it from KVM
    and XEN_PV instead of from top-level arm64/x86. [Paolo]
  - Drop an unnecessary synchronize_rcu() when registering callbacks. [Peter]
  - Retain a WARN_ON_ONCE() when unregistering callbacks if the caller
    didn't provide the correct pointer. [Peter]
  - Rework the static_call patch to move it all to common perf.
  - Add a patch to drop the (un)register stubs, made possible after
    having KVM+XEN_PV select GUEST_PERF_EVENTS.
  - Split dropping guest callback "support" for arm, csky, etc... to a
    separate patch, to make introducing GUEST_PERF_EVENTS cleaner.
  
v2 (relative to static_call v10):
  - Split the patch into the semantic change (multiplexed ->state) and
    introduction of static_call.
  - Don't use '0' for "not a guest RIP".
  - Handle unregister path.
  - Drop changes for architectures that can be culled entirely.

v2 (relative to v1):
  - https://lkml.kernel.org/r/20210828003558.713983-6-seanjc@google.com
  - Drop per-cpu approach. [Peter]
  - Fix mostly-theoretical reload and use-after-free with READ_ONCE(),
    WRITE_ONCE(), and synchronize_rcu(). [Peter]
  - Avoid new exports like the plague. [Peter]

v1:
  - https://lkml.kernel.org/r/20210827005718.585190-1-seanjc@google.com

v10 static_call:
  - https://lkml.kernel.org/r/20210806133802.3528-2-lingshan.zhu@intel.com

Like Xu (1):
  perf/core: Rework guest callbacks to prepare for static_call support

Sean Christopherson (16):
  perf: Protect perf_guest_cbs with RCU
  KVM: x86: Register perf callbacks after calling vendor's
    hardware_setup()
  KVM: x86: Register Processor Trace interrupt hook iff PT enabled in
    guest
  perf: Stop pretending that perf can handle multiple guest callbacks
  perf: Drop dead and useless guest "support" from arm, csky, nds32 and
    riscv
  perf: Add wrappers for invoking guest callbacks
  perf: Force architectures to opt-in to guest callbacks
  perf/core: Use static_call to optimize perf_guest_info_callbacks
  KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu
    variable
  KVM: x86: More precisely identify NMI from guest when handling PMI
  KVM: Move x86's perf guest info callbacks to generic KVM
  KVM: x86: Move Intel Processor Trace interrupt handler to vmx.c
  KVM: arm64: Convert to the generic perf callbacks
  KVM: arm64: Hide kvm_arm_pmu_available behind CONFIG_HW_PERF_EVENTS=y
  KVM: arm64: Drop perf.c and fold its tiny bits of code into arm.c
  perf: Drop guest callback (un)register stubs

 arch/arm/kernel/perf_callchain.c   | 28 ++------------
 arch/arm64/include/asm/kvm_host.h  | 11 +++++-
 arch/arm64/kernel/image-vars.h     |  2 +
 arch/arm64/kernel/perf_callchain.c | 13 ++++---
 arch/arm64/kvm/Kconfig             |  1 +
 arch/arm64/kvm/Makefile            |  2 +-
 arch/arm64/kvm/arm.c               | 10 ++++-
 arch/arm64/kvm/perf.c              | 59 ------------------------------
 arch/arm64/kvm/pmu-emul.c          |  2 +
 arch/csky/kernel/perf_callchain.c  | 10 -----
 arch/nds32/kernel/perf_event_cpu.c | 29 ++-------------
 arch/riscv/kernel/perf_callchain.c | 10 -----
 arch/x86/events/core.c             | 13 ++++---
 arch/x86/events/intel/core.c       |  5 +--
 arch/x86/include/asm/kvm_host.h    |  7 +++-
 arch/x86/kvm/Kconfig               |  1 +
 arch/x86/kvm/pmu.c                 |  2 +-
 arch/x86/kvm/svm/svm.c             |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 25 ++++++++++++-
 arch/x86/kvm/x86.c                 | 58 +++++------------------------
 arch/x86/kvm/x86.h                 | 17 +++++++--
 arch/x86/xen/Kconfig               |  1 +
 arch/x86/xen/pmu.c                 | 32 +++++++---------
 include/kvm/arm_pmu.h              | 19 ++++++----
 include/linux/kvm_host.h           | 10 +++++
 include/linux/perf_event.h         | 44 ++++++++++++++++------
 init/Kconfig                       |  4 ++
 kernel/events/core.c               | 41 +++++++++++++++------
 virt/kvm/kvm_main.c                | 44 ++++++++++++++++++++++
 29 files changed, 246 insertions(+), 256 deletions(-)
 delete mode 100644 arch/arm64/kvm/perf.c

-- 
2.34.0.rc0.344.g81b53c2807-goog

