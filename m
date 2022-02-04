Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A1D4AA26F
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243411AbiBDVmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243083AbiBDVmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:09 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF17FC061714
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:08 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id u24-20020a656718000000b0035e911d79edso3563234pgf.1
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=A80sxPQaWL6f5yGjquWZL0N8aen675OaLvQ0vL9tgic=;
        b=Ue9TW2PPM/s7I+5nAselrLCj9uVE1MWUWqRCtAaQeBgZbEVHwuwYMJ+vb/NSFldbfS
         KAzOOXyh6EnG4IxX/JRp0TzU/F8i7EOiJlejnoDCDwiWW3qJDMP5I1vyJHYG+VOGiKMd
         cLzU4YL70sIqSaJ5JJPVUPIJ+waOhaOvItclVxJS/NRaQppBwHkS9Bcp4mIIujLOPF5T
         oY2+4FTrr1JEPe43UdvtAg5FPLioQ/sOrGRgnwgfef84+HpDRdy21z0h1X7I6MnIc/m1
         dcSZvPWNQk8va3DzzcUHiIuKARR16G9h8c02ZGOjtPeRatzSfG3Il/iwroN1mD7LXbdo
         dx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=A80sxPQaWL6f5yGjquWZL0N8aen675OaLvQ0vL9tgic=;
        b=BMtYbk6Vm2FAC4MAZl21Pf3liMTYvSSZidwVSSZPgtqT0BZXPBU1IbBhpv09LAaPCd
         btKqUeZy4Zu5MwuhZKOlPdipItJHsdkyvqQumiSKKFZzf8GHXq7C8gtdHubYT0jG3YHO
         MrPRnEHzERbaLb2JGGikV73uhwY4tmTsMekMsTJOy6+iG7QvoGuYC+CVVHsqNTCMVFgF
         69wYWYWzEAYIqOdWL9jyYqr1FL0ok92Gls8qpV8MHTYUIm5NKFT4MZIpS821OUiU0MnX
         3krPN/vc6xpRVZVlPIi9Cdu8xoP/GaDjIIRu2hyahgg4KyMT98g6cmPxPPlhgZXhM6bX
         5aJQ==
X-Gm-Message-State: AOAM5331rOQ5isQZMEpNP7vpIyrQJnkvK2texlPY0Rf1uHUO/j7RL2Zv
        T1nIk+jQ2kXs9gtyL8L/ob6pXMfS2Jo=
X-Google-Smtp-Source: ABdhPJyvWM4OK4sgvDuUOvIgvTK7/Ym8wKVT2IloIOe2I8/OMLiKslX9+dYxCl+znng1ZvFdRj3ug6DuKMw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:16d4:: with SMTP id
 l20mr5020761pfc.5.1644010927914; Fri, 04 Feb 2022 13:42:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:54 +0000
Message-Id: <20220204214205.3306634-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 00/11] KVM: x86: Prep work for VMX IPI virtualization
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for VMX's IPI virtualization, in which hardware treats ICR as a
single 64-bit register in x2APIC mode.  The SDM wasn't clear on how ICR
should be modeled, KVM just took the easier path and guessed wrong.

Hardware's implementation of ICR as a 64-bit register requires explicit
handling to maintain backwards compatibility in KVM_{G,S}ET_REG, as
migrating a VM between hosts with different IPI virtualization support
would lead to ICR "corruption" for writes that aren't intercepted by
KVM (hardware doesn't fill ICR2 in vAPIC page).

This series includes AVIC cleanups for things I encountered along the way.
AVIC still has multiple issues, this only fixes the easy bugs.

Sean Christopherson (11):
  Revert "svm: Add warning message for AVIC IPI invalid target"
  KVM: VMX: Handle APIC-write offset wrangling in VMX code
  KVM: x86: Use "raw" APIC register read for handling APIC-write VM-Exit
  KVM: SVM: Use common kvm_apic_write_nodecode() for AVIC write traps
  KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure
  KVM: x86: WARN if KVM emulates an IPI without clearing the BUSY flag
  KVM: x86: Make kvm_lapic_reg_{read,write}() static
  KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes
  KVM: x86: Treat x2APIC's ICR as a 64-bit register, not two 32-bit regs
  KVM: x86: Make kvm_lapic_set_reg() a "private" xAPIC helper
  KVM: selftests: Add test to verify KVM handles x2APIC ICR=>ICR2 dance

 arch/x86/kvm/lapic.c                          | 193 ++++++++++++------
 arch/x86/kvm/lapic.h                          |  21 +-
 arch/x86/kvm/svm/avic.c                       |  38 ++--
 arch/x86/kvm/trace.h                          |   6 +-
 arch/x86/kvm/vmx/vmx.c                        |  11 +-
 arch/x86/kvm/x86.c                            |  15 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   1 +
 .../selftests/kvm/x86_64/xapic_state_test.c   | 150 ++++++++++++++
 10 files changed, 325 insertions(+), 112 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/xapic_state_test.c


base-commit: 17179d0068b20413de2355f84c75a93740257e20
-- 
2.35.0.263.gb82422642f-goog

