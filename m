Return-Path: <kvm+bounces-55419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C4DBB30955
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A53DA07867
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDCA72EBDE6;
	Thu, 21 Aug 2025 22:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ScMlz5As"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FB32E11C9;
	Thu, 21 Aug 2025 22:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815880; cv=none; b=shy/kpkEoGxhj7YHc951Ri21elRRP3bwskeU2S+qsuZhoklvCCUIA6Bg2tFoNlgVAI7/q0oV99wGSmomP+Y1f3JTl3htC36Et9PlsSZk9PxFEI0eBuxa7w9rD5lC8EDw5aYmD7qOzwGB6zBD4RCf2/WTYzgFFkrR8UyIEZAhV+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815880; c=relaxed/simple;
	bh=CcpUNIwcWELq9FQ0e3A7cvlm/ESk8tkksXQ+ElWWu28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sert8o0ZgCzMQB9JgdLPj+PeN7WKnY+GKBspFrPvwHJZMap5ZKOoT4MIcPMYLsCIvvI6/zvIa3MTXh7fCZtChNOdhsxrJrGxryIen53ZaGJB3XNF0Z3mxHJRsfz31zwb9YWApuMnlXxSWk5FkMyVbPqIJKcOYcfI3VKgrMR9mSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ScMlz5As; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOU984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:47 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOU984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815807;
	bh=cjkzdFQQCZZeage9Ohj+alYSyUTV78Z/SgMg9nbasuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ScMlz5AsrIdFnnHBOd/584LcEpe4JsEF14ZxzHP/3kKrAxZi/qA0g6ZvPXl1A8xM3
	 2Tuk/sbwQdS7c1JuSrVPNBuernMeg5ey1wtef9/jdBkUwFnbliIO7Orq9yIdDG2Dyx
	 0DcZXaLEvgRybmi56Hm4Wdl/6jNQv7TDIgCQWiCQg9kxW9Y+2kSrIC8KoCbMqfnyp8
	 GkTQyTLETL3ejdxR35Om1pJVFs/zrxvKHj4WJoQupEzQm3A9SjtssagpFgZx4yEUjO
	 HPD4/vhz3UCiPe7dNFkIPT2qQtPX70qLNU5bqfFxflHPFrYw8SrL1fT16ixmoADo4F
	 MxG1Y8ou+jtUA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 06/20] KVM: VMX: Set FRED MSR intercepts
Date: Thu, 21 Aug 2025 15:36:15 -0700
Message-ID: <20250821223630.984383-7-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

On a userspace MSR filter change, set FRED MSR intercepts.

8 FRED MSRs, i.e., MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
be passthrough, because they all have a pair of corresponding host
and guest VMCS fields.

Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 are dedicated for
userspace event delivery only, IOW they are NOT used in any kernel
event delivery and the execution of ERETS.  Thus KVM can run safely
with guest values in the two MSRs.  As a result, save and restore of
their guest values are deferred until vCPU context switch and their
host values are restored upon host returning to userspace.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Changes in v5:
* Skip execution of vmx_set_intercept_for_fred_msr() if FRED is
  not available or enabled (Sean).
* Use 'intercept' as the variable name to indicate whether MSR
  interception should be enabled (Sean).
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/vmx/vmx.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42e179f19c23..8e81230be7af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4128,6 +4128,43 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
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
+	 * designated for event delivery while executing in userspace.  Since
+	 * KVM operates exclusively in kernel mode (the CPL is always 0 after
+	 * any VM exit), KVM can safely retain and operate with the guest-defined
+	 * values for MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP.
+	 *
+	 * Therefore, interception of MSR_IA32_FRED_RSP0 and MSR_IA32_PL0_SSP
+	 * is not required.
+	 *
+	 * Note, save and restore of MSR_IA32_PL0_SSP belong to CET supervisor
+	 * context management.  However the FRED SSP MSRs, including
+	 * MSR_IA32_PL0_SSP, are supported by any processor that enumerates FRED.
+	 * If such a processor does not support CET, FRED transitions will not
+	 * use the MSRs, but the MSRs would still be accessible using MSR-access
+	 * instructions (e.g., RDMSR, WRMSR).
+	 */
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, intercept);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
+}
+
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	bool intercept;
@@ -4194,6 +4231,8 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
 	}
 
+	vmx_set_intercept_for_fred_msr(vcpu);
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.50.1


