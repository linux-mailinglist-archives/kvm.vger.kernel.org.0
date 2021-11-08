Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA3447E92
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 12:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbhKHLNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 06:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbhKHLNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFB7C061570;
        Mon,  8 Nov 2021 03:11:00 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s13so1388067pfd.7;
        Mon, 08 Nov 2021 03:11:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gavCSuL1t3IJ6cNjx1GF8/Zg+Uk5+9JidRW6NUy4gzQ=;
        b=pHKLgCrCRCn/9efAstnxPLP/BbSrdHgo8pq4qptZiSvxYkXfzpr9NrpCSc+LAfLP4u
         HwAIR8Ow1IxfCqyecP4i/nNbSp70bVfs+oc55thLD1M838F+WrMF63QePFIp1xwKgWZF
         G0ZDLpq4CAeLjF2AX78IHddpJoiLs0OVByjsmpOduGcVnHtjy7uJ4Z3jqLd7zm3sxXJV
         FkDmqJ241A30dBRQbHn+7Wl6yHo29C52e/ndkYsssuUNN2SmAMUB0WWnQ+9rldTURr3y
         OO7O9Vw5PIt091luPJIIKcV7Eo5+87EYMhjE3DKLZsRR2YLMOvTjrEDF3G2b01WAYZuy
         p3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gavCSuL1t3IJ6cNjx1GF8/Zg+Uk5+9JidRW6NUy4gzQ=;
        b=yd+Dxt4S7kJJsJ9H0/IF33YHJIc0ucUB7SQhAJN+cA8VVP36lXxaH5rHcmEEnRn7h0
         N/LlT+UfVBas3F9PsjswK8NY5DsCf4osM82CKaCrqLPXT7T18fu8r4S8xU52xLikONhg
         EwrgMpgm4tZW51Vr1LyE5yGY53zElRBDRQUGiVhnbfDjC1zxwahaCD8R+AQc5bmhFr5G
         UrlqgB1EKYiQZouA2DIaqYRkQFpifzoOswrxAdOaOmbjxxUjCphDrK8hE4kBHYc92OAo
         QZypiKHlY+pMf3Y9GWDu0G/S8HPqnBBNehBtIfAOth/SgDJNWH8Ts0VW7nGIywpSpMs2
         Rp8g==
X-Gm-Message-State: AOAM531irQj/ANEPntBSmrUNDZaJvpcEQ8kJ+MF8GrIVeIoiOCumDULK
        suONh01ncr2jn36H3wzGANBkt0s4osk=
X-Google-Smtp-Source: ABdhPJzD3D0h1+Y17yTAygoSu70TFGj9obOC44TLynUMBFVhlTsV0al22glG78QBEWMIIZRwtCdR4A==
X-Received: by 2002:a63:3c4c:: with SMTP id i12mr58896041pgn.447.1636369860305;
        Mon, 08 Nov 2021 03:11:00 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ne7sm16559483pjb.36.2021.11.08.03.10.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 03:11:00 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] KVM: x86: Introduce definitions to support static calls for kvm_pmu_ops
Date:   Mon,  8 Nov 2021 19:10:31 +0800
Message-Id: <20211108111032.24457-7-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108111032.24457-1-likexu@tencent.com>
References: <20211108111032.24457-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Use static calls to improve kvm_pmu_ops performance. Introduce the
definitions that will be used by a subsequent patch to actualize the
savings. Add a new kvm-x86-pmu-ops.h header that can be used for the
definition of static calls. This header is also intended to be
used to simplify the defition of amd_pmu_ops and intel_pmu_ops.

Like what we did for kvm_x86_ops, 'pmu_ops' can be covered by
static calls in a simlilar manner for insignificant but not
negligible performance impact, especially on older models.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 32 ++++++++++++++++++++++++++
 arch/x86/kvm/pmu.c                     |  6 +++++
 arch/x86/kvm/pmu.h                     |  5 ++++
 3 files changed, 43 insertions(+)
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
new file mode 100644
index 000000000000..b7713b16d21d
--- /dev/null
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#if !defined(KVM_X86_PMU_OP) || !defined(KVM_X86_PMU_OP_NULL)
+BUILD_BUG_ON(1)
+#endif
+
+/*
+ * KVM_X86_PMU_OP() and KVM_X86_PMU_OP_NULL() are used to
+ * help generate "static_call()"s. They are also intended for use when defining
+ * the amd/intel KVM_X86_PMU_OPs. KVM_X86_PMU_OP() can be used
+ * for those functions that follow the [amd|intel]_func_name convention.
+ * KVM_X86_PMU_OP_NULL() can leave a NULL definition for the
+ * case where there is no definition or a function name that
+ * doesn't match the typical naming convention is supplied.
+ */
+KVM_X86_PMU_OP(find_arch_event);
+KVM_X86_PMU_OP(find_fixed_event);
+KVM_X86_PMU_OP(pmc_is_enabled);
+KVM_X86_PMU_OP(pmc_idx_to_pmc);
+KVM_X86_PMU_OP(rdpmc_ecx_to_pmc);
+KVM_X86_PMU_OP(msr_idx_to_pmc);
+KVM_X86_PMU_OP(is_valid_rdpmc_ecx);
+KVM_X86_PMU_OP(is_valid_msr);
+KVM_X86_PMU_OP(get_msr);
+KVM_X86_PMU_OP(set_msr);
+KVM_X86_PMU_OP(refresh);
+KVM_X86_PMU_OP(init);
+KVM_X86_PMU_OP(reset);
+KVM_X86_PMU_OP_NULL(deliver_pmi);
+KVM_X86_PMU_OP_NULL(cleanup);
+
+#undef KVM_X86_PMU_OP
+#undef KVM_X86_PMU_OP_NULL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 353989bf0102..bfdd9f2bc0fa 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -50,6 +50,12 @@
 struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_pmu_ops);
 
+#define	KVM_X86_PMU_OP(func)	\
+	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
+				*(((struct kvm_pmu_ops *)0)->func))
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b2fe135d395a..40e0b523637b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -45,6 +45,11 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
+#define	KVM_X86_PMU_OP(func)	\
+	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.33.0

