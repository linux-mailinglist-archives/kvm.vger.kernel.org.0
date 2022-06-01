Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E672F539B8B
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349293AbiFADTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 23:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349284AbiFADTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 23:19:37 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA558B0A7;
        Tue, 31 May 2022 20:19:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h1so523841plf.11;
        Tue, 31 May 2022 20:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7+1EA6A/6RNV2QBUrRVFqjIksxe9LFHPVmVbTjKWy98=;
        b=RAxMiTTID2eCzjoSn3227yQkq6kWGgPAz4Vxzhpno5au8ao8ekcvbvoBIQVJ47cmXS
         Bwb4SUEsFHx0lu0Mm5+js0xv1voJcY1tTDDv2crsqbY/Nwi0k9ThysQ5uykPyz4ACBFX
         y8rgvpMSbM5T35Soge+8MxNZjsHByeQRpYLpYTHJ2FW0iK0GY/1FTIICfZJ9M31m2dBU
         zVGMjhI/+eBCjo95970rvpp+/oqLZnNCerIWUcFw/xHTPmPsRjuGczkVnYvoB+wDZ2cx
         /bn+3PhKH0t1TZ6Z21yAvDdZ8L35rhmeMsau0ZLiz9YYseJrZQhTlfJMB3mAEpnM8knY
         +EYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7+1EA6A/6RNV2QBUrRVFqjIksxe9LFHPVmVbTjKWy98=;
        b=nLeh00RSb6ZdGnYL2dZ1mlh9ygQ7kk7FA6FI639EGcRqhs+J3ss1QiMEraStiTPEu9
         uM2whf3ut66gvvmYt7y3s3HzDzFt5AVaT1W+uPlyq+XMRRWz080t6i+X3czyiFDxUBXL
         cJeJMcp7sC52DyL6bwnS3Q50lKNcBG+qHcsUrAW9LWlc34i4nNlSbNEuy28hVKED0SFQ
         ioUMF+sHIsYgXNyWCvaDLKoxZPqojSCpHI4FZc7/Tbb4BXo3KPdgxLDkw3hnV04TvB5a
         Kg8mZOughDmXiak0TS9jQYCxAYwPULfSrHkw+qXZVtpLmpNh5rn8YlM1wSQ+98mz7e8D
         5n4w==
X-Gm-Message-State: AOAM5311UQ2d1udgSHekyuFiFEHwQWW9eQuBEHDWUTa8VQ584C1TiE+7
        wf2e1Wswj+BbKzCa0sE8KXg=
X-Google-Smtp-Source: ABdhPJwx/TQ1fyWBUhEBxzMKoDjXWgi81xMb6vE02IzLHAAtZ0sg03nyELtVs+yiIX/y1qsOzS3FUw==
X-Received: by 2002:a17:90b:4f47:b0:1e3:38c7:70b5 with SMTP id pj7-20020a17090b4f4700b001e338c770b5mr7215818pjb.32.1654053575187;
        Tue, 31 May 2022 20:19:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.23])
        by smtp.gmail.com with ESMTPSA id i13-20020a056a00004d00b0050dc76281d3sm184691pfk.173.2022.05.31.20.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 20:19:34 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/pmu: Avoid exposing Intel BTS feature
Date:   Wed,  1 Jun 2022 11:19:25 +0800
Message-Id: <20220601031925.59693-3-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601031925.59693-1-likexu@tencent.com>
References: <20220601031925.59693-1-likexu@tencent.com>
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

The BTS feature (including the ability to set the BTS and BTINT
bits in the DEBUGCTL MSR) is currently unsupported on KVM.

But we may try using the BTS facility on a PEBS enabled guest like this:
    perf record -e branches:u -c 1 -d ls
and then we would encounter the following call trace:

 [] unchecked MSR access error: WRMSR to 0x1d9 (tried to write 0x00000000000003c0)
        at rIP: 0xffffffff810745e4 (native_write_msr+0x4/0x20)
 [] Call Trace:
 []  intel_pmu_enable_bts+0x5d/0x70
 []  bts_event_add+0x54/0x70
 []  event_sched_in+0xee/0x290

As it lacks any CPUID indicator or perf_capabilities valid bit
fields to prompt for this information, the platform would hint
the Intel BTS feature unavailable to guest by setting the
BTS_UNAVAIL bit in the IA32_MISC_ENABLE.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 3 +++
 arch/x86/kvm/vmx/pmu_intel.c | 4 +++-
 arch/x86/kvm/x86.c           | 6 +++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 8fbce2bc06d9..c1b61671ba1e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -8,6 +8,9 @@
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
 
+#define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
+					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
+
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ddf837130d1f..967fd2e15815 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -634,6 +634,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
 
+	vcpu->arch.ia32_misc_enable_msr |= (MSR_IA32_MISC_ENABLE_BTS_UNAVAIL |
+					    MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL);
+
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
 		return;
@@ -725,7 +728,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	} else {
-		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7460b9a77d9a..22c3c576fbc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3565,12 +3565,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_MISC_ENABLE: {
 		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
-		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON |
-			MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_PMU_RO_MASK |
+			MSR_IA32_MISC_ENABLE_EMON;
 
 		/* RO bits */
 		if (!msr_info->host_initiated &&
-		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL))
+		    ((old_val ^ data) & MSR_IA32_MISC_ENABLE_PMU_RO_MASK))
 			return 1;
 
 		/*
-- 
2.36.1

