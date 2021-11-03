Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9114443D83
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 08:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKCHGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 03:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbhKCHGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 03:06:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EB2C061714;
        Wed,  3 Nov 2021 00:03:27 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r5so1890884pls.1;
        Wed, 03 Nov 2021 00:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nEzrkqMWOPHSw09kJBsw5hSTh6gQrdiHdsIlswJkoXg=;
        b=HwfD5B5dF9WXE2dzhFVUComcRJ6EdQI4lRQDjf0oi5/F4uo7Z+WSSk5/QN3fB6+CSt
         ek3NJzvPcwMqEozk0Jmk013MzNYLi1Ge5wkMxtdbQWwpMxYU+jw2Iqf8ioz/UQBBaBML
         0YnaKS2bQOC89by9NHAnq0QZ8Tzaj0JvxJjq7LL3vRt7N0FPRIMSHyMBelrkFlDJxILe
         mOic4kXwhDCzKiMpeK36c162UVBem0nBl7kpqlNFexP/lzdg9RfuwOb+zCLmHrh/xpqp
         UpHGS7QRt9A96uAgQi/w9wCOgCIvnC9rgKpJ3oeVtK4pHC4lxe3CkzkxYCdNwz0AnuWa
         VlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nEzrkqMWOPHSw09kJBsw5hSTh6gQrdiHdsIlswJkoXg=;
        b=VXwSCd6Jk9LMWczjcsF7ewMafwFcdNtT2n+Oc+rJtfTnxAEkrKDElPusPt93e6OS7z
         Etv2E8B0Uq1ZZZUb8LORTM5J0jAPDo/xcACsJS14Z4VO3RcBiOz8OJa1SZJl5v86unt9
         KaybHZgs4tuMje/6je2TJFFR/P8LBGjjZU1cx5toc+a+wft7qlvOL+FD7gAbmiqmsGc2
         Y1iDNFyiCickgNQFojjN/qFVSU1MgyanrEE77+jwC7ODTdEmRiwJkF2ku1elu+W9QBq5
         OEkg78lYdWbvCeC03Bt8wRS2uXI4RQJx09B1FQmL/7CQRphqEzzYAx7IjEvszY+sv4Zn
         5hjA==
X-Gm-Message-State: AOAM531Q/YJdNG/TLrZDS4Apb3M7KSVEtpsE54W9mSuz0Tr4gRQryQOl
        fkSpRZCyx/pLU6GHEVlehIM=
X-Google-Smtp-Source: ABdhPJzlo8AIIklSaBIiJncQaZB0PbBnFX6Jq9hTWfYQsRx6gir4zi6kfOldb3VoWyNNERxNPVNZyQ==
X-Received: by 2002:a17:90a:2c02:: with SMTP id m2mr12639696pjd.109.1635923006758;
        Wed, 03 Nov 2021 00:03:26 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x9sm4242564pjp.50.2021.11.03.00.03.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Nov 2021 00:03:26 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Introduce definitions to support static calls for kvm_pmu_ops
Date:   Wed,  3 Nov 2021 15:03:09 +0800
Message-Id: <20211103070310.43380-3-likexu@tencent.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211103070310.43380-1-likexu@tencent.com>
References: <20211103070310.43380-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/kvm/pmu.c                     |  7 ++++++
 arch/x86/kvm/pmu.h                     | 15 ++++++++++++
 3 files changed, 54 insertions(+)
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
index 0db1887137d9..b6f08c719125 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -50,6 +50,13 @@
 struct kvm_pmu_ops kvm_pmu_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_pmu_ops);
 
+#define	KVM_X86_PMU_OP(func)	\
+	DEFINE_STATIC_CALL_NULL(kvm_x86_pmu_##func,	\
+				*(((struct kvm_pmu_ops *)0)->func))
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+EXPORT_STATIC_CALL_GPL(kvm_x86_pmu_is_valid_msr);
+
 static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
 {
 	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index b2fe135d395a..e5550d4acf14 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -3,6 +3,8 @@
 #define __KVM_X86_PMU_H
 
 #include <linux/nospec.h>
+#include <linux/static_call_types.h>
+#include <linux/static_call.h>
 
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
@@ -45,6 +47,19 @@ struct kvm_pmu_ops {
 	void (*cleanup)(struct kvm_vcpu *vcpu);
 };
 
+#define	KVM_X86_PMU_OP(func)	\
+	DECLARE_STATIC_CALL(kvm_x86_pmu_##func, *(((struct kvm_pmu_ops *)0)->func))
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+
+static inline void kvm_pmu_ops_static_call_update(void)
+{
+#define	KVM_X86_PMU_OP(func)	\
+	static_call_update(kvm_x86_pmu_##func, kvm_pmu_ops.func)
+#define	KVM_X86_PMU_OP_NULL	KVM_X86_PMU_OP
+#include <asm/kvm-x86-pmu-ops.h>
+}
+
 static inline u64 pmc_bitmask(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-- 
2.33.0

