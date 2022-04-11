Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F124FB95C
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345331AbiDKKXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345475AbiDKKWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CD941F96;
        Mon, 11 Apr 2022 03:20:29 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y8so9038582pfw.0;
        Mon, 11 Apr 2022 03:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xoMBpnSEunsJDVc9W25Zbl0+g3/+rjVG4pywLxdaxu8=;
        b=q1GJTWEAHrQ7MeLlmhTi+JGVsHpz84VaFxdo8pdubh3H5yGA/JBHuLQRqJf9Ok4Rvt
         A1zyBoPMbBXsEl+a/7I2TLY12rjlRioNvHElRzM8lTeOymQ4aorEqXjRUJyQ/M823t5N
         vGll/5GKSu18G/jAEoj+lkuz6khhQZoE7/CwqV7TBi625PZh7S3Lk2JJLAVv9uMMsOZE
         cFEZM1ZHy2dCItW5sInJOfEM0aAmnFA2KFN9D26F2gS1bhObQtOksUUCgaqgrZ4gLwUv
         2ioo8SpHIwO206zezh+Npgv6BdH015BbJkhTNpSMDleTq6Ci786DEeg+G4YsNyj0/9Yb
         /FXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xoMBpnSEunsJDVc9W25Zbl0+g3/+rjVG4pywLxdaxu8=;
        b=ydw3htk1CDgsWWXz1AoIE9eUDtcoGMUTYtdc0DibsN2yA0SWAgr250RlaL9FSwApP0
         kFLFSgnvlkY6VK8PP0A+Lem9bVElfUaSkDVulhBDRMQYCf1HSUma99Iy9GLDuh1HkoKB
         hnHN4gCq5MIu5U9x5UlBa4r4leGh5wBfZU1zNDSU1YL/Y+zxIQMkJ9qLvH+Rr6RnBSH+
         yf6zsrFv8H7JtHb+bkYHr1H4mpLpuXe912OpBi//SalaJOLZtdsYflXIc/Lint6FfI7j
         A8vxDrXN4ATeOtkERtyoMoghOAJIKSK6zMOnWjOisGqz7ayvVjILaI1o0NLMI3gsYjgU
         ZlSA==
X-Gm-Message-State: AOAM533Gj7VHMGn5oQp3AZ5yj1i4BhcaVRA0Rezg2g8Mp9I5rSTvIizM
        9osOJ+5SBrB3LCBD/eTeXnk=
X-Google-Smtp-Source: ABdhPJwn8cgaLC5E/DjyVziHinAkAFcNCN6EcBIzuN1VwSILaW7WTAUlBaljt1A55mEppydy3RzoUg==
X-Received: by 2002:a65:604b:0:b0:398:ebeb:ad8f with SMTP id a11-20020a65604b000000b00398ebebad8fmr26434758pgp.89.1649672429060;
        Mon, 11 Apr 2022 03:20:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 12/17] KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
Date:   Mon, 11 Apr 2022 18:19:41 +0800
Message-Id: <20220411101946.20262-13-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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
index df661b5bbbf1..389f2585f20a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -609,6 +609,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
 
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_mask = ~pmu->global_ctrl;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
@@ -622,6 +623,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	} else {
+		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02142fa244f3..1887b7146da6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3553,7 +3553,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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

