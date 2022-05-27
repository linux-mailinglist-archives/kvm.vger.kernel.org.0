Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF8D535757
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 03:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbiE0BcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 21:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbiE0BcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 21:32:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFE35643F
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 18:32:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d22so2888797plr.9
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 18:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=DtJKs/F8vTj/HXdmzljZuCCiDXwNwAC0dItfGFMRrsA=;
        b=o1R4d1dGpyoMoMCOY2RtKId4gjAywrro9Xk4TUXrd2BmW8148tYYL4RFfrkxjX53Bc
         nuFzeL8lGTvX8cv7rLPo2O2FkfEQmjSbuZOFd0cA7dnQAgBGAd0f7bXkEzU4unqbnKc+
         Kx+oCwHmVCGJT6X+pNQce6DSdd9xSthQuU0h9S2I1P4dE44HVyy/GKkH+UJ7Ni9uQ2uK
         ph9A0gRKxWIDMamIclevoKfgDL5KU1I+lHGVis3JXMvqua9r3pd/GILBjfINevVw+AoQ
         C2dFAhtXZia2ST6Tfd4HOpoYkerSklXWIP4Ix95dR2Lzi11Il1eOZhk7lHSSYirGgY4g
         RTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DtJKs/F8vTj/HXdmzljZuCCiDXwNwAC0dItfGFMRrsA=;
        b=0cBY1mLacQfoV1/kPr2fKJJ1JHszY3lcx5vYLj2wWLig2ix6dL4uWzHMzf9O6Hk0M6
         DdBoNnCmpOo32lNaCA0yvmmKhiMhipdSO59dHgrxyghMRENYzm8Zkv6BwIPIJPvaDVvA
         U0x2mB5WFvlJFZJA86oRu47J+04ScPv7IhJTCN5/HMV2k1mtgiLwYCCWDLIa1vHZPPHF
         eszNDI5j/LiyitOx6IBFFbbacHCy+GrLb8UYT84rw3KeP3Uw/q7JWR2zQFQ7IMM2Qoix
         MBv7rA5vFcfI+BpNz/UrUwRsgDC5Y7PIPv2FHJ6Mh/PdgcSsvuFzvrPGL+fLsKWXd3O/
         fTag==
X-Gm-Message-State: AOAM530Nw2XE/CMOZVznZPS3xkFe+7axwKysacLBCefGkdBt2T0q6r1V
        cr+qGTD4nYV5V/r4qc8wt8Y2wE/cqdRmvyZ7okJBlWDqLJ0V
X-Google-Smtp-Source: ABdhPJxCZIi61MLHlMBkgf1a1qdvBKwNQuNsxe+dasHzWKKhZtBVjHnppsD9rzI3AB+UdHkk081bW8r7/o08BDwJ1VM=
X-Received: by 2002:a17:90b:4b52:b0:1df:c1ef:2cd1 with SMTP id
 mi18-20020a17090b4b5200b001dfc1ef2cd1mr5646083pjb.130.1653615132169; Thu, 26
 May 2022 18:32:12 -0700 (PDT)
MIME-Version: 1.0
From:   Bill Wendling <morbo@google.com>
Date:   Thu, 26 May 2022 20:32:01 -0500
Message-ID: <CAGG=3QXUfFksVLF=gzU3EYkyf7RQKvr5_FU6Ea5enf39vinY3A@mail.gmail.com>
Subject: [kvm-unit-tests RFC] Inlining in PMU Test
To:     kvm list <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm into an issue when I compile kvm-unit-tests with a new-ish Clang
version. It results in a failure similar to this:

Serial contents after VMM exited:
SeaBIOS (version 1.8.2-20160510_123855-google)
Total RAM Size = 0x0000000100000000 = 4096 MiB
CPU Mhz=2000
CPUs found: 1     Max CPUs supported: 1
Booting from ROM...
enabling apic
paging enabled
cr0 = 80010011
cr3 = bfefc000
cr4 = 20
PMU version:         4
GP counters:         3
GP counter width:    48
Mask length:         7
Fixed counters:      3
Fixed counter width: 48
 ---8<---
PASS: all counters
FAIL: overflow: cntr-0
PASS: overflow: status-0
PASS: overflow: status clear-0
PASS: overflow: irq-0
FAIL: overflow: cntr-1
PASS: overflow: status-1
PASS: overflow: status clear-1
PASS: overflow: irq-1
FAIL: overflow: cntr-2
PASS: overflow: status-2
PASS: overflow: status clear-2
PASS: overflow: irq-2
FAIL: overflow: cntr-3
PASS: overflow: status-3
PASS: overflow: status clear-3
PASS: overflow: irq-3
 ---8<---

It turns out that newer Clangs are much more aggressive at inlining
than GCC. I could replicate this failure with GCC with the patch
below[1] (the patch probably isn't minimal). If I add the "noinline"
attribute "measure()" in the patch below, the test passes.

Is there a subtle assumption being made by the test that breaks with
aggressive inlining? If so, is adding the "noinline" attribute to
"measure()" the correct fix, or should the test be made more robust?

-bw

[1]
diff --git a/x86/pmu.c b/x86/pmu.c
index a46bdbf4788c..4295e0c83aa0 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -104,7 +104,7 @@ static int num_counters;

 char *buf;

-static inline void loop(void)
+static __always_inline void loop(void)
 {
        unsigned long tmp, tmp2, tmp3;

@@ -144,7 +144,7 @@ static int event_to_global_idx(pmu_counter_t *cnt)
                (MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
 }

-static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
+static __always_inline struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 {
        if (is_gp(cnt)) {
                int i;
@@ -158,7 +158,7 @@ static struct pmu_event*
get_counter_event(pmu_counter_t *cnt)
        return (void*)0;
 }

-static void global_enable(pmu_counter_t *cnt)
+static __always_inline void global_enable(pmu_counter_t *cnt)
 {
        cnt->idx = event_to_global_idx(cnt);

@@ -166,14 +166,14 @@ static void global_enable(pmu_counter_t *cnt)
                        (1ull << cnt->idx));
 }

-static void global_disable(pmu_counter_t *cnt)
+static __always_inline void global_disable(pmu_counter_t *cnt)
 {
        wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
                        ~(1ull << cnt->idx));
 }


-static void start_event(pmu_counter_t *evt)
+static __always_inline void start_event(pmu_counter_t *evt)
 {
     wrmsr(evt->ctr, evt->count);
     if (is_gp(evt))
@@ -197,7 +197,7 @@ static void start_event(pmu_counter_t *evt)
     apic_write(APIC_LVTPC, PC_VECTOR);
 }

-static void stop_event(pmu_counter_t *evt)
+static __always_inline void stop_event(pmu_counter_t *evt)
 {
        global_disable(evt);
        if (is_gp(evt))
@@ -211,7 +211,7 @@ static void stop_event(pmu_counter_t *evt)
        evt->count = rdmsr(evt->ctr);
 }

-static void measure(pmu_counter_t *evt, int count)
+static __always_inline void measure(pmu_counter_t *evt, int count)
 {
        int i;
        for (i = 0; i < count; i++)
