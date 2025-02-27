Return-Path: <kvm+bounces-39475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72256A47175
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A5853A7DDB
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF85233129;
	Thu, 27 Feb 2025 01:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l+sTLXDX"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F671232384;
	Thu, 27 Feb 2025 01:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619668; cv=none; b=mV3D70Ibu6FPB4gAVNaLFlVoejZLfIPwmvVTNdMUDlOtFqr0E/03kRPn0aCtoD2yH+u485cRzwbJjuFIoyhaK9giAw8C8TJVESbPaW/7BKCbPrh4neffsjzVJksyeaTJq/+tLxCH7xhCKgfshxDfUP6GNLjLWS/Uo2WuYPTzmmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619668; c=relaxed/simple;
	bh=mIdsMYHzPWGKfQ76gyR0od074LQLBhdNIqzTXep/9HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=md0+EoaPqWW0nG4yrMOuWFuitQAXmc+K5NzQOKTspU2Wv1ZSlKjjEYfpsU0KGcq0lMfFEnSTka9sa9FGVxFkak8qY2hFpgrv3NGNntfA40HPgQmMe1DT54FWnyAN4zl2duTG5cvIesOoojebTOReIIknCSrUKJyhMxbr8Lp/lno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l+sTLXDX; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740619663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dfUQyumxQMDUJXdJGU+sofO81aPkdWCO0PVYPcYWac=;
	b=l+sTLXDX0jv/vF96NEG6CtwsLDiN/112u7a0wPuQsum56JdJSXtEas3d0xJ3Akl/F5JhjP
	5RvOtKJb5g9WVBYwI2Ixujbl2q6sx7dsOSX3DfQgzJA+lBVId0zCCJmy5fsS4WQEIubraF
	6rPPWYyQp7SmFyT7WrIWLG8LG9JxiAM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: x86@kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 5/6] KVM: nVMX: Always use IBPB to properly virtualize IBRS
Date: Thu, 27 Feb 2025 01:27:11 +0000
Message-ID: <20250227012712.3193063-6-yosry.ahmed@linux.dev>
In-Reply-To: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
References: <20250227012712.3193063-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On synthesized nested VM-exits in VMX, an IBPB is performed if IBRS is
advertised to the guest to properly provide separate prediction domains
for L1 and L2. However, this is currently conditional on
X86_FEATURE_USE_IBPB, which depends on the host spectre_v2_user
mitigation.

In short, if spectre_v2_user=no, IBRS is not virtualized correctly and
L1 becomes susceptible to attacks from L2. Fix this by performing the
IBPB regardless of X86_FEATURE_USE_IBPB.

Fixes: 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS")
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Reviewed-by: Jim Mattson <jmattson@google.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 504f328907ad4..ca18c3eec76d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5026,8 +5026,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
 	 * separate modes for L2 vs L1.
 	 */
-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-	    cpu_feature_enabled(X86_FEATURE_USE_IBPB))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
 		indirect_branch_prediction_barrier();
 
 	/* Update any VMCS fields that might have changed while L2 ran */
-- 
2.48.1.658.g4767266eb4-goog


