Return-Path: <kvm+bounces-56344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D49DCB3BF6A
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0452B586C43
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DF033A028;
	Fri, 29 Aug 2025 15:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="O7uTc3Qi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7667322DDE;
	Fri, 29 Aug 2025 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481592; cv=none; b=YNfnWmL+3sn/hTsCKtZ+vwv1NuDKxEU1yVSdj6HOe1H+4uJKnmwrY/SgJPSiojLu7VcG1R70q0Bbis+ekilov2+OGGTi3Gn9iOTDHan+6f8kFsahswMm3zw/Xr4K9apaEENUHg1jxjkEA6lv5HW90890dIHRJpJqU+8ETncDPYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481592; c=relaxed/simple;
	bh=TajmWRHRpulYaL3Ezgb6JK2nld0TR9mgSOrqKoDxdj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paABnGKZMMqEXrCm2jwRQNVs+R/pv2X3+NJCjQHkjWo7B0oNgqu3A5s9EcJXUpK1OuZksOZDmVfrSbcSeH+VxrbXmSuC+REGxI5+a0j5pyPmjqTXoNntNQzmOINDtg9MB84wHPzYrs6S+7zGRSLnW1ke8wvqL7FDzY+5/97yNg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=O7uTc3Qi; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4D2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:18 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4D2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481539;
	bh=t+WgOmDPWX9Ho3zVppzgC3aSr34E3+f5Z93Cy1TLXmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7uTc3QiBIFpKOEJ3KWvFdzWximz6PJASqESkiKclP7I+dn5LrTLD3tHfkDt7ex+S
	 dTmKzOGxoP4L4OUyt6cEQuO6c66+lEnOyWB74sfpuS/r2+cOr0Htf2vXwnDrYrOESF
	 Yvg3PaaF78Qk1646jkGrcFRfJfj6jC0QMmfKVon1PkF2xMdGm9k2SbPn7DPtExQU/A
	 1A+xYTfW4u8h4IKy+mG88yndan8c+DvLZWl4Dsxxnx+RDnEs6TZORrUTqBjCl5qi+8
	 iRYzieaBJqbTkRpRAwynHR3Yv70KsfdNCbzHSuywL9J5W5YM3cn6eKerDgkKWOUkDi
	 lT4nODLv5LQwg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 07/21] KVM: VMX: Set FRED MSR intercepts
Date: Fri, 29 Aug 2025 08:31:35 -0700
Message-ID: <20250829153149.2871901-8-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

On a userspace MSR filter change, set FRED MSR intercepts.

The eight FRED MSRs, MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
passthrough, because each has a corresponding host and guest field
in VMCS.

Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 (aka MSR_IA32_PL0_SSP)
are dedicated for userspace event delivery, IOW they are NOT used in
any kernel event delivery and the execution of ERETS.  Thus KVM can
run safely with guest values in the two MSRs.  As a result, save and
restore of their guest values are deferred until vCPU context switch,
Host MSR_IA32_FRED_RSP0 is restored upon returning to userspace, and
Host MSR_IA32_PL0_SSP is managed with XRSTORS/XSAVES.

Note, FRED SSP MSRs, including MSR_IA32_PL0_SSP, are available on
any processor that enumerates FRED.  On processors that support FRED
but not CET, FRED transitions do not use these MSRs, but they remain
accessible via MSR instructions such as RDMSR and WRMSR.

Intercept MSR_IA32_PL0_SSP when CET shadow stack is not supported,
regardless of FRED support.  This ensures the guest value remains
fully virtual and does not modify the hardware FRED SSP0 MSR.

This behavior is consistent with the current setup in
vmx_recalc_msr_intercepts(), so no change is needed to the interception
logic for MSR_IA32_PL0_SSP.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v7:
* Rewrite the changelog and comment, majorly for MSR_IA32_PL0_SSP.

Changes in v5:
* Skip execution of vmx_set_intercept_for_fred_msr() if FRED is
  not available or enabled (Sean).
* Use 'intercept' as the variable name to indicate whether MSR
  interception should be enabled (Sean).
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/vmx/vmx.c | 47 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42e179f19c23..368f1799394c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4128,6 +4128,51 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
+{
+	bool intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+		return;
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, intercept);
+
+	/*
+	 * MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP (aka MSR_IA32_FRED_SSP0) are
+	 * designed for event delivery while executing in userspace.  Since KVM
+	 * operates entirely in kernel mode (CPL is always 0 after any VM exit),
+	 * it can safely retain and operate with guest-defined values for these
+	 * MSRs.
+	 *
+	 * As a result, interception of MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP
+	 * is unnecessary.
+	 *
+	 * Note: Saving and restoring MSR_IA32_PL0_SSP is part of CET supervisor
+	 * context management.  However, FRED SSP MSRs, including MSR_IA32_PL0_SSP,
+	 * are available on any processor that enumerates FRED.
+	 *
+	 * On processors that support FRED but not CET, FRED transitions do not
+	 * use these MSRs, but they remain accessible via MSR instructions such
+	 * as RDMSR and WRMSR.
+	 *
+	 * Intercept MSR_IA32_PL0_SSP when CET shadow stack is not supported,
+	 * regardless of FRED support.  This ensures the guest value remains
+	 * fully virtual and does not modify the hardware FRED SSP0 MSR.
+	 *
+	 * This behavior is consistent with the current setup in
+	 * vmx_recalc_msr_intercepts(), so no change is needed to the interception
+	 * logic for MSR_IA32_PL0_SSP.
+	 */
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, intercept);
+}
+
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	bool intercept;
@@ -4194,6 +4239,8 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
 	}
 
+	vmx_set_intercept_for_fred_msr(vcpu);
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.51.0


