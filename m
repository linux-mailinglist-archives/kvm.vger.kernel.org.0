Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599C7442AA5
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhKBJtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKBJtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Nov 2021 05:49:35 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C972EC061714
        for <kvm@vger.kernel.org>; Tue,  2 Nov 2021 02:47:00 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id s21-20020a056602169500b005e184f81e0fso6485891iow.22
        for <kvm@vger.kernel.org>; Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8Hd2ZUMx5ILHWyo2zM7pIHkuH4DnNmNsL76fDtWtm1s=;
        b=E2M0qmyqra/TlmR8sNdUNnqypFAgx2byfZsucj64HcfDQTvxD/mvhZJkXohOyHvfnv
         d5IB+ZGFXPR88GhGj/Ivf6QeDGp/6YurkWU2p55yIF4wdlt+JGIIU7r6G+HtZB05dFYo
         CGJuXlvDZLzUfyKYuMfoyq10hlYCDy/eizAOlLOxyNs7nwnVK952aeHGe/7QAwduEmge
         +I11gM4N4guNIyZWghqOG+A1y17uVCtQQwQhMKCIY5yU3QnKn7qPfbhZl8i+MP/Jd3Kf
         l3LWpUcJCZ8LPuWIkK9ibOyrEYmODpJ1s/MuMXosi0RdgDOUHSUtMAoyMKpl4/92Jzdp
         NXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8Hd2ZUMx5ILHWyo2zM7pIHkuH4DnNmNsL76fDtWtm1s=;
        b=A4cxLR6AKje5BOJzPqPiH8gqajpD7ikf1HDCBbj0LkfOSbsBf2bai8kiLW+Z5AASFH
         pikeB0C0XVR7orDScMsejLYqeVOFyOd6ClmLxaN4NdHDrWXtzgBjUyPwkd47Kcm+Hqx3
         5HzxA7A25Sx4tQZ8q8SpLPANeyNRCS4Fw+tDUGFtL/sBmklxeAMiVk8zGM8dtKfB8jN1
         Qhr0PKQCsnquFlZp12y3svhEo1SRO82pWeVzZh1nR76EOIjD7nu+GxG3NoB1f0D40A3q
         BADNo6/87yqYqq4EyIRQ4pEx2IglRBgBumr8Kv+cmGU3ob0J1Zusc5r9QOQ2lALPuGMi
         au+A==
X-Gm-Message-State: AOAM530xHmm+4f2A8QlP7QfGPI9Qor26541zFIf0SjYRwqMyeKw8j0g4
        AfhKsC5zQg68acansr/3BfLVpyZfBEE=
X-Google-Smtp-Source: ABdhPJwp82eJZKpATb/STfJK1tEYrOYlTSbWGpyQyJFGOHuzO64TyzBAnAXrfYhajH7o5tbhGvqNlILST3A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:c9c1:: with SMTP id c1mr11157225jap.0.1635846420169;
 Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
Date:   Tue,  2 Nov 2021 09:46:45 +0000
Message-Id: <20211102094651.2071532-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 0/6] KVM: arm64: Emulate the OS lock
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM does not implement the debug architecture to the letter of the
specification. One such issue is the fact that KVM treats the OS Lock as
RAZ/WI, rather than emulating its behavior on hardware. This series adds
emulation support for the OS Lock to KVM. Emulation is warranted as the
OS Lock affects debug exceptions taken from all ELs, and is not limited
to only the context of the guest.

The 1st patch is a correctness fix for the OSLSR register, ensuring
the trap handler actually is written to suggest WO behavior. Note that
the changed code should never be reached on a correct implementation, as
hardware should generate the undef, not KVM.

The 2nd patch adds the necessary context to track guest values of the
OS Lock bit and exposes the value to userspace for the sake of
migration.

The 3rd patch makes the OSLK bit writable in OSLAR_EL1 (from the guest)
and OSLSR_EL1 (from userspace), but does nothing with its value.

The 4th patch actually implements the OS Lock behavior, disabling all
debug exceptions from the perspective of the guest. This is done by
disabling MDE and SS in MDSCR_EL1. Since software breakpoint
instructions cannot be masked by anything but the OS Lock, we emulate by
trapping debug exceptions to EL2 and skipping the breakpoint. Skip this
whole song and dance altogether if userspace is debugging the guest.

The 5th patch asserts that OSLSR_EL1 is exposed by KVM to userspace
through the KVM_GET_REG_LIST ioctl. Lastly, the 6th patch asserts that
no debug exceptions are routed to the guest when the OSLK bit is set.

This series applies cleanly to 5.15. Tested on an Ampere Altra machine
with the included selftests patches. Additionally, I single-stepped a
guest using kvmtool to make sure userspace debugging is still working
correctly.

[v1]: http://lore.kernel.org/r/20211029003202.158161-1-oupton@google.com

v1 -> v2:
 - Added OSLSR_EL1 to get-reg-list test
 - Added test cases to debug-exceptions test
 - Scrapped the context switching of OSLSR_EL1
 - Dropped DFR0 changes, to be addressed in a later series

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  5 ++
 arch/arm64/include/asm/sysreg.h               |  6 ++
 arch/arm64/kvm/debug.c                        | 20 ++++--
 arch/arm64/kvm/handle_exit.c                  |  8 +++
 arch/arm64/kvm/sys_regs.c                     | 70 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 7 files changed, 144 insertions(+), 24 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

