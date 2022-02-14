Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA7E4B4237
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 07:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiBNG6L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 01:58:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiBNG6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 01:58:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B5575F7
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:58:01 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id h16-20020a17090ac39000b001b8d02b2efaso11512106pjt.5
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 22:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bf6tXmW4Xjw0i9aHU0xXYkS3N9118hlVkcp2QpXKGT8=;
        b=OFKC31x+v6O0/pc4MosKeO3E6kYjrHU69hU/Q5bx8WNwtfNnG4C9/nP2ecC02B7i3E
         BQ3oCQVz67an0H31oEiEjFUBJ8r8rhDgV3m0Txd5ZWcBtjmE9xf5Qb60yWnGb0pSG7yQ
         RNAGsZ4iMQZuODOuUtKUys+bJ1WvUS+G1h2rKB0nlGn8kRgRHgati0kB4IqEeKac2t5w
         BJjAO2wz9QqbVcP35Rt22xq+T3PvlK9p4gSxo8tQtaCWQuhirpHaUXU6zRSX0AqQ8/mj
         lBEvE2LkUrg1RqKEO2jegJRqCdGVTN0yUKDNI/IuLcoXp/NpRA/eCays43YQEEjilKB0
         CLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bf6tXmW4Xjw0i9aHU0xXYkS3N9118hlVkcp2QpXKGT8=;
        b=2LWmm5ODDFNLp9H47eNQuT3VDxlKRepoQMJYre3qDs2jBoyqLWDt8RsLDt3ZChIVdn
         IbvtjmuzfinQAKqrGmmd/9vEe+32gqihh1FA88TzLR69fuWwQx1t3m/nvHGzvq4NsGlb
         DcEMEZt1EE0P/kxAwoutB8AwwHhzHt+LFFuH/kMmw/f75Y9MB/lR0AmoN1GubJ+kx+Ro
         eclRSyJx0+gfJ8Sf2i8V8xhhV9v1znLykrlgfzqXeG41vzQDV80zhPOzrsUVf1Rv2RyY
         PdTXdMy1cZmd1vtbGdLQxRavM/doj+WWjp2oVVIldJoiFUEljz57gL/Ql8v1y6UVj4SL
         rSDQ==
X-Gm-Message-State: AOAM533PKrtMsC1hlv95DJU4Pkn0CbzOWvVS1dqMWdJ6H8gVdONEWYs/
        zBBtG1UEKZYZcP8Zmi7m7qIbZ/H3QDY=
X-Google-Smtp-Source: ABdhPJyUgSMlRdBoRc9I77pRNdSVFFQPR+MJpe46ngdA9aF9Ff5sG4RbUrKOXPK5ekQnEYr4eiZwhdMvLKQ=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:9a9:: with SMTP id
 u41mr12857206pfg.75.1644821881185; Sun, 13 Feb 2022 22:58:01 -0800 (PST)
Date:   Sun, 13 Feb 2022 22:57:19 -0800
Message-Id: <20220214065746.1230608-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 00/27] KVM: arm64: Make CPU ID registers writable by userspace
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
and unconfiguring features for guests.  We need this because we would
like to expose a uniform set/level of features for a group of guests on
systems with different ARM CPUs.  Since some features are not binary
in nature (e.g. AA64DFR0_EL1.BRPs fields indicate number of
breakpoints minus 1), using KVM_ARM_VCPU_INIT to control such features
is inconvenient.

The patch series is for both VHE and non-VHE, except for protected VMs,
which have a different way of configuring ID registers based on its
different requirements [1].
There was a patch series that tried to achieve the same thing [2].
A few snippets of codes in this series were inspired by or came from [2].

The initial value of ID registers for a vCPU will be the host's value
with bits cleared for unsupported features and for opt-in features that
were not configured. So, the initial value userspace can see (via
KVM_GET_ONE_REG) is the upper limit that can be set for the register.
Any requests to change the value that conflicts with opt-in features'
configuration will fail (e.g. if KVM_ARM_VCPU_PMU_V3 is configured by
KVM_ARM_VCPU_INIT, ID_AA64DFR0_EL1.PMUVER cannot be set to zero.
Otherwise, the initial value of ID_AA64DFR0_EL1.PMUVER will be zero,
and cannot be changed from zero).

When a guest tries to use a CPU feature that is not exposed to the guest,
trapping it (to emulate a real CPU's behavior) would generally be a
desirable behavior (when it is possible with no or little side effects).
The later patches in the series add codes for this.  Only features that
can be trapped independently will be trapped by this series though.

This series adds kunit tests for new functions in sys_regs.c (except for
trivial ones), and these tests are enabled with a new configuration
option 'CONFIG_KVM_KUNIT_TEST'.

The series is based on v5.17-rc3 with the patch [3] applied.

v5:
  - Change the return value of kcalloc failure of init_arm64_ftr_bits_kvm
    to -ENOMEM from ENOMEM. [Fuad]
  - Call init_arm64_ftr_bits_kvm from init_cpu_features(). [Ricardo, Fuad]
  - Move is_id_reg() in arch/arm64/kvm/sys_regs.c. [Fuad]
  - Remove frac_ftr_check from feature_frac [Fuad]
  - Rename kvm_id_regs_consistency_check() [Fuad]
  - Add feature_config_ctrl for ID_AA64DFR0_TRACEVER [Fuad]
  - Move changes for kvm_set_id_reg_feature and __modify_kvm_id_reg from
    patch-4 to patch-3. [Fuad]
  - Comment additions and fixes [Fuad]
  - Rename arm64_check_features() [Ricardo]
  - Run arm64_check_features_kvm() for the default guest value [Ricardo]
  - Add ID_AA64MMFR1_EL1.HAFDBS validation
  - Cosmetic fixes

v4: https://lore.kernel.org/all/20220106042708.2869332-1-reijiw@google.com/
  - Make ID registers storage per VM instead of per vCPU. [Marc]
  - Implement arm64_check_features() in arch/arm64/kernel/cpufeature.c
    by using existing codes in the file. [Marc]
  - Use a configuration function to enable traps for disabled
    features. [Marc]
  - Document ID registers become immutable after the first KVM_RUN [Eric]
  - Update ID_AA64PFR0.GIC at the point where a GICv3 is created. [Marc]
  - Get TGranX's bit position by substracting 12 from TGranX_2's bit
    position. [Eric]
  - Don't validate AArch32 ID registers when the system doesn't support
    32bit EL0. [Eric]
  - Add/fixes comments for patches. [Eric]
  - Made bug fixes/improvements of the selftest. [Eric]
  - Added .kunitconfig for arm64 KUnit tests

v3: https://lore.kernel.org/all/20211117064359.2362060-1-reijiw@google.com/
  - Remove ID register consistency checking across vCPUs. [Oliver]
  - Change KVM_CAP_ARM_ID_REG_WRITABLE to
    KVM_CAP_ARM_ID_REG_CONFIGURABLE. [Oliver]
  - Add KUnit testing for ID register validation and trap initialization.
  - Change read_id_reg() to take care of ID_AA64PFR0_EL1.GIC.
  - Add a helper of read_id_reg() (__read_id_reg()) and use the helper
    instead of directly using __vcpu_sys_reg().
  - Change not to run kvm_id_regs_consistency_check() and
    kvm_vcpu_init_traps() for protected VMs.
  - Update selftest to remove test cases for ID register consistency.
    checking across vCPUs and to add test cases for ID_AA64PFR0_EL1.GIC.

v2: https://lore.kernel.org/all/20211103062520.1445832-1-reijiw@google.com/
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
    id_reg_info's validate().

v1: https://lore.kernel.org/all/20211012043535.500493-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20211010145636.1950948-1-tabba@google.com/
[2] https://lore.kernel.org/all/20201102033422.657391-1-liangpeng10@huawei.com/
[3] https://lore.kernel.org/all/20220127161759.53553-2-alexandru.elisei@arm.com/

Reiji Watanabe (27):
  KVM: arm64: Introduce a validation function for an ID register
  KVM: arm64: Save ID registers' sanitized value per guest
  KVM: arm64: Introduce struct id_reg_info
  KVM: arm64: Make ID_AA64PFR0_EL1 writable
  KVM: arm64: Make ID_AA64PFR1_EL1 writable
  KVM: arm64: Make ID_AA64ISAR0_EL1 writable
  KVM: arm64: Make ID_AA64ISAR1_EL1 writable
  KVM: arm64: Make ID_AA64MMFR0_EL1 writable
  KVM: arm64: Make ID_AA64MMFR1_EL1 writable
  KVM: arm64: Hide IMPLEMENTATION DEFINED PMU support for the guest
  KVM: arm64: Make ID_AA64DFR0_EL1 writable
  KVM: arm64: Make ID_DFR0_EL1 writable
  KVM: arm64: Make MVFR1_EL1 writable
  KVM: arm64: Make ID registers without id_reg_info writable
  KVM: arm64: Add consistency checking for frac fields of ID registers
  KVM: arm64: Introduce KVM_CAP_ARM_ID_REG_CONFIGURABLE capability
  KVM: arm64: Add kunit test for ID register validation
  KVM: arm64: Use vcpu->arch cptr_el2 to track value of cptr_el2 for VHE
  KVM: arm64: Use vcpu->arch.mdcr_el2 to track value of mdcr_el2
  KVM: arm64: Introduce framework to trap disabled features
  KVM: arm64: Trap disabled features of ID_AA64PFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64PFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64DFR0_EL1
  KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
  KVM: arm64: Trap disabled features of ID_AA64ISAR1_EL1
  KVM: arm64: Add kunit test for trap initialization
  KVM: arm64: selftests: Introduce id_reg_test

 Documentation/virt/kvm/api.rst                |   12 +
 arch/arm64/include/asm/cpufeature.h           |    3 +-
 arch/arm64/include/asm/kvm_arm.h              |   32 +
 arch/arm64/include/asm/kvm_host.h             |   15 +
 arch/arm64/include/asm/sysreg.h               |    3 +
 arch/arm64/kernel/cpufeature.c                |  229 +++
 arch/arm64/kvm/.kunitconfig                   |    4 +
 arch/arm64/kvm/Kconfig                        |   11 +
 arch/arm64/kvm/arm.c                          |   24 +-
 arch/arm64/kvm/debug.c                        |   13 +-
 arch/arm64/kvm/hyp/vhe/switch.c               |   14 +-
 arch/arm64/kvm/sys_regs.c                     | 1392 +++++++++++++++--
 arch/arm64/kvm/sys_regs_test.c                | 1280 +++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c               |    9 +
 include/uapi/linux/kvm.h                      |    1 +
 tools/arch/arm64/include/asm/sysreg.h         |    1 +
 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../selftests/kvm/aarch64/id_reg_test.c       | 1239 +++++++++++++++
 19 files changed, 4138 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm64/kvm/.kunitconfig
 create mode 100644 arch/arm64/kvm/sys_regs_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/id_reg_test.c


base-commit: 7a0ca515b9f15b68f22ec0feacd868b2c810b0af
-- 
2.35.1.265.g69c8d7142f-goog

