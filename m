Return-Path: <kvm+bounces-62375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 142F1C42283
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AFB4F4F5AD0
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4662C234C;
	Sat,  8 Nov 2025 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ae5ChuCp"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B8C2C11E0
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 00:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562764; cv=none; b=lYWOmMDvgiArkBQ2briKo3bJ0Pufktn41qDN8EAquBCEb7NuvPzPJV92xVCSTjyotcLkRdfPbbS66Q5kKrgDWsB45SUyD1ze777WZzZ0Uy65A5mzAmDFjtXcaK2h9x/zEvnjQBpFxvWyEc9CO65FyTYskwJnwbcoJy44JGE7ZFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562764; c=relaxed/simple;
	bh=jPnbjDzBUThVjCN4iUHlEfn/weoy+FVgHzyY9Pudk+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZydh9t2SE8ZCGgUiWBUn9S/lHM87+Pf6jdXPFz9P1N4Z+VEIQUp+bE74ib5d1gmXREbySJNN6eVS4QQJ4FZNkLKOPTQiZrkmWxRowVPtMmEndOmrK4binI7T8pGrbJr7RvtmfKsC2Xkunj2CYnUOtF++jJFWlSxHx7wLqzBKF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ae5ChuCp; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762562759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uQRlG+qWAMXnVf3h5BiO0QmP4IJTVvnw5JQLBnE7avU=;
	b=ae5ChuCp4g34nFzXrgAJMYo9pwAptFurH58Uzz+9m7n/uCLgq3qGs+r69ARr1icAUt7Qyd
	lMZn36VAqarC8zTWX6C+k3UGU/Fa0/fx96zLCH1SHpy796bPX8lz1M3FmedsjNtbpZxrs4
	PE3pmTUXVGTPk9L/hGZZ3lwpWSwzCuI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 5/6] KVM: SVM: Add missing save/restore handling of LBR MSRs
Date: Sat,  8 Nov 2025 00:45:23 +0000
Message-ID: <20251108004524.1600006-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
References: <20251108004524.1600006-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

MSR_IA32_DEBUGCTLMSR and LBR MSRs are currently not enumerated by
KVM_GET_MSR_INDEX_LIST, and LBR MSRs cannot be set with KVM_SET_MSRS. So
save/restore is completely broken.

Fix it by adding the MSRs to msrs_to_save_base, and allowing writes to
LBR MSRs from userspace only (as they are read-only MSRs). Additionally,
to correctly restore L1's LBRs while L2 is running, make sure the LBRs
are copied from the captured VMCB01 save area in svm_copy_vmrun_state().

Fixes: 24e09cbf480a ("KVM: SVM: enable LBR virtualization")
Cc: stable@vger.kernel.org

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  3 +++
 arch/x86/kvm/svm/svm.c    | 20 ++++++++++++++++++++
 arch/x86/kvm/x86.c        |  3 +++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e7861392f2fcd..955de5d90f48e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1057,6 +1057,9 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 		to_save->isst_addr = from_save->isst_addr;
 		to_save->ssp = from_save->ssp;
 	}
+
+	if (lbrv)
+		svm_copy_lbrs(to_save, from_save);
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9eb112f0e61f0..45faf892a0431 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2988,6 +2988,26 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		svm_update_lbrv(vcpu);
 		break;
+	case MSR_IA32_LASTBRANCHFROMIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_from = data;
+		break;
+	case MSR_IA32_LASTBRANCHTOIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.br_to = data;
+		break;
+	case MSR_IA32_LASTINTFROMIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_from = data;
+		break;
+	case MSR_IA32_LASTINTTOIP:
+		if (!msr->host_initiated)
+			return 1;
+		svm->vmcb->save.last_excp_to = data;
+		break;
 	case MSR_VM_HSAVE_PA:
 		/*
 		 * Old kernels did not validate the value written to
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9c2e28028c2b5..1d36a0f782c49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -348,6 +348,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_U_CET, MSR_IA32_S_CET,
 	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
 	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP, MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP, MSR_IA32_LASTINTTOIP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.51.2.1041.gc1ab5b90ca-goog


