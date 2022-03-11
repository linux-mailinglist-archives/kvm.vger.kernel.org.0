Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7EE4D67C7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350830AbiCKRmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243959AbiCKRmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:09 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69B1BE4D0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:01 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id a2-20020a056e020e0200b002c6344a01c9so5984057ilk.13
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CaZECgSQQngAZ4EFaCTOOf/knhTC32OnUGVX63d7H30=;
        b=Z7i8z7fruZx8KKcK+U57/Z4fpEHj/pSiGoZWk7dkaay7yQzSe9vy1hOh4vU6+xj0uN
         Df/OW1pUWUBf6i2QaEpW6LN/soXfqT3UgGESIihLN5LnqTyR7Xbr6kYScZnkc3bJunIR
         HbU8IQoUpj+Z83fchRrtPmNMul5E32Il5zQKIxjHPrihRsuooKXBMXsbmpMXYEwyblkn
         oBvaeYQE7gDaqXMIyMehK5WmVsKonuLKWFUdTGKkVRUmeFVZjs0DToycOvdf4FiyvMrt
         MwUbDYlhz+8gSXiuSFXMMs9+bx+fsWUHPBt1NJz0xA1w83/Mgaw6GWcd+Z5LZKik8y4P
         WN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CaZECgSQQngAZ4EFaCTOOf/knhTC32OnUGVX63d7H30=;
        b=I6kRDCAS6KDRDtU9/eGlGZCcUFlECXE6ROPq1fMUddJ1O+U1rWrynSU8xIutSf8ZI9
         pjcLPRZXpe6ipjBgnlClZV0ZqVEiAt+a3vJP5dfiKjJZcnt2HSxLKQznuF2g8EkT8pph
         42z923RYunBghoknV70681TQ1tjgaeqe4cAztOqm5P5hAf0DFXMyTYLlRBn47wW8WAmd
         +WKIxgMONICjEcjYQdKy5Dis+UwS1h+q/zN81ZPJDRJ64IrMr8ZmBuZ5JWQ8fVue0wDZ
         Zbcve6r3l10wHGvUhFtx23r/ZEkWCCJ4AVkuCneKowp6fKceRx+1shcvlccUi3VWpjjF
         vxFQ==
X-Gm-Message-State: AOAM5325TZ0PIVMry8pz3vU0m90HYgOw83FU84Evp4/ppYvwZjkJCZnt
        9K7n0esEtz2H6kHDULRoOOIWYsv3YrE=
X-Google-Smtp-Source: ABdhPJyEHlgCGDdV6xgBOz7Pnzf7qCUae7tY13dxi43ECMUekR46DfcK8JkoEyIMWvetCp5+i4QJrNChqqs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:6a60:0:b0:315:4758:1be1 with SMTP id
 m32-20020a026a60000000b0031547581be1mr9375898jaf.316.1647020460754; Fri, 11
 Mar 2022 09:41:00 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:46 +0000
Message-Id: <20220311174001.605719-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 00/15] KVM: arm64: PSCI SYSTEM_SUSPEND + SYSTEM_RESET2 bugfix
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

**NOTE** Patch 2 is a bugfix for commit d43583b890e7 ("KVM: arm64:
Expose PSCI SYSTEM_RESET2 call to the guest") on kvmarm/next. Without
this patch, it is possible for the guest to call
PSCI_1_1_FN64_SYSTEM_RESET2 from AArch32.

The PSCI v1.0 specification describes a call, SYSTEM_SUSPEND, which
allows software to request that the system be placed into the lowest
possible power state and await an IMPLEMENTATION DEFINED wakeup event.
This call is optional in v1.0 and v1.1. KVM does not currently support
this optional call.

This series adds support for the PSCI SYSTEM_SUSPEND call to KVM/arm64.
For reasons best explained in PATCH 09/15, it is infeasible to correctly
implement PSCI SYSTEM_SUSPEND like the other system-wide PSCI calls,
wherein part of the implementation exists in the kernel and the rest in
userspace. To that end, this series affords userspace the ability to
trap SYSTEM_SUSPEND calls (with opt-in) and to optionally leverage
in-kernel emulation of a suspension by way of a new MP_STATE.

Patch 1 snags a useful change from Marc to use bits in an unsigned long
to indicate boolean properties of a VM instead of boolean fields. This
patch was lifted from [1] and modified to eliminate kvm_arch::ran_once.

Patches 2-3 rework some of the PSCI switch statements to make them a bit
more futureproof for later extension. Namely, eliminate dependence on
falling through to the default case. Additionally, reject any and all
SMC64 calls made from AArch32 instead of checking on a case-by-case
basis.

Patch 4 starts tracking the MP state of vCPUs explicitly, as subsequent
changes add additional states that cannot be otherwise represented.

Patch 5 is a renaming nit to clarify the KVM_REQ_SLEEP handler processes
(instead of makes) requests.

Patch 6 creates a helper for preparing kvm_run to do a system event
exit.

Patch 7 prepares for the case where a vCPU request could result in an
exit to userspace.

Patch 8 adds support for userspace to request in-kernel emulation of a
suspended vCPU as the architectural execution of a WFI instruction.
Userspace gets to decide when to resume the vCPU, so KVM will just exit
every time a wakeup event is recognized (unmasked pending interrupt).

Patch 9 adds a capability that allows userspace to trap the
SYSTEM_SUSPEND PSCI call. KVM does absolutely nothing besides exit to
avoid possible races when exiting to userspace.

Patches 10-14 rework some SMCCC handling in KVM selftests as well as
prepare the PSCI test for more test cases.

Lastly, patch 15 adds test cases for SYSTEM_SUSPEND, verifying that it
is discoverable with the PSCI_FEATURES call and results in exits to
userspace when directly called.

Given the conflicts/fixes for SYSTEM_RESET2 and conflicts with
Documentation changes, this series is based on kvmarm/next at commit:

  9872e6bc08d6 ("Merge branch kvm-arm64/psci-1.1 into kvmarm-master/next")

This series was tested with the included selftest as well as a kvmtool
series that instruments the userspace portion of SYSTEM_SUSPEND that
will be sent out soon.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/mmu/guest-MMIO-guard&id=7dd0a13a4217b870f2e83cdc6045e5ce482a5340

v3: https://patchwork.kernel.org/project/kvm/cover/20220223041844.3984439-1-oupton@google.com/

v3 -> v4:
 - Rebase to kvmarm/next
 - Grab Marc's VM feature patch
 - Drop filtering for an invalid IPA. It is no longer directly relevant
   to this series and can be sent out separately.
 - Use the kvm_mp_state structure to store a vCPU's MP state (Marc)
 - Rename helper to better fit MP state mnemonic (Marc)
 - Don't even bother with an in-kernel implementation of the
   SYSTEM_SUSPEND call (Marc)
 - Add discoverability tests for SYSTEM_SUSPEND
 - Ack from Anup for RISC-V change.

Marc Zyngier (1):
  KVM: arm64: Generalise VM features into a set of flags

Oliver Upton (14):
  KVM: arm64: Generally disallow SMC64 for AArch32 guests
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
 arch/arm64/include/asm/kvm_host.h             |  25 +-
 arch/arm64/kvm/arm.c                          | 100 ++++++--
 arch/arm64/kvm/mmio.c                         |   3 +-
 arch/arm64/kvm/pmu-emul.c                     |   4 +-
 arch/arm64/kvm/psci.c                         |  80 ++++---
 arch/riscv/kvm/vcpu_sbi_v01.c                 |   4 +-
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
 18 files changed, 501 insertions(+), 209 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c

-- 
2.35.1.723.g4982287a31-goog

