Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7800521477
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 13:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241424AbiEJMBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241379AbiEJMB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:01:27 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449775418B;
        Tue, 10 May 2022 04:57:24 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d17so16564763plg.0;
        Tue, 10 May 2022 04:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shkBQ6u+7n2fObSlWwQHgCMPATV4g6HS36NExz20L0w=;
        b=PQRwBWTzYkvG65psGWy3kZMKe/EyYclggxnRLqkt/6n/QbLN+5e7Ft2ksdjrq+WPw/
         yMV4PtGil3G3L4rqfPj32Gj5C/A1G/NauIGQgxgWADiA+ZrrZYb1iSOycyhu+5SgPDXg
         Wi8d9/STee5ANfbUieBNxr5wEOVWtLTUC39cPxevmgTxp0Ncn/tBYNDkQd06pWEsdabn
         EK8colE11fIR8HNmwQ99ruhtUq/6mdXNOIcjL0zbaT7kQ6LP3Uuptw8b4vIRG8N9psV+
         VctK7OmycZVvHnuoOuWTHP7L2UY6bC0+M7BEQpfuVfOXHlVvgLbPebmKiD9L3x2iLk+q
         9zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shkBQ6u+7n2fObSlWwQHgCMPATV4g6HS36NExz20L0w=;
        b=32JrbQHOLKC6LABoAFOq99jH3T6zeXIg3g5MSJEZPrQ1sQyxk2bIVyVBZtKyUcQz6/
         kJraKWwoL9jZwklMytcPQWlWlIiH+rfIZXNIyii81dqAYDS1p6XLTCaDY/PNa+AcwCc2
         KT/7wqy38MEI7/rQZUaXaYLCGrllU/F5N6Yxs6pnYN8TUpSruQCwAtm4d2rjgnbaQ7OO
         1fhW/CwCrYze0q9posQf1b4WUeypqnew57/WOr01HBfH3APnWXki5u5feXvjg2nzBuJ0
         C7V8RVXgQw0noFm2VXqCFGYA13iyEnl+2+lieNxACx/XMRcksPTKSbGI92Bs7i0aZv1b
         wLjA==
X-Gm-Message-State: AOAM530s4cq0+ehGKThTYMWGrNwYwv94ZHVK4xZuydB+SRqumDNZ9pbt
        gvTVFNIxGueDnNO5g5LFU70=
X-Google-Smtp-Source: ABdhPJxE0E0NpdKRSDOPYn/tNURiZIemQGnJ9NLdwCebVEomK7N4OcuWGxqwJ8+az3vdtwf4KQEEww==
X-Received: by 2002:a17:90b:3a83:b0:1dc:b7d4:8395 with SMTP id om3-20020a17090b3a8300b001dcb7d48395mr22931698pjb.173.1652183843744;
        Tue, 10 May 2022 04:57:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.81])
        by smtp.gmail.com with ESMTPSA id m21-20020a62a215000000b0050dc7628194sm10460463pff.110.2022.05.10.04.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 04:57:23 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, sandipan.das@amd.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/pmu: Add fast-path check for per-vm vPMU disablility
Date:   Tue, 10 May 2022 19:57:16 +0800
Message-Id: <20220510115718.93335-1-likexu@tencent.com>
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

Since vcpu->kvm->arch.enable_pmu is introduced in a generic way,
it makes more sense to move the relevant checks to generic code rather
than scattering usages around, thus saving cpu cycles from static_call()
when vPMU is disabled.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 6 ++++++
 arch/x86/kvm/svm/pmu.c       | 3 ---
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 618f529f1c4d..522498945a4a 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -415,6 +415,9 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
 
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 {
+	if (!vcpu->kvm->arch.enable_pmu)
+		return false;
+
 	return static_call(kvm_x86_pmu_msr_idx_to_pmc)(vcpu, msr) ||
 		static_call(kvm_x86_pmu_is_valid_msr)(vcpu, msr);
 }
@@ -445,6 +448,9 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  */
 void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->kvm->arch.enable_pmu)
+		return;
+
 	static_call(kvm_x86_pmu_refresh)(vcpu);
 }
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 57ab4739eb19..68b9e22c84d2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,9 +101,6 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!vcpu->kvm->arch.enable_pmu)
-		return NULL;
-
 	switch (msr) {
 	case MSR_F15H_PERF_CTL0:
 	case MSR_F15H_PERF_CTL1:
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9db662399487..3f15ec2dd4b3 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -493,7 +493,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry || !vcpu->kvm->arch.enable_pmu)
+	if (!entry)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.36.1

