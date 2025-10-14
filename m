Return-Path: <kvm+bounces-59979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C963BD6F6B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 03:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9B8AC4F9BF4
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E1D301477;
	Tue, 14 Oct 2025 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JJKWCIge"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328B2FFDD0;
	Tue, 14 Oct 2025 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760404278; cv=none; b=ZGQnne+roFvIzgNt0mR9yndlae/bcNIUl7jveoTeXSPR0EAoOWj1uBYAj0uMBwa1Hf9ZIxfWfUZJ8yWpDN6mq56lIw1cjL6RZiaakZ5aGUt0gzHZ8wQ52uwfWx2wogMVbzpPyvSUTwFr7D72BbIDwGZNll28O6nfPj4u6Nuktes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760404278; c=relaxed/simple;
	bh=GcRijnzvckGbUDGuT4MDmTyIn9bwMINfKvsj5rIbQ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DohrhF8le1/5WUyFYuYQNJzVO05aYggbD95EuoDOh2LSlhGkZEHb9PpzHTeLEvI218UUpU+HuEN2cU54mCnuTYR3djlclSkhwEzaimtDMGTw73VTyhdLYOlu6XNxDM9xx0FJTei+s5FUGEw9RBik7swTZvCNHlMJETPJLo2S330=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JJKWCIge; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59E19p1U1568441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 13 Oct 2025 18:10:01 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59E19p1U1568441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025092201; t=1760404202;
	bh=XuqUC0FWC/Xpn0I+r1FlsMommUaVM1ZgPK7l8B+MsSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJKWCIgeUFlZlHvQxLW7I6khbicj62YVfvzL6mDEyWL0FqAhU5q6VXXNzBX4adxLk
	 JMb8fo6aaWgXwHiC3QFzdk5mKrw+K39XcWQBbiFyiIauI60SNRRjKYXBigfdsT7wp5
	 Lc9dxhsOTXziRjrBLKf+r52ywQu3/GPL9diS2fc6Xga6QT7NYlqU0P25mi0jtX4W4p
	 JLr+znaTXF852QNpIrggwudv7s8hcxeUzHYX6mbP1M3p6Ukcl3HP2r8ldOJnz6Mw3Y
	 nL4v00k6kRxNRyHnRWtRDOn0yjqMVyF8XPZwGvZsJD2uPjMezJJGXhOS7vtkb4pcL7
	 WrSvNZQHIXmjw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v8 07/21] KVM: VMX: Set FRED MSR intercepts
Date: Mon, 13 Oct 2025 18:09:36 -0700
Message-ID: <20251014010950.1568389-8-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251014010950.1568389-1-xin@zytor.com>
References: <20251014010950.1568389-1-xin@zytor.com>
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
index 07e75c134c32..cced21832ee6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4127,6 +4127,51 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
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
@@ -4193,6 +4238,8 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
 	}
 
+	vmx_set_intercept_for_fred_msr(vcpu);
+
 	/*
 	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
 	 * filtered by userspace.
-- 
2.51.0


