Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7597A534C17
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 10:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346740AbiEZI6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 04:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346743AbiEZI6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 04:58:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C24C5E71;
        Thu, 26 May 2022 01:57:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b5so916047plx.10;
        Thu, 26 May 2022 01:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z/aK1HVjWaZDKT3C6HDZPJDX4pSdyTJAvLiL+3q+10I=;
        b=fnCj85xWRNBNPLSX5Lfd59eeCOL9G6A0HsvjvjG9TEjrlvkEjVEafCo9oZrgtYmnlE
         1hmS0o+RYbCCSrv6tiaB63enPQuDZqNCieG+OzXRbIz8eZA6okwO7oBZdeDz3af1hA8O
         n7IDm8EmrYXa/Ht9YUh+XjpbeBE0Yw3fRNpE2+1ZsIA1SS0pYFf6JikdzjCXYnu3j762
         vMQ072Jwyt1vQas29DPDjt/oSeFqV244vTCtyEX1tZ20uTM6KyKZEeDIIwRFRufvfbkB
         v0sgdCJjzn2nqnoaIJc65tK8y9dCbsEqY4IWMptAJJDSKT+3rJcGik45r1IHhPEenxq2
         NfyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z/aK1HVjWaZDKT3C6HDZPJDX4pSdyTJAvLiL+3q+10I=;
        b=LCO6+L00fxI23cZCVL8IK7fuFlMCdoRsfr7ptopyHG6s7SgZCHKvF7PGu3ksTqsBgB
         Oe6d/lt/CeIydZYLRWAVujFhnSLv1Np3U0+PZTpIXDlatd3eqUf2MXXmImzbTJ3Rc1iO
         MNPsn/IRAgUAD+W0ixEsT7Pd0DeoJjNGaOMlrFJ6mWYSwVmavIS+tiqnhRlXS0RmcfgN
         FjcToQ6L12gN5DsnE0WHP/4VD1YoH1CCivKZgL1aZ4hyfgct6gxXfQlzl8OCJz1M6d+b
         hNJCTNhcJ80X1MYT1eVlINugLP0TAuI+sFqR5xIFFuScnHZhdyKMxeFowoMTlIQEIHnl
         yk6A==
X-Gm-Message-State: AOAM530zP8n5Kr8MgMd/3SeJ29SGK3EpmjCblVeElDYa5AbCE9Z5ayIr
        sJjiILa7BfCFcMyitrrrw+c=
X-Google-Smtp-Source: ABdhPJxaHm1sD3Pn9AyRjXJ/E271UjGHMu0ckZ3UGrSIEMkq3gA1c2JPGyBqJnkyw8p5PxLJQGltZA==
X-Received: by 2002:a17:902:7c96:b0:162:3071:3266 with SMTP id y22-20020a1709027c9600b0016230713266mr16376584pll.119.1653555475792;
        Thu, 26 May 2022 01:57:55 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.22])
        by smtp.gmail.com with ESMTPSA id p1-20020a170902f08100b0015eb200cc00sm894378pla.138.2022.05.26.01.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:57:55 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yanfei Xu <yanfei.xu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Update pmu->pebs_enable_mask with actual counter_mask
Date:   Thu, 26 May 2022 16:57:23 +0800
Message-Id: <20220526085723.91292-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
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

The blamed commit is posted before the PEBS merge in, but is applied after
the latter is merged in. Fix dependency of pebs_enable_mask on
a new reusable counter_mask instead of zero-initialized global_ctrl.

Fixes: 94e05293f839 ("KVM: x86/pmu: Don't overwrite the pmu->global_ctrl when refreshing")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ddf837130d1f..72bbcb3f9f8a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -621,6 +621,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	struct kvm_cpuid_entry2 *entry;
 	union cpuid10_eax eax;
 	union cpuid10_edx edx;
+	u64 counter_mask;
 	int i;
 
 	pmu->nr_arch_gp_counters = 0;
@@ -672,8 +673,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
 		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
-	pmu->global_ctrl_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
+	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
+	pmu->global_ctrl_mask = counter_mask;
 	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
@@ -713,7 +715,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
 		vcpu->arch.ia32_misc_enable_msr &= ~MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
-			pmu->pebs_enable_mask = ~pmu->global_ctrl;
+			pmu->pebs_enable_mask = counter_mask;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 				pmu->fixed_ctr_ctrl_mask &=
-- 
2.36.1

