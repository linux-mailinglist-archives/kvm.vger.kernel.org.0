Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E180C443D11
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbhKCG3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCG3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:29:46 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E83EC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 23:27:10 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w5-20020a654105000000b002692534afceso1026236pgp.8
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 23:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nOpE9XVDgQOIo/EJs2jaMDIMC2kgYNF2JDnFhdJTdr4=;
        b=alR/PVozPXxI+DTzgB9UiN0rnqOz8EhyWoNbPB3LJLbK9Af6UePyRp74QzL8TTmQbs
         1FPjSYevscpHUsmHkDMbj/iJblVmwQ8Szd3K27rlrrwIoPFaxAdG/pyQNTmexiyhhHPA
         VZnKbNJEtDzYrdi5So9pVrC0IvI3JW+MtO9AcipNN1V6UqO8SdG93YW1goR/zB5F5CFa
         e+9OIlnUrdWSqJuh1c4jfWQ6TEWZdjmDPbqM7dG/ovFsnxUvj5CA3RwTdAkTogKr2LLn
         eNN4WzzWMwJipvU9QtOT1/lD2jXZ+s4nFBdN/f8+sX7yU4i3E+YLOwolhALblWKIKpjG
         IV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nOpE9XVDgQOIo/EJs2jaMDIMC2kgYNF2JDnFhdJTdr4=;
        b=YzARlKjuAMvSFGkjvMuEbgCMjut9D+7Lqgs+5LzzetpjRGgCxxqIfIsKmCmqO+pzjN
         JUCmgN7XsDGzE3ea5ZtsRh9qFbByFR4Tvmx2sOTwNjTVGMj84D4x+vnIKabZXXefotWd
         FfaFAl5+cb/SFLHwlNZo7Sf92aMUgxL9qrorhm7M30KHc+F4gtwEgBxcIXs5m9vD9kzL
         42AwG0jjYh6oC2X2K2YpsooMm4bPEyX8akwUBlhdXg7oXSwQCV/Wmw2eTey+RzrnMqpF
         KkcXssSQ77AoWmF8P4Pxxs8WKp8caMwNzh/7XmjrqKf5TPpy1R4n4XOlcXBsoi3msLOW
         CUVQ==
X-Gm-Message-State: AOAM531IDXdlOcH9g/nDKhpH4+kU0rcYTgI3TpE1Ytpxi6FVBVzgh8w8
        8Zyg4zh+aLUXAT2o+VJklq0DPY+DEt8=
X-Google-Smtp-Source: ABdhPJyAcuKAnRL2nqwyBBddlsT73iHPXL9DpaQ7c+DPjyAlP13VWMhR1DxTmZ4CAAgmV7tDs21sykbK9OU=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id
 u14-20020a170902e5ce00b00142078078dbmr9392206plf.12.1635920829651; Tue, 02
 Nov 2021 23:27:09 -0700 (PDT)
Date:   Tue,  2 Nov 2021 23:24:52 -0700
Message-Id: <20211103062520.1445832-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 00/28] KVM: arm64: Make CPU ID registers writable by userspace
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

The initial value of ID registers for a vCPU will be the host's value
with bits cleared for unsupported features and for opt-in features that
were not configured. So, the initial value userspace can see (via
KVM_GET_ONE_REG) is the upper limit that can be set for the register.
Any requests to change the value that conflicts with opt-in features'
configuration will fail.

When a guest tries to use a CPU feature that is not exposed to the guest,
trapping it (to emulate a real CPU's behavior) would generally be a
desirable behavior (when it's possible with no or little side effects).
The later patches in the series add codes for this.  Only features that
can be trapped independently will be trapped by this series though.

The series is based on v5.15 with the patch series [3] applied.

v2:
  - Remove unnecessary line breaks. [Andrew]
  - Use @params for comments. [Andrew]
  - Move arm64_check_features to arch/arm64/kvm/sys_regs.c and
    change that KVM specific feature check function.  [Andrew]
  - Remove unnecessary raz handling from __set_id_reg. [Andrew]
  - Remove sys_val field from the initial id_reg_info and add it
    in the later patch. [Andrew]
  - Call id_reg->init() from id_reg_info_init(). [Andrew]
  - Fix cpuid_feature_cap_perfmon_field() to convert 0xf to 0x0
    (and use it in the following patches).
  - Change kvm_vcpu_first_run_init to set has_run_once to false
    when kvm_id_regs_consistency_check() fails.
  - Add a patch to introduce id_reg_info for ID_AA64MMFR0_EL1,
    which requires special validity checking for TGran*_2 fields.
  - Add patches to introduce id_reg_info for ID_DFR1_EL1 and
    ID_MMFR0_EL1, which are required due to arm64_check_features
    implementation change.
  - Add a new argument, which is a pointer to id_reg_info, for
    id_reg_info's validate()

v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/

[1] https://lore.kernel.org/kvmarm/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/kvm/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/kvmarm/20211007233439.1826892-1-rananta@google.com/

Reiji Watanabe (28):
  KVM: arm64: Add has_reset_once flag for vcpu
  KVM: arm64: Save ID registers' sanitized value per vCPU
  KVM: arm64: Introduce struct id_reg_info
  KVM: arm64: Keep consistency of ID registers between vCPUs
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64MMFR0_EL1 writable
  KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
  KVM: arm64: Make ID_AA64DFR0_EL1 writable
  KVM: arm64: Make ID_DFR0_EL1 writable
  KVM: arm64: Make ID_DFR1_EL1 writable
  KVM: arm64: Make ID_MMFR0_EL1 writable
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
 arch/arm64/include/asm/cpufeature.h           |    2 +-
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   18 +-
 arch/arm64/include/asm/sysreg.h               |    2 +
 arch/arm64/kvm/arm.c                          |   31 +-
 arch/arm64/kvm/debug.c                        |   13 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/reset.c                        |    4 +
 arch/arm64/kvm/sys_regs.c                     | 1236 ++++++++++++++--
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1296 +++++++++++++++++
 15 files changed, 2508 insertions(+), 152 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c

-- 
2.33.1.1089.g2158813163f-goog

