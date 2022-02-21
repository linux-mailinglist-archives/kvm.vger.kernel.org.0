Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6DD4BE531
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356930AbiBULwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:52:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356918AbiBULwr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:47 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE741C90D;
        Mon, 21 Feb 2022 03:52:24 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f8so14071733pgc.8;
        Mon, 21 Feb 2022 03:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FB1eMfSYvUVn+Sd4GmduBTaes5/j6Y5IcJ2hQSwAGKk=;
        b=AyiSYpQrW2zAwk6iAYZyxtr9h+kGAAF7cR7BsxHjKHLAqYpPtt5mSWMHKT6tjJHBTD
         riHOAj4bicbSth94d1YvRsg7sKhcjhO/2GurAgmv5yyG6FLMEZstLiFLc0u5ZOUH4Eh1
         U13elNygg0Hs/cefn4VzhKTS++aU+OrMuYIBa1RKQRkEjbFogg1uJFqnr/a2iV/19v7q
         KdtAARNptQR0H8Lnu1zilLEjSURiRMgo2AQ4qlLMyyg4m8XYjO4RAbSKEvL+AsL4PPZW
         Q6bqOu4aCXq5EZ/dJO5Cmu6DhJz4R7IsHc0yJzYaxUQEvJz83JxX+e7BrT0507E09pXw
         A4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FB1eMfSYvUVn+Sd4GmduBTaes5/j6Y5IcJ2hQSwAGKk=;
        b=j7EZmFwaii6/FY18/qyK4cq/Y70xX+MHbSGv/eWYAtOlAn/Qlt8cPSI5aKCXqvJKqB
         7qJ4qmbucWVYhtJ98PQz5nUpdFP1F58G7nl5+jz2dy0Xhn3DUCCm+dLTrTw2oRVXFkDr
         Tjd+n/KKS3ryB8TAj8lpLZBbmI5HLVkYL7a1ThQFWu1iEisNvVqm7hOU+kXARDGmLt/s
         6Kfn2cwE5lJvzT8PUxQGgHKYrynU6E+4T7X2J5ltqERgSHqPkIiJquVfSOu9aLfkpDoN
         siLVDlKmYbCRuoJu5tCyxOuNCg6ZgkOCTRnwQEqIpw8TAloY6nTSfR+1t0oK+uzsr6zR
         mDjg==
X-Gm-Message-State: AOAM531GavY8zJJ9zOCxo7rW7nNVB1mIO6XT5B3nYVzefBUawekklRV1
        e08S/s/cuthoQXhtXqYhD0k=
X-Google-Smtp-Source: ABdhPJwqv7jbgfcpYcFQHKenXA0Et8VvWIDZY8kDqvJ9cZZCRD1ahqSr+Wrfh59wKmB3J04wCw/bnA==
X-Received: by 2002:a05:6a00:15d6:b0:4f1:4a86:b3b with SMTP id o22-20020a056a0015d600b004f14a860b3bmr594459pfu.60.1645444344138;
        Mon, 21 Feb 2022 03:52:24 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:23 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 04/11] KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
Date:   Mon, 21 Feb 2022 19:51:54 +0800
Message-Id: <20220221115201.22208-5-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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

Because inside reprogram_gp_counter(), it is bound to assign the requested
eventel to pmc->eventsel, this assignment step can be moved forward, thus
simplifying the passing of parameters to "struct kvm_pmc *pmc" only.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 7 +++----
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 3 ++-
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 125bdfdbaa7a..482a78956dd0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -213,16 +213,15 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
+	u64 eventsel = pmc->eventsel;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	pmc->eventsel = eventsel;
-
 	pmc_pause_counter(pmc);
 
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
@@ -289,7 +288,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 void reprogram_counter(struct kvm_pmc *pmc)
 {
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc);
 	else {
 		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b529c54dc309..4db50c290c62 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,7 +140,7 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
+void reprogram_gp_counter(struct kvm_pmc *pmc);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmc *pmc);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5aa45f13b16d..db839578e8be 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -265,7 +265,8 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data == pmc->eventsel)
 			return 0;
 		if (!(data & pmu->reserved_bits)) {
-			reprogram_gp_counter(pmc, data);
+			pmc->eventsel = data;
+			reprogram_gp_counter(pmc);
 			return 0;
 		}
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 049ce5519fb5..1ed7d23d6738 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -448,7 +448,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if (data == pmc->eventsel)
 				return 0;
 			if (!(data & pmu->reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				pmc->eventsel = data;
+				reprogram_gp_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.35.0

