Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD2720BC5
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 00:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbjFBWMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 18:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbjFBWMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 18:12:42 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777001BB
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 15:12:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bacfa4eefd2so3530576276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 15:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685743958; x=1688335958;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hZOQLIvJzczYTMAnaTGjzB0ofTaMaErv1XOCluG82ws=;
        b=ztnEwzy36DzIiYsf21ckOGWKoNk9x0+aF0krJRVhEGILD6FboIXDsRdHNE4nHzs8yQ
         D0nQnrSycvryY8KmsmF2B9P+c4iKhgxXfpMIAYDhOOw8Z3YfjvifOVAHHXtSc+VA4lcv
         vtJB58g21yx16+MjcUO0PWPLRYaen/R1GkwQ2R5DygvBCHRATnuSJUlx9qzrWJAfKbuJ
         PDq3fVh+dV2cn7B7iX8gv4dOVqZwH8Jk56seTtG571ZyY1FT4iGz8sB+Ge3BmXFEKay0
         2jChpUvDjsXGJDyGTqf9E4tDl+OsuY07liagomRKpZ9cdyEwbNKENiZZMzwTBN9qtJQx
         Dnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685743958; x=1688335958;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZOQLIvJzczYTMAnaTGjzB0ofTaMaErv1XOCluG82ws=;
        b=lCD4sTuiYrUnwE7NjaClkxtD3u+ie6NiUbmnAmaAklX1wRMaI0SO3CHAcP+9IqqAKO
         sukBYqmSBbMI8F4wmftJx6RJOYl6/ooXptaYZSisgtydRYp12CjDivD88CHl4kR2vZhY
         67frOHGjjjo9RU8vv6fwqhdPXFYOISj4FMBX7n3t5PrTTZAJc9oEeYX6aCktnXTwEVyL
         hy5U3pEPHeQzDyH08upA0+BG0VmjA996QOrbEwPO1Zzr04fwi+8psbF556jD0XzCiTb+
         gBQMec63aFy6zgnw5oBATt1N8q0+Mol5xm81rlh0DV8Tmzyh3rFPERvOO+kD0P9U5MUj
         5qjA==
X-Gm-Message-State: AC+VfDzOnCWLy0aNwDBk9BaPzHKEo5XH1GHHt4BmbR6fh5wDMRp7ZBk8
        pXojK6SKEGnb6nHKeWrfEnjaMyX9yxU=
X-Google-Smtp-Source: ACHHUZ5kEM4UotGbjNhuGYnPNZSPFcZdv+PhWsaBh77AzL3xpMn6mZn9HFXaERTjVE4vBhdvz3jiI7Tpz7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:728:b0:ba1:d0:7f7c with SMTP id
 l8-20020a056902072800b00ba100d07f7cmr1667909ybt.2.1685743958805; Fri, 02 Jun
 2023 15:12:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 15:12:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602221236.952888-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename global_ovf_ctrl_mask to global_status_mask to avoid confusion now
that Intel has renamed GLOBAL_OVF_CTRL to GLOBAL_STATUS_RESET in PMU v4.
GLOBAL_OVF_CTRL and GLOBAL_STATUS_RESET are the same MSR index, i.e. are
just different names for the same thing, but the SDM provides different
entries in the IA-32 Architectural MSRs table, which gets really confusing
when looking at PMU v4 definitions since it *looks* like GLOBAL_STATUS has
bits that don't exist in GLOBAL_OVF_CTRL, but in reality the bits are
simply defined in the GLOBAL_STATUS_RESET entry.

No functional change intended.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..28bd38303d70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -523,7 +523,7 @@ struct kvm_pmu {
 	u64 global_status;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
-	u64 global_ovf_ctrl_mask;
+	u64 global_status_mask;
 	u64 reserved_bits;
 	u64 raw_event_mask;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..fb96cbfc9ae8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -427,7 +427,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (data & pmu->global_ovf_ctrl_mask)
+		/*
+		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
+		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
+		 */
+		if (data & pmu->global_status_mask)
 			return 1;
 
 		if (!msr_info->host_initiated)
@@ -531,7 +535,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 	pmu->global_ctrl_mask = ~0ull;
-	pmu->global_ovf_ctrl_mask = ~0ull;
+	pmu->global_status_mask = ~0ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
@@ -585,11 +589,17 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
-	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
+
+	/*
+	 * GLOBAL_STATUS and GLOBAL_OVF_CONTROL (a.k.a. GLOBAL_STATUS_RESET)
+	 * share reserved bit definitions.  The kernel just happens to use
+	 * OVF_CTRL for the names.
+	 */
+	pmu->global_status_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
 	if (vmx_pt_mode_is_host_guest())
-		pmu->global_ovf_ctrl_mask &=
+		pmu->global_status_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);

base-commit: b9846a698c9aff4eb2214a06ac83638ad098f33f
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

