Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB56DC5E3
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjDJKvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjDJKvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:20 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9663581;
        Mon, 10 Apr 2023 03:51:19 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-634b28df952so422918b3a.2;
        Mon, 10 Apr 2023 03:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123879; x=1683715879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS0Uc7+GRHk2JAOMs6kTtR/AvHmqVodtFBcgwhyXJLQ=;
        b=RURMy3bjBcxyE2TmYmZ5bRcBHne+dHqOxQTKUR1E19Cpgp1TLjrlTGF0hBxgV+Q1JU
         V/V9RIo35bvieRPNjTgT/q780TYHA59+nD+8RujekbGqJQ7NWpcMCZ9Uql7hjiW5Dr1x
         ALtP2Hm6ic9Solciaee0S0EVyENMLbvuqHBoRlOQuGzw7KWJCp6MFlr1ZFcfqM6T3+P3
         qeyeuV32TCjZWc+S9OT6mOlDMq7UXAPj957EQkQsC/+IaKy7fjWdgelN/BUoMql6D+yd
         Bu3zQpRHL2xatzOTf5cpRMzLmuiTrJfeWRIC8rNNC0EGGSiMrN8Lp8h8ciQGhtkXqGNS
         UzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123879; x=1683715879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AS0Uc7+GRHk2JAOMs6kTtR/AvHmqVodtFBcgwhyXJLQ=;
        b=Ciovr9WG/wgqOFKMhkg6WMLx9mBOsliOEptGrG5iSi0WTubuj4vKxCSaEWuT5+h8q0
         Uv+J8SW3H7pKB68B2TBZNOISeDA4RzGyOnWH8Qy6ReJe+ZcLBalOwg10n3KAOQqcSt+V
         dbOLIkEBk/bjkSuKmcFDi42EaVVVaVl62U3mm3a+DWpq+0Es8/89FxzOgvl2gnx0/AJE
         4eg3M/jjH1XqBhWthgtQj0cJlpyEzHPKG/WXII1r4frzSPaoTsm9YZ8z19ABhXis5K3h
         dIvVenFj64Fm9PFMVQlC/3uB3SzAdCPMBu1t7BDCu8DKGMVSPOFPBIg5od23cTpLf7qE
         8H4g==
X-Gm-Message-State: AAQBX9c+2kP7Mq2n45YFW/HdOaCs2dTNAlCknEylvkGq73Ynmt4CAWdp
        K9x9aT86WLc9mHA9WKJGDWsX0E+LnmvoTw==
X-Google-Smtp-Source: AKy350bfCmd8FxzV7MO7p5Q79iCjrX6Z3ftpMmg6ChociNbnfVy7tFPfE5yqHrmTCLVgSU4kMAW5UQ==
X-Received: by 2002:aa7:9697:0:b0:5a0:c4b6:edd6 with SMTP id f23-20020aa79697000000b005a0c4b6edd6mr11197859pfk.0.1681123878752;
        Mon, 10 Apr 2023 03:51:18 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:18 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 01/10] KVM: x86/pmu: Expose reprogram_counters() in pmu.h
Date:   Mon, 10 Apr 2023 18:50:47 +0800
Message-Id: <20230410105056.60973-2-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The optimization stands on its own, whereas the code movement is
justified only by the incoming AMD PMU v2 support.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 12 ++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5c7bbf03b599..986563aeeef8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -201,6 +201,18 @@ static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
+{
+	int bit;
+
+	if (!diff)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
+		set_bit(bit, pmu->reprogram_pmi);
+	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
+}
+
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..1f9c3e916a21 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -73,18 +73,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
-{
-	int bit;
-
-	if (!diff)
-		return;
-
-	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX)
-		set_bit(bit, pmu->reprogram_pmi);
-	kvm_make_request(KVM_REQ_PMU, pmu_to_vcpu(pmu));
-}
-
 static bool intel_hw_event_available(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.40.0

