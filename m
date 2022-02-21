Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825F74BE97A
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356824AbiBULwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:52:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356845AbiBULwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:36 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5A31FA42;
        Mon, 21 Feb 2022 03:52:13 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m11so9144563pls.5;
        Mon, 21 Feb 2022 03:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q9EVapK/pPTWvrGkIuS0gkdfg4WRi8A2dJLpE97G/j0=;
        b=c15fHKyorTTeBgbqVh4Saep5MTSKXM0Wpe+4pl01EVerXlX8i2TOvQ54kAJYb9tQ/H
         5Ul7FDxOv675f2fXPh+7k9Q/RU02OSTWpNHaFN/97Rrq1N8kRTHx65H4+5qj7VidNcSX
         K862UhDRMAbhxuwimfhfGhzd5hb3JtHNqg1KXO+hudB7gwasY7Gzgz/3MNU5ZElsudss
         SyqwgPQPff9iSjZjxJIeV/8dKW0gaOhRNvHPAwOYElMeOLtyd4KYUJAozWOdwo5h7j6Z
         0ye5DoTT5y9rDL3jN8o1gOGsngTXHwTwmFohoA3qDSD9fqPdRFNP+joNUBW00YKoy1cP
         BAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q9EVapK/pPTWvrGkIuS0gkdfg4WRi8A2dJLpE97G/j0=;
        b=MH2aNsM4bqqz2ibxrUjDFSIJAA5W2CjTemNoC6zuLKxy7DqcXDMD+aQJnnTH62nG8b
         OstPOOzSeQEwCs9GjDLupKpTPwnnVYG6cQiLkR7rhCGf8iZjjtWGr77r2bMRycLQx76K
         4mvlWcybjRbtTszQ9m88PyviFXXg3Tb6zPj87aPFkYJ6LCNgOn50DAoX9hFdEB3Tf5uC
         09F2PRmgNTNCaVmu4BMcdCqbwYi09X19QEx/3kSkN3BKfOgrdFSmaeap2mU0WtS726Sn
         BVpzd0zaalA2Zj1E0enAnUy5bktJ9/cgV1z/zsOC9spk/WEKV1dnkIcisOZvyhlZrS78
         TPSg==
X-Gm-Message-State: AOAM530x7pozj6g8+FWo5uRoLJlxAyjCX5jG1TaeQJXDOeswpg41/sEU
        3tt6wJzMJ2KUAWJp/rb2p4s=
X-Google-Smtp-Source: ABdhPJzIOpX6LkU8ZlmEhbzW8KQ7EIpl63rw0DNq2i8r/bXk7KMe0ahf3LljPUtlg0nplo6q8JJXNQ==
X-Received: by 2002:a17:90a:480e:b0:1bc:1d88:8d4e with SMTP id a14-20020a17090a480e00b001bc1d888d4emr7801756pjh.157.1645444332617;
        Mon, 21 Feb 2022 03:52:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 00/11] KVM: x86/pmu: Get rid of PERF_TYPE_HARDWAR and other minor fixes
Date:   Mon, 21 Feb 2022 19:51:50 +0800
Message-Id: <20220221115201.22208-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
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
symmetrical, simpler and even faster [1], and it also fixes the
obsolescence amd_event_mapping issue [2].

One of the notable changes is that we ended up removing the
reprogram_{gp, fixed}_counter() functions and replacing it with the
merged reprogram_counter(), where KVM programs pmc->perf_event
with only the PERF_TYPE_RAW type for any type of counter
(suggested by Jim as well).  PeterZ confirmed the idea, "think so;
the HARDWARE is just a convenience wrapper over RAW IIRC". 

Practically, this change drops the guest pmu support on the hosts without
X86_FEATURE_ARCH_PERFMON  (the oldest Pentium 4), where the
PERF_TYPE_HARDWAR is intentionally introduced so that hosts can
map the architectural guest PMU events to their own.

Some code refactoring helps to review key changes more easily.
Patches are based on top of kvm/master (ec756e40e271).

The last patch removes the call trace in the commit message while we still
think that kvm->arch.pmu_event_filter requires SRCU protection in terms
of pmu_event_filter functionality, similar to "kvm->arch.msr_filter".

Please check more details in each commit and feel free to comment.

[0] https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/
[1] https://lore.kernel.org/kvm/ebfac3c7-fbc6-78a5-50c5-005ea11cc6ca@gmail.com/
[2] https://lore.kernel.org/kvm/20220117085307.93030-1-likexu@tencent.com/

Like Xu (11):
  KVM: x86/pmu: Update comments for AMD gp counters
  KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
  KVM: x86/pmu: Pass only "struct kvm_pmc *pmc" to reprogram_counter()
  KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
  KVM: x86/pmu: Drop "u8 ctrl, int idx" for reprogram_fixed_counter()
  KVM: x86/pmu: Use only the uniformly exported interface
    reprogram_counter()
  KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,
    fixed}counter()
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
  KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context
  KVM: x86/pmu: Protect kvm->arch.pmu_event_filter with SRCU

 arch/x86/events/core.c            |  11 ++
 arch/x86/include/asm/perf_event.h |   6 +
 arch/x86/kvm/pmu.c                | 188 ++++++++++++------------------
 arch/x86/kvm/pmu.h                |   6 +-
 arch/x86/kvm/svm/pmu.c            |  37 +-----
 arch/x86/kvm/vmx/pmu_intel.c      |  62 +++++-----
 6 files changed, 130 insertions(+), 180 deletions(-)

-- 
2.35.0

