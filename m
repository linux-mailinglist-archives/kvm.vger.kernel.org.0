Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C951429C79
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 06:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhJLEh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 00:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhJLEh6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 00:37:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5391DC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:35:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t4-20020a62ea04000000b0044b333f5d1bso8589578pfh.20
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 21:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ARkaHXR2eWubzBw8IR0BEjfGZOpO8HzRAR4xytV+aUY=;
        b=rJEX/4vo6+sN+Pcdup+t6VgohqTOZFeSMVj0l6L/LilgI7Rrt4bZo03FgfK/KuMjh2
         CE6XlVtq+h//Eud6aJP/+OmS28Nk0Q6aRATCpBbLtKPVC8fv/vr6cxu9JvIsaaxO2DAS
         ApVsOat8Q/zdFbMJ1qECDB5z8MEwPnIORYVTVB9RT9PxtCXgny/iRpvEHJtPxvpKTAvs
         +KaYJqs8ntc8Cp6REyFGpTuXvwzImbeEAPvbzZF9IeVMZ+BHzjDWD1BcPnwmj1TBTYaC
         Ml7R9O595LgYgYX2NMUlkmSXIgSfYK7lAGdTOw/VDTVfMlsrNU+yvJoRRDx0LfIgfwKh
         IQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ARkaHXR2eWubzBw8IR0BEjfGZOpO8HzRAR4xytV+aUY=;
        b=Z+xwjbaSRqLdvM/Y5tQIJPWDetcJ5o7hSUIeDM0s6CVRbViW9SYHHnBQiTavBn2bTv
         wB/HCfIglBLoc75iOjO2VRmnta9SNyurzK8sISxtS+LRIB3ydrwm3bHO1cvHxff297fI
         QggOLclB9Zb0POvQ1zXssozXAq8h2L2m6epkPj7avfZtWxj9PDTSJdxZWZn9D/BQBrnq
         AtUf23S2lVyRCOtdD45adsByBE500vKmMt6q5MDQl7vwMcgz8rQi56q3Ta0dQfCf9Rxp
         rNOj3P1IDpkJzTHzMbPG/gioBL2m9Csy67GeTcnejSMGsE81HWu1JkORVSPHYo3MdyGi
         iYGQ==
X-Gm-Message-State: AOAM533ARUPj3selkjA3KGsDFOY5knjaMjQN/S6yRK+Iu3oGvlabi8xK
        3VGjlxbCkwjmYTN7qMBkQHWaqlhs6b0=
X-Google-Smtp-Source: ABdhPJzusAZuOFWODA8MBmn37mWBO6zsyEPE7bFvBaG1kzFFfGhoSLSD7AEwe6dtIKVigbydAi7NZbAdl6I=
X-Received: from reiji-vws.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:aa7:91c2:0:b0:44c:a5a4:43d4 with SMTP id
 z2-20020aa791c2000000b0044ca5a443d4mr29252166pfa.20.1634013356858; Mon, 11
 Oct 2021 21:35:56 -0700 (PDT)
Date:   Mon, 11 Oct 2021 21:35:10 -0700
Message-Id: <20211012043535.500493-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 00/25] KVM: arm64: Make CPU ID registers writable by userspace
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In KVM/arm64, values of ID registers for a guest are mostly same as
its host's values except for bits for feature that KVM doesn't support
and for opt-in features that userspace didn't configure.  Userspace
can use KVM_SET_ONE_REG to a set ID register value, but it fails
if userspace attempts to modify the register value.

This patch series adds support to allow userspace to modify a value of
ID registers (as long as KVM can support features that are indicated
in the registers) so userspace can have more control of configuring
and unconfiguring features for guests.
The patch series affects both VHE or non-VHE including protected VMs
for now but should be changed not to affect for protected VMs, which
will have a different way of configuring ID registers [1] based on
its different requirements.
There was a patch series that tried to achieve the same thing [2].
A few snippets of codes in this series were inspired by or came from [2].

Since an initial value of ID registers will be the host value with bits
cleared for unsupported features and for opt-in features that were not
configured, the initial value userspace can see (via KVM_GET_ONE_REG) is
the upper limit that can be set for the register.  Any requests to change
the value that conflicts with opt-in features' configuration will fail.

When a guest tries to use a CPU feature that is not exposed to the guest,
trapping it (to emulate a real CPU's behavior) would generally be a
desirable behavior (when it's possible with no or little side effects).
The later patches in the series add codes for this.  Only features that
can be trapped independently will be trapped by this series though.

The series is based on 5.15-rc5 with the patch series [3] applied.

Patch 01 introduces 'has_reset_once' flag for a vCPU to indicate if the
vCPU reset has been done once.  This is used to initialize ID registers
only at the first vCPU reset.

Patch 02 extends sys_regs[] of kvm_cpu_context to save values of ID
registers for the vCPU. For now, the sanitized host's values are saved
in the array at the first vCPU reset.

Patch 03 introduces arm64_check_features(), which will do a common
validation checking for ID registers.

Patch 04 introduces structure id_reg_info to manage the ID register
specific control of the register value for the guest.

Patch 05 introduces a function to keep consistency of ID register values
between vCPUs at the first KVM_RUN. Also, the patch adds code to prevent
userspace from changing ID register value after the first KVM_RUN.

Patches 06-12 add id_reg_info for ID registers to make them
writable with some specific handling for the registers.

Patch 13 changes KVM_SET_ONE_REG behavior for ID registers to
allow userspace to change ID registers that don't have id_reg_info.

Patch 14 introduces validity checking of feature fractional
fields of ID registers at the first KVM_RUN.

Patch 15 introduces a new capability KVM_CAP_ARM_ID_REG_WRITABLE
to identify that ID registers are writable by userspace.

Patches 16-17 changes the way of using vcpu->arch.cptr_el2/mdcr_el2 to
track certain bits of cptr_el2/mdcr_el2 in the vcpu->arch fields and use
them when setting them for the guest.  The following patches will update
the vcpu->arch fields based on available features for the guest.

Patch 18 introduces struct feature_config_ctrl and some utility
functions to enable trapping of features that are disabled for a guest.

Patches 19-23 add feature_config_ctrl for CPU features, which are
used to program configuration registers to trap each feature.

Patch 24 enables trapping CPU features that are disabled for the
guest based on feature_config_ctrl that were added by patch 18-23.

Patch 25 adds a selftest to validate reading/writing ID registers.

[1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/kvmarm/20211007233439.1826892-1-rananta@google.com/

Reiji Watanabe (25):
  KVM: arm64: Add has_reset_once flag for vcpu
  KVM: arm64: Save ID registers' sanitized value per vCPU
  KVM: arm64: Introduce a validation function for an ID register
  KVM: arm64: Introduce struct id_reg_info
  KVM: arm64: Keep consistency of ID registers between vCPUs
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64DFR0_EL1 writable
  KVM: arm64: Make ID_DFR0_EL1 writable
  KVM: arm64: Make MVFR1_EL1 writable
  KVM: arm64: Make ID registers without id_reg_info writable
  KVM: arm64: Add consistency checking for frac fields of ID registers
  KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_WRITABLE capability
  KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
  KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
  KVM: arm64: Introduce framework to trap disabled features
  KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
  KVM: arm64: Activate trapping of disabled CPU features for the guest
  KVM: arm64: selftests: Introduce id_reg_test

 Documentation/virt/kvm/api.rst                |    8 +
 arch/arm64/include/asm/cpufeature.h           |    1 +
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   18 +-
 arch/arm64/include/asm/sysreg.h               |    1 +
 arch/arm64/kernel/cpufeature.c                |   26 +
 arch/arm64/kvm/arm.c                          |   30 +-
 arch/arm64/kvm/debug.c                        |   13 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/reset.c                        |    4 +
 arch/arm64/kvm/sys_regs.c                     | 1010 +++++++++++--
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1296 +++++++++++++++++
 16 files changed, 2306 insertions(+), 151 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c

-- 
2.33.0.882.g93a45727a2-goog

