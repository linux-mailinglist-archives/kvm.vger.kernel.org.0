Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676C05892B9
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 21:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbiHCT1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 15:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbiHCT1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 15:27:17 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33E75B062
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 12:27:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 185-20020a6218c2000000b0052d4852d3f6so4102462pfy.5
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 12:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=S+w5TrS2aE3Gtpp3HC8mmkT4Qt+4IBb4hazG/v7qagI=;
        b=lmEYlMMVO7RosQH1pARCRiSvkT4wsXXKXfUp+jCo+GsJZRkS34/+uMIQSRuadC24YK
         hppsOHONTrzjUsbf2sjkvaEkzGHKAc8xMom3WelINp2MTfetiMQ5h6CFGQE1r5Eb3eai
         yS/7sxnhdwOhTm0kXBk9JVK9mQe9iiU+ZZAs7VpzaW6v1OWSlt65skDr2IGCB8IkeX+P
         5zumLR1VErgkKXZiFu8nKojDR2XAoqZiAavHumGeIJwK3yK+ClI4HAjmw/KRk5FbRPtJ
         FuWNWP6APBTl0PNGV6O09kdS1qqTb3q5fX6fVJU2iJYgvuPukPluausbL8Ll23seGPT/
         aXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=S+w5TrS2aE3Gtpp3HC8mmkT4Qt+4IBb4hazG/v7qagI=;
        b=GpTSEW8cie2oSYcQ72tDTDI0LIIgvYJptnl5Xc/SBFkqCReYBt+XPY2y9C4c95PP3b
         mq2YvnmvlN2H6mHD502cXHDNkz5Uuv3+HW6OVm9XsbE9SNNF7Ygy0NgSwKkiWkn+Gx1J
         kuQYEl8AkFgth8x26U1g1DeNRCZDElwuxW4AiWpsuYYxq4aLBK0TmqoemGdHFl0aDlCx
         vs7aSR+ZBM9Z/Xsqe23f1S/eZot7nz2e3ETzuNdvXwyUs02zXs91R/MBmFcmk158tST9
         /PZJgLlbGfbcBP51A8xUO8M+5ED/nkb4Gr1+dH+03ILzO6IEdnr/23JQ+OoK+HHELSwO
         e/DQ==
X-Gm-Message-State: ACgBeo13x2jAF9RtF2bga+ldSdN4eMOyj+eHcng0cwVqwmvUeJTjj7Ci
        70u/ddc1YtsLQBfCidvbrq890Je1Z/o=
X-Google-Smtp-Source: AA6agR4o3cxWVgS7VIytOO8dO0l35jbwyG3DPxCP1ZD9nJgR/3J065dpus5g1cP/VkTWwQK9ibmPsnduNho=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:228f:b0:16f:1b48:230c with SMTP id
 b15-20020a170903228f00b0016f1b48230cmr2674111plh.78.1659554831157; Wed, 03
 Aug 2022 12:27:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Aug 2022 19:26:56 +0000
In-Reply-To: <20220803192658.860033-1-seanjc@google.com>
Message-Id: <20220803192658.860033-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220803192658.860033-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v2 5/7] KVM: VMX: Use proper type-safe functions for vCPU =>
 LBRs helpers
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turn vcpu_to_lbr_desc() and vcpu_to_lbr_records() into functions in order
to provide type safety, to document exactly what they return, and to
allow consuming the helpers in vmx.h.  Move the definitions as necessary
(the macros "reference" to_vmx() before its definition).

Opportunistically move the other PMU definitions/declarations to keep the
PMU stuff bundled together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.h | 50 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fb8e3480a9d7..35b39dab175d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -6,6 +6,7 @@
 
 #include <asm/kvm.h>
 #include <asm/intel_pt.h>
+#include <asm/perf_event.h>
 
 #include "capabilities.h"
 #include "../kvm_cache_regs.h"
@@ -92,27 +93,6 @@ union vmx_exit_reason {
 	u32 full;
 };
 
-static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
-{
-	/*
-	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
-	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
-	 * greater than zero.  However, KVM only exposes and emulates the MSR
-	 * to/for the guest if the guest PMU supports at least "Architectural
-	 * Performance Monitoring Version 2".
-	 */
-	return pmu->version > 1;
-}
-
-#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
-#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
-
-void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
-
-int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
-
 struct lbr_desc {
 	/* Basic info about guest LBR records. */
 	struct x86_pmu_lbr records;
@@ -542,6 +522,34 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_vmx, vcpu);
 }
 
+static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
+{
+	return &to_vmx(vcpu)->lbr_desc;
+}
+
+static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
+{
+	return &vcpu_to_lbr_desc(vcpu)->records;
+}
+
+static inline bool intel_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
+{
+	/*
+	 * Architecturally, Intel's SDM states that IA32_PERF_GLOBAL_CTRL is
+	 * supported if "CPUID.0AH: EAX[7:0] > 0", i.e. if the PMU version is
+	 * greater than zero.  However, KVM only exposes and emulates the MSR
+	 * to/for the guest if the guest PMU supports at least "Architectural
+	 * Performance Monitoring Version 2".
+	 */
+	return pmu->version > 1;
+}
+
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
+bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
+
+int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
+void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
+
 static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-- 
2.37.1.559.g78731f0fdb-goog

