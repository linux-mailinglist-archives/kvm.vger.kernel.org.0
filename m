Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC96170F2
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbiKBWwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiKBWwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5060DF0C
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n1-20020a170902f60100b00179c0a5c51fso185735plg.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ctDNfIMHZ5icB8QtOiHwp12zQU5tmB9ZoVNqcNfIfAQ=;
        b=VGXAdBpFQM3TZRGnn1J92UA/pio6AEpqXnfX26vei3bsntX1Uz6s7wGF+ytSx4yLez
         xQ14jr/6n9eM8pfHKySiraOG1TLc7z//Nij/sFu3wgzhiRDK8Zh5tgZPQNAvA8yEhyKv
         oAiHFWMNNwnMe2Q98Qj7Pr5vDWTl+QftOGnoRoGkL+f3yfCMix1KMyJcXSKrIZJX5Uiw
         LzItfELDL1RxxX0pgNBQcMlU6fnw7utqpvSH1d1sddvCcgQu5nOiXt9sOBJfW0W1XfqE
         I33jYufMtAakukLfISbFyAdhJuca15AOPR+tgYn1hfakZIRsKElRqnkR0FOWC8nstakU
         vekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ctDNfIMHZ5icB8QtOiHwp12zQU5tmB9ZoVNqcNfIfAQ=;
        b=43K/cuoDUfWASv0dEjKTENYhQrIxdzbhtrxcNvMBs0Z5s0l4hWk+hfwMMWgidGSsM9
         falQ3NYyQ/IdQZkka/4aVDmKkYhOK6qdmsYRzZ2oBTJyf9lC2h9/kuy24LyfypU2Q+Mz
         0EkoZrj3lqpbKOlav1XH1BZ4qA4OcVi05v9XbcTyGA48nbf4oDRNl5JzZdmzGHPA7Cih
         qCHsOnX1JnWeg0tQP6P44MJOhQYnncqGHCF46FpSrOZH+iSQlpM1c/kF4TM0G8K7hM/E
         9Hvo57qlMyz/V2UUgDTDnQfnaUMtneN4t9hr2SfmhnBCoga3oGUXG3I+oxXNMWMZRZp6
         qL5g==
X-Gm-Message-State: ACrzQf1JxsDr0EeIDjwHQsS0UDJMiXpGxII94w3uny+uG6e7Br3UCQQM
        YvSaerE2/dQ3xskEqy8pPy6oDf8PYcY=
X-Google-Smtp-Source: AMsMyM67RQM7PXs7FSR9T5O4pzIbagjgaS25vdU/8+WLVpPgLQpnvXRmF4HMT13OoC10kiFR7YYQfzQwlRI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP id
 fs17-20020a17090af29100b0020aeab5cf39mr144905pjb.1.1667429507116; Wed, 02 Nov
 2022 15:51:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:02 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-20-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 19/27] x86/pmu: Add helper to get fixed
 counter MSR index
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

From: Like Xu <likexu@tencent.com>

Add a helper to get the index of a fixed counter instead of manually
calculating the index, a future patch will add more users of the fixed
counter MSRs.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
[sean: move to separate patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.h | 5 +++++
 x86/pmu.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index c98c583c..091e61b3 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -91,4 +91,9 @@ static inline bool pmu_use_full_writes(void)
 	return pmu.msr_gp_counter_base == MSR_IA32_PMC0;
 }
 
+static inline u32 MSR_PERF_FIXED_CTRx(unsigned int i)
+{
+	return MSR_CORE_PERF_FIXED_CTR0 + i;
+}
+
 #endif /* _X86_PMU_H_ */
diff --git a/x86/pmu.c b/x86/pmu.c
index d66786be..eb83c407 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -390,7 +390,7 @@ static void check_rdpmc(void)
 			.idx = i
 		};
 
-		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, x);
+		wrmsr(MSR_PERF_FIXED_CTRx(i), x);
 		report(rdpmc(i | (1 << 30)) == x, "fixed cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
-- 
2.38.1.431.g37b22c650d-goog

