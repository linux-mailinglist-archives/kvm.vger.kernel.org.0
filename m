Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96736CCEAF
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 02:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjC2AWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 20:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC2AV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 20:21:59 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFA32D44
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54196bfcd5fso135326417b3.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 17:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680049309;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eENpLd222ixV/BEnAXd0sJR92bJ82vOOCby7utTN/Sg=;
        b=Aa8PAqkWPiWBkQau05fBBTj7M/gFx1Aynw2O/bik1Gs2nRZ+KCIt+jxe8K7YXvPuSQ
         W1Wt5kni0xN/UeYWmRcoxL/2GaaRe6z0kiD1NxIRNpj3GIakz4LW6YxHpaaImCNac4/C
         fl8p6fE4xBtuW1MsFWCX34HO/YCxvYmxwdDC8R/70EWIIQ3ZmoZTdpZWr787RJW/kueZ
         QXt8o1DKgq/YfU9AoF390oIyWkG+IblRUs+kFr5ZcykjQmQX6Kb5cWu3fuLC0cNAKRpS
         Llob84bCYPw0zLpomfS23S1dHYquDMJfAUbTKeALBoUDrsxrLh16Mm8L7K+H/HI9m0TL
         Aing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680049309;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eENpLd222ixV/BEnAXd0sJR92bJ82vOOCby7utTN/Sg=;
        b=B5d9aV5TsRRd+pJhR+stomc/wohbO5XxZAeH9tsFlrdxWEXCwTwUtrjOK5V8gNjwYX
         gsWuIU0Z52YqmDkWsYhtRrLGQbaMX1ipi2j5FEJ5h08u08A5Zo+PHE8fX23iehT+SFSL
         Q4SW53fCuU6jSzJkYw8b7tS1MOywvCfCsRSF1kWeUHXRS64LyoOUiyahZmeLefzbUuvC
         xPR3DesicJe9G59CA5Av+LN3tJyvXOGm0KmVD97yuYl+N3V89SBQHr845mwVKIgc00ni
         eAqSLtpPxXw/PXJdfSvdqw6BZ12lPq2Eb2ieXnbd/G6E8D2hT8fi68regNo1e9wCM1pv
         kj0w==
X-Gm-Message-State: AAQBX9do57hRqp8ENhw5+3n2bWEaUHgmRY0XPkz5xMpSpRf/VrE9Qudf
        ATm3DuoUI8/M7JBsQj5De9jaieTVoz8=
X-Google-Smtp-Source: AKy350bYlftYs/VjTtPUhS+UZTqUG+PyB67xAw95S2F9WnlDiwxxGHU3sZYm6ArConjwnrWRT7z6nY2Gezw=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:102b:b0:b6c:48c3:3c1c with SMTP id
 x11-20020a056902102b00b00b6c48c33c1cmr11754883ybt.13.1680049309492; Tue, 28
 Mar 2023 17:21:49 -0700 (PDT)
Date:   Tue, 28 Mar 2023 17:21:34 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329002136.2463442-1-reijiw@google.com>
Subject: [PATCH v1 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series will fix bugs in KVM's handling of PMUSERENR_EL0.

With PMU access support from EL0 [1], the perf subsystem would
set CR and ER bits of PMUSERENR_EL0 as needed to allow EL0 to have
a direct access to PMU counters.  However, KVM appears to assume
that the register value is always zero for the host EL0, and has
the following two problems in handling the register.

[A] The host EL0 might lose the direct access to PMU counters, as
    KVM always clears PMUSERENR_EL0 before returning to userspace.

[B] With VHE, the guest EL0 access to PMU counters might be trapped
    to EL1 instead of to EL2 (even when PMUSERENR_EL0 for the guest
    indicates that the guest EL0 has an access to the counters).
    This is because, with VHE, KVM sets ER, CR, SW and EN bits of
    PMUSERENR_EL0 to 1 on vcpu_load() to ensure to trap PMU access
    from the guset EL0 to EL2, but those bits might be cleared by
    the perf subsystem after vcpu_load() (when PMU counters are
    programmed for the vPMU emulation).

Patch-1 will fix [A], and Patch-2 will fix [B] respectively.
The series is based on v6.3-rc4.

[1] https://github.com/torvalds/linux/commit/83a7a4d643d33a8b74a42229346b7ed7139fcef9

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Ensure to trap PMU access from EL0 to EL2

 arch/arm64/include/asm/kvm_host.h       |  3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 28 +++++++++++++------------
 2 files changed, 18 insertions(+), 13 deletions(-)


base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
-- 
2.40.0.348.gf938b09366-goog

