Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0358745ADC0
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbhKWVE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 16:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbhKWVE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 16:04:26 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2C3C061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:16 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id m6-20020a0566022e8600b005ec18906edaso158648iow.6
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 13:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4Jy9ZNvtLqSyNCGaQe67LiBMWweegmq5EAtgAYXEIo8=;
        b=C6+YVcqTvJAgK9Pcl8zQs362VGJn34iwhdZwoWTiSLIHyIQO2DA/U9jsP7Bw+gdDJn
         5mPcJu8ToV4+GJTv22tFCrKLWcTpiIC5UCeUGZp9dYHBbjDP7og23OZ7gHYtceljUV37
         hcj2can/fRzWsv7caiHv5f11NX8YsrzLALvI07GD031eEIQnMU1iFKBUOtmTU4CG+sxI
         nIkOusBb6IcF7bZLrQSIOCSG2L+wMbXDDQPfYIdTXlKgXA7jBVSc/cOwNcql8WDXLKN1
         vq3PZA3BvLpGk9f30GuuFEckK0MqjOjZYjuoxSn6Uhn2ckFg3GG6oxlLPjCQ9HRb3OtD
         SAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4Jy9ZNvtLqSyNCGaQe67LiBMWweegmq5EAtgAYXEIo8=;
        b=yZp/S8EEoWGHpH0LLwrHcgtZi0eNV7++lTCjrlDsQSeXNaF5CabG0D42O7jiWLAlxz
         t/m4UTPV9QTDn4vRvlruwTgAYqo+j1nZM2lAkUsma96VnKxXLlV4BQJx2giFUpV6EH9K
         HVUlkgTkrC+U3EekMd36cwT7ViIyqABTwKvpOZywF5erw5LP6pW+qDRN7YoPveGi5F4W
         SnjVYzm1kK0qMdtfqQyX5O9yIqjyTt/aYESS0DJc11b+19YHifCNcxzTeyOMVWVCIbze
         Pkcf6B2glKhsKlcsIAevBIoZ22qRRbfz+lkvz5LdG369T5UpioVfApfj+EONq56mmjA8
         Or+A==
X-Gm-Message-State: AOAM533GW1t7y+WUXXbe2/hz/l+wEB3QQSlqnc4eo/aDWl93skEnduZk
        /9nZOi9Xr9Qolujlyp8SuHj+RNhKoYE=
X-Google-Smtp-Source: ABdhPJwseHjr6oKumnq1kaHVtftmYAstQdQZxGpG32BJhANLhxR/L06sDCbf1VsVsCjLO3yQPf8BUbhcFVg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1b8a:: with SMTP id
 h10mr7719477ili.14.1637701276051; Tue, 23 Nov 2021 13:01:16 -0800 (PST)
Date:   Tue, 23 Nov 2021 21:01:03 +0000
Message-Id: <20211123210109.1605642-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 0/6] KVM: arm64: Emulate the OS lock
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

This series applies cleanly to 5.16-rc2. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/sysreg.h               |  6 ++
 arch/arm64/kvm/debug.c                        | 27 +++++--
 arch/arm64/kvm/sys_regs.c                     | 70 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 145 insertions(+), 23 deletions(-)

-- 
2.34.0.rc2.393.gf8c9666880-goog

