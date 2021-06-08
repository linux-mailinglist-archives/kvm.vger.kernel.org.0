Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC0C39F8AD
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhFHOOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:51 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:49081 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbhFHOOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:50 -0400
Received: by mail-qk1-f202.google.com with SMTP id 2-20020a3709020000b02903aa9873df32so5516028qkj.15
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=o2JaYusrSX5g5l6Yw6yxi3k3vNOoBMCguurDm0+l8Ag=;
        b=QAjX942AbHdhVv90FgSKKOKWthZhg07ww0LE/PswekVtnTIQ+FEJC3UffROIlD8Dqi
         fgh7Goj+WeuL8mRRRjE52DgNtl7QgztYNbPPb0cOEJ+CJybjuGH9Gd9ixwLvGMl7nH2A
         3Y3RtoKefMrohU2jN69vuRDjlCUBPvqwXoSXadqIP6UedKXV3CjK1LWzxOW7054rNCu/
         Dfp4baoOS0c0Xu58yoVwOZcfObIcAmPltdBbwjfhmsECkZ7zyIKmlD8ZNtzugWw8qBKn
         r17DF1FsZGIYjr6hITFWPLZwkDBo2z6oJDJKy5UYQmvSawpSgxAYHsEzgtLugeh3Myjj
         WWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=o2JaYusrSX5g5l6Yw6yxi3k3vNOoBMCguurDm0+l8Ag=;
        b=YPHytEq8eEM4uAUQlUZUU3ScVepGs71FjkKSK7K2icM98NG/xNCVK8lG6ZdsLyc/+G
         nxS0UgurNFGVA+kb87bcTJ6WwF5C/bs/w8lrfUOeMoCuaitL84O9WB3On0NeAuJsgU+e
         mUXYROi0MHAADlnSs0M7okzcuimv0mXNyBYSeWOjEvDYzSTfHo7SvJelFq6zsOelF36c
         67rXvsfz7DKSGDhjeLYRgt3QVqDiY/3kU+RmCqZ0FycYP8JrIEk37znekjdc0mplkKTs
         L16luHLEF/GEaG9sjkc9NZWLZ1kyhzIsUoy0RGv4K3iFoGtgb9BCxl2lrHOPPwWeUXWB
         9FoA==
X-Gm-Message-State: AOAM5335g1GupQexgHrfRlk4EHp+LP7NPUIgqbD5uEuEsHudRQTG8iOy
        3RuVg129/YrYRpHxaomvKcimwTeyqg==
X-Google-Smtp-Source: ABdhPJxSM4ceufbESyUI9a+fBHervXps3fjSrrAiV4eM0G4Dpr1cL3+sY1800798HV5X0kp4wyrcUszRNw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fa4a:: with SMTP id k10mr202563qvo.18.1623161503263;
 Tue, 08 Jun 2021 07:11:43 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:28 +0100
Message-Id: <20210608141141.997398-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 00/13] KVM: arm64: Fixed features for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series adds support for restricting CPU features for protected VMs
in KVM [1].

Various feature configurations are allowed in KVM/arm64. Supporting all
these features in pKVM is difficult, as it either involves moving much of
the handling code to EL2, which adds bloat and results in a less verifiable
trusted code base. Or it involves leaving the code handling at EL1, which
risks having an untrusted host kernel feeding wrong information to the EL2
and to the protected guests.

This series attempts to mitigate this by reducing the configuration space,
providing a reduced amount of feature support at EL2 with the least amount of
compromise of protected guests' capabilities.

This is done by restricting CPU features exposed to protected guests through
feature registers. These restrictions are enforced by trapping register
accesses as well as instructions associated with these features, and injecting
an undefined exception into the guest if it attempts to use a restricted
feature.

The features being restricted (only for protected VMs in protected mode) are
the following:
- Debug, Trace, and DoubleLock
- Performance Monitoring (PMU)
- Statistical Profiling (SPE)
- Scalable Vector Extension (SVE)
- Memory Partitioning and Monitoring (MPAM)
- Activity Monitoring (AMU)
- Memory Tagging (MTE)
- Limited Ordering Regions (LOR)
- AArch32 State
- Generic Interrupt Controller (GIC) (depending on rVIC support)
- Nested Virtualization (NV)
- Reliability, Availability, and Serviceability (RAS) above V1
- Implementation-defined Features

This series is based on kvmarm/next and Will's patches for an Initial pKVM user
ABI [1]. You can find the applied series here [2].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://www.youtube.com/watch?v=edqJSzsDRxk

[2] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v1

To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Quentin Perret <qperret@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: kernel-team@android.com

Fuad Tabba (13):
  KVM: arm64: Remove trailing whitespace in comments
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix name of HCR_TACR to match the spec
  KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
  KVM: arm64: Restore mdcr_el2 from vcpu
  KVM: arm64: Add feature register flag definitions
  KVM: arm64: Add config register bit definitions
  KVM: arm64: Guest exit handlers for nVHE hyp
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits
  KVM: arm64: Check vcpu features at pVM creation

 arch/arm64/include/asm/kvm_arm.h        |  34 +-
 arch/arm64/include/asm/kvm_asm.h        |   2 +-
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/kvm_hyp.h        |   4 +
 arch/arm64/include/asm/sysreg.h         |   6 +
 arch/arm64/kvm/arm.c                    |   4 +
 arch/arm64/kvm/debug.c                  |   5 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  42 ++
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 114 +++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 501 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
 arch/arm64/kvm/pkvm.c                   |  31 ++
 arch/arm64/kvm/sys_regs.c               |  62 +--
 arch/arm64/kvm/sys_regs.h               |  35 ++
 17 files changed, 782 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: 35b256a5eebe3ac715b4ea6234aa4236a10d1a88
-- 
2.32.0.rc1.229.g3e70b5a671-goog

