Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC57B3A80E6
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhFONmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhFONmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:21 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5649C0611FB
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:39:54 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id x9-20020a5d49090000b0290118d8746e06so8670954wrq.10
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YqFGnAW4G80KFjLlYtbBihqs/VTfxdlv4UyDdFH0VNk=;
        b=vW8UU2mcVqIU2mlyEisSMA6Kbql1ZGDyN4oKiLenSONa/dq2y5ObhezQJCRnWqR4AO
         erXSeDx7mrF9iWHaFloBWd3gB1Jg7EDbnhltwV+e/cuI+nAZyTueEP+8VrykmXlgtgvr
         hqJHvVphsBKr8tdiVgRFElzn7BTPLBPpJh6ZgIf+pQVbrMgindHsOy7UgX6M+6cLMe55
         BiyAJNBd5HqG0NGyMs26s4ElIxBU1heAGJBYKK4CL/Xbk0f1sPw8BkIJs6i+Nkk8kBA2
         KZpq7kpV/AsChjgK2s8H+SNgGPFGVgNycLE9SfCDkfChrjVz/FqXgG/yAGkBpwdMQgY2
         aGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YqFGnAW4G80KFjLlYtbBihqs/VTfxdlv4UyDdFH0VNk=;
        b=Uym8/TUmgkf5chFFYAlSlkliQR8f+Fu3Ki/H3qbsKDRN7kDuustQ0UTfa6nas5hfgK
         pTcQC92X+8jtae03I0Ie44kewNeHQjdUwPzaSfXZIGbDq98korma88pjzyy5oDEG6KRs
         syfa8FqpQGToKajp27FerSoVZYlOT/1kLF9rkFlWuJYBQFzCVIeZ6a5MTfSsTkL+D/fB
         P3nQldbGDZHIJjINckZ5tBpW1vbAGeJrEr8kIAz824Q57fxqR0TrtP+JmDDEjCCRC0Zc
         P3n3I3WPyK29mnQu7AS8II9MlFLJ8B0peNVuq4sKxysi/HDwHTLKT7yzB3NIDrUdazAr
         IAlQ==
X-Gm-Message-State: AOAM533/fIUyUG1c92h2ksOcZa3m6Fa5Tu3vrf4LRAuKKN3C+EXMhupZ
        3qWn00E9MKNTMHbEJOVfPukiXHirIQ==
X-Google-Smtp-Source: ABdhPJzBlOmstNMiFWInb2WeX1AQwhgtoVD7ZnXYUlVqpBpHhlkPQmt7vhX1oh7GW7BAoXIVaF7wKZIaJw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c24a:: with SMTP id b10mr11308wmj.1.1623764393022;
 Tue, 15 Jun 2021 06:39:53 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:37 +0100
Message-Id: <20210615133950.693489-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 00/13] KVM: arm64: Fixed features for protected VMs
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Changes since v1 [0]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)
- Rebase on the latest kvmarm/next

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [1].

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

Remaining features currently supported by KVM are allowed. If new hardware
features become supported by KVM, they would need to be explicitly allowed
for protected VMs.

This series is based on kvmarm/next and Will's patches for an Initial pKVM user
ABI [2]. You can find the applied series here [3].

Cheers,
/fuad

[0] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[1] Once complete, protected KVM adds the ability to create protected VMs.
These protected VMs are protected from the host Linux kernel (and from other
VMs), where the host does not have access to guest memory,even if compromised.
Normal (nVHE) guests can still be created and run in parallel with protected
VMs. Their functionality should not be affected.

For protected VMs, the host should not even have access to a protected guest's
state or anything that would enable it to manipulate it (e.g., vcpu register
context and el2 system registers); only hyp would have that access. If the host
could access that state, then it might be able to get around the protection
provided.  Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at hyp.

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
https://www.youtube.com/watch?v=edqJSzsDRxk

[2] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v2

Fuad Tabba (13):
  KVM: arm64: Remove trailing whitespace in comments
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix names of config register fields
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

 arch/arm64/include/asm/kvm_arm.h        |  53 ++-
 arch/arm64/include/asm/kvm_asm.h        |   2 +-
 arch/arm64/include/asm/kvm_host.h       |   2 +-
 arch/arm64/include/asm/kvm_hyp.h        |   3 +
 arch/arm64/include/asm/sysreg.h         |   9 +
 arch/arm64/kvm/arm.c                    |   3 +
 arch/arm64/kvm/debug.c                  |   5 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  42 +++
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c      |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c        | 125 ++++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      | 477 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c       |   2 +-
 arch/arm64/kvm/pkvm.c                   |  43 +++
 arch/arm64/kvm/sys_regs.c               |  34 +-
 arch/arm64/kvm/sys_regs.h               |  35 ++
 17 files changed, 784 insertions(+), 61 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: bc63d9369b320fd3c85ee13a029af9dc0ddac0ea
-- 
2.32.0.272.g935e593368-goog

