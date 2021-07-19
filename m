Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3733CEE55
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387823AbhGSUf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383726AbhGSSJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:09:23 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1BAC0613DC
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:38:06 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id a19-20020a5d95930000b02904a03acf5d82so2250665ioo.23
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TW3Lwfo6iV3YWWKfTQZnRqKolgBnoTBJnEoEOlUBBIU=;
        b=Ka7NIFYp8eL6xwNwJff+OsKuklDUlOD9dQVG8L4hhr8zIJMW0+qvq3OmyK3dBb39aM
         dVauf6jg209m/BQbQ6WkBJl/Hi6q/5zWGvlKuZw1OhXPVhqAFOnnBf+ntdqe2DLKCRDb
         SI9Kk4VLposrYS16Prq2KpqODez2UdyxnMY6SyXquz0GumkWt1cSa2TmBAGvCPZExGf6
         0IhUVBp5oReWE9HG9T4D8o6rEkh0BmrtjlmhVaHK+1KMWwnGRh7ERe5wbCCmI2aigQRd
         iS4kdmz3knct394pqegei0v3g0IySWFV+Qai5NY/SheK2Fj1Fq8vI5+bGXjvuJdjFEeN
         mtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TW3Lwfo6iV3YWWKfTQZnRqKolgBnoTBJnEoEOlUBBIU=;
        b=NK8y/Q4ryuNJ7zKO6gjhtHUSAbf6ctSo+5FgOC/k5Oz5DRpHl4KGArgXtUv1R8rb9g
         fdlyHshUEm+TwghRX+17w88WjzwX0miUzPyLxbxio5wunPZltslWlr9xF2EupYiZPW9P
         0byIMXPMJYn1cXOzkzrmNZ1CWw3ZcY1UGQmSQyXj/0wcaxM1IuHkecSxP+xw/WnEQAI6
         p1mi/82uMxAZwNZHEvx7EOD/EztXkFBbrxrsSi3SrtB8k+t/0B6bojRavMWPFHElXiTN
         LoT+ybNUyjpSXOweHTy3gUHDVVBXNj+bL3OLACr9g3ksP6yVU4VTaFr8yQkWweXvqfx5
         ZKMA==
X-Gm-Message-State: AOAM530e7Vkx5797iKN05xUjfs9OZm5F9p3qYT5qimwrioBIVm7ftm6s
        cG7ZuE6PGywO4SYm0XhiiKkOERNlAmfpPR95rNKoFSKlNXPOvqwKKcytKpVthXkEFxpJVt9MmuM
        Qk8wL+lVF0Z1daVpIwBz1LZCQ9CxwEVmE9En6UO0QESybcuxRG2JUdCwOIA==
X-Google-Smtp-Source: ABdhPJxAZWRt/inMp7xN5+GhnqHLkGfanEok2D7yX9AeIFdWV2Eh47/OPmYvAnECuaXJ0ytjYuFl7s1PqIk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:2099:: with SMTP id
 a25mr1891457ioa.143.1626720600237; Mon, 19 Jul 2021 11:50:00 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:37 +0000
Message-Id: <20210719184949.1385910-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 00/12] KVM: Add idempotent controls for migrating system
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
  - Added the (realtime, host_tsc) instant support to KVM_{GET,SET}_CLOCK
  - Changed the arm64 implementation to broadcast counter
    offset values to all vCPUs in a guest. This upholds the
    architectural expectations of a consistent counter-timer across CPUs.
  - Fixed a bug with traps in VHE mode. We now configure traps on every
    transition into a guest to handle differing VMs (trapped, emulated).

v2 -> v3:
  - Added documentation for additions to KVM_{GET,SET}_CLOCK
  - Added documentation for all new vCPU attributes
  - Added documentation for suggested algorithm to migrate a guest's
    TSC(s)
  - Bug fixes throughout series
  - Rename KVM_CLOCK_REAL_TIME -> KVM_CLOCK_REALTIME

v1: https://lore.kernel.org/kvm/20210608214742.1897483-1-oupton@google.com/
v2: https://lore.kernel.org/r/20210716212629.2232756-1-oupton@google.com

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
 Documentation/virt/kvm/devices/vcpu.rst       | 101 +++++
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
 arch/x86/kvm/x86.c                            | 422 ++++++++++++++----
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
 29 files changed, 1549 insertions(+), 133 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/timer-sr.h
 create mode 100644 tools/arch/x86/include/asm/pvclock-abi.h
 create mode 100644 tools/arch/x86/include/asm/pvclock.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c

-- 
2.32.0.402.g57bb445576-goog

