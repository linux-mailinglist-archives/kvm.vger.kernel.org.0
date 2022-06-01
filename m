Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29F539B8C
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 05:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbiFADTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 23:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241329AbiFADTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 23:19:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17598B0A7;
        Tue, 31 May 2022 20:19:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id n13-20020a17090a394d00b001e30a60f82dso4826167pjf.5;
        Tue, 31 May 2022 20:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKgI1HXiOEQjCz4KL5/iiLkMDmHzaI43i9dEIs2R6Zw=;
        b=X2Hndi0YvAZG4nN2Dl8+vVDx1DqrFowIsK7MD1rwsCZpj9ZL+wKlTD8KG59KXzPM0Q
         h2sy8Nf/EcYbfOl/AQ+8QLx2Gxkc6b7FRjYagm3D07AYLvNcA/k2W5r9u00EVInGfk8v
         tcWNQCbPYEZWE/fH+IWk8DN1MluXLhPTqK+06ACEhDx34fS1soK3XU6lYeZmQ7zpjDXg
         cYRnAY4D18rcpsSTKz9ExFrsYYJ1172J9jBeQ15qv2RUXcE8oQZKraVMJjEf+NI1/0L+
         s8cE2U38sKa6JeVC6vdhZJo8nYoTdIUkOAlNv6wQeskkLdi5J1fEfwjiIovmU9dNApW3
         6lbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKgI1HXiOEQjCz4KL5/iiLkMDmHzaI43i9dEIs2R6Zw=;
        b=6m+UCjxcbkJ0Zueo7tFjO3Fwf1+3t6Tvc0rgWO5kfekuYkZpF2myiMZX6lkL7/nFSD
         UHJ70+Z/uoyeYM1ouJBQLNbxem8LWVvdTwxNEl07M21FpgUQq5Gsleuk4z1thFZhWc5D
         Rs4TSPRLI/KurXEbJ9NCBloGQSx3vm/EGLesflQIeWeCFcdTvGG+K8PO3plIen1UDhoO
         hLqdlt2XCO+BNjo3Fh97XR+x4JQWw+6R10MjNkV9VxUGOeyIfYgAvOq+d1Zliz2t9D5y
         ZfGJ+xIa35R6jwIyEWEXW7H/QdegGGuWBeM1zhfFas5DLS45vaGn2OyWZpY3OKR5RO7w
         W+9g==
X-Gm-Message-State: AOAM531jPQPpsoaFNcdQIFRRRBy2uXnbTXUZLcCHPlpa3uqs5B3cI5IY
        t1nbD1z9x6+Bu4c7yzMZYQI=
X-Google-Smtp-Source: ABdhPJzldhxLu11cxwB2qP3x3UP18xW+MjJxmw4zBf2NdyVYkmoE12xWq8wIQGbpJ50NYA0DOT/uDA==
X-Received: by 2002:a17:902:d58a:b0:164:f5d1:82e9 with SMTP id k10-20020a170902d58a00b00164f5d182e9mr2027183plh.3.1654053570422;
        Tue, 31 May 2022 20:19:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.23])
        by smtp.gmail.com with ESMTPSA id i13-20020a056a00004d00b0050dc76281d3sm184691pfk.173.2022.05.31.20.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 20:19:29 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86/pmu: Accept 0 for absent PMU MSRs when host-initiated if !enable_pmu
Date:   Wed,  1 Jun 2022 11:19:23 +0800
Message-Id: <20220601031925.59693-1-likexu@tencent.com>
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

Whenever an MSR is part of KVM_GET_MSR_INDEX_LIST, as is the case for
MSR_K7_EVNTSEL0 or MSR_F15H_PERF_CTL0, it has to be always retrievable
and settable with KVM_GET_MSR and KVM_SET_MSR.

Accept a zero value for these MSRs to obey the contract.

Signed-off-by: Like Xu <likexu@tencent.com>
---
Note, if !enable_pmu, it is easy to reproduce and verify it with selftest.

 arch/x86/kvm/pmu.c     |  8 ++++++++
 arch/x86/kvm/svm/pmu.c | 11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7a74691de223..3575a3746bf9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -439,11 +439,19 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
 
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu) {
+		msr_info->data = 0;
+		return 0;
+	}
+
 	return static_call(kvm_x86_pmu_get_msr)(vcpu, msr_info);
 }
 
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
+	if (msr_info->host_initiated && !vcpu->kvm->arch.enable_pmu)
+		return !!msr_info->data;
+
 	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
 	return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 256244b8f89c..fe520b2649b5 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -182,7 +182,16 @@ static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr, bool host_initiated)
 {
 	/* All MSRs refer to exactly one PMC, so msr_idx_to_pmc is enough.  */
-	return false;
+	if (!host_initiated)
+		return false;
+
+	switch (msr) {
+	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
+		return true;
+	default:
+		return false;
+	}
 }
 
 static struct kvm_pmc *amd_msr_idx_to_pmc(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.36.1

