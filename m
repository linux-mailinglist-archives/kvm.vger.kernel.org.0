Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38723F4E54
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhHWQ2s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhHWQ2r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 12:28:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D8DC061757
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:28:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso16978210ybq.10
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 09:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=z+nmbEdHjJd9kCl6ax0Qt0CR58EnkRjNbiq5PgrCWGo=;
        b=DamFGB1rYZZZIH5F92NKEYjruMrxbCl3hxTpuSGonrRna9NxtFkBeIPQ3tFA+GAFBi
         q91n+XJbWFdA+fWuBheP0zIm1xyHOYlKDBwkPYsPAs3ftWqcDX+MJPXYV9UkdzvN0Evg
         710XbQ8U50pOF9bfZ7U4+5h8s++8gkj6KwUoMaDaqxt9NUKMuuo/ByL58nK1gWb/ZkH4
         Pf2/WvCbjPYL+uZ47JtW9M/z6T+cmEnB/rrEPbyWj1E91UxM0GrMQzGMTzDS9EoXa17O
         QUxYucs3K+ZelvmRnXYMYpfZURekWMBMBXnObnPV7iz+6srs92Au2RS09SdgqJY4nMM3
         dgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=z+nmbEdHjJd9kCl6ax0Qt0CR58EnkRjNbiq5PgrCWGo=;
        b=V6qgUkiuGgiPzKi9kSNAyFxLJ80yDpeka0/HG3m7Y5JED5y+9VHxIjYDDDdpAcvgcx
         BQlVZ2DFIGch872Py11fWwWm+3OUmyGwfgp9JKoK51rcPaMYy+io13GaAhlZ13h+cWAO
         xUnOryG6Ujm0uBBs0NhNjHhuiiMKQe/taqBj356YD3dzAIkCVgRUrRYD5vmrXeJD1PWP
         ewxVzmXWYe+MUtYw0EuOHBm0OiR8ryfz0k6/M+Qh9F3Dh9NrcKvStDYbzrXX4uUBJuYZ
         ZFTgCxK35Yjg6F8evY0/5I6FoJmAumjU/vuegC5Mv5LPi/5VlAkd+iDx6p07+hkgISk9
         jVPQ==
X-Gm-Message-State: AOAM530uV+0/fnZURIjak09nfPzYIa9duRFzGWAKcSSFpxgxZKcQ8GOc
        CQUAspaDSc99QvNG533iRIsUi4klN1GM/ZaBKSjIHzDY91GkOuntjb4tAJrCOG7LANV0I/ujyeW
        HpLAGnUZTjHDP/i9ZtLnX3gIHl9JDAa+AuKA46Pr0ONwodO41Wxx2AdA4vA==
X-Google-Smtp-Source: ABdhPJyhfHeKjR8LCIk/k28mtAfHMcEdeghJNNVx89KO4FaM3RhrkM4UKxEvsjsRhKYb0GX2rKW8a+Ro7B4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:672c:389d:3532:4d07])
 (user=pgonda job=sendgmr) by 2002:a25:8445:: with SMTP id r5mr46481398ybm.20.1629736083841;
 Mon, 23 Aug 2021 09:28:03 -0700 (PDT)
Date:   Mon, 23 Aug 2021 09:27:54 -0700
Message-Id: <20210823162756.2686856-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 0/2 V5] Add AMD SEV and SEV-ES intra host migration support
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
2.33.0.rc2.250.ged5fa647cd-goog

