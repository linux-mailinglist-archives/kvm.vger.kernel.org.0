Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8933ECBDF
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhHPAMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhHPAMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:05 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE9C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:34 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id s22-20020a5e98160000b02905afde383110so4774605ioj.8
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iJYsu7fpasA4KCIA5cuNFhT9/QgsjAss3yu7wk60u8Q=;
        b=aQj/I1mY6r1r03IW3BWlNheUhL3RDYxx/4BIrimzwkzt2gfhIN0A/tEFP0+K8V90Cb
         zKOXBSuylCsQDzsL6PKOCbhHzPGaGBvEjREeSHMXlsWBrwkycNJXsX+SXhJltmySqdbK
         0cP3Dur3EwL6skxpgnFzlPK4SKLVQkZ3dYumZnisLLglIrZdTmu6K+DSv77KoVVtKS9+
         XU3+hWyiPbJPXOwf+NesHBYEuz9EfXIqrStikdtcpAorkuSS1tERCKbQqUPs7FYKEZY3
         O1roXtb6SaQoT+f3WJVvzZ1103URmkOQIs2VyJAu7ES9jAZAYzXa2e1wv7mCIVAjrSo3
         hyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iJYsu7fpasA4KCIA5cuNFhT9/QgsjAss3yu7wk60u8Q=;
        b=chzaRG2lJW/RMG7LY/y8nYWZ1oqLiVTwGFUZ/1nb4YbBq+Cx1SBsRKTgZ3596w961a
         ktJgUHbxYdPy1DM0zkJnYk1uBjfivV5qOLTxpidsL9tZ4AnLkUZubZj+h4ZtLYZMncVD
         8QwrLPQ5et5G84Nk5Z30ra9KmsoDDHSoi76kFib/rMqhzgQ+UBWGLSlyigCS9bj0ZSEL
         3tSHU3AQ4tEImb8Nz2sYgTVFhF1952m84LA4KGWrvX246uOFn13as3jirxrJvXGA3EU7
         TcmqdHSRq5hVWQiW9fm0PQBR/TLcgsABcxhrKBC5dqI8nqikUciRAodyez4LxSFL9vkN
         ysYg==
X-Gm-Message-State: AOAM5319EEX9VpxRs+SWsbY7oWSECMsC2mzC2J3z+FQqOD59+3rdupzs
        O6fEy62zRgk13bGkpHtI94I8v730e8C/2v6gLu0KEuLIN3PXmkvnJqyoEHwUfBb66ADBqjkT46r
        rWhYUeffuR/oIx/qpL0FbgG7BqVAY7T5qlrrUYymaSnC+p7bASWGraXrQ6g==
X-Google-Smtp-Source: ABdhPJyyEq1JPYrQ+owXHLwmCeY/SoZMfZe5R92+IYuMRt/23mdj7nVwa7/HPh0wkyoJLBOG25OQdvvomhs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:8915:: with SMTP id k21mr4192645ioj.137.1629072694172;
 Sun, 15 Aug 2021 17:11:34 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:24 +0000
Message-Id: <20210816001130.3059564-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 0/6] KVM: x86: Add idempotent controls for migrating system
 counter state
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM's current means of saving/restoring system counters is plagued with
temporal issues. On x86, we migrate the guest's system counter by-value
through the respective guest's IA32_TSC value. Restoring system counters
by-value is brittle as the state is not idempotent: the host system
counter is still oscillating between the attempted save and restore.
Furthermore, VMMs may wish to transparently live migrate guest VMs,
meaning that they include the elapsed time due to live migration blackout
in the guest system counter view. The VMM thread could be preempted for
any number of reasons (scheduler, L0 hypervisor under nested) between the
time that it calculates the desired guest counter value and when
KVM actually sets this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of the TSC offset.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in a new device attribute. This
series introduces new vCPU device attributes to provide userspace access
to the vCPU's system counter offset.

Patch 1 addresses a possible race in KVM_GET_CLOCK where
use_master_clock is read outside of the pvclock_gtod_sync_lock.

Patch 2 is a cleanup, moving the implementation of KVM_{GET,SET}_CLOCK
into helper methods.

Patch 3 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patches 4-5 are some preparatory changes for exposing the TSC offset to
userspace. Patch 6 provides a vCPU attribute to provide userspace access
to the TSC offset.

This series was tested with the new KVM selftests for the KVM clock and
system counter offset controls on Haswell hardware. Note that these
tests are mailed as a separate series due to the dependencies in both
x86 and arm64.

Applies cleanly to kvm/queue.

Parent commit: a3e0b8bd99ab ("KVM: MMU: change tracepoints arguments to kvm_page_fault")

v6: https://lore.kernel.org/r/20210804085819.846610-1-oupton@google.com

v6 -> v7:
 - Separated x86, arm64, and selftests into different series
 - Rebased on top of kvm/queue

Oliver Upton (6):
  KVM: x86: Fix potential race in KVM_GET_CLOCK
  KVM: x86: Create helper methods for KVM_{GET,SET}_CLOCK ioctls
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Take the pvclock sync lock behind the tsc_write_lock
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace

 Documentation/virt/kvm/api.rst          |  42 ++-
 Documentation/virt/kvm/devices/vcpu.rst |  57 ++++
 Documentation/virt/kvm/locking.rst      |  11 +
 arch/x86/include/asm/kvm_host.h         |   4 +
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 362 +++++++++++++++++-------
 include/uapi/linux/kvm.h                |   7 +-
 7 files changed, 378 insertions(+), 109 deletions(-)

-- 
2.33.0.rc1.237.g0d66db33f3-goog

