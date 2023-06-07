Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CE4725157
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 03:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbjFGBCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 21:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbjFGBCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 21:02:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB0A1726
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:02:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb397723627so2303389276.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 18:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099735; x=1688691735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/p3hE18mmnljLb7fbFnVkkn8QwKXTaT5e9jEQlBWXcU=;
        b=6UvT6b0pBC2I3ReD74BskUKqwcHxT2DPwtJz6h4dQIf0lHIvZSKhTS2z6XHo0m2YyQ
         dyyCZPMTIaqqpphsP6+05vRW/aDN6KreYQqGeaaZWyXjMzJUD60PPE0HtOuAuZjtOHMu
         Oz+BBNEuK99s7gfi6PJtXvYxpHyEpOiYFxX+/yJI+S3tLnIoesOR7gyw8m4ynEGveJzT
         SDnYH7M+8WW2xoCXwUP1RnvMVPRCKHzj1ZNFKfxS2wp2nz7Ui38bmNTLEX2S2iKr5L45
         Wb2+GpSmRSs1WwOAyl3F0INfi5pydWmUHlJRxYt6nOm1gQqIOSFij9xPXiJ3UssrOsEz
         RiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099735; x=1688691735;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/p3hE18mmnljLb7fbFnVkkn8QwKXTaT5e9jEQlBWXcU=;
        b=MrU5d6wY1LWj3+DEzak9eOb7SIDzQRVX87DM0sv/BOt/FcEM+0d3p5hI49oy2h5r9c
         MtgNvWQYZ4SXGRutNcMEh4Ap2GIdAyw4CVj7jU/v7u5rYB/YEojJQnaZfWJTpwQ+26P6
         BRxOklkBRpUOTN4EyFuIzxnhvIIWTKuBVdd9QHLVZ0AdrFkBmrC3NRTwpxsXiosJivrO
         M7PUuWHWPmKKKnQAZneE+RSLTHxlvRuPHUSVCRno15h7wZ23OPoLN4lm9jRPnWMTv4Ho
         5g6JTI0f4FsTxY3V0B/vpYdb3NK9AQPx7cQW41262dy0G9eY2nU7kT8Zc8TWbEJ0/CtR
         db5Q==
X-Gm-Message-State: AC+VfDxVI6K/W9wb4nozf2Y1ah+I8dHzET9iWBKDyW16rD32FvSC7be1
        jHmh1ng+Qjqg/6QgkC1flfBjW+6PqBY=
X-Google-Smtp-Source: ACHHUZ66ZN18TSVUSFfTJ9KYMFh531G+fYQnxCFRROXfI3t6AlHX78mEuOWXgZ1KtH0TDjdOM2NxAZyogNQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4117:0:b0:ba8:9653:c948 with SMTP id
 o23-20020a254117000000b00ba89653c948mr1341420yba.3.1686099734922; Tue, 06 Jun
 2023 18:02:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 18:02:05 -0700
In-Reply-To: <20230607010206.1425277-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607010206.1425277-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607010206.1425277-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: x86/pmu: Require nr fixed_pmc_events to match nr max
 fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that the number of known fixed_pmc_events matches the max number of
fixed counters supported by KVM, and clean up related code.

Opportunistically extend setup_fixed_pmc_eventsel()'s use of
array_index_nospec() to cover fixed_counters, as nr_arch_fixed_counters is
set based on userspace input (but capped using KVM-controlled values).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f281e634af3c..c0b0a721b97f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -527,16 +527,17 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 {
-	size_t size = ARRAY_SIZE(fixed_pmc_events);
-	struct kvm_pmc *pmc;
-	u32 event;
 	int i;
 
+	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
+
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		pmc = &pmu->fixed_counters[i];
-		event = fixed_pmc_events[array_index_nospec(i, size)];
+		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
+		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
+		u32 event = fixed_pmc_events[index];
+
 		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
-			intel_arch_events[event].eventsel;
+				 intel_arch_events[event].eventsel;
 	}
 }
 
@@ -597,10 +598,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (pmu->version == 1) {
 		pmu->nr_arch_fixed_counters = 0;
 	} else {
-		pmu->nr_arch_fixed_counters =
-			min3(ARRAY_SIZE(fixed_pmc_events),
-			     (size_t) edx.split.num_counters_fixed,
-			     (size_t)kvm_pmu_cap.num_counters_fixed);
+		pmu->nr_arch_fixed_counters = min_t(int, edx.split.num_counters_fixed,
+						    kvm_pmu_cap.num_counters_fixed);
 		edx.split.bit_width_fixed = min_t(int, edx.split.bit_width_fixed,
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
-- 
2.41.0.162.gfafddb0af9-goog

