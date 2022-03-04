Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F94CD0A2
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiCDJFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiCDJFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85768194A85;
        Fri,  4 Mar 2022 01:04:47 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o8so6978808pgf.9;
        Fri, 04 Mar 2022 01:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tG9QVYguScnvN93HMaVeuxERBtJckq0WH2ekKGOb1E=;
        b=Xg49WBsNpepfy18BeAlE5EQfta82gxeFzvNztlPvMK92GrKf74GEIoqi3HCtHKSbaz
         1QnjlZL+9bD9Cxg6dhvs1+9cdSymWPByxFEAVYep1Rs79LhgFP6ZWadzPuC/gvNO5mJz
         73ktRmZLwCFrGMwmudw9Yl2is9ZbVZ3NH+0RoYCcee+U4lGVqMB5RKr3ZgEGrGLLFkKa
         Z+YaRYWSLEpxcGuuNCbD6o3xqJHgAcRoDMmgC9XdNTChb2+YAyy8vmLFDjOVYqV8qGVw
         QJ5hc6SJ3/7sF5+WO45mVx7cymNS2JD4Fzqzio2Ut0oVoZNGWZdMagnEFsTBOn3UN+NR
         SUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tG9QVYguScnvN93HMaVeuxERBtJckq0WH2ekKGOb1E=;
        b=CFEmBp6f8Z1PG2glPl2kc4JyXrX9P413vRSaYBKl/Cu97pfnSCA4cNHjMZhkASbjKj
         qNGELOGyO0r5xaO7XXVLbahgOgnuT5G2A26lvHizYVXhqAMhLnOleja9mvKIqDnERiNr
         LRhN3324iY3QbYq5ik1x5sAwWP1i9xZJkzrsT850EPLfC7Se1+dtUQeYn5zHi63uAgwS
         mOMFD9CEvpJg+Dvq0ktXlAMuJ+qzNnvT/wJV92vHC4lhkd3w2G29skC6kZf2R5Uau5lJ
         xvAxtQ9woRHNKWoYewMka6xFLr6zU2/Ym7ArkbeRiaFijbXgzD1H/VSYf1399TNTHnPd
         KErA==
X-Gm-Message-State: AOAM532QGmf9ehRC5WzFnR1JL/sLGVjVF6vBPwFxuk7XWnkI36SwJBTY
        lcn3yRNRpB9ZF3h4CeuX40Q=
X-Google-Smtp-Source: ABdhPJx8A3VBpXvulqeJaYX3i/sb6qfxG/9ntFJqm0Nv5TYdwtIWdklLz36ZFcTi8HVo7ODYclb8Bg==
X-Received: by 2002:a05:6a00:1146:b0:4c9:ede0:725a with SMTP id b6-20020a056a00114600b004c9ede0725amr42849425pfm.35.1646384686773;
        Fri, 04 Mar 2022 01:04:46 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:46 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 02/17] perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
Date:   Fri,  4 Mar 2022 17:04:12 +0800
Message-Id: <20220304090427.90888-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

With PEBS virtualization, the guest PEBS records get delivered to the
guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
to distinguish whether the PMI comes from the guest code like Intel PT.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The fake event causes the KVM PMI callback to
be called, thereby injecting the PEBS overflow PMI into the guest.

KVM may inject the PMI with BUFFER_OVF set, even if the guest DS is
empty. That should really be harmless. Thus guest PEBS handler would
retrieve the correct information from its own PEBS records buffer.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7723fa6ed65e..da4b77f6c6a4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2831,6 +2831,47 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+/*
+ * We may be running with guest PEBS events created by KVM, and the
+ * PEBS records are logged into the guest's DS and invisible to host.
+ *
+ * In the case of guest PEBS overflow, we only trigger a fake event
+ * to emulate the PEBS overflow PMI for guest PEBS counters in KVM.
+ * The guest will then vm-entry and check the guest DS area to read
+ * the guest PEBS records.
+ *
+ * The contents and other behavior of the guest event do not matter.
+ */
+static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
+				      struct perf_sample_data *data)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	struct perf_event *event = NULL;
+	int bit;
+
+	if (!unlikely(perf_guest_state()))
+		return;
+
+	if (!x86_pmu.pebs_ept || !x86_pmu.pebs_active ||
+	    !guest_pebs_idxs)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
+			 INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, data, regs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		break;
+	}
+}
+
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
@@ -2882,6 +2923,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		u64 pebs_enabled = cpuc->pebs_enabled;
 
 		handled++;
+		x86_pmu_handle_guest_pebs(regs, &data);
 		x86_pmu.drain_pebs(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
-- 
2.35.1

