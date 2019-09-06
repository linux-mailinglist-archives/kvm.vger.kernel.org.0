Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B1AC1CE
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389219AbfIFVD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:29 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:42829 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388923AbfIFVD3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:29 -0400
Received: by mail-pl1-f201.google.com with SMTP id t10so4243993plr.9
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pvy5xBJ4sVR8VVUN06klRrkN6IdSpm4Xfk2m+Gn3e8g=;
        b=fNtYv29/D3+jlMDwGuX3KwyxRK4HvPN2dgMwPWy/dhR6W6+lstdOMjCSKcLufGW/5P
         2fhMCnx5zDfIMAJZRnBz3gRtokSR0XQCEEHyux7ko69Jtj06H1RNLa/wOt4VpeOQvEOK
         0dTctUXxM9CxGnGX8J4nKGS/knFcE9g4RJqkwRRuONJzPay/5wL+irQfbYwysWenqudm
         JNpBUesoT82CyofUsEcUEvyrHlsiu32F1a0ytYYm6tb2qInpIAEChv5hnKMFjskur9cu
         pYkrPId0Ygx7KyWPVNWwlzO83tKvKdgqYM5pu0hUUV0MtdH5lpYkJdjyDIk7wD5eanTq
         Bjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pvy5xBJ4sVR8VVUN06klRrkN6IdSpm4Xfk2m+Gn3e8g=;
        b=c1UjQS6AO/Gbpnzd95SC97Vj6cVGcFJ8KnrA9tZOScsfRjR444kcnqvj7tZrWzRE4P
         9nuiF1TJ0vWuwl8ug5wYT083C0TslgKxxs9SoMTRtsbYDy0GKbeicXgRrCrJOpzg4WSn
         LrjWJJEFObxOGBtB3GkJDE5DaEcnkRtdBaT0SlJT/g69BqlGj2jEdE2Wr7QUNT1dclq1
         3xDlr3vqUB1G7gCzQ/GzUBaD8cczG0/izwiSOhqDmmz+RJpVW+zkao1UrYcg95wYrjXd
         Gb04SkanTR6zXHTuvyDdRq1NZKuL9YQikjy6f9XmgcjH5Bhj7T9Lte0evwSF0r98jvKk
         UyQw==
X-Gm-Message-State: APjAAAU4WcrK/mIdktVBMz5FZz1AleK/cXNnQ7z+iTOXTvIWUD0eK/Yg
        DXxpYY1ZYFn2lefseHK4uRZMtJi+R1K2WBOCrrVT9DE9wCtUoEZY1q8qzl2KHQppOU/e+Wjd1N7
        CT5h9ItNRvB274jv9zQ9vAI8k1JGDgk3gpwMdKMOnzRH2+JeIw+QROPzceg==
X-Google-Smtp-Source: APXvYqw5+ungzeO2AZZITfA/X0xpNayQnD4Xft7LFpZiqOVerqGky5jL6Zk/BhsVgdmunreAarpEuKdpsgE=
X-Received: by 2002:a63:9e54:: with SMTP id r20mr9984312pgo.64.1567803807897;
 Fri, 06 Sep 2019 14:03:27 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:07 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-4-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 3/9] KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a helper function to check the validity of a proposed value for
IA32_PERF_GLOBAL_CTRL from the existing check in intel_pmu_set_msr().

Per Intel's SDM, the reserved bits in IA32_PERF_GLOBAL_CTRL must be
cleared for the corresponding host/guest state fields.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/pmu.h           | 6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..67a0f6da567c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -79,6 +79,12 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
 }
 
+static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_pmu *pmu,
+						 u64 data)
+{
+	return !(pmu->global_ctrl_mask & data);
+}
+
 /* returns general purpose PMC with the specified MSR. Note that it can be
  * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
  * paramenter to tell them apart.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e39..963766d631ad 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -223,7 +223,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (pmu->global_ctrl == data)
 			return 0;
-		if (!(data & pmu->global_ctrl_mask)) {
+		if (kvm_is_valid_perf_global_ctrl(pmu, data)) {
 			global_ctrl_changed(pmu, data);
 			return 0;
 		}
-- 
2.23.0.187.g17f5b7556c-goog

