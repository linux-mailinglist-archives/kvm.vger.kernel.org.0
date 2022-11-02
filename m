Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABC6170DF
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiKBWvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiKBWvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C91B1C3
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:16 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fc0644f51so10997b3.17
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bExxaYx4niNALMWuoiu73wsZy042ybP2pVsvZ5pNZGs=;
        b=KGwfYs327aRbCbiNZOErFpREYz1TEUP4mAGlkcFDdEwrfAwbOPKsKC7x/UnO3I1AEg
         B4xsOCMu9QesFJIZoNCqFnjpl/bVLRP941oWPECC1CebU4LOkqU7HjY9RPVlihopjRDv
         jnF4KIQDGME46d/8fZnPP2NQT/gSMe5DQbefEpNtyUcLIRhfTCWD3ZCEssbzTEOu1RCn
         q2oJm7CH+atc1ikfGRloBE7hD5dRrF24Pin4L1qj2i3Lvcwx0ehC0ZVKTwqi7ynbziv+
         M4vw7YXqjl2DxXImxq/DHGrfF1q05ISozkm2Lj4PuFGM2MBAdYFVD1xSdGbXGb5wCNxQ
         mEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bExxaYx4niNALMWuoiu73wsZy042ybP2pVsvZ5pNZGs=;
        b=SGfsLIt1MVxoaiJEF+/TyIKjdMVghooJlXBwMjuql6Bgb5sNOgm5rS/ZrQFdWL/NiF
         cj8Ybm13KFYao/LJr7Le5AD0+JSv64GUQYzPaFprHCoziaysmUkOHwhVREqPEXRUZVed
         vC4mNYpipcaCGgEaDDD3qH1pQuY+TG7xfKvT6OfhX3NZj+XYiGXlkz+yU3BDiJvlZky7
         j42YDUJI50T5UdxunistUvu9KUyBijqZ9cLqWjGRGRnweL4uYcQyrnYcblpCVNpjnVdI
         +fVPzay1I9G5eNAykSWawm1PaG9xuFf5AfhoIZ9GObNRC5S4Y5Kz+mY6uTvYPOA1yBjU
         F5mQ==
X-Gm-Message-State: ACrzQf3pbMju95/w8O/MJkyQIc0NGFc2fZkgSPl653RbODZ1sVbc6/We
        UXP8xKQIP38G7rF5SbrcPYJZeXnPGdI=
X-Google-Smtp-Source: AMsMyM5JSQ71qe8CZA4oLC3fu+Pix0RiI4iEjH1agYRoYtGVT96ZGyAcMk233Ry3yThJfuKRxaTICn0tuis=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3f47:0:b0:6c1:130e:381c with SMTP id
 m68-20020a253f47000000b006c1130e381cmr177147yba.366.1667429475803; Wed, 02
 Nov 2022 15:51:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:44 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 01/27] x86/pmu: Add PDCM check before
 accessing PERF_CAP register
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

On virtual platforms without PDCM support (e.g. AMD), #GP
failure on MSR_IA32_PERF_CAPABILITIES is completely avoidable.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h | 8 ++++++++
 x86/pmu.c           | 2 +-
 x86/pmu_lbr.c       | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 03242206..f85abe36 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -847,4 +847,12 @@ static inline bool pmu_gp_counter_is_available(int i)
 	return !(cpuid(10).b & BIT(i));
 }
 
+static inline u64 this_cpu_perf_capabilities(void)
+{
+	if (!this_cpu_has(X86_FEATURE_PDCM))
+		return 0;
+
+	return rdmsr(MSR_IA32_PERF_CAPABILITIES);
+}
+
 #endif
diff --git a/x86/pmu.c b/x86/pmu.c
index 6cadb590..1a3e5a54 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -660,7 +660,7 @@ int main(int ac, char **av)
 
 	check_counters();
 
-	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+	if (this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES) {
 		gp_counter_base = MSR_IA32_PMC0;
 		report_prefix_push("full-width writes");
 		check_counters();
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 8dad1f1a..c040b146 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -72,7 +72,7 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	perf_cap = this_cpu_perf_capabilities();
 
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
 		report_skip("(Architectural) LBR is not supported.");
-- 
2.38.1.431.g37b22c650d-goog

