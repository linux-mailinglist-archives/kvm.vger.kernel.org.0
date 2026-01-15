Return-Path: <kvm+bounces-68117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EAAC5D21F8F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23E1B30B7175
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9196253F13;
	Thu, 15 Jan 2026 01:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a2ZZyLX0"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D2B23B63C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439625; cv=none; b=F/D4QdQgV/20sfBAm/h/bN9PH/NEEeLTkVvwuNHsPQD+h8wRBdcL3YLnPtL+5wu4RS7FBWSdiDRAxAF0XZ4LXB6WQCVrBhzfCO8bfLBnw2xs3KbZVJMswt6vXESWDp+KhuDmWLffa+QpsLqJpzeiQX/9Z6lG1O/LlzZVRVf5jeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439625; c=relaxed/simple;
	bh=uQPLXjFDg6ZFEhd8vy7B1DGkEFfDiXAQ0XwqZPVm1rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6nXmmWXIPtBquCrxj74qsz8hBqA6hJe59PeH+YsK0Lzm4qDhV9JRk1QIJn+v8y2LtbKPewaqqnBP96MN4lUIuvOEIDOv6a5WaHbeuwCgiqUNj/hjH0jOxN9Qy7ExsecsDA/UPUhZeYSFcDpHNQ6dP6w6xTAL81foJGSCUOp+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a2ZZyLX0; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7LxR8DM4ndhbBh+39vPuUgm/qdJCgyvaLXfvcbZYjw=;
	b=a2ZZyLX0JpogKYP5a5MaErttjVYYFrzCbqO8ZvMDlRRDvnOBbWhROAQNyUEgZejonqWITv
	LEpRMJIpEp/dx9kC/sfqSev0dfm8aSXYUJzhPAGk2HTvJSi/yWKhp4rb365X3ao/ns+DLe
	PTNXVbx4xk6EGapkNYYhC9RxjZSDf2U=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v4 02/26] KVM: SVM: Add missing save/restore handling of LBR MSRs
Date: Thu, 15 Jan 2026 01:12:48 +0000
Message-ID: <20260115011312.3675857-3-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
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
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c |  3 +++
 arch/x86/kvm/svm/svm.c    | 20 ++++++++++++++++++++
 arch/x86/kvm/x86.c        |  3 +++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 58f843681a71..03a2c4390676 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1106,6 +1106,9 @@ void svm_copy_vmrun_state(struct vmcb_save_area *to_save,
 		to_save->isst_addr = from_save->isst_addr;
 		to_save->ssp = from_save->ssp;
 	}
+
+	if (lbrv)
+		svm_copy_lbrs(to_save, from_save);
 }
 
 void svm_copy_vmloadsave_state(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a387b52032cd..c6ed59e5f0b8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3065,6 +3065,26 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
index 3d4e07f9cff5..9c3099e76f3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -349,6 +349,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_U_CET, MSR_IA32_S_CET,
 	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
 	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB,
+	MSR_IA32_DEBUGCTLMSR,
+	MSR_IA32_LASTBRANCHFROMIP, MSR_IA32_LASTBRANCHTOIP,
+	MSR_IA32_LASTINTFROMIP, MSR_IA32_LASTINTTOIP,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.52.0.457.g6b5491de43-goog


