Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8CD74DE1D
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 21:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjGJTYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 15:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjGJTYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 15:24:36 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE34183
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-579e9b95b86so59618477b3.1
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 12:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017073; x=1691609073;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=blbJsY1tevXkpN11ExS1lzOVNoR4ZYwKCSGaaCw8t6U=;
        b=CjZI5HUbA9pnkqip1gs9QRVz34a6qhwBmtysgri3RzvR08LQe/zefIRLxQ+k/m3iPg
         JYv56WOxNaHoTpKwE8Kdwxd+9fy2kDaKvDyPOCgVA2K8cbfl7EBBK0L2h4l37E4EdZhX
         zSySqR/M8D2PTfPDnmbaw8xglDtx8Z0ujrIYfYsPirhgl2JWN86zptFcecJ3axv7QvQJ
         UCYExHaiV5FzLuUgLIJkKoy47o9Vu5ILm5ubor1wPMRJCOF7ClhYrmewvoIgvea0br0s
         DWMoSidn0ur8mtJts784btGXJ+AkAMAwey2q4psdIlikdsc7RalhNggPNzrCPq38GAmq
         5TdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017073; x=1691609073;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=blbJsY1tevXkpN11ExS1lzOVNoR4ZYwKCSGaaCw8t6U=;
        b=LDTa3PBqFpbb+8yV8OzRwfIZG+csuxxS5eH13SMlph3tWfeJ9c/IhDd9OvNMAPDJFM
         9IANNCxo2/328dCj48KYVvqV0KLVAS2vqyTYqKQza8qUQMCVQnrLezFjnxC8GQMyS4ES
         +TZ7JB6tVRYEeNU6EefwflPvRVQowUNmBJ7xCjgwrr93d0P9wHMzmqeLszE+MqzkMqJO
         Wngo4B9pQRJNMwhVL3XycdzeOkhh0LkRTkSc5oIQZe5EJpG2XRmAXi7x/soicMsZkRzR
         1PJChQNASgQU2mfXCXwXV/N4JLILQwkoeDG0qtsz5ZZ7qabKuiDiuDpI7qmDOSIVFpsF
         DySQ==
X-Gm-Message-State: ABy/qLYlz9pXX0UVacpdEJ5eB88AZM17rKX9VC+71WQoetRIeSbUsk4h
        gIY9QRH/hiBjrwBr056+3pjiCmXY1OATXDfzqCZ7u94VZZOmUwNi26A4XMAauFmGoKQcjVV0udf
        EdR5+y77avii+II0E/Rpn9cQ4GgiKrbbj7/vMmKdLh31xfY2bLaE/rRnIEFPmGqiY3XpQl7s=
X-Google-Smtp-Source: APBJJlFfpoC9fJXsqOFcjrMpASNBzMzZhqXGDJedjyg3Esd8A1tWW4poDR1LpBHpcCPUD+QPxXBPSool9fvrH46tMw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a81:cf0c:0:b0:570:b1:ca37 with SMTP id
 u12-20020a81cf0c000000b0057000b1ca37mr94786ywi.5.1689017073377; Mon, 10 Jul
 2023 12:24:33 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:24:23 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-1-jingzhangos@google.com>
Subject: [PATCH v5 0/6] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2, 3}
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series enable userspace writable for below idregs:
ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2, 3}_EL1.

It is based on v6.5-rc1 which contains infrastructure for writable idregs.

A selftest is added to verify that KVM handles the writings from user space
correctly.

A relevant patch from Oliver is picked from [3].

---

* v4 -> v5
  - Rebase on v6.4-rc1 which contains infrastructure for writable idregs.
  - Use guest ID registers values for the sake of emulation.
  - Added a selftest to verify idreg userspace writing.

* v3 -> v4
  - Rebase on v11 of writable idregs series at [2].

* v2 -> v3
  - Rebase on v6 of writable idregs series.
  - Enable writable for ID_AA64PFR0_EL1 and ID_AA64MMFR{0, 1, 2}_EL1.

* v1 -> v2
  - Rebase on latest patch series [1] of enabling writable ID register.

[1] https://lore.kernel.org/all/20230402183735.3011540-1-jingzhangos@google.com
[2] https://lore.kernel.org/all/20230602005118.2899664-1-jingzhangos@google.com
[3] https://lore.kernel.org/kvmarm/20230623205232.2837077-1-oliver.upton@linux.dev

[v1] https://lore.kernel.org/all/20230326011950.405749-1-jingzhangos@google.com
[v2] https://lore.kernel.org/all/20230403003723.3199828-1-jingzhangos@google.com
[v3] https://lore.kernel.org/all/20230405172146.297208-1-jingzhangos@google.com

---

Jing Zhang (5):
  KVM: arm64: Use guest ID register values for the sake of emulation
  KVM: arm64: Enable writable for ID_AA64DFR0_EL1 and ID_DFR0_EL1
  KVM: arm64: Enable writable for ID_AA64PFR0_EL1
  KVM: arm64: Enable writable for ID_AA64MMFR{0, 1, 2, 3}_EL1
  KVM: arm64: selftests: Test for setting ID register from usersapce

Oliver Upton (1):
  KVM: arm64: Reject attempts to set invalid debug arch version

 arch/arm64/kvm/sys_regs.c                     |  62 +++++--
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/set_id_regs.c       | 163 ++++++++++++++++++
 3 files changed, 213 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

