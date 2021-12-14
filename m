Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E86474966
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 18:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbhLNR2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbhLNR2S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 12:28:18 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0BBC06173F
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:17 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id y15-20020a056e02174f00b002a4222f24a5so18351459ill.3
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 09:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zk8b273QnCh6EBKHsBLZCwm7phsH1qXNNxAFMztBRMQ=;
        b=Z1p6iB38u4qCLN3DR6XCPMSeigD1Z90OlOv79x1GPPrkP/Zle4CFrX7F1AkqkyLyv7
         pTfAm2sxx5KBGsVYl56DkuvF8sus9B08ph5GevUidg2bCb2erwD34UEBUPgQOLv2mcgR
         ttlLQ+aDL8Y+RBNggNyu2CUQAdU88fB6nPfi8d7KDMjMMZQ8uVCn5U/6ZJr8yehKvQq0
         YK4s3ktTyMmfdGY1232w6DsMQ2PcXxxJkoJxHs+J6kv9Z3xtxkjSTBPdaELbVMwVRRj6
         Vpp1uDVLDs+pDeM0HqOS9PL1A9Jajy0DfNyDpiCp0whq9oBBQx135HKMKyhmTo12gaXb
         NmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zk8b273QnCh6EBKHsBLZCwm7phsH1qXNNxAFMztBRMQ=;
        b=TsDkcKCvyoRIoLarK6lV53WokKT8yBT8uDNYHY4ajhOVLqeD94hAQcOSK3u+aagKSM
         V6tLwukY5FeSCeKumWCsUG2hmMXAmoU2gtLh5Tr1lDCnJQh3NAoSCEmfZqwWTOi6ZYD+
         ZLRrn/K9kaP9dfiShtvh31LckIgBTILhQvPZFnTIIDFysrRgHmMa2hp9aI/qV51wMP+O
         Gs07BJHKBZs1BwxzAUa/80/S5UY6dXNXmCkdhctpbQyElZy/49xBtm76SSITAz4yun1U
         WR2xfkJTnGye99R4qYET0TcLJi4XnksP0sADTx/pt+m6DkVdZK6wBf2XCeLd+WqML+KK
         Wg/g==
X-Gm-Message-State: AOAM533nkZiylEaJNItGKvdpBbeQ/KcVUGsg4LdyHVrR8ZZD0pSs11SF
        +I8xW2Qikjmaf81q5KV0ElRA2rSeMZs=
X-Google-Smtp-Source: ABdhPJwm2kW1tWIdTafhk7By1Qz8hjfZFCojXCQPPWKGX9iyHrDuiA02tnU4jkY+2HaL5PjwP1IH8HpANww=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:8747:: with SMTP id d7mr4479540ilm.203.1639502896974;
 Tue, 14 Dec 2021 09:28:16 -0800 (PST)
Date:   Tue, 14 Dec 2021 17:28:06 +0000
Message-Id: <20211214172812.2894560-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 0/6] KVM: arm64: Emulate the OS Lock
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
debug exceptions (except breakpoint instructions) from the perspective
of the guest. This is done by disabling MDE and SS in MDSCR_EL1.

The 5th patch asserts that OSLSR_EL1 is exposed by KVM to userspace
through the KVM_GET_REG_LIST ioctl. Lastly, the 6th patch asserts that
no debug exceptions are routed to the guest when the OSLK bit is set.

This series applies cleanly to 5.16-rc4. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/sysreg.h               |  9 +++
 arch/arm64/kvm/debug.c                        | 26 ++++++-
 arch/arm64/kvm/sys_regs.c                     | 74 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 151 insertions(+), 23 deletions(-)

-- 
2.34.1.173.g76aa8bc2d0-goog

