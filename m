Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9713966D3D0
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 02:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbjAQBgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 20:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjAQBf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 20:35:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4987468D
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:35:56 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso32657247ybp.20
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 17:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cXMIKYVp+c4Sa+jsYUUChNh+35aTl0TzPBaHrVahGAc=;
        b=Kvh4CvJ7GmN8kUkSghBYRl1ZQpcu4BzNDkpekiOpL3Zi+TsoDhh+x1YNSfTPW+lM6/
         a2STHKxc+7l/h1aTCW0YLE+CCa4OqbXw5elBqpZbB3vnBHGCszGi7hVFHEgVB0ky8OTU
         YAUBENoYICZpoO+Qs9Sm0k68XDt3eu8P7dV/2oodRpbCcKOeYbs0O8iXfS411dCEFjql
         o7f8Uj3GdThd4dD+zxmYyezMDFpiaDmfaLn3QLaws7T9xWn2B6zDvgzM3pT7IEhSvXc0
         Wbzq4s+4Y/ouGD/QXbo6/wgaklLZIaBBe91DnYNmMCvH6MCn3Mi+FPpDLcOKYsC5601/
         xtlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXMIKYVp+c4Sa+jsYUUChNh+35aTl0TzPBaHrVahGAc=;
        b=SSFMWiPI5U+r40vhHtvYSOu7tOFOkh5qqAN1VOJsgT2AXtfayaw+3n6249zr91ew3Y
         YeRHIxbZHr0Vi6ZgEfKGkAYCCBWLLD/jRrq+8LcelQto3JtnNKPWMQU1LnofM5/oQL9H
         RMY5SHzgFACqx8ZORXlHhdI6Ms6AXTATEZYIcOP6rrnnFoGfyzVnO52IOZkmOaU3rp/a
         NyJNI4No4+6kFvFHHAAp8Lh17AwQq77latFc3OinRhk6b+Dax57cd6WzsgU6mTKTIuK3
         xZYhaaWcubtDpombkqV4YBM2H+ZechPU+mck7492/mJyRucwTA7/nbpFgDCFnMAk517a
         xyPg==
X-Gm-Message-State: AFqh2kqqiOqRsADgLRPruG5PSmKZ7SkOALPxlWeztVnSeMFQL1mOFOKM
        VF3LcXoWTu3WYxI8hV4XXh/doRwwVAo=
X-Google-Smtp-Source: AMrXdXuMkKUdTI8/EmoeRlROPqs4UPn1FtCKXJ+AbfVWp3HQ3sK8ZayDheDbCUEAVC0xjpf5YT/8oPb05YI=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:7408:0:b0:3cc:8ab:be2c with SMTP id
 p8-20020a817408000000b003cc08abbe2cmr182266ywc.205.1673919356032; Mon, 16 Jan
 2023 17:35:56 -0800 (PST)
Date:   Mon, 16 Jan 2023 17:35:34 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-1-reijiw@google.com>
Subject: [PATCH v2 0/8] KVM: arm64: PMU: Allow userspace to limit the number
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
of PMU event counters on the vCPU. We need this to support migration
across systems that implement different numbers of counters.

The number of PMU event counters is indicated in PMCR_EL0.N.
For a vCPU with PMUv3 configured, its value will be the same as
the host value by default. Userspace can set PMCR_EL0.N for the
vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
However, it is practically unsupported, as KVM resets PMCR_EL0.N
to the host value on vCPU reset and some KVM code uses the host
value to identify (un)implemented event counters on the vCPU.

This series will ensure that the PMCR_EL0.N value is preserved
on vCPU reset and that KVM doesn't use the host value
to identify (un)implemented event counters on the vCPU.
This allows userspace to limit the number of the PMU event
counters on the vCPU.

Patch 1 fixes reset_pmu_reg() to ensure that (RAZ) bits of
{PMCNTEN,PMOVS}{SET,CLR}_EL1 corresponding to unimplemented event
counters on the vCPU are reset to zero even when PMCR_EL0.N for
the vCPU is different from the host.

Patch 2 is a minor refactoring to use the default PMU register reset
function (reset_pmu_reg()) for PMUSERENR_EL0 and PMCCFILTR_EL0.
(With the Patch 1 change, reset_pmu_reg() can now be used for
those registers)

Patch 3 fixes reset_pmcr() to preserve PMCR_EL0.N for the vCPU on
vCPU reset.

Patch 4 adds the sys_reg's set_user() handler for the PMCR_EL0
to disallow userspace to set PMCR_EL0.N for the vCPU to a value
that is greater than the host value.

Patch 5-8 adds a selftest to verify reading and writing PMU registers
for implemented or unimplemented PMU event counters on the vCPU.

The series is based on v6.2-rc4.

v2:
 - Added the sys_reg's set_user() handler for the PMCR_EL0 to
   disallow userspace to set PMCR_EL0.N for the vCPU to a value
   that is greater than the host value (and added a new test
   case for this behavior). [Oliver]
 - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
   PMCCFILTR_EL0 have UNKNOWN reset values.

v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/

Reiji Watanabe (8):
  KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
  KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
    PMCCFILTR_EL0
  KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
  KVM: arm64: PMU: Disallow userspace to set PMCR.N greater than the
    host value
  tools: arm64: Import perf_event.h
  KVM: selftests: aarch64: Introduce vpmu_counter_access test
  KVM: selftests: aarch64: vPMU register test for implemented counters
  KVM: selftests: aarch64: vPMU register test for unimplemented counters

 arch/arm64/kvm/pmu-emul.c                     |   6 +
 arch/arm64/kvm/sys_regs.c                     |  57 +-
 tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 644 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 6 files changed, 954 insertions(+), 13 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/perf_event.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c


base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
-- 
2.39.0.314.g84b9a713c41-goog

