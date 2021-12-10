Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533CB4701C7
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbhLJNkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbhLJNjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:39 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6C8C0698C9;
        Fri, 10 Dec 2021 05:36:00 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x7so6899193pjn.0;
        Fri, 10 Dec 2021 05:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WjwTyGG9bV97hr7RCNl6Qo+GaIwTl4Nt2MWUdNajFQ=;
        b=CcpN/AAxyrtLTPWp47YxVqkooHEm4nAefiO3TD6hAvdTYZcEgfQB2pwzEh3q3nRKUy
         CegwUPRreGfcmU8GWz80gQoOCSvfsmP8A4DOtJnLc0cdbS5AhNRMr6Jdy5cAhsVW9xFx
         RFa8ficAW4cAQIrrtBwe6JW7ikimJs8VcRyjOsz6wIXcqu18Z4q2VFfnPXFHxzaeVAlk
         wAekjhJQTLHSH5L7sZOBsW61wDEZX6FbQZ0le+mcvi1Db6mry/BQlcsk7aRJYOTOzG1i
         mHwlZ9Rn0FLlvYAYlaTYcAC8B/tD016s7a27E2Vb5iBWcFvDbYcwghavBCu4qfGZbGyp
         k7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WjwTyGG9bV97hr7RCNl6Qo+GaIwTl4Nt2MWUdNajFQ=;
        b=cwq0Www7D90f7mzvLAnNyNzLxGciaOr+mWDEfOZSs1guujwyPpk/FCYO2GrzMJGnT4
         Ylp3RRd65CiF2ExE+GIYNkR3nR0wngpPuM6gCXIYzLYhBdI2u5PXtKZotWYQTLgnmQ/h
         CVF6XKAZe/CETbjM78ug24KT5PVZOjtys1DZ9f++9wwALaa7pkk+web1FCsxu7dNZr/l
         eqPK4aifXSm1bf2MFTIDPHpfMQGw3SbcWu6L2kx7xe/Tzjybv6muUBy4adYBpHN+O3qk
         hwCGl4/O0Q273bctSfSs+Oc+VOs/TjDgXjllS1CVktWqrsvfUN98mUOI2vzLZDsagsLO
         Lgxg==
X-Gm-Message-State: AOAM533StZot58cdn8cB61FW/cqiNceHrlwedq8IPwfKj/J8+xUssH0E
        pF3+nLqFNeBeAxER8+Z9irs=
X-Google-Smtp-Source: ABdhPJzq1BwOXtkwg4tu0exbij+FU0zNeKwzw4IHeaWNqeQ9MOvT0lZMuMvZ27pzC7Zon/wio94uYA==
X-Received: by 2002:a17:902:ba84:b0:142:5514:8dd7 with SMTP id k4-20020a170902ba8400b0014255148dd7mr76148916pls.87.1639143360492;
        Fri, 10 Dec 2021 05:36:00 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:00 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 06/17] x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
Date:   Fri, 10 Dec 2021 21:35:14 +0800
Message-Id: <20211210133525.46465-7-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Peter Zijlstra (Intel)" <peterz@infradead.org>

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
index 6721ccd9067b..c886e360698c 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2911,10 +2911,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
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
@@ -3963,10 +3960,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
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
@@ -5657,6 +5651,7 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+	x86_pmu.pebs_capable		= PEBS_COUNTER_MASK;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -5841,6 +5836,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.lbr_pt_coexist = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
 		x86_pmu.get_event_constraints = glp_get_event_constraints;
@@ -6198,6 +6194,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
@@ -6240,6 +6237,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_aliases = NULL;
 		x86_pmu.pebs_prec_dist = true;
 		x86_pmu.pebs_block = true;
+		x86_pmu.pebs_capable = ~0ULL;
 		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 		x86_pmu.flags |= PMU_FL_PEBS_ALL;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 21f84cc6a827..28ca0ada1616 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -824,6 +824,7 @@ struct x86_pmu {
 	void		(*pebs_aliases)(struct perf_event *event);
 	unsigned long	large_pebs_flags;
 	u64		rtm_abort_event;
+	u64		pebs_capable;
 
 	/*
 	 * Intel LBR
-- 
2.33.1

