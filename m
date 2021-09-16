Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4952340EA5E
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343790AbhIPS5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbhIPS51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:27 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10256C04A14A
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:24 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id p10-20020a92d28a000000b0022b5f9140f7so14845693ilp.9
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=btDL3L/+bb3DbBRXEgGoHsE8Zt71CBQL97fPH4EXk/A=;
        b=pH3ZPSHyuyqIdw7sVb6pv1UZzHZwd5tpk6oKk5pjSrUAGZjaI6gPpcnwmDwWIogj5j
         zj/3RnzxsG3WAEUhnmKI2g0W+tsSXBeox49VmFI5O+cpKSsRpG/6GdcRVsEh7H69XLxb
         XOCV8gStUGRy/QembchUDT3ZrwTt9voEZqdtsOVVh1EdYKxtygL1sfUnFlqfSlCayr3t
         HbiYWAEvdfR74JBhPty46cWzByaiwZHagXS7CSXSfkcVw7Uj5nHRYsUlPFFfU0JkmTYg
         HtQtxiOVYuCMtNh4+rjvCaFJCVWe0PvSpdy9xi6x/3YSDDF8pGUZYGKCaMNPV/IUnAkq
         mkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=btDL3L/+bb3DbBRXEgGoHsE8Zt71CBQL97fPH4EXk/A=;
        b=kUSHmJjfm+UIul1Wiks1c5qoGZHz22/G+SDSjXE9aQ1ko7PGhNCAnAu0B5MkfebmBC
         A/3f+3vzIGAJLcWHb8ZC7LldLZrx72Qxcx+95esPIFnYLcaapXGQWVhO5Lg/lp2LbnwD
         YFOAENLGgXERo0Bv8KtyP51X73A41y44IavjlD39iJpV0SeEniG9eOMrv+e3ukD3kE4O
         uhewcD+KagzkFiRCNEj7RqK/iPhzOfInQ6pBgOP7Ke2SOWpZnaHhU23mekkOTCWhKMGe
         YfZtFNqgxAEIhb/LP5xfPHhz6lHESv/UFo53B65+CwKkYiNNxCj+nvE9tUZBK35MLmc+
         B/Rg==
X-Gm-Message-State: AOAM531laKfRRr3e/zDk/EmpQBSMz0Cw6/PvjJtczNQNQw0ovrYE6DRo
        PzuQutl2PAA5y0UsFztJytdMy2CmvETk5Nik/1/Ri5Yn/tSj3Ap9VDqwUF7oP6knRtCzyas0Qnc
        UT3Iz7XzaC5EYoQ+PexDVz41efQvdJis1/4vXwCFHy4LHAmQq+eeAkeHgpw==
X-Google-Smtp-Source: ABdhPJxFWTKFCHnmW32IKSDzUpsnORPNcQrlWReCXvncQJer79Nhv+dt9vMYUea9GMm6JAvZIYiN8o71iQI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:90a:: with SMTP id y10mr5002860ilg.108.1631816123285;
 Thu, 16 Sep 2021 11:15:23 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:02 +0000
Message-Id: <20210916181510.963449-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/8] KVM: arm64: Add idempotent controls to migrate guest counter
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

Patch 3 is a minor refactor, creating a helper function to get the
number of timer registers for a particular vCPU.

Patch 4 exposes a vCPU's virtual offset through the KVM_*_ONE_REG
ioctls. When NV support is added to KVM, CNTVOFF_EL2 will be considered
a guest system register. So, it is safe to expose it now through that
ioctl.

Patch 5 adds a cpufeature bit to detect 'full' ECV implementations,
providing EL2 with the ability to offset the physical counter-timer.

Patch 6 exposes a vCPU's physical offset as a vCPU device attribute.
This is deliberate, as the attribute is not architectural; KVM uses this
attribute to track the host<->guest offset.

Patch 7 is a prepatory change for the sake of physical offset emulation,
as counter-timer traps must be configured separately for each vCPU.

Patch 8 allows non-ECV hosts to support the physical offset vCPU device
attribute, by trapping and emulating the physical counter registers.

This series was tested on an Ampere Mt. Jade system (non-ECV, VHE and
nVHE). I did not test this on the FVP, as I need to really figure out
tooling for it on my workstation.

Applies cleanly to v5.15-rc1

v7: http://lore.kernel.org/r/20210816001217.3063400-1-oupton@google.com

v7 -> v8:
 - Only use ECV if !VHE
 - Only expose CNTVOFF_EL2 register to userspace with opt-in
 - Refer to the direct_ptimer explicitly

Oliver Upton (8):
  KVM: arm64: Refactor update_vtimer_cntvoff()
  KVM: arm64: Separate guest/host counter offset values
  KVM: arm64: Make a helper function to get nr of timer regs
  KVM: arm64: Allow userspace to configure a vCPU's virtual offset
  arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
  KVM: arm64: Allow userspace to configure a guest's counter-timer
    offset
  KVM: arm64: Configure timer traps in vcpu_load() for VHE
  KVM: arm64: Emulate physical counter offsetting on non-ECV systems

 Documentation/arm64/booting.rst         |   7 +
 Documentation/virt/kvm/api.rst          |  23 +++
 Documentation/virt/kvm/devices/vcpu.rst |  28 ++++
 arch/arm64/include/asm/kvm_host.h       |   3 +
 arch/arm64/include/asm/sysreg.h         |   5 +
 arch/arm64/include/uapi/asm/kvm.h       |   2 +
 arch/arm64/kernel/cpufeature.c          |  10 ++
 arch/arm64/kvm/arch_timer.c             | 196 +++++++++++++++++++++---
 arch/arm64/kvm/arm.c                    |   9 +-
 arch/arm64/kvm/guest.c                  |  28 +++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  32 ++++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  11 +-
 arch/arm64/tools/cpucaps                |   1 +
 include/clocksource/arm_arch_timer.h    |   1 +
 include/kvm/arm_arch_timer.h            |  14 +-
 include/uapi/linux/kvm.h                |   1 +
 16 files changed, 337 insertions(+), 34 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

