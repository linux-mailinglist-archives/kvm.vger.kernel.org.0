Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EC25195D4
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbiEDD2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiEDD23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:28:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7450C275CC
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:24:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t3-20020a656083000000b0039cf337edd6so87012pgu.18
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KgPp4H0NuOXhN/wKLMYd5omlFxsjaCCDTXWIWXRSBbg=;
        b=DmyQSOYJGcco5+Z4OTfOviHTkWkf+fn4I7+QmVo96W+55a7ZQD7pIzftEAC3pnN8ZA
         l9JcBz03PNT7zTv1nUYlVUfKoC4VpY85yltqlsI6Xvd0Lmqep6+thdtV2s31+MT0FwpO
         QGEQ4A0BkecMPTbEqMvp6Bg+K7qJLJjV/zOSNJf03h0nwFjjTIyWhhDSnW3slTH3bsJH
         Y4c3nZYGMB+yKeWutRtXiYPLrYyUfec5ztQc2jKgLOypWbICymKSrVim4l4DL1zPUIiP
         CHdmOTTLgA3y6KADxJGz9tVkJJ5ra4vTG89lT4lG9Vo9O6O5GYBs/0RUyCzDTxEKH6w1
         PRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KgPp4H0NuOXhN/wKLMYd5omlFxsjaCCDTXWIWXRSBbg=;
        b=4+dSOTc3OZtTKM0h4EPHIajtWvBtxoqn7SO4gHKI7dpni6atGgAr1RSwJ/ts8x2DLX
         97sqKrB33uyfbHIu37wBVepKp7wXy+WAgGZywQpz3FTE8+syOkmJx6xWfO2F7ixOwCqU
         txsQWNfEsri99y2hjdPtwwaT4Mb9lxUn7p+Z+Qdsf73rw7isd9/QYWn4ZCNLF9JzqRzs
         kF7k9uaN++0O4OdneSKnrcn0JijoiZVZUqkTd5vlIx04IfT85CX1b3jbckat07YDt+D0
         TsXhD1WiJPJ0wwf3+jDWfqEj3uwfFpGP+VbdGa8y0lKBKt4cOZRiwAM4AGb0URl9B8DI
         e83g==
X-Gm-Message-State: AOAM532gdC/daQ8vflht+AXOH70wKUQoTV32+BC/HMOZx6SBsq+jIlRA
        m2O4irIaNFkUu6oU6jLURBHY7qzA71M=
X-Google-Smtp-Source: ABdhPJy0md364rnqqnpBagaJWaE/z1Wg/rNj8Qldyb9Z+17hxkDrPJCpHr8Z5hTe7QOHoLuWhwefh8NqYp8=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:c986:b0:1d9:56e7:4e83 with SMTP id
 w6-20020a17090ac98600b001d956e74e83mr221104pjt.1.1651634693511; Tue, 03 May
 2022 20:24:53 -0700 (PDT)
Date:   Wed,  4 May 2022 03:24:34 +0000
Message-Id: <20220504032446.4133305-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 00/12] KVM: arm64: PSCI SYSTEM_SUSPEND support
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        reijiw@google.com, ricarkol@google.com,
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

The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
allows software to request that the system be placed into the lowest
possible power state and await a wakeup event. This call is optional
in v1.0 and v1.1. KVM does not currently support this optional call.

This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
For reasons best described in patch 8, it is infeasible to correctly
implement PSCI SYSTEM_SUSPEND (or any system-wide event for that matter)
in a split design between kernel/userspace. As such, this series cheaply
exits to userspace so it can decide what to do with the call. This
series also gives userspace some help to emulate suspension with a new
MP state that awaits an unmasked pending interrupt.

Patches 1-5 are small reworks to more easily shoehorn the new features
into the kernel.

Patch 6 stands up the new suspend MP state, allowing userspace to
emulate the PSCI call.

Patch 7 actually allows userspace to enable the PSCI call, which
requires explicit opt-in for the new KVM_EXIT_SYSTEM_EVENT type.

Patches 8-11 clean up the way PSCI is tested in selftests to more easily
add new test cases.

Finally, the last patch actually tests that PSCI SYSTEM_SUSPEND calls
within the guest result in userspace exits.

Applies cleanly to 5.18-rc5. I'm sure you're already aware of it Marc,
but for the sake of everyone else there's some light conflict with
Raghu's patches that you've got queued up [1].

Tested with the included selftest and a hacked up kvmtool [2] with support
for the new UAPI.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/hcall-selection
[2]: https://lore.kernel.org/all/20220311175717.616958-1-oupton@google.com/

v5: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

v5 -> v6:
  - Rebase to 5.18-rc5
  - Collect Reiji's R-b's
  - Drop the system_event helper. Since we now have variadic data
    returning to userspace it doesn't make much sense to roll it up into
    a helper. Meh.
  - Put back the pointless kvm_vcpu_request() in kvm_arm_vcpu_suspend().
    We'll rip out the reliance on vCPU requests for power state later
    on. It is entirely benign, even when a vCPU targets itself.

Oliver Upton (12):
  KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
  KVM: arm64: Dedupe vCPU power off helpers
  KVM: arm64: Track vCPU power state using MP state values
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: arm64: Return a value from check_vcpu_requests()
  KVM: arm64: Add support for userspace to suspend a vCPU
  KVM: arm64: Implement PSCI SYSTEM_SUSPEND
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |  76 ++++++-
 arch/arm64/include/asm/kvm_host.h             |  10 +-
 arch/arm64/kvm/arm.c                          | 104 +++++++--
 arch/arm64/kvm/psci.c                         |  65 ++++--
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 213 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 12 files changed, 480 insertions(+), 177 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.36.0.464.gb9c8b46e94-goog

