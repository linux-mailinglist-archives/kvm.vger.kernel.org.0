Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B9A68F8F7
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 21:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjBHUml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 15:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbjBHUmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 15:42:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642B430E9C
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 12:42:38 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id e11-20020a17090a77cb00b0022925dd66d3so1819026pjs.4
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 12:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zVWDTl0p8IeLDiHH3ugnUoxZ7xfcxn6x+ZxiZsMm1KE=;
        b=WPwZTTT6W7rLlFyK6g3SZsOgRN4KF7X/gJI2mYv+nPqGya9GQYbpivlSLH7pxH9ReX
         Ycdy8GW7qw+hGfGzLdCkUTd5iDSAauj/h6Ta0mQ+tV54mqO68SlssteuZua90Gqp8+iR
         1Ezxx37QtpW0xG/k04jRWUcTDKBevogtVIw3hP6+4gpF/SE7hg7D5qWj+sMmB/YrhzrK
         HPK/ZXkpi1YeeeU1K1SP+96nsuGS+m/RLcT629dZDIFpVqGIWFK3/0hEEUd0eeVgJeV0
         9ZWh2ox8GKZgGtzKvqPkjzx6S+JtjJl+pmb6UWELdgL0+6zcJQx6M3FuA0dmRmJKUNtq
         tT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zVWDTl0p8IeLDiHH3ugnUoxZ7xfcxn6x+ZxiZsMm1KE=;
        b=hORSeuxFDmYejCJyLi8QeuQnZ5tSzGfRvdgqURjShREYpgGZpH/bSinBrWOHnd0OTG
         a75bTtUHrMJJ00qwKBLmug9GlpWAE24LrEQSZ10EmXq0qO0GBh8b+b+MQgqKgz61Pb0i
         vg4Z3XNDpJW7L34vPgMI2wh1elVJl/dm0TpgP3BV6ymTQiNxgAYs1uWuSDXRKNntF9IO
         /Uuo6FYDMHEBlbBJPuTWAH0MpgkoXPonzJiGCaQHGN2t4DCRFg/aYnuWcLd0mklR7pdN
         NnNud8anCsymVW9Ue0m1m+t/x4HcwF8n2f8m0C05Nk/432h0x9LKYY0bQhR4vvmrrWfe
         +FDQ==
X-Gm-Message-State: AO0yUKWKKKmhYJ64YBjaeoGxvEGyiksWIWpUHOLterkXSrme8iMjoAFr
        0ThJ+xHRcFVDKXXKTrWZxeG3yX/Wg2I=
X-Google-Smtp-Source: AK7set/9M5lzkaYsVmbNoMuDWODbJ+CjIGMp3PmwMVqe+KA05wUxJoqkdvyG+iyqxk3/KTf1kMRS0WpkVGc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:701b:0:b0:4fb:3ee3:3a6a with SMTP id
 l27-20020a63701b000000b004fb3ee33a6amr384194pgc.125.1675888957652; Wed, 08
 Feb 2023 12:42:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Feb 2023 20:42:30 +0000
In-Reply-To: <20230208204230.1360502-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230208204230.1360502-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208204230.1360502-3-seanjc@google.com>
Subject: [PATCH v2 2/2] perf/x86: Refuse to export capabilities for hybrid PMUs
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
        kvm@vger.kernel.org, Jianfeng Gao <jianfeng.gao@intel.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM disables vPMU support on hybrid CPUs, WARN and return zeros
if perf_get_x86_pmu_capability() is invoked on a hybrid CPU.  The helper
doesn't provide an accurate accounting of the PMU capabilities for hybrid
CPUs and needs to be enhanced if KVM, or anything else outside of perf,
wants to act on the PMU capabilities.

Cc: stable@vger.kernel.org
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/all/20220818181530.2355034-1-kan.liang@linux.intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 85a63a41c471..d096b04bf80e 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2974,17 +2974,19 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
-	if (!x86_pmu_initialized()) {
+	/* This API doesn't currently support enumerating hybrid PMUs. */
+	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
+	    !x86_pmu_initialized()) {
 		memset(cap, 0, sizeof(*cap));
 		return;
 	}
 
+	/*
+	 * Note, hybrid CPU models get tracked as having hybrid PMUs even when
+	 * all E-cores are disabled via BIOS.  When E-cores are disabled, the
+	 * base PMU holds the correct number of counters for P-cores.
+	 */
 	cap->version		= x86_pmu.version;
-	/*
-	 * KVM doesn't support the hybrid PMU yet.
-	 * Return the common value in global x86_pmu,
-	 * which available for all cores.
-	 */
 	cap->num_counters_gp	= x86_pmu.num_counters;
 	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
 	cap->bit_width_gp	= x86_pmu.cntval_bits;
-- 
2.39.1.519.gcb327c4b5f-goog

