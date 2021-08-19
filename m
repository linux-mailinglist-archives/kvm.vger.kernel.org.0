Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8507B3F1D45
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 17:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240619AbhHSPtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbhHSPtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 11:49:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD56CC061756
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 08:49:14 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 11-20020a63040b0000b029023af03ea119so3655805pge.0
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 08:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=06xCCfeaDxwheq8VhlMKBbnaHCeiAJzMnFNIfyATnu0=;
        b=s7az7JI8GVaX8Owd7nc9lURKMIYeL6ZASEWKYW5SpoNi8JEXhQKu9qiI5q/1BFyfmK
         DxMjXJcry+Of8Wy3fwTkTHQIYeBNNLPW1dr/0TJqtbE9rkPp3iofwYeEh1jiwCOdgl7p
         GVv7a+QtavFRbqLE1qz+vpAClBDsLKMHe71+bBQoQlMEm9/QCHYRS8wT23sizWziYIhu
         uIJFdkSKhWm5pS0a8v2MlRMxezBK3ZKTDGASvkUMGbGm6Ms0PZOYMrqVBcLiSUJlUdlS
         kjWLD9b4tN1BzH+RPHeBEkxeRKsrlTEvfncRhKHPqB4zVczSk5s/cI4ZaW1Gn4aOOFqv
         LcGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=06xCCfeaDxwheq8VhlMKBbnaHCeiAJzMnFNIfyATnu0=;
        b=hOpv7ETHLe4ea+LdTkjA6W9ShrOC+bbZ6o6Hz8Zdefd/BqIsS5qaCHbvvbPvHtKBvU
         GZmNBGhxsLg3J4TLNGDizkDJZRjiXi5QsTDjDbY98R+SdZytOLUEUjxz1puTA9ApCawm
         GmrEDWQvKmUXk0WizG2nqU89sKBmuYaEDIOUzqDURGi5c0FsVgqqqiGp6ENkGfutaEHc
         hWSxJB/GneU9Es6xPbdci/iG93Rd0xlTSlWT/WT25T3br4ZKNONCPmu8MpdsV66Z8Kht
         zId9/aRCq9fDvAXylNeXREuWZd1H1F70CjtynuJENhNyPjqyh8X2o+OiS7Dwsq+OfrpY
         VQDg==
X-Gm-Message-State: AOAM5325OnAfZkqPiGF9TlDB4ouhc0ogzIjAFjyf7liXEHXzE7tC7mmN
        oLhFAFudql2hFDejC1TmbXbRjKzm2YkXz8xJCfcQbIvzycuG3oC1rziRxA5FyjB8/BdO745K4od
        NMp282qsvRL+18tj3JTPbibtasAmhAsnw11XiSbkTx4wqkxVCFxOVdkTalw==
X-Google-Smtp-Source: ABdhPJxfxyVOalqYvQvTh6+f5mlJ/77VclV8r29FH/fSnyOzRashtzzvkLjktIFmYN2vR6hr25SyW2MsxSc=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:6cf4:9d41:7258:8536])
 (user=pgonda job=sendgmr) by 2002:a17:90a:db96:: with SMTP id
 h22mr16031244pjv.212.1629388154249; Thu, 19 Aug 2021 08:49:14 -0700 (PDT)
Date:   Thu, 19 Aug 2021 08:49:08 -0700
Message-Id: <20210819154910.1064090-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 0/2 V4] Add AMD SEV and SEV-ES intra host migration support
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
 arch/x86/kvm/svm/sev.c          | 160 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/svm/svm.h          |   3 +
 arch/x86/kvm/x86.c              |   5 +
 include/uapi/linux/kvm.h        |   1 +
 7 files changed, 186 insertions(+)

base-commit: a3e0b8bd99ab

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
2.33.0.rc1.237.g0d66db33f3-goog

