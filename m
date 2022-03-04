Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B04CD0AF
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiCDJG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbiCDJGU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:20 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148091A6FB2;
        Fri,  4 Mar 2022 01:05:22 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id q11so7157982pln.11;
        Fri, 04 Mar 2022 01:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMzPMdl7KcQbGCtbANNUWbGMkm0iwQkAmLBMSkPAF54=;
        b=aejbG9PLpiGxo31XZRk+uadodFz2IO2lrXBkuW4FeJH5wJk3kKVT3gO8xJaqnVYfTz
         O95NGRtkEeU/SDg/o+aIgJ0CKexSbK8scCb08/61w5R9eNX326Uqf6Nr7/wfuWXVqn6s
         Di4MMrcb4nYkzehclt8l+4mYwXmx0IzWbmRNZbDtJmxNyGsEuXurUyQMPEvCm2BpAGSx
         06yw20c7BxJfCaWRzl7HB6Hy+2jQWCTsHnHjSBp9y4PyZhPtyScvTNmIvxnrUKoTWLWI
         DAkLZCrWw3QgI/V2LzKzXleEvl9Yh0DsLioQSMZedMMW/yinAY0v1/j9l/WAExWGKre2
         jmyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMzPMdl7KcQbGCtbANNUWbGMkm0iwQkAmLBMSkPAF54=;
        b=hWZRMzc02Q8LfK5bzE2mGIq9794TWqwhF59Y8eldsPP6tSagb4fcsMqWc8kgMA2PDq
         O4N6Q1pzqbEu/UEBpTbdHOFGZ+xiXbYPdRMQCFWC0//oJeZpUttVjtvuvuYTPtKTaxYb
         hwfjsWSpl3OFNy9CC2gI2hKfg8ufHC2OCvVggwpy1I4RDnBvvM1HyXbKdZ4Zfwpye/RN
         0aDVb0j9/UxFjJYFqQXV7boxmaSV4pYSJJ8pkpLKFGAqAz2vseMR6sVlwt57CiC9lonU
         SECe70FauM3chl7Hthm2lCdBU+LYbLS2J0BrOAtcB5S/u/e9VG+F4ePKacFyrq70OIFk
         nf7g==
X-Gm-Message-State: AOAM532lfzU8d5idF5ptD+L+AjMPVvxMdW4jFUZ3HwnRS1wZotjTFrHU
        vz4z4Wj8aMxgncF/np9qK0M=
X-Google-Smtp-Source: ABdhPJyTl2+xl9sMg4x5A+XYIi9uoZapaavKzeLeo2jnKuMVIfRLW4OhmaOIBnfrDmzL44L8JGlWGQ==
X-Received: by 2002:a17:902:8698:b0:151:488f:3dee with SMTP id g24-20020a170902869800b00151488f3deemr31730591plo.9.1646384721377;
        Fri, 04 Mar 2022 01:05:21 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:21 -0800 (PST)
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
Subject: [PATCH v12 12/17] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Fri,  4 Mar 2022 17:04:22 +0800
Message-Id: <20220304090427.90888-13-likexu@tencent.com>
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

The bit 12 represents "Processor Event Based Sampling Unavailable (RO)" :
	1 = PEBS is not supported.
	0 = PEBS is supported.

A write to this PEBS_UNAVL available bit will bring #GP(0) when guest PEBS
is enabled. Some PEBS drivers in guest may care about this bit.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 arch/x86/kvm/x86.c           | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3cfc90d5c4f4..a1fadfa3fbec 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -601,6 +601,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -614,6 +615,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c7a51468216..41b25412bad4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3517,7 +3517,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE: {
 		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
-		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
+			MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
+
+		/* RO bits */
+		if (!msr_info->host_initiated &&
+		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
+			return 1;
 
 		/*
 		 * For a dummy user space, the order of setting vPMU capabilities and
-- 
2.35.1

