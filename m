Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485D44D58E7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346001AbiCKD3H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiCKD3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:06 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B65EACA0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:04 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id v4-20020a63f844000000b003745fd0919aso4037453pgj.20
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XKkoV9WqAMW6txuBkF5Wd3rs0lT6dWVS/pJ+2/MRtag=;
        b=kufdfWVgYM9IzhcIFS2Zm75ZysbcrHo+Ft1gBPcwjP2xCCig08BOid5sNt+kBPWRCt
         Ovz6oGnz2qY/BmB4MJJ6UNIZ/H8ietBfYnn5sVsOHxpNc6NScHhfFnq4RBZEl8hehthK
         trb78KhZBvWAPpHIauti2B4oEYlX8VRIMdKqK9TcUZjfDEqlcGcrb1FeKztPVY/pOYf/
         +a00MkCYl8XEqFqYIhj9SSHFrR02lJqzd4OSOOOyd0FfcAWXXF4yCKMU85lnOXpJEBCl
         2cTtAImJkpdW04qL3ZFJe9E+JX4lhJcq8QiAauf9Re1Z7r1omuYMWrT3ntK69u4uP89q
         SeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=XKkoV9WqAMW6txuBkF5Wd3rs0lT6dWVS/pJ+2/MRtag=;
        b=c5TTueUJiJVtWdDdulHDdG68XmwyqpE8X6GaHJfbyS224oN13RFmSD4/bwpvv7OSh+
         oELsiGcWc3SshtxUCI2a7cS54hQh2cO0lgheEd1wC3Qe0NmDVQGOtDzb+xgph6oDq13C
         h6xFf7MepcM1XOfmJk/qLeeEv1UijGxeI07y+JiaIzhAjA7eMY4TAvc/bI6SfKtisrpU
         rIVizW+n81Uki7Niqu9ZrNkxtkH6w4wBeOzUydX5gtXP7pQ7ILbPmsII692G+SAMuXMr
         QwssLcTr2vP1x2YrKFquCC+k9YU4JiAtBWcLYNXLm9e/PyYEZhG1r6Wh5jBNkXg92WwP
         F+OQ==
X-Gm-Message-State: AOAM533T1isyC6Ob4inGnMfuOKC3tZ+FHyEzR2Yg9hUHJsrQFN3nRpdG
        +/fV6jbyRW+tvPlhs4Rc1BtJZM0wBxw=
X-Google-Smtp-Source: ABdhPJwIG2XZcUj85RKHGPmCh8wL09k3iIswXlIqpkv0ONOnCCRLF0z1lkYsbPsHDBhGQ3AIDKCVaQ/orcQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:130e:b0:4f3:9654:266d with SMTP id
 j14-20020a056a00130e00b004f39654266dmr8042509pfu.59.1646969284051; Thu, 10
 Mar 2022 19:28:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:40 +0000
Message-Id: <20220311032801.3467418-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 00/21] KVM: x86: Event/exception fixes and cleanups
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
along the way; some through code inspection, some through tests (I truly
thought this series was finished 10 commits and 3 days ago...).

Nothing in here is all that urgent; all bugs tagged for stable have been
around for multiple releases (years in most cases).

Sean Christopherson (21):
  KVM: x86: Return immediately from x86_emulate_instruction() on code
    #DB
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
  KVM: VMX: Update MTF and ICEBP comments to document KVM's subtle
    behavior
  KVM: selftests: Use uapi header to get VMX and SVM exit reasons/codes
  KVM: selftests: Add an x86-only test to verify nested exception
    queueing

 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |  33 +-
 arch/x86/kvm/emulate.c                        |   3 +-
 arch/x86/kvm/svm/nested.c                     | 100 ++---
 arch/x86/kvm/svm/svm.c                        |  18 +-
 arch/x86/kvm/vmx/nested.c                     | 322 +++++++++-----
 arch/x86/kvm/vmx/sgx.c                        |   2 +-
 arch/x86/kvm/vmx/vmx.c                        |  53 ++-
 arch/x86/kvm/x86.c                            | 409 ++++++++++++------
 arch/x86/kvm/x86.h                            |  10 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   5 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  51 +--
 .../kvm/x86_64/nested_exceptions_test.c       | 307 +++++++++++++
 15 files changed, 914 insertions(+), 403 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c


base-commit: 4a204f7895878363ca8211f50ec610408c8c70aa
-- 
2.35.1.723.g4982287a31-goog

