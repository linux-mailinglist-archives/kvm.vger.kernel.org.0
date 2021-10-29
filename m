Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5043F3F2
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhJ2AfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 20:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhJ2AfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 20:35:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0848DC061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w199-20020a25c7d0000000b005bea7566924so11248880ybe.20
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 17:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vw5IElLY3kB8cY1L2Z+7D5wanBys4JUHwDM1VncqKoI=;
        b=PCh1M803lS/Kd65Q8t89i5Nu8M1/0FfLF3gOxRVpd9H5ySYjaVIlKhrcBmAAZHAvHL
         v1TsKipc2dhUgHXNlPnV6jTdmV8k9F46xup3BxToefljw/OFIXB7jePY2Cm5XrOxHzi1
         s8M6HeWExB082mLRIgrKgNPhssfGoXV53P/km8PJih9ZFR6rbrcbCAS6w32AIVYPYJgJ
         jkreVHIwHpBpbmFJP36xIPd7JbRl7aE/2xUzNuumQ+Q8H5dY5ooxCypcZIgwXw/K8JHp
         PkbLJ/g8MvaXOZdsUClyOyvB5EZXIMWrkgMJezJ2FuSquxP6Vg4Umm2GNRVIu2mPTA1R
         K2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vw5IElLY3kB8cY1L2Z+7D5wanBys4JUHwDM1VncqKoI=;
        b=6iyzu7N9sW8M0KXgmUCMvEeeR85VXbRtKL0332P77Oh7LfQuSu1jt4vSiNRSgH6uHL
         1Um7b0K9kGrSUtHrRQUhBZa80A93GfKQOxxy8fMjfE+uRgpUb7/EkpWl+bcPHDQhOZUt
         1nKlxfmwKaat6KbVI2vZo8ACmC9NehxZgZ3Jqq0Qm08GfVuJikiepx0heu3Z0hPoLER2
         aJiCuykOJhvd44PnujfsZ0Av7Lccep/zhC472qrZ92JR//1j/XgALfPpGd9o4BZXD5ky
         vIm8cTvAhoGsCfTPqZJITZr2y6nmZjZHgQWqtk/uOPIoITPV+FsQr+8HRt2tiFJ26bYk
         5XIQ==
X-Gm-Message-State: AOAM530rgdGeX4hUGxtMFOlFW3sO7F/Qw2JJ7TlZVX3otRY5j+YXod4g
        xMcPCsVu9hZ3TfvLpF+RrRKyTNIYI7E=
X-Google-Smtp-Source: ABdhPJxAz30X4IhyMRe9T1OY/gwd77ukFMDfy0+meau5n4bTd35B4sOyPkxXfMVZntXji4d0V4ISRBJUilI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:aac8:: with SMTP id t66mr8949989ybi.238.1635467561151;
 Thu, 28 Oct 2021 17:32:41 -0700 (PDT)
Date:   Fri, 29 Oct 2021 00:31:59 +0000
Message-Id: <20211029003202.158161-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 0/3] KVM: arm64: Fixes for the exposed debug architecture
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

I had a conversation with Marc about some of the quirks around the debug
architecture on KVM and incorporated some of his suggestions into a
series here. Of course, any glaring mistakes/choices made in this series
is on me :-)

Anyhow:

KVM's implementation of the debug architecture is a bit deviant as it
stands. For one, KVM handles the OS Lock as RAZ/WI, even though the
architecture mandates it. Additionally, KVM advertises more than it can
actually support: FEAT_DoubleLock is exposed as implemented to the
guest, though OSDLR_EL1 is handled as RAZ/WI too.

Only v8.2+ revisions of the debug architecture permit implementations to
omit DoubleLock. Fortunately, the delta between v8.0 and v8.2 is
entirely focused on external debug, a feature that KVM does not support
and likely never will. So, there isn't much of a hurdle to bump KVM's
reported DebugVer to v8.2, thereby allowing KVM to omit DoubleLock from
ID_AA64DFR0_EL1. Of the remaining bits of external debug visible to the
guest, the only additional thing to address is the OSLAR_EL1 issue by
simply context switching the host/guest values.

Patch 1 changes the way KVM backs OSLSR_EL1 in the sys reg table.
Instead of returning a static value from its handler, stash a copy of it
in kvm_cpu_context and return that when read.

Patch 2 makes the material change of allowing a guest to actually toggle
the OSLK bit by redirecting writes to OSLAR_EL1.OSLK to OSLSR_EL1.OSLK.
When saving context, simply stash the value of OSLSR_EL1. On resume,
apply OSLSR_EL1.OSLK to OSLAR_EL1.OSLK.

Finally, Patch 3 raises the KVM debug architecture to v8.2 and exposes
FEAT_DoubleLock as NI to the guest. With the changes to OSLAR_EL1 in
this series, KVM now does what it says on the tin.

This series applies cleanly to 5.15-rc4, and was (lightly) tested by
booting 5.15-rc4 as a kvmtool guest on this kernel.

Oliver Upton (3):
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow the guest to change the OS Lock status
  KVM: arm64: Raise KVM's reported debug architecture to v8.2

 arch/arm64/include/asm/kvm_host.h          |  1 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  5 +++
 arch/arm64/kvm/sys_regs.c                  | 42 ++++++++++++++++------
 3 files changed, 37 insertions(+), 11 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

