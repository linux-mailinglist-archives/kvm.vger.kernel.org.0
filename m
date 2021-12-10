Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84E04701E5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242574AbhLJNkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242322AbhLJNkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:40:24 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BE8C061D5F;
        Fri, 10 Dec 2021 05:36:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id r130so8534596pfc.1;
        Fri, 10 Dec 2021 05:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BUiijKRugCFKHfUrzCq3Xknkp/kY3YXTtm4X5J5lOSY=;
        b=i4/q98DEUgsofKSi74+YiF98DOe555gdE2dxaSnwrxoVg3ZmcmiksieflZRaveeMpJ
         0+E52GVIyT/r09NOxPygT1pUgIQ3UwYY4rQU4OpZ92VhmdfpunsO/j0s2TU3jr7/ETkk
         k8IQbqVxKpmDnsPlL+MtaoZlSGQMQ1beW0cRURJ9lNn9zwHGZLWpq1HqMyrfu5JAJr6c
         T5p0d9DxHK22ppgAJf3VgCmu57rjLwQBGj+Xr3SMgJzm1IkuWTXj+NS4d0+Xbo63d0Yw
         ere5VMf/ogpnrW8BEQGlS+cEoghGEdmdPohTCkPvRs0RgYEJDT7z3ia/klfgkQXpDMTx
         NDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BUiijKRugCFKHfUrzCq3Xknkp/kY3YXTtm4X5J5lOSY=;
        b=0mETExbq6JlZIqtjHL0U60BIGGwNcmLmDTYclG10z7EAPkKd8hoW6TAGjgOyu6bQY/
         SSEZcUTQxZLLk4QLqlUtPmk1YZOs189y9Xj2M/vaLVVYFAAHcVXXUUDITAcYOvPREaWl
         aW0/rObJ228Mznw7CSyqZNvIXDMYp7nR7LJ+yFptTT1o4bv5eBgpJe5v1i0YtFMc8bgK
         iuonVWUXmF75SWMU1pmDcUkGbcOuAd4u1T9PGkczuMeFshTuXAsIe0BYrZwl48/Wz/mx
         6KaRqE7ejzxblAC5UE7lxQfENft28AdLeDrX4A5ufsCThB4nqP0zPvcofjxS/rIKjS1k
         1f4A==
X-Gm-Message-State: AOAM531jOGMHcvP/u0ZjWVqsLLLaYAgCpGNaApndu1dSM07UTvyUPL6Z
        HYc4LWH6Giu9RXyHc4jjwXlg0hFopIM=
X-Google-Smtp-Source: ABdhPJwuh0YaT3OOzkPoUSn3BmwmahRPjn9wnZsShTiIEKJlFd5eBL1u28WAELPaJXkz1TPBkXz4Xg==
X-Received: by 2002:a63:ea52:: with SMTP id l18mr24572792pgk.114.1639143393017;
        Fri, 10 Dec 2021 05:36:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:32 -0800 (PST)
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
Subject: [PATCH v11 16/17] KVM: x86/cpuid: Refactor host/guest CPU model consistency check
Date:   Fri, 10 Dec 2021 21:35:24 +0800
Message-Id: <20211210133525.46465-17-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

For the same purpose, the leagcy intel_pmu_lbr_is_compatible() can be
renamed for reuse by more callers, and remove the comment about LBR
use case can be deleted by the way.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/cpuid.h         |  5 +++++
 arch/x86/kvm/vmx/pmu_intel.c | 12 +-----------
 arch/x86/kvm/vmx/vmx.c       |  2 +-
 arch/x86/kvm/vmx/vmx.h       |  1 -
 4 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index c99edfff7f82..439ce776b9a0 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -143,6 +143,11 @@ static inline int guest_cpuid_model(struct kvm_vcpu *vcpu)
 	return x86_model(best->eax);
 }
 
+static inline bool cpuid_model_is_consistent(struct kvm_vcpu *vcpu)
+{
+	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
+}
+
 static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 26a6eee1a9f7..f7827b8f0eea 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -161,16 +161,6 @@ static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
 	return get_gp_pmc(pmu, msr, MSR_IA32_PMC0);
 }
 
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * As a first step, a guest could only enable LBR feature if its
-	 * cpu model is the same as the host because the LBR registers
-	 * would be pass-through to the guest and they're model specific.
-	 */
-	return boot_cpu_data.x86_model == guest_cpuid_model(vcpu);
-}
-
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 {
 	struct x86_pmu_lbr *lbr = vcpu_to_lbr_records(vcpu);
@@ -581,7 +571,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 
-	if (intel_pmu_lbr_is_compatible(vcpu))
+	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
 		lbr_desc->records.nr = 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8d0df12a608c..bd53f39e6283 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2216,7 +2216,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PMU_CAP_LBR_FMT) !=
 			    (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT))
 				return 1;
-			if (!intel_pmu_lbr_is_compatible(vcpu))
+			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1b2daf6b9c10..172df8739640 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -95,7 +95,6 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
 void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
-bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
-- 
2.33.1

