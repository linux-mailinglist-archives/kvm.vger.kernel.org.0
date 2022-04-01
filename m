Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E901C4EE592
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 03:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243652AbiDABK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 21:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiDABK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 21:10:28 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95FB12ACC
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:08:39 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id g20-20020a92c7d4000000b002c9ed225d38so889777ilk.4
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 18:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kL9d/s0Mnyvvq5xceGf8t2Ku5ZfUJAPmTPk2nXEvlGU=;
        b=N2eqlZ8z3YFz3XyEkuOB+8wTp8T2vu7nAJ3SBPyPPNG2EXyKjBs2zPReQsCNcgR62/
         GgomeeOiuFgJj2EaUihw08Xev8ZvqIS3N4tYW2pm2uTP4ru4dIVNrNv8M2pcnDYbMpzi
         etIJvz6Q1i4ZUe9P85kyqhOCjztZjX0V6innFelwk/ZSnFAQ+QYvl/1KY0OjeRKSp63J
         ltTOL14JzHH+dM2+1yJFOEFF0jbRCJM8Zocyzj4RDtfpInxk6j49zUy34U0BUd1W4ONP
         7jehSV8LgeGFLwVEbex+LM9J5KNqZGeK3YkxooMZAKby5lcazJXLQsqQrRcjeKfAh2UT
         JVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kL9d/s0Mnyvvq5xceGf8t2Ku5ZfUJAPmTPk2nXEvlGU=;
        b=tM0HtyG3MnBaIFhrLPfiugEgm5aD83d/zQA931qvyivagz68E2RpIAIsPbvD8NUvvo
         +GtA9QqqiFP3KUZXgUV309IkaS0B8dKdsj56eO63M9D4fVChIdUBhXmS2z/m5+rI8s5P
         c/pbI4erj2sP/wC+ztXSOsf9luxKx5Tg02aVHaChK/s98Lrhc98Gartu7Mg1sfNU+sX7
         2bU6CYzLw33Rvv8i+k16EVztG2xYkm58ZjWRKjyWgAyI3z32BXz3ufBCClpYtjjzjiUu
         T4HIrKP2b5IKffIa4VG4XyH4qyBTtoib0VDi04TOkG+k0EOV2w1ss4SJAjrx979JGB1J
         9x5w==
X-Gm-Message-State: AOAM530ZvLVQ0JaqRF8kQ3tim1XaCjwKhZATpax/aY8cAp8ZsiglSoDE
        MjHJXDM8B1NJYeSkjIJK4My3E+TrWyk=
X-Google-Smtp-Source: ABdhPJxQnq7pKml6XanwOMnHzHv9EDXFtxgBk58x0mq9HUGV2OjLa88lb/ZOZv8EHc19z+AoKhav5b9MVFE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1e06:b0:2c8:2707:71d with SMTP id
 g6-20020a056e021e0600b002c82707071dmr14141413ila.39.1648775319144; Thu, 31
 Mar 2022 18:08:39 -0700 (PDT)
Date:   Fri,  1 Apr 2022 01:08:29 +0000
Message-Id: <20220401010832.3425787-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 0/3] KVM: arm64: Limit feature register reads from AArch32
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
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

KVM/arm64 does not restrict the guest's view of the AArch32 feature
registers when read from AArch32. HCR_EL2.TID3 is cleared for AArch32
guests, meaning that register reads come straight from hardware. This is
problematic as KVM relies on read_sanitised_ftr_reg() to expose a set of
features consistent for a particular system.

Appropriate handlers must first be put in place for CP10 and CP15 ID
register accesses before setting TID3. Rather than exhaustively
enumerating each of the encodings for CP10 and CP15 registers, take the
lazy route and aim the register accesses at the AArch64 system register
table.

Patch 1 reroutes the CP15 registers into the AArch64 table, taking care
to immediately RAZ undefined ranges of registers. This is done to avoid
possibly conflicting with encodings for future AArch64 registers.

Patch 2 installs an exit handler for the CP10 ID registers and also
relies on the general AArch64 register handler to implement reads.

Finally, patch 3 actually sets TID3 for AArch32 guests, providing
known-safe values for feature register accesses.

Series applies cleanly to kvmarm/fixes at commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

There is an argument that the series is in fact a bug fix for running
AArch32 VMs on heterogeneous systems. To that end, it could be
blamed/backported to when we first knew better:

  93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")

But I left that tag off as in the aforementioned change skipping
AArch32 was intentional.

Tested with AArch32 kvm-unit-tests and booting an AArch32 debian guest
on a Raspberry Pi 4.

v1: https://lore.kernel.org/kvmarm/20220329011301.1166265-1-oupton@google.com/

v1 -> v2:
 - Actually set TID3! Oops.
 - Refactor kvm_emulate_cp15_id_reg() to check preconditions before
   proceeding to emulation (Reiji)
 - Tighten up comment on kvm_is_cp15_id_reg() to indicate that the only
   other trapped ID register (CTR) is already handled in the cp15
   register table (Reiji)

Oliver Upton (3):
  KVM: arm64: Wire up CP15 feature registers to their AArch64
    equivalents
  KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
  KVM: arm64: Start trapping ID registers for 32 bit guests

 arch/arm64/include/asm/kvm_arm.h     |   3 +-
 arch/arm64/include/asm/kvm_emulate.h |   8 --
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/handle_exit.c         |   1 +
 arch/arm64/kvm/sys_regs.c            | 129 +++++++++++++++++++++++++++
 5 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

