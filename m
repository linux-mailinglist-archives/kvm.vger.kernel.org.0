Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8933F2330
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhHSWhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbhHSWhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689EDC061756
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w201-20020a25dfd2000000b00594695384d1so8023751ybg.20
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=hVLqpfJyik/aNFUVhgkn5ayQKvTB31kCk1HpemlZ0PQ=;
        b=GVin9ZIo8I4PynVJRsVMmAXOcqMyYaVqEzH+8z/eUNoXN8UG91sa6EC9fkjEn9xBre
         wLjfmlUSr8AV0SDnhLLG9ol7IzYBlmwUnaSNmrKYc1QMYSRym9e7tdOebKRJwJEbR7v2
         lGKnctauKMxPl/EOy2QEc5Z9H0574kKfbqEm34EZxFaTiZDXTN88HVvge8Fi0L+dNi+i
         Sjb+nyFuGATdY799YV0IcFKzfhmf9H7Z20kFjrJazV36ANC5jOYSF49koRxq71br307U
         y5u60XEsDL6BiTI0Ye/mugeKEYHrpvKyIkn2FfiAj9JWl5pjekralsIP9C+3TytPlQbV
         GeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=hVLqpfJyik/aNFUVhgkn5ayQKvTB31kCk1HpemlZ0PQ=;
        b=JB1XMCcOQ/Z4sUzZBgL+7R3oNeAwYKElIG/x/nKSv9/1UTeQe9OjF3BDvEy7P+m1Cg
         OqFiUvM6zRPAPtpPEFbU7u7y++Yh+m6YN55eros5fmDN2rF4h5yYKCmDyrO65LLiGX7b
         pr2MDS+/sFTg0JeosucdMOjatoaUvxsJVhrerFibzF36PiPVcmZTgXCsN2/ohm1ygSz6
         HPcJqdKolOLfIf/aIVct1nCZkUnV570Kv5WgS/erT6ly390+j1EYbs7MYmafwWUIa8/G
         3NJS4eoMYalMJOA5yEQAWh3+JkdDSquwF35Yk+96IeqVjnq/Pj2A71CZZ5FlxLb+R8qI
         V0Tg==
X-Gm-Message-State: AOAM530mJ4cbr436t6sSQJw5cA4XfgM3poOW4pXhAnhIZI/jA1opcxWc
        iXjfqwPHpdYm9vP1w6NLRR266Ep+Uq6sLDOTmcuhjyf6clXiIzJBF7TNFqilJI4wSNNzTDXbKIX
        hZPLwMkh80/pz8WzyCwkdQwxKcUBwQ/bDb05Cfb8tAFFRkB625dHsayUkAg==
X-Google-Smtp-Source: ABdhPJwSrjQerrU1uikVnLI3vJ2z24wtkGEFdI8gQO/BHJSju1355boZQO0W8F52k/AIOIKPAb3ocFx1CF8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dfd5:: with SMTP id w204mr18198187ybg.78.1629412603603;
 Thu, 19 Aug 2021 15:36:43 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:34 +0000
Message-Id: <20210819223640.3564975-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
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

Certain VMMs/operators may wish to give their guests the ability to
initiate a system suspend that could result in the VM being saved to
persistent storage to be resumed at a later time. The PSCI v1.0
specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
request a system suspend. This call is optional for v1.0, and KVM
elected to not support the call in its v1.0 implementation.

This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
Since this is a system-scoped event, KVM cannot quiesce the VM on its
own. We add a new system exit type in this series to clue in userspace
that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
that doesn't care about this event can simply resume the guest without
issue (we set up the calling vCPU to come out of reset correctly on next
KVM_RUN).

Patch 1 is unrelated, and is a fix for "KVM: arm64: Enforce reserved
bits for PSCI target affinities" on the kvmarm/next branch. Nothing
particularly hairy, just an unused param.

Patch 2 simplifies the function to check if KVM allows a particular PSCI
function. We can generally disallow any PSCI function that sets the
SMC64 bit in the PSCI function ID.

Patch 3 wraps up the PSCI reset logic used for CPU_ON, which will be
needed later to queue up a reset on the vCPU that requested the system
suspend.

Patch 4 brings in the new UAPI and PSCI call, guarded behind a VM
capability for backwards compatibility.

Patch 5 is indirectly related to this series, and avoids compiler
reordering on PSCI calls in the selftest introduced by "selftests: KVM:
Introduce psci_cpu_on_test".

Finally, patch 6 extends the PSCI selftest to verify the
SYSTEM_SUSPEND PSCI call behaves as intended.

These patches apply cleanly to kvmarm/next at the following commit:

f2267b87ecd5 ("Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next")

The series is intentionally based on kvmarm/next for the sake of fixing
patches only present there in [1/6] and [5/6]. Tested on QEMU (ick)
since my Mt. Jade box is out to lunch at the moment and for some unknown
reason the toolchain on my work computer doesn't play nice with the FVP.

Oliver Upton (6):
  KVM: arm64: Drop unused vcpu param to kvm_psci_valid_affinity()
  KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
  KVM: arm64: Encapsulate reset request logic in a helper function
  KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
  selftests: KVM: Promote PSCI hypercalls to asm volatile
  selftests: KVM: Test SYSTEM_SUSPEND PSCI call

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/arm.c                          |   5 +
 arch/arm64/kvm/psci.c                         | 134 +++++++++++++-----
 include/uapi/linux/kvm.h                      |   2 +
 .../selftests/kvm/aarch64/psci_cpu_on_test.c  | 126 +++++++++++-----
 5 files changed, 202 insertions(+), 68 deletions(-)

-- 
2.33.0.rc2.250.ged5fa647cd-goog

