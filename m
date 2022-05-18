Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8C152BBC2
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiERNZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237909AbiERNZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA670A5AA4;
        Wed, 18 May 2022 06:25:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q4so1739297plr.11;
        Wed, 18 May 2022 06:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5rJYKB50pqwoRKSdVNgGM4Ug4UmJXRZvOCRmjAZMIK8=;
        b=a7Q0hcuUejglF/nUBx3FEUNOPWv/CgJ7paV/YyBks6cCNp9/9h0yVHtOcn/kRaCxjs
         s/QerGzPZnIEeT/MdOUwNEAJipS5dK3eOs2jN0s99zLR2cUrjEpyyat4SphODbVxlfzq
         Y5ZmJRcWu7ph/6y6Vm4H1h3tdHvjEogYyuULXiWIZ/RGC+yAITXljg4lvGJcs6Z5kleY
         wqy1VbPYy0UxuFp4qokfaMCl86RNPoulONOSjOc+OlRNH3x/3l3Zz3Rp1nuxO1CMjGiP
         pKolpI4pDWrSByap6Wsj/AUbZID5WrbkAbSx2auHpm4X+Rh77X8EZlARsfkfGDm5w1S8
         VjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5rJYKB50pqwoRKSdVNgGM4Ug4UmJXRZvOCRmjAZMIK8=;
        b=su8maLCYuagcmP9uX6ZC1MZjUYMPwZNai3AcqrKTIVXwQfM1j9RNypgHl9kMp124lH
         tInh+CnBqmF5Bx4asZmrbjTzpOd80y/cXr/osgSoW+AKVbwwdOvPipvofzcpDPTwzRnO
         4eMIZQPzxmOIHA0mPWerzPOwQ0Xk2oWKexan0OZJEuVeUuoM39zj0wtk4QiwmEqV2EGc
         2wKbeIY9mzRJCf/tIPtRKYnRWur7Vvp/Y/L3ZJyF7OHBGlJQymyGLcKWvpAUkJdrcemz
         fxtUjvAkk2z1FspINtBL3AeQSWmrHaTjQiZzLTj5k3jalX+XcEjuEz8CdxqcfQeAt/9q
         lMzA==
X-Gm-Message-State: AOAM5332zpWlloabBauKGOhxHG86KUCBmfnEB8V3drrHIg4FhLit3kMe
        rnWWVbz1zD4dMlgx9dsCmyY=
X-Google-Smtp-Source: ABdhPJyFaoda7Yd+qN6bKSH010pp1lvQOIXW0axA5QCzcsIWBgr76ktxjosOG27Ilj9mHQOggFPSuQ==
X-Received: by 2002:a17:902:c40f:b0:15e:bc6b:6980 with SMTP id k15-20020a170902c40f00b0015ebc6b6980mr27090075plk.145.1652880338280;
        Wed, 18 May 2022 06:25:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:38 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 08/11] KVM: x86/pmu: Use PERF_TYPE_RAW to merge reprogram_{gp,fixed}counter()
Date:   Wed, 18 May 2022 21:25:09 +0800
Message-Id: <20220518132512.37864-9-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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

The code sketch for reprogram_{gp, fixed}_counter() is similar, while the
fixed counter using the PERF_TYPE_HARDWAR type and the gp being
able to use either PERF_TYPE_HARDWAR or PERF_TYPE_RAW type
depending on the pmc->eventsel value.

After 'commit 761875634a5e ("KVM: x86/pmu: Setup pmc->eventsel
for fixed PMCs")', the pmc->eventsel of the fixed counter will also have
been setup with the same semantic value and will not be changed during
the guest runtime.

The original story of using the PERF_TYPE_HARDWARE type is to emulate
guest architecture PMU on a host without architecture PMU (the Pentium 4),
for which the guest vPMC needs to be reprogrammed using the kernel
generic perf_hw_id. But essentially, "the HARDWARE is just a convenience
wrapper over RAW IIRC", quoated from Peterz. So it could be pretty safe
to use the PERF_TYPE_RAW type only in practice to program both gp and
fixed counters naturally in the reprogram_counter().

To make the gp and fixed counters more semantically symmetrical,
the selection of EVENTSEL_{USER, OS, INT} bits is temporarily translated
via fixed_ctr_ctrl before the pmc_reprogram_counter() call.

Cc: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 87 +++++++++++++---------------------------------
 1 file changed, 25 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c2f00f07fbd7..33bf08fc0282 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -275,85 +275,48 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-static void reprogram_gp_counter(struct kvm_pmc *pmc)
+void reprogram_counter(struct kvm_pmc *pmc)
 {
-	u64 config;
-	u32 type = PERF_TYPE_RAW;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	u64 eventsel = pmc->eventsel;
+	u64 new_config = eventsel;
+	u8 fixed_ctr_ctrl;
+
+	pmc_pause_counter(pmc);
+
+	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
+		return;
+
+	if (!check_pmu_event_filter(pmc))
+		return;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	pmc_pause_counter(pmc);
-
-	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
-		config = static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc);
-		if (config != PERF_COUNT_HW_MAX)
-			type = PERF_TYPE_HARDWARE;
+	if (pmc_is_fixed(pmc)) {
+		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+						  pmc->idx - INTEL_PMC_IDX_FIXED);
+		if (fixed_ctr_ctrl & 0x1)
+			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
+		if (fixed_ctr_ctrl & 0x2)
+			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
+		if (fixed_ctr_ctrl & 0x8)
+			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
+		new_config = (u64)fixed_ctr_ctrl;
 	}
 
-	if (type == PERF_TYPE_RAW)
-		config = eventsel & pmu->raw_event_mask;
-
-	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
+	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
 		return;
 
 	pmc_release_perf_event(pmc);
 
-	pmc->current_config = eventsel;
-	pmc_reprogram_counter(pmc, type, config,
+	pmc->current_config = new_config;
+	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+			      (eventsel & pmu->raw_event_mask),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
 			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
-
-static void reprogram_fixed_counter(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
-	u8 ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl, idx);
-	unsigned en_field = ctrl & 0x3;
-	bool pmi = ctrl & 0x8;
-
-	pmc_pause_counter(pmc);
-
-	if (!en_field || !pmc_is_enabled(pmc))
-		return;
-
-	if (!check_pmu_event_filter(pmc))
-		return;
-
-	if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
-		return;
-
-	pmc_release_perf_event(pmc);
-
-	pmc->current_config = (u64)ctrl;
-	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      static_call(kvm_x86_pmu_pmc_perf_hw_id)(pmc),
-			      !(en_field & 0x2), /* exclude user */
-			      !(en_field & 0x1), /* exclude kernel */
-			      pmi);
-}
-
-void reprogram_counter(struct kvm_pmc *pmc)
-{
-	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc);
-	else
-		reprogram_fixed_counter(pmc);
-}
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
-- 
2.36.1

