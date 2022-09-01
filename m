Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0035A9E0E
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiIARdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiIARdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:33:10 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454A390C61
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:33:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p18-20020a170902a41200b00172b0dc71e0so12135977plq.0
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=ofkPShsbSyFZI8RD89m1othYee0wghfvC+xOO3506Ww=;
        b=f2dd3K7JeejrjsilIf7B/bJPMfWDAesXu74GJj5UL5npsZ7j6ECo4hfl8eZJB/bNr3
         bCdkXlUWwDY6FJNayKbHXBSl2B8PDA5tdlW2msiT3NoNm4HmjyaBEeGzlyiyjn5rnxZ4
         x8FPhCZ8agVZtma2hSpCkQ4MqpAyumxQUFlpVImng5LLoStpvYNZDxOVJetkEHnN4Psn
         8fc7dncVnaSCBIo+BZ4MoBd/NJLiK4AdFy/0T8gXysm5dZO6tHNKbWoN7o90lBA2G+Ys
         TI1GTbTnjTe4wn0NvwvBWRH2jesFS/3QxI/DLTPdIptUvfv4oJPvutgdLoa8wIN6Te/j
         I0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=ofkPShsbSyFZI8RD89m1othYee0wghfvC+xOO3506Ww=;
        b=udo00JGpJYgilZF6K5eJQDCjcZjg2/BVl7Cw+ngUv9ERFHb523JqHzeXiH8+gjROuB
         BDHmnjAiPKwT9gkpAjhYn9zi++S49xIyQCwwMiEMn+1clZbNgOCsf2ZAIWBEYD7rXhT/
         UBKIxZkL7HmCLRU4oOulVthyoJPBLKnAYvzyw/m8Y1Zeg78gwuqbY+1mAXzwVh85wUhG
         y48FRMzUL+nGJHmZNSg/hIUCTk67017w4JlSd6y5zVu70iP8VLM+0X0nn3IS8nYmlSck
         823j4ZJGrNY4PtUvQzHj/slqVZULXv0pRAWbbL7l+2HhtmL79JlXJ2CpL49e+GShxxjq
         zLtA==
X-Gm-Message-State: ACgBeo1ap2hYGJyqSoWxIl8D0NSqNhPqiRQked0eQUiQpxa2mR5WEFcj
        y9T6P2mnjwOyFdngzm/6xzLkpIviTCk=
X-Google-Smtp-Source: AA6agR4P+E5miP9Nzqe0YpKuXmcmAYUmB55ligejTXr1uwXWZNlQ62OIme5k2Kuvg5q1JpWRl1OlVS+7czk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e655:b0:1fe:4ec3:aba with SMTP id
 ep21-20020a17090ae65500b001fe4ec30abamr236338pjb.182.1662053582852; Thu, 01
 Sep 2022 10:33:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Sep 2022 17:32:54 +0000
In-Reply-To: <20220901173258.925729-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220901173258.925729-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901173258.925729-2-seanjc@google.com>
Subject: [PATCH v4 1/5] perf/x86/core: Remove unnecessary stubs provided for
 KVM-only helpers
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

Remove CONFIG_PERF_EVENT=n stubs for functions that are effectively
KVM-only.  KVM selects PERF_EVENT and will never consume the stubs.
Dropping the unnecessary stubs will allow simplifying x86_perf_get_lbr()
by getting rid of the impossible-to-hit error path (which KVM doesn't
even check).

Opportunstically reorganize the declarations to collapse multiple
CONFIG_PERF_EVENTS #ifdefs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/perf_event.h | 53 ++++++++-----------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f6fc8dd51ef4..f839eb55f298 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -525,46 +525,18 @@ extern u64 perf_get_hw_event_config(int hw_event);
 extern void perf_check_microcode(void);
 extern void perf_clear_dirty_counters(void);
 extern int x86_perf_rdpmc_index(struct perf_event *event);
-#else
-static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
-{
-	memset(cap, 0, sizeof(*cap));
-}
 
-static inline u64 perf_get_hw_event_config(int hw_event)
-{
-	return 0;
-}
-
-static inline void perf_events_lapic_init(void)	{ }
-static inline void perf_check_microcode(void) { }
-#endif
-
-#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
+#ifdef CONFIG_CPU_SUP_INTEL
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
-#else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
-static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
-{
-	return -1;
-}
-#endif
+extern void intel_pt_handle_vmx(int on);
+#endif /* CONFIG_CPU_SUP_INTEL */
 
-#ifdef CONFIG_CPU_SUP_INTEL
- extern void intel_pt_handle_vmx(int on);
-#else
-static inline void intel_pt_handle_vmx(int on)
-{
+#ifdef CONFIG_CPU_SUP_AMD
+extern void amd_pmu_enable_virt(void);
+extern void amd_pmu_disable_virt(void);
 
-}
-#endif
-
-#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
- extern void amd_pmu_enable_virt(void);
- extern void amd_pmu_disable_virt(void);
-
-#if defined(CONFIG_PERF_EVENTS_AMD_BRS)
+#ifdef CONFIG_PERF_EVENTS_AMD_BRS
 
 #define PERF_NEEDS_LOPWR_CB 1
 
@@ -582,12 +554,13 @@ static inline void perf_lopwr_cb(bool lopwr_in)
 	static_call_mod(perf_lopwr_cb)(lopwr_in);
 }
 
-#endif /* PERF_NEEDS_LOPWR_CB */
+#endif /* CONFIG_PERF_EVENTS_AMD_BRS */
+#endif /* CONFIG_CPU_SUP_AMD */
 
-#else
- static inline void amd_pmu_enable_virt(void) { }
- static inline void amd_pmu_disable_virt(void) { }
-#endif
+#else  /* !CONFIG_PERF_EVENTS */
+static inline void perf_events_lapic_init(void)	{ }
+static inline void perf_check_microcode(void) { }
+#endif /* CONFIG_PERF_EVENTS */
 
 #define arch_perf_out_copy_user copy_from_user_nmi
 
-- 
2.37.2.789.g6183377224-goog

