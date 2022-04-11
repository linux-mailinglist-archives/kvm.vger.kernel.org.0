Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3054FB978
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiDKKYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345383AbiDKKWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:39 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920954339D;
        Mon, 11 Apr 2022 03:20:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q142so13748801pgq.9;
        Mon, 11 Apr 2022 03:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MglEhREufqOz6ECjIz7gIuhKtasDE7aAeqJpWaH1wQw=;
        b=Ca7UciFkpcK0fE8IfKwqPYpXjKHHJbDVps1xVdNoJLf55d3gI7gvzP2Z5AWzu6x68i
         OnQ8iMv2eyHWR1ksIrmOAlMP4ufJrsyzCdZX0qJvSm3iZZP0hYmNfNuhaL9AyOkZltZw
         MFUxyBQM8Hkbl8uXxCWQC1In6/iyEavCO3h/B047zLiVFnoh8nTBpsEjfqdcRHZgD5IT
         bSXYoIGJIKY6k+vd5LkM3DiYjGmsA+iGI4GSeK2nAuWnHIV+9/Kb1cWOL4H80MRvNfqM
         hEFTZetCtZuPEioD4R4G2u92mAxkDOV8dldiyhXSfnXyTtOvNt874mEk71B5rEtYY3JX
         ENKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MglEhREufqOz6ECjIz7gIuhKtasDE7aAeqJpWaH1wQw=;
        b=cz+CB/800o6/et0Qtk6LX0qWa31kVHj1/aAT0dAcykftgqGwI+aR5VPwcmv/cud2Fd
         ptm78NvDvTbrmSp8U0G8ScL3AR68uTZpNIrG8uNOk4lAS9+fAPGQY95KlM+clPBKytjb
         2mmAQ2cMafMTWrSXuxb5o5cXPMw3ywjooKhFfT9nxKELzv6YCYrnICBymmo1Vk4VnOZ0
         Sepq2lE2bSnqy1futlgdJDbmoUfCTz1gZIPj/3/JssbXeXpiqUVeujRr5dnzkmZq5xGZ
         p4zwooKsmATEJeODevxyutobG1Z+OPc41t7ahnQhKvTsVNuIVMUfmyYnFyjIc9OWsoUi
         GC3g==
X-Gm-Message-State: AOAM530TuY2T4OiLNsh6AXmT6rkN6B162pYlpZtc14NOIHfYXinmEBsN
        fZinH6oT1xo7RIAR6OBnRFQ=
X-Google-Smtp-Source: ABdhPJxnIZ5n5ZQBRFsQtrc+f1t5KSZf7D6lA+6uTfi8x4UyJtcEkGU81humOmS+5dAFXjg3BkLvxQ==
X-Received: by 2002:a63:7c4e:0:b0:380:8ae9:c975 with SMTP id l14-20020a637c4e000000b003808ae9c975mr26522585pgn.25.1649672416765;
        Mon, 11 Apr 2022 03:20:16 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:16 -0700 (PDT)
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
Subject: [PATCH RESEND v12 08/17] KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
Date:   Mon, 11 Apr 2022 18:19:37 +0800
Message-Id: <20220411101946.20262-9-likexu@tencent.com>
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
index 618f529f1c4d..36487088f72c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -86,15 +86,22 @@ static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
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
@@ -124,6 +131,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
 				  bool exclude_kernel, bool intr)
 {
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -135,6 +143,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
 
 	if (type == PERF_TYPE_HARDWARE && config >= PERF_COUNT_HW_MAX)
 		return;
@@ -150,6 +159,23 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 */
 		attr.sample_period = 0;
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
@@ -163,7 +189,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	pmc_to_pmu(pmc)->event_count++;
 	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
-	pmc->intr = intr;
+	pmc->intr = intr || pebs;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
@@ -189,6 +215,10 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
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
2.35.1

