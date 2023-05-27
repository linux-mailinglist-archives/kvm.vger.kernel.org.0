Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115C2713269
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 06:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjE0EEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 00:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjE0EEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 00:04:14 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D267C125
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:12 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565d1b86a63so4057087b3.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 21:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685160252; x=1687752252;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YRT9I4djHwGzJQpPn1+l49c/6modgMoOAial+YqLhwY=;
        b=BXGdvFYKQjWbwlSN17LTz40eGsJgSBo4fqWemkL5mGJCJXAyT0xeNbxV/TRJK+aXpQ
         JVUmwUYsff7pvtBBYyA3OrsQt9YZ8w83aFdUjpVTyZX3WO/aX4llgjGJHlXnvr8ClIL2
         Ny8Y/+DpScYAzHZWAw9dUPaKeJPV7MEEVe8emdvbb+qixsoPE9Fyy/xpOie/Q8fhsPdx
         dlKzYxEGo6DXi0nXTI25DkMe6mjdS1i6xhy0m5XMgSLrCoW3W/k0nvkcp4qF3114VIEV
         zxzWvYHNpHyC6M17Pyrc76PONyLXZootxLrA36Y7cOwL9NCglA42yxpmOrr3zfOyKqZB
         ewXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685160252; x=1687752252;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YRT9I4djHwGzJQpPn1+l49c/6modgMoOAial+YqLhwY=;
        b=W88gXF2vNENQxCIsWM+NZxcwXchnr9R9gDofL8oirnxQbF0drxSIZ164c+f6Mk4ltj
         2yMLhm2dTU/CW2vgJcOavNOyaA+kXnSBZFahwD1zO3qFFOxriUwbf8XVh2WMO9Kxy+kl
         w7EV/xEpPFjGVSdWHGPVaLeUa4+vdPFvpq+iC3D3Z3OXt1isMFZcWRKEiYW3i8fJwrgM
         /6DyHXXVU38X2ElixYxbhjWbEbTYnOsRGviT7VC/UiOYpncZLpMAnhATBJ23Lk1RxSvc
         aMKn3hExHb8KxcxeMDLI1J7fhPcPYHoqn5H+H+uNCigHwmZNdhxB2w/x5468oiLIjjM7
         m7Xg==
X-Gm-Message-State: AC+VfDwXP+aA6m098u5UNyNlV6Ff7McXGQPAX87PBE5GnpFqC/pRKnun
        MPXMEdy1Qkib8NWXjpRC15VpMCeykQw=
X-Google-Smtp-Source: ACHHUZ5IekIIpHORjl7x+5hGHkPPeGv1S2EJr5b4ZPxCk+KXklujX1RFIClDi8UTrmkrrJy104dpqISl5+I=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:690c:727:b0:565:a43e:23c7 with SMTP id
 bt7-20020a05690c072700b00565a43e23c7mr2285571ywb.0.1685160252128; Fri, 26 May
 2023 21:04:12 -0700 (PDT)
Date:   Fri, 26 May 2023 21:02:32 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230527040236.1875860-1-reijiw@google.com>
Subject: [PATCH 0/4] KVM: arm64: PMU: Fix PMUVer handling on heterogeneous PMU systems
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
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

This series fixes issues with PMUVer handling for a guest with
PMU configured on heterogeneous PMU systems.
Specifically, it addresses the following two issues.

[A] The default value of ID_AA64DFR0_EL1.PMUVer of the vCPU is set
    to its sanitized value.  This could be inappropriate on
    heterogeneous PMU systems, as arm64_ftr_bits for PMUVer is defined
    as FTR_EXACT with safe_val == 0 (when ID_AA64DFR0_EL1.PMUVer of all
    PEs on the host is not uniform, the sanitized value will be 0).

[B] KVM uses PMUVer of the PMU hardware that is associated to
    the guest (kvm->arch.arm_pmu->pmuver) for the guest in some
    cases, even though userspace might have changed the guest's
    ID_AA64DFR0_EL1.PMUVer (kvm->arch.dfr0_pmuver.imp).

To fix [A], KVM will set the default value of the guest's
ID_AA64DFR0_EL1.PMUVer to the PMUVer of the guest's PMU
(kvm->arch.arm_pmu->pmuver).

To fix [B], KVM will stop using kvm->arch.arm_pmu->pmuver (except
for some special cases) and use ID_AA64DFR0_EL1.PMUVer for the
guest instead.

Patch 1 adds a helper to set a PMU for the guest. This helper will
make it easier for the following patches to modify the relevant
code.

Patch 2 make the default PMU for the guest set on the first
vCPU reset. As userspace can get the value of ID_AA64DFR0_EL1
after the initial vCPU reset, this change is to make the
default PMUVer value based on the guest's PMU available on
the initial vCPU reset.

Patch 3 and 4 fix the issue [A] and [B] respectively.

The series is based on v6.4-rc3.
The patches in this series were originally included as part of [1].

[1] https://lore.kernel.org/all/20230211031506.4159098-1-reijiw@google.com/

Reiji Watanabe (4):
  KVM: arm64: PMU: Introduce a helper to set the guest's PMU
  KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
  KVM: arm64: PMU: Use PMUVer of the guest's PMU for ID_AA64DFR0.PMUVer
  KVM: arm64: PMU: Don't use the PMUVer of the PMU set for guest

 arch/arm64/include/asm/kvm_host.h |  2 +
 arch/arm64/kvm/arm.c              |  6 ---
 arch/arm64/kvm/pmu-emul.c         | 73 +++++++++++++++++++++----------
 arch/arm64/kvm/reset.c            | 20 ++++++---
 arch/arm64/kvm/sys_regs.c         | 48 +++++++++++++-------
 include/kvm/arm_pmu.h             | 10 ++++-
 6 files changed, 106 insertions(+), 53 deletions(-)


base-commit: 44c026a73be8038f03dbdeef028b642880cf1511
-- 
2.41.0.rc0.172.g3f132b7071-goog

