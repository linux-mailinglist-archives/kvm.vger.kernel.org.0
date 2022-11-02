Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04416170EF
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiKBWwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiKBWv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037B4DED4
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:49 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id n4-20020a17090a2fc400b002132adb9485so61090pjm.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SJZ+S0mzOe9FkHKx5MOFKfgsx1VaH88UK4oLcesrQes=;
        b=Uz8SRRbX0H27QVFbyc+CNXAEMhW6Tov/0wPzjGSecwdStYQQHQyBteOd7cKJGueLUa
         rQf1/XFya2p/YnPixRdDqNAAIX02anUgrzfhcNWOhbmXFhj4ehzjpJk0kEOyXmnQV/aV
         B6KbRzozYfsjQ/o7WGyBm7JTLMgG5SSJoO1oDIl2i0+NjBeTv4cugGYNWlnYPdKjdb5B
         /2wx9zsmX46zgT4pwBfR0Tjpg65/4GL/9bngrzsVr14jl9Osbsh5WMZIW9+qSyjKmGmr
         gk2VcDR/9fvLFr3xXubKuVhT7v/Sd1PyQPqj1X2j1xt3isgY083H970TsRJJ3alPoqFq
         cf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJZ+S0mzOe9FkHKx5MOFKfgsx1VaH88UK4oLcesrQes=;
        b=T1ZFjqtVUh4yd//TxdkV6VM/z9hEBpOySkZZlvng3kog6IUyilR/Lle4/MBIJ8QUhB
         u+EPFloKSZoK14Do5aYOiXp2jimHpdGBApg5kwOl03XZZ+InPk39+duWNxHvm/P8+M69
         domCDzb2yjDMhBgu1eQaKSg3xQ68XyMUryFx+e/tS3H0PzEh07o+l5blnD3UE2V9/nGe
         JUKh7pZamIZJkhYGb/raYhANNQDKuRCQYwk4jqCxnuS9lkPIT2RQcqG46tidpSlWzZTx
         U/SknLuUUlmI39JnaCL7eKW5a91XWDY36JaNoFieLgyo312GM+dMm2dOokWUrKLiYb8V
         xsJQ==
X-Gm-Message-State: ACrzQf0cy494OAuVNAUMQOxH1YVU6co881//4vtj+EeSOjyA2r/293D8
        DRyma1pspRKcv8Wc0Fs1wIoxNbJEj4c=
X-Google-Smtp-Source: AMsMyM68q4PWcluv1cnAf5ji8Q6lEl5lD83FUxqbh8yzs1Q/GZCPveMt9EYYfEYPgZ0kU7om0NSri8VY4RM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce82:b0:187:3591:edac with SMTP id
 f2-20020a170902ce8200b001873591edacmr11863213plg.153.1667429508787; Wed, 02
 Nov 2022 15:51:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:03 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-21-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 20/27] x86/pmu: Reset GP and Fixed counters
 during pmu_init().
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

In generic PMU testing, it is very common to initialize the test env by
resetting counters registers. Add helpers to reset all PMU counters for
code reusability, and reset all counters during PMU initialization for
good measure.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c |  2 ++
 lib/x86/pmu.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index c73f802a..fb9a121e 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -24,4 +24,6 @@ void pmu_init(void)
 		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 	pmu.msr_gp_counter_base = MSR_IA32_PERFCTR0;
 	pmu.msr_gp_event_select_base = MSR_P6_EVNTSEL0;
+
+	pmu_reset_all_counters();
 }
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 091e61b3..cd81f557 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -96,4 +96,32 @@ static inline u32 MSR_PERF_FIXED_CTRx(unsigned int i)
 	return MSR_CORE_PERF_FIXED_CTR0 + i;
 }
 
+static inline void pmu_reset_all_gp_counters(void)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < pmu.nr_gp_counters; idx++) {
+		wrmsr(MSR_GP_EVENT_SELECTx(idx), 0);
+		wrmsr(MSR_GP_COUNTERx(idx), 0);
+	}
+}
+
+static inline void pmu_reset_all_fixed_counters(void)
+{
+	unsigned int idx;
+
+	if (!pmu.nr_fixed_counters)
+		return;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
+	for (idx = 0; idx < pmu.nr_fixed_counters; idx++)
+		wrmsr(MSR_PERF_FIXED_CTRx(idx), 0);
+}
+
+static inline void pmu_reset_all_counters(void)
+{
+	pmu_reset_all_gp_counters();
+	pmu_reset_all_fixed_counters();
+}
+
 #endif /* _X86_PMU_H_ */
-- 
2.38.1.431.g37b22c650d-goog

