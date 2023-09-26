Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E5C7AF7D3
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 03:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbjI0Bwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 21:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbjI0Buo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 21:50:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0381660F
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:12 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d868842eda1so11016018276.0
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695771611; x=1696376411; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DBZz03nR6vXHP7+mhK+zZem9sUDVZQM80l4Hk2l9+oM=;
        b=3i0PcMdS9aCbrPPQEQHqjwIu1LaPspIkkkn/lKQDNmskMy8HtbJG3UuGwdDVI3rfXb
         wCgcPY8D7wFsRojoFBQySMHr2QNJSTFs/RHioJksL/KNvLxcGtX8EXndh1NkDkfFMTrT
         KGatNw2gDSuyGSUcL5NYEEOXgrKv1rDDX22Q8FgQiTx3oKNLmvXkxbLBUtzKBq8abMmq
         JdmurmVgEh0pCtQ6sRnJtQ7H5QOgkC44ZFl684cs+ybF5Hg+VP3N0Z3L07aHYC4DBTCl
         4gRdEDEHlDFGRTFhEV27BBaX4scwiEb2MKWhruha+gOGWi7DL5IdI75b84eq3/aV4kIq
         T2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695771611; x=1696376411;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBZz03nR6vXHP7+mhK+zZem9sUDVZQM80l4Hk2l9+oM=;
        b=PTMjEKrwjb6rhktH2kTWQkP26dPaDK4X/jYeIZAMFDBJB59ARUDgopk6dQMHZ2i7h0
         XqVXecEzjzeLi+Z3onX3j70ozsP4ErCIi6QOcwLVJeD8SqSW/VIEcoEBq6hQhxmdlO5U
         CnQrd+yiNJJ0u1oZJsyHMyU8Br8yxyfAERN1CIJyW3lAVHyOM+YDJ4xNeSqOgf9b0NF7
         I0dd/VEl5miBInAYlTITLDW3TSa67tBbQaIq52ht6BcH0GbzIEkv3QNv3PYTuj86iA08
         gCEacVa+b0Yz6hZITv9IUjgNKopDMRa9jGspsOLGXJE4JBfZRqekXIKaZxxKUOOtvkC2
         ZXbA==
X-Gm-Message-State: AOJu0YxDZwCizZO2UzQ5MnmLMXcQhTffUaSXBMKAM4tB4rIMC+VopDtx
        fkQXRlLGq3Q3Ap+572oP+sth6CC9MnMv
X-Google-Smtp-Source: AGHT+IH+SqAHAb/x2o7VLSGDQEey3HjL5K5XEMJ7sW/4mrbG9+wfDWdp+8z1rmq6Ubznn1Ur71amL8i04drG
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:541:b0:d0c:c83b:94ed with SMTP id
 z1-20020a056902054100b00d0cc83b94edmr4524ybs.10.1695771611520; Tue, 26 Sep
 2023 16:40:11 -0700 (PDT)
Date:   Tue, 26 Sep 2023 23:39:57 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230926234008.2348607-1-rananta@google.com>
Subject: [PATCH v6 00/11] KVM: arm64: PMU: Allow userspace to limit the number
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

With permission from Reiji Watanabe <reijiw@google.com>, the original
author of the series, I'm posting the v6 with necessary alterations.

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

The series is based on v6.6-rc3.

Patch 1 adds helper functions to set a PMU for the guest. This
helper will make it easier for the following patches to add
modify codes for that process.

Patch 2 makes the default PMU for the guest set on the first
vCPU reset.

Patch 3 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 4 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 5 adds a helper to read vCPU's PMCR_EL0.

Patch 6 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N.

Patch 7 adds support userspace modifying PMCR_EL0.N.

Patch 8-11 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

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
   now being handled in a separate series [1].
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

[1]:
https://lore.kernel.org/all/20230728181907.1759513-1-reijiw@google.com/

Raghavendra Rao Ananta (1):
  tools: Import arm_pmuv3.h

Reiji Watanabe (10):
  KVM: arm64: PMU: Introduce helpers to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |   3 +-
 arch/arm64/kvm/pmu-emul.c                     |  91 ++-
 arch/arm64/kvm/reset.c                        |  18 +-
 arch/arm64/kvm/sys_regs.c                     | 102 ++-
 include/kvm/arm_pmu.h                         |  12 +
 tools/include/perf/arm_pmuv3.h                | 308 +++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 590 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 10 files changed, 1064 insertions(+), 65 deletions(-)
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.42.0.582.g8ccd20d70d-goog

