Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4EC697338
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbjBOBIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjBOBIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:08:21 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670D63251D
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:46 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c11-20020a62e80b000000b005a8ba9365c1so3927484pfi.18
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GgKzaPi/QrcJiYM9eoiWYZTMezdJYvR+LPCiPmmJFjY=;
        b=h7nSXllSzOJ60G4tQHhNw0yP7P7IYk0V3nZluZTd1aMfkkFB5AixmW6tMQT57xcK5X
         3N+teDIr2zebKOfi+rXEmLZDY+2Jn+/fgVbt87wmgO4Zell5U4fJXChAH0FUfjQcnxkZ
         99uNFbR404ukjvLLgCaP/YvpdxSZmd9BWx+qQMSZLfT+drLA+sqU2P4YpiAr0oTZsmQ/
         dr1EryYc7/p+6ImTUZVERkCPEzSjufT+1PbPc99/YoduBfja3S6h7MvDinPhlOcXwiU3
         RF7gPL6ORXAH9NgRoMjLAEqKeUBQJGTN6Vb3p33ypqUalMNTD44ZDBcvaV7XIqlo1agb
         ppAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GgKzaPi/QrcJiYM9eoiWYZTMezdJYvR+LPCiPmmJFjY=;
        b=PhDjtUAW1bs+gAwUlpqsvG6cBa8WJRdOJfjYG44cqlC9KtIOqgQfpTMKciG3AcEXw/
         /nV/VFZAiWVjmbs+e30ya71Td081bD4CCr/rd25lW+Qom3dJuKpIWAVkQa27jPD/6HX9
         0ex8ag2sxCa1rKyPUzxsFhLsaPKXol/UhuU/yKMH+n0qPh+hV60tC0s+fmO4F/vKSoGl
         DUXuuxl+9LeAxhjOStM6VCv+x6bt9GcJeJU014kM3ttq6mSjtXN/XNl6r01fFDW2Pfaw
         GFgGmyllqzUBALL9gW2Po4bBgu/iDgIvMv3mMA+Ql4dbWoPhHb7+oNEpBgmnOwrwfHz8
         o0GA==
X-Gm-Message-State: AO0yUKVortx2tyDhMnOoxRn9Ar5Z0qXu+nX40HNLh+449Ts7BjCBx/4Y
        cxCj3N3BTetY5vEg+iPBuEArFyjUutE=
X-Google-Smtp-Source: AK7set9MjL0Jda/vguFC5G3SyIToXJN/WaABgPL+TzCCiyajUFbJq7+m/hR2kmh5tMx8b86IAzn4xqMAjqE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3d06:0:b0:4fb:58bf:d25f with SMTP id
 k6-20020a633d06000000b004fb58bfd25fmr52360pga.7.1676423265751; Tue, 14 Feb
 2023 17:07:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:11 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: APIC changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
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

KVM x86 APIC related changes for 6.3.  Emanuele's fix for userspace forcing an
x2APIC => xAPIC transition is the most interesting change, the rest is minor
fixes and cleanups.

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-apic-6.3

for you to fetch changes up to eb98192576315d3f4c6c990d589ab398e7091782:

  KVM: selftests: Verify APIC_ID is set when forcing x2APIC=>xAPIC transition (2023-02-01 16:22:54 -0800)

----------------------------------------------------------------
KVM x86 APIC changes for 6.3:

 - Remove a superfluous variables from apic_get_tmcct()

 - Fix various edge cases in x2APIC MSR emulation

 - Mark APIC timer as expired if its in one-shot mode and the count
   underflows while the vCPU task was being migrated

 - Reset xAPIC when userspace forces "impossible" x2APIC => xAPIC transition

----------------------------------------------------------------
Emanuele Giuseppe Esposito (2):
      KVM: x86: Reinitialize xAPIC ID when userspace forces x2APIC => xAPIC
      KVM: selftests: Verify APIC_ID is set when forcing x2APIC=>xAPIC transition

Li RongQing (1):
      KVM: x86: fire timer when it is migrated and expired, and in oneshot mode

Sean Christopherson (6):
      KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
      KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
      KVM: x86: Mark x2APIC DFR reg as non-existent for x2APIC
      KVM: x86: Split out logic to generate "readable" APIC regs mask to helper
      KVM: VMX: Always intercept accesses to unsupported "extended" x2APIC regs
      KVM: VMX: Intercept reads to invalid and write-only x2APIC registers

zhang songyi (1):
      KVM: x86: remove redundant ret variable

 arch/x86/kvm/lapic.c                               | 77 +++++++++++++---------
 arch/x86/kvm/lapic.h                               |  2 +
 arch/x86/kvm/vmx/vmx.c                             | 40 +++++------
 .../selftests/kvm/x86_64/xapic_state_test.c        | 55 ++++++++++++++++
 4 files changed, 125 insertions(+), 49 deletions(-)
