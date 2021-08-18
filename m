Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E771A3EFF90
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 10:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhHRIvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 04:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhHRIvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 04:51:31 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D98C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:50:56 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id y20-20020a056e020f5400b00224400d1c21so839258ilj.11
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 01:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SFFBjk6fBfzTLeFLGMERukTfXI4cB+XvM9PLOmI8ffA=;
        b=q72p8Z4Um676qw+5B767IOnYYDKK3/aifELNlK2Nx7ieNC7tChONoMx6HgmB8Vl+L3
         sptokUlysxY8fuChZK2Y9wCz6tKf72GCX8UPtaUdaArzZ7pxjlP8Uomp8IoCXmVBym6K
         1sDbX+Sjq8UQMFzJAJy8XIiGI57lSQsHhQ5MIJR4EJX0xfiDQLdhjv9fheqlrosBktSZ
         bA4U/0nAosKE+vM2qZcXZE9J4nIrd2nIKdlvSERoGS9zoKWWH2cu0RK8g82kg9Trvb4y
         EKP8L7FVI1sMEhelj9xASjAE6RkMfYHdib8/FeA10BND3Jdo5TvM14x58WGa8aDawf01
         FCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SFFBjk6fBfzTLeFLGMERukTfXI4cB+XvM9PLOmI8ffA=;
        b=GtQzv6lPvzoU8sPqPGIsqhOdyxBmrMTXLdIlL6bPuzUF4XW0/Id/+e2SLU/G4ccbNu
         XWc2d9sc8VDL0maT4b8OHTgQMIEzdVLsobfCD6vjt80+8zeoKERrCKpHYzGngiqyARym
         fXD2sAvNDW8UikuDq9XQzvVklUL5cmUDWjuglyqpKj1J5V4IjQV4rCzVs4xczitRS33k
         yo6J65PffNq/xBEAEp+qj9HEcbzT6OylfiY4IVFf/kbEShjCA8/5pAbHELO/uj1+FzmV
         5yIk1i5blCqg3XHyuiz8mGaPkqx9xM3DVS8FZKoJJTjjuT5/Os4WCleng6ZbAO0tmq4+
         3rzw==
X-Gm-Message-State: AOAM532Z4thDlCz/PWWNeEgmtDdh+S4d4gv3YTTC591ZoR5+xcEtGqNW
        GWAOVDO7+CPM0KjdAsvL/qzSAOhj1tCdjwL5FiPiUAZIOH8mjkPlmsKqh4ymYrt47ShUg2Ti9WM
        5JAUj5MrtRxBSK7W2RoNnmj25f7WEUejf85FRJEul7mDRevq+VrpH1wf0Tw==
X-Google-Smtp-Source: ABdhPJwp3MbNRnUFgUnmbFferx21vJX38gpSFXR8tLXbf1G2rfJlZ4+PcXRuGotHHSYcgebHCnnN3cdBS4M=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:dd88:: with SMTP id g8mr5675929iln.158.1629276656060;
 Wed, 18 Aug 2021 01:50:56 -0700 (PDT)
Date:   Wed, 18 Aug 2021 08:50:43 +0000
Message-Id: <20210818085047.1005285-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/4] KVM: arm64: Fix some races in CPU_ON PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CPU_ON PSCI call requires careful coordination between vCPUs in KVM,
as it allows callers to send a payload (pc, context id) to another vCPU
to start execution. There are a couple of races in the handling of
CPU_ON:

 - KVM uses the kvm->lock to serialize the write-side of a vCPU's reset
   state. However, kvm_vcpu_reset() doesn't take the lock on the
   read-size, meaning the vCPU could be reset with interleaved state
   from two separate CPU_ON calls.

 - If a targeted vCPU never enters the guest again (say, the VMM was
   getting ready to migrate), then the reset payload is never actually
   folded in to the vCPU's registers. Despite this, the calling vCPU has
   already made the target runnable. Migrating the target vCPU at this
   time will result in execution from its old PC, not execution coming
   out of the reset state at the requested address.

Patch 1 addresses the read-side race in KVM's CPU_ON implementation.

Patch 2 fixes the KVM/VMM race by resetting a vCPU (if requested)
whenever the VMM tries to read out its registers. Gross, but it avoids
exposing the vcpu_reset_state structure through some other UAPI. That is
undesirable, as we really are only trying to paper over the
implementation details of PSCI in KVM.

Patch 3 is unrelated, and is based on my own reading of the PSCI
specification. In short, if you invoke PSCI_ON from AArch64, then you
must set the Aff3 bits. This is impossible if you use the 32 bit
function, since the arguments are only 32 bits. Just return
INVALID_PARAMS to the guest in this case.

This series cleanly applies to kvm-arm/next at the following commit:

ae280335cdb5 ("Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next")

The series was tested with the included KVM selftest on an Ampere Mt.
Jade system. Broken behavior was verified using the same test on
kvm-arm/next, sans this series.

Oliver Upton (4):
  KVM: arm64: Fix read-side race on updates to vcpu reset state
  KVM: arm64: Handle PSCI resets before userspace touches vCPU state
  KVM: arm64: Enforce reserved bits for PSCI target affinities
  selftests: KVM: Introduce psci_cpu_on_test

 arch/arm64/kvm/arm.c                          |   9 ++
 arch/arm64/kvm/psci.c                         |  20 ++-
 arch/arm64/kvm/reset.c                        |  16 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   3 +
 7 files changed, 162 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c

-- 
2.33.0.rc1.237.g0d66db33f3-goog

