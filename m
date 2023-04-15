Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D466E327D
	for <lists+kvm@lfdr.de>; Sat, 15 Apr 2023 18:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDOQkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Apr 2023 12:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOQkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Apr 2023 12:40:41 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6DA421B
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 09:40:40 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id pq9-20020a17090b3d8900b00247447dce91so1840746pjb.8
        for <kvm@vger.kernel.org>; Sat, 15 Apr 2023 09:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681576839; x=1684168839;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=edJ/8m/hi3oLGytM7aKqe1ZAWmH9bh2Sy5kO3X9HLCg=;
        b=2QAl3z9GUrv+fNBQ0blS9baSho0J11b079sd+mJX3sh0TkcWMTcgtJabqPYXI/Z1KK
         n08VA3LjH4GuKOF+dlVgh0RGVXP9/0gk7UZTJgobLZDghhbp7FvNbB5bZFprdObPwaS1
         phquLKjrHz+8FlCccLG2WDN9tCRYSmtZbzH8dasm7VR3Yyh9SF/aVUL/qI/xpDIUe9Jf
         hHxlo2H3AtQtBpSXPxpcju4yFNYSQDArFOh+GBmgfFTLCGddYnJKCCVEtMPGjn3kOSNE
         ch/XtDmfccFdFQ5uGTWbY+QezeRTFON94CtS1lrfWkigpKts5sNxJuMzXOOksmUhbKfr
         Knkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681576839; x=1684168839;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=edJ/8m/hi3oLGytM7aKqe1ZAWmH9bh2Sy5kO3X9HLCg=;
        b=AhyMyi5w1YztQbDzxvwLttZDpWZESR2GLnBgHPKAe39YDnEd3mmJtAN0kREXyIJcql
         2f8Dob5HfbdxTzxBU/oOdD7L3i5bW/yHO/0ZeJX/VSwAzNAZv+VYgGTO/ZeYL5/W97ZX
         mw9PfZfPWU9DRW0L902rwD4POci4wu0XzukH0jM8DRjgnz+OUrzsvWHd6SCIrnPxXdEU
         zQwnQ6H7riu70N48YYT31U/zAI91NBF/fsjGbuivZmceIHBLmpuaSSOfCXn+WG6CSw+U
         7jJ75wjfgluOTvSY601XMsXfYoLKn3WzVoyu82d4cxtHwhfP682YTVWedOQhsMhfwdXx
         oiBQ==
X-Gm-Message-State: AAQBX9cJLI+glISGsaAEumAyexT8+dPWa67PMH5z0zYOfK5PmxOJhEgE
        V8SAwnogQLL0K7iJ1j2KNL55MPH97lo=
X-Google-Smtp-Source: AKy350Yv3s5ep7D7zZyG+Et4G6Q08mYKXp9AqiJJfgV4/tHON+L4dGztaBGVDdCldKPepvfT1xtBuK3yPus=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:ba5a:0:b0:518:244c:1cde with SMTP id
 l26-20020a63ba5a000000b00518244c1cdemr1709195pgu.2.1681576839640; Sat, 15 Apr
 2023 09:40:39 -0700 (PDT)
Date:   Sat, 15 Apr 2023 09:40:27 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230415164029.526895-1-reijiw@google.com>
Subject: [PATCH v3 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
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

v3:
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

Reiji Watanabe (2):
  KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
  KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded

 arch/arm64/include/asm/kvm_host.h       |  7 +++++
 arch/arm64/kernel/perf_event.c          | 21 ++++++++++++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 37 +++++++++++++++++++++++--
 arch/arm64/kvm/hyp/nvhe/Makefile        |  2 +-
 arch/arm64/kvm/pmu.c                    | 25 +++++++++++++++++
 include/linux/irqflags.h                |  4 +--
 6 files changed, 88 insertions(+), 8 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.40.0.634.g4ca3ef3211-goog

