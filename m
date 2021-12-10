Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A35F4701C2
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbhLJNjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238746AbhLJNjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF023C0617A1;
        Fri, 10 Dec 2021 05:36:07 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x7so6899398pjn.0;
        Fri, 10 Dec 2021 05:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sT4BTdsaYQnUgB11mSNSzl3RhfDk7KFXXBMaleAwSfQ=;
        b=qs6BKu+4h4lgivt9jIhjIz/JcEgAk56iItuSli21vFCli0fBF/1O1KPq/SKkVrTYor
         CsTDib17UOU5ewpBjzP3Lj6dTO1g/yT18umS+3GaukmwRaL5BSZHM2/P06WtTkrNGHq0
         sqPel+Jpq+xzQC5DgWSX76s7VPt5NVkvENGEN7+xd3GU0EyS83VhYXQC5b55CmYqoInk
         0MUjfwl6RkjDep88JNP+n3FhTo240rG95pbUmhjckPn0GNVnHD/mQr1uxOaIF8g38JY2
         Gfx7wNV/BAVoTYUzpOyq1JaDfTzTyPZ3/WvN8IHQS+SRFBpZ1W9W9vXVzczm/xVLJ8rY
         ef+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sT4BTdsaYQnUgB11mSNSzl3RhfDk7KFXXBMaleAwSfQ=;
        b=UtRH4ivTpNSYJ1nC3RkAymvWujSAxnG/N+xs02832uhhTYTQhTqfsHMKETSJUzqAeg
         bZnA/Gmo/Iy7w+438qx7Jc4Lzv6vuTQFFxsaQmZ48SHMeIKS/TEMJCN7gF8z+QE3atFs
         8e45Ls6YggRfpFaFe/HOiCUY78oMYKl5f+gG3oUKppTqUlUvdeCfrbP94/e0QxZCnn0R
         GqqfiDMjdzW+lSGelN/iOZ2XpATLgQlTvYwgfYGx1+Wi3rgK+SjGTWvXlLR2ZZuC5HOi
         80eKPzMi51E8TLqIbPggxOUaYeGLdWT7nUfbuK/TD22hKajeYel/4XdbSaFnTL3/E5HK
         ZeRA==
X-Gm-Message-State: AOAM532pS70jDuP4iEKC1SPuG8H97afSkfyJLYXgT56LtUzIJK11SJ4M
        TVY80LfwH3jW42AuQpsNMsw=
X-Google-Smtp-Source: ABdhPJyyVLwq11n/T57Bn4o8gD89FG6M+zv3MDwSb1SJOp7Mn0kO+0WIt8uk6oFmKMhjGy+3b9KQfg==
X-Received: by 2002:a17:90b:3ecc:: with SMTP id rm12mr23839757pjb.75.1639143367463;
        Fri, 10 Dec 2021 05:36:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:07 -0800 (PST)
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
Subject: [PATCH v11 08/17] KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
Date:   Fri, 10 Dec 2021 21:35:16 +0800
Message-Id: <20211210133525.46465-9-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When a guest counter is configured as a PEBS counter through
IA32_PEBS_ENABLE, a guest PEBS event will be reprogrammed by
configuring a non-zero precision level in the perf_event_attr.

The guest PEBS overflow PMI bit would be set in the guest
GLOBAL_STATUS MSR when PEBS facility generates a PEBS
overflow PMI based on guest IA32_DS_AREA MSR.

Even with the same counter index and the same event code and
mask, guest PEBS events will not be reused for non-PEBS events.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/pmu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a20207ee4014..8934261e9563 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -58,15 +58,22 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	bool skip_pmi = false;
 
 	/* Ignore counters that have been reprogrammed already. */
 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 		return;
 
-	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	if (pmc->perf_event && pmc->perf_event->attr.precise_ip) {
+		/* Indicate PEBS overflow PMI to guest. */
+		skip_pmi = __test_and_set_bit(GLOBAL_STATUS_BUFFER_OVF_BIT,
+					      (unsigned long *)&pmu->global_status);
+	} else {
+		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+	}
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 
-	if (!pmc->intr)
+	if (!pmc->intr || skip_pmi)
 		return;
 
 	/*
@@ -97,6 +104,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  bool exclude_kernel, bool intr,
 				  bool in_tx, bool in_tx_cp)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -108,6 +116,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
@@ -122,6 +131,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		attr.sample_period = 0;
 		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
+	if (pebs) {
+		/*
+		 * The non-zero precision level of guest event makes the ordinary
+		 * guest event becomes a guest PEBS event and triggers the host
+		 * PEBS PMI handler to determine whether the PEBS overflow PMI
+		 * comes from the host counters or the guest.
+		 *
+		 * For most PEBS hardware events, the difference in the software
+		 * precision levels of guest and host PEBS events will not affect
+		 * the accuracy of the PEBS profiling result, because the "event IP"
+		 * in the PEBS record is calibrated on the guest side.
+		 *
+		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
+		 * could possibly care here is unsupported and needs changes.
+		 */
+		attr.precise_ip = 1;
+	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
 						 kvm_perf_overflow, pmc);
@@ -135,7 +161,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
-	pmc->intr = intr;
+	pmc->intr = intr || pebs;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
@@ -161,6 +187,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
+	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
+	    pmc->perf_event->attr.precise_ip)
+		return false;
+
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
 	perf_event_enable(pmc->perf_event);
 	pmc->is_paused = false;
-- 
2.33.1

