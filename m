Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ABB40B538
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhINQsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhINQst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:48:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33CDC061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:31 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e2-20020a17090301c200b0013b8b16c22cso2609552plh.5
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZlkIDsFBSERm/Xbx3Ggd03CqQdqQbhahkeWLgMh2nug=;
        b=AEjRWP+lD/D5q9exkYWG+QxaG03/J156jSXYDhoyQGVcNjoLONBxPwXyn15Pqw2sgT
         USFgJx4v+B3SOKGRmvDCEH5fJucy0NfisIHBinP3+VWp16Us041hvFMEqWyXqvskMpaA
         2qSsPhKMzTr+dovtd2sMCAOqQ035xJnunLq2HLyb8D1pnLdReIn2beODwLrIONtJaxks
         caOP2CR4UKbkhLJJ56Z+LQegVzhBBFaGjpJaaOdq7/eKDlhjWhrkoY55jH5n2KZxO9wX
         GF/lsiXhxiX/LQnJNbuLF6rLXxe3HagGylMT9znXfAwwhN8Ksb7bVaMrj8AJF1sH2YSF
         MwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZlkIDsFBSERm/Xbx3Ggd03CqQdqQbhahkeWLgMh2nug=;
        b=JnK0b0xKGigS2kEjFM2KtDqaRipwQMl3gBSuApVlQWHfSqVhHkRrOaLTXgSkq6gJ7v
         t87rWfuFdcI3hqaSbEsQnWFXrIsOoORIsrdvq1gDCbqpVamjHiGLL5IVqTYCPVSAKJd6
         HXbnBfHioXWjOCTeQf2qt/55y/HXxke/YC8r0N+EsE39RPbvKwIC6StxD2Jxuge81dJP
         2jX88/CkzxvJLjX0jUMtiQ87Debwzf8n2hRe4DuYm5EkhRcTfc8/k0+lSRrxx4zz+tyL
         /1+5+J90jwmIPVmsfqGTRvDIUWgTjjkkLZsrCF2L6FF18eo46wA48qLJnYZlq/ue5q9e
         5X+A==
X-Gm-Message-State: AOAM531Fg5MJ2jXAUuw7b2Yc7ki3jWDadG/2/SmQ5WfBN9sStrXH0mIN
        jm2APYfgecmJZPwFpQVz+HW4DHFNJEPdNxeda31j5OlOlKN0Z/Pyzlsd35Bkv8EkPtW4JsxP/nG
        5OAlXUMqvVodAfRVoOa0qds90u5hZKvU5hNBkDp8rbmjyQ2i2V+dYg9KvTw==
X-Google-Smtp-Source: ABdhPJxP0z3NqxcPYSBvChKyaZ263JWYy3SOY6I1xc5+L47cHHK1bFD1b67xcFV3wDtohpjKV5Zf554sBaA=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a62:7997:0:b0:43d:f9e1:939c with SMTP id
 u145-20020a627997000000b0043df9e1939cmr5102953pfc.2.1631638051037; Tue, 14
 Sep 2021 09:47:31 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:47:23 -0700
Message-Id: <20210914164727.3007031-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 0/4 V8] Add AMD SEV and SEV-ES intra host migration support
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
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

base-commit: 680c7e3be6a3

Cc: Marc Orr <marcorr@google.com>
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

Peter Gonda (4):
  KVM: SEV: Add support for SEV intra host migration
  KVM: SEV: Add support for SEV-ES intra host migration
  selftest: KVM: Add open sev dev helper
  selftest: KVM: Add intra host migration tests

 Documentation/virt/kvm/api.rst                |  15 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/svm/sev.c                        | 187 ++++++++++++++++
 arch/x86/kvm/svm/svm.c                        |   1 +
 arch/x86/kvm/svm/svm.h                        |   2 +
 arch/x86/kvm/x86.c                            |   6 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  24 ++-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  13 ++
 .../selftests/kvm/x86_64/sev_vm_tests.c       | 203 ++++++++++++++++++
 13 files changed, 447 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_vm_tests.c

-- 
2.33.0.309.g3052b89438-goog

