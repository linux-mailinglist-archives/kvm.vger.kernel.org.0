Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F733F0C9A
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhHRUWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 16:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbhHRUWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 16:22:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF7C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:36 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x10-20020a05622a000ab02902982df43057so1531533qtw.9
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 13:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WXJPnFEjLyNrsHUbWIgf/gvEc1e+fUVAP4iQlBo9KEc=;
        b=KlGbNAIjTWTtbpNpUH6cgKKGcDuIwO8nZx020krswpm9E2TOS02eix5vl7prvpwbSX
         NHoj8cmogcR7oSwJ4dfOcY62zAOxrJ6RDMR55YL7EGiI/rDsqs5i17BdA7APVI0snlS0
         vWJ85Y/vMLoTCUvGvySJYXR8zWNh1sppdCzyFrRMlytwU8h/h1wvZQoHv9f/PmkSH2Zy
         X1HvP+PkN6gsXOKKYQyO2uCTaWSVBiv6/BRxrUgQ/Jhllo3ac2cxJ4CEXaXtCC025TzU
         nkkAfCHr2ohXVb6hzMUZJDC937+n3JrqXDO6Rk+Fo+qEl77Iud0nA83vF865XvThopTI
         pqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WXJPnFEjLyNrsHUbWIgf/gvEc1e+fUVAP4iQlBo9KEc=;
        b=ZjIMR4fgyeyPGgf/GJCZkncMLJvDw8OeGZY46kI37GQtJVSjq0+axPXucwyB0eX1wU
         fe+XDP6Ce1RQJROKw9V6OUqwiv2n73hrx7U3YxYGJ3WvaPNGBVptSlB/EGxcCkc/F1+F
         xsrEYMw5EI8K+gptvChfI2qHS1HRKl4PGsDxast2ty5lUIHVCko+C/WnPNKUiPRflWQM
         Yxzx++aoVZXBtpLMMp5gP/7f0ekGyCZfOLctIK4mu437SyIUOrNT1bkzHZx0ni8zjjTG
         m+uNNUAo6Y0l8NS9pQcj6iHeLE/AuDqiDZ53tgS2rHxtHz2VBKbBAJJCSDgl3vSrBf32
         0z1A==
X-Gm-Message-State: AOAM533yIJBs8xDTgbfFXiGTPK5iXo/HGl3HUP0mmuuGdFECSJ6BeTyv
        mzU2dZaFpuqt3QJ9OKWe8mBtTggL1OtpLdh15QIHfmyZZe0XUqVZrY8tnMsAd4FXl3xPdzmOUEc
        ysDvnQT3rlVHJq8+sUvoEWJ/3DoJbtEBJ2+al3tRm2yQlKtdATWCdIh2nYA==
X-Google-Smtp-Source: ABdhPJyXRTZH1sgyNZ0IEvDRpdJZwxkl7akSNB9SJ9fTfbpZBNgTEuZYrRMjNXtfv6RQ63mYOx/KK896CKI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:500b:: with SMTP id
 jo11mr10823569qvb.52.1629318095735; Wed, 18 Aug 2021 13:21:35 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:21:29 +0000
Message-Id: <20210818202133.1106786-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 0/4] KVM: arm64: Fix some races in CPU_ON PSCI call
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
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

This series cleanly applies to v5.14-rc6

The series was tested with the included KVM selftest on an Ampere Mt.
Jade system. Broken behavior was verified using the same test on
v5.14-rc6, sans this series.

v1: http://lore.kernel.org/r/20210818085047.1005285-1-oupton@google.com

v1 -> v2:
 - avoid memcpy for reading reset state (Marc)
 - promote reset_state.reset = false to WRITE_ONCE() (Marc)
 - rephrase comment, commit msg (Marc)
 - cite the PSCI spec precisely (Marc)
 - drop unnecessary mask-down to 32 bits in CPU_ON (Marc)
 - rebased on top of v5.14-rc6

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

