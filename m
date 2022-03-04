Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75FC04CD0A8
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbiCDJFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiCDJFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:42 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294F0192E36;
        Fri,  4 Mar 2022 01:04:55 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m22so6892703pja.0;
        Fri, 04 Mar 2022 01:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t5IBLpV9CBp3Q9A9d6p3YjiEqXq27VVkPzFjiGgiBI8=;
        b=lSTE4viCsh4WcIgB6p0ZFpIg4PuUmIXdiji4whKV+QsPQH3dmmbsmygclsaNlFrIQk
         8Ah42j0lWg4zV21ch88RpJxFiw1qXf7O60LsIni3iuqm1Ur6xUBz5RpMgM0qds42uzS5
         MYExyg6v1rN6oNX31uzuvGsF3lEJEZu0yxhbuSBrydaAOgL7luuSNjs0NuYKoNuUI908
         oA7oOkG7Weo9ZzrT/+L7oF0anC9LI604WNlLevzk9u/Q7EVz2b319WZzQrDgOfPdkRwM
         HHI/nA96QPNAZ+/KgtxAtmue/UmIM5Tg5bhloQpgK+/vQsvmJ1q4+Ho1ZTRCoQSLu4Xk
         xlkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t5IBLpV9CBp3Q9A9d6p3YjiEqXq27VVkPzFjiGgiBI8=;
        b=NWuNGvOIMhePYYpc0plH/ukQ3ywRjb2Pp1xt+QExJzHRIObslDEGZFDoD5tBUZPJ10
         0vr8Cw6xRN392POStUzJe9mPRfaE17CxJrrcmVVUZQBzlOHnUUTkuuiPD4bUtBusHKaV
         y2+RcevAL9HPykafdzE2+d8TltpTWl6LGUNYkDip0kE/l1QXUH9mzE1uPbKaZO4bNfPk
         yANlfgvmlm/vKQb4W4bModlcmGODZIqkeMch/0vvc70eUy+gJyk+XtJ29AD1FqrNGRPW
         2YYhasbw8OqKlQZ3OhmVKNvYE4i4NUme8FbWr60fXZnjc3Z2O29DA3KfRbIaUuKlmdtU
         X5zQ==
X-Gm-Message-State: AOAM533ah7McpzPTqqnM+nfJCB2nJdZrep1LpkxYQHWhudWeGkAplb4f
        djkUDYZWz1E8GI2Q23qtbRU=
X-Google-Smtp-Source: ABdhPJxerh5TMu9NOmmnxK1FSbkst9oJfDPpWgbiHUTPhqzj3gf5MgeGMGi+VNTZaoRQK+UiY9bYTg==
X-Received: by 2002:a17:90a:20a:b0:1be:e850:1a37 with SMTP id c10-20020a17090a020a00b001bee8501a37mr9655446pjc.28.1646384694602;
        Fri, 04 Mar 2022 01:04:54 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:54 -0800 (PST)
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
Subject: [PATCH v12 04/17] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Fri,  4 Mar 2022 17:04:14 +0800
Message-Id: <20220304090427.90888-5-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
detect whether the processor supports performance monitoring facility.

It depends on the PMU is enabled for the guest, and a software write
operation to this available bit will be ignored. The proposal to ignore
the toggle in KVM is the way to go and that behavior matches bare metal.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 arch/x86/kvm/x86.c           | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4e5b1eeeb77c..61de7b07489c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -496,6 +496,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
 	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf17af4d6904..3c7a51468216 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3515,9 +3515,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
 		break;
-	case MSR_IA32_MISC_ENABLE:
+	case MSR_IA32_MISC_ENABLE: {
+		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON;
+
+		/*
+		 * For a dummy user space, the order of setting vPMU capabilities and
+		 * initialising MSR_IA32_MISC_ENABLE is not strictly guaranteed, so to
+		 * avoid inconsistent functionality we keep the vPMU bits unchanged here.
+		 */
+		data &= ~pmu_mask;
+		data |= old_val & pmu_mask;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
-		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
+		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
@@ -3526,6 +3536,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
 		break;
+	}
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
 			return 1;
-- 
2.35.1

