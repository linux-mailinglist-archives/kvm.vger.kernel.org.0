Return-Path: <kvm+bounces-27742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 563CF98B371
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04F131F24F07
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283001C1ACC;
	Tue,  1 Oct 2024 05:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="phlplVaG"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9E1BBBC9;
	Tue,  1 Oct 2024 05:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758941; cv=none; b=VjWoInlTX4SU60eOirtP5hNVUCOsaeRhg+gwjW6hyH+TNx7EQmy0pLoc0N05E8XlVgco60A1dztTSUAg2FLRlEdlq8Wh9HhsW0MpoUBGo5mNQFBj4L6Q5UfIOFbMIIw6agR79BalQID3KLrUPM2AYrAhti8LfwrReclXZcOi/wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758941; c=relaxed/simple;
	bh=XHFnI85DETCTZUsMiaMjTMhzUM8tB5OPWcBH8WtEpB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLCkNhQ8JFc9XQ6xWjWAzKQHECI9+OecL/+0pcIMy9XoX1LnmTI2va0xlp8MyT306cN2eyotDvwoDW51lFKJIffPjn2jh1dHPRn1exrVtGk+lzMsljcvfP0Pi4VOM2QDL71WMMbKbOgBH1V18axyVyuLri9WeYeHen+jUIiyr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=phlplVaG; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7Z3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7Z3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758886;
	bh=SjNhSZbcKGusmLjwXANGU7MqZ8m12LMeSX+punktfiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phlplVaGiCSI5D3kXFxsiMtEGU9zI3UNif41GiNqCtYU7U2Mkaf8M3Eba2v9+Kvx+
	 dfF6WhOz3CH7s652NFXR3/evZNy3BCcDkiPUu+juMC6dGwD9NbD8izYzrgGzFqP2El
	 69KQaiplOhd4VW02YZrKT8znZC3ev6ZAnpaiNaJBbODdUnaHqsZS8ixNFwu4W0xXFo
	 ajoEqkQBHZpSh85iGWq63lAUpoP3qcKX4wJkQbHp7D3/jtV3ckcXykgz7o3Bah5PtU
	 /5jFXDGeYHN1n1kYhYu3gJgEidSYpcn+b8lA2HWK3yfFrTSnKahwcfuFp/FfXib37N
	 u745axsU1PUjg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 10/27] KVM: VMX: Set FRED MSR interception
Date: Mon, 30 Sep 2024 22:00:53 -0700
Message-ID: <20241001050110.3643764-11-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
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
MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to be
passthrough, because they all have a pair of corresponding host and
guest VMCS fields.

Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 are dedicated for user
level event delivery only, IOW they are NOT used in any kernel event
delivery and the execution of ERETS.  Thus KVM can run safely with
guest values in the 2 MSRs.  As a result, save and restore of their
guest values are postponed until vCPU context switching and their host
values are restored on returning to userspace.

Save/restore of MSR_IA32_FRED_RSP0 is done in the next patch.

Note, as MSR_IA32_FRED_SSP0 is an alias of MSR_IA32_PL0_SSP, its save
and restore is done through the CET supervisor context management.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 28cf89c97bda..c10c955722a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -176,6 +176,16 @@ static u32 vmx_possible_passthrough_msrs[] = {
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
@@ -7880,6 +7890,28 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
+{
+	bool flag = !guest_can_use(vcpu, X86_FEATURE_FRED);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, flag);
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
+	 * flag = !(CET.SUPERVISOR_SHADOW_STACK || FRED)
+	 *
+	 * A possible optimization is to intercept SSPs when FRED && !CET.SUPERVISOR_SHADOW_STACK.
+	 */
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP0, MSR_TYPE_RW, flag);
+}
+
 void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7957,6 +7989,8 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_set_intercept_for_fred_msr(vcpu);
 }
 
 static __init u64 vmx_get_perf_capabilities(void)
-- 
2.46.2


