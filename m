Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E8428203
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhJJO6k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhJJO6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:58:40 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4385CC061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:41 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id s18-20020adfbc12000000b00160b2d4d5ebso11240051wrg.7
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=0IALRDz6Tre84NinIHTYzESK4wmCcI5wtlY2yCjYCUY=;
        b=XFtspDwNvHx3OaaLUkgTBRzozA11W2KOc2oj9Ffr5nL7uiZpcykfK4WXNfLGWyd0j7
         iQq9wIihaUCErX7b0sNwuTx0OINH8vTgcA6mraLwFVngsVwSvMnYV2LyfQ8ei8FFJjRl
         pDaW5b1j+sjA4dLq5Tg9+zqxA1O/NxBVU4SSsY4lKjRP1Ej9BgNyVq9OfeunQTjO+y8R
         7S5APWKp2BdXqRJxn9qT1QWfRzHpF7Uy+TN0RlMC0Nb+kZcinW5q8QKbaC3MHZf2iuo/
         whBWKBYadxOSTT/w9qYgrHMjH2ErwOOt82iV6YuiWBfSmm2aarKKIaTqd9PjjmfEkfNt
         WIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=0IALRDz6Tre84NinIHTYzESK4wmCcI5wtlY2yCjYCUY=;
        b=Y7G2hLTxupD1tVXnpHjNskXiMSlaGdyZBJIoWCGW5OF1sABgYCS3GKsrzV8bmGddRp
         +Qcj0+opJ9F95/VEEn0KtLekR5kHMKuIO14noTv4nrkm6so2MsIupmmzbpFA20nFdfMy
         exLpkNWwgvYHKRJftJvQtqbdPL6BGg3ijL+7qWW7wNz9utJq3KLq5XBxbyFcycwh3hgZ
         PetmHcXyoahKHJz2WJ3DALF0vOWta0oj2LfMtQVGEkEZ1vgHGaGt6rhOt6S6icrCI+4c
         dd5nO4QNemA96o3W4l48RXJF8sEVst4kY2pJJ5FcPZ6OOYkRO2/4HPDVc7oYfVkqFWOb
         vJRg==
X-Gm-Message-State: AOAM531gDC+whzjssDUYhce5QnxXH3o5Nk9v/Ks6mXkck/sr1Q7h2w8U
        XCED1suvfg+HcPgJvUrYKgLnw0SFQg==
X-Google-Smtp-Source: ABdhPJzVKpI391DGIxy4EJmP42G66znpH547K7u6BG5q03NUhe2ylAPuiZia7WvbkXH0DxZIT5XKvi6ykA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:cf03:: with SMTP id l3mr15528139wmg.25.1633877798476;
 Sun, 10 Oct 2021 07:56:38 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:25 +0100
Message-Id: <20211010145636.1950948-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 00/11] KVM: arm64: Fixed features for protected VMs
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

Changes since v7 [1]:
- Fix build warnings

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [2].

This series is based on 5.15-rc4. You can find the applied series here [3].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20211008155832.1415010-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v8

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
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 186 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              | 108 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 500 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 19 files changed, 1243 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: 1da38549dd64c7f5dd22427f12dfa8db3d8a722b
-- 
2.33.0.882.g93a45727a2-goog

