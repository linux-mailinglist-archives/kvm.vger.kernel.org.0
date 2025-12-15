Return-Path: <kvm+bounces-66025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91840CBFA35
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE034302283E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6890133CE88;
	Mon, 15 Dec 2025 19:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B3/Ci1VQ"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E994333508B;
	Mon, 15 Dec 2025 19:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826990; cv=none; b=XcCdPgtLHrMSizgOylaO0Ckvw1VPS+SkrvCVhHWH50aCgU+w4tNh5FFL+dOmInXTgTi0f+Cq/q99k0uPXsfLXP9JeAPJzcuwgJKPCyZelbJNdX3NgYa+uYImHqDJLnAbCkUcUZeM13iwqek5dMsVwsDM5qoAB2LMjAcCSpasKa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826990; c=relaxed/simple;
	bh=UOOFjKUiRVJF+3Zny1BE5+alClzFDyUygp6XzhYBgfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmyH/P45S/YpCIU4zZhKBSJN50f4iMD8tNQ3W2rNwaIyVXPNddTYT5KTHXhLThYOcyoQyU8yU9rQRJa4xFTix3f8iettcjzh7sXnal/ulS4x4prUDo3Ql16QSIXZeHYEZy6ojJDj4KnKHU0eavoLek8IO46z+Y9jqsJVwRBrX/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B3/Ci1VQ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765826982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2w3PcSuTySue98ugHf9Cvyx7R7WZ7jBJr+z7GT+HOes=;
	b=B3/Ci1VQbJAk+A/p2+Tc1NEPnel/X/qpMenyuxJSDZYzTfYvB/P1QnfBT5eRMRLuGFyVXi
	C4Y3g28MHC2aT0J2GbY4BwqFSrDBDyGzwpODH8kqmlWCzzHZ5ujbs0ZpwF38QZWtr/lMeR
	x6t46qMvjhIhXZN7yCEz0zcKmfDUy5U=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 19/26] KVM: nSVM: Add missing consistency check for event_inj
Date: Mon, 15 Dec 2025 19:27:14 +0000
Message-ID: <20251215192722.3654335-21-yosry.ahmed@linux.dev>
In-Reply-To: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
References: <20251215192722.3654335-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM Volume #2, 15.20 (24593—Rev. 3.42—March 2024):

  VMRUN exits with VMEXIT_INVALID error code if either:
  • Reserved values of TYPE have been specified, or
  • TYPE = 3 (exception) has been specified with a vector that does not
    correspond to an exception (this includes vector 2, which is an NMI,
    not an exception).

Add the missing consistency checks to KVM. For the second point, inject
VMEXIT_INVALID if the vector is anything but the vectors defined by the
APM for exceptions. Reserved vectors are also considered invalid, which
matches the HW behavior. Vector 9 (i.e. #CSO) is considered invalid
because it is reserved on modern CPUs, and according to LLMs no CPUs
exist supporting SVM and producing #CSOs.

Defined exceptions could be different between virtual CPUs as new CPUs
define new vectors. In a best effort to dynamically define the valid
vectors, make all currently defined vectors as valid except those
obviously tied to a CPU feature: SHSTK -> #CP and SEV-ES -> #VC. As new
vectors are defined, they can similarly be tied to corresponding CPU
features.

Invalid vectors on specific (e.g. old) CPUs that are missed by KVM
should be rejected by HW anyway.

Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/nested.c | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 47d4316b126d..229903e0ad40 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -326,6 +326,54 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
 	    kvm_vcpu_is_legal_gpa(vcpu, addr + size - 1);
 }
 
+static bool nested_svm_event_inj_valid_exept(struct kvm_vcpu *vcpu, u8 vector)
+{
+	/*
+	 * Vectors that do not correspond to a defined exception are invalid
+	 * (including #NMI and reserved vectors). In a best effort to define
+	 * valid exceptions based on the virtual CPU, make all exceptions always
+	 * valid except those obviously tied to a CPU feature.
+	 */
+	switch (vector) {
+	case DE_VECTOR: case DB_VECTOR: case BP_VECTOR: case OF_VECTOR:
+	case BR_VECTOR: case UD_VECTOR: case NM_VECTOR: case DF_VECTOR:
+	case TS_VECTOR: case NP_VECTOR: case SS_VECTOR: case GP_VECTOR:
+	case PF_VECTOR: case MF_VECTOR: case AC_VECTOR: case MC_VECTOR:
+	case XM_VECTOR: case HV_VECTOR: case SX_VECTOR:
+		return true;
+	case CP_VECTOR:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
+	case VC_VECTOR:
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SEV_ES);
+	}
+	return false;
+}
+
+/*
+ * According to the APM, VMRUN exits with SVM_EXIT_ERR if SVM_EVTINJ_VALID is
+ * set and:
+ * - The type of event_inj is not one of the defined values.
+ * - The type is SVM_EVTINJ_TYPE_EXEPT, but the vector is not a valid exception.
+ */
+static bool nested_svm_check_event_inj(struct kvm_vcpu *vcpu, u32 event_inj)
+{
+	u32 type = event_inj & SVM_EVTINJ_TYPE_MASK;
+	u8 vector = event_inj & SVM_EVTINJ_VEC_MASK;
+
+	if (!(event_inj & SVM_EVTINJ_VALID))
+		return true;
+
+	if (type != SVM_EVTINJ_TYPE_INTR && type != SVM_EVTINJ_TYPE_NMI &&
+	    type != SVM_EVTINJ_TYPE_EXEPT && type != SVM_EVTINJ_TYPE_SOFT)
+		return false;
+
+	if (type == SVM_EVTINJ_TYPE_EXEPT &&
+	    !nested_svm_event_inj_valid_exept(vcpu, vector))
+		return false;
+
+	return true;
+}
+
 static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 				       struct vmcb_ctrl_area_cached *control,
 				       unsigned long l1_cr0)
@@ -355,6 +403,9 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (CC(!nested_svm_check_event_inj(vcpu, control->event_inj)))
+		return false;
+
 	return true;
 }
 
-- 
2.52.0.239.gd5f0c6e74e-goog


