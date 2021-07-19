Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146313CE4FF
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbhGSPrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350259AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6A8C0613E8
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:04 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id t7-20020a0562140c67b02902f36ca6afdcso14774511qvj.7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=X3IdqzKtSdKmEHqu0gSKjOdvCta/WPAlxOlzNq5U9KI=;
        b=uIH6aFAEogBPjp3JnJ8pNTafadhbYdKOoTiFg87snBwSlO47nkKZDDP+0OgB23SsPL
         pYWETb0wm0ULN8PK5q0FWytbFLfdGggAjYKU5gxU5joDMl09vDKWz3a12uCby8wabOJD
         Sohhdf4JtNvB5/Zc0yoOKHLeKVOxr5nbmtux2Aj4cN1eWopNkVAacAnCsEiWUXQ9UGP/
         yKoGei+fcSWgZrKVqzWWZKGh1m0xsx46brxd4R6EAaVVn+Mdxrf9llPIzADcvJ8r8ahH
         v+eATGrXiMuzHkQHUOAOfOIdacdGXDQLYHt5pGRvRSMaBQHGSFjE6vNg6pxkHqWmB5Q4
         N4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=X3IdqzKtSdKmEHqu0gSKjOdvCta/WPAlxOlzNq5U9KI=;
        b=Px3jTLbmjWYmgss7H4PrvAI8+b3TaPhbHytQjx8AXda5ALar/aVullc5i8s4JPPOgp
         jVDA7S77JRQ2IgSmh2GQUjb2WpLmjCMWzTP5fBwDw0WrCkxjxwDASbgNZqUgy0BD/Zw4
         XYcQ3mUmUpbvAwIs7DyuBL/49oQfYt2pQylUY1r/bS09lax+wY2qeDHe18yu3wooDDNn
         u2FR2BGVUDbfj36dGccdWOYdO5GKiXWQ3ElV27E0NUeHtyUdkjdPcwEWONhyeqVxjL9A
         tyMFuxZWYPb21pvIUPmhVGcLeyFis7FOPnSW1giff5jQsUgK093VfFufTPd3r221nG3Y
         sIpA==
X-Gm-Message-State: AOAM533ae2M6GNYUsqxFSxAg7y0+Q/zTmGTkS6l4ZNMhJNr2vaAJaxIX
        yKxdCDJyFJjzwJTQnZvNae/o6q3UxQ==
X-Google-Smtp-Source: ABdhPJxAOglNWseu0wn6j1VK16OzeLqCOGgMEktN+EBmxudy9HH20JMPvsgut3x+BTUFeB3mBdJqAyMDUQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:29e9:: with SMTP id
 jv9mr25278307qvb.18.1626710628711; Mon, 19 Jul 2021 09:03:48 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:31 +0100
Message-Id: <20210719160346.609914-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 00/15] KVM: arm64: Fixed features for protected VMs
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

Changes since v2 [1]:
- Both trapping and setting of feature id registers are toggled by an allowed
  features bitmap of the feature id registers (Will)
- Documentation explaining the rationale behind allowed/blocked features (Drew)
- Restrict protected VM features by checking and restricting VM capabilities
- Misc small fixes and tidying up (mostly Will)
- Remove dependency on Will's protected VM user ABI series [2]
- Rebase on 5.14-rc2
- Carried Will's acks

Changes since v1 [3]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [4].

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

This series is based on 5.14-rc2. You can find the applied series here [5].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210615133950.693489-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[3] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[4] Once complete, protected KVM adds the ability to create protected VMs.
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

[5] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v3

Fuad Tabba (15):
  KVM: arm64: placeholder to check if VM is protected
  KVM: arm64: Remove trailing whitespace in comment
  KVM: arm64: MDCR_EL2 is a 64-bit register
  KVM: arm64: Fix names of config register fields
  KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
  KVM: arm64: Restore mdcr_el2 from vcpu
  KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
  KVM: arm64: Add feature register flag definitions
  KVM: arm64: Add config register bit definitions
  KVM: arm64: Guest exit handlers for nVHE hyp
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits
  KVM: arm64: Restrict protected VM capabilities

 arch/arm64/include/asm/cpufeature.h       |   4 +-
 arch/arm64/include/asm/kvm_arm.h          |  54 ++-
 arch/arm64/include/asm/kvm_asm.h          |   2 +-
 arch/arm64/include/asm/kvm_fixed_config.h | 188 +++++++++
 arch/arm64/include/asm/kvm_host.h         |  15 +-
 arch/arm64/include/asm/kvm_hyp.h          |   5 +-
 arch/arm64/include/asm/sysreg.h           |  15 +-
 arch/arm64/kernel/cpufeature.c            |   8 +-
 arch/arm64/kvm/Makefile                   |   2 +-
 arch/arm64/kvm/arm.c                      |  75 +++-
 arch/arm64/kvm/debug.c                    |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h   |  76 +++-
 arch/arm64/kvm/hyp/nvhe/Makefile          |   2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |   2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c     |   6 -
 arch/arm64/kvm/hyp/nvhe/switch.c          |  72 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c        | 445 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/debug-sr.c         |   2 +-
 arch/arm64/kvm/hyp/vhe/switch.c           |  12 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |   2 +-
 arch/arm64/kvm/pkvm.c                     | 213 +++++++++++
 arch/arm64/kvm/sys_regs.c                 |  34 +-
 arch/arm64/kvm/sys_regs.h                 |  31 ++
 23 files changed, 1172 insertions(+), 95 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c
 create mode 100644 arch/arm64/kvm/pkvm.c


base-commit: 2734d6c1b1a089fb593ef6a23d4b70903526fe0c
-- 
2.32.0.402.g57bb445576-goog

