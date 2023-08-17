Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440C977EE3F
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347357AbjHQAa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347327AbjHQAae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:30:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3232736
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58c8b2d6784so15549687b3.3
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232232; x=1692837032;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b+30u7Hadsk1kKJhP450GQhawAECfldtwwLSkjuNZSo=;
        b=oJ/CQvox3ccnSVCtz7SydIVQIcgGOxbkhaM3NDAFYe/8agaa33CyRKd6DaYgjevv6/
         Omldr/V1HithlSuUNkL8YcsGa2PCWZ/VSieAqsiV8EV/RO8XTxCIGZ/bAONlsMPuJn1G
         Y+GFNfVU6qDfCz1NYhAjKqbT7oaapzhySzor7xGSlcTNRayLtWpjuOXXsdIhrykFMoiL
         +nIslcWpzEnQagjnY9lvht16YLEbpscdbhUoa+XuUzWidOwgy2dl205ZYpjVXWp6FchX
         Y1qaK0qZzPubV329E4ccE+IHwECaQETparBdxtSOlC/oldFpJBDF4kYdyUA272YAK3ch
         nFzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232232; x=1692837032;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b+30u7Hadsk1kKJhP450GQhawAECfldtwwLSkjuNZSo=;
        b=NaML0fyLnauy6bFovvy4vwuMgaqepRDmtV/u1PYqHTWhB6n2JKG7nP6GLdUTpYSAtU
         yPLwaPz0TUkLcVoQrh+zhxzRXBcoGUqnIjQQWURzhHfMu9hv4jNcwEbtBnzXbJmJ2rel
         eelmJs/7OzHIsUTLsY0//DPHor9lVUIlJiKs27bBjQKYKyaQl0OQPXX02Ghb0D6wZbwB
         2kBvwA9xGrBsoeS4tTQxU9xMVWXSwQ+9zG0bwVXUYlBi3RgYpyvFwJA55cc6qqW8YkS2
         R150CHk2SNA7sPyXZTdgpkTLLCMGDexG4pYTfpiOhONxjKUPtGtgwLkjPg2bIqDBNspX
         hcLA==
X-Gm-Message-State: AOJu0YyQfRWgLuIfEUkIZr8pSo0oDlr3ESfp3vQ/WFLApYLtFpbk3NYl
        brPNnsZFbVqIHxZ8QgxG3JeBwY2EY5SF
X-Google-Smtp-Source: AGHT+IH30MLz99imuYd8az1WoxYlUm/n9smqwxGoczHOBVojWP6GDQqEWzdtTgrxqvadHBd6+52J0LjiwST6
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:b659:0:b0:583:abae:56ab with SMTP id
 h25-20020a81b659000000b00583abae56abmr44554ywk.7.1692232232398; Wed, 16 Aug
 2023 17:30:32 -0700 (PDT)
Date:   Thu, 17 Aug 2023 00:30:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-1-rananta@google.com>
Subject: [PATCH v5 00/12] KVM: arm64: PMU: Allow userspace to limit the number
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
author of the series, I'm posting the v5 with necessary alterations.

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

The series is based on v6.5-rc6.

Patch 1 adds a helper to set a PMU for the guest. This helper will
make it easier for the following patches to add modify codes
for that process.

Patch 2 makes the default PMU for the guest set on the first
vCPU reset.

Patch 3 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 4 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 5 simplifies the existing code that extracts PMCR_EL0.N by
using FIELD_GET().

Patch 6 adds a helper to read vCPU's PMCR_EL0.

Patch 7 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N.

Patch 8 adds support userspace modifying PMCR_EL0.N.

Patch 9-12 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v5:
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

Reiji Watanabe (11):
  KVM: arm64: PMU: Introduce a helper to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   6 +
 arch/arm64/kvm/arm.c                          |   3 +-
 arch/arm64/kvm/pmu-emul.c                     |  82 ++-
 arch/arm64/kvm/reset.c                        |  18 +-
 arch/arm64/kvm/sys_regs.c                     |  96 +--
 drivers/perf/arm_pmuv3.c                      |   3 +-
 include/kvm/arm_pmu.h                         |  12 +
 include/linux/perf/arm_pmuv3.h                |   2 +-
 tools/include/perf/arm_pmuv3.h                | 306 ++++++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 568 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 12 files changed, 1028 insertions(+), 70 deletions(-)
 create mode 100644 tools/include/perf/arm_pmuv3.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
-- 
2.41.0.694.ge786442a9b-goog

