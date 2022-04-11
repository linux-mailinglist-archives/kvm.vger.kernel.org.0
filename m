Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AF64FB793
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344433AbiDKJh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243873AbiDKJh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:37:57 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808BB15A0F;
        Mon, 11 Apr 2022 02:35:43 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 32so11567789pgl.4;
        Mon, 11 Apr 2022 02:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O1b3En5apsd/pN/5FY6BImJsRQvGXKFda/tDrlpUaEw=;
        b=iZ9iioHWIKt8yt2gZQ3JX/6hdAq5l2pjNyJKu8chrs+3KaYk38XvifL7w+bWL9YpkN
         nghhWtPnch0SWdURoZZ1jhOc2FDavX9tuh6+dUP+Ueil4eq23I6DZ19twv8JXGWyci7o
         fi8uzvms/lNX577H0iJDqFhcfVYRySZnpKwPUF0hC2K8eN9ftuWcl3gvP9q9KhSTL8D6
         Uqwn0jSUSB+KgymEuocdrxB9Jve1IyD8qOh7S0EoljruMPe5P1tDksLKBf07mUQJ40pe
         FO4ofNWbR45Ul61DphUkRnupUX0WZxefY7UpUIoD0d3yh3vjsyHTRzgoIHxIPm8U/XhR
         6G0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O1b3En5apsd/pN/5FY6BImJsRQvGXKFda/tDrlpUaEw=;
        b=zMv3KuIiUiFkQWV6I1bdfIY0ezv4gkWBZfm8GuZB//BUdb0AumXUD485w3guiBw9ef
         6RTmfk8N7Qds8pQfIh99jxRfigyVup1Tw7SyoRTpYjiFTHlBSiVOyWc6WLRIXuMNC5Jo
         HS5n17Yrmnhz8mZUjN45Xl1NozgwdEsuLBZDWxd2Ka/Yqwj8SAYo/JSOhSPsLtnt3VqO
         bFRir+wyxgNLVvDhwbSVMM3MOJi40HTA4wRcx93zf48smz44J6oLnm0snI0Y0K1dXk2c
         dTWo0EYV7DoG4oAB/gp+FEIcCSltnLLMASz3jeJJNqEQd1XIZWqmsxok7/Y5yD2js/J/
         1dYQ==
X-Gm-Message-State: AOAM533tKJdVHJXH4TF5mTjjOyvFolN1CzBtBovYtQ4Z3AA2Ov5PiVAI
        TCV9WEU5oJSS1c7BnppnR64=
X-Google-Smtp-Source: ABdhPJxhmDYDXdoFVhEirtrbYZeUX2WXDRtpdmwZh+2gtnJi4hWYNEZJxweFO2xmEwOlSA4XxduspA==
X-Received: by 2002:a63:150c:0:b0:39c:c255:27c1 with SMTP id v12-20020a63150c000000b0039cc25527c1mr18126076pgl.293.1649669743032;
        Mon, 11 Apr 2022 02:35:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:42 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 00/11] KVM: x86/pmu: More refactoring to get rid of PERF_TYPE_HARDWAR
Date:   Mon, 11 Apr 2022 17:35:26 +0800
Message-Id: <20220411093537.11558-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

v2: https://lore.kernel.org/kvm/20220302111334.12689-1-likexu@tencent.com/
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
  KVM: x86/pmu: Use only the uniformly exported interface
    reprogram_counter()
  KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
  perf: x86/core: Add interface to query perfmon_event_map[] directly
  KVM: x86/pmu: Replace pmc_perf_hw_id() with perf_get_hw_event_config()
  KVM: x86/pmu: Drop amd_event_mapping[] in the KVM context

 arch/x86/events/core.c                 |  11 ++
 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
 arch/x86/include/asm/perf_event.h      |   6 +
 arch/x86/kvm/pmu.c                     | 179 ++++++++++---------------
 arch/x86/kvm/pmu.h                     |   6 +-
 arch/x86/kvm/svm/pmu.c                 |  40 +-----
 arch/x86/kvm/vmx/pmu_intel.c           |  65 ++++-----
 7 files changed, 132 insertions(+), 177 deletions(-)

-- 
2.35.1

