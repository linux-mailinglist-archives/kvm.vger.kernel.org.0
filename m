Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579887D1843
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345309AbjJTVlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345256AbjJTVlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:04 -0400
Received: from mail-oi1-x249.google.com (mail-oi1-x249.google.com [IPv6:2607:f8b0:4864:20::249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF80D6C
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:40:57 -0700 (PDT)
Received: by mail-oi1-x249.google.com with SMTP id 5614622812f47-3b2ecaf68dbso2106105b6e.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838057; x=1698442857; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9uyJIMwTKYCyWOffk6DDwTmldfLUB0YlKCSR4JSJIpA=;
        b=pxFTSKGnh0CYrGc22yftWW+2jtL1LdociyDjM6W5a0bkcgRxB3Qz90L/0DeasiAMBC
         85VdZ/scrmwGfFgyxg53KnXtj2Z6O/QXkwzkKepGZNbG8QZ0WaZrHMgokIgMB+0vI1YK
         wLOXWHXDTwojFhZpDkshPwM5npCdBiU0VTtzueMH3QG0ZSFgeJ+ybM3wwvOXAByWLneQ
         1QUFqzJkN3Krk8xsFXcQ4my47TjVPY4mZk7PylB3fBkiyGI1+hTe81lKnK+Z3K4E+/sv
         IZ+xdJXf6pQJaGLafdMwZLUSkJo2gKdLB3DVkc/73Eg2c9hD6qUgjZ2jWYHiiJSSU9tj
         Z5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838057; x=1698442857;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9uyJIMwTKYCyWOffk6DDwTmldfLUB0YlKCSR4JSJIpA=;
        b=EPxhDGjkfnFm3gfRDl49SA/VoQACbptG5v7rNgI22xgK46tiey35N06F7NEJX693g7
         utbvkIH4yax8/vTG1PWwZMUJkcKSik45tRF9jHWpVq/ORKg2MYRcUJ+Kz1MipKEh/Tmf
         ouDliL26QvHSL3tjdxy84Fl/vZRWHMg1eH6gWylSAHGOjG1A8l7OgMPhzJxw2AEZNBYM
         9sewkobzosszOltxZ5vG/VbK5nH5Z6OdIpkvYSnr+Dvdz4uOu1P2Fzi7uAbeTH4v8i8G
         AmtZd73L0yLlg0F2Pc8ct1dfa023I5v5JkSykDxEqN4/cMTyoYq9fjbVZiPVHaHcBxfc
         dPpA==
X-Gm-Message-State: AOJu0YzkysxtzwgKAvK4qyJoVTaF7n17MOcaYjdUE76Ag4q2L9sLWxge
        cVPfN7OmdFgvDek05+/xDZ+FwYa57FsQ
X-Google-Smtp-Source: AGHT+IEVJCO6jjS10yQjQNjSGC21aaOcD4Beut4oHBDK6jrEqw40q2pxVUdIyGgKdLHvaRO+kKxVcl4Nm5I0
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6808:308f:b0:3ae:2710:cf87 with SMTP
 id bl15-20020a056808308f00b003ae2710cf87mr1055498oib.7.1697838056993; Fri, 20
 Oct 2023 14:40:56 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-1-rananta@google.com>
Subject: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The goal of this series is to allow userspace to limit the number
of PMU event counters on the vCPU.  We need this to support migration
across systems that implement different numbers of counters.

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the current PE by default.  Userspace can set PMCR_EL0.N for the
vCPU to any value even with the current KVM using KVM_SET_ONE_REG.
However, it is practically unsupported, as KVM resets PMCR_EL0.N
to the host value on vCPU reset and some KVM code uses the host
value to identify (un)implemented event counters on the vCPU.

This series will ensure that the PMCR_EL0.N value is preserved
on vCPU reset and that KVM doesn't use the host value
to identify (un)implemented event counters on the vCPU.
This allows userspace to limit the number of the PMU event
counters on the vCPU.

The series is based on kvmarm/next @0a3a1665cbc59 to include the
vCPU reset and feature flags cleanup/fixes series [1] and the
new sysreg definitions [2] that the selftests in this series utilizes.

Patch 1 adds helper functions to set a PMU for the guest. This
helper will make it easier for the following patches to add
modify codes for that process.

Patch 2 makes the default PMU for the guest set before the first
vCPU reset.

Patch 3 adds a helper to read vCPU's PMCR_EL0.

Patch 4 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N.

Patch 5 adds userspace handlers for PM{C,I}NTEN{SET,CLR} and
PMOVS{SET,CLR} to consider the guest's PMCR.N.

Patch 6 sanitizes the PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} registers
before the first run of the guest based on the number of counters
configured.

Patch 7 adds support userspace modifying PMCR_EL0.N.

Patch 8-13 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v8: Thanks, Oliver, Sebastian, and Eric for suggestions
- Drop v7 patches 3 and 4, and bring back initializing the
  PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} registers with unknown
  values. (Eric)
- Implement {get,set}_user callbacks for PM{C,I}NTEN{SET,CLR} and
  PMOVS{SET,CLR} registers. (Oliver)
- Sanitize PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} registers
  before starting the first vCPU run. (Oliver)
- Rename kvm_vcpu_set_pmu() to kvm_setup_vcpu(). (Oliver)
- Rename kvm_arm_get_num_counters() to kvm_arm_pmu_get_max_counters()
  and squash it into the caller's patch. (Oliver)
- In set_pmcr() implementation, do not initialize the pmcr register
  with kvm_vcpu_read_pmcr(). (Oliver) 
- Introduce test_create_vpmu_vm_with_pmcr_n() in the selftest to
  carry the commonly used code of creating a VM and configuring
  its PMCR.N field. (Eric)
- Add a selftest scenario to check the immutable behavior of
  the registers. (Sebastian)
- Add a selftest scenario to check the valid behavior of
  PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} registers when accessed
  from userspace.
- Address other nits.

v7: Thanks, Oliver for the suggestions
- Rebase the series onto kvmarm/next.
- Move the logic to set the default PMU for the guest from
  kvm_reset_vcpu() to __kvm_vcpu_set_target() to deal with the
  error returned.
- Add a helper, kvm_arm_get_num_counters(), to read the number
  of general-purpose counters.
- Use this helper to fix the error reported by kernel test robot [3].

v6: Thanks, Oliver and Shaoqin for the suggestions
- Split the previously defined kvm_arm_set_vm_pmu() into separate
  functions: default arm_pmu and a caller requested arm_pmu.
- Send -EINVAL from kvm_reset_vcpu(), instead of -ENODEV for the
  case where KVM fails to set a default arm_pmu, to remain consistent
  with the existing behavior.
- Drop the v5 patch-5/12 that removes ARMV8_PMU_PMCR_N_MASK and adds
  ARMV8_PMU_PMCR_N. Make corresponding changes to v5 patch-6/12.
- Disregard introducing 'pmcr_n_limit' in kvm->arch as a member to
  be accessed later in 'set_pmcr()'. Instead, directly obtain the
  value by accessing the saved 'arm_pmu'.
- 'set_pmcr()' ignores the error when userspace tries to set PMCR.N
  greater than the hardware limit to keep the existing API behavior.
- 'set_pmcr()' ignores modifications to the register after the VM has
  started and returns a success to userspace.
- Introduce [get|set]_pmcr_n() helpers in the selftest to make
  modifications to the field easier.
- Define the 'vpmu_vm' globally in the selftest, instead of allocating
  it every time a VM is created.
- Use the new printf style __GUEST_ASSERT()s in the selftest. 

v5:
https://lore.kernel.org/all/20230817003029.3073210-1-rananta@google.com/
 - Drop the patches (v4 3,4) related to PMU version fixes as it's
   now being handled in a separate series [4].
 - Switch to config_lock, instead of kvm->lock, while configuring
   the guest PMU.
 - Instead of continuing after a WARN_ON() for the return value of
   kvm_arm_set_vm_pmu() in kvm_arm_pmu_v3_set_pmu(), patch-1 now
   returns from the function immediately with the error code.
 - Fix WARN_ON() logic in kvm_host_pmu_init() (patch v4 9/14).
 - Instead of returning 0, return -ENODEV from the
   kvm_arm_set_vm_pmu() stub function.
 - Do not define the PMEVN_CASE() and PMEVN_SWITCH() macros in
   the selftest code as they are now included in the imported
   arm_pmuv3.h header.
 - Since the (initial) purpose of the selftest is to test the
   accessibility of the counter registers, remove the functional
   test at the end of test_access_pmc_regs(). It'll be added
   later in a separate series.
 - Introduce additional helper functions (destroy_vpmu_vm(),
   PMC_ACC_TO_IDX()) in the selftest for ease of maintenance
   and debugging.
   
v4:
https://lore.kernel.org/all/20230211031506.4159098-1-reijiw@google.com/
 - Fix the selftest bug in patch 13 (Have test_access_pmc_regs() to
   specify pmc index for test_bitmap_pmu_regs() instead of bit-shifted
   value (Thank you Raghavendra for the reporting the issue!).

v3:
https://lore.kernel.org/all/20230203040242.1792453-1-reijiw@google.com/
 - Remove reset_pmu_reg(), and use reset_val() instead. [Marc]
 - Fixed the initial value of PMCR_EL0.N on heterogeneous
   PMU systems. [Oliver]
 - Fixed PMUVer issues on heterogeneous PMU systems.
 - Fixed typos [Shaoqin]

v2:
https://lore.kernel.org/all/20230117013542.371944-1-reijiw@google.com/
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1:
https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Thank you.
Raghavendra

[1]: https://lore.kernel.org/all/20230920195036.1169791-1-oliver.upton@linux.dev/
[2]: https://lore.kernel.org/all/20231011195740.3349631-5-oliver.upton@linux.dev/
[3]: https://lore.kernel.org/all/202309290607.Qgg05wKw-lkp@intel.com/
[4]: https://lore.kernel.org/all/20230728181907.1759513-1-reijiw@google.com/

Raghavendra Rao Ananta (6):
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR},
    PMOVS{SET,CLR}
  KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR} before first
    run
  tools: Import arm_pmuv3.h
  KVM: selftests: aarch64: vPMU test for validating user accesses
  KVM: selftests: aarch64: vPMU test for immutability

Reiji Watanabe (7):
  KVM: arm64: PMU: Introduce helpers to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest before vCPU reset
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |  22 +-
 arch/arm64/kvm/pmu-emul.c                     | 112 ++-
 arch/arm64/kvm/sys_regs.c                     | 180 ++++-
 include/kvm/arm_pmu.h                         |  20 +
 tools/include/perf/arm_pmuv3.h                | 308 ++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 726 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 9 files changed, 1319 insertions(+), 54 deletions(-)
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 0a3a1665cbc59ee8d6326aa6c0b4a8d1cd67dda3
-- 
2.42.0.655.g421f12c284-goog

