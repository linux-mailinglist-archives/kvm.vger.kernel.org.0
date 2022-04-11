Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD74FB958
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345330AbiDKKXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345331AbiDKKWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D9242ED6;
        Mon, 11 Apr 2022 03:20:11 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b15so14210910pfm.5;
        Mon, 11 Apr 2022 03:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z2iqtu3MCtqxHONgz3FeIAzZYoJ5MOlkFMWxQni3C+o=;
        b=MP1E90YwpZvurBGQoEmG9gJk6cx1VNlanyIqbIjqDKJ2kWqcdomVwZeroEJ+4dnntf
         qy/iRhKa62Yj325arHjfqmtC83/8NP2oMe6w9tj9xsaSEvkyXqlgkzmQgrdojHudrF73
         Fa0oBqxg6M8bJ1+5kwJqxGLwScVlqRjuX4qzQQ6FCzjxwtlrXdjLb+0574wckKUpD/E0
         19zHaJ3wpNOVoPUGLpwH4uTMku7BgnzFfj06rUGT697imRCnGtd1wenmrbdJ/6OeFsgy
         dVkIHDFe0/7+vmIfnDpOSh2Ir7V+XAQYZU+U+NefrG8N9ojCCnnZwWBW1yKATivuTY4q
         QK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2iqtu3MCtqxHONgz3FeIAzZYoJ5MOlkFMWxQni3C+o=;
        b=slVj8mJ3pQPMS0FdVPyx/MQrLhnGAipj8Zw0HCG8D33rjP6cUppjFfLVW9kvUyf3ZY
         G44DwoQhnCQmHP5NWwN5qy5iVFnsGYnlLfq31GazFgTJeN3P4kSEz9K9F19guHRIcd2N
         RliyNC49KMhFlYZqvb5sXxsvlOkeLlcyxsWEvzkHRgxxkRSeINYPaR4Ostnrpr2Xaliq
         04kIc7lkQ7hATsvYn9m6KGzSValePXnmH+oL5VeIZ8qgdqS2MAdcCaU/GmKFFT7LNlTO
         CgqOgoUpFZA3Pqf+VEI84qMxJOhfAN3rUpigWSf+wyYuw6eouaaCAGCZ+ZqT7YhXg2gG
         x0bw==
X-Gm-Message-State: AOAM533eOlUHgbtGA9iXQBeNp7stqAdfUziq7nxSg4vIUCZ7psPnrV3V
        D3POOEguLWSBm5kIbJAAqxM=
X-Google-Smtp-Source: ABdhPJyd2439CLyF0Bn7SWZxlagBLucpztQRQtITeO6C/TkVzPQG1wHuJq8+tBVbtnGZ9cS7d9pn8Q==
X-Received: by 2002:a63:1c22:0:b0:385:fcae:cb3f with SMTP id c34-20020a631c22000000b00385fcaecb3fmr26100814pgc.102.1649672410237;
        Mon, 11 Apr 2022 03:20:10 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 06/17] x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
Date:   Mon, 11 Apr 2022 18:19:35 +0800
Message-Id: <20220411101946.20262-7-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

The value of pebs_counter_mask will be accessed frequently
for repeated use in the intel_guest_get_msrs(). So it can be
optimized instead of endlessly mucking about with branches.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 14 ++++++--------
 arch/x86/events/perf_event.h |  1 +
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 039e4e7cbc2f..4a3619ed66d1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2932,10 +2932,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 * counters from the GLOBAL_STATUS mask and we always process PEBS
 	 * events via drain_pebs().
 	 */
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		status &= ~cpuc->pebs_enabled;
-	else
-		status &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	status &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
@@ -3981,10 +3978,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
 	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
 	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	if (x86_pmu.flags & PMU_FL_PEBS_ALL)
-		arr[0].guest &= ~cpuc->pebs_enabled;
-	else
-		arr[0].guest &= ~(cpuc->pebs_enabled & PEBS_COUNTER_MASK);
+	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
 	*nr = 1;
 
 	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
@@ -5688,6 +5682,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -5872,6 +5867,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6229,6 +6225,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6271,6 +6268,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index bf23cbe4f6cf..9e1bef9c2b0c 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -825,6 +825,7 @@ struct x86_pmu {
 	void		(*pebs_aliases)(struct perf_event *event);
 	unsigned long	large_pebs_flags;
 	u64		rtm_abort_event;
+	u64		pebs_capable;
 
 	/*
 	 * Intel LBR
-- 
2.35.1

