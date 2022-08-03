Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64D25892B5
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbiHCT1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbiHCT1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6499458B59
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e23-20020a63e017000000b0041cc49e0ac3so335432pgh.0
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=M8ovGhzxNi7TT4QpXAtpoUmOo1wqUNy+ycPxrvboNqY=;
        b=PmTq74m3OAW+mdBUVHtZuRyPSZSQFiucZ6qIpbJfNFw8tuNx4AenCOZ4GC10Wvedux
         I6LtTBvTGanR9V0VSYyixRM+IFhE6rlu8kWOjOaOGZDwNmAJxceo0Km4DPAXg4H2E1rT
         mup74jwLSded8usdiM3BOpiType/StEUkhnhfDwlD1E7SoUwM3ejy2SWmj6aKOBV2XfH
         UbqBldM5ZdtkNHELr9Q8QJWBzLqxnWESbugkfAkvuzFaXq88g93ChcmNBJXiK9oWvh/9
         y1tWycthZEzuxuRPOIAIvlmvxqngWvuaUzMNOgJngA9NKq2H2KkIYOw7u48fGmz/AFCk
         YsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=M8ovGhzxNi7TT4QpXAtpoUmOo1wqUNy+ycPxrvboNqY=;
        b=BV4oiJZyKJiQLUurPoLfrZfLTwXEMeOnfuRBqJdxLJ5PR6ezteN7vVDG5eKLbdyJ2n
         tpqTxcsvvrGWysWMVWrRZ32vUD2xMIbF8Q206DXUuSW1IPCWYm4vQqF8++W2Ywr2tWnO
         J28SbKXcKF9FOCI646QvNV4oK9oZFN/SbDgHGn/VTcwEVLmzDVyKmI3S3grnQ2Oxb10p
         FShCqElTGn67TTCTRXcGsza6RDQvMgr77yV+uCplJhmwKxh4dcMYraqyGSbYnzWqUS2e
         xtbJ2tAeVieZqBbC/owMTjxuXc09aMsl0+zXHZiIv7XAomW5975tWhTCsPY2V1JFAAWg
         yPmw==
X-Gm-Message-State: ACgBeo1vC27De30p25o3ZB1tvs7YgR5kp6ONBLinBZsYYMp7Bhy4Gju2
        7tERoZeIk5y6QAOXRBzeDXaUbD11s5o=
X-Google-Smtp-Source: AA6agR62hcM0a/MWqBP3Ttz5aODILaJxPENcv1VXOYqSYQh+MQec1dO1rNpqdChbUfAtNZP3d/fSILQAdZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c8d:b0:1f5:29ef:4a36 with SMTP id
 my13-20020a17090b4c8d00b001f529ef4a36mr6536897pjb.127.1659554827779; Wed, 03
 Aug 2022 12:27:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:54 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 3/7] perf/x86/core: Drop the unnecessary return value from x86_perf_get_lbr()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index aba196172500..102fd3ad4605 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -512,7 +512,7 @@ extern int x86_perf_rdpmc_index(struct perf_event *event);
 
 #ifdef CONFIG_CPU_SUP_INTEL
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
-extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
+extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 extern void intel_pt_handle_vmx(int on);
 #endif /* CONFIG_CPU_SUP_INTEL */
 
-- 
2.37.1.559.g78731f0fdb-goog

