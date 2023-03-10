Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D06B3CDF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCJKyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCJKyT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:19 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B151CFFBC2;
        Fri, 10 Mar 2023 02:54:08 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i3so5126162plg.6;
        Fri, 10 Mar 2023 02:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4nlGjUeIFU1ciO0H/3MLCy3YXN9ZRSdwoj+bqo8KVo=;
        b=eHN8RTG6pL94ZOvOg1K0rftRqP+Sokxzh768c6Gr8ZOf5zmYPhBKN1Y7ifUe1/41Wt
         8zucL4Mf7ts944+Yu6pwicQkNwHTREwBQe/6tTX74BpL6yP4bVtr/mRYK8BEjcO8yzuY
         J0kWgEKbFVvA8BV7CF/Q2kMpsfgpPf/rHEah44zT4dBss4+fSt4/KJohWqEVgcc0HgNl
         AHMfbXKF3moRvT+R2crip9h2ZUqzsuBKb++2reZo4K9DfOjgFvhiPO5pSMuk4zLuYUnS
         Mek8uCbjc5TrtNbx+XnnNTon9Q+UT7HJnBCAypSnvLnNzOIkqIG7xW5DIyKgIFSs9RUY
         QRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4nlGjUeIFU1ciO0H/3MLCy3YXN9ZRSdwoj+bqo8KVo=;
        b=iEltDBHwlI7UrdayJl/Zr1wBStWV+jM4maJHDroycgfLxKGGWDxRWLSyGRjwANFFKk
         3PBBDvhDT+PDG1EFFSrNxGyM4zRS3atkvM9As1iyb2V2YnH0ba/qP8F4jb4Hc6u+uQ6q
         9WUauonq3Ce1Lv77mga80w+OudU2k2KnY3p+7QhNxQ5/AyJAUaAHw+MUkoarrY0PAM3g
         6PHabHhh5AWs0AE31/avRntRA3fe4CXDMIR+XSIGP21vz/sIJsoySuUyuM9OR4wwKzur
         tq0tZyU9x5ffY36nsNP+krBeeT0tobsvIjA6v0N+Mlw8eVTP5EOIH0Mx2he1Y63TqI7V
         7Hcw==
X-Gm-Message-State: AO0yUKVWmhW85XtwCqHz95bsDxFr2MdJSuDnRjD4Z3eDMVEqo5Q7dT1e
        sggGzMXoe8sYHuhIi691OsrkjYPZ0AohHsu7MQ8=
X-Google-Smtp-Source: AK7set/EtmriIfUFXfBKPHBSYv6Fhro0WivjxJFQkAz5PClTwyTbZAT3rX3m3TtVI9sVvYJi8n4yZA==
X-Received: by 2002:a17:902:da90:b0:19c:e405:4446 with SMTP id j16-20020a170902da9000b0019ce4054446mr29539447plx.30.1678445648178;
        Fri, 10 Mar 2023 02:54:08 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ks3-20020a170903084300b0019cbabf127dsm1174167plb.182.2023.03.10.02.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] KVM: x86/pmu: Add a helper to check if pmc has PEBS mode enabled
Date:   Fri, 10 Mar 2023 18:53:43 +0800
Message-Id: <20230310105346.12302-3-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310105346.12302-1-likexu@tencent.com>
References: <20230310105346.12302-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add a helper to check if pmc has PEBS mode enabled so that more new
code may reuse this part and opportunistically drop a pmu reference.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c | 3 +--
 arch/x86/kvm/pmu.h | 7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d1c89a6625a0..01a6b7ffa9b1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -191,7 +191,6 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 				 bool exclude_user, bool exclude_kernel,
 				 bool intr)
 {
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	struct perf_event *event;
 	struct perf_event_attr attr = {
 		.type = type,
@@ -203,7 +202,7 @@ static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
-	bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+	bool pebs = pebs_is_enabled(pmc);
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cff0651b030b..db4262fe8814 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -189,6 +189,13 @@ static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline bool pebs_is_enabled(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	return test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-- 
2.39.2

