Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD985A7226
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiHaABC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiHaAA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:00:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02777696CA
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:00:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e16-20020a17090301d000b00172fbf52e7dso8898536plh.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=HjUp0+XGX7I9pp1rwUfEKS1ZQ3tXMZ53vYRIKHPszec=;
        b=PlaHhbkkfyCu7zAcx6wxZJlKMNEW34EZejuQEmTlmm/CP0cfEaYlGWVW+MWr/AV5on
         +9Oyj7XiMxBnejeGsablgXp8wfcg9qHu0UoKA058ojeBK+tKlHXp5uOdm2nzdaVIAlkt
         2+CWPToHxPAWcYeDdq2V9cI9MgjzEH0ius2XrFiohVZ963FjaSoIpPJqZd3VmFtjfF29
         chObz/FQ32Ff+LwhplTN6N3SGyVJ8lIYqgyvMJwaLy2XwGiwsgaF6S4MbLVAUlNrrw4y
         Fcrlrhgl8ECpYQ4nCCju3y6RtZmxmBo0N9OAgbLJaX1X/LR3yXURMLUeaNG4vwr5lp4Y
         Eieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=HjUp0+XGX7I9pp1rwUfEKS1ZQ3tXMZ53vYRIKHPszec=;
        b=yRPHyGN6NAsdRv+AAg1x+wmjiLL6Btc25i8IAr5P+tBQmzqQWIaglM/cJw0cFcdY2U
         0FI3e8lKhw1ruXz3I+rC8LiI03F3cMLrwruCAOujmoqL9cI0xS0hhU/S2ahieo/N8p3t
         Itp/PqQDzYjiE1DDr9Jj7emq2jHBo4zxSYEAMPlo48V+sS3tN70sAozKJlMkcGZywRwp
         OkVPU/Jl5KDjB9ai2UeSdJTTpIppOshYwqxvuBpFFYQhNTrQPcifau4Tp5vuZAC92vMS
         SLymBobsjUemtNaSmDhOFnJu1IpUpphpBgWKvmEP9ei9TFlblq5STv+BTJhCUC/a4C6o
         ryIA==
X-Gm-Message-State: ACgBeo2srUHENW39xTWmHBtJSDLFIKNtV1YsnZppV9Vv04cTw4LfVWuH
        OLn2CZOCuzJG8+CgjY65Vi93gr4lQRg=
X-Google-Smtp-Source: AA6agR4bzFoFtOfSYApxa64iuwbXdswW+XlYkRQHFxA89Xel0/yW91r0PpgxrKN76mN32s9Iu5kl3UX2uEU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8882:0:b0:52f:1ead:2c21 with SMTP id
 z2-20020aa78882000000b0052f1ead2c21mr23652721pfe.15.1661904057468; Tue, 30
 Aug 2022 17:00:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:00:50 +0000
In-Reply-To: <20220831000051.4015031-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220831000051.4015031-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831000051.4015031-3-seanjc@google.com>
Subject: [PATCH v3 2/3] perf/x86/core: Drop the unnecessary return value from x86_perf_get_lbr()
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
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

Drop the return value from x86_perf_get_lbr() now that there's no stub,
i.e. now that success is guaranteed (which is a bit of a lie since
success was always guaranteed, it's just more obvious now).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/lbr.c       | 6 +-----
 arch/x86/include/asm/perf_event.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 4f70fb6c2c1e..b8ad31c52cf0 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1868,10 +1868,8 @@ void __init intel_pmu_arch_lbr_init(void)
  * x86_perf_get_lbr - get the LBR records information
  *
  * @lbr: the caller's memory to store the LBR records information
- *
- * Returns: 0 indicates the LBR info has been successfully obtained
  */
-int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
+void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	int lbr_fmt = x86_pmu.intel_cap.lbr_format;
 
@@ -1879,8 +1877,6 @@ int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 	lbr->from = x86_pmu.lbr_from;
 	lbr->to = x86_pmu.lbr_to;
 	lbr->info = (lbr_fmt == LBR_FORMAT_INFO) ? x86_pmu.lbr_info : 0;
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(x86_perf_get_lbr);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f839eb55f298..f6d9230cdfab 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -528,7 +528,7 @@ extern int x86_perf_rdpmc_index(struct perf_event *event);
 
 #ifdef CONFIG_CPU_SUP_INTEL
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
-extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
+extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 extern void intel_pt_handle_vmx(int on);
 #endif /* CONFIG_CPU_SUP_INTEL */
 
-- 
2.37.2.672.g94769d06f0-goog

