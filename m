Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C85F3EE80E
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhHQIML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbhHQIMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:10 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BB7C0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:37 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id q19-20020adfbb93000000b00156a96f5178so2943589wrg.11
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/ckzLK+CffvqCGULa3qCpG0UYTxjxawmLkBAgkfDEXo=;
        b=QOcUVIAb0RL4/R1D1DYehkMtW7KrbfAD8MNMIwVla7JNYR+f6jzkGj6rSjT3ZmeTHO
         GPEFJhHixBMI9s2i5d7CtxWNjMqeEIQejNcYWI/z4lJe19jLkGCIurEKoWvSiUEepAtG
         7Xn7k3jUN3q6jRmTvQBqT+qVZP5krTphbRhrY+C2WKz34C+vt8tBpQv5f7o0Xcm9HKTE
         2uzPyqfEpgWbJPxoOFus4v7UpFLrllCbZ8jk6z24Y3KlE/YZ+PyahxHg+1dgXl33TEho
         E6lDZmLUBetNANo05xelrS3c/hSvaUjO22o2FRok6NKLLqH3S4NHs82nkYymOjBQMvy8
         rvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/ckzLK+CffvqCGULa3qCpG0UYTxjxawmLkBAgkfDEXo=;
        b=LMm0g+a41E1/PNvaF9+/R7QLLEc8cn7EdmDRpITJUnS/Sarcc/yPS2iUCvjV1DBvHa
         kE7e6DHZRkPWcFXuuYMfyFM6jBQPQXSIdEiDyGhs8nyxlL/OnXa2mhjprHkYTqckjFGN
         TI1AMAbkjJumN1zl9V2EpwiRLCSQW99Mdj0eS0AeuNOdcV7V/+HYfbx/qmdQubFvUn8H
         m2lgzkw04ICrQLK0kKIUBoy226G77ozqvi8VTJ8xz9CtvVmfpFVnBo01NXvDDJ5iUVOq
         BpSkVzHjqAzNOHUqNUUq39pAr5pixwryKvjPFklDKQNYHk2p+BuVUz+JnErabXHiobct
         hUuw==
X-Gm-Message-State: AOAM531ijznK3nPqpIU6EkyaLAKv8ReqthjAfWmuUiY2XsAEH6/Q0Xke
        dBFuio2xbfOzYUklRsstbQ237EdZrA==
X-Google-Smtp-Source: ABdhPJzfKxBuOWNyF4P/P/98BI2zZOeQMB4OaOrC7slEfd9Q9lbLcP35IKx3h5EiaGgEeUX6MQmU7zDtxg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:2213:: with SMTP id
 z19mr2027642wml.6.1629187895964; Tue, 17 Aug 2021 01:11:35 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:19 +0100
Message-Id: <20210817081134.2918285-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 00/15] KVM: arm64: Fixed features for protected VMs
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

Changes since v3 [1]:
- Redid calculating restricted values of feature register fields, ensuring that
  the code distinguishes between unsigned and (potentially in the future)
  signed fields (Will)
- Refactoring and fixes (Drew, Will)
- More documentation and comments (Oliver, Will)
- Dropped patch "Restrict protected VM capabilities", since it should come with
  or after the user ABI series for pKVM (Will)
- Carried Will's acks

Changes since v2 [2]:
- Both trapping and setting of feature id registers are toggled by an allowed
  features bitmap of the feature id registers (Will)
- Documentation explaining the rationale behind allowed/blocked features (Drew)
- Restrict protected VM features by checking and restricting VM capabilities
- Misc small fixes and tidying up (mostly Will)
- Remove dependency on Will's protected VM user ABI series [3]
- Rebase on 5.14-rc2
- Carried Will's acks

Changes since v1 [4]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [5].

Various VM feature configurations are allowed in KVM/arm64, each requiring
specific handling logic to deal with traps, context-switching and potentially
emulation. Achieving feature parity in pKVM therefore requires either elevating
this logic to EL2 (and substantially increasing the TCB) or continuing to trust
the host handlers at EL1. Since neither of these options are especially
appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
configuration based on the underlying hardware and which can mostly be provided
straightforwardly by EL2.

This series approaches that by restricting CPU features exposed to protected
guests. Features advertised through feature registers are limited, which pKVM
enforces by trapping register accesses and instructions associated with these
features.

This series is based on 5.14-rc2. You can find the applied series here [6].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210719160346.609914-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210615133950.693489-1-tabba@google.com/

[3] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[4] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[5] Once complete, protected KVM adds the ability to create protected VMs.
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

[6] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v4

Fuad Tabba (15):
  KVM: arm64: placeholder to check if VM is protected
  KVM: arm64: Remove trailing whitespace in comment
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix names of config register fields
  KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
  KVM: arm64: Restore mdcr_el2 from vcpu
  KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
  KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
  KVM: arm64: Add feature register flag definitions
  KVM: arm64: Add config register bit definitions
  KVM: arm64: Guest exit handlers for nVHE hyp
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

 arch/arm64/include/asm/cpufeature.h       |   4 +-
 arch/arm64/include/asm/kvm_arm.h          |  54 ++-
 arch/arm64/include/asm/kvm_asm.h          |   2 +-
 arch/arm64/include/asm/kvm_fixed_config.h | 170 +++++++++
 arch/arm64/include/asm/kvm_host.h         |  15 +-
 arch/arm64/include/asm/kvm_hyp.h          |   5 +-
 arch/arm64/include/asm/sysreg.h           |  17 +-
 arch/arm64/kernel/cpufeature.c            |   8 +-
 arch/arm64/kvm/Makefile                   |   2 +-
 arch/arm64/kvm/arm.c                      |  12 +
 arch/arm64/kvm/debug.c                    |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  52 ++-
 arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c     |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c          |  87 ++++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c        | 432 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c         |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  12 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/pkvm.c                     | 185 +++++++++
 arch/arm64/kvm/sys_regs.c                 |  64 +---
 arch/arm64/kvm/sys_regs.h                 |  31 ++
 23 files changed, 1059 insertions(+), 109 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
 create mode 100644 arch/arm64/kvm/pkvm.c


base-commit: c500bee1c5b2f1d59b1081ac879d73268ab0ff17
-- 
2.33.0.rc1.237.g0d66db33f3-goog

