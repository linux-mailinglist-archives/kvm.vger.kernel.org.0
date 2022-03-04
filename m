Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F594CD0A7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbiCDJFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbiCDJFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:45 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C7118C7AE;
        Fri,  4 Mar 2022 01:04:58 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id w37so6989699pga.7;
        Fri, 04 Mar 2022 01:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wqAWqtHFfbVYNDLrbuE8MvbnnaQXA5m+KCEAEyf7i8g=;
        b=ILJzeVk2e4smnpL/Uc8gyyQUb/BjmWa948vQm7i3F/fLX48pjRodhWJvBtgyPX8VWT
         LCk9ZWageMhdE8HXJWJPWM+tJfJi83LUb74MVwc7ZnBe7zCyty35L9dnsjW65b1EpYg7
         EUEIwVfhGZob6vqzNHJMBURkhIaGP6NA2hkPtpVPjfAyG5WBpnwciOOc8VUAP1blzpoQ
         3O8/u62XiTKQmjM3beH+OjS4g5kXiD5lJw5D09EVp1pFTEesVitvNcs483eLfJ9w7/iO
         wtACqtZN9ot1f93oN35K0uz3qGAEaD3Kq7ve0CtQQWFQGD/6y5yCfX+ZlhTnKHPRCviI
         AtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wqAWqtHFfbVYNDLrbuE8MvbnnaQXA5m+KCEAEyf7i8g=;
        b=csYVS8oUVxRMmdOnG8FHo/wOFJWKe44OWBOtMbQIkRaif3oS0lWxhIUOLxBv4jRXTi
         T+VokfieFJc5R+7hMIC7nbT/quCxiqw/cT3BGiuIKE+QfEk5nw8eGZtNbl9mHCohFNml
         fLk059ewNn1trW1p5Hhk43+6LSauSfloPT8jX7hGs9g91ZghgS2U2Lr8r8QIrLC3OI9z
         AE3xTDW3FkX870Kd1WlaaJxuAVby7idYnuSUet+Z8hyg82AOJZtUEtjW3N1IrTftVbz5
         GjNarnX1x+Qg4tQwii4spRTbJvKZT1I0jFIZ1/Qa7vRTXYQhitvAb+tMJdrcxPUXogKH
         Umsw==
X-Gm-Message-State: AOAM531qUzBNWYFzItpm3Ql86rl0jUinePPZlG+NaKq4yLxtRWuukSwi
        CqRnrd9BPyiay9nTSmtKzbM=
X-Google-Smtp-Source: ABdhPJzGP6ihfVDOPpJNSMhc2AjW/yI0zGwN7dbP9zOKD9OHsbfYRkopU2LiTSn44GaQaVGFFkQ7vA==
X-Received: by 2002:a05:6a00:9a9:b0:4f3:f293:9ca5 with SMTP id u41-20020a056a0009a900b004f3f2939ca5mr30466217pfg.40.1646384698374;
        Fri, 04 Mar 2022 01:04:58 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:04:58 -0800 (PST)
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
Subject: [PATCH v12 05/17] KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
Date:   Fri,  4 Mar 2022 17:04:15 +0800
Message-Id: <20220304090427.90888-6-likexu@tencent.com>
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

The mask value of fixed counter control register should be dynamic
adjusted with the number of fixed counters. This patch introduces a
variable that includes the reserved bits of fixed counter control
registers. This is a generic code refactoring.

Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c45ab8b5c37f..cf5ce12557f2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -504,6 +504,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_mask;
 	u64 global_ctrl;
 	u64 global_status;
 	u64 counter_bitmask[2];
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 61de7b07489c..c5f885198c60 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -394,7 +394,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		if (pmu->fixed_ctr_ctrl == data)
 			return 0;
-		if (!(data & 0xfffffffffffff444ull)) {
+		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
 			reprogram_fixed_counters(pmu, data);
 			return 0;
 		}
@@ -478,6 +478,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	int i;
 
 	pmu->nr_arch_gp_counters = 0;
 	pmu->nr_arch_fixed_counters = 0;
@@ -485,6 +486,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->fixed_ctr_ctrl_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
@@ -521,6 +523,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		setup_fixed_pmc_eventsel(pmu);
 	}
 
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
 	pmu->global_ctrl_mask = ~pmu->global_ctrl;
-- 
2.35.1

