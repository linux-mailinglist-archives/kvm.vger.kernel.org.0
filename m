Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6D42AE26
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 22:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhJLUvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 16:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhJLUvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 16:51:05 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94271C061745
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:03 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s20-20020a05620a0bd400b0045e893f2ed8so228562qki.11
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=teEEhVWJN+Qa6H6Qk1wKq131PVGwnj7NNqky10GsyoI=;
        b=OiGTRrzaxSz0x5HSUuTg4hDTD/OeCBAaD/mWV8UZ8XyjJG/gdgfKyZcn0SQPwisM+h
         fXqoflM2sv0pCaZUKFh6qXeNq3Vd+aNA3I0J0Q2TL1yC4iw4fc25ZGn1XbPKhRO9rKLV
         eLlEt/S+g02f1ZSqsow1cq5Ce6FY2ZhJzliLWojrXbuSpDTC7Y/AAlvthgYohIzgl7X3
         KR4tLcEk8wR1f+i93CD2P3zvLCZhqQGopG9tAh/QCC78f2zvgC0nWq3+WTQZ5OpxY5LS
         cctPwwBnkZ+h0SJW5XJWeYRFEcD1IPUnuuToF19ElOm8dOhe/7me0v5RLB267vWGMCf6
         pJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=teEEhVWJN+Qa6H6Qk1wKq131PVGwnj7NNqky10GsyoI=;
        b=Oe0W6Wn6NB9d6A+xpgfawnRMzoV0Etg2vnaKpBMHmoNbChv3tfqe7rvxwiSpgo86A5
         1K3+fny1+ka8S7uNP/hD1d0hhZfvnQh1lFWh4fWpyIprlB4Cb5Xftyz6IFBjH4Mxo682
         0g9Ytj/fVNWIwvcLDfe03Xn2wUMfQyW2gDtv0vtV19EONATUcxd4KDcLqLU/KSi1zJ1n
         Rfg4q0p94SFyG63HV8EITJ9jNtQDf5oTkmUupgETvcRmQESOA7l9R5vAM5F1Ibm2uq67
         D0+Y+KseeOYkOfg7NBcKyyN3sFN/z4Nv4I3iSsB87b9sohEaG/EIjGr4jfdXV2daoV0X
         Dwqg==
X-Gm-Message-State: AOAM530366F3tVfFKbdWIRYbMmAsBaXLrmztxPAtqqP3uW37tqRCrK4J
        VPAkBTLslaho3TQmRV3itBFGrKpgmPAjSc5vGQPED/rDXGChPxcKJzS4GE3lCxp0sp+bJznjwTS
        rUeR/Mm3+epPXnprwuqN66UjbHEhC5t5Bk+K9uZ8you4zvJZeEwetki9a1Q==
X-Google-Smtp-Source: ABdhPJxFeI5OJl1z1+FmDrAXsT2HYKR4TceIvtLx4TbVTlU8OdQG/KZr0T4g+ZTxK0Y9ntVAQXi3xx+NCTw=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:bab5:e2c:2623:d2f8])
 (user=pgonda job=sendgmr) by 2002:ac8:5e14:: with SMTP id h20mr24196018qtx.364.1634071742702;
 Tue, 12 Oct 2021 13:49:02 -0700 (PDT)
Date:   Tue, 12 Oct 2021 13:48:53 -0700
Message-Id: <20211012204858.3614961-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 0/5 V10] Add AMD SEV and SEV-ES intra host migration support
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

base-commit: 2acbc5c9a0ec

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
 arch/x86/kvm/svm/sev.c                        | 264 +++++++++++++++---
 arch/x86/kvm/svm/svm.c                        |   9 +-
 arch/x86/kvm/svm/svm.h                        |  28 +-
 arch/x86/kvm/x86.c                            |   6 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  24 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 ++++++++++++++
 13 files changed, 504 insertions(+), 66 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

-- 
2.33.0.882.g93a45727a2-goog

