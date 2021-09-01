Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57C33FE49E
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244982AbhIAVPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243869AbhIAVPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BB6C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e137-20020a25698f000000b0059b84c50006so861508ybc.11
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IC7/AY/yxBuXuyMg4BXoHPpcO7Yg2Uivpm2g2M9LU9A=;
        b=YQHM7qcabtCeKsJwLf7HSWD9CrXjcLsr4d0DY40Vmr5wcyCYXWTLTf3b/khxxjj+17
         PKEVzkoqYS+iYNbfnnnrqg908lXzOGyt9JWO2ofeUyJJ1E57soPd0H6BH58byFMHx11f
         qcfjpZQw6/uvhxE/TNRHYOenlJR2uZxToYKHiTaBrRVLUOXil632AMGsPSv8Gq8OYzXT
         X5mwhkbk5S8sI64LX1hgVBuu1OzMoDJDn0mGLgHDJNn4QTEHPLG9AzFWCtxXy1j6wYuL
         h53KotFX7laUBh6f/2jJ8tg/TDIfr6anaMXLy2jWzoBHJXKg6YQxiv23D8cBtgJy3bpI
         OoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IC7/AY/yxBuXuyMg4BXoHPpcO7Yg2Uivpm2g2M9LU9A=;
        b=ZmyswS082ELfqAqpVrBd4qapm49jkAoat4L/pu4DWeoxeiyAvThOLzptpYtCgWaiYQ
         NaMuWWD4jWcwUajTQBQBXMW23UlvT3ueTamF2Twvaa82j0IxhBZO8dcRn9iTBne7b0aA
         PAkXJTdpL+ANG05cv+Ajb7TCXGywyxBslH+40qWGV1rnq30I8SxDOjwTjrJna8NGaZeZ
         9gGaMKDFFJnMNfzWXfEJ0uEqVfCS1BDa2/WDnpbiFvtwmcD3ruhNDTP+GfACyHKcbrw9
         RLfo4PcTBLBamlWgFXr3WjWrB25Xrzrp0WqJgwGZ7H4S9jLHroDh7wQTeqv6ZKqX3bDc
         1+8A==
X-Gm-Message-State: AOAM530A8Y46/9GSgqGZJpXz9HjDlrBDHXNKzgstOLrTvriLylmB1Hrz
        Ol/yuGXOx2vc8N7uyLqGt2myAIdxpaT7
X-Google-Smtp-Source: ABdhPJzVt2OJAdldm107LqGs2piLrTLDAJR7RMU/Sc/Yly0nF0QfNnqBHMDf+WR1oTUaLCXqKhGQrQRWp7fj
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a5b:443:: with SMTP id s3mr2083384ybp.299.1630530858232;
 Wed, 01 Sep 2021 14:14:18 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:00 +0000
Message-Id: <20210901211412.4171835-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 00/12] KVM: arm64: selftests: Introduce arch_timer selftest
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The patch series adds a KVM selftest to validate the behavior of
ARM's generic timer (patch-11). The test programs the timer IRQs
periodically, and for each interrupt, it validates the behaviour
against the architecture specifications. The test further provides
a command-line interface to configure the number of vCPUs, the
period of the timer, and the number of iterations that the test
has to run for.

Patch-12 adds an option to randomly migrate the vCPUs to different
physical CPUs across the system. The bug for the fix provided by
Marc with commit 3134cc8beb69d0d ("KVM: arm64: vgic: Resample HW
pending state on deactivation") was discovered using arch_timer
test with vCPU migrations.

Since the test heavily depends on interrupts, patch-10 adds a host
library to setup ARM Generic Interrupt Controller v3 (GICv3). This
includes creating a vGIC device, setting up distributor and
redistributor attributes, and mapping the guest physical addresses.
Symmetrical to this, patch-9 adds a guest library to talk to the vGIC,
which includes initializing the controller, enabling/disabling the
interrupts, and so on.

Furthermore, additional processor utilities such as accessing the MMIO
(via readl/writel), read/write to assembler unsupported registers,
basic delay generation, enable/disable local IRQs, and so on, are also
introduced that the test/GICv3 takes advantage of (patches 1 through 8).

The patch series, specifically the library support, is derived from the
kvm-unit-tests and the kernel itself.

Regards,
Raghavendra

v2 -> v3:

- Addressed the comments from Ricardo regarding moving the vGIC host
  support for selftests to its own library.
- Added an option (-m) to migrate the guest vCPUs to physical CPUs
  in the system.

v1 -> v2:

Addressed comments from Zenghui in include/aarch64/arch_timer.h:
- Correct the header description
- Remove unnecessary inclusion of linux/sizes.h
- Re-arrange CTL_ defines in ascending order
- Remove inappropriate 'return' from timer_set_* functions, which
  returns 'void'.

Raghavendra Rao Ananta (12):
  KVM: arm64: selftests: Add MMIO readl/writel support
  KVM: arm64: selftests: Add write_sysreg_s and read_sysreg_s
  KVM: arm64: selftests: Add support for cpu_relax
  KVM: arm64: selftests: Add basic support for arch_timers
  KVM: arm64: selftests: Add basic support to generate delays
  KVM: arm64: selftests: Add support to disable and enable local IRQs
  KVM: arm64: selftests: Add support to get the vcpuid from MPIDR_EL1
  KVM: arm64: selftests: Add light-weight spinlock support
  KVM: arm64: selftests: Add basic GICv3 support
  KVM: arm64: selftests: Add host support for vGIC
  KVM: arm64: selftests: Add arch_timer test
  KVM: arm64: selftests: arch_timer: Support vCPU migration

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../selftests/kvm/aarch64/arch_timer.c        | 457 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          | 142 ++++++
 .../selftests/kvm/include/aarch64/delay.h     |  25 +
 .../selftests/kvm/include/aarch64/gic.h       |  21 +
 .../selftests/kvm/include/aarch64/processor.h | 140 +++++-
 .../selftests/kvm/include/aarch64/spinlock.h  |  13 +
 .../selftests/kvm/include/aarch64/vgic.h      |  14 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 ++++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  21 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 +++++++++
 .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++
 .../selftests/kvm/lib/aarch64/spinlock.c      |  27 ++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  67 +++
 15 files changed, 1332 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer.c
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/arch_timer.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/spinlock.h
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/spinlock.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

-- 
2.33.0.153.gba50c8fa24-goog

