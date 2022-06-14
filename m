Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016AF54BC0F
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbiFNUrq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiFNUri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:47:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E820B1D322
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id c2-20020a25a2c2000000b0066288641421so8549543ybn.14
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=RNfsBnrb019GwwlDncDGa0smr28pomq7mA55AJKJhHI=;
        b=R325LsRZneFNEFs8J6A6K9NT69ICE7hR+z6FsW/5Db9t8H6xLdqgyEpeRzkOBdLCO/
         XQCmFcsCKJt7FSotMJUlI6ZBcOVL9BatykBhuM1yBHYmz3ZilAF4/D4eC2XkhNHdtAkJ
         scgUUyd4ok2n2uXyg2qcJSVX809jw/dkHJEm8qde54teS95v+M3B8e5rIo/QaVzOtoSv
         Rcqv2Rgt2kvMXuS1BvxVEvuxOy3DwocOX33yLWhfR3rpGcqZcPjMDZCQlgjJYTKE7W54
         rCoffxIBjX7bY2L7ZhgeeEBK/6eTvKCUKnqePEQJHcg9mRv9oHzqhWmq9vLROZhuOVCB
         S3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=RNfsBnrb019GwwlDncDGa0smr28pomq7mA55AJKJhHI=;
        b=X8dm3ZY0V+oFsRd+IlxHo2stkOTZ2oEh7VfZKcTfP+mNjoJPKXmq7j1ZNGGsw7eM6t
         30bq5WNGzeHYdvepvyVUnEoNnz1L+cRIP5fspOGcB/D+LbBr9LPknF5CsR44j0TSKKJN
         +lVDyHnpp6/ijyuZ3xIKuxrAhqxJImduJ4SokCJ7/w7uT6+RI0ozatGJfriGeC4rOrmF
         vbqjlcC9eu4m8wlHxE8j28bcOUVA6l8K0krX8ae1HNmIcLzTWJxOkJMfIq7LZ+SZzhQ8
         QhTd6CAdCFIpWwM731eTi/8vHju6jZ6v/BKsCUxFcpBRS1hJiC1XaWM+Iw4Tmgw8HEk3
         tcLQ==
X-Gm-Message-State: AJIora9bjHg9mfiAJdCDgttS38pqNCoTaucvP+UkzdhSpMz/diJzH5+D
        OZ5OXkcF63tN/piFdZc7KhZdNg4RCJk=
X-Google-Smtp-Source: AGRyM1vaT5geIv0+nQuGaH5hx7l6hUj5FbIN6ax9c/UTf8qAI7MTavn23/SMXsJJTDkFsNPPjKgejO8Ibpo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:260a:0:b0:300:1729:7654 with SMTP id
 m10-20020a81260a000000b0030017297654mr7643645ywm.125.1655239656113; Tue, 14
 Jun 2022 13:47:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:09 +0000
Message-Id: <20220614204730.3359543-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Everything leading up to that are related fixes and cleanups I encountered
along the way; some through code inspection, some through tests.

v2:
  - Rebased to kvm/queue (commit 8baacf67c76c) + selftests CPUID
    overhaul.
    https://lore.kernel.org/all/20220614200707.3315957-1-seanjc@google.com
  - Treat KVM_REQ_TRIPLE_FAULT as a pending exception.

v1: https://lore.kernel.org/all/20220311032801.3467418-1-seanjc@google.com

Sean Christopherson (21):
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
  KVM: x86: Morph pending exceptions to pending VM-Exits at queue time
  KVM: x86: Treat pending TRIPLE_FAULT requests as pending exceptions
  KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
    behavior
  KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
  KVM: selftests: Add an x86-only test to verify nested exception
    queueing

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  35 +-
 arch/x86/kvm/emulate.c                        |   3 +-
 arch/x86/kvm/svm/nested.c                     | 102 ++---
 arch/x86/kvm/svm/svm.c                        |  18 +-
 arch/x86/kvm/vmx/nested.c                     | 319 +++++++++-----
 arch/x86/kvm/vmx/sgx.c                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  53 ++-
 arch/x86/kvm/x86.c                            | 404 +++++++++++-------
 arch/x86/kvm/x86.h                            |  11 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   7 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
 .../kvm/x86_64/nested_exceptions_test.c       | 295 +++++++++++++
 15 files changed, 886 insertions(+), 418 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c


base-commit: 816967202161955f398ce379f9cbbedcb1eb03cb
-- 
2.36.1.476.g0c4daa206d-goog

