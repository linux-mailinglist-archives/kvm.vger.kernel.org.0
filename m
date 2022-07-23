Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7774657EAB6
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiGWAvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiGWAvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41907101F3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d10-20020a170902ceca00b0016bea2dc145so3410557plg.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ys0GEGydU2uam+ngTo0juEJ4Yk0g/q5LIx8twKFbkvo=;
        b=eoJyzr4WnjHgJiPyv/j3LYAggu5KZ6mgGOSC+8DjGmkVg0ZQkSGqMkngQAsl8GQHTr
         Qh63sE0ukJVkRBYSl1oDORksOiGHnIi5eQENeRmJinEEuLjBaEI6r9dEA/EKh7Yc1H+K
         xhWMHn0IWuzmRzpqZycznbL9BKA5rUA6vdplBVkslg0hQg4V3FAd1Wv9vxSstOCwGA3i
         Cj1F1sHHFfRW5gvCdjiVCBA9Cn9SbjZX83685VAfn5cl1C6akRPsXB89IaxNM3wm5KZd
         g2IOqE4EblmvV+cFSC62c5SEdZDVsDLWRhwaQlAcpdtZxqfXm9b/efZ1I07zg85s3Yy2
         b53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ys0GEGydU2uam+ngTo0juEJ4Yk0g/q5LIx8twKFbkvo=;
        b=POvj3CH7A/8yz00/N4KfWpVyqPUEONcP1ir05+PmgV/H/hQJ2z5/+Dqs9GgqwoKdeM
         7rBf5RtLF+CgDB/IZIjy2iUnKNW+gWuynZYSqdCEBCjQtwmpMHSMBBDEAh0jjp80EwFt
         6vST+iXSVMczFzNxrspra+l6SYGM+Ny2oQGsKbgHfo5CJwEYmiKvhDrYZmhVtz3qjRFH
         9pbx7zxak6cd/HREjKGd7UQMq7ykOUaytNXIlDnvy7rXms3R2BBp1QcHYkkZQ958n/gk
         5a/LE/teIajbZ8AF37FWneM9C47P//rZ9VJ7+ncPENnVFm3BHSIOYl45BSWhn3UdAh9/
         +yaw==
X-Gm-Message-State: AJIora+UsmBAshFpTgrIuocCoURutjnj5oT3SD9qQAEkBdLjLpbrexkV
        fEFuC6V6IhpKU0hcHwUrXLG3uw8IAQ4=
X-Google-Smtp-Source: AGRyM1sNSto+k2nljue71DnqV97d9qArsGrPWIPo3Wa8vvX1skLmXUMNbkt7w98ictKfa8YZGCclE5ggSYg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr1127906pje.0.1658537502542; Fri, 22 Jul
 2022 17:51:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:13 +0000
Message-Id: <20220723005137.1649592-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 00/24] KVM: x86: Event/exception fixes and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main goal of this series is to fix KVM's longstanding bug of not
honoring L1's exception intercepts wants when handling an exception that
occurs during delivery of a different exception.  E.g. if L0 and L1 are
using shadow paging, and L2 hits a #PF, and then hits another #PF while
vectoring the first #PF due to _L1_ not having a shadow page for the IDT,
KVM needs to check L1's intercepts before morphing the #PF => #PF => #DF
so that the #PF is routed to L1, not injected into L2 as a #DF.

nVMX has hacked around the bug for years by overriding the #PF injector
for shadow paging to go straight to VM-Exit, and nSVM has started doing
the same.  The hacks mostly work, but they're incomplete, confusing, and
lead to other hacky code, e.g. bailing from the emulator because #PF
injection forced a VM-Exit and suddenly KVM is back in L1.

v4:
 - Collect reviews. [Maxim]
 - Fix a bug where an intermediate patch dropped the async #PF token
   and used a stale payload. [Maxim]
 - Tweak comments to call out that AMD CPUs generate error codes with
   bits 31:16 != 0. [Maxim]

v3:
 - https://lore.kernel.org/all/20220715204226.3655170-1-seanjc@google.com
 - Collect reviews. [Maxim, Jim]
 - Split a few patches into more consumable chunks. [Maxim]
 - Document that KVM doesn't correctly handle SMI+MTF (or SMI priority). [Maxim]
 - Add comment to document the instruction boundary (event window) aspect
   of block_nested_events. [Maxim]
 - Add a patch to rename inject_pending_events() and add a comment to
   document KVM's not-quite-architecturally-correct handing of instruction
   boundaries and asynchronous events. [Maxim]

v2:
  - https://lore.kernel.org/all/20220614204730.3359543-1-seanjc@google.com
  - Rebased to kvm/queue (commit 8baacf67c76c) + selftests CPUID
    overhaul.
    https://lore.kernel.org/all/20220614200707.3315957-1-seanjc@google.com
  - Treat KVM_REQ_TRIPLE_FAULT as a pending exception.

v1: https://lore.kernel.org/all/20220614204730.3359543-1-seanjc@google.com

Sean Christopherson (24):
  KVM: nVMX: Unconditionally purge queued/injected events on nested
    "exit"
  KVM: VMX: Drop bits 31:16 when shoving exception error code into VMCS
  KVM: x86: Don't check for code breakpoints when emulating on exception
  KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
  KVM: nVMX: Prioritize TSS T-flag #DBs over Monitor Trap Flag
  KVM: x86: Treat #DBs from the emulator as fault-like (code and
    DR7.GD=1)
  KVM: x86: Use DR7_GD macro instead of open coding check in emulator
  KVM: nVMX: Ignore SIPI that arrives in L2 when vCPU is not in WFS
  KVM: nVMX: Unconditionally clear mtf_pending on nested VM-Exit
  KVM: VMX: Inject #PF on ENCLS as "emulated" #PF
  KVM: x86: Rename kvm_x86_ops.queue_exception to inject_exception
  KVM: x86: Make kvm_queued_exception a properly named, visible struct
  KVM: x86: Formalize blocking of nested pending exceptions
  KVM: x86: Use kvm_queue_exception_e() to queue #DF
  KVM: x86: Hoist nested event checks above event injection logic
  KVM: x86: Evaluate ability to inject SMI/NMI/IRQ after potential
    VM-Exit
  KVM: nVMX: Add a helper to identify low-priority #DB traps
  KVM: nVMX: Document priority of all known events on Intel CPUs
  KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
  KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
  KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
    behavior
  KVM: x86: Rename inject_pending_events() to
    kvm_check_and_inject_events()
  KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
  KVM: selftests: Add an x86-only test to verify nested exception
    queueing

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  35 +-
 arch/x86/kvm/emulate.c                        |   3 +-
 arch/x86/kvm/svm/nested.c                     | 110 ++---
 arch/x86/kvm/svm/svm.c                        |  20 +-
 arch/x86/kvm/vmx/nested.c                     | 331 ++++++++-----
 arch/x86/kvm/vmx/sgx.c                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  54 ++-
 arch/x86/kvm/x86.c                            | 450 ++++++++++++------
 arch/x86/kvm/x86.h                            |  11 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  51 +-
 .../kvm/x86_64/nested_exceptions_test.c       | 295 ++++++++++++
 15 files changed, 953 insertions(+), 420 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c


base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.359.gd136c6c3e2-goog

