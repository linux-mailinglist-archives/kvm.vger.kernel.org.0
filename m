Return-Path: <kvm+bounces-61113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E5CC0B27B
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 21:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2616B3B7251
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 20:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0691E301705;
	Sun, 26 Oct 2025 20:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="l9/7Mb6b"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581C92FE56D;
	Sun, 26 Oct 2025 20:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761510032; cv=none; b=Rx101kaj0IVV+2z7a7DBAJCu4Eno5ihid/7CpGP5oFcx8aQ/x3zL8Vk4+wT/C88xOPa9MDa4NuD656hmkyceJxHPLyfnOXXm9eJtGN4Oo2X0tlIrZcyxqXERLEOfBKn0Q+Mw7SRX2PbyaCKZRTdy5QEZpI7Uq+9Csm19niTe4tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761510032; c=relaxed/simple;
	bh=fk/q/5Z5O+Th2PQI5mUXkbu6h+x7Mb9S6XbFKt1lQJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7OhQKfEK1YMqs2D8M9a5NIhUbuqLPYel/BE37W660Vj072ipLP2gn1lYr9uHXD5ZZzTBbD/ub/Yg0GyJvl5/AD6Alefy0SYsQi7dJiEkwzmt5GMzE/7p9hrxOZ5GmxtgvMNqo4zX33p2cXeJV/VR1AZBDUI694hthJAr1qQE8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=l9/7Mb6b; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QKJBkP505258
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 13:19:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QKJBkP505258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761509967;
	bh=muIIDzX0rabxn3SyHEwL2i0xyjzvxD1OyAad8RDcW3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9/7Mb6b7RARa0sa+JzdMgXyhDpMw6opAsEJoFROrSMj+Len6nEUj6cSkIfb3Afg0
	 WxrfGmOEJ4+SiTQwOCGT6o7/SU/incytNWzIyDNu6UN71FvTuui+S81NAdcyzEBrWC
	 m5V/yB/69H5H/lCyr+Sflt7Cqux6C9G09UzsUIFCtRBI6JAwVN5QDasIGf6yQGHmMR
	 O2dOz71tUUEYZltOJ1F2eGwe/XDD4JzxV9Tz5ecttymscAdJWDlzMwrNc8ZcRHTdqB
	 3P7Y9tQZpkfOfkTBjzchQqWMn/eFEU0/QLGQPMtYIovuf9r3RgSkJ5FfWfys+vBJ5P
	 EHo31yPDSOYrA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org, sohil.mehta@intel.com
Subject: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
Date: Sun, 26 Oct 2025 13:18:56 -0700
Message-ID: <20251026201911.505204-9-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026201911.505204-1-xin@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
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
index c8b5359123bf..ef9765779884 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4146,6 +4146,51 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
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
 static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 {
 	bool intercept;
@@ -4212,6 +4257,8 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
 	}
 
+	vmx_set_intercept_for_fred_msr(vcpu);
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.51.0


