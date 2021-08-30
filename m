Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AC93FBDAB
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 22:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhH3U6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 16:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhH3U6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 16:58:15 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3801C06175F
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:21 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id v33-20020a634821000000b002530e4cca7bso1167306pga.10
        for <kvm@vger.kernel.org>; Mon, 30 Aug 2021 13:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qQlkZxCZKnPJMcE0Oq5p1b0zS1PuedDR0ng2hng3Vck=;
        b=URLkGxYvi4dBsZzh96zP2kS+YcEDsz3DGH6wz7BYGUfXshLjwU1mhGJWiWu2oHYcf4
         WhwdD1CHVOh/yBtaJ7Bx+gDMZyEnqFttVGrHccs8WkSGbmS+QkbCk7FGHP2mwpCoANSW
         Btbg+akgj3u6dioHCLAPaMQhMEQZfY+ambjPjtN6imFnVsDb5hSRPv8513n1YALFO2Q3
         c3xzxgG0It4Wlq4WVkIQssCbhrsnkHiJcdoPlKXaDp4Uyod+7alcbfJ5yyEZXmFcG616
         GhkEQBvh9zmRLVqUXPWGtx9P5/voI2XIZiYlNJby7IqS/HFrRO91Ru3avPdaIqCxgWH3
         ShRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qQlkZxCZKnPJMcE0Oq5p1b0zS1PuedDR0ng2hng3Vck=;
        b=mDig8Php5uPdldsSCpkginOSc3Lag7NYlGVBpDg9bAj19vG/j6EWjSiD0PCD1+5AXG
         zlJH9311iZjtk1ZQY+SfQQXlkVXys1Esyq6KFW4TMTY/2JRNinhQHvT5NTekLzFtPs/X
         Vg8qRovzoEp4w2ytPar4i/I2PHRqtILiKqNS+3SL+oh8TaOCEgyMBdn9/iI2WFiaEyt6
         ntouXkjeFvKjkzbAzp7ipi1cvjewO380WUJ24tZpqDb1kcexXZphuZDi2jFxOSBQ0JtW
         aY/hQ9OIr2aD39PVn2YgDp3r2WuqQZw4TZ+/BRBrR0ML2ncxY7bfmIoMH2KwgYDUtM89
         G9Ag==
X-Gm-Message-State: AOAM533GVfWxvTsJJjhap9H2pUwat4TuUCKmE1CE1IN0of5lST2Ow9HU
        9NPU2Llfs17jc8fCJfsI1pfgzNqWiGnSBV+XpumvzmK+m0MNoEh482AF9X64uq50nwRcyg9W11J
        JPdYPcVEa7FCBg/1AIDgUgkHvX3+HMrd/9Q+8e1FO0FDsaCvNWZ2uTxppZQ==
X-Google-Smtp-Source: ABdhPJy3d63pj/GuNIeIvbohTcbMiChxRm64WcL3v5zRARS2U6xfUqQhkHq05xHNnh0dqQm1+DtipePdDl8=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:e552:6d5e:b69d:968c])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:b4e:b0:3eb:1c8d:d5d8 with SMTP id
 p14-20020a056a000b4e00b003eb1c8dd5d8mr24459675pfo.67.1630357040822; Mon, 30
 Aug 2021 13:57:20 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:57:14 -0700
Message-Id: <20210830205717.3530483-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 0/2 V6] Add AMD SEV and SEV-ES intra host migration support
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
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

For the intra host operation the SEV required metadata, the source VM FD is
sent to the target VMM. The target VMM calls the new cap ioctl with the
source VM FD, KVM then moves all the SEV state to the target VM from the
source VM.

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

Peter Gonda (2):
  KVM, SEV: Add support for SEV intra host migration
  KVM, SEV: Add support for SEV-ES intra host migration

 Documentation/virt/kvm/api.rst  |  15 +++
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/svm/sev.c          | 157 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/svm/svm.h          |   2 +
 arch/x86/kvm/x86.c              |   5 +
 include/uapi/linux/kvm.h        |   1 +
 7 files changed, 182 insertions(+)

base-commit: a3e0b8bd99ab

Peter Gonda (3):
  KVM, SEV: Add support for SEV intra host migration
  KVM, SEV: Add support for SEV-ES intra host migration
  selftesting

 Documentation/virt/kvm/api.rst                |  15 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/sev.c                        | 157 ++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |   1 +
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/x86.c                            |   5 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 152 +++++++++++++++++
 9 files changed, 335 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
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

-- 
2.33.0.259.gc128427fd7-goog

