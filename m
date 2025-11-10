Return-Path: <kvm+bounces-62658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4420C49C39
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 00:32:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74D40188EA17
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 23:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059873054D7;
	Mon, 10 Nov 2025 23:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BwWIMQVa"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9140343D72
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 23:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817248; cv=none; b=EJPOpMXhC63Yu/ehJJqLyAES4Fd1VrlTEv3D/G8yTEHYqC3vT/cOWQ0nSrCffgsmG1jUkSJCgmpJufKDeMwndj6PYAeIl+vGYPREMsIGwJEq0c+MqHoI/zn2qiyE3vbf9f+NZewNV2EcVn6ElZwvPs13NPvZu0xSpOzegE3v6rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817248; c=relaxed/simple;
	bh=1nnldSyEvUMxdV3DKPZB9q5uBddTFGvYWQ+A5Gk4ElM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvF52Au+APVAkBR6QVEcnpdkIi2M433oSHLComojLPpH0taNHMkVqm7ygJd/1wPD9Aq2sQLjFxYE9WMNzhhxw4xmPchUTe5glOlgjg6brTotbj+kj8qOwkDv7Xk1OkV9VEloI5GEa1yV+yKnfmyVJfy9I4LFvWUYVvVVmtL6DCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BwWIMQVa; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762817245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vRe2/SJRKLIb78m7r5C5J3c6BhgOIpUIxQ+bEHV9RQ=;
	b=BwWIMQVaAl13BoMv9/NJv+GhfuwUnn53OtluxqiPKy/xZVYaz+kcjuibSOhBmIewv4ha/6
	ePzp2J1uFwPxYgauZZB0McSZofHSDHBpOFy3mSs/5Gq+U/qPXEr2yq6oUyOw3s/cufKUxG
	NNC4GbQlmwkD9yqNTZjTg5HAWC9RTGw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Kevin Cheng <chengkev@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 14/14] x86/svm: Rename VMCB fields to match KVM
Date: Mon, 10 Nov 2025 23:26:42 +0000
Message-ID: <20251110232642.633672-15-yosry.ahmed@linux.dev>
In-Reply-To: <20251110232642.633672-1-yosry.ahmed@linux.dev>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Rename nested_ctl and virt_ext to misc_ctl and misc_ctl2, respectively,
to match new names in KVM code.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 x86/svm.c       |  2 +-
 x86/svm.h       |  6 +++---
 x86/svm_tests.c | 12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index de9eb19443caa..c40ef154bcacd 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -200,7 +200,7 @@ void vmcb_ident(struct vmcb *vmcb)
 	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
 
 	if (npt_supported()) {
-		ctrl->nested_ctl = 1;
+		ctrl->misc_ctl = 1;
 		ctrl->nested_cr3 = (u64)pml4e;
 		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
diff --git a/x86/svm.h b/x86/svm.h
index 264583a6547ef..00d28199f65f5 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -94,12 +94,12 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 exit_info_2;
 	u32 exit_int_info;
 	u32 exit_int_info_err;
-	u64 nested_ctl;
+	u64 misc_ctl;
 	u8 reserved_4[16];
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -370,7 +370,7 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define MSR_BITMAP_SIZE 8192
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
+#define SVM_MISC_CTL2_LBR_CTL_ENABLE BIT_ULL(0)
 
 struct svm_test {
 	const char *name;
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 47a2edfbb6c9b..49b5906965b7e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -3139,7 +3139,7 @@ static void svm_lbrv_test1(void)
 	u64 from_ip, to_ip;
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
-	vmcb->control.virt_ext = 0;
+	vmcb->control.misc_ctl2 = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch1);
@@ -3160,7 +3160,7 @@ static void svm_lbrv_test2(void)
 	u64 from_ip, to_ip;
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
-	vmcb->control.virt_ext = 0;
+	vmcb->control.misc_ctl2 = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch2);
@@ -3185,7 +3185,7 @@ static void svm_lbrv_test3(void)
 	u64 from_ip, to_ip;
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest3);
-	vmcb->control.virt_ext = 0;
+	vmcb->control.misc_ctl2 = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch5);
@@ -3214,7 +3214,7 @@ static void svm_lbrv_nested_test1(void)
 	}
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest1);
-	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vmcb->control.misc_ctl2 = SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
@@ -3244,7 +3244,7 @@ static void svm_lbrv_nested_test2(void)
 	}
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest2);
-	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vmcb->control.misc_ctl2 = SVM_MISC_CTL2_LBR_CTL_ENABLE;
 
 	vmcb->save.dbgctl = 0;
 	vmcb->save.br_from = (u64)&host_branch2_from;
@@ -3278,7 +3278,7 @@ static void svm_lbrv_nested_test3(void)
 	}
 
 	svm_setup_vmrun((u64)svm_lbrv_test_guest3);
-	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vmcb->control.misc_ctl2 = SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	vmcb->save.dbgctl = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
-- 
2.51.2.1041.gc1ab5b90ca-goog


