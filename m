Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3705A9E10
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbiIARdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiIARdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:33:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2661D9321C
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 10:33:07 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id m11-20020a17090a3f8b00b001fabfce6a26so1629280pjc.4
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=up2TM/zYvuiSr9vjf1/TjFbeoqAIIxAqdA2XP4Ysf64=;
        b=mnzCFMgQovP4pOxeqKDuUiKfKrfoW65FbzBEQyAYN0ttmKM9Hh1tn19fDLY1zlYtWu
         +n7/5M4T94WtHynUEM5Qxjeinqtsgq7kkWH1LAKgXSBGxeeB4/vbe1jcHe/yBUsPS47r
         CS8IVxzzXWcq68j/3bpQUF6p/7SH4+Sgj0cIqPEZt25gWPd6VkfhYz+p2Rt1jEahgKP2
         VMVS1gWvHEFx4IC8PCk70lmXV016g5e8CrdOg/DNbEb5xuetcpm3Yq6WuPP+NMhYDh/i
         XiYz9dt3VoPajHrHpKBF/rxWZeUyIF4eymR1mkVJRp56WXnN1UakQer/LEUTyRLDRfZq
         B4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=up2TM/zYvuiSr9vjf1/TjFbeoqAIIxAqdA2XP4Ysf64=;
        b=WV0lRZnNWlY4XHOJlqpReBwLKcpU70xgk0r3QDbfEvVtu7SXUNjbg/CBW3DrU7+IWh
         AGRmSVTeuo/HbSktIipDVL5dconaMfNd/nBmViwLzfBf24WsUdMmhq9KGxzjUV+I1RvM
         eYIERe/uBhZw+DiEuaS0fPtGmVtpWDK8DcXrVLhIL8jClhf9qHBHPTJt54oark+jR4hI
         rp/wd7WoVJbemNtFZO5FkXXfhZYsXL7K5T9Vx9QBzfOIBgy4udDYSYSjeDg31gZJ6jok
         xYZt3fJmydQdZFq1ZqSrcQiKhFmvaWBSWzH5f0raCp5TNgr072uA0n7E57WqAqfFbaM0
         mdhg==
X-Gm-Message-State: ACgBeo03jyNEh45Gf8bFo1b2VNhrRclZasfx/HrBGir7ntg04g3EmR9+
        y0linzxU2fjsEVqvISvd4LSiLgV7NXw=
X-Google-Smtp-Source: AA6agR7YtYGNAqd7HjqTYxeCdsRMjgGly3qkWP2F386oX2uY9RK0QBieMMd91SJA6yGNmzbigLsV1w4m5nk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b52:b0:1fe:2ee2:e341 with SMTP id
 ot18-20020a17090b3b5200b001fe2ee2e341mr207479pjb.231.1662053586161; Thu, 01
 Sep 2022 10:33:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Sep 2022 17:32:56 +0000
In-Reply-To: <20220901173258.925729-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220901173258.925729-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901173258.925729-4-seanjc@google.com>
Subject: [PATCH v4 3/5] KVM: VMX: Move vmx_get_perf_capabilities() definition
 to vmx.c
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
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

Move vmx_get_perf_capabilities() to vmx.c as a non-inline function so
that it can safely reference x86_perf_get_lbr(), which is available iff
CPU_SUP_INTEL=y, i.e. only if kvm_intel is being built.  The helper is
non-trivial and isn't used in any paths that are performance critical,
i.e. doesn't need to be inlined.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 24 ++----------------------
 arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c5e5dfef69c7..23dca5ebae16 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -75,6 +75,8 @@ struct vmx_capability {
 };
 extern struct vmx_capability vmx_capability;
 
+u64 vmx_get_perf_capabilities(void);
+
 static inline bool cpu_has_vmx_basic_inout(void)
 {
 	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
@@ -401,28 +403,6 @@ static inline bool vmx_pebs_supported(void)
 	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
 }
 
-static inline u64 vmx_get_perf_capabilities(void)
-{
-	u64 perf_cap = PMU_CAP_FW_WRITES;
-	u64 host_perf_cap = 0;
-
-	if (!enable_pmu)
-		return 0;
-
-	if (boot_cpu_has(X86_FEATURE_PDCM))
-		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
-
-	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
-
-	if (vmx_pebs_supported()) {
-		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
-		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
-			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
-	}
-
-	return perf_cap;
-}
-
 static inline u64 vmx_supported_debugctl(void)
 {
 	u64 debugctl = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c9b49a09e6b5..657fa9908bf9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1826,6 +1826,28 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 	return !(val & ~valid_bits);
 }
 
+u64 vmx_get_perf_capabilities(void)
+{
+	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 host_perf_cap = 0;
+
+	if (!enable_pmu)
+		return 0;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
+
+	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+
+	if (vmx_pebs_supported()) {
+		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
+			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
+	}
+
+	return perf_cap;
+}
+
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
-- 
2.37.2.789.g6183377224-goog

