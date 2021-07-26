Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB0673D67AE
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhGZTJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 15:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZTJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 15:09:53 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60D2C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id v2-20020a17090ac902b0290176b4310aaeso328136pjt.2
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 12:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=stBYlnl0prGrJgTrhDLoW6+eKRnCayRzpy3Yob11L/M=;
        b=ChimdB2fLyoqnmZVX7sJFdNUOC+HhTMpVmSt6LMSTbZ+nWbIqPOZhj7aqVxqmdzR+V
         GTE7w7WKktOkyU1V83bBg/f/Rdw4K3nWJSGg+sBpNOZnR5qIvrY5/+BnvtrRfH0+OB67
         8rPZ8D0Eqvc9ews/yVcm0Xdyhg2bGoS2uRfrzT0rwy+if0x9Xk5F8diPGLTomf2ioD3g
         Zg0d/+G0OJfJ2GNVrFyhp7woJny1IpB4uUdVOADZ4ajE0+yOku90ZJsfdbJaGRaoOzo8
         g/JzphPZ9cl5TEdE4yZv0RtOJvWISslJ3SLHKBn6cy32RAGZxwqZXRsUkT6vojJPm45W
         PrZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=stBYlnl0prGrJgTrhDLoW6+eKRnCayRzpy3Yob11L/M=;
        b=BQ899ZvQRUYmGfOD7Q8VK1EUKkN6yzM10dJ/WwDmMeuZulIC74fT8fsyTV6X2gffQB
         VGbFM6wZzQjhKcRzpkjMK9UZxBz8LTIodnL2wL+tMg2BB1nGBoBJyLcj800Q9pR9kMDF
         s0fPVz7RGH9SM6T6w94VB62HWr7140WFbk7cr2Xww3+T+2ZPoS3ibF7XTkCEGvYANXhj
         ZzW+KFK9/+LvilhP3KTs5yuvAQJnJdbSviDx1V7ON3NRlT/H326pfBU3pf3HoxoWjSHe
         5YWdBwOO/Nv91kzkcVAWJOkKdmQ2SbOfqTLcyum9R6Ic2BZVoCxQxcTPafJnrasXVY9y
         8rzw==
X-Gm-Message-State: AOAM531O7m4so/Oo6IO2F1COEVyGFkiGgj/HYFJ2W5WDc5pA/AEcpKx8
        Zxth01PQl/107xPjmnx+jxJhj5j5iaUX6wsFCeY7OoLbDND76ghxMsyEm1nwm18/333wJvULGXX
        IrQA82JP/sozjH8OI3dWuQP7j8rMEZ4E3ZmRd6TSGt0fnbVb4nuQQgwkjJw==
X-Google-Smtp-Source: ABdhPJxlgvQpw77mLA9t1UYeqQbSKYbh2M+3zz6aX/OEh9eABjPzrMxhDp6LjW695qdW9fhqGu+MkYiG1Hg=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:f4a:330f:115:e2d4])
 (user=pgonda job=sendgmr) by 2002:a17:90a:c8b:: with SMTP id
 v11mr588912pja.114.1627329020912; Mon, 26 Jul 2021 12:50:20 -0700 (PDT)
Date:   Mon, 26 Jul 2021 12:50:12 -0700
Message-Id: <20210726195015.2106033-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 0/3 V3] Add AMD SEV and SEV-ES intra host migration support
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

Intra host migration provides a low-cost mechanism for userspace VMM upgrades.
It is an alternative to traditional (i.e., remote) live migration. Whereas
remote migration handles move a guest to a new host, intra host migration only
handles moving a guest to a new userspace VMM within a host.  This can be
used to update, rollback, change flags of the VMM, etc. The lower cost
compared to live migration comes from the fact that the guest's memory does
not need to be copied between processes. A handle to the guest memory
simply gets passed to the new VMM, this could be done via using /dev/shm
with share=on or similar feature.

The guest state can be transferred from an old VMM to a new VMM as follows:
1. Export guest state from KVM to the old user-space VMM via a getter
user-space/kernel API 2. Transfer guest state from old VMM to new VMM via
IPC communication 3. Import guest state into KVM from the new user-space
VMM via a setter user-space/kernel API VMMs by exporting from KVM using
getters, sending that data to the new VMM, then setting it again in KVM.

In the common case for intra host migration, we can rely on the normal ioctls
for passing data from one VMM to the next. SEV, SEV-ES, and other
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

During the intra host send operation the SEV required metadata, the guest's
ASID is loaded into a kvm wide hashmap keyed by a value given by
userspace. This allows the userspace VMM to pass the key to the target
VMM. Then on intra host receive the target VMM can be loaded with the
metadata from the hashmap.

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

Peter Gonda (3):
  KVM, SEV: Refactor out function for unregistering encrypted regions
  KVM, SEV: Add support for SEV intra host migration
  KVM, SEV: Add support for SEV-ES intra host migration

 .../virt/kvm/amd-memory-encryption.rst        |  43 ++
 arch/x86/kvm/svm/sev.c                        | 396 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  12 +
 4 files changed, 433 insertions(+), 19 deletions(-)

base-commit: 7caa04b36f20

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
2.32.0.93.g670b81a890-goog

