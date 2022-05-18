Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CB952BC3B
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiERNZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiERNZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE35E1B5FAD;
        Wed, 18 May 2022 06:25:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z7-20020a17090abd8700b001df78c7c209so5616912pjr.1;
        Wed, 18 May 2022 06:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xg60UELkO1AELegT163+kFb9GluCuJgTwNP9GFmBOlE=;
        b=Hu1Y9Jp6WbY/BIfab/L98ljDQF2FBYAUDeJRDKv11ts6TfRcuyRrPX7aPlXS6C9kjr
         2LUxAskhD3SIAsRr5O4ISY4DnMqMZ5h51cyVE1L1tqddNvh4kEOk10CleELn1/ST5MEP
         C+lFJHqI74sm+HMiz/kTUlxrkQ+cySLCN5F+VdtYIEOifr5Qmxro6ipYIM8vMQ+er1sJ
         OrEFhPqY1j9Q/YLcNcsQTGgv68XSPH1My6CjFdH5K1ybHKA7kUf6r0aRWC/cBcUuWx48
         CWbwhb5cmIkdm46xO8sHM2h+F4LvzzrsRH2QZNoTh3rM5O3hiwRZkO7xwEL6Xi2P70Bu
         V/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xg60UELkO1AELegT163+kFb9GluCuJgTwNP9GFmBOlE=;
        b=Cn/lBDnbKlfirOtdtjG1ZXV/+uutWvom4NuOomWpXroGNOHGxUrtmhnY08FESM8xHT
         ZRlAKu16evQ71mYNAFrEh7VKCOEW9KlxcuMcBfyc1pShSZR3bjTGk6acp39QbraXDWRC
         im7fgn+Rse/zfYl37kK16C0R5wAurUbIvnr5rQ+cEzylIQ6eD4a7PqOSX1smyjGI1wtZ
         CPhB7Tqa01ovmvY+xCc8f0OWvO1unOLUI1tzGDINbupuaUnmDo0pCRqlL6iZsbjNGMUZ
         4ZsYjgoLXzf39haM5fLWYM3TeGV1vQnE/00ilhcto8tEfF+g9Ckb/jdSsL8tA8XMoIot
         +ulg==
X-Gm-Message-State: AOAM5327SyVYwdx8MXHDAXVceClxcAMGuvBgPfwhgw61fYZLiGiCaU+F
        z17WfA6raps27bvbYjBPTkk=
X-Google-Smtp-Source: ABdhPJyaJZL3M0KoOZQCpG0CgO0wIreYrrvXS0f5a9/wQiAcrQBlTga4/N9oi+uHkKZaCxd8Nqt4qg==
X-Received: by 2002:a17:90b:4f41:b0:1de:bd14:7721 with SMTP id pj1-20020a17090b4f4100b001debd147721mr30894092pjb.9.1652880318372;
        Wed, 18 May 2022 06:25:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:17 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 00/11] KVM: x86/pmu: More refactoring to get rid of PERF_TYPE_HARDWAR
Date:   Wed, 18 May 2022 21:25:01 +0800
Message-Id: <20220518132512.37864-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a follow up to [0]. By keeping the same semantics of eventsel
for gp and fixed counters, the reprogram code could be made more
symmetrical, simpler and even faster [1], and based on that, it fixes the
obsolescence amd_event_mapping issue [2].

Most of the changes are code refactoring, which help to review key
changes more easily. Patches are rebased on top of kvm/queue.

One of the notable changes is that we ended up removing the
reprogram_{gp, fixed}_counter() functions and replacing it with the
merged reprogram_counter(), where KVM programs pmc->perf_event
with only the PERF_TYPE_RAW type for any type of counter
(suggested by Jim as well).  PeterZ confirmed the idea, "think so;
the HARDWARE is just a convenience wrapper over RAW IIRC". 

Practically, this change drops the guest pmu support on the hosts without
X86_FEATURE_ARCH_PERFMON  (the oldest Pentium 4), where the
PERF_TYPE_HARDWAR is intentionally introduced so that hosts can
map the architectural guest PMU events to their own. (thanks to Paolo)

The 3rd patch removes the call trace in the commit message while we still
think that kvm->arch.pmu_event_filter requires SRCU protection in terms
of pmu_event_filter functionality, similar to "kvm->arch.msr_filter".

Please check more details in each commit and feel free to comment.

[0] https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/
[1] https://lore.kernel.org/kvm/ebfac3c7-fbc6-78a5-50c5-005ea11cc6ca@gmail.com/
[2] https://lore.kernel.org/kvm/20220117085307.93030-1-likexu@tencent.com/

Thanks,
Like Xu

---
v3: https://lore.kernel.org/kvm/20220411093537.11558-1-likexu@tencent.com/
v3 -> v3 RESEND Changelog:
-  Rebase on the top kvm-queue tree;

v2 -> v3 Changelog:
- Use static_call stuff for .hw_event_is_unavail hook;
- Drop unrelated 0012 patch since we have addressed the issue;
- Drop passing HSW_IN_TX* bits for pmc_reprogram_counter();

v1: https://lore.kernel.org/kvm/20220221115201.22208-1-likexu@tencent.com/
v1 -> v2 Changelog:
- Get all the vPMC tests I have on hand to pass;
- Update obsolete AMD PMU comments; (Jim)
- Fix my carelessness for [-Wconstant-logical-operand] in 0009; (0day)
- Add "u64 new_config" to reuse perf_event for fixed CTRs; (0day)
- Add patch 0012 to attract attention to review;

Like Xu (11):
  KVM: x86/pmu: Update comments for AMD gp counters
  KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
  KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU
  KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
  KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
  KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
  KVM: x86/pmu: Use only the uniform interface reprogram_counter()
  KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
  KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context

 arch/x86/events/core.c                 |  11 ++
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
 arch/x86/include/asm/perf_event.h      |   6 +
 arch/x86/kvm/pmu.c                     | 157 ++++++++++---------------
 arch/x86/kvm/pmu.h                     |   8 +-
 arch/x86/kvm/svm/pmu.c                 |  62 ++--------
 arch/x86/kvm/vmx/pmu_intel.c           |  62 +++++-----
 7 files changed, 121 insertions(+), 187 deletions(-)

-- 
2.36.1

