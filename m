Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB90436997
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhJURre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbhJURqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:46:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9FCC0432C4
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:07 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y41-20020a056a00182900b0044d43d31f20so811352pfa.11
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=iURUGf0w78yycZlu3miQkJiEIuDMDSn6yRxhCauMXZs=;
        b=FYDdF7PwrythipcCGhs6ak63WyihVhH3l9X3Mdqn78QcJkg71mr/Yb5C5rXAxakXf+
         XjQDJngrHupRI+gfUqt52vbengOSjCZlNM7D/0PW77dJpdQrUVjxZFTZz+8ynEzMmI11
         lss2UFhFeBB+TubSLlFEIAfwE1fFnWDmRzLF31D2RW30W41849OY6XUO5eVcczFVfOwC
         CuV+jHxy7l9mp4hg81m6Mdnm8Gy0/whoZnjhZcDsi+cJPxtuTXAcZ1ob0ZgXqAbd5Dhn
         lOcCfc4rubjMWfsKNJ0OA1p8VDc86P3N+pWanZ8d/xJAW3uWEG/iIrLyXlFFlxIp4iy4
         O+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=iURUGf0w78yycZlu3miQkJiEIuDMDSn6yRxhCauMXZs=;
        b=ImEmj+M/16ynZuuxJNKD7VXNG4PkKdVkr8KIzzthHpiAgTKy6jTaCyY8X/MLhssm7j
         gP15DOVht27fFnpel/xPQfd5xClH18sqDXK2u72DZgnt/JrjHRmUjfWO7maZiG31qCxw
         Lgao6Ko/QN1ZVikL2D6wQ3+81UxNxmrqFByuAAlTnskrt+NokMO15ocUqVWQxEY65kPO
         xcSAmjWjMPGC29iBfIa/EDQ0b7yYyRLoG2G1NhePOCh4AFAHnFP1qpBE1E52dAe4yEtQ
         U9Xv7udOi54i1vLHmEejrlmMBpRZBX5kdNiTOvrU7SOuVAdtnh2URiRWehZ2K6Fu8E5z
         VZsg==
X-Gm-Message-State: AOAM531Y+YDoclmaPFXjegYIQrbRvZbCEyMmrnoqkt2CyKkTrIJLUs1n
        Dvx+sOsKrQ8zs/IOpSEu4O5D/FF0IyU0mKVUd4fjk2AYqsY4FuDv6BxTaGqnjB7sN1NTAkKltWm
        8PMC5FAQtlU6BormG+05auFIYL0lG19mLAl0b8PmH6Zxh2e8aE2gNGV4sDQ==
X-Google-Smtp-Source: ABdhPJyMsl4iJVNkTTIHy24KxkXOwmEW/9BwIrkTf9rMmQN6v8My2o0LjnHen5hB3Vit/wgdP/hgU7lPATE=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:da2d:dcb2:6:add9])
 (user=pgonda job=sendgmr) by 2002:a63:7b4a:: with SMTP id k10mr5515192pgn.301.1634838186675;
 Thu, 21 Oct 2021 10:43:06 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:42:58 -0700
Message-Id: <20211021174303.385706-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 0/5 V11] Add AMD SEV and SEV-ES intra host migration support
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intra host migration provides a low-cost mechanism for userspace VMM
upgrades.  It is an alternative to traditional (i.e., remote) live
migration. Whereas remote migration handles moving a guest to a new host,
intra host migration only handles moving a guest to a new userspace VMM
within a host.  This can be used to update, rollback, change flags of the
VMM, etc. The lower cost compared to live migration comes from the fact
that the guest's memory does not need to be copied between processes. A
handle to the guest memory simply gets passed to the new VMM, this could
be done via /dev/shm with share=on or similar feature.

The guest state can be transferred from an old VMM to a new VMM as follows:
1. Export guest state from KVM to the old user-space VMM via a getter
user-space/kernel API 2. Transfer guest state from old VMM to new VMM via
IPC communication 3. Import guest state into KVM from the new user-space
VMM via a setter user-space/kernel API VMMs by exporting from KVM using
getters, sending that data to the new VMM, then setting it again in KVM.

In the common case for intra host migration, we can rely on the normal
ioctls for passing data from one VMM to the next. SEV, SEV-ES, and other
confidential compute environments make most of this information opaque, and
render KVM ioctls such as "KVM_GET_REGS" irrelevant.  As a result, we need
the ability to pass this opaque metadata from one VMM to the next. The
easiest way to do this is to leave this data in the kernel, and transfer
ownership of the metadata from one KVM VM (or vCPU) to the next. For
example, we need to move the SEV enabled ASID, VMSAs, and GHCB metadata
from one VMM to the next.  In general, we need to be able to hand off any
data that would be unsafe/impossible for the kernel to hand directly to
userspace (and cannot be reproduced using data that can be handed safely to
userspace).

V11
 * Zero SEV-ES vCPU state on source.
 * Rebase onto SEV-ES fixes.

V10
 * Add new starting patch to refactor all SEV-ES related vCPU data into
   for easier copying.

V9
 * Fix sev_lock_vcpus_for_migration from unlocking the vCPU mutex it
   failed to unlock.

V8
 * Update to require that @dst is not SEV or SEV-ES enabled.
 * Address selftest feedback.

V7
 * Address selftest feedback.

V6
 * Add selftest.

V5:
 * Fix up locking scheme
 * Address marcorr@ comments.

V4:
 * Move to seanjc@'s suggestion of source VM FD based single ioctl design.

v3:
 * Fix memory leak found by dan.carpenter@

v2:
 * Added marcorr@ reviewed by tag
 * Renamed function introduced in 1/3
 * Edited with seanjc@'s review comments
 ** Cleaned up WARN usage
 ** Userspace makes random token now
 * Edited with brijesh.singh@'s review comments
 ** Checks for different LAUNCH_* states in send function

v1: https://lore.kernel.org/kvm/20210621163118.1040170-1-pgonda@google.com/

base-commit: 9f1ee7b169af

Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Peter Gonda (5):
  Refactor out sev_es_state struct
  KVM: SEV: Add support for SEV intra host migration
  KVM: SEV: Add support for SEV-ES intra host migration
  selftest: KVM: Add open sev dev helper
  selftest: KVM: Add intra host migration tests

 Documentation/virt/kvm/api.rst                |  15 +
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/sev.c                        | 268 +++++++++++++++---
 arch/x86/kvm/svm/svm.c                        |   9 +-
 arch/x86/kvm/svm/svm.h                        |  28 +-
 arch/x86/kvm/x86.c                            |   6 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  24 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 +++++++++++++
 13 files changed, 507 insertions(+), 67 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

-- 
2.33.0.1079.g6e70778dc9-goog

