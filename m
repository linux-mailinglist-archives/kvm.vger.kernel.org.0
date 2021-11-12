Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B944E436
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbhKLJyv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhKLJys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 04:54:48 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE53EC0613F5;
        Fri, 12 Nov 2021 01:51:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so5849922pjb.1;
        Fri, 12 Nov 2021 01:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mSUYYsI1RoLVeho4NqLoOx8k8Av4Oi06Kuv482qZLWA=;
        b=NYuTpDFFmQnKYnMPZXsrt2g2lMsVCOYYJv/1+Pp3tmCYt2qKVeibdDEbgyUo6ZS1l+
         E5pNsqoNqyPDFAogrBzPtegEtqlwztAbWPT9v/R0cJwoBF6HQzEMTcbS0Ad6lYioFoiv
         1hHYETopAT1L7uYuBJYeNgZb4z+eqeriVEiBRlKSDcDEWJj1Fyhljlhun7jIid5KCUgL
         ML4lTrdYIznqstnzc05K8Nzdp6FRXxkcdkbX2ePXS1QvktskTAemJScqxsH0czyRTi0Y
         Rfb3oPqcjEL2Bcb68qP+2Lr3/qKBDwleMmReWdFu33cJPFM2+7W/57OTVAeYC9xhYk6L
         8Kvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mSUYYsI1RoLVeho4NqLoOx8k8Av4Oi06Kuv482qZLWA=;
        b=PMoJKvTZLN1rlih0KC+O/jNBwz7kgIbS0BP5UScbcCZrsJxW7Z6h9Yr6qyghDDIAXk
         VIz9cF6zphejaQtWMxeU+WBebMf9SSCkYlQEa6ES/5A0tNXCv0qtmXrdFBmujEctcuHR
         QYkR8rs5YjI0yy98bq+tvb3lS/HjMtxrheHup221sNUcN6aTUsTtzGU4YIFvI+GIznZX
         9ZkDjTnA0Id+tXzbPdy3d+0WbpWFP3eJlM2gusyuTZOTUraO12UV5EzHlulrqGN4Cjrr
         9tNMDF1VwiQJPr4PCZz/YeENcEXNF0BvJDEbgckVhiYWu0MLX7n/XGiDkRryKK1Sp/sb
         J0fg==
X-Gm-Message-State: AOAM532avVDpayiH5MaRsfrdAwlGXPa4JrrlsXkIMcKKHt6aTiyZxlc2
        8kL0fi9jfbwInxwiqrPcgnI=
X-Google-Smtp-Source: ABdhPJwRMajZL6saDgpIQEf3QkiIMT9eQyx9EHB+VKOP+y+2FQby0nlhNpwpgooORTPlhf+1mAYYZA==
X-Received: by 2002:a17:90a:df14:: with SMTP id gp20mr34664052pjb.186.1636710717398;
        Fri, 12 Nov 2021 01:51:57 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f3sm5799403pfg.167.2021.11.12.01.51.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Nov 2021 01:51:57 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 3/7] KVM: x86/pmu: Pass "struct kvm_pmu *" to the find_fixed_event()
Date:   Fri, 12 Nov 2021 17:51:35 +0800
Message-Id: <20211112095139.21775-4-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211112095139.21775-1-likexu@tencent.com>
References: <20211112095139.21775-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The KVM userspace may make some hw events (including cpu-cycles,
instruction, ref-cpu-cycles) not work properly by marking bits in the
guest CPUID 0AH.EBX leaf, but these counters will still be accessible.

As a preliminary preparation, this part of the check depends on the
access to the pmu->available_event_types value in the find_fixed_event
as well as find_arch_event().

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           | 3 ++-
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0772bad9165c..7093fc70cd38 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -245,6 +245,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 	bool pmi = ctrl & 0x8;
 	struct kvm_pmu_event_filter *filter;
 	struct kvm *kvm = pmc->vcpu->kvm;
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
 	pmc_pause_counter(pmc);
 
@@ -268,7 +269,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 
 	pmc->current_config = (u64)ctrl;
 	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
-			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
+			      kvm_x86_ops.pmu_ops->find_fixed_event(pmu, idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
 			      pmi, false, false);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0e4f2b1fa9fb..fe29537b1343 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -26,7 +26,7 @@ struct kvm_event_hw_type_mapping {
 struct kvm_pmu_ops {
 	unsigned (*find_arch_event)(struct kvm_pmu *pmu, u8 event_select,
 				    u8 unit_mask);
-	unsigned (*find_fixed_event)(int idx);
+	unsigned int (*find_fixed_event)(struct kvm_pmu *pmu, int idx);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index fdf587f19c5f..3ee8f86d9ace 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -152,7 +152,7 @@ static unsigned amd_find_arch_event(struct kvm_pmu *pmu,
 }
 
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-static unsigned amd_find_fixed_event(int idx)
+static unsigned int amd_find_fixed_event(struct kvm_pmu *pmu, int idx)
 {
 	return PERF_COUNT_HW_MAX;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index bc6845265362..4c04e94ae548 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -86,7 +86,7 @@ static unsigned intel_find_arch_event(struct kvm_pmu *pmu,
 	return intel_arch_events[i].event_type;
 }
 
-static unsigned intel_find_fixed_event(int idx)
+static unsigned int intel_find_fixed_event(struct kvm_pmu *pmu, int idx)
 {
 	u32 event;
 	size_t size = ARRAY_SIZE(fixed_pmc_events);
-- 
2.33.0

