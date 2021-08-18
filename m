Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E703F0B2E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhHRSnz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhHRSnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:43:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAB6C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p71-20020a25424a0000b029056092741626so3795275yba.19
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l9Ep8m3SAn8ZPERlomDWGpbLnUSGIc8n7kJ/7XvQr3I=;
        b=oIzGtBG58c+wvTDLuFazeHcg/gPwfiCk99Ee97zl4k8+L1dKwwmXs34v0QUT+bnKvT
         zy2wQkhJznKa9FoL9aYZvaWbFcmaNuQ5HC7MaQIo23e5A65KMd5QY9coe3o8Cz+JX2Ho
         M4liQQY7ZD2n0JX+hAYWOcsYpcRw2GjnmE5vvhh4PuKMCSZjcvAR2RROiVsvHax1lE4k
         MLEjVq9Gc7d//PDBCATacOIlXbDaZkjxQbM6IRbd57wJS36WL/Hma0q8f7uJ+i9VgVs8
         Aa6/Rq3XxQ3+WcbKhYrsxs6dcXxbPlqk2kbX+K1Bj7/unA4RNBS4ewt+qC1CPtFoKXdc
         TMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l9Ep8m3SAn8ZPERlomDWGpbLnUSGIc8n7kJ/7XvQr3I=;
        b=bOfQPNy64x6F+uke2eQ0082nbWqhLCTVL5toIapfgsvlYG/qaE0p2S2AK5XzSRgEEa
         ukyCCgIAIoyzt6jPCztUJWwaDQkRxjCEuPsO9UisxNIpS/vH9TjSveTm4KS07q4xiMHn
         OiMkqk0Z1GEKAX9nOYB2Trm7HgUQRh+sMJ1IMZ5bOYwd2YMcMupFgAYRWM7ubymKkfjH
         wL4g4WeeHYOLzSQ1Kjee1DTe9/UVQBz/0P/sOgAfjfD7OfczjNyCrh14myI0TuYmDjiI
         /OrQcEVj3Gf875Ggu8JLRtnDHwbTXwTJZh3bgYN2oPmGqrdU6f8Y8XcNppwql5GZ00mS
         EBKg==
X-Gm-Message-State: AOAM530A4UU7peQLISdq7dfDTsR+kAhUS+VPHGM+d/xmBLDWncxLYa2e
        oc+Uij6L2HptS7gXy+dlXOojmJlg8E5i
X-Google-Smtp-Source: ABdhPJzL1rSeACANcoAXaGAe6gCJ9waFOyb6BJmgH5pkNGv5e5te1StvfFWXP1m0l6m9UcT33XY90MOeQG06
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6902:547:: with SMTP id
 z7mr4683235ybs.303.1629312196319; Wed, 18 Aug 2021 11:43:16 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:01 +0000
Message-Id: <20210818184311.517295-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-9). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Since the test heavily depends on interrupts, the patch series also
adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
to the KVM selftest framework (patch-8).

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, and so on, are also
introduced that the test/GICv3 takes advantage of (patches 1 through 7).

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

Raghavendra Rao Ananta (10):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add arch_timer test

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/arch_timer.c        | 382 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          | 142 +++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 ++
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 ++++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 ++++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 13 files changed, 1176 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

