Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8914FAA5F
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbiDISsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 14:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiDISsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 14:48:08 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223B122B25
        for <kvm@vger.kernel.org>; Sat,  9 Apr 2022 11:46:00 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id u5-20020a056e02110500b002ca9dc66d3dso1083851ilk.22
        for <kvm@vger.kernel.org>; Sat, 09 Apr 2022 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2O5CotoUSOZWSX+DgcMySzP79UQI3Nfk4A4+f0zgD3M=;
        b=N2gl4ry2kPPGTCsnaLq6meOWeqG1zyBXus/SEfje763OmvLx9jreiUAkx5s+8PK4Mz
         ZuXbkfDPs0z8aQGkLgf1T0IB1mUhd2e8Aa1C3M5CO73Q8XULWv3oxi2VWSoUwEvSSex1
         u3zPwuyYKKJeAiWFqrrQsHDZjJ2n1jWIHDTk0ZkCImGf4SUeO5cEDeEZGAxNV1CoTnWl
         nu7nG+DerlFXD3OWn+eVyIC4pIeTACRdFQ1wxKidxA9Rag/q0F9Su8PVyFYIdn+YtoMD
         izxesDdaoRjOfMdcYrZqHHG/7aOO0XsLP9XUKvkhwD7ANibxESAXvpFliZXXz9mPgHWT
         cb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2O5CotoUSOZWSX+DgcMySzP79UQI3Nfk4A4+f0zgD3M=;
        b=H+3rKVL146EQeulLKdv0+qjMHG9c+CiPte8xEPAo1Deciagoa8OQp6KoRlK5aE/jOe
         SFOGll9ndrV0j6UCxCMhrajhs0L4VwEafKi8qDEhZgA6MlL+zCv8ONiin6T3d/bcn7Vn
         jzJIIb8D6ExMzXgoiuKnv2otGq+etPjLYEgw+sM6BbqTYiDCjiB+vUzz1xzARP1DFIL0
         4wndb2ymDrskbss+9Gv3c/Ptr7fOUSiw50wikDTYgaSor6guWmMjkTJMTulWJg0PMn0H
         D1JefEFFSugWHKtwWH8g/C2z7UizYPvll4zhT1wPYw1dCQFRvvK2Ml0zatTpFcG15j6f
         +LKQ==
X-Gm-Message-State: AOAM533LmwwxLzrXNTw+DNz9MxGT+QC9Cij8SeMUzkmFmyFDPorthIYl
        MXgdOxo4MkWrtdTlty26z278ekB5+u8=
X-Google-Smtp-Source: ABdhPJx7mmaiQYRNM78+N4In0mzcOq8mhVFldJrAmdB4tW4+VGr/cmbClLZZLQuRs4be4V33PypTBrX6vFw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:38a3:b0:326:24b9:e196 with SMTP id
 b35-20020a05663838a300b0032624b9e196mr635674jav.255.1649529959542; Sat, 09
 Apr 2022 11:45:59 -0700 (PDT)
Date:   Sat,  9 Apr 2022 18:45:36 +0000
Message-Id: <20220409184549.1681189-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 00/13] KVM: arm64: PSCI SYSTEM_SUSPEND support
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
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

Patches 1-6 are small reworks to more easily shoehorn the new features
into the kernel.

Patch 7 stands up the new suspend MP state, allowing userspace to
emulate the PSCI call.

Patch 8 actually allows userspace to enable the PSCI call, which
requires explicit opt-in for the new KVM_EXIT_SYSTEM_EVENT type.

Patches 9-12 clean up the way PSCI is tested in selftests to more easily
add new test cases.

Finally, the last patch actually tests that PSCI SYSTEM_SUSPEND calls
within the guest result in userspace exits.

Applies cleanly to kvmarm/fixes, at the following commit:

  21db83846683 ("selftests: KVM: Free the GIC FD when cleaning up in arch_timer")

This is because there's some patches on the fixes branch that would
cause conflicts with this series otherwise.

Tested with the included selftest and a hacked up kvmtool [1] with support
for the new UAPI.

[1]: https://lore.kernel.org/all/20220311175717.616958-1-oupton@google.com/

v4: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com

v4 -> v5:
 - Rebase to kvmarm/fixes (5.18-rc1 + a bit more)
 - Rework system event helper around RISC-V SBI changes (Anup)
 - Don't presume a vCPU has been woken up when it returns from
   kvm_vcpu_wfi(), as there are other situations where the vCPU thread
   unblocks, such as signals. (Reiji)
 - Tighten up comments/docs (Reiji)

Oliver Upton (13):
  KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
  KVM: arm64: Dedupe vCPU power off helpers
  KVM: arm64: Track vCPU power state using MP state values
  KVM: arm64: Rename the KVM_REQ_SLEEP handler
  KVM: Create helper for setting a system event exit
  KVM: arm64: Return a value from check_vcpu_requests()
  KVM: arm64: Add support for userspace to suspend a vCPU
  KVM: arm64: Implement PSCI SYSTEM_SUSPEND
  selftests: KVM: Rename psci_cpu_on_test to psci_test
  selftests: KVM: Create helper for making SMCCC calls
  selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
  selftests: KVM: Refactor psci_test to make it amenable to new tests
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 Documentation/virt/kvm/api.rst                |  76 ++++++-
 arch/arm64/include/asm/kvm_host.h             |  11 +-
 arch/arm64/kvm/arm.c                          | 107 +++++++--
 arch/arm64/kvm/psci.c                         |  66 +++---
 arch/riscv/kvm/vcpu_sbi.c                     |   5 +-
 arch/x86/kvm/x86.c                            |   6 +-
 include/linux/kvm_host.h                      |   2 +
 include/uapi/linux/kvm.h                      |   4 +
 tools/testing/selftests/kvm/.gitignore        |   2 +-
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 121 ----------
 .../testing/selftests/kvm/aarch64/psci_test.c | 213 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  22 ++
 .../selftests/kvm/lib/aarch64/processor.c     |  25 ++
 tools/testing/selftests/kvm/steal_time.c      |  13 +-
 virt/kvm/kvm_main.c                           |   8 +
 16 files changed, 493 insertions(+), 190 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.35.1.1178.g4f1659d476-goog

