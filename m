Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0A6E3512
	for <lists+kvm@lfdr.de>; Sun, 16 Apr 2023 06:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjDPExe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Apr 2023 00:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDPExd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Apr 2023 00:53:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F8326BB
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 21:53:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u188-20020a2560c5000000b00b8f15f2111dso16273608ybb.4
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 21:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681620811; x=1684212811;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GSBOHO8J2MQ2o/VKIsPqTm9ugOUbkx/1SnLPtI3xz4A=;
        b=ao6Gt0p3QbgT6+gIHy9isrfjtcrgOsou5uEF8cXmo65HRAKbSjAWxBlj5942sbxx7Y
         /LqSQftNAIHrBN8knrrYx+4xCYjN/X82j3NAddpQDH9Rlx5YGZf8VxJqH09V7XpxhFJx
         PdWGl5uOrq8wtx/GO6wmEfxK2+rlcFb6ZO8G8UnK8ey0/TeOKeDZI4vdkuVmTjHX4Jdm
         O9h6hXfUrxOQXsInVKpGZilOzVoAEBqBQ6vPAsQNSJhHcY2LbqUE6sS3rKDCP/s5kK4d
         PzFCt9s8+1cojNl2E6UpxGcnGyx9sA3BYYsvaJXx4ve5N6GbB7UiuIhHfywVhcEywCPj
         hW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681620811; x=1684212811;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GSBOHO8J2MQ2o/VKIsPqTm9ugOUbkx/1SnLPtI3xz4A=;
        b=QZkWvEalNPKFF9Q29onnufvAZnNJqbcUy6kjGvGjVlSTr/bjx5HhQ2yea3Zxc92Txf
         52D5veVlcbzcJ0+IbvOfom0kNLApijnUkWf2Vw+4RoPfGfPsXUBWrkxk7TAaWK5AKUnH
         urzT1fWpFJrdJleD+kBoJTdyi6LJMLRg/La3QRL9nAx26yD0WxBE3tu+O5LzUPDrafdP
         gNycJ6mVeTTN4mhl5JFVKcRhBBYdCWOvQg2Y+Y4Dso1FrQaGNrq23I3aPG/GoPx09x7n
         flyHxcWxyrOVt/ODcCxxMgJlvsglw1RnyQXgbyX2gdMCNzBwFm90+alQnEM/w8XYywmh
         tS1Q==
X-Gm-Message-State: AAQBX9eGU0dz0HhRhWjzv3CQM4jdJKLwiL5H/vgiCidLZk5stpHP9vFR
        XhWhSHZzjajD6BbXwCOPYjkAGlquT6k=
X-Google-Smtp-Source: AKy350YrV2Jc2viuvwLHBzra9y9vpzRiIgY9TA0+SRfr+P59RNJCm7Qq0WQi8xckYzZJwFXI/uJfbMWGyoU=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:e08c:0:b0:b8f:3647:d757 with SMTP id
 x134-20020a25e08c000000b00b8f3647d757mr7226448ybg.11.1681620811185; Sat, 15
 Apr 2023 21:53:31 -0700 (PDT)
Date:   Sat, 15 Apr 2023 21:53:14 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230416045316.1367849-1-reijiw@google.com>
Subject: [PATCH v4 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Rob Herring <robh@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
The series is based on v6.3-rc6.

v4:
 - Introduce NO_DEBUG_IRQFLAGS to exclude warn_bogus_irq_restore()
   from the nVHE hyp code. This is to address the issue [2] that
   was reported by kernel test robot <lkp@intel.com>.

v3: https://lore.kernel.org/all/20230415164029.526895-1-reijiw@google.com/
 - While vcpu_{put,load}() are manipulating PMUSERENR_EL0,
   disable IRQs to prevent a race condition between these
   processes and IPIs that updates PMUSERENR_EL0. [Mark]

v2: https://lore.kernel.org/all/20230408034759.2369068-1-reijiw@google.com/
 - Save the PMUSERENR_EL0 for the host in the sysreg array of
   kvm_host_data. [Marc]
 - Don't let armv8pmu_start() overwrite PMUSERENR if the vCPU
   is loaded, instead have KVM update the saved shadow register
   value for the host. [Marc, Mark]

v1: https://lore.kernel.org/all/20230329002136.2463442-1-reijiw@google.com/

[1] https://github.com/torvalds/linux/commit/83a7a4d643d33a8b74a42229346b7ed7139fcef9
[2] https://lore.kernel.org/all/202304160658.Oqr1xZbi-lkp@intel.com/

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm64/include/asm/kvm_host.h       |  7 +++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/pmu.c                    | 25 +++++++++++++++++
 include/linux/irqflags.h                |  6 ++--
 6 files changed, 89 insertions(+), 9 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0.634.g4ca3ef3211-goog

