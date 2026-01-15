Return-Path: <kvm+bounces-68130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 44DDAD21FC0
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:18:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0FAEA300FBF1
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB442D8773;
	Thu, 15 Jan 2026 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FPxphtO3"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C40264A65;
	Thu, 15 Jan 2026 01:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768439647; cv=none; b=od2gujJ9H7DO5K03Wd/X7DTzDANIZ1JyHbLBM4Yh9C3FvkBxcnMTI0UCIomP5LqyGXuhQ4Zt/Spc6wEFUVKJirQDUE4NJsjI1xQ+UANCcoDVRyiCE77P9o27lFUSBIpRyxcQULisOaSPffjDFKLkr9AXvC5pEIyeAm0QcetMgXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768439647; c=relaxed/simple;
	bh=lCwWYrC+i/WlW0FzLo8Y3vpJnW3WvFax7tAQm04Kw6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O6+WoltSvjVc7l9VTb2r0gfzqREAsPsvsgkYrMV8gBWnb3SDtDwbKDxpAMQCRNnK/qUogLx7w3IqJHIT8mQJ66wYr/Hp8/p3GIa8NUKN4ipD/ywLTABUDXT8oGcul5Pj4tx7mXIvu6oHuDTGdmq0/w8e6Ob+DdfNLOPSwYu+geg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FPxphtO3; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768439641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STHpibAtHQzZNIIE51mSVp+HkDDjwfWOOM+rEzu4sw8=;
	b=FPxphtO3yej0lCJwlU+g+l42a2h+GLF27VJXEpUFDUH8qTSDZ8hUCTyiq5PfWBZ0ArOKiu
	hcL+maaH3xQjTJR7aBfXH69E5UxIRwM6sZqfPa1ByqZHlaVhag5NBG5Iw/FFlJFAXErt8+
	JnjlY+/4LQj9lxJiBiSoQFQkH8z6sFk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 19/26] KVM: nSVM: Add missing consistency check for event_inj
Date: Thu, 15 Jan 2026 01:13:05 +0000
Message-ID: <20260115011312.3675857-20-yosry.ahmed@linux.dev>
In-Reply-To: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
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
index d8c79b3ea55e..79db1e1c8b2a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -342,6 +342,54 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
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
@@ -371,6 +419,9 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
+	if (CC(!nested_svm_check_event_inj(vcpu, control->event_inj)))
+		return false;
+
 	return true;
 }
 
-- 
2.52.0.457.g6b5491de43-goog


