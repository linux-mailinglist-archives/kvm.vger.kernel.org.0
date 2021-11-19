Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41721456A66
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 07:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhKSGwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 01:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhKSGwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 01:52:10 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9587CC061574;
        Thu, 18 Nov 2021 22:49:09 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id m15so7812344pgu.11;
        Thu, 18 Nov 2021 22:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySY5gs4YmNlohZdoUrGBvO2t4ksP1moPL1VkuQOudcA=;
        b=c+T0luO1Z7DW1M8suxXHK4hs4HJWs64viTP6TUFyaZt3U74977+LdEJ8DerkOiXWVG
         HOe4geh7T45+KRr2Qx9X6Fu/LJLSb2bSuK9DIQjNWbAzPthqLV0TJC8SyHWNnHlaGvAR
         0mwvGNd6SjWs2widOjP/Zhg1qWe4+4I+fkBRm3BU1TqfRWtuukuhXE1hN5SdX0qe0kJB
         FtKSek03ykzn9DL5ctlCdrYHkEzxO35cT+GLsPj7tKEDP1mfq13LrYBqqY+2WlL1sYaD
         m4SDyizoBHpLzSgUWfTebyPiohAgEUIDmAlrGCcECYDCjHc347IJvipCSedEIaES93u6
         w3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySY5gs4YmNlohZdoUrGBvO2t4ksP1moPL1VkuQOudcA=;
        b=AFgvQEYGS5hZv1PJxBWp1XKxij/eXOXPdURyEUoqm7AUfO3nMgQzorN03VUT+nJ4oL
         eeJARnwKl+EmzNPDCFUSorfl4N19V3A24B1UNQvjgmGSqYBaHgrRq/YVtE1CHRrylfXa
         6yAKiQfDtxCvPuRqYeBROJ09n5/eyCSXP7QLUwklc2539G/tuX+0+rF9TUNpDneX2HoK
         iWWuatX1TuV8srTZvZHqaKKduNMHaHfgHG86CnojfsgEW3/S7fJMHW19DmxMefw9pMYx
         k2GsskDXYo0OUJvvG2ZGRo7wc37DaccFIyqn5QYBnhA3hOJOVQDLIzzk9r337GY/2i1p
         WU2w==
X-Gm-Message-State: AOAM532FAgaO6BTd0+TxwT9lpImzZpa1GY1dk3nCjv83Cx+I+dVDol2n
        1w7N6uMzXTbIwteiVPloLvk=
X-Google-Smtp-Source: ABdhPJzDcAHy/evao7AX3x06t6sy1xn9rOgE2vnpjqPEpKRSedb6uC7ZbGDtOf/FxXua5wunUPqNJA==
X-Received: by 2002:a05:6a00:1489:b0:49f:daa8:c727 with SMTP id v9-20020a056a00148900b0049fdaa8c727mr62043812pfu.56.1637304549133;
        Thu, 18 Nov 2021 22:49:09 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mr2sm1286928pjb.25.2021.11.18.22.49.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 22:49:08 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
Date:   Fri, 19 Nov 2021 14:48:53 +0800
Message-Id: <20211119064856.77948-2-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119064856.77948-1-likexu@tencent.com>
References: <20211119064856.77948-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The current pmc->eventsel for fixed counter is underutilised. The
pmc->eventsel can be setup for all known available fixed counters
since we have mapping between fixed pmc index and
the intel_arch_events array.

Either gp or fixed counter, it will simplify the later checks for
consistency between eventsel and perf_hw_id.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b7456b2177b..b7ab5fd03681 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -459,6 +459,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 1;
 }
 
+static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
+{
+	size_t size = ARRAY_SIZE(fixed_pmc_events);
+	struct kvm_pmc *pmc;
+	u32 event;
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmc = &pmu->fixed_counters[i];
+		event = fixed_pmc_events[array_index_nospec(i, size)];
+		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
+			intel_arch_events[event].eventsel;
+	}
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -506,6 +521,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
+		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	pmu->global_ctrl = ((1ull << pmu->nr_arch_gp_counters) - 1) |
-- 
2.33.1

