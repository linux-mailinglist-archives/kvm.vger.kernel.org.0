Return-Path: <kvm+bounces-42196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0AFBA74F06
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 18:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1429C176837
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 17:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A854C1E51FC;
	Fri, 28 Mar 2025 17:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="cTnqEBB/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4451DB15C;
	Fri, 28 Mar 2025 17:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743181995; cv=none; b=C/CdaPCo6onZbfiCP7eaSxscgSX/4Lms2e/PS/JPZVSxHwzzjnc+cXIzbBFt25eoIUjc8B2mOGM+A7tsP4aaMzi02ADOw/8jf/Zk+h9E+qPj6KRXSuNnOpotz72XXjbY+PQ8N/pPgS9hQ4EwtfRJZjI4yGp9DAuwBDp/nHKLTcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743181995; c=relaxed/simple;
	bh=EhZQkEO8i1deIQ7W9kN9XlPhwqOssT6nAuxmAs5jXz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQmXL0LfuCSPdaKdiDIBK4bY3Ypg+ToN6p2olGvVzubtfnPP7OS7LnF3WccYw/9RmclH81oNVOiST8H5EoALU36dSgNBMOes45yVVlCNvFBh8rPA8mGf2r6A/QkHJhYmcq/26ZHtd2NYYrwavej5dQVxVso75YlF9QnylbVI1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=cTnqEBB/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52SHC6vc2029344
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 28 Mar 2025 10:12:19 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52SHC6vc2029344
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743181939;
	bh=o2J7w3PKRvGcuJDf1co0d+/I22ZZbd6QrLY11S4WAVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTnqEBB/BJah7A89aB4mgOBhlXinldTz7OdPUuc0intRY/Oq0VWKBJUnUKx2z+TV/
	 B18nn8xnGyHrGIvQuYkLteU/gK5NlsGGVcK5ug6P3ssN2Hp2MnqbASrkKDMJy7gSt5
	 l0ehtRUj27sb3WLGvWx6wAfFrNY7WyZbRwSOzmSk0FUquh+aGIijDkuoswb6P9ctk2
	 5juRvZV91InP+zZfAWWU7X+ma/P8N4Ft0GpKGPQlN1X0QiOLzkcFUN0db/kjryubzC
	 xYrTyrV8fuN1Me4TVwF1dQZmiCTOrHx2g2Pn+YFIoeFbECjbQF6yX892xSUhUWGfl7
	 0w1dx4AfZct0Q==
From: "Xin Li (Intel)" <xin@zytor.com>
To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        andrew.cooper3@citrix.com, luto@kernel.org, peterz@infradead.org,
        chao.gao@intel.com, xin3.li@intel.com
Subject: [PATCH v4 06/19] KVM: VMX: Set FRED MSR interception
Date: Fri, 28 Mar 2025 10:11:52 -0700
Message-ID: <20250328171205.2029296-7-xin@zytor.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250328171205.2029296-1-xin@zytor.com>
References: <20250328171205.2029296-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Add FRED MSRs to the VMX passthrough MSR list and set FRED MSRs
interception.

8 FRED MSRs, i.e., MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to
be passthrough, because they all have a pair of corresponding host
and guest VMCS fields.

Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 are dedicated for
userspace event delivery only, IOW they are NOT used in any kernel
event delivery and the execution of ERETS.  Thus KVM can run safely
with guest values in the 2 MSRs.  As a result, save and restore of
their guest values are deferred until vCPU context switch and their
host values are restored upon host returning to userspace.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 40 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ac6aa2d091c3..236fe5428a74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -176,6 +176,16 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_FS_BASE,
 	MSR_GS_BASE,
 	MSR_KERNEL_GS_BASE,
+	MSR_IA32_FRED_RSP0,
+	MSR_IA32_FRED_RSP1,
+	MSR_IA32_FRED_RSP2,
+	MSR_IA32_FRED_RSP3,
+	MSR_IA32_FRED_STKLVLS,
+	MSR_IA32_FRED_SSP1,
+	MSR_IA32_FRED_SSP2,
+	MSR_IA32_FRED_SSP3,
+	MSR_IA32_FRED_CONFIG,
+	MSR_IA32_FRED_SSP0,		/* Should be added through CET */
 	MSR_IA32_XFD,
 	MSR_IA32_XFD_ERR,
 #endif
@@ -7935,6 +7945,34 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
+{
+	bool flag = !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, flag);
+
+	/*
+	 * IA32_FRED_RSP0 and IA32_PL0_SSP (a.k.a. IA32_FRED_SSP0) are only used
+	 * for delivering events when running userspace, while KVM always runs in
+	 * kernel mode (the CPL is always 0 after any VM exit), thus KVM can run
+	 * safely with guest IA32_FRED_RSP0 and IA32_PL0_SSP.
+	 *
+	 * As a result, no need to intercept IA32_FRED_RSP0 and IA32_PL0_SSP.
+	 *
+	 * Note, save and restore of IA32_PL0_SSP belong to CET supervisor context
+	 * management no matter whether FRED is enabled or not.  So leave its
+	 * state management to CET code.
+	 */
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, flag);
+}
+
 void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -8007,6 +8045,8 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_set_intercept_for_fred_msr(vcpu);
 }
 
 static __init u64 vmx_get_perf_capabilities(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d53904db5d1a..f48791cf6aa6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,7 +356,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	26
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.48.1


