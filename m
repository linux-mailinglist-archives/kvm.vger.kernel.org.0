Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597E357684D
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGOUmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGOUmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:35 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB965B04F
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:34 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e11-20020a17090301cb00b0016c3375abd3so2570929plh.3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=I/QtSIUAt/ll33VekTJLh62H8IcuJ8z6tut6BxZsMlM=;
        b=fyGq4PDW6nNQF4AgVR2GWsJutzb8REI7X30M+jAdJvMXKIiLqLV5+41RoSH2TGMyke
         In+cj7mPYK0r2awY7X/evjcY1kdNfY5xPXJX6mKoMWvW0p4NbdxM4tS3pqpygfvoilha
         niWGT/MtkjgADD6uIh8CZcOLymPLPPYO+HH5SnFUYjuDVL7HF3fRUMp600ZRo64UzB3e
         jYHhdk8F3/6eRvz9JbkcvSpg3wg1t3jEsVc/NV7alHZUvcf59/mzzwHxk8lHlKbElHUG
         XrjEh9gsJNP8BGFl6FJs6w8e1tPTPfWlWQ29EuF9fElc/jZ3mhk9iZVa8yPXnhaWavgs
         YCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=I/QtSIUAt/ll33VekTJLh62H8IcuJ8z6tut6BxZsMlM=;
        b=DE5iZzkWCBdEoOSieOe8XDb3fTvu6VtjTRcEH7AEHUxXseljtUlMQ0j8YW5vTe4w+i
         92IgwGqjemH+DnBDHOdIHuW1NAuLyGehiWyAgIBMyBRoxgfJiatKp2BmXphov/HG2J//
         kUMM22tqkNFwNIvhHJmkc04Ec152VfpTNZ4jx+NLL1//8I1KgREu8LD74sJWupnJHzsx
         fWdfyDh4FJab75hj5zfCXbZSxC29MjOhnXwWBkZ/Os/YJg+dn/T4V2LiGKcdaXNijm19
         eOeXzcfV2LVMCZxx8tvCrvnzxeHk6SHcnot1NxQNDMbH+7PcDTjmPS/39oWu9UsjKAOa
         z6Dw==
X-Gm-Message-State: AJIora+iLgf30XI2/DkkS8VfxIgii/0u6DSqjOWpeR7K4kAwny6WgckZ
        jeEWG6iH3nLbIOZH/0XP5rwLlcFDO30=
X-Google-Smtp-Source: AGRyM1sFgmYzLtmfKLJLV5nfuc4k+8wI40y5q4ho5M0nFm/EHMVCPOr80cRtiKWNrD4WZI42WiPdfLuL+9Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f8ce:b0:1ef:798c:ae03 with SMTP id
 l14-20020a17090af8ce00b001ef798cae03mr24290306pjd.8.1657917754552; Fri, 15
 Jul 2022 13:42:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:02 +0000
Message-Id: <20220715204226.3655170-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 00/24] KVM: x86: Event/exception fixes and cleanups
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

Maxim, I believe I addressed all of your comments, holler if I missed
something.

v2:
 - Collect reviews. [Maxim, Jim]
 - Split a few patches into more consumable chunks. [Maxim]
 - Document that KVM doesn't correctly handle SMI+MTF (or SMI priority). [Maxim]
 - Add comment to document the instruction boundary (event window) aspect
   of block_nested_events. [Maxim]
 - Add a patch to rename inject_pending_events() and add a comment to
   document KVM's not-quite-architecturally-correct handing of instruction
   boundaries and asynchronous events. [Maxim]

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
 arch/x86/kvm/vmx/nested.c                     | 329 ++++++++-----
 arch/x86/kvm/vmx/sgx.c                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  53 ++-
 arch/x86/kvm/x86.c                            | 450 ++++++++++++------
 arch/x86/kvm/x86.h                            |  11 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  51 +-
 .../kvm/x86_64/nested_exceptions_test.c       | 295 ++++++++++++
 15 files changed, 950 insertions(+), 420 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c


base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
-- 
2.37.0.170.g444d1eabd0-goog

