Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D3B414970
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhIVMsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbhIVMsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:48:37 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1F0C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:07 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id f34-20020a05622a1a2200b0029c338949c1so9012825qtb.8
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yFOEbvnmLRE/MkTldpqRjjZcedskEwLRag9pY/Gsti8=;
        b=lqFiVOFnQ+0KhLoph58xwAtl+YvZwPQXFz7TkOFZ5ID33rHZ8/wh5S8eX3QOIhQI3s
         AvBhm2vjK6T/lB7ri+u4Pl81oSKqbJWOlGbpOaAMArLOz8DRgLT2whq7bHmNeBIJ+zcT
         8HmFgRKSCbVoNfjXt41sG9VIEHy+P7U4k4tkHp0OPQ70jwdeJEdrEYqdlRqHdcVyN83N
         S5YkaxfymReqcbqI1j5CnxWnBzo7oYAR4jj1cW0rbOoYiySu109OviCq05WzH2nZcnLp
         1bPohbKzJ+hJ5cd12GyXd3+GE3UCd76qxejPwwDTh1Zz8j98F8TPUhH+PLu8gIPsHuX6
         oCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yFOEbvnmLRE/MkTldpqRjjZcedskEwLRag9pY/Gsti8=;
        b=40mWkbcIvEpj8kmpNdZ2ISZikjShavnLUfkyUmDUBhhHeuXhrIWZaf0NmikJybonaG
         3PYS/faPC+qYMo2gb6NqLGGxe3BLOntQAlp9ekWoYfacdcPuBEWD8l1mH38dlZVUOgzs
         xMYookl/bUIvmf+wYzBLbz9Q7dVahkr7aCGUuXfAl4mgymxmjy/hBrNHKI+pWJiTqGHc
         PHEnXUe1ncff3J3Hkb+x559Kp5YBaCwMOHcpTyMzhZ/LtrXMracPaH9z/3ZLXFuQQ4MN
         7QyvEEUmWA8EECb5rUroFQQBWFGXpPHSoDcVwWtA3wdfEUoQhpidzdRZ63ulYTuCYOXm
         8Wzg==
X-Gm-Message-State: AOAM531ZX3yNS+7n55npu3S2zEXOO0LAry4Is0rgJ8jHAM1UPnTa4ewm
        T1tCgW6iNvkLkpF6QWKyYbjbrUc7hg==
X-Google-Smtp-Source: ABdhPJyoWFoyStmCkS24R7d0GBY3bV8l/thty5+34iLzeNvMU3bFfF8UZu0rNinvkttL3hXSDtynpikIVA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:5554:: with SMTP id v20mr36606923qvy.16.1632314826731;
 Wed, 22 Sep 2021 05:47:06 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:46:52 +0100
Message-Id: <20210922124704.600087-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 00/12] KVM: arm64: Fixed features for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Changes since v5 [1]:
- Rebase on 5.15-rc2
- Include Marc's early exception handlers in the series
- Refactoring and fixes (Drew, Marc)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [1].

This series is based on 5.15-rc2. You can find the applied series here [2].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v6

Fuad Tabba (9):
  KVM: arm64: Add missing FORCE prerequisite in Makefile
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add handlers for protected VM System Registers
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

Marc Zyngier (3):
  KVM: arm64: Move __get_fault_info() and co into their own include file
  KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
  KVM: arm64: Move early handlers to per-EC handlers

 arch/arm64/include/asm/kvm_arm.h           |   1 +
 arch/arm64/include/asm/kvm_asm.h           |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h  | 195 ++++++++
 arch/arm64/include/asm/kvm_host.h          |   2 +
 arch/arm64/include/asm/kvm_hyp.h           |   5 +
 arch/arm64/kvm/arm.c                       |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h     |  75 ++++
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 221 ++++-----
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  14 +
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h |  28 ++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   4 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  12 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 186 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           | 117 +++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 494 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            |  17 +
 arch/arm64/kvm/sys_regs.c                  |  10 +-
 18 files changed, 1257 insertions(+), 146 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: e4e737bb5c170df6135a127739a9e6148ee3da82
-- 
2.33.0.464.g1972c5931b-goog

