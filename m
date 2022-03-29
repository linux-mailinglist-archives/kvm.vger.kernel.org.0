Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96C44EA47C
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 03:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiC2BOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 21:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiC2BOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 21:14:51 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C3341304
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:09 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id m12-20020a9d7acc000000b005b21f450ed2so9045411otn.20
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 18:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nYlE+C/axixPppHHbcO/XGK1yVRHkszjXFRKMgmo2rQ=;
        b=tUZNXLhTPTopRQyZVbL8Vxdk++9/mwdVfpzx2zNYKV1d3E/6Kg6zw6o0PSKaWu26Y1
         pG1gfCQFJzSZdys9ABwQ1NIBkX62MZJ6XdDGpjd9VvNaS4Pm/4M6RTUzEVwDm4VUEY3c
         AvbGNQLFPOEUxr2O9hbCT0Y6CXJ9zQykHhFNsZtgolLyid4BWiF7gsm9Mq6N7Oo3XtjT
         3m7EebjNmgk1vWU5ojSN1cvxV/nuAyN7B/NiGZ7H6PDfg6IEVoA1zXw3Ru+QOaR+RX7l
         j280fbEy7glIONhzteHunuyH7rmj9wuQ3Swek9km8eOogW1f+hVDtsHIyG8/Lrc/9uoM
         ub3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nYlE+C/axixPppHHbcO/XGK1yVRHkszjXFRKMgmo2rQ=;
        b=FS5anynGTPUxq9FhvC+l3Gn0bMNiP4Lx8wvAmcERzoK8iciTR6YSQSWeVwxjfrxC8M
         X5zdmmcYu3dOZK8rDjgQta35eBXhaPMiIcKmCFwVYAP7jGrG4WqEbE+oPmE4MN31vVfW
         HQt0UckkESSqG70WKOcyDAuOSOJTOSVdqBZOc3rzIRbViMpkXVKJzsVTc+jM53EZfJNY
         jqg0dzOd1g46BTI2qq0JPeYGLCMDLYKg4H/3Bth30/HZvfmV0nF8jpn/Nm+ZgDzFMR9R
         vjdhkXMzQTWnxLRnvIC9IfmVsY+ygKe4bywv61D4ICN6Lt4apnkJLfxcSgMCaQd61Jjo
         tf0A==
X-Gm-Message-State: AOAM530Y/pvYzSCCLcOqDwnK8VixKjHJ0MXrJeFo+/mwLhYNPcvcWdEv
        HFJmqLn1lcKFMQOYy2A1kC11+96htzY=
X-Google-Smtp-Source: ABdhPJwwujhcPW9Bu1rOL7Be1SGcb234TZlpdxtAkIVxfUSk/Vnz+sZ0hNqbYylYDqlhN4vDVQTbAJrgTQ8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:6f07:0:b0:5b2:38e8:41f7 with SMTP id
 n7-20020a9d6f07000000b005b238e841f7mr113246otq.308.1648516389241; Mon, 28 Mar
 2022 18:13:09 -0700 (PDT)
Date:   Tue, 29 Mar 2022 01:12:58 +0000
Message-Id: <20220329011301.1166265-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 0/3] KVM: arm64: Limit feature register reads from AArch32
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

I'll leave it as an exercise for the reader to decide whether or not I'm
being _too_ lazy here ;-)

Series applies cleanly to kvmarm/fixes at commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

Tested with AArch32 kvm-unit-tests and booting an AArch32 debian image
on a Raspberry Pi 4. Nothing seems to have gone up in smoke yet...

Oliver Upton (3):
  KVM: arm64: Wire up CP15 feature registers to their AArch64
    equivalents
  KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
  KVM: arm64: Start trapping ID registers for 32 bit guests

 arch/arm64/include/asm/kvm_emulate.h |   8 --
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/handle_exit.c         |   1 +
 arch/arm64/kvm/sys_regs.c            | 128 +++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 8 deletions(-)

-- 
2.35.1.1021.g381101b075-goog

