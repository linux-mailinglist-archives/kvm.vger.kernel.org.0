Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2075E3F97F5
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244757AbhH0KRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244492AbhH0KRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:00 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97489C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:11 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id q2-20020ad45ca2000000b00374fa0dbedfso2571510qvh.1
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jsA6xT98EeA80UGER1WEqhvGsAPxq/3pPd3JQ9gufNk=;
        b=VhFaBqIfTeTaY8WOw3nAg0JlzJztciYu4suzC598Ebz2q37OUD13vfp9lIwq5DIwyw
         t2wAB2K4+11hk+25HeExvkyRPequRrvFhjWJRyh1JdbiFa0vwD4hj3hd/PqOLHgui/P9
         YfWX7zFGKKu2ymeJI7D+6uyVNjR9Q1ctx4ZkLAHHHNITVKevtV5R9VMkYD6L5A/Z+L4C
         ZGMuUGyptLkmSaYfLQsfqiQCk7FI2cDGRWLqlN4QQEGyvdUX+LtphSsnwi/HOo9KEcel
         DYxqxTmSRwZnKtnJoQRVYbLs194cX3pj7jdEqAGWK+Rc5akusnV62oo28FJMS5/UkyRd
         r7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jsA6xT98EeA80UGER1WEqhvGsAPxq/3pPd3JQ9gufNk=;
        b=qALGT1s/dVaSo8tu1mkbVlzbJX7FaUQVE6FopWwtyiwXT7Cy+QImZ/ja3b1+CU0uFa
         dcF4v2teFkhdQaJAyMNBkHj9EPYMCersPGSHcYVT4Gv71McYSn+Z8WtxBftuN8vvMUKe
         qC2tEtJCWWK9Zdc/SbVLSwXpl1yrPi0puoFnBIPOvFYYbmFNkJUE3dVVAEpry8es2+2l
         iKeWoGkFhG2CFlzufeNr0NORZBduHrV31dU2tVi3ADwLZkRvristT/IDpXqqRqp7r5vL
         lx8WZvhZrpijpNr++4q4KWmHYkQsx2+pbViPcK1S/py3k5R+vqYZAhPktqvfiIz6kGs6
         lgMA==
X-Gm-Message-State: AOAM530IXIDDYcV/tvw6vxxY5kObq9zbQFYXBcjXuPJuKPwKYGCBC6z8
        ps14ZJxRWigTJrjGP/VIjcIVkskioA==
X-Google-Smtp-Source: ABdhPJzvFP8+CJjGjT4Q/qSS+1OA0tDxp3n9hoCOklGx1Uk6TnaXfxtcDrpuAdqzcwZSqvV+uAeQtEL0Zg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fbcf:: with SMTP id n15mr9011967qvp.49.1630059370831;
 Fri, 27 Aug 2021 03:16:10 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:01 +0100
Message-Id: <20210827101609.2808181-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 0/8] KVM: arm64: Fixed features for protected VMs
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

Changes since v4 [1]:
- Calculating feature id register values takes into account features
  supported/enabled in KVM.
- Handle all AArch64 feature ID registers, with sanitized copies at EL2 if
  necessary, rather than trusting the host, even if the value is the same.
- Trap registers are set based on the exposed value of the feature id
  registers, rather than the masks to allow/restrict.
- Move code for settings trap registers for protected guests to EL2.
- Refactoring and fixes.
- Dropped Will's ack for "KVM: arm64: Trap access to pVM restricted features"
- Rebase on Marc's pkvm-fixed-features branch [2].

Changes since v3 [3]:
- Redid calculating restricted values of feature register fields, ensuring that
  the code distinguishes between unsigned and (potentially in the future)
  signed fields (Will)
- Refactoring and fixes (Drew, Will)
- More documentation and comments (Oliver, Will)
- Dropped patch "Restrict protected VM capabilities", since it should come with
  or after the user ABI series for pKVM (Will)
- Carried Will's acks

Changes since v2 [4]:
- Both trapping and setting of feature id registers are toggled by an allowed
  features bitmap of the feature id registers (Will)
- Documentation explaining the rationale behind allowed/blocked features (Drew)
- Restrict protected VM features by checking and restricting VM capabilities
- Misc small fixes and tidying up (mostly Will)
- Remove dependency on Will's protected VM user ABI series [5]
- Rebase on 5.14-rc2
- Carried Will's acks

Changes since v1 [6]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [7].

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

This series is based on 5.14-rc2. You can find the applied series here [8].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210817081134.2918285-1-tabba@google.com/

[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pkvm-fixed-features

[3] https://lore.kernel.org/kvmarm/20210719160346.609914-1-tabba@google.com/

[4] https://lore.kernel.org/kvmarm/20210615133950.693489-1-tabba@google.com/

[5] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[6] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[7] Once complete, protected KVM adds the ability to create protected VMs.
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

[8] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v5

Fuad Tabba (8):
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

 arch/arm64/include/asm/kvm_arm.h           |   1 +
 arch/arm64/include/asm/kvm_asm.h           |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h  | 164 +++++++
 arch/arm64/include/asm/kvm_host.h          |   2 +
 arch/arm64/include/asm/kvm_hyp.h           |   5 +
 arch/arm64/kvm/arm.c                       |  13 +
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  14 +
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h |  29 ++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  10 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   6 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 186 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |  59 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 525 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            |   2 +-
 arch/arm64/kvm/sys_regs.c                  |  10 +-
 17 files changed, 1020 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: cc3ef75c796e58acec8f64a9acf47fc18645f194
-- 
2.33.0.259.gc128427fd7-goog

