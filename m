Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B7A4EAEB3
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237480AbiC2NsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 09:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiC2NsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 09:48:21 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B59015DAA7;
        Tue, 29 Mar 2022 06:46:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso2063623pjb.0;
        Tue, 29 Mar 2022 06:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgrXCQ8DvR6aFcMp2z2Iko9WKtMTYjOnny8m9XfH5bc=;
        b=YWwQABy4/xNVwdoOYNasx7+NdRGiiSGwW35gcliM/ZKz1a8HQaShPge5Cn+ONI+HNN
         YcDS4BS3OLm6ra8vy3Qer7tCSuCsPdBaj9oBfcuDGHS2g5UKRI8c8Acv6QGtqKQNpqqg
         5YQ4Sr9owcyh88tlPzvVoWGWVM2+387hxpz5MopOz3yky05pm+dtNUmm/PndZimXXwzb
         LOtbZ7+7i23XCCgEOVH7unoiZsscJoJHUW5q1lo4XF7X9q9Vf/KdYYV5kMsl0hTt4m4g
         3CV2P4IdZUcqufPGIKWrk1DeV/a1qO+eu9G21GEPpIPevgEGC5/8p79NB/K80rtZeOBl
         yrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wgrXCQ8DvR6aFcMp2z2Iko9WKtMTYjOnny8m9XfH5bc=;
        b=nNiR7hxe9uf7D4qoazG3WQoN+0Kr1KQcA45xB2OXi8/ny9myK7D69DUlqKW7bCerIc
         Ji5CjKZvmvxaNxgMdl21EYopu30CIitvKzw+vPVu1yY7ihtnsy9GygiXeqMGIoz+iKT9
         k2BEnyYWG0PoG5I40DF4mdKw8BurqKSvmSB4RuPG6wkd8m2tng5S5tkIB87dLLbX7SQg
         y3KcJoFOPOW24QQMG8rzSjDMJ0+Tq3Dhg+glPIBs6KMYD9JvG0RpKXSA1sMsh7JeihMT
         8SygfAYSlRFs6r/m9wmrMzjpmGa8OcnzYKVY6CmoldlHwfh4bJ1jghuL7yLmtu3xK46i
         KicA==
X-Gm-Message-State: AOAM531DfxkYjv+P+LcjyQmeokeZtb+YQt94Sv+9VYdb75Y6ptXTIiba
        y4ylXIWHBo3W5qxR0Wc0+DA=
X-Google-Smtp-Source: ABdhPJwM4WO6pMAFONePzLVdD1g92TkttXelonGeF63gcj0pBeRSUwBBF5z123f1t0AkMbWG4vWBMQ==
X-Received: by 2002:a17:902:7796:b0:153:8441:b5c8 with SMTP id o22-20020a170902779600b001538441b5c8mr29830741pll.72.1648561597984;
        Tue, 29 Mar 2022 06:46:37 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m7-20020a056a00080700b004fb28fafc4csm14114571pfk.97.2022.03.29.06.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:46:37 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Update AMD PMC smaple period to fix guest NMI-watchdog
Date:   Tue, 29 Mar 2022 21:46:32 +0800
Message-Id: <20220329134632.6064-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

NMI-watchdog is one of the favorite features of kernel developers,
but it does not work in AMD guest even with vPMU enabled and worse,
the system misrepresents this capability via /proc.

This is a PMC emulation error. KVM does not pass the latest valid
value to perf_event in time when guest NMI-watchdog is running, thus
the perf_event corresponding to the watchdog counter will enter the
old state at some point after the first guest NMI injection, forcing
the hardware register PMC0 to be constantly written to 0x800000000001.

Meanwhile, the running counter should accurately reflect its new value
based on the latest coordinated pmc->counter (from vPMC's point of view)
rather than the value written directly by the guest.

Fixes: 168d918f2643 ("KVM: x86: Adjust counter sample period after a wrmsr")
Reported-by: Dongli Cao <caodongli@kingsoft.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           | 9 +++++++++
 arch/x86/kvm/svm/pmu.c       | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 8 ++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..5e7e8d163b98 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -140,6 +140,15 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event || pmc->is_paused)
+		return;
+
+	perf_event_period(pmc->perf_event,
+			  get_sample_period(pmc, pmc->counter));
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 24eb935b6f85..b14860863c39 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -257,6 +257,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index efa172a7278e..e64046fbcdca 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,15 +431,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
-- 
2.35.1

