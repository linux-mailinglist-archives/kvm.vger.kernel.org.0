Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D05A9E16
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbiIARdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiIARdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:33:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE44915C6
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:33:05 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3449870f0e4so11621757b3.6
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=XJr3O/WjgV8Oj3RFIIU2dPA6nPGu/zK6BlwHM7Oxyas=;
        b=H1oG9tgaAu/9JBqRdtDauWPCTkTGEaRUb/l2jm4jF+TLNO/awsbefo2B9gw8Qm7Ntg
         APvLhm7mKKZy3n8scjtSgSKJemYEosybLpxGKSldb5B1R6SgLPYp0AJKgais1fFcbWMY
         fTuBaygpXb4K4p7wDQV3Ll19FPxK7g0pTNmqS4T5NSd+XfkLsXZOGH/Slwq9Ot02eGD0
         uBnuFW3f6DHdgw9W9FkmGy+SEgJqPK10yy9knuGR2wXV6VR3Jtfhb9zlY+U8Y6+fD7Wq
         rxVk9pJTZTEcxaeuWXnoEoVZNvmObK6iD2jrqE3lDA6pirseIWkp3Co0erfAnzQ+Elbd
         vlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=XJr3O/WjgV8Oj3RFIIU2dPA6nPGu/zK6BlwHM7Oxyas=;
        b=WTnmsgxv2H2r/Ig7398AsB5umnnQT3T0okZQg/r2FfTkKwDnycw89qH6g5YE+oAx/x
         Ql7w4lmswaTHGazXQHMN+S9hIojBPg9mkAXJdWglT31/s9t/ZRGv4QEq99N9WwhLO6O1
         8xkzzhs/2AbCNdYuOZJPH7SeQxNH8EQSzsVe+7joas7V+axSovnGaSKKfxC1QlJLkQvw
         9mB/oIhPXhgaO3EtvGVdx46fLnS2LDovwEm6HshofP2Gh6iu1rreJt9YOvPr7LmvaCim
         ZgqPzsEzXDeTtEpJjuTy5UuEhdsEq/5FIEuCMiecHQFYDcmW+5zLftINbJ++5GKOkJ3i
         GGSw==
X-Gm-Message-State: ACgBeo2Z49Tmqy2pAbi3K7YhsP+brGKyrAQFtWh5mtq3aY0D430WTVKo
        oS5lQFWc0bmqdjexu0ra8K/PxfShIjE=
X-Google-Smtp-Source: AA6agR5+qsfqUATGChKbujBDj8Kjg/Yf52WCNi49j0HSHvk7YqI6GPmJk02FO34aTzjM2gKWvJR6fbxq+b0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:bb8d:0:b0:696:340c:a672 with SMTP id
 y13-20020a25bb8d000000b00696340ca672mr20209148ybg.332.1662053584444; Thu, 01
 Sep 2022 10:33:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Sep 2022 17:32:55 +0000
In-Reply-To: <20220901173258.925729-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220901173258.925729-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901173258.925729-3-seanjc@google.com>
Subject: [PATCH v4 2/5] perf/x86/core: Drop the unnecessary return value from x86_perf_get_lbr()
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
        autolearn=ham autolearn_force=no version=3.4.6
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
2.37.2.789.g6183377224-goog

