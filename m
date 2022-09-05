Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2745D5AD30C
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiIEMn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 08:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiIEMnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 08:43:16 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B942127B;
        Mon,  5 Sep 2022 05:40:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 78so7991565pgb.13;
        Mon, 05 Sep 2022 05:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=ssoGUZ4ZbkC1Wv+R+3XnE7I13lbD204WKPkjTaaF05k=;
        b=ATYARh2Ur/LSsSPMV1rkDqhpPw3L5aiffvYBBla6LjE489AIe0SnPi4ZDVw/82VZ98
         w3DiE6JCVCi6NmQXtUao5HPwxXV/Dfosc8I0yF7KwfgDdACpg7H0XfNX8gatqn0vrbAL
         WtxgyPIbdVHxCJ0YrQ6nhXi1HD7sd1pQTl5whOG7oysVhEZRu67ybFjKACkbvXUPi2oT
         Fn0z5YSCmbFdrhi9lfqsg3PHyKo4k4ZxUCzctcst6nws4EsYG+7sbu7EZMiF72eo/UPU
         I2PWFdTxC3yPuftq/D22GyYz3vOXinFT2AwCX7EnI4TiQ0yOFP6fxe5RJg5eLBIr5/Qv
         hShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ssoGUZ4ZbkC1Wv+R+3XnE7I13lbD204WKPkjTaaF05k=;
        b=HrAbVOYM3SYpDmXRQVTFI3kird/2tvrK4yToyvQ/b7mwPVsUlhpHxlyXNUGiS2YCeu
         aMGerA27v2A1AOZE1jSLGQmpfXdOMAMll6pHLheJq/HG8059TTdtGIJrRBy01rTTzH/0
         j7Ri0cFoFaPiOzBHtFGnHOJ8M8UDyI9iIX99D3esRoIPYLE7PNY0S9aYYWsNU7v56fRD
         LRLrP4ww6QyFFwH6yYA8EiutIgi46BHNc1PdtADGihcsX25pME21fk9UrUaE5MMGffBi
         uNJVB1xlN6QUbXygxhzgqm+Laws2XtaDZh3LcMxRpRSHcP7MCJf8A7oiKV0/MzyzX15n
         DCpw==
X-Gm-Message-State: ACgBeo3VqICjIrhWqkKijvjT6TG8+9tC5usOsgvGuYzgUwVfowoKjn2S
        ky/kRIhCD8PUzGti/+VmEYU=
X-Google-Smtp-Source: AA6agR4GGSOx7YIggzyYMOLvTQHUbP/ZbPK3rKLsUvWRMzka5/DviEnu5+qfYjgCa6iuI0TR3DagSw==
X-Received: by 2002:a63:40e:0:b0:42b:890d:594e with SMTP id 14-20020a63040e000000b0042b890d594emr38732333pge.331.1662381606782;
        Mon, 05 Sep 2022 05:40:06 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902ec8800b00168dadc7354sm7428431plg.78.2022.09.05.05.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 05:40:06 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sandipan Das <sandipan.das@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] KVM: x86/svm/pmu: Limit the maximum number of supported GP counters
Date:   Mon,  5 Sep 2022 20:39:41 +0800
Message-Id: <20220905123946.95223-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220905123946.95223-1-likexu@tencent.com>
References: <20220905123946.95223-1-likexu@tencent.com>
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

The AMD PerfMonV2 specification allows for a maximum of 16 GP counters,
which is clearly not supported with zero code effort in the current KVM.

A local macro (named like INTEL_PMC_MAX_GENERIC) is introduced to
take back control of this virt capability, which also makes it easier to
statically partition all available counters between hosts and guests.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h     | 2 ++
 arch/x86/kvm/svm/pmu.c | 7 ++++---
 arch/x86/kvm/x86.c     | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 847e7112a5d3..e3a3813b6a38 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -18,6 +18,8 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+#define KVM_AMD_PMC_MAX_GENERIC	AMD64_NUM_COUNTERS_CORE
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 2ec420b85d6a..f99f2c869664 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -192,9 +192,10 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > INTEL_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(AMD64_NUM_COUNTERS_CORE > KVM_AMD_PMC_MAX_GENERIC);
+	BUILD_BUG_ON(KVM_AMD_PMC_MAX_GENERIC > INTEL_PMC_MAX_GENERIC);
 
-	for (i = 0; i < AMD64_NUM_COUNTERS_CORE ; i++) {
+	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC ; i++) {
 		pmu->gp_counters[i].type = KVM_PMC_GP;
 		pmu->gp_counters[i].vcpu = vcpu;
 		pmu->gp_counters[i].idx = i;
@@ -207,7 +208,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	for (i = 0; i < AMD64_NUM_COUNTERS_CORE; i++) {
+	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43a6a7efc6ec..b9738efd8425 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1444,12 +1444,14 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
+	/* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
 	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
-- 
2.37.3

