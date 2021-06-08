Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEF3A0668
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhFHVvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:51:02 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:44934 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbhFHVup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:45 -0400
Received: by mail-yb1-f202.google.com with SMTP id u7-20020a259b470000b02904dca50820c2so28778793ybo.11
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZmzQ8drBn8GOJEpgUU5A9TzyvKgZTBK9qQ6Jx96KdBk=;
        b=ZjjQejovMig73skXX6Y9WVM+PbZM26taCHwIUBGYoKgbsHO+ONkHAPfz48Ty9n/xUQ
         Ik5IvX9sU8D10Mf6ZhAvYGzfQqZSIfYdMwPB4fbN3cyyCYRvBNunmETVj+Dpr+iCnDMa
         yEfyw/9H2yAVs4lOZq1KhTOvtEL/gQ0R5aM+j0BB5/Fkqgwf2JMy387voLLMKJfvw8Rc
         MLxLy8totqqVD0S8dgeReMRXs+JNfoNKuYZCNdyfz8IB9Sa7DZ3DQapdRNT97CXXyI/I
         0f0rLEwgTtHezXCTFlZ/sfa1U0iSc+xKx5YGbmOJhFGWpXFQY58dlXmUWvPndnZSlWXv
         EAPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZmzQ8drBn8GOJEpgUU5A9TzyvKgZTBK9qQ6Jx96KdBk=;
        b=OhYtJBCbMtCBiTMe8/Eqj1HOVyKxv5GNeb80LG1nBqzQYEbtrwp9O5M77Sy3Du1Mct
         dv9mIWkeelOurWJwxrwhZ8ulSc0l7MfEEPTOmUz/vTeRf9cJInKa6e5B6WmZ659OMV7W
         5L7BnLCNT/il/xVrrDaS55EBvaEthxSiXT+SO9TDUwZ1Qg06uLmjsDRq0Rc6lSwsQfgI
         9FmOp1TMJfzVInpRa9mEZbsQuKArgeO6cuV90M85Ri7k8d4wqsu3XFfRkRZCHRw620um
         Z9gt2ncH+kHyO+2VyOxfh7D8fTE/PqwS05N8oKkxltbwBPWsiNmayVOIYcwlUEOnsEM0
         larQ==
X-Gm-Message-State: AOAM530IbIpiv1qWEWMKaS1jufcYLi4KsxCBoWcvtS+WhwXu9IRjMAug
        4pyp4ktquQ1i0COVyWNVGlmdY1ZpIer1B67ex/9ohu0gWO2nPKK/PDuIU82ybG4Q8NQgNv7dx3V
        ZREDKJ5lOe/ESds2zckzXQlU5/TnMl5e3dOV2Qn5GcaPeTti23iIN+CQ61A==
X-Google-Smtp-Source: ABdhPJzzqOZPygy1YgOeFl0vdbFwvNNJdzp73oaeWdQ2ebrZaEa+ByO7723NHsVE3GS/0W4v2Makm/XKenM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:3483:: with SMTP id b125mr36945419yba.355.1623188871487;
 Tue, 08 Jun 2021 14:47:51 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:32 +0000
Message-Id: <20210608214742.1897483-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 00/10] KVM: Add idempotent controls for migrating system
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
introduces KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls, meant to provide
userspace with idempotent controls of the guest system counter.

Patch 1 defines the ioctls, and was separated from the two provided
implementations for the sake of review. If it is more intuitive, this
patch can be squashed into the implementation commit.

Patch 2 realizes initial support for ARM64, migrating only the state
associated with the guest's virtual counter-timer. Patch 3 introduces a
KVM selftest to assert that userspace manipulation via the
aforementioned ioctls produces the expected system counter values within
the guest.

Patch 4 extends upon the ARM64 implementation by adding support for
physical counter-timer offsetting. This is currently backed by a
trap-and-emulate implementation, but can also be virtualized in hardware
that fully implements ARMv8.6-ECV. ECV support has been elided from this
series out of convenience for the author :) Patch 5 adds some test cases
to the newly-minted kvm selftest to validate expectations of physical
counter-timer emulation.

Patch 6 introduces yet another KVM selftest for aarch64, intended to
measure the effects of physical counter-timer emulation. Data for this
test can be found below, but basically there is some tradeoff of
overhead for the sake of correctness, but it isn't too bad.

Patches 7-8 add support for the ioctls to x86 by shoehorning the
controls into the pre-existing synchronization heuristics. Patch 7
provides necessary helper methods for the implementation to play nice
with those heuristics, and patch 8 actually implements the ioctls.

Patch 9 adds x86 test cases to the system counter KVM selftest. Lastly,
patch 10 documents the ioctls for both x86 and arm64.

All patches apply cleanly to kvm/next at the following commit:

a4345a7cecfb ("Merge tag 'kvmarm-fixes-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD")

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

Oliver Upton (10):
  KVM: Introduce KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
  KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
  selftests: KVM: Introduce system_counter_state_test
  KVM: arm64: Add userspace control of the guest's physical counter
  selftests: KVM: Add test cases for physical counter offsetting
  selftests: KVM: Add counter emulation benchmark
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Implement KVM_CAP_SYSTEM_COUNTER_STATE
  selftests: KVM: Add support for x86 to system_counter_state_test
  Documentation: KVM: Document KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls

 Documentation/virt/kvm/api.rst                |  98 +++++++
 Documentation/virt/kvm/locking.rst            |  11 +
 arch/arm64/include/asm/kvm_host.h             |   6 +
 arch/arm64/include/asm/sysreg.h               |   1 +
 arch/arm64/include/uapi/asm/kvm.h             |  17 ++
 arch/arm64/kvm/arch_timer.c                   |  84 +++++-
 arch/arm64/kvm/arm.c                          |  25 ++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  31 +++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c            |  16 +-
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/x86.c                            | 176 +++++++++---
 include/uapi/linux/kvm.h                      |   5 +
 tools/testing/selftests/kvm/.gitignore        |   2 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../kvm/aarch64/counter_emulation_benchmark.c | 209 ++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  24 ++
 .../selftests/kvm/system_counter_state_test.c | 256 ++++++++++++++++++
 18 files changed, 926 insertions(+), 47 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
 create mode 100644 tools/testing/selftests/kvm/system_counter_state_test.c

-- 
2.32.0.rc1.229.g3e70b5a671-goog

