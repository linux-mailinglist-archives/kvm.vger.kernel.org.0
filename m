Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE763ECBEE
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhHPAMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbhHPAMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D961CC061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w200-20020a25c7d10000b02905585436b530so15029806ybe.21
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5mrMQ5rgKSJDf7VPeRHLHNRCD8GR57cQzcrJ1T4+wG8=;
        b=lo6ullO6Kp1xDycruAhwYsKGgXPnqzWGDrHQLxnZckr1P61xPB1v7A1arHNGA4MA2f
         1/FETdWS8qyfarlClNbsf8207Ps+zEM71kE4Wvu8mHn+/RXW2PIGPYzE7HAlLHCkmZuX
         7BEbPqI0WNTpwuOxsjrIOB6oQaOpOPZtoRZvj7+X4FfK5TWmrM7Lxj9/LhvRAxyH9GOK
         C3QoxNvrgWXEN6Ql3hLHIUwcJrpB8LfE3es4CWc6TQtq8Yu+6PJnlYw7b3NNPF5vfb44
         yL84b0/IGjXt4hHj2Gf4J2AfbgiQG4D0L0uC2VdiUsMmGaP4HujAqaXzCmhcsmo3l+dC
         AlrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5mrMQ5rgKSJDf7VPeRHLHNRCD8GR57cQzcrJ1T4+wG8=;
        b=cRyM5nndnB5ltYcVwRfgCn+aUmO0jh+TJ5yDpHiEKlggS3mUXOPg8ER4atoqc+N0wR
         Na4CN82w6FCMbaUCBuJ975Jx7ZWqRUtKWIVLfpboZ13tqV+n+pWjoZnljnbz1jo1Q97h
         ttXwc0Kfb08WZibwJtLC5bJGQ8C0SeM2NXJ7McyizCfBwu1wiyRDaoT3WOCGiYIHABi0
         t5n9gECsU11vbGvu+4fydtCoRWPg9Z4iuvLuSijIBkpWy7jw0YgaTqzjYRib4VvvlPHG
         LlrDFBwKqKiQ8/x8zQAH+BrZtODnpUB/r5AtmF2SkKvLHQEN1TKX0Kh8Upyfyl7ITaBC
         suqQ==
X-Gm-Message-State: AOAM530jvihTNnBb37MZFoTN3UEioFWwArnWVyoiYFvvSAmvCfvXZkMg
        Ac2qN7k/ColAiDlaeHVvWHjwpeokErLTz1mNoRuMw2jmSpaz0de6V30dDPbtjEY4gE2qo2HFaxi
        dF9jeEQ7jbJBCzUFXLNluSo2zT7j95sUPrFHSEZulDoz2fU/bouCZEUeitQ==
X-Google-Smtp-Source: ABdhPJxVRmLt9tUt3gGzv0/4JgNLL1IiSIdGK/E6P34z9I+oWRL6HpOccF2RgtNs7bOl/yPJOoA44nyOzDw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:9241:: with SMTP id e1mr17406096ybo.38.1629072741082;
 Sun, 15 Aug 2021 17:12:21 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:10 +0000
Message-Id: <20210816001217.3063400-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/7] KVM: arm64: Add idempotent controls to migrate guest counter
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
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, on KVM/arm64, we only allow a VMM to migrate the guest's
virtual counter by-value. Saving and restoring the counter by value is
problematic in the fact that the recorded state is not idempotent.
Furthermore, we obfuscate from userspace the fact that the architecture
actually provides offset-based controls.

Another issue is that KVM/arm64 doesn't provide userspace with the
controls of the physical counter-timer. This series aims to address both
issues by adding offset-based controls for the virtual and physical
counters.

Patches 1-2 are refactor changes required to provide offset controls to
userspace and putting in some generic plumbing to use for both physical
and virtual offsets.

Patch 3 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
a guest system register. So, it is safe to expose it now through that
ioctl.

Patch 4 adds a cpufeature bit to detect 'full' ECV implementations,
providing EL2 with the ability to offset the physical counter-timer.

Patch 5 exposes a vCPU's physical offset as a vCPU device attribute.
This is deliberate, as the attribute is not architectural; KVM uses this
attribute to track the host<->guest offset.

Patch 6 is a prepatory change for the sake of physical offset emulation,
as counter-timer traps must be configured separately for each vCPU.

Patch 7 allows non-ECV hosts to support the physical offset vCPU device
attribute, by trapping and emulating the physical counter registers.

This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
nVHE) as well as the ARM Base RevC FVP (ECV, VHE and nVHE). Patches
apply to kvmarm/next at the following commit:

ae280335cdb5 ("Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next")

Selftests for these changes are being mailed as a separate series, since
there exist dependencies betwen both x86 and arm64.

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - Fixed typo in documentation (Marc)
 - Clean up some unused variables (Drew)
 - Added trap configuration for ECV+nVHE (Marc)
 - Documented dependency on SCR_EL3.ECVEn (Marc)
 - wrap up ptimer_emulation_required() for use in hyp and kernel code
   (Drew)
 - check static branch condition first (Drew)
 - s/cpus_have_const_cap/cpus_have_final_cap/ (Marc)
 - s/ARM64_ECV/ARM64_HAS_ECV2/
 - Emulate CNTPCTSS_EL2 if ECV2 not present (Marc)
 - Reordered the introduction of some functions to ensure that we don't
   have unused functions in the middle of the series.
 - Cleaned up the read side of CNTVOFF_EL2 (from userspace). Don't
   open-code the answer based on the difference of hardware offsets,
   just use the guest system register value we stashed on the write
   side.

Oliver Upton (7):
  KVM: arm64: Refactor update_vtimer_cntvoff()
  KVM: arm64: Separate guest/host counter offset values
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
  KVM: arm64: Allow userspace to configure a guest's counter-timer
    offset
  KVM: arm64: Configure timer traps in vcpu_load() for VHE
  KVM: arm64: Emulate physical counter offsetting on non-ECV systems

 Documentation/arm64/booting.rst         |   7 +
 Documentation/virt/kvm/api.rst          |  10 ++
 Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
 arch/arm64/include/asm/kvm_asm.h        |   2 +
 arch/arm64/include/asm/sysreg.h         |   5 +
 arch/arm64/include/uapi/asm/kvm.h       |   2 +
 arch/arm64/kernel/cpufeature.c          |  10 ++
 arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   4 +-
 arch/arm64/kvm/guest.c                  |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |   6 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  20 ++-
 arch/arm64/kvm/hyp/vhe/timer-sr.c       |   5 +
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   1 +
 include/kvm/arm_arch_timer.h            |   9 +-
 17 files changed, 315 insertions(+), 29 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

