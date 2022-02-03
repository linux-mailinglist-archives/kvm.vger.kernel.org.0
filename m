Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE34A8A59
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiBCRmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiBCRmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:42:03 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EFBC061714
        for <kvm@vger.kernel.org>; Thu,  3 Feb 2022 09:42:03 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id y18-20020a92c752000000b002bc083421e7so2153754ilp.13
        for <kvm@vger.kernel.org>; Thu, 03 Feb 2022 09:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wtbaMJAcQnUO9qTorbz70eUVIMRxM9RIgak6LcFUBbE=;
        b=iWNSw66HK3xFVyVWo/nsSDvNahYyh+8iHQJGXCfl3MJyq2KHy6SMvZSRDHo7jjcsa6
         aT/A4CoJClWOCyEsZ47ZyfOsfXa3mo2Zhq3huMk2v7GZ4Gbbd61Yr1kmKtsZ6G8rtpHp
         9GhIdFPv67wk8HcMhQMhIXwyFx8eIq5z5rajhIq70WXQFf3Y0XVPvFPY44cFKQVm1Iz8
         /mEUwV2WwvfAsZKWlqtuBOZstP64tAw4+ra1wS5tfyeKHuTxxMkhb3O7Uvwa7fP0N+xg
         KMOxGB7rNY9eiz1+5dM25v5H9+y2stts4LjSN1YbGzmUAcyuAWCsKZ2d1Ot39Df9oQEf
         I5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wtbaMJAcQnUO9qTorbz70eUVIMRxM9RIgak6LcFUBbE=;
        b=Hkaj/Y7+hkDDYGO6kRllzLTurAJlGLSKktuLXgWFj1FkOnmqOpg1vPWCOF0CD5JSzl
         qECHWz9+2kKbGkpiUHMFEkttCxOgtN+GvWSuPdJ9KgJ81vxUSQMttI51y/A8/RhQCpVN
         lxQWfIHvXa4A/nQITkNTR9ljGyQnmZZ0nWdWHtcsj3yQs99EVak+UvIsfQVIOu1l4GLX
         WmhAnH+a/pOoybxWdTXKDL+pi0MnhMOwoIq0qOilO/pOGZU1oLr8kUDtALRdvSL4MIvg
         yU3rME1arwFe+KY4sA3Ko2uSemdCz+/mElybABMRGplyUmsoeE6GJ6KrFCf9kbv3TI6i
         ObDA==
X-Gm-Message-State: AOAM532IvqyN+v55jOPPUFoC7gsVjHl6dHhHWhNg6WfEiUXO1WBwsPOv
        1wSUM4SRlKIZ0egRxDzKliM/wrGfkcc=
X-Google-Smtp-Source: ABdhPJyjGwifMCspxAbvAxARlfmTo1KqwjLTOFFoUnnZSSU36ffXdntHhtr3u0pDpdD2d1Wz/BXGRIOMtWM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:83c1:: with SMTP id j1mr18511925jah.185.1643910122833;
 Thu, 03 Feb 2022 09:42:02 -0800 (PST)
Date:   Thu,  3 Feb 2022 17:41:53 +0000
Message-Id: <20220203174159.2887882-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v5 0/6] KVM: arm64: Emulate the OS Lock
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
        Mark Rutland <mark.rutland@arm.com>,
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

With this series a new register is exposed to userspace: OSLSR_EL1.
Since the register was not exposed to userspace before, changes to
register mutability do not have ABI breakage implications.

This series applies cleanly to 5.17-rc2. Tested on an Ampere Altra
machine with the included selftests patches.

Oliver Upton (6):
  KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow guest to set the OSLK bit
  KVM: arm64: Emulate the OS Lock
  selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
  selftests: KVM: Test OS lock behavior

 arch/arm64/include/asm/kvm_host.h             |  5 ++
 arch/arm64/include/asm/sysreg.h               |  8 ++
 arch/arm64/kvm/debug.c                        | 26 ++++++-
 arch/arm64/kvm/sys_regs.c                     | 74 ++++++++++++++-----
 .../selftests/kvm/aarch64/debug-exceptions.c  | 58 ++++++++++++++-
 .../selftests/kvm/aarch64/get-reg-list.c      |  1 +
 6 files changed, 149 insertions(+), 23 deletions(-)

-- 
2.35.0.263.gb82422642f-goog

