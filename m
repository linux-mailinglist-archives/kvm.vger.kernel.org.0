Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED58C573647
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 14:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbiGMMZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 08:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiGMMZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 08:25:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CACCAE395;
        Wed, 13 Jul 2022 05:25:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p9so11746257pjd.3;
        Wed, 13 Jul 2022 05:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lqdR1yNeP/n66U2PWo5TDBoxni/6Pe9986cCFbMvI3U=;
        b=aQg2/CRoKMKik40O6ZDgPkEwJg4r684F3WopDzyWBoQGBw3FZSrU6HXRn6EFYIuSjw
         auunaz2AWlA4LbYTW3mwLgrZLwS+P3lYfv7qn3pvge1/JMx1CUMdFwv9XyhSjixTMhws
         /Ntr4Osjt7QLV3xcFHLxVwddoFBj+k8LLL3phuQ5M1lOZzeeTcSxU6EuY7aszL606iGt
         hRvOBAnwAcnMd8m1IzJnpdu/zdolOdfwKy+l0+ueXul23ldrdA1RQKxY5sRxrPp5zIEg
         hG4sUJQCRCOpd7GYzR6HmIMOum7efLN2LFnU5thCUAy5czZnQjCmMYucotBItKTFZlVX
         UN+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lqdR1yNeP/n66U2PWo5TDBoxni/6Pe9986cCFbMvI3U=;
        b=2wkzNjG90pyo6fHgdiONUbIT4FxC78j/GhXdY8oJLOgszhvsYst1BUifMClzZ6Ecb+
         UikBpdfbNtiabRf/k1vVmtNty08Ggcc0iJYdL7Nkuk8YAGxbW+6d2WLbjzVaxchrEiix
         q2+KGHUBbEKEBDqokn9ZCXeFBz9PioUNfbHARftLwKnm2xVhrzj8bH4Ykg0913uPPvRt
         EKyANXMnAQLSHmZSB2UNhRWFWLOtZFBcVhk71R710ysxLX4LumFv0fGZy6nX6o/Z2nPB
         5raPRnN9uU91LA6QS/PfLbZlnB4jO5qlvzfq6LXsKPbuS+Fa9gafMR02KaqW3liPbN1a
         qPZQ==
X-Gm-Message-State: AJIora/bACIQH7BoDzkZRK2Qs/jhAZNsRT1FPszbeMPL4MzIwxWJbrIz
        Wr/lqKVHerMxP3RAvV5Y+8ULiWQMv2c=
X-Google-Smtp-Source: AGRyM1s+Q+GHg0VHs6eFsX2XOO5VsZpWQpY8IFJloT+mDphAF1B5HqP9SixJz843txhgeOeJYVBGBg==
X-Received: by 2002:a17:903:11cc:b0:168:eae:da4a with SMTP id q12-20020a17090311cc00b001680eaeda4amr2896959plh.21.1657715126941;
        Wed, 13 Jul 2022 05:25:26 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902bb8700b0016bf1ed3489sm8719233pls.143.2022.07.13.05.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:25:25 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 0/7] KVM: x86/pmu: Fix some corner cases including Intel PEBS
Date:   Wed, 13 Jul 2022 20:24:59 +0800
Message-Id: <20220713122507.29236-1-likexu@tencent.com>
X-Mailer: git-send-email 2.37.0
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

A new guest PEBS kvm-unit-test constructs a number of typical and
corner use cases to demonstrate how fragile the earlier PEBS
enabling patch set is. I prefer to reveal these flaws and fix them
myself before we receive complaints from projects that rely on it.

In this patch series, there is one small optimization (006), one hardware
surprise (002), and most of these fixes have stepped on my little toes.

Please feel free to add more tests or share comments.

Like Xu (7):
  perf/x86/core: Update x86_pmu.pebs_capable for ICELAKE_{X,D}
  perf/x86/core: Completely disable guest PEBS via guest's global_ctrl
  KVM: x86/pmu: Avoid setting BIT_ULL(-1) to pmu->host_cross_mapped_mask
  KVM: x86/pmu: Not to generate PEBS records for emulated instructions
  KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
  KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
  KVM: x86/pmu: Defer counter emulated overflow via pmc->stale_counter

 arch/x86/events/intel/core.c    |  4 ++-
 arch/x86/include/asm/kvm_host.h |  5 ++--
 arch/x86/kvm/pmu.c              | 43 +++++++++++++++++++++------------
 arch/x86/kvm/svm/pmu.c          |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 29 +++++++++++-----------
 5 files changed, 49 insertions(+), 34 deletions(-)

-- 
2.37.0

