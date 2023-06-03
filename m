Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D48720CD3
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbjFCBLG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235994AbjFCBLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:05 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781CE4C
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f1b50f0ecso1216714a12.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754661; x=1688346661;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iiocMTv8yvIcNZ4J7lO1deo0WKpqj2KZDWeFfD5uk+8=;
        b=uh5NKLv+bZuTCk11HqiRwQOg778yWsyI3yFt3YitAlkENAx2vJ5WuMzpdkL6zjOxn+
         5jrMzK6rhYuXI3uGg6Mok4vo69qi6M0sZMtE9067mijE806NlkxuWac2x6hG9wZ3cxEq
         KVWv0Bh4MiANhbT4Ao6zpnlGL16f61sS/l7mZft76egdD4mvGN1wbAs7ukVMryoQ0WCI
         lGRLMNwAPyy+dYWPQzUCeO1t06npnxxHsEiQsZ4kT4pstJt1w1idoPzr9W+N0duRynY5
         XT8O6mfhi6IVDg1qvZzlFqltbY2wylydAxwwXAzcVkAvI97lbEVo2SLoiBWZ0G4yduH9
         H1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754661; x=1688346661;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iiocMTv8yvIcNZ4J7lO1deo0WKpqj2KZDWeFfD5uk+8=;
        b=EYIrq3jCORyjYJ7P42xPt2n0HBbXOdOXz+gM1U2GUFgFkoW2hXwR4f7MBkjlaHCPpA
         2OcVm1zY5nqzaASHEzAogRM4dHdzd6HzUAgpJMxvw0oCIIJ2gEBFpT5ZwADRtnJuwTVF
         mPR4HmduQ+ac6rK/nbZWmJ0ksbKv8Nu9o+iEFxfdMdb/cOGcxyHh5eSNgBO7ejey7JyE
         QkJtMo0Mp5PU2xpzViLWknN5cTBUEO2Y7Et7CO+nqIxmf8gdDIBNN2ginJaAqhI9w9Hl
         bMohs/MfsW/W1aVsxh12yA/gfmMtDJBBiG0TC5B6tVhEA+v3OggpYQXJTysqPMCyKlHn
         Mdeg==
X-Gm-Message-State: AC+VfDxrizxb/7bVPvPh6+KhauCcznnFAY3HL5veQvAB5ob7146lPKK/
        jM864ZcDRi6aac5uYWb6uAP1S2gJAts=
X-Google-Smtp-Source: ACHHUZ77rxDPl5T4tnhoR2ebHvRrQWcb5qI9CTBrT9UjLlhReWhPSy3iRDOj9+WN2Vf20N/ZISREPbVUbTc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:24a:b0:253:3e6b:f5ce with SMTP id
 fz10-20020a17090b024a00b002533e6bf5cemr321454pjb.8.1685754661705; Fri, 02 Jun
 2023 18:11:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:46 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-1-seanjc@google.com>
Subject: [PATCH v7 00/12] KVM: x86: Add AMD Guest PerfMonV2 PMU support
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
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

v7 of AMD PMU v2 support.  This includes the global_ovf_ctrl_mask =>
global_status_mask rename that I *just* posted.  I really wanted to apply
v6 and be done with this series, and so sent it out separately, but the
code movement from pmu_intel.c to common x86 was too buggy to do in fixup.

Lightly tested (it's late, it's Friday).

v7:
 - Massage/rewrite changelogs to use preferred style.
 - Actually move PERF_GLOBAL_CTRL and friends out of pmu_intel.c.
 - Move intel_pmu_has_perf_global_ctrl() to common code instead of open
   coding it.
 - Split moving pmc_is_enabled() out to a separate patch.
 - Rebase on the s/global_ovf_ctrl_mask/global_status_mask rename

v6: https://lore.kernel.org/all/20230530060423.32361-1-likexu@tencent.com
v5: https://lore.kernel.org/all/20230410105056.60973-1-likexu@tencent.com
v4: https://lore.kernel.org/kvm/20230214050757.9623-1-likexu@tencent.com

Like Xu (11):
  KVM: x86/pmu: Move reprogram_counters() to pmu.h
  KVM: x86/pmu: Reject userspace attempts to set reserved GLOBAL_STATUS
    bits
  KVM: x86/pmu: Move handling PERF_GLOBAL_CTRL and friends to common x86
  KVM: x86/pmu: Provide Intel PMU's pmc_is_enabled() as generic x86 code
  KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
  KVM: x86/pmu: Disable vPMU if the minimum num of counters isn't met
  KVM: x86/pmu: Advertise PERFCTR_CORE iff the min nr of counters is met
  KVM: x86/pmu: Constrain the num of guest counters with kvm_pmu_cap
  KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
  KVM: x86/svm/pmu: Add AMD PerfMonV2 support
  KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022

Sean Christopherson (1):
  KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask

 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h        |  2 +-
 arch/x86/kvm/cpuid.c                   | 30 ++++++++-
 arch/x86/kvm/pmu.c                     | 92 +++++++++++++++++++++++---
 arch/x86/kvm/pmu.h                     | 56 ++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h           |  7 ++
 arch/x86/kvm/svm/pmu.c                 | 68 +++++++++++++------
 arch/x86/kvm/svm/svm.c                 | 19 +++++-
 arch/x86/kvm/vmx/nested.c              |  4 +-
 arch/x86/kvm/vmx/pmu_intel.c           | 77 ++++-----------------
 arch/x86/kvm/vmx/vmx.h                 | 12 ----
 arch/x86/kvm/x86.c                     | 10 +++
 12 files changed, 260 insertions(+), 118 deletions(-)


base-commit: b9846a698c9aff4eb2214a06ac83638ad098f33f
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

