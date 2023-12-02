Return-Path: <kvm+bounces-3190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A44C980187A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 606C2281485
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3CAC3D87;
	Sat,  2 Dec 2023 00:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LwYKKOV5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C610F4
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:30 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-28654a46803so1865360a91.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475470; x=1702080270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IlV9aHgXCDr1PCq/OJiSpLXuk1u3KjEQF1oNVvd8opE=;
        b=LwYKKOV5Ckke8o2P+FmOkZfdVSozdktgsUGHls2/Lz7I7XkQhAyidKTec6qmG4/lXF
         P7fNQp/RcfX4qdJ2efuQ14RH+Hv/ljm4s/2OgGXsDp4khSczuHd15lc2NrbVSIPXobJN
         irjjaL7/UAJx8qmziVc93KzIqeLFSy4JwHeg6KxIsFZrQgNKGSf2WmqHAezhNxpLViHR
         DQhQqRmYnuTsIBMEM0WBXx2rONcAquU1IQBZxgRnKh4nu/pm/ehr340ndhOhQ1VhCeLK
         aoocImMQKxXCzx1TohhPu3PdT1A8tv3bX5WSbpMGnpD3/qB2BGkLCs26tOGaB1hawgkw
         OyCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475470; x=1702080270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IlV9aHgXCDr1PCq/OJiSpLXuk1u3KjEQF1oNVvd8opE=;
        b=XAjJp0qBwwOxk2RVGpnA5ei1Mna5TBLaEf1PEp4B7XUq+hh16HsNQpdYISJ13Ij+X5
         JnkQ9uKrPRuKviyoK5gwlcnne3Igu6WXjSUnQZ7pHl5QCv6LkJqmLV/MDbXeCmMwRNB6
         tKsolzC1oGIcX+TxP5ZGtMW5VUqTNdCo/UnfdRNDa41GD4panhyUurPDOEvzNRdgivhQ
         ZQ/MsQYu+gK3zzOgYo77TnsQVperf6+PpPxdFiWwXM7HJZgBvUop1K8O11yIDGiuggOX
         zrIBWScz/ECw7Fnin/pIShu49RrXYwPtu7P54S3jLSonsPrJ4LrjOebZq29QdH9XoYu8
         CPZA==
X-Gm-Message-State: AOJu0YysNUmEpstw7IUmBVhzztAcLzbeee3ZKf8FekszJs9AHzFxf3xp
	2WOeW5CXoE3qinQCFIK/pWqNJDS1dhg=
X-Google-Smtp-Source: AGHT+IHe73U04LFyU3cCC97hEmyqtqWWU+NyyoCwQ5gWdButyfA0mh42MPPXQN6XuuXmYJI+tvDCi+Uv4IQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7006:b0:1cf:cc0d:b295 with SMTP id
 y6-20020a170902700600b001cfcc0db295mr3418209plk.13.1701475470418; Fri, 01 Dec
 2023 16:04:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:54 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-6-seanjc@google.com>
Subject: [PATCH v9 05/28] KVM: x86/pmu: Get eventsel for fixed counters from perf
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Get the event selectors used to effectively request fixed counters for
perf events from perf itself instead of hardcoding them in KVM and hoping
that they match the underlying hardware.  While fixed counters 0 and 1 use
architectural events, as of ffbe4ab0beda ("perf/x86/intel: Extend the
ref-cycles event to GP counters") fixed counter 2 (reference TSC cycles)
may use a software-defined pseudo-encoding or a real hardware-defined
encoding.

Reported-by: Kan Liang <kan.liang@linux.intel.com>
Closes: https://lkml.kernel.org/r/4281eee7-6423-4ec8-bb18-c6aeee1faf2c%40linux.intel.com
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 98e92b9ece09..ec4feaef3d55 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -404,24 +404,28 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * result is the same (ignoring the fact that using a general purpose counter
  * will likely exacerbate counter contention).
  *
- * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
- * as there is no architectural general purpose encoding for reference cycles.
+ * Forcibly inlined to allow asserting on @index at build time, and there should
+ * never be more than one user.
  */
-static u64 intel_get_fixed_pmc_eventsel(int index)
+static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 {
-	const struct {
-		u8 event;
-		u8 unit_mask;
-	} fixed_pmc_events[] = {
-		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
-		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
-		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
+	const enum perf_hw_id fixed_pmc_perf_ids[] = {
+		[0] = PERF_COUNT_HW_INSTRUCTIONS,
+		[1] = PERF_COUNT_HW_CPU_CYCLES,
+		[2] = PERF_COUNT_HW_REF_CPU_CYCLES,
 	};
+	u64 eventsel;
 
-	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
+	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_perf_ids) != KVM_PMC_MAX_FIXED);
+	BUILD_BUG_ON(index >= KVM_PMC_MAX_FIXED);
 
-	return (fixed_pmc_events[index].unit_mask << 8) |
-		fixed_pmc_events[index].event;
+	/*
+	 * Yell if perf reports support for a fixed counter but perf doesn't
+	 * have a known encoding for the associated general purpose event.
+	 */
+	eventsel = perf_get_hw_event_config(fixed_pmc_perf_ids[index]);
+	WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
+	return eventsel;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
-- 
2.43.0.rc2.451.g8631bc7472-goog


