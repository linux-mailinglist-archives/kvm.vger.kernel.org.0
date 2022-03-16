Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169684DA722
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 01:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352876AbiCPA5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 20:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbiCPA47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 20:56:59 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9AD5DE5E
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:47 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id e23-20020a6b6917000000b006406b9433d6so383291ioc.14
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 17:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7WWXojAi0FcQXJtF2eoNRpWc83KOMfaQ30jynIZqluI=;
        b=hUnTTB6doHu3+VfAAEjSr+4Nj9597dampvdLqKW180QsYRWUI6T2g+lKxO1skVUjgi
         UNHbMwQut0fsPUPLOQjMOJ6qOTT2aBW6brEAswxm/GzjJpVXmCFgqE8YIVpwCBH7wIb5
         rUp1vdQan0lqAhIyseVH4DgufYf32Myl4o9nUs4uQfnVoqMjTwqUcBYrxlDanr7+MPM2
         8SqoXmrbYQvdH9VybN+Fa4FAl5ULJIn/3WvkhWOxXABmfi3UTqJZgMiC8cHZYKKuWsmY
         GKkNGFZ9mfsQrImVB7IvVmr2duTpf47uYXva/QrkL/pHzrJ5dFUZxFKd/SKqgMgUN8lU
         CFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7WWXojAi0FcQXJtF2eoNRpWc83KOMfaQ30jynIZqluI=;
        b=ODiqXhXfsjYPXCb9AdNQexoaLuLEwQ1iSfO2Mn/4sv9qxp+4WVB6tDFV+tslVzDgpt
         UxHD6oZbHUIQKZQYX27yPMTI2YI6g1IhfeXFHaUV633FGXEVa4fbSOpcius9is3qAfRK
         ps0Q1eSr/B2Xe0+pMKb1PO0zAXaU5kec36HXWfejPTP8qqg8T9odcPA+kf/9fRMmla3N
         z9rRsNH5k8gMGY/gj41EjuS4pJuc79tZecdcLWz3n/D8JVSLzPqiozU/P3LDSmIUt1ja
         OLMeKB9k2TXvX/GfgRcv9MK7dqvRmMP+54gu8t7uDFIY4DmLXv2AqLNjU7gK6Pmf/Uh9
         dikw==
X-Gm-Message-State: AOAM532kzYnEHengWY0YkGSo/NnORx9S2tqhT3rr3n7bURDH931pwkZI
        DtsDpfNEAiq4SWztG3Gkd9IwHGJvHH3sdG/dMtY9J/cbUuycjkmGeiSizdElveplyelowxZCGpR
        5NJ2WPbp38qwh3sDSROJ2QA3qPLllFuhU28xFyMvDxHJzn8URMLMBJ+bK0A==
X-Google-Smtp-Source: ABdhPJwB6GUKoTqCu4zierEHOBfWnDbG96NHjMLxcKLr1vkP1Lcbn7U5oXGtRvTXrbeGu9UjCAV52eN/TfQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:ab95:0:b0:317:b245:7901 with SMTP id
 t21-20020a02ab95000000b00317b2457901mr24892235jan.23.1647392145860; Tue, 15
 Mar 2022 17:55:45 -0700 (PDT)
Date:   Wed, 16 Mar 2022 00:55:36 +0000
Message-Id: <20220316005538.2282772-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 0/2] KVM: x86: Allow opt out of guest hypercall patching
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Another interesting behavior of KVM is that it rewrites guest hypercall
instructions when emulated on #UD. So, if a guest uses the wrong
instruction for the vendor its running on, KVM rewrites the guest
instruction to use the correct one (i.e. VMCALL on VMX, VMMCALL on SVM).

While it may not be the end of the world for a non-nested guest that
knows its running on KVM, this is dead wrong in the context of nested
virtualization.

The nested situation could probably be seen as a bug, but I decided to
leave it as is for now in the series since there hasn't been any
complaints about it so far.

This series adds a quirk which allows userspace to opt out of hypercall
rewrites. With the quirk disabled, misbehaved guests will see a #UD
instead.

Applies to kvm/queue at the following commit:

  2ca1ba339ed8 ("KVM: x86: Test case for TSC scaling and offset sync")

Note, the series depends on KVM_CAP_DISABLE_QUIRKS2 which was introduced
in the following commit on kvm/queue:

  3a825326df69 ("KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2")

Tested with the included selftest on an Intel Skylake and AMD Rome
machine.

Oliver Upton (2):
  KVM: x86: Allow userspace to opt out of hypercall patching
  selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN

 Documentation/virt/kvm/api.rst                |   9 +
 arch/x86/include/asm/kvm_host.h               |   3 +-
 arch/x86/include/uapi/asm/kvm.h               |  11 +-
 arch/x86/kvm/x86.c                            |  11 ++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/fix_hypercall_test.c | 170 ++++++++++++++++++
 7 files changed, 200 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c

-- 
2.35.1.723.g4982287a31-goog

