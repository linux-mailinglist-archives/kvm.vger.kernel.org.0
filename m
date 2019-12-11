Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A868E11BE7B
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 21:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfLKUtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 15:49:01 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:37490 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfLKUs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 15:48:58 -0500
Received: by mail-pg1-f201.google.com with SMTP id r2so48789pgl.4
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 12:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q2WftxLFBC38ZplqpzPFiWQPxTVG5vmfpl6ZFdDx0Ls=;
        b=n38F3O5Wj72FHpKAB1iuO1qaxLkiOywJqGKJuKRPX9DRIUOVnbjea5yRxkMvMW08fi
         YLWDubVosTKLT9/ex20DfZ4MzGfCk7Ut5ki6Ovf9RDL/Wfj/XCVCedl/6l+bai2LKPa6
         IHIUk/Y2ejoWqHqahSGxr7E7SCWFzR0tCFExxFpjsAsQ/b+Gkw1gSe1t0XrBruX7JSx2
         0nLnl2vLR/4nil+bA1itCNMwDQuI5QCy8+TPojba4ykkfKBRH08TTHAYGSwtYZUbweAF
         bUw02KELO0yzVboH3k6uwcX///DkmaUdzbbSR57n3esKFCDEKpED2d9tImt571EN+0in
         o3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q2WftxLFBC38ZplqpzPFiWQPxTVG5vmfpl6ZFdDx0Ls=;
        b=E1HamnDuPzSs+3RDYlegmI2uEqNtO7saRdd6NPB/r0nRdEexI6AUmit1wEREgsdwMv
         aSs69eb5UFdqqjb7eWQSiYVOw/0JyjLppTR4ml0cgiQQeuy0JFHVavMJ1qlJKW+r4Xk0
         Hzs27EuDmMXx9eoJL8trF22dcVaOnmcIwUjwImay7dKFOhH7XJrA0DQBUl1UfN741Wf5
         xzcYM96/bK7h+9Q/Fuu+HFss9ygYIJ/5k4Ck7xj/nhJ1+G4fu7/HUB4k5UF+WBe7ZvMU
         pqZPosQ6gt1wsl3b0L2e0cM5F9+j3JOB8aV8Z2bZGVmb8hql9QuPHIdXwK/s3iUrTOJL
         UQ8A==
X-Gm-Message-State: APjAAAWwk+Get9azAF8uVoKd0owGpfEpzqrp0/Rz8AIx0IoCGszMYI4I
        TguXuoZzhEcrgh5NzHsOVr6/o8BTxUzd
X-Google-Smtp-Source: APXvYqySiK3vlCpPDd6XbHVODMh/69JkxMxOx0cp5mxe9k3meq8zOwT030e7RouMU4KGMCKnIX/PHviOs3fX
X-Received: by 2002:a63:31cf:: with SMTP id x198mr6253789pgx.272.1576097337682;
 Wed, 11 Dec 2019 12:48:57 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:47:48 -0800
In-Reply-To: <20191211204753.242298-1-pomonis@google.com>
Message-Id: <20191211204753.242298-9-pomonis@google.com>
Mime-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v2 08/13] KVM: x86: Protect MSR-based index computations in
 pmu.h from Spectre-v1/L1TF attacks
From:   Marios Pomonis <pomonis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        Marios Pomonis <pomonis@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a Spectre-v1/L1TF vulnerability in the get_gp_pmc() and
get_fixed_pmc() functions.
They both contain index computations based on the (attacker-controlled)
MSR number.

Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")

Signed-off-by: Nick Finco <nifi@google.com>
Signed-off-by: Marios Pomonis <pomonis@google.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/kvm/pmu.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7ebb62326c14..13332984b6d5 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_PMU_H
 #define __KVM_X86_PMU_H
 
+#include <linux/nospec.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -102,8 +104,12 @@ static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
 static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
 					 u32 base)
 {
-	if (msr >= base && msr < base + pmu->nr_arch_gp_counters)
-		return &pmu->gp_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_gp_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_gp_counters);
+
+		return &pmu->gp_counters[index];
+	}
 
 	return NULL;
 }
@@ -113,8 +119,12 @@ static inline struct kvm_pmc *get_fixed_pmc(struct kvm_pmu *pmu, u32 msr)
 {
 	int base = MSR_CORE_PERF_FIXED_CTR0;
 
-	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters)
-		return &pmu->fixed_counters[msr - base];
+	if (msr >= base && msr < base + pmu->nr_arch_fixed_counters) {
+		u32 index = array_index_nospec(msr - base,
+					       pmu->nr_arch_fixed_counters);
+
+		return &pmu->fixed_counters[index];
+	}
 
 	return NULL;
 }
-- 
2.24.0.525.g8f36a354ae-goog

