Return-Path: <kvm+bounces-53291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4CFB0F9BA
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 19:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05EBD567538
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C1923E25A;
	Wed, 23 Jul 2025 17:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="G7i/Eh4H"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C0E239E76;
	Wed, 23 Jul 2025 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753293266; cv=none; b=W3+GKBChJggZDZkPNoKIh7Lov4Y1X+KVuWUReU4t0Z0Rw0cvodr+GrCZ0jSb1+S5ObNqVZA1tBbx+oRd6T1Nx5L0XIlk5om6RY8mJxqup/oEtL/X/DNAUJUN62PkaCwrehN/3dWawBGwvBob2aUMYhTnNU4lxiz4LCdOs2Ot+Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753293266; c=relaxed/simple;
	bh=vAqHRHWQXZ7ZM5XEy0qCffELvyIz8o5oWBCIEU4gYG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M33LSyiXS98GlZzcxmNEBaOS2ZfmTJ7JuWlWPPDMAcJdmsSenjEdeMqlBFaM1/5qdEdrxuJrHlX7I8XfVXDf4hb8IFnIEQbOmNSvslChGe8ltZofXRpnDQZ4twOqMXHomqBOZUIVG51d6yJeI13eAW1Ij7fsOZr2zeIRZCCnaH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=G7i/Eh4H; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56NHrfxv1284522
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 23 Jul 2025 10:53:52 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56NHrfxv1284522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753293232;
	bh=WgbmsEpI3obK2UgbjujDyGoEWsCZP0mLrCSQll4/LVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7i/Eh4H3/l+y20QSINQig1hO++x1PbVlyHpWxpriJe9YsjbS0jKYytAA2ZRaNKRB
	 tMGXhtfoiq4VRNPygiq1H3vILSxY7tbhDIsihZf5urcH2n3TuAb2EVcSO2ov5IFDWh
	 /dpFc9xqjEB4p7KG+1YSi78sdLl2wglnaMGboTkfalQ+52iYPDRYr2SCIO8Rz9vXHQ
	 63a5YU63C+QOlvRViMB4I+JGt7ktaUlnfu41wVsw7E7ltBhLQHosVsDlnj/Q1vVUOR
	 6iSM5bzy+3t5hpJSFy6pLfpMkJev6Evcnxhs/Wnw1AOtEz1rSpVyGGk4+HJeu6iyE8
	 62hhD0ccSANsA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v5 07/23] KVM: VMX: Set FRED MSR intercepts
Date: Wed, 23 Jul 2025 10:53:25 -0700
Message-ID: <20250723175341.1284463-8-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723175341.1284463-1-xin@zytor.com>
References: <20250723175341.1284463-1-xin@zytor.com>
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
* Use 'set' instead of 'flag' as the variable name to indicate
  whether MSR interception should be enabled (Sean).
* Add TB from Xuelian Guo.
---
 arch/x86/kvm/vmx/vmx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 58017bdf2ff0..4cdc2a0c1465 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4096,6 +4096,37 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
+{
+	bool set = !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+		return;
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, set);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, set);
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
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, set);
+}
+
 void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	if (!cpu_has_vmx_msr_bitmap())
@@ -4143,6 +4174,8 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	vmx_set_intercept_for_fred_msr(vcpu);
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.50.1


