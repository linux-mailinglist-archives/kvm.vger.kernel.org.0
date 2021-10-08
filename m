Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EC9426E30
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243111AbhJHQAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbhJHQAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F66BC061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 124-20020a251182000000b005a027223ed9so12966015ybr.13
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OhGTFF+wvS+RHrDxBXMcls6M7hE9mvNcy5n5nxdlojY=;
        b=UhDbVer3yTzCQuEnCVNCCwOJxroBSjeGrerPZQUnL9cSLTLWZM3WcLmHKtjpnB9H42
         4+MLmNwhYgZLSfRYqHvwMdpkPmhxPa0wHy03c+jxdQpFlGn/qfuRE6+r+AXnoqOj8+4e
         vbW8EjUhfr23GdmxGkqXMAEdxEylEw/4lSVq9KsaNs9IFfJyBemq5uVCgHnZHwwIlrgR
         3dR7J6sZkD7Dryb1tIb+9atF3DgzOcXpejRI2P/LT4BP/ftKIDUkkxMrp1QsH2aVR5c3
         qf+KjTx6Is/FLnOUPigUaJyHzddnzRFVNxlidDe4gzrGvYWQEs5u/MYkOCax/EABYnHo
         7pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OhGTFF+wvS+RHrDxBXMcls6M7hE9mvNcy5n5nxdlojY=;
        b=s3JEYYppGmYUDQJGXS74RnGFnGQObDbO+13GmDoUkpd3dli35ASMiCPq8k0zuiyelQ
         aHHmKzoztERfOavAxgVG48/N2TsCaX68tTauCk7ardAKv3Lf7MXBCA/+Q/BMT8JUPKhn
         2W+KYdRaZWUJBeEdg1wGgGTaHv+jo7oIbSiJNRIIbHQuKeJYo9PapHLicUYrVqptuXcc
         isbcaKkLU5kwMbWb6saH57KWwszCsSntu3i+RaXqqHCkb7yR1gE2wK3wHR/ODhg6KDkA
         XnyHbGCkBxpZVbNX/ugGIsBBZbyAUjKNz198pdKHvjEFbrjh0NH5PVLQBZbCtA6mU1zV
         7BVA==
X-Gm-Message-State: AOAM531zyBvf6G8DyVmIuS7nZzuMkGrS5x//PMxLP9/VLn0dJFLzNBJe
        5nYVQ2L8j4WyH8Vv3PYxD5fD2fV64A==
X-Google-Smtp-Source: ABdhPJwSkEhANAXQ5JCD2NdWSpZq4SqWrw57ULj9YsrCO0+8ltUiACfmbzS/Tq1J1B3VPevPEONoAIAjbA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:6e06:: with SMTP id j6mr4604257ybc.311.1633708714429;
 Fri, 08 Oct 2021 08:58:34 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:21 +0100
Message-Id: <20211008155832.1415010-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 00/11] KVM: arm64: Fixed features for protected VMs
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

Changes since v6 [1]:
- Rebase on 5.15-rc4
- Include Marc's updated early exception handlers in the series
- Refactoring and fixes (Drew, Marc)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [2].

This series is based on 5.15-rc4. You can find the applied series here [3].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210922124704.600087-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v7

Fuad Tabba (8):
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

 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h     | 195 +++++++
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_hyp.h              |   5 +
 arch/arm64/kvm/arm.c                          |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 221 ++++----
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h    |  29 +
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              | 108 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 498 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 19 files changed, 1240 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: 1da38549dd64c7f5dd22427f12dfa8db3d8a722b
-- 
2.33.0.882.g93a45727a2-goog

