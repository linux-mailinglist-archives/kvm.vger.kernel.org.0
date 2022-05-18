Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028AB52BC6C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiERNZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbiERNZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:41 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988E1BB110;
        Wed, 18 May 2022 06:25:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ds11so2056235pjb.0;
        Wed, 18 May 2022 06:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NeZCG7dJ8X7IBI97mKgmMWCWw8QF1msEv0hMGgyhQcg=;
        b=DxAmtSk/vwSdimtJt1g/fLf2Ap6qR9cT6NlBaDi8ZDVDE5YrfzMv4LpwLexJlQyIsM
         vxDbqzxZ3z7c8bQljMo5pvCie34OB458tDIzb8eANUat+hzLLs4GC8xi8TSwNdV+ThyG
         fRO+Fz5+IQ0yKPzyN0n+TdLja2aArTCrhZCi+5nte4Qj1j6I6vkvU1G4mx7ok7kj3NTE
         IiS64NZL+TcC6gQaOFC+lvKSSGOqsJ6Dci4bQZ/Y0tdJwpoahAwhsEYJPBPoCnA+uFoO
         IDIOVRN+Gvk8XwuRrno8orNHXdcTQDegc7BUdfkwL1eYbTD34Jq6KsBOQkuD9Ee1XTOq
         0IhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeZCG7dJ8X7IBI97mKgmMWCWw8QF1msEv0hMGgyhQcg=;
        b=0XeHQ3Rek4bLfyB+dfZfHdbhG42NvZbw2pk9pCjYmn4cP7nkyJ/iubVSzidk2CICO/
         Xtl2KRBGsCMZVmvGEIdCf0ajAx/WfL6zMz1cNVzH0nYtNFMB1csds/BdAiceemQRh/Q0
         FuSPRIRrU7BJtmnAgq03mvl9XZsyB226R9fls1eXOzzzaDdk8umpEK06r9vk0g7tnecu
         1fqLYokIIdv6K7prVv2V697cIk/h/FwybfdobpxRWwgaPE2DR3gPeILpSKgx3BuzScJt
         h0q7TUD7AzDJfktLB65Xm1u26H9WwWA9qiLLO0+Tz3G8sDKXXuDZxUEwuYIrAipf7gTJ
         iCVw==
X-Gm-Message-State: AOAM5308K+HheLPfvYG+tbhVPT4jAJaXJOutfaRtdGG0AMuva44vlr6+
        aiaaRVhuiEUGZVy8sc5jPVQ=
X-Google-Smtp-Source: ABdhPJyDCmd1LTRsJXAvLyDHsDb//pTia52o/FrIaKpbCYajJ9sE0SBksKM26YNndySXpnNEuqxhcA==
X-Received: by 2002:a17:902:cec9:b0:15f:3f5d:882a with SMTP id d9-20020a170902cec900b0015f3f5d882amr28219229plg.132.1652880330875;
        Wed, 18 May 2022 06:25:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:30 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 05/11] KVM: x86/pmu: Drop "u64 eventsel" for reprogram_gp_counter()
Date:   Wed, 18 May 2022 21:25:06 +0800
Message-Id: <20220518132512.37864-6-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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

Because inside reprogram_gp_counter() it is bound to assign the requested
eventel to pmc->eventsel, this assignment step can be moved forward, thus
simplifying the passing of parameters to "struct kvm_pmc *pmc" only.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 7 +++----
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 6 ++++--
 arch/x86/kvm/vmx/pmu_intel.c | 3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index ba767b4921e3..cbffa060976e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -275,17 +275,16 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return allow_event;
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
+void reprogram_gp_counter(struct kvm_pmc *pmc)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 eventsel = pmc->eventsel;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
 
-	pmc->eventsel = eventsel;
-
 	pmc_pause_counter(pmc);
 
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
@@ -350,7 +349,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 void reprogram_counter(struct kvm_pmc *pmc)
 {
 	if (pmc_is_gp(pmc))
-		reprogram_gp_counter(pmc, pmc->eventsel);
+		reprogram_gp_counter(pmc);
 	else {
 		int idx = pmc->idx - INTEL_PMC_IDX_FIXED;
 		u8 ctrl = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl, idx);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0fd2518227f7..56204f5a545d 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -172,7 +172,7 @@ static inline void kvm_init_pmu_capability(void)
 					     KVM_PMC_MAX_FIXED);
 }
 
-void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
+void reprogram_gp_counter(struct kvm_pmc *pmc);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmc *pmc);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 47e8eaca1e90..fa4539e470b3 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -285,8 +285,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
 		data &= ~pmu->reserved_bits;
-		if (data != pmc->eventsel)
-			reprogram_gp_counter(pmc, data);
+		if (data != pmc->eventsel) {
+			pmc->eventsel = data;
+			reprogram_gp_counter(pmc);
+		}
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 33448482db50..2bfca470d5fd 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -484,7 +484,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
-				reprogram_gp_counter(pmc, data);
+				pmc->eventsel = data;
+				reprogram_gp_counter(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-- 
2.36.1

