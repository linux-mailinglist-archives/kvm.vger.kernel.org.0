Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5ED44D0D7B
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 02:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244483AbiCHBZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 20:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCHBZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 20:25:57 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA00626E0
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 17:25:01 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id t62-20020a635f41000000b0037c9ae5fb8bso5881973pgb.19
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 17:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=psAhHMBoTMYTyW1IhfydPNM7SNXgd6D2WdqBQwDlrm8=;
        b=EitQs/EdAnQ6EcwSq49B1JVVB46TLOXYl78CpEnKx4ZDH3BcP5ct3ldxedBp1do/XN
         5tdsHlJDnlv5y2Apz+hxG08Fde/9lni638m0VtMuO4NAQ77FeMjmaY4B+FfMDI8cmHne
         QheLhg7SaPCZecRPTCK/To3pHa8FFHXHFW6uitymYeWOi3nFUCh+0kvWwpD3FtDRG9+O
         /73uf6MuUSIpMMd495+QFUvBroLKOOlH18fYulLXLEEa0lslLW5OlydOQS46wPfSy10U
         jatSkbnVlyq1LQn20N/VYge7rRzXaxP0g/IvMvLI3IRAC5hIbAghChyaGTaCrZk7fkGh
         VNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=psAhHMBoTMYTyW1IhfydPNM7SNXgd6D2WdqBQwDlrm8=;
        b=XHHdvBQoh0FJK1ulDCd0xXQakfG4HCrTcDyJnBia5OBg7ZX50WErUMOlz/4INaBiKd
         RM/Y63KW55lLMsJMopMgwnQ1QWCpkwMNRtKlq8w1HF6yT/4m6LZwkYmXQ72jmbLFetGj
         V8Q3Nd74RgGqxMBKuLBxxhlV+NDQ9U5StLOP3EPhYa3LrfZnpROLYsGtDUJrjx7UEmYg
         bAGZ2XrpAFe3OOI5Y/Y1EIXjjAdpTv0cgbKaJmsDXGD0lWpWiLJIx7BBnA7c3XVtCU0x
         tNBh9FFfFX/DFppYvr/QGheoSbGvwHM335RRPJaeLPa2wAVAZk5YAEbGDX+9D321dNPn
         PH8Q==
X-Gm-Message-State: AOAM530duHVWTPIy+M+uiehZx8NQUc201mhnRoizp65p2+WKZE+wqSSn
        TntvuH7oBxQtp8QOUsIuoqYyBaITdjY0Gw7Y1Fjyrq31hcVxn23qVLZzKo+Yr3AzLL1SNMDi5yu
        ZgHoNGUpYNgDzam2fkDXzvbhhN+5/pxckMxGAAlGVxI2BHQtfKqGKImJ4pGwwdck=
X-Google-Smtp-Source: ABdhPJyCOXBr7g8ebCxtjSsVy9RM5y1Tg8XFe6S45FUTIuUBKXxVFSao0tTC2MB8bsTCKojHr2XdhmhFePXTlA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:3e42:b0:1bf:53ce:f1ef with SMTP
 id t2-20020a17090a3e4200b001bf53cef1efmr1948562pjm.33.1646702701098; Mon, 07
 Mar 2022 17:25:01 -0800 (PST)
Date:   Mon,  7 Mar 2022 17:24:52 -0800
Message-Id: <20220308012452.3468611-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH] KVM: x86/pmu: Use different raw event masks for AMD and Intel
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
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

The third nybble of AMD's event select overlaps with Intel's IN_TX and
IN_TXCP bits. Therefore, we can't use AMD64_RAW_EVENT_MASK on Intel
platforms that support TSX.

Declare a raw_event_mask in the kvm_pmu structure, initialize it in
the vendor-specific pmu_refresh() functions, and use that mask for
PERF_TYPE_RAW configurations in reprogram_gp_counter().

Fixes: 710c47651431 ("KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/pmu.c              | 3 ++-
 arch/x86/kvm/svm/pmu.c          | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c45ab8b5c37f..cacd27c1aa19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -510,6 +510,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 raw_event_mask;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b1a02993782b..902b6d700215 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -185,6 +185,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	u32 type = PERF_TYPE_RAW;
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -221,7 +222,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+		config = eventsel & pmu->raw_event_mask;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 886e8ac5cfaa..24eb935b6f85 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -282,6 +282,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
+	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4e5b1eeeb77c..da71160a50d6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -485,6 +485,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
-- 
2.35.1.616.g0bdcbb4464-goog

