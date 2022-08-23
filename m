Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9028859DCE8
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358646AbiHWLwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359221AbiHWLwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:06 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEFCD51C2;
        Tue, 23 Aug 2022 02:32:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c24so11765635pgg.11;
        Tue, 23 Aug 2022 02:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=lB8NoAFXZ2ojNqB5NHqtJca8PZPv13Mxr0Sf4o4zAgs=;
        b=Hfd9KdXbIhbkSlfQznWZaJb5TmMaqJiAfLkPMefN5SZTy9aTY3UGQ0KqPwkS1grIfm
         vCy4hKurr4Zs2tkcBQYtzP2/kOR8gtY6xNJicOakdqoWNH4JZUqypeyNPn6UI5TAkyEl
         oXBA7V9t0O+vKQXWgvZyZxday/87L0JM+pZQesVwchkSur42u/MwJZF2wbdiI4rO7f+S
         nrqKU0UfZgLtpQGsQOElfdFXi74uyCuU3j1227SwSEGFh4YFChEkn/Ly9aOsLpoBUJTP
         B4ogg406gufB0GKJj1WS6teWqnCG7WAKU6WNm7FuHngPjaYPU1B+zHGakDngAcG0GI9S
         MQWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=lB8NoAFXZ2ojNqB5NHqtJca8PZPv13Mxr0Sf4o4zAgs=;
        b=soj6Rdi0hQjyBEbRxgPHNkj2cfKca6yLPf2ZJNqJpd2rE+NL8rpXGuvRAJ8lrim77X
         HK8m2B7QacXt2rL4sBBYsdC7gi90PAklXD8ff3kwuEQuJ3VY4xoJ70XbQDbBjhRzJ2H/
         uoqCn+wGVgyGIUAz+yWzRBG9s22jrrqf+B8ONKAsWQTxkhPn4xP6ihqSAyG5mkEsVrhV
         whUTwjiXJk/Xhw7X5NlcUYngfUdFb+W3+NWs42m3xijTbKUKaM9kLL7/wKS6D2FQDpQg
         Cy2siFHNFEMh9JDhm3thlMB6m1kWpKo2rsun1n/zl8f7hQms7CiK0+nitReVQYXk9G2b
         0V6Q==
X-Gm-Message-State: ACgBeo3paDW/Gci605Q8aSETfj7jX7VxbvvBKRtBCF7ItJXtGbtsefJG
        NcqpChPxYjZDcy26Q3pstOADVIbKjFw=
X-Google-Smtp-Source: AA6agR7pIIeHPiBQ2/MIHoqFUmi90hSjVnWTFT92xDq3NVbeeCVMhyFqRRdHiLpUtrCXa+Qeg9x14w==
X-Received: by 2002:a05:6a00:f8d:b0:536:c6c9:a2d with SMTP id ct13-20020a056a000f8d00b00536c6c90a2dmr6436699pfb.52.1661247162167;
        Tue, 23 Aug 2022 02:32:42 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:41 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 0/8] x86/pmu: Corner cases fixes and optimization
Date:   Tue, 23 Aug 2022 17:32:13 +0800
Message-Id: <20220823093221.38075-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
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

Good well-designed tests can help us find more bugs, especially when
the test steps differ from the Linux kernel behaviour in terms of the
timing of access to virtualized hw resources.

In this patch series, there are three small optimization (006/007/008),
one hardware surprise (001), and most of these fixes have stepped
on my little toes.

Please feel free to run tests, add more or share comments.

Previous:
https://lore.kernel.org/kvm/20220721103549.49543-1-likexu@tencent.com/
https://lore.kernel.org/kvm/20220803130124.72340-1-likexu@tencent.com/

V2 -> V2 RESEND Changelog:
- The "pebs_capable" fix has been merged into tip/perf/tree tree;
- Move the other two AMD vPMU optimization here;

Like Xu (8):
  perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
  KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
  KVM: x86/pmu: Don't generate PEBS records for emulated instructions
  KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
  KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
  KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter
  KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement
    amd_*_to_pmc()
  KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters
    scalability

 arch/x86/events/intel/core.c    |   3 +-
 arch/x86/include/asm/kvm_host.h |   6 +-
 arch/x86/kvm/pmu.c              |  47 ++++++++-----
 arch/x86/kvm/pmu.h              |   6 +-
 arch/x86/kvm/svm/pmu.c          | 116 +++++---------------------------
 arch/x86/kvm/vmx/pmu_intel.c    |  30 ++++-----
 6 files changed, 73 insertions(+), 135 deletions(-)

-- 
2.37.2

