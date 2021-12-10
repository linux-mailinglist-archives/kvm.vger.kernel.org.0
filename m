Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0539B4701BE
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241994AbhLJNjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbhLJNjh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:37 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1453C061D5E;
        Fri, 10 Dec 2021 05:35:54 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q17so6278654plr.11;
        Fri, 10 Dec 2021 05:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P7fOzJhvWhWUMEUeL08jyrm40+FTIEogpFB8ugfuV0M=;
        b=T2TlhkOneVOQerMsi/YH/tPqYJOIT1VbK/BLLlNrgfMb29AkUsRrtRaYt9oGADcvEN
         yuBf/QGEjJ20UUGIS2Hl0mXbaK/WoP9rI/MmbV5uJ93l8M2KfgLUzBCTWMrNf3gTO1Uj
         W73RSD7lrlqksAE7WSUOCrZUtdqBe+k6gYwam6BqjIYeDYt7N4jwqefxHvp8R1IGLARy
         FmWwbqZEFvam5TbLYHlp4p27PsZ6R8CQQmaiiGyNJDQvhcg2wttL5QJYSX+1NBkzU9N4
         +zdxhOBWs+YAcYiC3EpKuOtf4ap/OamCRuIJR9tfWoGEIIKv27ImaVdCW7gnCbpmOrhM
         5cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P7fOzJhvWhWUMEUeL08jyrm40+FTIEogpFB8ugfuV0M=;
        b=D2uaqTfbK36d+DOGOdMH3nRxXlaPH9mkzuWNXTbwFCylhVkxpWL8PthVmjSt91p8UL
         StoIF4JlbWApq3Uhes9wlA4UNZaLRuvHyPdP382psB+8BXoBR7XH57xYgWewq1z+U46+
         vYQYiGoQj2Z2ebKly593NC/rMDVNzrJhUWwVvBXLIZFaEX+VEF2fXaIzP4apNsJKKsUH
         S/I96GNvRYdohcZgyKgyZnMNKPVzBDmWUf/5Aud70cOp77YzXH6C7hOxgPGHlr1E9arJ
         d7jl2+q4TUXxX3WSBQkMvlAalHrIUdR9Ihqa7Ai2wnE7QxJ/RQX3Kz3Lgz7IOSkWWkYO
         QrKw==
X-Gm-Message-State: AOAM530iz/QA6oFZ2mXe2DhEfjKlpI5fbQJam9slHUMXfCzdqGTlEo6n
        IbET2gbcmuTlDeao1XUfvTM=
X-Google-Smtp-Source: ABdhPJzPLh6+7nV7x9R/y1HaliSqwln1biAfUGdGbpr2yqdrJi1ku1l0LydqtVF1e6gHrFZUmbXEIQ==
X-Received: by 2002:a17:90a:8c0a:: with SMTP id a10mr24096364pjo.58.1639143354578;
        Fri, 10 Dec 2021 05:35:54 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.35.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:35:54 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 04/17] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
Date:   Fri, 10 Dec 2021 21:35:12 +0800
Message-Id: <20211210133525.46465-5-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
detect whether the processor supports performance monitoring facility.

It depends on the PMU is enabled for the guest, and a software write
operation to this available bit will be ignored. The proposal to ignore
the toggle in KVM is the way to go and that behavior matches bare metal.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  1 +
 arch/x86/kvm/x86.c           | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ad0e53b0d7bf..8b9a7686f264 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -490,6 +490,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	if (!pmu->version)
 		return;
 
+	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
 	perf_get_x86_pmu_capability(&x86_pmu);
 
 	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26cb3a4cd0e9..bd331f2e123b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3478,9 +3478,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_tsc_adjust_msr = data;
 		}
 		break;
-	case MSR_IA32_MISC_ENABLE:
+	case MSR_IA32_MISC_ENABLE: {
+		u64 old_val = vcpu->arch.ia32_misc_enable_msr;
+		u64 pmu_mask = MSR_IA32_MISC_ENABLE_EMON;
+
+		/*
+		 * For a dummy user space, the order of setting vPMU capabilities and
+		 * initialising MSR_IA32_MISC_ENABLE is not strictly guaranteed, so to
+		 * avoid inconsistent functionality we keep the vPMU bits unchanged here.
+		 */
+		data &= ~pmu_mask;
+		data |= old_val & pmu_mask;
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
-		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
+		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
@@ -3489,6 +3499,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vcpu->arch.ia32_misc_enable_msr = data;
 		}
 		break;
+	}
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
 			return 1;
-- 
2.33.1

