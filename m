Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE74CD0B2
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236406AbiCDJGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbiCDJGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290171A6170;
        Fri,  4 Mar 2022 01:05:12 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so6306913pju.2;
        Fri, 04 Mar 2022 01:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0huejo0qrLdiOti9R/R/YhmO9lyJjNF+aGK4BTVQpxQ=;
        b=LziV9tYEPXFaZm2NruyYFsPhGY7dsE4flt5Wzom69xqCgmPicIMKJx35GCx8VxDdMU
         MoKfvJsd8fh7u3N3eYjCCCO4rJ5KVQYI0jQq9QmqaOPZ1kLI8OgCCBL/odDrWIcG95/K
         itFkBzGtxG9xKSQjELfSmmfOxkbbv/t3aSnI90NzxwPOcES2XMlFEBPbys5fcnRoYuCS
         9vHErakB5Dw3Wuta9F/CPNSV/2h1JsKGjjqd0GoMTTZTRBqHSdbydl5voCp1HoY1Aoop
         1BLJUes7a/7MK1MVeF9gr6ZqrKKob5wuKTCPvxfVyqjwlZhFGEB3RsB3dTp5tFxk58hl
         WGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0huejo0qrLdiOti9R/R/YhmO9lyJjNF+aGK4BTVQpxQ=;
        b=4nRTO9P9HGa2Zv/5SzyZPXtGlBEwhLvWKdWYDZjNJADGFFHBzjR8XsEtR7L0GKJBq5
         5S2CN4CKnuLEQrb40VdM8hEmSZ6kqMzaRdmHyzODHtFuNi2GfxRSws7bY+f+/SqqOm1u
         nxnHDo5Gkzg2LFs3E/2biXOay4/5MJfiI7/yCRGDu/09yy+7GZTMhxYFdCPFOuQ7iCgO
         ZwFtrbzmgd6E4M99mbWx0wZT0jzM+4rc/2NybN61prblPCSp/6RQ9JptWHf6JypHmNvt
         e+IJA5LQeMvexuNB8uZTavHXuZRrUlzCbyMAXu4E2Iiupm7hGPnE6gQMR2oMrukwJ00j
         YFPg==
X-Gm-Message-State: AOAM533nv5RZ0DupsxDoL3yyaG9cvFurg90Ovp6gNK1YDi3m+F2pe2ky
        d9Ha4Cq/ulL1PeuQSOzIqsw=
X-Google-Smtp-Source: ABdhPJzhYYc+rc8NYp3GxJf+T4KsVlb6veADCHYuGh6uicdA0fZvivPnt2wZvNGzndKQR5U6B2s21g==
X-Received: by 2002:a17:902:ea02:b0:14f:fd0e:e433 with SMTP id s2-20020a170902ea0200b0014ffd0ee433mr41533847plg.24.1646384711904;
        Fri, 04 Mar 2022 01:05:11 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:11 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 09/17] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Fri,  4 Mar 2022 17:04:19 +0800
Message-Id: <20220304090427.90888-10-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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

From: Like Xu <like.xu@linux.intel.com>

The PEBS-PDIR facility on Ice Lake server is supported on IA31_FIXED0 only.
If the guest configures counter 32 and PEBS is enabled, the PEBS-PDIR
facility is supposed to be used, in which case KVM adjusts attr.precise_ip
to 3 and request host perf to assign the exactly requested counter or fail.

The CPU model check is also required since some platforms may place the
PEBS-PDIR facility in another counter index.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c | 2 +-
 arch/x86/kvm/pmu.c           | 2 ++
 arch/x86/kvm/pmu.h           | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index b08f0eb6cfee..f88b3be88061 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4003,8 +4003,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 
 	if (!x86_pmu.pebs_ept)
 		return arr;
-	pebs_enable = (*nr)++;
 
+	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 51a218f53fed..f16dfd7431d1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -152,6 +152,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..28c3a826f169 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -4,6 +4,8 @@
 
 #include <linux/nospec.h>
 
+#include <asm/cpu_device_id.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -16,6 +18,11 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 #define MAX_FIXED_COUNTERS	3
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
 
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
-- 
2.35.1

