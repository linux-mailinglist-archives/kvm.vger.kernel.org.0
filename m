Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9FE5BC504
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiISJKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 05:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiISJKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 05:10:33 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFD71F2F2;
        Mon, 19 Sep 2022 02:10:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a29so3828877pfk.5;
        Mon, 19 Sep 2022 02:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=//7IDK9hf5emBmfzIVVyuap+G2fwMaQFUeXvJHIdsMs=;
        b=gF5002VElAisVYUpDNvebYbP7hRiPqpUrVS8yOWP5RaA8boHKoX63kiitR3yNDFx+r
         l2v0MXOluBRwaC4pTstSjE2bHoQ+C/Up/ZySPHNf1uKMReU9yfMMsVSSyD6je3TlxqH/
         eaOFC9VY90mqyYa0AOMGdNEItWRTGu8ix5pQH1x3Q8GdnSQOf9To0LS9WVppt2ittUAC
         dCr3n89qrKXaYbLv4aOS3Rgt0FFTejY51+oqixEcb8G0Ub05ibf/W4hQDBridCiT2qvz
         COTN3q4qQpYjN/EspBa9n7SQJgKl3wLa2FQrUJEybTDB012TtfOWx33V8dvAsOnn/K6n
         gZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=//7IDK9hf5emBmfzIVVyuap+G2fwMaQFUeXvJHIdsMs=;
        b=S+H/sYyohkYh4TIHy3cowcbpEjLu4wsLeEev9xBd/gxrsqf1UDnE+63O3QHvk+Yj/7
         jbsjtjKd7XMmycP88iN48QBK9K+OiKKrIbI5R/SAwTZZtmgHGEKIwgHULXdbaUgbVZtE
         g3oI1XJBGY69dnW4YwfVj2EbV3KrU4FklwLQBWWF+tYzRacbdi/k6f3fleADLwhc5qgD
         +YWRvsjw99a3BiqXNJtsaFJEB1MgZ+pGj3r8HokxHeQWxdHl3mrLIsu7GsJTdn1Yo4E8
         s2hyqr2SHAC5f1BRn4lqayMeDuKcfXK2mJLn88MNNVO1Mjvi6zDSa6c6Pp03iAaN7a4/
         82hA==
X-Gm-Message-State: ACrzQf1KDKnuf9INX48Wf8L5Q/cyzFyXvGJX0+kwfNmsnNnX3eZ9spSD
        i2VDpBR6/8Yl/hz6jdLaq8w=
X-Google-Smtp-Source: AMsMyM6dOaX5R7fVEL9/iJ18oLaiiMNomtLOusIPD++0/0BRut63i2bRM8jGFSpC4bl0XKRvjuQMOA==
X-Received: by 2002:aa7:9717:0:b0:53e:84e4:dceb with SMTP id a23-20020aa79717000000b0053e84e4dcebmr17453406pfg.48.1663578631586;
        Mon, 19 Sep 2022 02:10:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020a63a54f000000b0043395af24f6sm18185684pgu.25.2022.09.19.02.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 02:10:31 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] KVM: x86/pmu: Limit the maximum number of supported AMD GP counters
Date:   Mon, 19 Sep 2022 17:10:08 +0800
Message-Id: <20220919091008.60695-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220919091008.60695-1-likexu@tencent.com>
References: <20220919091008.60695-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/pmu.c          | 7 ++++---
 arch/x86/kvm/x86.c              | 3 +++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17abcf5c496a..1b3094616d87 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -506,6 +506,7 @@ struct kvm_pmc {
 #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
 #define KVM_PMC_MAX_FIXED	3
+#define KVM_AMD_PMC_MAX_GENERIC	AMD64_NUM_COUNTERS_CORE
 struct kvm_pmu {
 	unsigned nr_arch_gp_counters;
 	unsigned nr_arch_fixed_counters;
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f24613a108c5..e696979ee395 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -271,9 +271,10 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
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
@@ -286,7 +287,7 @@ static void amd_pmu_reset(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	int i;
 
-	for (i = 0; i < AMD64_NUM_COUNTERS_CORE; i++) {
+	for (i = 0; i < KVM_AMD_PMC_MAX_GENERIC; i++) {
 		struct kvm_pmc *pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf7eafcbe5ec..368af134f913 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1438,10 +1438,13 @@ static const u32 msrs_to_save_all[] = {
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
+
+	/* This part of MSRs should match KVM_AMD_PMC_MAX_GENERIC. */
 	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
+
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
-- 
2.37.3

