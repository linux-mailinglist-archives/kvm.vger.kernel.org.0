Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7F4688E5F
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjBCEDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjBCEDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:03:10 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810A210277
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:02:51 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-50e79ffba49so39233767b3.9
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 20:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aEW/Npz2sdHk1B5OTprUVUyiPN1G1EFi6du1BLhPkgg=;
        b=IjRPSeWgMjBBwCHli4Yw1tohOaRbiHodVFVBcp42Td04xRfKajH+/5sxJYxs3aPIIq
         sg/N/xGsMQcvJ2qGly6VuU4VgnsKJfHPoTcQdd3hyACasDChXTGgkLm22UioGKMFfCOs
         AmWnbfkOw4IoZ1vBpzcdd/wzqIustrBn7/l2cdl5tesW0333/tzUt27LS5VzFHG35w2I
         Mh/BqZV4JSBV34wZgjUKrLt5FC6PTcHFRbyrZk9UngDknbmIwxwnWSoRCjMQLUKsdMTC
         w9hVYuwPTK9mxisml+1GwBvMUvOQ4lDI6f7KAsewPvr8ldY2sRFkQJ7/R/6d1Ra/KqM7
         oaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aEW/Npz2sdHk1B5OTprUVUyiPN1G1EFi6du1BLhPkgg=;
        b=Vzj8pAeMJSdWEKB+3JGvFVxsPW0Eo/hGLYOSKhAS4wF3I8ZSSSs/3WlRLidxCdCUmj
         Gd785HMWYk8AGzErWIVlXoYd1lVaxAiXROXhaXC98EPWqPwMXY+R7SirxIpDI9zZf7xV
         ea7j33fj4gVBS9q5mdPLXNkOgnKwcbaAe7y2IQXjGKzrYp8qVP7vIPHvWv8h6LqnMIYi
         X1/FcG7NZMJ+pbshzykqKq3C0BtSJsTkaeFm+5HAeOJiR+ybkB3XbquBJAtyu8OUETYb
         aypBo7x9qoa74HIdwpZQZ03c0dWRptwK5DezATfgQktctq5Vk+uRSEIKYcMSfiJr0ifa
         4fQQ==
X-Gm-Message-State: AO0yUKXnZ1WhCH0IIPxB9owWvcm3b1DKqH/5SxfsUrY8z1HQfeQbggz9
        tqP+dQPy9PilZLxo/zWYkCCSS0kUpuU=
X-Google-Smtp-Source: AK7set+TsD6+Z9hBoYbr1+iHxu4ZqInnlSg1Oe6NDZYC7iweFzclF6WbZV4M9ru1qUDhdb5v+qNknlzyKew=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:b188:0:b0:70c:bbcb:3432 with SMTP id
 h8-20020a25b188000000b0070cbbcb3432mr1191509ybj.173.1675396970806; Thu, 02
 Feb 2023 20:02:50 -0800 (PST)
Date:   Thu,  2 Feb 2023 20:02:28 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203040242.1792453-1-reijiw@google.com>
Subject: [PATCH v3 00/14] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin@google.com, Huang@google.com, shahuang@redhat.com,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

This series also includes bug fixes related to the handling of
PMCR_EL0.N and PMUVer for a vCPU with PMUv3 configured on
heterogeneous PMU systems. The issues to be addressed are:

[A] KVM uses the host PMU's PMUVer (kvm->arch.arm_pmu->pmuver) for
    the vCPU in some cases even though userspace might have changed
    the vCPU's PMUVer(kvm->arch.dfr0_pmuver.imp).
[B] ID_AA64DFR0_EL1.PMUVer of the vCPU is set based on the sanitized
    value of the field.  This could be inappropriate on heterogeneous
    PMU systems because only one of PMUs on the system can be
    associated to the guest anyway.
[C] The value of PMCR_EL0.N for the vCPU is set to the same value
    as the current PE.  The value might be different from
    the PMCR_EL0.N value of the PMU associated with the guest.

To fix [A], we will stop using kvm->arch.arm_pmu->pmuver in this series.

To fix [B] and [C], the vCPU's PMCR_EL0.N and ID_AA64DFR0_EL1.PMUVer
will be set based on the host's PMU (kvm->arch.arm_pmu->pmuver) by
default in this series.  When the PMU is changed for the guest using
KVM_ARM_VCPU_PMU_V3_SET_PMU, those are reset to the new PMU's values.
See patch 2, 3, and 9 for more details.

The series is based on v6.2-rc6.

Patch 1 add a helper to set a PMU for the guest. This helper will
make it easier for the following patches to add modify codes
for that process.

Patch 2 make the default PMU for the guest set on the first
vCPU reset.

Patch 3 and 4 fixes the issue [B] and [A], respectively.

Patch 5 fixes reset_pmu_reg() to ensure that (RAZ) bits of
PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
PMOVS{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero.

Patch 6 is a minor refactoring to use the default PMU register reset
function for PMUSERENR_EL0 and PMCCFILTR_EL0.

Patch 7 simplifies the existing code that extracts PMCR_EL0.N by
using FIELD_GET().

Patch 8 add a helper to read vCPU's PMCR_EL0.

Patch 9 changes the code to use the guest's PMCR_EL0.N, instead
of the PE's PMCR_EL0.N. This patch fixes the issue [C].

Patch 10 adds support userspace modifying PMCR_EL0.N.

Patch 11-14 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

v3:
 - Remove reset_pmu_reg(), and use reset_val() instead. [Marc]
 - Fixed the initial value of PMCR_EL0.N on heterogeneous
   PMU systems. [Oliver]
 - Fixed PMUVer issues on heterogeneous PMU systems.
 - Fixed typos [Shaoqin]

v2: https://lore.kernel.org/all/20230117013542.371944-1-reijiw@google.com/
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Reiji Watanabe (14):
  KVM: arm64: PMU: Introduce a helper to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Don't use the sanitized value for PMUVer
  KVM: arm64: PMU: Don't use the PMUVer of the PMU set for the guest
  KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and PMOVS{SET,CLR} on vCPU
    reset
  KVM: arm64: PMU: Don't define the sysreg reset() for
    PM{USERENR,CCFILTR}_EL0
  KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
  KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
  KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
  KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/include/asm/kvm_host.h             |   7 +
 arch/arm64/include/asm/perf_event.h           |   2 +-
 arch/arm64/kernel/perf_event.c                |   3 +-
 arch/arm64/kvm/arm.c                          |   9 +-
 arch/arm64/kvm/pmu-emul.c                     |  81 ++-
 arch/arm64/kvm/reset.c                        |  21 +-
 arch/arm64/kvm/sys_regs.c                     | 133 ++--
 include/kvm/arm_pmu.h                         |  13 +-
 tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 643 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 12 files changed, 1083 insertions(+), 89 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 6d796c50f84ca79f1722bb131799e5a5710c4700
-- 
2.39.1.519.gcb327c4b5f-goog

