Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E41A3CBE8B
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbhGPV3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhGPV3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953ACC06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x84-20020a2531570000b029055d47682463so14460816ybx.5
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CG1+N8vSAN8jzRMG92Z0vjc6XGG3WrzLze9UYb4OGFM=;
        b=hpALvyjB67nNiBWyNRqdwZIgq9/Ah4C1wy4WzyAhOF1YMY/PbIl+5JKuOIwVYnwWXL
         yHkH+Q76WdRKmp3DXfrvnGBgf3RmSHMMJP1rsysV+s0a0bDxSckfFBsAmpPs5qMieJPr
         Z/4fTJy3iUAL++yl1gG/rPWRtSIQlPEv0nTGfhj0vmNoICTnPyCUDw85Scu6xFnhxqQ/
         PCl5syulBaA+CBZq01RP/dqRWltjhNxXD34Gf3fbM6nhoBWFHS0MzyhH4DCJ8wLeMicH
         vzXbhsT3y3DycKc2TTueJe29yKr7LdDQxOI22pnAgKXyUZZrFRHTKRIqBL2NhrtrEbTw
         SYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CG1+N8vSAN8jzRMG92Z0vjc6XGG3WrzLze9UYb4OGFM=;
        b=PagxCMssjpTFrF++4XViuzQiK0gh7B78acx4oL9kFeNOnqdfxTrcUPnvoMuRwxj4zx
         dAN13SGroKETrpJOUcsuEwPAOlfoxzdFZYnNFoYXMuu+Hr7lGssbNc9mI6FkFKvUXC2T
         uo5YicQBgpociuwlZ6wmXi3pTxHPlQmXlSZ8UF8/N1XcDdlEcK5SdbWPXCxrziiN6Ims
         e9LA5KJRnC4oYKCW+3o3NPWkqkux5b/j0We/mesM/kzEW3iB9253oLKPYECyfBLC46i0
         sxuR/Do69Xsg1oN4U9oL29H8+/QjRWtL7+Hx7o4zuQ7DT0vgLH9AbB4tM1+oo17ljDC5
         oJig==
X-Gm-Message-State: AOAM531bJqTzL1ilvu6iFqzfYLBLdkI0UjwPypx5ZR4gKLe7U1zhXfUs
        g88g2oGF3tLY2U9JAZZ80V9Q4lBJCmnYZ0Di5PlZJBz663eCWhbAFmzwwAUn1BxN+KjFRcKJYMI
        qj0J4lP2It3O3dIABUdskff80WEp8JvuCg6mJXvWHPNdYe0qy8XVYLY4ULg==
X-Google-Smtp-Source: ABdhPJyM4yakm1D1JS9PB+woXsIw2d1EI19Wm7mHRgWc5nFPgvVvTY/SC4vCot6IQ4tGKqy+FEet80OPohc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:ed0b:: with SMTP id k11mr14179470ybh.39.1626470799678;
 Fri, 16 Jul 2021 14:26:39 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:17 +0000
Message-Id: <20210716212629.2232756-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 00/12] KVM: Add idempotent controls for migrating system
 counter state
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM's current means of saving/restoring system counters is plagued with
temporal issues. At least on ARM64 and x86, we migrate the guest's
system counter by-value through the respective guest system register
values (cntvct_el0, ia32_tsc). Restoring system counters by-value is
brittle as the state is not idempotent: the host system counter is still
oscillating between the attempted save and restore. Furthermore, VMMs
may wish to transparently live migrate guest VMs, meaning that they
include the elapsed time due to live migration blackout in the guest
system counter view. The VMM thread could be preempted for any number of
reasons (scheduler, L0 hypervisor under nested) between the time that
it calculates the desired guest counter value and when KVM actually sets
this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of system counter offsets.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in new ioctls. This series
introduces new vCPU device attributes to provide userspace access to the
vCPU's system counter offset.

Patch 1 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patches 2-3 add support for x86 by shoehorning the new controls into the
pre-existing synchronization heuristics.

Patches 4-5 implement a test for the new additions to
KVM_{GET,SET}_CLOCK.

Patches 6-7 implement at test for the tsc offset attribute introduced in
patch 3.

Patch 8 adds a device attribute for the arm64 virtual counter-timer
offset.

Patch 9 extends the test from patch 7 to cover the arm64 virtual
counter-timer offset.

Patch 10 adds a device attribute for the arm64 physical counter-timer
offset. Currently, this is implemented as a synthetic register, forcing
the guest to trap to the host and emulating the offset in the fast exit
path. Later down the line we will have hardware with FEAT_ECV, which
allows the hypervisor to perform physical counter-timer offsetting in
hardware (CNTPOFF_EL2).

Patch 11 extends the test from patch 7 to cover the arm64 physical
counter-timer offset.

Patch 12 introduces a benchmark to measure the overhead of emulation in
patch 10.

Physical counter benchmark
--------------------------

The following data was collected by running 10000 iterations of the
benchmark test from Patch 6 on an Ampere Mt. Jade reference server, A 2S
machine with 2 80-core Ampere Altra SoCs. Measurements were collected
for both VHE and nVHE operation using the `kvm-arm.mode=` command-line
parameter.

nVHE
----

+--------------------+--------+---------+
|       Metric       | Native | Trapped |
+--------------------+--------+---------+
| Average            | 54ns   | 148ns   |
| Standard Deviation | 124ns  | 122ns   |
| 95th Percentile    | 258ns  | 348ns   |
+--------------------+--------+---------+

VHE
---

+--------------------+--------+---------+
|       Metric       | Native | Trapped |
+--------------------+--------+---------+
| Average            | 53ns   | 152ns   |
| Standard Deviation | 92ns   | 94ns    |
| 95th Percentile    | 204ns  | 307ns   |
+--------------------+--------+---------+

This series applies cleanly to the following commit:

1889228d80fe ("KVM: selftests: smm_test: Test SMM enter from L2")

v1 -> v2:
  - Reimplemented as vCPU device attributes instead of a distinct ioctl.
  - Added the (realtime, host_tsc) instant support to
    KVM_{GET,SET}_CLOCK
  - Changed the arm64 implementation to broadcast counter offset values
    to all vCPUs in a guest. This upholds the architectural expectations
    of a consistent counter-timer across CPUs.
  - Fixed a bug with traps in VHE mode. We now configure traps on every
    transition into a guest to handle differing VMs (trapped, emulated).

Oliver Upton (12):
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace
  tools: arch: x86: pull in pvclock headers
  selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
  selftests: KVM: Add helpers for vCPU device attributes
  selftests: KVM: Introduce system counter offset test
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  selftests: KVM: Add support for aarch64 to system_counter_offset_test
  KVM: arm64: Provide userspace access to the physical counter offset
  selftests: KVM: Test physical counter offsetting
  selftests: KVM: Add counter emulation benchmark

 Documentation/virt/kvm/api.rst                |  42 +-
 Documentation/virt/kvm/locking.rst            |  11 +
 arch/arm64/include/asm/kvm_host.h             |   1 +
 arch/arm64/include/asm/kvm_hyp.h              |   2 -
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h             |   2 +
 arch/arm64/kvm/arch_timer.c                   | 118 ++++-
 arch/arm64/kvm/arm.c                          |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  23 +
 arch/arm64/kvm/hyp/include/hyp/timer-sr.h     |  26 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |   2 -
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  21 +-
 arch/arm64/kvm/hyp/vhe/timer-sr.c             |  27 ++
 arch/x86/include/asm/kvm_host.h               |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   4 +
 arch/x86/kvm/x86.c                            | 421 ++++++++++++++----
 include/kvm/arm_arch_timer.h                  |   2 -
 include/uapi/linux/kvm.h                      |   7 +-
 tools/arch/x86/include/asm/pvclock-abi.h      |  48 ++
 tools/arch/x86/include/asm/pvclock.h          | 103 +++++
 tools/testing/selftests/kvm/.gitignore        |   3 +
 tools/testing/selftests/kvm/Makefile          |   4 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 215 +++++++++
 .../selftests/kvm/include/aarch64/processor.h |  24 +
 .../testing/selftests/kvm/include/kvm_util.h  |  11 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  38 ++
 .../kvm/system_counter_offset_test.c          | 206 +++++++++
 .../selftests/kvm/x86_64/kvm_clock_test.c     | 210 +++++++++
 28 files changed, 1447 insertions(+), 133 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.32.0.402.g57bb445576-goog

